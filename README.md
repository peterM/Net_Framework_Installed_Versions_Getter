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

- `processCommand`
- `requestVersion`
- `execute`

##### Usage

> when you want run program only when specific .net is installed

`.\detect.ps1 -processCommand cmd -requestVersion 11 -execute True`

> when you want to install specific version in case is not already installed

`.\detect.ps1 -requestVersion 11`

> or if you want to know installed versions of .net

`.\detect.ps1`

