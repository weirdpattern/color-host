#########################################################################
# Copyright (c) 2017, Patricio Trevino                                  #
# All rights reserved.                                                  #
#                                                                       #
# This source code is licensed under the MIT-style license found in the #
# LICENSE file in the root directory of this source tree.               #
#########################################################################

@{
  RootModule = 'ColorHost.psm1'
  ModuleVersion = '1.0.0'
  GUID = 'A90B54D9-DC6D-44DC-96A7-18EC96393602'
  Author = 'Patricio Trevino'
  PowerShellVersion = '3.0'
  FunctionsToExport = 'Write-ColorHost'
  AliasesToExport = 'Write-AnsiHost', 'Write-VT100Host'
}
