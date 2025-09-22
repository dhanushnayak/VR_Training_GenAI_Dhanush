import sqlite3
import pandas as pd
from sqlalchemy import create_engine, text
import os
from datetime import datetime, date
from typing import List, Dict, Any, Optional


curr_path = os.path.dirname(os.path.abspath(__file__)) # current file path dirname

db_path = os.path.join(curr_path,'database/VR.db')


def connection_to_db(db_path):
    return_response = {
        "connection": 0,"cursor":0
    }
    try:
        conn = sqlite3.connect(database=db_path)
        cursor = conn.cursor()
        return_response['connection']=conn
        return_response['cursor'] = cursor
        return return_response
    except:
        return return_response
    

def read_sql_query(sql,conn):
    df = pd.read_sql(sql=sql,con=conn)
    return df

def get_data(sql):
    connecter = connection_to_db(db_path=db_path)
    if connecter['connection']!=0:
        df = read_sql_query(sql=sql,conn=connecter['connection'])
        return df
    else:
        return None


if __name__ == "__main__":
    sql = "SELECT * FROM EMPLOYEES;"
    connecter = connection_to_db(db_path=db_path)
    df=read_sql_query(sql=sql,conn=connecter['connection'])
    print(df)
    