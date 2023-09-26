export class UserTraitGenerator {
  static randomName(): string {
    return this.randomToken(20);
  }

  static randomEmail(): string {
    return `${this.randomToken()}@${this.randomToken()}.com`
  }

  private static randomToken(length = 16): string {
    const chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  
    var result = '';
    for (var i = length; i > 0; --i) {
      result += chars[Math.floor(Math.random() * chars.length)];
    }
    return result;
  }
}
