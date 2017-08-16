#ifndef LONGTAILEDTITAPP_H
#define LONGTAILEDTITAPP_H

#include "MooseApp.h"

class longtailedtitApp;

template <>
InputParameters validParams<longtailedtitApp>();

class longtailedtitApp : public MooseApp
{
public:
  longtailedtitApp(InputParameters parameters);
  virtual ~longtailedtitApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
};

#endif /* LONGTAILEDTITAPP_H */
