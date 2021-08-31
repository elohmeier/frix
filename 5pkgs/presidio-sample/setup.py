from setuptools import setup, find_packages

setup(
    name="presidio-sample",
    packages=find_packages(),
    include_package_data=True,
    entry_points={
        "console_scripts": [
            "presidio-sample=sample.app:main",
        ]
    },
)
