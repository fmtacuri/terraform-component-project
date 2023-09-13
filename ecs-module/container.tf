/**************************************
*
* ECS Container configuration
*
***************************************/

/////////////////////////////////////////
// ECS Container Definition
/////////////////////////////////////////
data "template_file" "nginx_app" {
  template = file("${path.module}/templates/nginx.json")
  vars = {
    app_name       = var.nginx_app_name
    app_image      = var.ecr_app_image
    app_port       = var.nginx_app_port
    fargate_cpu    = var.nginx_fargate_cpu
    fargate_memory = var.nginx_fargate_memory
    aws_region     = var.aws_region
  }
}

/////////////////////////////////////////
// Define main.py with EC2 instance names
// Upload docker image to ECR
/////////////////////////////////////////

resource "null_resource" "instances" {
  count = var.cluster_runner_count
  triggers = {
    name = "${var.app_name}-ecs-cluster-runner-${count.index}"
  }
}

resource "null_resource" "docker" {
  provisioner "local-exec" {
    command = <<EOF
echo "from flask import Flask
app = Flask(__name__)

@app.route(\"/\")
def hello():
    html = \"\"\"
    <!DOCTYPE html>
    <html>
    <head>
        <title>AWS UPS - Tacuri Freddy</title>
        <style>
            .center-container {
                text-align: center;
            }
            .center-table {
                margin-left: auto;
                margin-right: auto;
            }
        </style>
    </head>
    <body>
        <h1 class=\"center-container\">Aws Ec2 Terraform Lab</h1>
        <table border=\"1\" class=\"center-table\">
            <tr>
                <th>Instancias</th>
            </tr>
    \"\"\"

    # Loop through trigger names and add rows to the table
    original_string = "\"" + "${join(",", null_resource.instances.*.triggers.name)}" + "\""
    new_string = original_string.replace('+', '').strip()
    elements = new_string.split(',')

    quoted_elements = ['\"' + element + '\"' for element in elements]

    # Loop through trigger names and add rows to the table
    for name in quoted_elements:
        html += f'<tr><td>{name}</td></tr>'

    html += \"\"\"
        </table>
    </body>
    </html>
    \"\"\"

    return html

if __name__ == \"__main__\":
    # Only for debugging while developing
    app.run(host='0.0.0.0', debug=True, port=80)
" > ./app/main.py;
 docker build -f Dockerfile -t ${var.docker_image_name} . ;
 docker tag ${var.docker_image_name}:latest ${var.ecr_app_image};
 docker push ${var.ecr_app_image};
EOF
  }
}

/////////////////////////////////////////
// ECS Task Definition
/////////////////////////////////////////

resource "aws_ecs_task_definition" "nginx_app" {
  family                   = "${var.app_name}-task"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.nginx_fargate_cpu
  memory                   = var.nginx_fargate_memory
  container_definitions    = data.template_file.nginx_app.rendered

  depends_on = [null_resource.docker]
}

/////////////////////////////////////////
// ECS Fargate Service Definition
/////////////////////////////////////////

resource "aws_ecs_service" "nginx_app" {
  name            = var.nginx_app_name
  cluster         = aws_ecs_cluster.aws-ecs.id
  task_definition = aws_ecs_task_definition.nginx_app.arn
  desired_count   = var.nginx_app_count
  launch_type     = "FARGATE"
  network_configuration {
    security_groups  = [aws_security_group.aws-ecs-tasks.id]
    subnets          = aws_subnet.aws-subnet.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.nginx_app.id
    container_name   = var.nginx_app_name
    container_port   = var.nginx_app_port
  }

  depends_on = [aws_alb_listener.front_end]

  tags = {
    Name = "${var.nginx_app_name}-nginx-ecs"
  }
}
