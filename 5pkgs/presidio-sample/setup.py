from setuptools import setup

setup(
    name="presidio-sample",
    packages=["sample"],
    include_package_data=True,
    entry_points={
        "console_scripts": [
            "presidio-sample=sample.app:main",
        ]
    },
)
