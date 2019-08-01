import { ApolloQueryResult } from 'apollo-client';

const defaultQueryResult = { data: {}, loading: false, networkStatus: null, stale: false };

export abstract class Base {
  readonly queryResult: ApolloQueryResult<any>;

  constructor(queryResult: ApolloQueryResult<any> = defaultQueryResult) {
    this.queryResult = queryResult;
    this.afterConstruction();
  }

  protected afterConstruction(): void { }
}
