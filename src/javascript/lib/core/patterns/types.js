/* @flow */
export class Variable {
  name: ?string;

  constructor(name: ?string = null) {
    this.name = name;
  }
}

export class Wildcard {
  constructor() {
  }
}

export class StartsWith {
  prefix: string;

  constructor(prefix: string) {
    this.prefix = prefix;
  }
}

export class Capture {
  value: any;

  constructor(value: any) {
    this.value = value;
  }
}

export class HeadTail {
  head: any;
  tail: any;

  constructor(head: any = null, tail: any = null) {
    this.head = head;
    this.tail = tail;
  }
}

export class Type {
  type: any;
  objPattern: Object;

  constructor(type: any, objPattern: Object = {}) {
    this.type = type
    this.objPattern = objPattern
  }
}

export class Bound {
  value: any;

  constructor(value: any) {
    this.value = value;
  }
}

export class BitStringMatch {
  values: Array<Object>

    //{'value': value, 'attributes': [type, unit, size]};

    //length = unit * size

    //use that info to map value to subset of bitstring
    //use type to turn subset of bitstring into desired type
    //if value is a variable, add variable to args list
    //if value is just a value, match up substring with generated bitstring from value

  constructor(...values: Array<Object>){
    this.values = values;
  }

  length() {
    return values.length;
  }

  size(){
    let s = 0;

    for(let val of this.values){
      s = s + val.unit * val.size;
    }

    return s;
  }

  getValue(index){
    return this.values(index);
  }

  getSizeOfValue(index){
    let val = this.getValue(index);
    return val.unit * val.size;
  }

  getTypeOfValue(index){
    return this.getValue(index).type;
  }
}

export function variable(name: ?string = null): Variable {
  return new Variable(name);
}

export function wildcard(): Wildcard {
  return new Wildcard();
}

export function startsWith(prefix: string): StartsWith {
  return new StartsWith(prefix);
}

export function capture(value: any): Capture {
  return new Capture(value);
}

export function headTail(head: any = null, tail: any = null): HeadTail {
  return new HeadTail(head, tail);
}

export function type(type: any, objPattern: Object = {}): Type {
  return new Type(type, objPattern);
}

export function bound(value: any): Bound {
  return new Bound(value);
}

export function bitStringMatch(...values: Array<Object>){
  return new BitStringMatch(...values);
}
