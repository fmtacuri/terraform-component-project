from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    html = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>AWS UPS - Tacuri Freddy</title>
    </head>
    <body>
        <h1>Aws Ec2 Terraform Lab</h1>
        <table>
            <tr>
                <th>Instancias</th>
            </tr>
    """

    # Loop through trigger names and add rows to the table
    original_string = " + my-ecs-app-ecs-cluster-runner-0,my-ecs-app-ecs-cluster-runner-1 + "
    new_string = original_string.replace('+', '').strip()
    elements = new_string.split(',')

    quoted_elements = ['"' + element + '"' for element in elements]

    # Loop through trigger names and add rows to the table
    for name in quoted_elements:
        html += f'<tr><td>{name}</td></tr>'

    html += """
        </table>
    </body>
    </html>
    """

    return html

if __name__ == "__main__":
    # Only for debugging while developing
    app.run(host='0.0.0.0', debug=True, port=80)

