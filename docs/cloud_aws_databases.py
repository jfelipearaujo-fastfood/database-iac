from diagrams import Cluster, Diagram
from diagrams.aws.compute import EKS, Lambda
from diagrams.aws.security import SecretsManager
from diagrams.aws.management import SystemsManagerParameterStore as ParameterStore
from diagrams.aws.database import RDSPostgresqlInstance as RDS
from diagrams.aws.network import ElbNetworkLoadBalancer as NLB, APIGateway
from diagrams.aws.security import WAF
from diagrams.aws.general import Users
from diagrams.k8s.compute import Pod
from diagrams.onprem.database import Mongodb

diagram_attr = {
    "fontsize": "25",
    "bgcolor": "white",
    "pad": "0.5",
    "splines": "spline",
}

node_attr = {
    "fontsize": "20",
    "size": "6",
    "bgcolor": "white",
    "margin": "1",
    "height": "3",
    "pad": "5"
}

cluster_attr = {
    "fontsize": "20",
    "size": "5",
    "margin": "18",
    "pad": "2"
}

item_attr = {
    "fontsize": "20",
    "height": "2.2"
}

with Diagram("Cloud AWS Databases", show=False, graph_attr=diagram_attr):    
    with Cluster("AWS"):        
        products_db = Mongodb("Products")
        products_db >> SecretsManager("DB URL")

        orders_db = RDS("Orders DB")
        orders_db >> SecretsManager("DB URL")

        payments_db = RDS("Payments DB")
        payments_db >> SecretsManager("DB URL")

        productions_db = RDS("Productions DB")
        productions_db >> SecretsManager("DB URL")

        customers_db = RDS("Customers DB")
        customers_db >> SecretsManager("DB URL")

