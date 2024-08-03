import os

--app: lib
--noMain: on
--define: nimPreviewDotLikeOps

switch("define", "projectName:" & projectName())
switch("out", "lib"/("workspaceentry".toDll))