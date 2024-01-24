import json
from pydantic import BaseModel

class Img2imgWebModel(BaseModel):
    model_checkpoint: str | None
    mode: int | None
    prompt: str | None
    negative_prompt: str | None
    prompt_styles: list| None
    steps: int | None
    sampler_index: int | None
    mask_blur: int | None
    mask_alpha: float| None
    inpainting_fill: int | None
    restore_faces: bool| None
    tiling: bool| None
    n_iter: int | None
    batch_size: int | None
    cfg_scale: float| None
    image_cfg_scale: float| None
    denoising_strength: float| None
    seed: int | None
    subseed: int | None
    subseed_strength: float| None
    seed_resize_from_h: int | None
    seed_resize_from_w: int | None
    seed_enable_extras: bool| None
    selected_scale_tab: int | None
    height: int | None
    width: int | None
    scale_by: float| None
    resize_mode: int | None
    inpaint_full_res: bool| None
    inpaint_full_res_padding: int | None
    inpainting_mask_invert: int | None
    img2img_batch_input_dir: str | None
    img2img_batch_output_dir: str | None
    img2img_batch_inpaint_mask_dir: str | None
    img2img_batch_use_png_info: bool| None
    img2img_batch_png_info_props: list| None
    img2img_batch_png_info_dir: str | None

class Img2imgApiModel(BaseModel):
    # init_images: list| None
    resize_mode: int | None
    denoising_strength: float| None
    image_cfg_scale: int | None
    # mask: str | None
    mask_blur: float | None
    mask_blur_x: float | None
    mask_blur_y: float | None
    inpainting_fill: int | None
    inpaint_full_res: bool| None
    inpaint_full_res_padding: int | None
    inpainting_mask_invert: int | None
    initial_noise_multiplier: int | None
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
    # do_not_save_samples: bool| None
    # do_not_save_grid: bool| None
    negative_prompt: str | None
    # eta: int | None
    # s_min_uncond: int | None
    # s_churn: int | None
    # s_tmax: int | None
    # s_tmin: int | None
    # s_noise: int | None
    override_settings: dict| None = {}
    # override_settings_restore_afterwards: bool| None = False
    # script_args: list| None
    # priority: int | None = 100
    # sampler_index: str | None
    # include_init_images: bool| None
    # script_name: str | None
    # send_images: bool| None = False
    # save_images: bool| None = True
    # alwayson_scripts: dict| None = {}
