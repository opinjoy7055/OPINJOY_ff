# main.py
import marshal, re, types, builtins, sys

# =====================================================================
# --- OP INJOY MASTER INTERCEPTOR ---
# Safely edits binary code objects in memory before execution
# =====================================================================
TARGET_GROUP = 'https://whatsapp.com/channel/0029Vb8yryKAojYnKvEAwF2L'

_orig_loads = marshal.loads
def _deep_patch_code(c_obj):
    def _patch_str(s):
        if isinstance(s, str):
            if 'whatsapp.com' in s: 
                s = re.sub(r'https://(chat\.)?whatsapp\.com/[^\s\'">]+', TARGET_GROUP, s)
            s = s.replace('ARIYAN', 'INJOY').replace('Ariyan', 'Injoy')
            s = s.replace('A R I Y A N', 'I N J O Y')
        return s
    if hasattr(c_obj, 'co_consts'):
        return c_obj.replace(co_consts=tuple(_patch_str(c) if isinstance(c, str) else (_deep_patch_code(c) if isinstance(c, types.CodeType) else c) for c in c_obj.co_consts))
    return c_obj
marshal.loads = lambda b, *a, **kw: _deep_patch_code(_orig_loads(b, *a, **kw))

_orig_open = builtins.open
builtins.open = lambda f, *a, **kw: __import__('io').StringIO("OP INJOY\n") if isinstance(f, str) and 'terminal_username' in f else _orig_open(f, *a, **kw)

_orig_write = sys.stdout.write
sys.stdout.write = lambda s: _orig_write(s.replace('ARIYAN', 'INJOY').replace('Ariyan', 'Injoy')) if isinstance(s, str) else _orig_write(s)
# =====================================================================

import marshal as _53771c1647c195,zlib as _379a5c4966f29d,base64 as _ba60154dcb6fb8,sys as _1935a945dd8d3a
_0d28d3d422502a=539795
_2b5e2fe60885ed=701991
_20ac8824e88238=761518
_f3b76960034a32=931304
_cbc082834ece2e=571258
_1ee360f7effabe=622449
_ed9e7b68a19ce0=928807
_79903fac6db8bc=795301
_6d745c6846473c=681275
_0daa79f4e4ebab=554138
_aee1033add0b14=669804
_fc6ae404d412ec=880993
_e43b63dad90f89=930872
_dae6a073033de0=498959
_8d05a57093d3fa=965495
_a9e082dfe52455=873227
_894387ec1b7ca8=387995
_6bb9d77246c431=964837
_58fc27f746be3f='ZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedcba9876543210+/'
_a39eafb8f4f123='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
_c4b580a5eb3de9='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'
_87f54fd6a94e27=((183, 168, 250, 6, 35, 56, 183, 129, 231, 109, 189, 23, 148, 2, 144, 160, 247, 19, 128, 136, 133, 151, 215, 245, 196, 149, 41, 59, 163, 152, 21, 82, 146, 120, 249, 193, 144, 7, 42, 186, 172, 198, 213, 255, 70, 211, 41, 87, 56, 120, 242, 79, 70, 159, 161, 53, 54, 17, 175, 33, 124, 218, 68, 119), (51, 194, 149, 102, 88, 106, 206, 56, 32, 71, 12, 84, 87, 29, 165, 12, 65, 203, 147, 226, 26, 140, 63, 206, 183, 75, 55, 209, 108, 42, 141, 79, 177, 34, 38, 73, 173, 162, 165, 142, 247, 246, 2, 157, 20, 200, 34, 42), (172, 87, 26, 14, 171, 253, 78, 186, 179, 245, 111, 74, 202, 106, 254, 195, 8, 20, 103, 130, 169, 63, 35, 247, 14, 26, 24, 56, 187, 94, 104, 39))
_88893cd717ec34=str.maketrans(_58fc27f746be3f,_a39eafb8f4f123)

_translated_b64 = _c4b580a5eb3de9.translate(_88893cd717ec34)
# Add missing base64 padding dynamically if needed to avoid binascii.Error
_translated_b64 += '=' * (-len(_translated_b64) % 4)
_3be0fe5e03cd4b=_ba60154dcb6fb8.b64decode(_translated_b64)

_b7feb2220ad579=_3be0fe5e03cd4b
for _59b3b14fc3aa2e in _87f54fd6a94e27:
    _b7feb2220ad579=bytes([b^_59b3b14fc3aa2e[i%len(_59b3b14fc3aa2e)]for i,b in enumerate(_b7feb2220ad579)])

_351cd23ae7dd7a=_379a5c4966f29d.decompress(_b7feb2220ad579,wbits=15)
_f1b7f7ed7b6ae3=_53771c1647c195.loads(_351cd23ae7dd7a)
exec(_f1b7f7ed7b6ae3,{'__name__':'__main__','__file__':_1935a945dd8d3a.argv[0]})
