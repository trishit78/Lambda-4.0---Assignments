 function union(arr1,arr2){
    const result=[];
    for(const element of [...arr1,...arr2]){
        if(isObject(element)){
            if(!result.some((el)=>isEqual(el,element))){
                result.push(element);
            }
        }else if(!result.includes(element)){
            result.push(element);
        }
    }
    return result;
}

function isObject(value){
    return value !== null && typeof value === "Object" ;
}

function isEqual(a,b){
    if(a===b) return true;
    if(!isObject(a) || !isObject(b))
        return false;

    const key1=Object.keys(a);
    const key2=Object.keys(b);

    if(key1.length !== key2.length) return false;

    return key1.every(key =>key2.includes(key) && isEqual(a[key],b[key]));
}


console.log(union([1,2,3],[2,3,4]));

console.log(union(['a'],['b']));

console.log(union([1],['1',1]));

console.log(union([{ a:{ b:10}}],[{ a:{ b:20}}]))


console.log(union([{ b: 10, c: { z: { t: 5, _t: 5 }, f: [4] } }, 2],[{ b: 10, c: { z: { t: 5, _t: 5 }, f: [4] } }, '2']))