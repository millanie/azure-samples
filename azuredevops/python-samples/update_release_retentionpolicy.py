from azure.devops.connection import Connection
from msrest.authentication import BasicAuthentication
import pprint
import logging

#logging.basicConfig(level=logging.DEBUG)

personal_access_token = 'YOURPAT'
organization_url = 'https://dev.azure.com/YOURORG'
project_name = 'YOURPRJ'
definition_id = 'YOURDefId'

credentials = BasicAuthentication('', personal_access_token)
connection = Connection(base_url=organization_url, creds=credentials)

release_client = connection.clients.get_release_client()

rel_def = release_client.get_release_definition(project_name,definition_id, property_filters='retention_policy')
rel_def.environments[0].retention_policy = {"daysToKeep": 20, "releasesToKeep": 3, "retainBuild": True}

resp = release_client.update_release_definition(release_definition=rel_def,project=project_name)
