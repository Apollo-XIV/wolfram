from setuptools import setup

setup(
    name='wolfram',
    version='0.1.0',
    py_modules=['wolfram', 'lib'],
    install_requires=[
        'Click',
    ],
    entry_points={
        'console_scripts': [
            'wolfram = wolfram:rule',
        ],
    },
)
