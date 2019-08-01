export class UserSignup {
  readonly name: string = '';
  readonly email: string = '';
  readonly password: string = '';

  constructor(args?: { name: string, email: string, password: string }) {
    Object.assign(this, args);
  }
}
