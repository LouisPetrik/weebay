let string = "1,2,3"

let arr = Array.from(string.split(","))
console.log("array is now:", arr)
for (let i = 0; i < arr.length; i++) {
	arr[i] = parseInt(arr[i])
}

console.log(arr)

// Arr wieder zu String
let stringAgain = JSON.stringify(arr)
stringAgain = stringAgain.replace("[", "")
stringAgain = stringAgain.replace("]", "")
console.log(stringAgain)
