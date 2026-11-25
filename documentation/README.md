# Documentación de HireKit

Esta carpeta es el cerebro del proyecto. Describe cómo es HireKit **hoy**, no
cómo fue. Personas y agentes de IA la leen antes de cambiar código.

| Documento | Responde a |
| --- | --- |
| [app.md](app.md) | ¿Qué hace la app, para quién y en qué plataformas? ¿Qué falta? |
| [business.md](business.md) | ¿Qué reglas de negocio aplica y cómo es el dominio? |
| [architecture.md](architecture.md) | ¿Cómo se reparten las capas, los paquetes y la inyección de dependencias? |
| [routing.md](routing.md) | ¿Cómo se navega entre flujos y pantallas? |
| [design-system.md](design-system.md) | ¿Cómo se construye la interfaz con Liquid Glass? |
| [assets/](assets) | Banner y recursos gráficos de la documentación |

## Reglas de mantenimiento

1. **Cada cambio actualiza su documento en el mismo trabajo.** Si cambias una
   regla de negocio, un flujo, una capa o un componente, actualiza el documento
   que lo describe antes de dar el trabajo por terminado.
2. **Un documento que ya no representa el diseño se reemplaza, no se parcha.**
   Si las ideas de un documento dejaron de ser ciertas, bórralo y escribe uno
   nuevo desde el estado actual del código. No acumules secciones "antes/ahora".
3. **Sin documentos huérfanos.** Todo documento aparece en la tabla de arriba;
   si se elimina un documento, también su fila.
4. **El código manda.** Si el código y un documento no coinciden, corrige el
   documento o el código, nunca dejes ambos.
5. **Dependencias en cuatro lugares.** Toda dependencia nueva o eliminada se
   refleja en la tabla de dependencias del [README](../README.md), en el README
   del paquete que la usa, en [architecture.md](architecture.md) y en el
   [CHANGELOG](../CHANGELOG.md). Las librerías de terceros necesitan
   aprobación previa.
