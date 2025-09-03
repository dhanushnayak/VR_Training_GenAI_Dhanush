
import requests as req
#
def test_add(a,b):
    print('Test  add method')
    return 'tested'


X = 2

TEST_A = 1
B = 2


response = req.get('http://127.0.0.1:5002/app/add/?num1=500&num2=750&num3=1000')
print(response.status_code,response.text,response)