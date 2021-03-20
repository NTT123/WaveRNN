"""vietnamese alphabet."""
import unicodedata

_pad = '_'
_punctuation = '!\'(),.:;? '
_special = '-#'  # `#` for a [silent] duration of 0.05s


alphabet = unicodedata.normalize(
    'NFKC',
    "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    "ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠạẢảẤấẦầẨẩẪẫẬậẮắẰằ"
    "ẲẳẴẵẶặẸẹẺẻẼẽẾếỀềỂểỄễỆệỈỉỊịỌọỎỏỐốỒồỔổỖỗỘộỚớỜờỞởỠỡỢợỤụỦủỨứỪừỬửỮữ"
    "ỰựỲỳỴỵỶỷỸỹ"
)

symbols = [_pad] + list(_punctuation) + list(_special) + list(alphabet)
