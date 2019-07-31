import { Injectable } from '@angular/core';
import { Apollo } from 'apollo-angular';
import gql from 'graphql-tag';
import { ApolloQueryResult } from 'apollo-client';

import { Observable } from 'rxjs';
// import { map, tap } from 'rxjs/operators';

type AppQueryResult<T> = Observable<ApolloQueryResult<T>>;

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  constructor(private apollo: Apollo) { }

  query<T>(parameters: { name: string, args: object, fields: string[] }): AppQueryResult<T> {
    const { name, args, fields } = parameters;

    const argsStr = Object.entries(args).map(([key, value]) => `${key}: "${value}"`).join(' ');
    const fieldsStr = fields.join(' ');

    return this.apollo.watchQuery<T>({
      query: gql`
        {
          ${name}(
            ${argsStr}
          ) {
            ${fieldsStr}
          }
        }
      `,
    }).valueChanges;

    // this.apollo.watchQuery({
    //   query: gql`
    //     {
    //       rates(currency: "USD") {
    //         currency
    //         rate
    //       }
    //     }
    //   `,
    // })
    // .valueChanges.subscribe(result => {
    //   this.rates = result.data && result.data.rates;
    //   this.loading = result.loading;
    //   this.error = result.error;
    // });
  }
}
