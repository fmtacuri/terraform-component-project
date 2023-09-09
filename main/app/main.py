from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
  return "<!DOCTYPE html><html><head><title>AWS Challenge</title><h1>AWS EC2 Tag Instances:</h1></head><body>my-ecs-app-ecs-cluster-runner-0 <br/> ,my-ecs-app-ecs-cluster-runner-1 <br/> </body></html>"

if __name__ == "__main__":
    # Only for debugging while developing
    app.run(host='0.0.0.0', debug=True, port=80)

