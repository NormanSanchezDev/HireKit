create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  first_name text not null check (char_length(first_name) >= 2),
  paternal_last_name text not null check (char_length(paternal_last_name) >= 2),
  maternal_last_name text check (maternal_last_name is null or char_length(maternal_last_name) >= 2),
  birth_date date not null check (birth_date <= (current_date - interval '18 years')),
  dial_code text not null check (dial_code in ('+52', '+1')),
  phone text not null check (phone ~ '^[0-9]{10}$'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Users can read their own profile"
  on public.profiles for select
  to authenticated
  using ((select auth.uid()) = id);

create policy "Users can update their own profile"
  on public.profiles for update
  to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

create function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (
    id, first_name, paternal_last_name, maternal_last_name, birth_date, dial_code, phone
  )
  values (
    new.id,
    new.raw_user_meta_data ->> 'first_name',
    new.raw_user_meta_data ->> 'paternal_last_name',
    nullif(new.raw_user_meta_data ->> 'maternal_last_name', ''),
    (new.raw_user_meta_data ->> 'birth_date')::date,
    new.raw_user_meta_data ->> 'dial_code',
    new.raw_user_meta_data ->> 'phone'
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
