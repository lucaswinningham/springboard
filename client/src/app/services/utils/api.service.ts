import { Injectable } from '@angular/core';

import { Observable, throwError } from 'rxjs';
import { map, catchError } from 'rxjs/operators';

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
      map(response => {
        if (response.apierrors) {
          throw new ApiErrors(response.apierrors);
        } else {
          return response;
        }
      }),
      catchError((errors: any): Observable<ApiErrors> => {
        return throwError(new ApiErrors(errors));
      })
    );
  }
}
