import json
from pydantic import BaseModel
from helper.txt2imgmodel import Txt2imgApiModel, Txt2imgWebModel
from helper.img2imgmodel import Img2imgApiModel, Img2imgWebModel
from helper.adetailermodel import ADetailerModel
from helper.controlnetmodel import ControlnetModel


def process_txt2img(p, scripts, script_args):
    general = convert_to_dict(p, 2)
    general = Txt2imgApiModel.validate(general)
    controlnet, adetailer = process_extensions(scripts, script_args)
    result = json.dumps({
        "general": general.dict(),
        "controlnet": controlnet,
        "adetailer": adetailer,
    })
    return result


def process_img2img(p, scripts, script_args):
    general = convert_to_dict(p, 2)
    general = Img2imgApiModel.validate(general)
    controlnet, adetailer = process_extensions(scripts, script_args)
    result = json.dumps({
        "general": general.dict(),
        "controlnet": controlnet,
        "adetailer": adetailer,
    })
    return result

def process_extensions(scripts, script_args):
    controlnet = []
    adetailer = []
    for script in scripts:
        if script.name == "controlnet":
            for i in range(script.args_from, script.args_to):
                ctrl = convert_to_dict(script_args[i])
                ctrl = ControlnetModel.validate(ctrl)
                controlnet.append(ctrl.dict())
        elif script.name == "adetailer":
            print('debug adetailer', script_args[script.args_from:script.args_to])
            adetailer.append(script_args[script.args_from])
            for i in range(script.args_from + 1, script.args_to):
                adl = convert_to_dict(script_args[i])
                adl = ADetailerModel.validate(adl)
                adetailer.append(adl.dict())
    print("controlnet", controlnet)
    print("adetailer", adetailer)
    return controlnet, adetailer

def get_jsonable(obj):
    try:
        json.dumps(obj)
        return obj
    except Exception:
        return

def convert_to_dict(obj, level=1):
    if level == 0:
        return get_jsonable(obj)

    if isinstance(obj, (list, tuple)):
        return [convert_to_dict(item, level - 1) for item in obj]
    elif isinstance(obj, dict):
        return {key: convert_to_dict(value, level - 1) for key, value in obj.items()}
    elif hasattr(obj, "__dict__"):
        struct = vars(obj)
        obj_dict = {}
        for key, value in struct.items():
            if key != "__objclass__":
                obj_dict[key] = convert_to_dict(value, level - 1)
        return get_jsonable(obj_dict)
    else:
        return get_jsonable(obj)
