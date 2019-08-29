import { TestBed } from '@angular/core/testing';

import { UserCreateService } from './user-create.service';

import { of } from 'rxjs';
import { catchError } from 'rxjs/operators';

import { GraphQLModule } from '@app/graphql.module';

import { ApiService } from '@services/utils/api.service';
import { Apollo } from 'apollo-angular';

function randomToken(length = 16): string {
  const chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

  var result = '';
  for (var i = length; i > 0; --i) {
    result += chars[Math.floor(Math.random() * chars.length)];
  }
  return result;
}

function randomName(): string {
  return randomToken(20);
}

function randomEmail(): string {
  return `${randomToken()}@${randomToken()}.com`
}

describe('UserCreateService', () => {
  let service: UserCreateService;
  let name, email;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [ GraphQLModule ],
      providers: [ ApiService, Apollo ]
    });

    service = TestBed.get(UserCreateService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('+signup', () => {
    beforeEach(() => {
      name = randomName();
      email = randomEmail();
    });

    describe('with valid params', () => {
      describe('response data', () => {
        it('should return userAuth', (done) => {
          service.create({ name, email }).subscribe(userAuth => {
            expect(userAuth).toBeTruthy();
            expect(userAuth.salt).toBeTruthy();
            expect(userAuth.nonce).toBeTruthy();
            expect(userAuth.ckey).toBeTruthy();
            expect(userAuth.civ).toBeTruthy();
            done();
          });
        });
      });
    });

    describe('with taken user name', () => {
      let takenNameUserCreate$;

      beforeEach(() => {
        takenNameUserCreate$ = service.create({ name, email });
      });

      it('should return error', (done) => {
        takenNameUserCreate$.subscribe(() => {
          email = randomEmail();
          service.create({ name, email }).pipe(
            catchError(apiErrors => {
              expect(apiErrors.messages).toContain('Name has already been taken')
              done();
              return of(apiErrors);
            })
          ).subscribe();
        });
      });
    });

    describe('with invalid user name', () => {
      let takenNameUserCreate$;

      beforeEach(() => {
        name = 'user name';
      });

      it('should return error', (done) => {
        service.create({ name, email }).pipe(
          catchError(apiErrors => {
            expect(apiErrors.messages).toContain('Name is invalid')
            done();
            return of(apiErrors);
          })
        ).subscribe();
      });
    });

    describe('with taken user email', () => {
      let takenNameUserCreate$;

      beforeEach(() => {
        takenNameUserCreate$ = service.create({ name, email });
      });

      it('should return error', (done) => {
        takenNameUserCreate$.subscribe(() => {
          name = randomName();
          service.create({ name, email }).pipe(
            catchError(apiErrors => {
              expect(apiErrors.messages).toContain('Email has already been taken')
              done();
              return of(apiErrors);
            })
          ).subscribe();
        });
      });
    });

    describe('with invalid user email', () => {
      let takenNameUserCreate$;

      beforeEach(() => {
        email = 'email@domain@domain.com';
      });

      it('should return error', (done) => {
        service.create({ name, email }).pipe(
          catchError(apiErrors => {
            expect(apiErrors.messages).toContain('Email is invalid')
            done();
            return of(apiErrors);
          })
        ).subscribe();
      });
    });
  });
});
