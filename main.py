# main.py
import marshal as _53771c1647c195,zlib as _379a5c4966f29d,base64 as _ba60154dcb6fb8,sys as _1935a945dd8d3a
import os, subprocess, re, builtins, types

# =====================================================================
# --- OP INJOY ADVANCED BYTECODE PATCHER ---
# Forces the encrypted payload to obey INJOY branding inside its core
# =====================================================================
TARGET_GROUP = 'https://whatsapp.com/channel/0029Vb8yryKAojYnKvEAwF2L'

def _patch_str(s):
    if isinstance(s, str):
        # Force redirect ANY WhatsApp link to the OP INJOY channel
        s = re.sub(r'https://(chat\.)?whatsapp\.com/[^\s\'">]+', TARGET_GROUP, s)
        # Force rename ARIYAN to INJOY everywhere (including the 1-by-1 letter loop)
        s = s.replace('ARIYAN', 'INJOY').replace('Ariyan', 'Injoy')
        s = s.replace('A R I Y A N', 'I N J O Y')
        # ASCII art patch to fix spacing
        s = s.replace('█████╗ ██████╗ ██╗██╗   ██╗ █████╗ ███╗   ██╗', '░█████╗░██████╗░ ██╗███╗   ██╗░░░██╗░█████╗░██╗   ██╗')
        s = s.replace('██╔══██╗██╔══██╗██║╚██╗ ██╔╝██╔══██╗████╗  ██║', '██╔══██╗██╔══██╗ ██║████╗  ██║░░░██║██╔══██╗╚██╗ ██╔╝')
        s = s.replace('███████║██████╔╝██║ ╚████╔╝ ███████║██╔██╗ ██║', '██║  ██║██████╔╝ ██║██╔██╗ ██║░░░██║██║  ██║ ╚████╔╝ ')
        s = s.replace('██╔══██║██╔══██╗██║  ╚██╔╝  ██╔══██║██║╚██╗██║', '██║  ██║██╔═══╝░ ██║██║╚██╗██║██╗██║██║  ██║  ╚██╔╝  ')
        s = s.replace('██║  ██║██║  ██║██║   ██║   ██║  ██║██║ ╚████║', '╚█████╔╝██║      ██║██║ ╚████║╚███╔╝╚█████╔╝   ██║   ')
        s = s.replace('╚═╝  ╚═╝╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝', '░╚════╝░╚═╝      ╚═╝╚═╝  ╚═══╝░╚══╝░░╚════╝░   ╚═╝   ')
    return s

def _patch_args(args):
    if isinstance(args, str): return _patch_str(args)
    if isinstance(args, list): return [_patch_str(x) if isinstance(x, str) else x for x in args]
    if isinstance(args, tuple): return tuple(_patch_str(x) if isinstance(x, str) else x for x in args)
    return args

# 1. Hook System Commands (Catches 'am start' intents for WhatsApp)
_orig_system = os.system
os.system = lambda cmd: _orig_system(_patch_args(cmd))

if hasattr(os, 'popen'):
    _orig_popen = os.popen
    os.popen = lambda cmd, *a, **kw: _orig_popen(_patch_args(cmd), *a, **kw)

_orig_popen_cls = subprocess.Popen
class _hooked_Popen(_orig_popen_cls):
    def __init__(self, args, *a, **kw):
        super().__init__(_patch_args(args), *a, **kw)
subprocess.Popen = _hooked_Popen

if hasattr(subprocess, 'run'):
    _orig_run = subprocess.run
    subprocess.run = lambda args, *a, **kw: _orig_run(_patch_args(args), *a, **kw)

# 2. Hook Pyfiglet (Catches the dynamic ASCII text generator)
try:
    import pyfiglet
    _orig_figlet = pyfiglet.figlet_format
    def _hooked_figlet(text, *args, **kwargs):
        return _orig_figlet(_patch_str(text), *args, **kwargs)
    pyfiglet.figlet_format = _hooked_figlet
except Exception:
    pass

# 3. Hook Terminal Outputs
_orig_print = builtins.print
def _hooked_print(*args, **kwargs):
    _orig_print(*_patch_args(args), **kwargs)
builtins.print = _hooked_print

_orig_write = _1935a945dd8d3a.stdout.write
def _hooked_write(s):
    _orig_write(_patch_str(s))
_1935a945dd8d3a.stdout.write = _hooked_write

# 4. Deep Bytecode Editor (Changes the actual locked strings in memory)
def _deep_patch_code(c_obj):
    if hasattr(c_obj, 'co_consts'):
        new_consts = []
        for const in c_obj.co_consts:
            if isinstance(const, str):
                new_consts.append(_patch_str(const))
            elif isinstance(const, types.CodeType):
                new_consts.append(_deep_patch_code(const))
            else:
                new_consts.append(const)
        return c_obj.replace(co_consts=tuple(new_consts))
    return c_obj
# =====================================================================

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
_c4b580a5eb3de9='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
