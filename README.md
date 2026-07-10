# Guía de Generación de Imágenes (Packer) y Despliegue (Terraform)

Este proyecto utiliza **Packer** para crear Imágenes de Máquina de Amazon (AMIs) personalizadas y **Terraform** para desplegar la infraestructura necesaria en AWS.

## Requisitos Previos

- [Packer](https://www.packer.io/downloads) instalado.
- [Terraform](https://www.terraform.io/downloads) instalado.
- Configuración de credenciales de AWS (`aws configure`).
- Node.js y Angular CLI (para compilar la aplicación antes de crear las imágenes).

---

## 1. Generación de Imágenes con Packer

El proyecto consta de tres componentes principales: Backend, Frontend y Base de Datos (MongoDB). Cada uno requiere su propia AMI.

### Paso 1: Compilar las aplicaciones (Solo si es necesario)
Antes de ejecutar Packer, asegúrate de que los artefactos de la aplicación estén listos:

**Backend:**
```bash
cd app-backend
npm install
npm run build
cd ..
```

**Frontend:**
```bash
cd app-frontend
npm install
npm run build
cd ..
```

### Paso 2: Crear las imágenes con Packer
Ejecuta los siguientes comandos para validar y construir las imágenes:

#### App Backend
```bash
cd packer/app-backend
packer init app-backend.pkr.hcl
packer build app-backend.pkr.hcl
cd ../..
```

#### App Frontend
```bash
cd packer/app-frontend
packer init app-frontend.pkr.hcl
packer build app-frontend.pkr.hcl
cd ../..
```

#### Base de Datos (MongoDB)
```bash
cd packer/db-mongo
packer init db-mongo.pkr.hcl
packer build db-mongo.pkr.hcl
cd ../..
```

---

## 2. Despliegue con Terraform

Una vez creadas las AMIs, Terraform las detectará automáticamente utilizando filtros por nombre (`app-backend-*`, `app-frontend-*`, `db-mongo-*`).

### Paso 1: Configurar variables
Revisa y edita el archivo `terraform/terraform.tfvars` con los valores adecuados para tu entorno (región, CIDRs de red, credenciales de MongoDB, etc.).

### Paso 2: Inicializar y desplegar
Navega a la carpeta de Terraform y ejecuta el flujo estándar:

```bash
cd terraform
# Inicializar el directorio de trabajo y descargar proveedores
terraform init

# Generar un plan de cambios
terraform plan -var-file="terraform.tfvars" -out tfplan

# Aplicar los cambios para crear la infraestructura
terraform apply tfplan
```

### Paso 3: Verificar el despliegue
Al finalizar, Terraform mostrará los outputs configurados (como el DNS del Load Balancer). Puedes acceder a la aplicación a través de esa URL.
