//
//  Copyright (c) 2018. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import SourceKittenFramework

func renderProperties(_ element: Structure, line: Line, file: File) -> String {
    let attributeStr = renderAttributes(element, content: file.contents)
    var str = ""
    if element.isInstanceVariable || element.isStaticVariable {
        str = renderVariable(element, attributes: attributeStr)
    } else if element.isInstanceMethod  || element.isStaticMethod {
        str = renderMethod(element, attributes: attributeStr)
    }
    return str
}