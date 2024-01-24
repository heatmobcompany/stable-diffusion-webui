from pydantic import BaseModel
from typing import Any


class ControlnetModel(BaseModel):
    enabled: bool | None
    module: str | None
    model: str | None
    weight: int | None
    image: Any | None
    resize_mode: str | None
    low_vram: bool | None
    processor_res: int | None
    threshold_a: int | None
    threshold_b: int | None
    guidance_start: int  | None
    guidance_end: int| None
    pixel_perfect: bool| None
    control_mode: str| None
    is_ui: bool| None
    input_mode: str| None
    batch_images: Any| None
    output_dir: str| None
    loopback: bool| None