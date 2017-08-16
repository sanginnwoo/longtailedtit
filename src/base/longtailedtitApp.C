#include "longtailedtitApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<longtailedtitApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

longtailedtitApp::longtailedtitApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  longtailedtitApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  longtailedtitApp::associateSyntax(_syntax, _action_factory);
}

longtailedtitApp::~longtailedtitApp() {}

// External entry point for dynamic application loading
extern "C" void
longtailedtitApp__registerApps()
{
  longtailedtitApp::registerApps();
}
void
longtailedtitApp::registerApps()
{
  registerApp(longtailedtitApp);
}

// External entry point for dynamic object registration
extern "C" void
longtailedtitApp__registerObjects(Factory & factory)
{
  longtailedtitApp::registerObjects(factory);
}
void
longtailedtitApp::registerObjects(Factory & factory)
{
}

// External entry point for dynamic syntax association
extern "C" void
longtailedtitApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  longtailedtitApp::associateSyntax(syntax, action_factory);
}
void
longtailedtitApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}
