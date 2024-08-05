import os
import argparse
from PIL import Image
from transformers import BlipProcessor, BlipForConditionalGeneration
from modules import paths

class BLIPCaption:
    def __init__(self):
        self.processor = None
        self.model = None
        
    def load(self, model_path = "Salesforce/blip-image-captioning-base"):
        self.processor = BlipProcessor.from_pretrained(model_path, cache_dir=os.path.join(paths.models_path, "BLIPCaption"))
        self.model = BlipForConditionalGeneration.from_pretrained("Salesforce/blip-image-captioning-base", cache_dir=os.path.join(paths.models_path, "BLIPCaption"))

    def caption_image(self, image):
        inputs = self.processor(image, return_tensors="pt")
        out = self.model.generate(**inputs)
        caption = self.processor.decode(out[0], skip_special_tokens=True)
        return caption

blipCaption = BLIPCaption()
blipCaption.load()