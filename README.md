# Sistema de Reservas de Habitaciones de Hotel

El problema de una reserva de hotel presencial es que obliga al cliente a acercarse físicamente a las instalaciones o, en su defecto, comunicarse por llamada telefónica o a través de mensajes de WhatsApp.  
Si bien estas alternativas buscan facilitar el proceso, en la práctica generan limitaciones importantes:  

- La atención depende de la disponibilidad del personal, lo que ocasiona demoras y riesgo de errores.  
- En llamadas o mensajes no siempre se garantiza una actualización inmediata de la disponibilidad.  
- Modificaciones o cancelaciones requieren contactar de nuevo al hotel, añadiendo pasos innecesarios.  
- Los pagos presenciales o transferencias manuales carecen de trazabilidad y seguridad.  

Un **sistema de reservas web** ofrece ventajas claras:
- Disponibilidad en tiempo real.  
- Confirmaciones automáticas.  
- Gestión segura de pagos en línea.  
- Posibilidad de modificar o cancelar sin depender de terceros.  
- Experiencia rápida y confiable para el usuario.  

## Tecnologías utilizadas
- **Frontend:** React + Vite  
- **Backend:** Node.js  
- **Base de datos:** PostgreSQL  
- **Infraestructura:** Docker, Terraform (AWS)

## Requisitos
- [Node.js 18+](https://nodejs.org/)  
- [Docker](https://www.docker.com/)
- [PostgreSQL](https://www.postgresql.org/)  
- [Terraform](https://developer.hashicorp.com/terraform)  

## Referencias de Terraform utilizadas

La infraestructura en AWS fue configurada siguiendo la documentación oficial de Terraform y módulos de la comunidad:

**main.tf**  
  Basado en la guía oficial del proveedor AWS:  
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs  
  https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest  

**aws_db_subnet_group.tf**  
  Referencias usadas:  
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group  
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group  
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance  

**Terraform** 
https://developer.hashicorp.com/terraform

