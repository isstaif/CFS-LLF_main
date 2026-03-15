
from locust import HttpUser, task, between
import random

class PredictUser(HttpUser):

    wait_time = between(1, 3)
    # wait_time = lambda self: 0
    # Adjust your base image path
    image_path = "/local/scratch/jackson-1-part2-profiles/jackson-1-part2-5h50m/720p/002825.jpg"

    # Generate classifier hostnames 1..100
    classifiers = [f"pytorch-classifier-{i}.default.example.com" for i in range(1, 101)]

    @task
    def predict_all_classifiers(self):
        """Each execution picks a random classifier between 1 and 100."""
        classifier = random.choice(self.classifiers)

        with open(self.image_path, "rb") as img:
            files = {
                "image": ("upload.jpg", img, "image/jpeg"),
            }

            headers = {
                "Host": classifier
            }

            self.client.post(
                "/predict",
                files=files,
                headers=headers,
                #name=f"POST /predict → {classifier}"
            )
