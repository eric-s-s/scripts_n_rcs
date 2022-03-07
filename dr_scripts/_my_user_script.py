import os
import uuid
from bson import ObjectId
from dr_usertool.datarobot_user_database import DataRobotUserDatabase
from dr_usertool.utils import get_permissions
from pymongo import MongoClient

from common.services.permissions import AccountRoles


def get_host():
    return os.environ.get('HOST', '127.0.0.1')


def get_infer_host():
    return os.environ.get('INFER_HOST', '127.0.0.1')


def get_mongo_host():
    return os.environ.get('MONGO_HOST', get_host()).strip()


def dr_usertool_setup():
    mongo_host = get_mongo_host()
    return DataRobotUserDatabase.setup('adhoc', '', mongo_host=mongo_host)


def connect_to_mongo():
    mongo_host = get_mongo_host()
    return MongoClient(mongo_host)


def create_prediction_instance_for_user(user):
    mongo = connect_to_mongo()
    instance = {
        "_id": ObjectId('5a4d4af2fb09ab74d200face'),
        "ssl_enabled": False,
        "resource": "prediction",
        "has_load_balancer": False,
        "datarobot_key": 'YOU WILL NEED A VALUE HERE'
        "is_dedicated": True,
        "setup_stage": "STAGE_DEPLOY",
        "instance_type": "N/A",
        "setup_status": "STATUS_COMPLETED",
        "host_name": get_infer_host(),
        "service_id": 'Local MMM Cloud Dev',
        "orm_version": "CCM",
        "owner_id": str(user['org_ids'][0]),
        "models": []
    }

    mongo.MMApp.instances.update_one({'_id': instance['_id']}, {'$set': instance}, upsert=True)


def delete_org(id):
    mongo = connect_to_mongo()
    mongo.MMApp.organization.delete_one({'_id': ObjectId(id)})


def generate_user():
    suffix = str(uuid.uuid4().int)
    user_username = "random_eric@datarobot.com"
    user_api_token = "lkjkljnm988989jkr5645tv_{}".format(suffix)
    return user_username, user_api_token


def setup():
    env, db = dr_usertool_setup()
    user_username, user_api_token = generate_user()
    user_permissions = get_permissions('_user_permissions', user_api_token)
    #
    # Add user
    DataRobotUserDatabase.add_user(
        db,
        env,
        user_username,
        invite_code='autogen',
        app_user_manager=False,
        permissions=user_permissions,
        api_token=user_api_token,
        activated=True,
        unix_user='datarobot_imp'
    )
    DataRobotUserDatabase.add_organization(db, user_username, 2)
    DataRobotUserDatabase.add_user_to_organization(db, user_username,
                                                   user_username)

    user = DataRobotUserDatabase.get_user(db, user_username)
    print(user)
    create_prediction_instance_for_user(user)

    print('export DATAROBOT_API_TOKEN={}'.format(user_api_token))


def set_permisisons():
    permissions = {
        "EXPERIMENTAL_API_ACCESS": True,
        "ENABLE_DOWNLOAD_DATASET": True,
        "ENABLE_DATA_MANAGEMENT": True,
        "ENABLE_CREATE_SNAPSHOT_DATASOURCE": True,
        'DATAROBOT_PRIME': True,
        'PREDICTIONS_ADMIN': True,
        'ADMIN_API_ACCESS': True,
        'CAN_MANAGE_OWN_PERMISSIONS': True
    }
    env, db = dr_usertool_setup()
    username, _ = generate_user()
    # username = 'admin@datarobot.com'
    DataRobotUserDatabase.set_permissions(db, username, permissions)
    # DataRobotUserDatabase.add_roles(db, username, [AccountRoles.APP_USER_MANAGER])


def reset_password(password):
    # username, api_token = generate_user()
    username = 'admin@datarobot.com'
    env, db = dr_usertool_setup()
    DataRobotUserDatabase.add_user(db, env, username, 'autogen',reset_password=True, password=password)



# def generate_api_token():
#     username, api_token = generate_user()
#     username = 'admin@datarobot.com'
#     env, db = dr_usertool_setup()
#     DataRobotUserDatabase.add_roles()


def print_user_info():
    # username, _ = generate_user()
    username = 'admin@datarobot.com'
    env, db = dr_usertool_setup()
    user = DataRobotUserDatabase.get_user(db, username)
    check = DataRobotUserDatabase.check_user(db, env, username)
    print('USER')
    for k, v in user.items():
        print('{}: {!r}'.format(k, v))
    print('CHECK')
    for k, v in check.items():
        print('{}: {!r}'.format(k, v))

if __name__ == '__main__':
    # setup()
    # set_permisisons()
    print_user_info()
    # reset_password('HEY DUMMY! SET A PASSWORD')
