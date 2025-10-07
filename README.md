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

**Para verificar que tu docker-compose.yml:**
1.Validar la sintaxis (sin levantar contenedores)
docker compose config
2.Probar levantar en modo detached (en segundo plano)
docker compose up -d
3.Verificar que los contenedores están corriendo
docker ps 

**Pasos para verificar que funciona Terraform**
1.Verificar que tengas Terraform instalado
terraform -v
2.Inicializar el proyecto
Desde la carpeta raíz de tu proyecto donde está el main.tf:
terraform init
3.Validar la sintaxis de los archivos Terraform
terraform validate
4.Previsualizar qué infraestructura se va a crear (plan)
terraform plan
5.Aplicar la infraestructura (ejecutar realmente)
terraform apply
**verificar manualmente si tu carpeta frontend/ es React en tu máquina:**
1.Primero asegúrate de estar en la carpeta raíz del frontend:
cd ~/Desktop/Sistema_Reserva_de_habitacones_hotel/frontend
2.Entra a la carpeta:
cd frontend
3.Lista los archivos:
ls -l
4.Abre el archivo package.json y revisa las dependencias:
cat package.json | grep react
Si se ve asi :
"react": "^18.x.x",
"react-dom": "^18.x.x",
entonces es un proyecto React.
5.Para correr el frontend, normalmente:
npm install
npm start
Para probar tu frontend en modo desarrollo:
npm run dev
**Configurar credenciales de AWS:**
aws configure
