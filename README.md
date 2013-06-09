# A*Grep

_Grep application to search Apex class, trigger, page and component_

* Search target: Apex Classes, Apex Triggers, Visualforce Pages and components
* Option       : "-i" (case Insensitive)
* Option       : "-l" (files with matches)

## Screenshot

![my image](img/screenshot.png)

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
4. Make *A*Grep* tab visible in your profile

## Testing

Run *AGrepController_TEST.cls*

## License

Released under the [MIT Licenses](http://opensource.org/licenses/MIT)
