import { TestBed } from '@angular/core/testing';

import { UserCreateService } from './user-create.service';

import { of } from 'rxjs';
import { catchError } from 'rxjs/operators';

import { SpecApiModule } from '@spec/spec-api.module';
import { UserTraitGenerator } from '@spec/users/user-trait-generator';

describe('UserCreateService', () => {
  let service: UserCreateService;
  let name, email;

  beforeEach(() => {
    TestBed.configureTestingModule({ imports: [ SpecApiModule ] });
    service = TestBed.get(UserCreateService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('+create', () => {
    beforeEach(() => {
      name = UserTraitGenerator.randomName();
      email = UserTraitGenerator.randomEmail();
    });

    describe('with valid params', () => {
      describe('response data', () => {
        it('should return user with auth attributes', (done) => {
          service.create({ name, email }).subscribe(user => {
            expect(user).toBeTruthy();
            expect(user.salt).toBeTruthy();
            expect(user.nonce).toBeTruthy();
            expect(user.ckey).toBeTruthy();
            expect(user.civ).toBeTruthy();
            done();
          });
        });
      });
    });

    describe('with taken user name', () => {
      let takenUserCreate$;

      beforeEach(() => {
        takenUserCreate$ = service.create({ name, email });
      });

      it('should return error', (done) => {
        takenUserCreate$.subscribe(() => {
          email = UserTraitGenerator.randomEmail();
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
      let takenUserCreate$;

      beforeEach(() => {
        takenUserCreate$ = service.create({ name, email });
      });

      it('should return error', (done) => {
        takenUserCreate$.subscribe(() => {
          name = UserTraitGenerator.randomName();
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
