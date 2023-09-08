from pydantic import BaseModel
from typing import Any, Literal

class ADetailerModel(BaseModel):
    ad_model: str = "None"
    ad_prompt: str = ""
    ad_negative_prompt: str = ""
    ad_confidence: float
    ad_mask_min_ratio: float
    ad_mask_max_ratio: float
    ad_dilate_erode: int = 4
    ad_x_offset: int = 0
    ad_y_offset: int = 0
    ad_mask_merge_invert: Literal["None", "Merge", "Merge and Invert"] = "None"
    ad_mask_blur: int
    ad_denoising_strength: float
    ad_inpaint_only_masked: bool = True
    ad_inpaint_only_masked_padding: int
    ad_use_inpaint_width_height: bool = False
    ad_inpaint_width: int
    ad_inpaint_height: int
    ad_use_steps: bool = False
    ad_steps: int = 28
    ad_use_cfg_scale: bool = False
    ad_cfg_scale: float = 7.0
    ad_use_sampler: bool = False
    ad_sampler: str = "DPM++ 2M Karras"
    ad_use_noise_multiplier: bool = False
    ad_noise_multiplier: float
    ad_use_clip_skip: bool = False
    ad_clip_skip: int
    ad_restore_face: bool = False
    ad_controlnet_model: str
    ad_controlnet_module: str | None
    ad_controlnet_weight: float
    ad_controlnet_guidance_start: float
    ad_controlnet_guidance_end: float
