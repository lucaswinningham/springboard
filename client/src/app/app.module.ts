import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { GraphQLModule } from './graphql.module';

// import { AppApolloModule } from '@app/app-apollo/app-apollo.module';
// import { HttpClientModule } from '@angular/common/http';

// import { APOLLO_OPTIONS } from 'apollo-angular';
// import { HttpLink } from 'apollo-angular-link-http';
// import { InMemoryCache } from 'apollo-cache-inmemory';

// import { environment } from '@env/environment';
// const { apiUrl } = environment;

// export function createApollo(httpLink: HttpLink) {
//   return {
//     cache: new InMemoryCache(),
//     link: httpLink.create({
//       uri: apiUrl
//     })
//   };
// }

import { PagesModule } from './pages/pages.module';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    GraphQLModule,
    // AppApolloModule.forRoot(),
    // HttpClientModule,
    PagesModule
  ],
  // providers: [{
  //   provide: APOLLO_OPTIONS,
  //   useFactory: createApollo,
  //   deps: [HttpLink]
  // }],
  bootstrap: [AppComponent]
})
export class AppModule { }
