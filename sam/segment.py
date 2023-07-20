from segment_anything import SamPredictor, sam_model_registry
from PIL import Image
import numpy as np

sam_chkpt = './sam_vit_h_4b8939.pth'
device = 'cpu'
model_type = 'vit_h'

sam = sam_model_registry[model_type](checkpoint=sam_chkpt)
sam = sam.to(device)

predictor = SamPredictor(sam)

selected_pixels = []

def generate_mask(image, pixel):
    selected_pixels.append(pixel)
    predictor.set_image(image)

    input_pts = np.array(selected_pixels)
    input_labels = np.ones(input_pts.shape[0])
    mask, _, _ = predictor.predict(
        point_coords=input_pts,
        point_labels=input_labels,
        multimask_ouput=False,
    )
    mask = Image.fromarray(mask[0, :, :].astype(np.uint8))
    return mask