"""vietnamese alphabet."""

_pad = '_'
_punctuation = '!\'(),.:;? '
_special = '-'


alphabet = ("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            "ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠạẢảẤấẦầẨẩẪẫẬậẮắẰằ"
            "ẲẳẴẵẶặẸẹẺẻẼẽẾếỀềỂểỄễỆệỈỉỊịỌọỎỏỐốỒồỔổỖỗỘộỚớỜờỞởỠỡỢợỤụỦủỨứỪừỬửỮữ"
            "ỰựỲỳỴỵỶỷỸỹ")

symbols = [_pad] + list(_punctuation) + list(_special) + list(alphabet)
