import json
from pydantic import BaseModel

class Txt2imgWebModel(BaseModel):
    model_checkpoint: str | None
    prompt: str | None
    negative_prompt: str | None
    # prompt_styles: list| None
    steps: int | None
    sampler_index: int | None
    restore_faces: bool| None
    tiling: bool| None
    n_iter: int | None
    batch_size: int | None
    cfg_scale: float| None
    seed: int | None
    subseed: int | None
    subseed_strength: float| None
    seed_resize_from_h: int | None
    seed_resize_from_w: int | None
    seed_enable_extras: bool| None
    height: int | None
    width: int | None
    enable_hr: bool| None
    denoising_strength: float| None
    hr_scale: float| None
    hr_upscaler: str | None
    hr_second_pass_steps: int | None
    hr_resize_x: int | None
    hr_resize_y: int | None
    hr_sampler_index: int | None
    hr_prompt: str | None
    hr_negative_prompt: str | None
    # override_settings_texts: dict| None



class Txt2imgApiModel(BaseModel):
    enable_hr: bool| None
    denoising_strength: float| None
    # firstphase_width: int | None
    # firstphase_height: int | None
    hr_scale: int | None
    hr_upscaler: str | None
    hr_second_pass_steps: int | None
    hr_resize_x: int | None
    hr_resize_y: int | None
    hr_sampler_name: str | None
    hr_prompt: str | None
    hr_negative_prompt: str | None
    prompt: str | None
    # styles: list| None
    seed: int | None
    subseed: int | None
    subseed_strength: float| None
    seed_resize_from_h: int | None
    seed_resize_from_w: int | None
    sampler_name: str | None
    batch_size: int | None
    n_iter: int | None
    steps: int | None
    cfg_scale: float| None
    width: int | None
    height: int | None
    restore_faces: bool| None
    tiling: bool| None
    do_not_save_samples: bool| None
    do_not_save_grid: bool| None
    negative_prompt: str | None
    # eta: int | None
    # s_min_uncond: int | None
    # s_churn: int | None
    # s_tmax: int | None
    # s_tmin: int | None
    # s_noise: int | None
    override_settings: dict| None
    # override_settings_restore_afterwards: bool| None = False
    # script_args: list| None
    # priority: int | None = 100
    # sampler_index: str | None
    # script_name: str | None
    # send_images: bool| None = False
    # save_images: bool| None = True
    # alwayson_scripts: dict| None = {}

    
