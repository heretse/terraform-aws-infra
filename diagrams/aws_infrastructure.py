#!/usr/local/bin/python3

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.network import VPC, PublicSubnet, PrivateSubnet, RouteTable, InternetGateway
from diagrams.aws.compute import EC2

graph_attr = {
    "fontsize": "28",
    "fontname": "Helvetica",
    "style": "rounded",
    "bgcolor": "transparent"
}

major_cluster = {
    "fontsize": "24",
    "fontname": "Helvetica",
    "style": "rounded"
}

minor_cluster = {
    "fontsize": "16",
    "fontname": "Helvetica",
    "style": "rounded"
}

with Diagram("My AWS Infrastructure Diagram", graph_attr=graph_attr, direction="TB"):

    with Cluster("VPC: my-vpc", graph_attr=major_cluster):

        with Cluster("Private subnets", graph_attr=minor_cluster):
            with Cluster("Application"):
                application_subnets       = PrivateSubnet("my-application-ap-northeast-1a") >> Edge() << PrivateSubnet("my-application-ap-northeast-1c") >> Edge() << PrivateSubnet("my-application-ap-northeast-1d")
                application_rtb           = RouteTable("my-application-rtb")

            with Cluster("Intra"):
                intra_subnets = PrivateSubnet(xlabel="my-intra-ap-northeast-1a") >> Edge() << PrivateSubnet(xlabel="my-intra-ap-northeast-1c") >> Edge() << PrivateSubnet(xlabel="my-intra-ap-northeast-1d")
                intra_rtb     = RouteTable("my-intra-rtb")

            with Cluster("Persistence"):
                persistence_subnets = PrivateSubnet(xlabel="my-persistence-ap-northeast-1a") >> Edge() << PrivateSubnet(xlabel="my-persistence-ap-northeast-1c") >> Edge() << PrivateSubnet(xlabel="my-persistence-ap-northeast-1d")
                persistence_rtb     = RouteTable("my-persistence-rtb")

        with Cluster("Public subnets", graph_attr=minor_cluster, direction="TB"):
            with Cluster("Public Subnets"):
                public_subnet    = PublicSubnet(xlabel="my-public-ap-northeast-1a") >> Edge() << PublicSubnet(xlabel="my-public-ap-northeast-1c") >> Edge() << PublicSubnet(xlabel="my-public-ap-northeast-1d")
                public_rtb       = RouteTable("my-public-rtb")
                bastion_instance = EC2("bastion_instance")

            with Cluster("NAT Subnet"):
                nat_subnet = PublicSubnet("my-nat-server")
                nat_server_instance = EC2("nat_server_instance")
                nat_server_rtb      = RouteTable("my-nat-rtb")

        internet_gw = InternetGateway("Internet_Gateway: my_igw")

        application_subnets >> Edge() << intra_subnets >> Edge() << persistence_subnets >> Edge() << public_subnet

        application_rtb >> Edge() << nat_server_instance
        intra_rtb       >> Edge() << nat_server_instance
        persistence_rtb >> Edge() << nat_server_instance

        nat_server_rtb >> Edge() << internet_gw
        public_rtb     >> Edge() << internet_gw
