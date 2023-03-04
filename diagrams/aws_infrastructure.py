#!/usr/local/bin/python3

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.network import VPC, PrivateSubnet, RouteTable, InternetGateway
from diagrams.aws.compute import EC2

graph_attr = {
    "fontsize": "28",
    "fontname": "Helvetica",
    "style": "rounded",
    "bgcolor": "transparent"
}

major_cluster ={
    "fontsize": "24",
    "fontname": "Helvetica",
    "style": "rounded",
    "bgcolor": "transparent"
}

cluster ={
    "fontsize": "16",
    "fontname": "Helvetica",
    "style": "rounded",
    "bgcolor": "transparent"
}

with Diagram("My AWS Infrastructure Diagram", graph_attr=graph_attr, direction="TB"):

    with Cluster("VPC: my-vpc"):

        with Cluster("Application Subnets"):
            application_subnets       = PrivateSubnet("my-application-ap-northeast-1a") >> Edge() << PrivateSubnet("my-application-ap-northeast-1c") >> Edge() << PrivateSubnet("my-application-ap-northeast-1d")
            application_rtb           = RouteTable("my-application-rtb")
            postgresql_proxy_instance = EC2("Bastion Instance")

        with Cluster("Intra Subnets"):
            intra_subnets = PrivateSubnet(xlabel="my-intra-ap-northeast-1a") >> Edge() << PrivateSubnet(xlabel="my-intra-ap-northeast-1c") >> Edge() << PrivateSubnet(xlabel="my-intra-ap-northeast-1d")
            intra_rtb     = RouteTable("my-intra-rtb")

        with Cluster("Persistence Subnets"):
            persistence_subnets = PrivateSubnet(xlabel="my-persistence-ap-northeast-1a") >> Edge() << PrivateSubnet(xlabel="my-persistence-ap-northeast-1c") >> Edge() << PrivateSubnet(xlabel="my-persistence-ap-northeast-1d")
            persistence_rtb     = RouteTable("my-persistence-rtb")

        with Cluster("Public Subnets"):
            public_subnet    = PrivateSubnet(xlabel="my-public-ap-northeast-1a") >> Edge() << PrivateSubnet(xlabel="my-public-ap-northeast-1c") >> Edge() << PrivateSubnet(xlabel="my-public-ap-northeast-1d")
            public_rtb       = RouteTable("my-public-rtb")
            bastion_instance = EC2("bastion_instance")

        with Cluster("NAT Subnet"):
            nat_subnet = PrivateSubnet("my-nat-server")
            nat_server_instance = EC2("nat_server_instance")
            nat_server_rtb      = RouteTable("my-nat-rtb")

        internet_gw = InternetGateway("Internet_Gateway")

        application_subnets >> Edge() << intra_subnets >> Edge() << persistence_subnets >> Edge() << public_subnet

        application_rtb >> Edge() << nat_server_instance
        intra_rtb       >> Edge() << nat_server_instance
        persistence_rtb >> Edge() << nat_server_instance

        nat_server_rtb >> Edge() << internet_gw
        public_rtb     >> Edge() << internet_gw
