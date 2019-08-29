import { NgModule } from '@angular/core';

import { APOLLO_OPTIONS } from 'apollo-angular';
import { ModuleWithProviders } from '@angular/core';
import { HttpLink } from 'apollo-angular-link-http';
import { InMemoryCache } from 'apollo-cache-inmemory';
// import { HttpClientModule } from '@angular/common/http';

import { environment } from '@env/environment';
const { apiUrl } = environment;

// @NgModule({ imports: [ HttpLink, HttpClientModule ] })
@NgModule({ imports: [ HttpLink ] })
export class AppApolloModule {
  static forRoot(): ModuleWithProviders {
    return {
      ngModule: AppApolloModule,
      providers: [{
        provide: APOLLO_OPTIONS,
        useFactory: (httpLink: HttpLink) => {
          return {
            cache: new InMemoryCache(),
            link: httpLink.create({
              uri: apiUrl
            })
          };
        },
        deps: [HttpLink]
      }],
    };
  }
}
