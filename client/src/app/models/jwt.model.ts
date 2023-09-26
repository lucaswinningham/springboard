export class Jwt {
  readonly token: string;

  constructor(args: { token: string }) {
    Object.assign(this, args);
  }
}
