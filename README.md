*Grep_

_Grep application to search Apex class, trigger, page and component_

## Deploying

1. Install Salesforce Migration Tool  
[Force.com Apex Code Developer's Guide](http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_deploying_ant.htm)

2. Modify *build.properties* correctly
```
sf.serverurl=<serverurl>
sf.username=<username>
sf.password=<password>
```

3. Deploy the code
```
$ ant deploy
```

## Testing

Run *AGrepController_TEST.cls*
