import pandas as pd
import os
from fastapi import FastAPI, HTTPException, Request, Body
from pydantic import BaseModel

from db_connect import *
from sql import *

class HigherSalary(BaseModel):
    salary:str

app = FastAPI()

@app.get("/ping")
def main():
    try:
        return {"status": "API is running"}
    except Exception as e:
        raise HTTPException(status_code=404, detail="API Not working")

 

@app.get("/employees")
async def get_employees_info():
    df = get_data(TASK1)
    if isinstance(df,pd.DataFrame):
        return df.to_json(orient='records')
    else:
        raise HTTPException(status_code=500,detail="Internal Error, check the connections")
    


 
@app.post("/employees/highsalary")
async def highersalaryemployee(hsalary: HigherSalary):
    global TASK2
    task2 = TASK2+str(hsalary.salary)
    df = get_data(task2)
    if isinstance(df,pd.DataFrame):
        return df.to_json(orient='records')
    else:
        raise HTTPException(status_code=500,detail="Internal Error, check the connections")

