from pydantic import BaseModel
from typing import Any, Literal


class ADetailerModel(BaseModel):
    ad_model: str | None = None
    ad_prompt: str | None = ""
    ad_negative_prompt: str | None = ""
    ad_confidence: float | None
    ad_mask_min_ratio: float | None
    ad_mask_max_ratio: float | None
    ad_dilate_erode: int | None = 4
    ad_x_offset: int | None = 0
    ad_y_offset: int | None = 0
    ad_mask_merge_invert: Literal["None", "Merge", "Merge and Invert"] | None = "None"
    ad_mask_blur: int | None
    ad_denoising_strength: float | None
    ad_inpaint_only_masked: bool | None = True
    ad_inpaint_only_masked_padding: int | None
    ad_use_inpaint_width_height: bool = False
    ad_inpaint_width: int | None
    ad_inpaint_height: int | None
    ad_use_steps: bool | None = False
    ad_steps: int | None = 28
    ad_use_cfg_scale: bool | None = False
    ad_cfg_scale: float | None = 7.0
    ad_use_sampler: bool | None = False
    ad_sampler: str | None = "DPM++ 2M Karras"
    ad_use_noise_multiplier: bool | None = False
    ad_noise_multiplier: float | None
    ad_use_clip_skip: bool | None = False
    ad_clip_skip: int | None
    ad_restore_face: bool | None = False
    ad_controlnet_model: str | None
    ad_controlnet_module: str | None
    ad_controlnet_weight: float | None
    ad_controlnet_guidance_start: float | None
    ad_controlnet_guidance_end: float | None
