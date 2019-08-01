import { Injectable } from '@angular/core';
import { Apollo } from 'apollo-angular';
import gql from 'graphql-tag';
import { ApolloQueryResult } from 'apollo-client';

import { Observable } from 'rxjs';

export type AppQuery = Observable<ApolloQueryResult<any>>;

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  constructor(private apollo: Apollo) { }

  query(args: { document: string, variables?: any }): AppQuery {
    const { document } = args;
    const variables = args.variables || {};

    const query = gql`${document}`;
    return this.apollo.watchQuery<any>({ query, variables }).valueChanges;
  }
}
