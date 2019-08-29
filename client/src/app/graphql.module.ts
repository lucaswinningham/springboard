import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';

import { ApolloModule, APOLLO_OPTIONS } from 'apollo-angular';
import { HttpLinkModule, HttpLink } from 'apollo-angular-link-http';
import { InMemoryCache } from 'apollo-cache-inmemory';

import { environment } from '@env/environment';
const { apiUrl } = environment;

export function createApollo(httpLink: HttpLink) {
  return {
    link: httpLink.create({ uri: apiUrl }),
    cache: new InMemoryCache(),
  };
}

@NgModule({
  imports: [
    ApolloModule,
    HttpLinkModule,
    HttpClientModule
  ],
  exports: [
    ApolloModule
  ],
  providers: [
    {
      provide: APOLLO_OPTIONS,
      useFactory: createApollo,
      deps: [ HttpLink ],
    },
  ],
})
export class GraphQLModule {}
