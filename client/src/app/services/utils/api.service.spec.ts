import { TestBed } from '@angular/core/testing';

import { ApiService } from './api.service';

import { ApolloTestingModule, ApolloTestingController } from 'apollo-angular/testing';
import gql from 'graphql-tag';

describe('ApiService', () => {
  let service: ApiService;
  let controller: ApolloTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({ imports: [ ApolloTestingModule ] });
    controller = TestBed.get(ApolloTestingController);
    service = TestBed.get(ApiService);
  });

  afterEach(() => {
    controller.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  describe('query', () => {
    let document, dog, flushData;

    beforeEach(() => {
      document = `
        query getDog($name: String) {
          dog(name: $name) {
            id
            name
            breedType
          }
        }
      `;

      dog = { id: 0, name: 'Mr Apollo', breedType: 'Hound' };
      flushData = { data : { dog } };
    });

    it('should expect apollo controller to receive document', () => {
      service.query({ document }).subscribe();
      controller.expectOne(gql`${document}`).flush(flushData);
    });

    it('should expect correct data in result', () => {
      service.query({ document }).subscribe(result => {
        expect(result.data.dog.id).toEqual(dog.id);
        expect(result.data.dog.name).toEqual(dog.name);
        expect(result.data.dog.breedType).toEqual(dog.breedType);
      });

      controller.expectOne(gql`${document}`).flush(flushData);
    });

    it('should expect correct variables in operation', () => {
      const variables = { name: dog.name };
      service.query({ document, variables }).subscribe();

      const testOperation = controller.expectOne(gql`${document}`);
      expect(testOperation.operation.variables).toEqual(variables);
      testOperation.flush(flushData);
    });
  });
});
