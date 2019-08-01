import { TestBed } from '@angular/core/testing';

import { UserSignupService } from './user-signup.service';

import { ApiService } from '../utils/api.service';

describe('UserSignupService', () => {
  let service: UserSignupService;
  let api: jasmine.SpyObj<ApiService>;

  beforeEach(() => {
    const apiSpy = jasmine.createSpyObj('ApiService', ['query']);
    TestBed.configureTestingModule({ providers: [{ provide: ApiService, useValue: apiSpy }] });

    api = TestBed.get(ApiService);
    service = TestBed.get(ApiService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('+signup', () => {
    let name, email, salt, nonce, ckey, civ;

    // class Dog { }

    beforeEach(() => {
      // document = `
      //   query getDog($name: String) {
      //     dog(name: $name) {
      //       id
      //       name
      //       breedType
      //     }
      //   }
      // `;

      // dog = { id: 0, name: 'Mr Apollo', breedType: 'Hound' };
      name = '_user_';
      email = 'user@example.com';

      salt = '$2a$10$pb5oHdE7ylzfVBIuqyVohe';
      nonce = 'NtJvwq/etNBusiwCjoDA7A==';
      ckey = 'EFnAMTRPt1nHF1c5bxsR0Q==\n';
      civ = 'o3SHAgyHmRjwhSGm2MilqA==\n';

      api.query.and.returnValue({
        data: {
          userAuth: { salt, nonce, ckey, civ }
        }
      })
    });

    it('should expect api to receive +query', () => {
      console.log({ service })
      console.log({ serviceSignup: service.signup })
      service.signup({ name, email }).subscribe(userAuth => console.log({ userAuth }));
      // expect(api.query).toHaveBeenCalled();
    });

    // it('should expect correct data in result', () => {
    //   service.query({ document }).subscribe(result => {
    //     expect(result.data.dog.id).toEqual(dog.id);
    //     expect(result.data.dog.name).toEqual(dog.name);
    //     expect(result.data.dog.breedType).toEqual(dog.breedType);
    //   });

    //   controller.expectOne(gql`${document}`).flush(flushData);
    // });

    // it('should expect correct variables in operation', () => {
    //   const variables = { name: dog.name };
    //   service.query({ document, variables }).subscribe();

    //   const testOperation = controller.expectOne(gql`${document}`);
    //   expect(testOperation.operation.variables).toEqual(variables);
    //   testOperation.flush(flushData);
    // });
  });
});
