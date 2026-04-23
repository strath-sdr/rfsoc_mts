import os
from distutils.dir_util import copy_tree
from setuptools import find_packages, setup

board_notebooks_dir = os.environ['PYNQ_JUPYTER_NOTEBOOKS']
board_project_dir = os.path.join(board_notebooks_dir, 'rfsoc-mts')

class package_installer():
    def __init__(self,
                 name,
                 version,
                 description,
                 author,
                 email,
                 license,
                 url,
                 pynq_version,
                 board):
        
        args = locals()
        for key in args:
            if key != 'self':
                setattr(self, key, args[key])
        self.check_board()
        self.copy_projects()
        self.copy_notebooks()
        self.run_setup()

    def check_board(self):
        """Check (1) the board is supported by the repository, and (2) the Jupyter Notebook directory exists"""
        if not os.path.isdir(f'boards/{self.board}/{self.name}'):
            raise ValueError("Board {} is not supported.".format(self.board))
        if not os.path.isdir(board_notebooks_dir):
            raise ValueError(
                "Directory {} does not exist.".format(board_notebooks_dir))
        
    def copy_projects(self):
        """
        Copy board specific files from
            boards/<board>/<project>/<subdir>/
        to
            <cwd>/<self.name>/<project>/<subdir>/
        notebooks, bitstreams, clks, etc.
        """
        cwd = os.getcwd()
        for prj in next(os.walk(os.path.join(cwd, 'boards', self.board)))[1]:
            temp_prj = os.path.join(cwd, 'boards', self.board, prj)
            for directory in next(os.walk(temp_prj))[1]:
                src = os.path.join(temp_prj, directory)
                dst = os.path.join(cwd, self.name, prj, directory)
                copy_tree(src, dst)

    def generate_pkg_dirs(self):
        """All files copied over from subdirs via copy_projects are acquired and included in package data"""
        data_files = []
        for directory in os.walk(os.path.join(os.getcwd(), self.name)):
            for file in directory[2]:
                data_files.append("".join([directory[0],"/",file]))
        return data_files
    
    def copy_notebooks(self):
        """Copy notebooks into the Jupyter directory"""
        src_nb_dir = os.path.join('boards', self.board, self.name, 'notebooks')
        dst_nb_dir = os.path.join(board_project_dir)
        copy_tree(src_nb_dir, dst_nb_dir)
    
    def run_setup(self):
        setup(name=self.name,
              version=self.version,
              install_requires=[self.pynq_version],
              url=self.url,
              license=self.license,
              author=self.author,
              author_email=self.email,
              packages=find_packages(),
              package_data={'': self.generate_pkg_dirs()},
              description=self.description)

package_installer(name = "rfsoc_mts",
                  version = "0.1.0",
                  description  = "RFSoC package to aid in the synchronisation of RFDC tiles using MTS framework.",
                  author = "Ryan Provan",
                  email = "ryan.provan@strath.ac.uk, rjprovan2001@gmail.com",
                  license = "None",
                  url = "https://github.com/strathsdr/rfsoc-mts",
                  pynq_version = "pynq>=3.1.1",
                  board = os.environ['BOARD'])
