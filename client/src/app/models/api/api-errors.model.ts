export class ApiErrors {
  readonly messages: string[];
  readonly networkError: any;
  readonly extraInfo: any;

  constructor(errors) {
    this.messages = [errors.message];
    if (errors.graphQLErrors) {
      this.messages.concat(errors.graphQLErrors.map(error => error.message));
    }

    const { networkError, extraInfo } = errors;
    Object.assign(this, { networkError, extraInfo });
  }
}
