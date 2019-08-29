import { Injectable } from '@angular/core';

import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';

import { Apollo } from 'apollo-angular';
import gql from 'graphql-tag';
import { ApolloQueryResult } from 'apollo-client';

import { ApiErrors } from '@models/api/api-errors.model';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  constructor(private apollo: Apollo) { }

  query(args: { document: string, variables?: any }): Observable<ApolloQueryResult<any>> {
    const { document } = args;
    const variables = args.variables || {};

    const query = gql`${document}`;
    return this.apollo.watchQuery({ query, variables }).valueChanges;
  }

  mutate(args: { document: string, variables?: any }): Observable<any> {
    const { document } = args;
    const variables = args.variables || {};

    const mutation = gql`${document}`;
    return this.apollo.mutate({ mutation, variables }).pipe(
      catchError((errors: any): Observable<any> => {
        if (errors.graphQLErrors) {
          const messages = errors.graphQLErrors.map(error => error.message);
          return throwError(new ApiErrors({ messages }));
        }
        return throwError(errors);
      })
    );
  }
}
