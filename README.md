
# Proyecto de Terraform

## Implementación de la infraestructura

Contiene la información requerida para el levantamiento de la infraestructura por medio de código.

### Despliegue

Para ejecutar el archivo **main.tf** de Terraform en Amazon Web Services (AWS), sigue los pasos a continuación:

* Instala Terraform: Descarga e instala Terraform en tu máquina local siguiendo las instrucciones proporcionadas en el sitio web oficial de Terraform: https://www.terraform.io/downloads.html

* Configura las credenciales de AWS: Asegúrate de tener configuradas las credenciales de AWS en tu entorno local. Puedes hacerlo estableciendo las variables de entorno **AWS_ACCESS_KEY_ID** y **AWS_SECRET_ACCESS_KEY** con tus credenciales de AWS. También puedes utilizar perfiles de AWS si lo prefieres.

* Navega hasta el directorio que contiene el archivo main.tf utilizando la línea de comandos o la terminal.

* Inicializa el directorio de trabajo de Terraform ejecutando el siguiente comando:

```bash
  terraform init
```

Terraform te mostrará una lista de los recursos que se crearán y te pedirá confirmación para aplicar los cambios. Ingresa "yes" para continuar.

Ten en cuenta que la ejecución de terraform apply creará y modificará recursos en tu cuenta de AWS, lo cual puede generar costos. Asegúrate de entender los cambios que se realizarán antes de confirmar la aplicación.

* Una vez que Terraform haya completado la aplicación de la configuración, podrás ver los recursos creados en tu cuenta de AWS según lo definido en el archivo main.tf.

## Implementación de pruebas de la infraestructura

Aquí se estructura la prueba de la ejecución del archivo de la infraestructura, y los pasos a ejecutar son:

Para ejecutar un archivo de prueba en Terratest llamado main_test.go, sigue estos pasos:

* Asegúrate de tener Terratest y todas las dependencias necesarias instaladas en tu entorno de desarrollo.

* Abre una terminal y navega hasta el directorio que contiene el archivo main_test.go.

* Ejecuta el siguiente comando para ejecutar las pruebas:

```bash
    go test -v -timeout 30m
```

El indicador -v muestra el detalle de la salida de las pruebas, y el indicador -timeout establece el tiempo límite para la ejecución de las pruebas.

Terratest buscará automáticamente los archivos de prueba que sigan el patrón *_test.go y los ejecutará.
## Autor

- [Freddy Mauricio Tacuri Pajuña](https://github.com/fmtacuri)

