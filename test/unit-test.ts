
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

    it('semtype/main.bal snapshot test', () => {
        return runTextMateTest('semtype/main');
    });

    it('semtype/bmain.bal snapshot test', () => {
        return runTextMateTest('semtype/bmain');
    });

    it('semtype/tests/baltest.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/baltest');
    });

    it('semtype/tests/data/basic.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/basic');
    });

    it('semtype/tests/data/boolean-subtype.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/boolean-subtype');
    });

    it('semtype/tests/data/error1.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/error1');
    });

    it('semtype/tests/data/error2.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/error2');
    });

    it('semtype/tests/data/function.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/function');
    });

    it('semtype/tests/data/hard.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/hard');
    });

    it('semtype/tests/data/int-singleton.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/int-singleton');
    });

    it('semtype/tests/data/int-subtype.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/int-subtype');
    });
    
    it('semtype/tests/data/never.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/never');
    });

    it('semtype/tests/data/readonly1.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/readonly1');
    });

    it('semtype/tests/data/readonly2.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/readonly2');
    });

    it('semtype/tests/data/string-singleton.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/string-singleton');
    });

    it('semtype/tests/data/tuple1.bal snapshot test', () => {
        return runTextMateTest('semtype/tests/data/tuple1');
    });

    it('semtype/modules/b/bbuild.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/b/bbuild');
    });
    
    it('semtype/modules/b/bparse.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/b/bparse');
    });

    it('semtype/modules/b/btoken.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/b/btoken');
    });

    it('semtype/modules/b/tests/btokentest.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/b/tests/btokentest');
    });

    it('semtype/modules/bdd/bdd.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/bdd/bdd');
    });

    it('semtype/modules/bdd/tests/bddtest.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/bdd/tests/bddtest');
    });

    it('semtype/modules/core/string.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/core/string');
    });

    it('semtype/modules/core/mapping.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/core/mapping');
    });

    it('semtype/modules/core/list.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/core/list');
    });

    it('semtype/modules/core/int.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/core/int');
    });

    it('semtype/modules/core/function.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/core/function');
    });

    it('semtype/modules/core/error.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/core/error');
    });

    it('semtype/modules/core/core.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/core/core');
    });

    it('semtype/modules/core/common.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/core/common');
    });

    it('semtype/modules/core/boolean.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/core/boolean');
    });

    it('semtype/modules/core/tests/coretest.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/core/tests/coretest');
    });

    it('semtype/modules/json/parse.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/json/parse');
    });

    it('semtype/modules/json/schema.bal snapshot test', () => {
        return runTextMateTest('semtype/modules/json/schema');
    });

    it('const snapshot test', () => {
        return runTextMateTest('const');
    });

    it('annotation snapshot test', () => {
        return runTextMateTest('annotation');
    });

    it('String Template snapshot test', () => {
        return runTextMateTest('stringTemplate');
    });

    it('match snapshot test', () => {
        return runTextMateTest('match');
    });

    it('where snapshot test', () => {
        return runTextMateTest('where');
    });

    it('json snapshot test', () => {
        return runTextMateTest('json');
    });

});
