from flask import Flask,request,Blueprint
from my_package.addition import add
from my_package.subtraction import sub
from blueprint_app import blue


app = Flask('vr')
app.register_blueprint(blue) 


@app.route('/',methods=['GET']) 
def hello_world():
    return 'Hello, World!'



@app.route('/app/add/',methods=['GET'])
def new_add():
    if request.method == "GET":
        try:
            num1 = float(request.args.get('num1',0))
            num2 = float(request.args.get('num2',0))
            result = add(num1,num2)
            return f"Added : {num1} + {num2} = {result}"
        except ValueError as e:
            return str(e.__doc__),500
        except NameError as e:
            return str(e.__doc__),204
        except Exception as e:
            return str(e.__doc__),501


@app.route('/app/sub/',methods=["POST"])
def new_sub_method():
    if request.method=="POST":
        try:
            if request.is_json:
                data = request.get_json()
                print("Data Recieved: ",data)
                if str(data['name']).isalnum():
                    num1 = float(data['num1'])
                    num2 = float(data['num2'])
                    result = sub(num1,num2)
                    return f"Subtracted : {num1} - {num2} = {result}",200
                else:
                    return "Username must be string type i.e. name must be string", 404
        except Exception as e:
            return str(e.__doc__),501


@app.route("/app/test/",methods=['GET','POST'])
def new_test():
    if request.method == "GET":
        try:
            num1 = float(request.args.get('num1',0))
            num2 = float(request.args.get('num2',0))
            result = add(num1,num2)
            return f"Added : {num1} + {num2} = {result}"
        except ValueError as e:
            return str(e.__doc__),500
        except NameError as e:
            return str(e.__doc__),204
        except Exception as e:
            return str(e.__doc__),501
       
    if request.method == "POST":
        try:
            if request.is_json:
                data = request.get_json()
                print("Data Recieved: ",data)
                if str(data['name']).isalnum():
                    num1 = float(data['num1'])
                    num2 = float(data['num2'])
                    result = sub(num1,num2)
                    return f"Subtracted : {num1} - {num2} = {result}",200
                else:
                    return "Username must be string type i.e. name must be string", 404
        except Exception as e:
            return str(e.__doc__),501


if __name__ == "__main__": 
    app.run(debug=True,port=5002)