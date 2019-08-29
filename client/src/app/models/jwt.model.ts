export class Jwt {
  readonly jwt: string;

  constructor(args: { jwt: string }) {
    Object.assign(this, args);
  }
}
