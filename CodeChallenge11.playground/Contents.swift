struct Pub: Equatable {
    let id: String
    let beers: [String]
}

var pubs = [
    Pub(id: "abc", beers: ["a", "b", "c"]),
    Pub(id: "abc", beers: ["d", "e", "f"]),
    Pub(id: "def", beers: ["a", "b", "c"]),
    Pub(id: "abc", beers: ["g", "h", "i"])
]

func sort(pubs: [Pub]) -> [Pub] {
    var toSort = pubs
    toSort.sort { $0.id < $1.id}
    toSort
    guard let first = toSort.first else { return [] }
    return mergePubs(pub: first, stillToSort: Array(toSort.dropFirst()), result: [])
}

func mergePubs(pub: Pub, stillToSort: [Pub], result: [Pub]) -> [Pub] {
    
    guard let first = stillToSort.first else { return result }
    var results = result.map { $0 }
    let newPub: Pub
    if pub.id == first.id {
        newPub = Pub(id: pub.id, beers: pub.beers + first.beers)
    } else {
        newPub = pub
    }
    
    results.append(newPub)
    
    return mergePubs(pub: first, stillToSort: Array(stillToSort.dropFirst()), result: results)
}

let it = sort(pubs: pubs)

it
