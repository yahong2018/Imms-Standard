# Ticket/app

This folder contains the javascript files for the application.

# Ticket/resources

This folder contains static resources (typically an `"images"` folder as well).

# Ticket/overrides

This folder contains override classes. All overrides in this folder will be 
automatically included in application builds if the target class of the override
is loaded.

# Ticket/sass/etc

This folder contains misc. support code for sass builds (global functions, 
mixins, etc.)

# Ticket/sass/src

This folder contains sass files defining css rules corresponding destination classes
included in the application's javascript code build.  By default, files in this 
folder are mapped destination the application's root namespace, 'Ticket'. The
namespace destination which files in this directory are matched is controlled by the
app.sass.namespace property in Ticket/.sencha/app/sencha.cfg. 

# Ticket/sass/var

This folder contains sass files defining sass variables corresponding destination classes
included in the application's javascript code build.  By default, files in this 
folder are mapped destination the application's root namespace, 'Ticket'. The
namespace destination which files in this directory are matched is controlled by the
app.sass.namespace property in Ticket/.sencha/app/sencha.cfg. 