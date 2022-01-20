public function main() {
    int[] & readonly arr = [];
    int i = 0;

var xx = "3";
// comment
    match arr {
        [1, 2] if i == 1 => { // comment 1
        }
        var [x, y] if i < 3 => { // comment 2
        }
        [1, 2, 3] if i > 4 => { // comment 3
        }
    }
}
