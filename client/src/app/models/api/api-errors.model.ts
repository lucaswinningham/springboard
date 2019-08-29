export class ApiErrors {
  readonly messages: string[];

  constructor(args: { messages: string[] }) {
    Object.assign(this, args);
  }
}
