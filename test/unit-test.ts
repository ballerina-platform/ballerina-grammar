
/**
 * Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 */

import { describe, it } from 'mocha';
import { runTextMateTest } from './test-util';

describe('Unit tests', () => {
    it('class snapshot test', () => {
        return runTextMateTest('class');
    });

    it('function snapshot test', () => {
        return runTextMateTest('function');
    });

    it('object snapshot test', () => {
        return runTextMateTest('object');
    });

    it('service snapshot test', () => {
        return runTextMateTest('service');
    });

    it('test snapshot test', () => {
        return runTextMateTest('test');
    });
});
