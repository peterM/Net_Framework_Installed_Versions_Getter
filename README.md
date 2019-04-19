# .Net Framework Installed Versions Getter

### Get all installed versions of .Net Framework


PowerShell Execution Policy
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
```

### Execution

To execute script do steps

1. Open `powershell`
2. Execute script

#### Parametrization

You can use parapeters

- `processCommand` (default = notepad.exe)
- `requestVersion` (default = -1)
- `execute`        (default = False)

##### Usage

> when you want run program only when specific .net is installed

`.\detect.ps1 -processCommand cmd -requestVersion 11 -execute True`

> when you want to install specific version in case is not already installed

`.\detect.ps1 -requestVersion 11`

> or if you want to know installed versions of .net

`.\detect.ps1`

#### Versions

| .net Framework version       | parameter |
|------------------------------|-----------|
| .net framework 3.5 sp1       |    ` 0`   |
| .net framework 4.0           |    ` 1`   |
| .net framework 4.5           |    ` 2`   |
| .net framework 4.5.1         |    ` 3`   |
| .net framework 4.5.2         |    ` 4`   |
| .net framework 4.6           |    ` 5`   |
| .net framework 4.6.1         |    ` 6`   |
| .net framework 4.6.2         |    ` 7`   |
| .net framework 4.7           |    ` 8`   |
| .net framework 4.7.1         |    ` 9`   |
| .net framework 4.7.2         |    `10`   |
| .net framework 4.8 preview   |    `11`   |
| .net framework 4.8           |    `12`   |