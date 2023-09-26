import { NgModule } from '@angular/core';

import { GraphQLModule } from '@app/graphql.module';

import { ApiService } from '@services/utils/api.service';
import { Apollo } from 'apollo-angular';

@NgModule({
  imports: [ GraphQLModule ],
  providers: [ ApiService, Apollo ]
})
export class SpecApiModule { }
