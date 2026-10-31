function _M0DTPB4Json4Null() {}
_M0DTPB4Json4Null.prototype.$tag = 0;
const _M0DTPB4Json4Null__ = new _M0DTPB4Json4Null();
function _M0DTPB4Json4True() {}
_M0DTPB4Json4True.prototype.$tag = 1;
const _M0DTPB4Json4True__ = new _M0DTPB4Json4True();
function _M0DTPB4Json5False() {}
_M0DTPB4Json5False.prototype.$tag = 2;
const _M0DTPB4Json5False__ = new _M0DTPB4Json5False();
function _M0DTPB4Json6Number(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPB4Json6Number.prototype.$tag = 3;
function _M0DTPB4Json6String(param0) {
  this._0 = param0;
}
_M0DTPB4Json6String.prototype.$tag = 4;
function _M0DTPB4Json5Array(param0) {
  this._0 = param0;
}
_M0DTPB4Json5Array.prototype.$tag = 5;
function _M0DTPB4Json6Object(param0) {
  this._0 = param0;
}
_M0DTPB4Json6Object.prototype.$tag = 6;
const $reinterpret_view = new DataView(new ArrayBuffer(8));
function $i64_reinterpret_f64(a) {
  $reinterpret_view.setBigUint64(0, BigInt.asUintN(64, a), false);
  return $reinterpret_view.getFloat64(0, false);
}
function _M0TPC28internal7strconv9FloatInfo(param0, param1, param2) {
  this.mantissa_bits = param0;
  this.exponent_bits = param1;
  this.bias = param2;
}
function _M0TP212moonbitstack8moondate4Time(param0, param1, param2, param3) {
  this.hour = param0;
  this.minute = param1;
  this.second = param2;
  this.nano = param3;
}
function _M0TPC16string10StringView(param0, param1, param2) {
  this.str = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPC15bytes9BytesView(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
const $bytes_literal$0 = new Uint8Array([70,114,111,109,32]);
function _M0TP212moonbitstack8moondate4Date(param0, param1, param2) {
  this.year = param0;
  this.month = param1;
  this.day = param2;
}
const $bytes_literal$1 = new Uint8Array([13,10]);
function $oob() {
  throw new Error("Index out of bounds");
}
function _M0TPB13StringBuilder(param0) {
  this.val = param0;
}
class $PanicError extends Error {}
function $panic() {
  throw new $PanicError();
}
const _M0FPB12random__seed = () => {
  if (globalThis.crypto?.getRandomValues) {
    const array = new Uint32Array(1);
    globalThis.crypto.getRandomValues(array);
    return array[0] | 0; // Convert to signed 32
  } else {
    return Math.floor(Math.random() * 0x100000000) | 0; // Fallback to Math.random
  }
};
const _M0FPB19int__to__string__js = (x, radix) => {
  return x.toString(radix);
};
const _M0FPB20uint__to__string__js = (x, radix) => {
  return (x >>> 0).toString(radix);
};
function _M0TPB4IterGyE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function _M0TPB4IterGUssEE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function _M0TPB4IterGcE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function _M0TPB9ArrayViewGyE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB9ArrayViewGkE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
function $makebytes(a, b) {
  const arr = new Uint8Array(a);
  if (b !== 0) {
    arr.fill(b);
  }
  return arr;
}
function _M0TPB8MutLocalGiE(param0) {
  this.val = param0;
}
const _M0MPB7JSArray4push = (arr, val) => { arr.push(val); };
function _M0TPB4IterGRPC16string10StringViewE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function _M0TPB8MutLocalGORPC16string10StringViewE(param0) {
  this.val = param0;
}
function _M0TPB9ArrayViewGUssEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0DTPC16result6ResultGRP212moonbitstack8moonmime7CharsetRP212moonbitstack8moonmime7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP212moonbitstack8moonmime7CharsetRP212moonbitstack8moonmime7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP212moonbitstack8moonmime7CharsetRP212moonbitstack8moonmime7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP212moonbitstack8moonmime7CharsetRP212moonbitstack8moonmime7RefusedE2Ok.prototype.$tag = 1;
function _M0TPB3MapGsRPB4JsonE(param0, param1, param2, param3, param4, param5, param6) {
  this.entries = param0;
  this.size = param1;
  this.capacity = param2;
  this.capacity_mask = param3;
  this.grow_at = param4;
  this.head = param5;
  this.tail = param6;
}
function _M0TPB5EntryGsRPB4JsonE(param0, param1, param2, param3, param4, param5) {
  this.prev = param0;
  this.next = param1;
  this.psl = param2;
  this.hash = param3;
  this.key = param4;
  this.value = param5;
}
function _M0TPB8MutLocalGORPB5EntryGsRPB4JsonEE(param0) {
  this.val = param0;
}
const $bytes_literal$2 = new Uint8Array();
function _M0TPB9ArrayViewGcE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
const _M0MPB7JSArray12append__view = (dst, src, src_offset, len) => {
   for (let i = 0; i < len; i++) {
     dst.push(src[src_offset + i]);
   }
 };
const _M0MPB7JSArray3pop = (arr) => arr.pop();
function _M0TPB9ArrayViewGsE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPB9ArrayViewGRPC16string10StringViewE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TPC15float17FloatingDecimal32(param0, param1) {
  this.mantissa = param0;
  this.exponent = param1;
}
function $i32_reinterpret_f32(a) {
  $reinterpret_view.setFloat32(0, a, true);
  return $reinterpret_view.getInt32(0, true);
}
function _M0DTPC15debug4Repr7UnitLit() {}
_M0DTPC15debug4Repr7UnitLit.prototype.$tag = 0;
function _M0DTPC15debug4Repr7Integer(param0) {
  this._0 = param0;
}
_M0DTPC15debug4Repr7Integer.prototype.$tag = 1;
function _M0DTPC15debug4Repr9DoubleLit(param0) {
  this._0 = param0;
}
_M0DTPC15debug4Repr9DoubleLit.prototype.$tag = 2;
function _M0DTPC15debug4Repr8FloatLit(param0) {
  this._0 = param0;
}
_M0DTPC15debug4Repr8FloatLit.prototype.$tag = 3;
function _M0DTPC15debug4Repr7BoolLit(param0) {
  this._0 = param0;
}
_M0DTPC15debug4Repr7BoolLit.prototype.$tag = 4;
function _M0DTPC15debug4Repr7CharLit(param0) {
  this._0 = param0;
}
_M0DTPC15debug4Repr7CharLit.prototype.$tag = 5;
function _M0DTPC15debug4Repr9StringLit(param0) {
  this._0 = param0;
}
_M0DTPC15debug4Repr9StringLit.prototype.$tag = 6;
function _M0DTPC15debug4Repr5Tuple(param0) {
  this._0 = param0;
}
_M0DTPC15debug4Repr5Tuple.prototype.$tag = 7;
function _M0DTPC15debug4Repr5Array(param0) {
  this._0 = param0;
}
_M0DTPC15debug4Repr5Array.prototype.$tag = 8;
function _M0DTPC15debug4Repr6Record(param0) {
  this._0 = param0;
}
_M0DTPC15debug4Repr6Record.prototype.$tag = 9;
function _M0DTPC15debug4Repr4Enum(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15debug4Repr4Enum.prototype.$tag = 10;
function _M0DTPC15debug4Repr3Map(param0) {
  this._0 = param0;
}
_M0DTPC15debug4Repr3Map.prototype.$tag = 11;
function _M0DTPC15debug4Repr11RecordField(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15debug4Repr11RecordField.prototype.$tag = 12;
function _M0DTPC15debug4Repr14EnumLabeledArg(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15debug4Repr14EnumLabeledArg.prototype.$tag = 13;
function _M0DTPC15debug4Repr6Opaque(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15debug4Repr6Opaque.prototype.$tag = 14;
function _M0DTPC15debug4Repr7Literal(param0) {
  this._0 = param0;
}
_M0DTPC15debug4Repr7Literal.prototype.$tag = 15;
function _M0DTPC15debug4Repr8MapEntry(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15debug4Repr8MapEntry.prototype.$tag = 16;
function _M0DTPC15debug4Repr7Omitted() {}
_M0DTPC15debug4Repr7Omitted.prototype.$tag = 17;
const _M0DTPC15debug4Repr7Omitted__ = new _M0DTPC15debug4Repr7Omitted();
function _M0TPC15debug13ContentParens(param0, param1) {
  this.size = param0;
  this.lines = param1;
}
function _M0TPC15debug7Content(param0, param1, param2) {
  this.size = param0;
  this.lines = param1;
  this.needs_parens = param2;
}
function _M0TPC16buffer6Buffer(param0, param1) {
  this.data = param0;
  this.len = param1;
}
const _M0FPC28encoding4utf816encode__utf8__js = (() => {
   const encoder = new TextEncoder();
   return function(src, start, len, bom) {
     const end = start + len;
     const encoded = encoder.encode(src.slice(start, end));
     if (!bom) {
       return encoded;
     }
     const result = new Uint8Array(encoded.length + 3);
     result[0] = 0xEF;
     result[1] = 0xBB;
     result[2] = 0xBF;
     result.set(encoded, 3);
     return result;
   };
 })();
const _M0FPC28encoding4utf823decode__utf8__lossy__js = ((preserveBOMDecoder, dropBOMDecoder) => function(bytes, start, len, preserveBOM) {
   const end = start + len;
   const slice = bytes.subarray(start, end);
   const decoder = preserveBOM ? preserveBOMDecoder : dropBOMDecoder;
   return decoder.decode(slice);
 })(
   new TextDecoder("utf-8", { ignoreBOM: true }),
   new TextDecoder("utf-8", { ignoreBOM: false }),
 );
function _M0DTPC16result6ResultGuRPB7FailureE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRPB7FailureE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGuRPB7FailureE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRPB7FailureE2Ok.prototype.$tag = 1;
function _M0DTPC15error5Error52moonbitstack_2fmoonmail_2fjmap_2eRefused_2eMalformed(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error52moonbitstack_2fmoonmail_2fjmap_2eRefused_2eMalformed.prototype.$tag = 28;
function _M0DTPC15error5Error54moonbitstack_2fmoonmail_2fjmap_2eRefused_2eNotAnObject() {}
_M0DTPC15error5Error54moonbitstack_2fmoonmail_2fjmap_2eRefused_2eNotAnObject.prototype.$tag = 27;
const _M0DTPC15error5Error54moonbitstack_2fmoonmail_2fjmap_2eRefused_2eNotAnObject__ = new _M0DTPC15error5Error54moonbitstack_2fmoonmail_2fjmap_2eRefused_2eNotAnObject();
function _M0DTPC15error5Error50moonbitstack_2fmoonmail_2fjmap_2eRefused_2eMissing(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error50moonbitstack_2fmoonmail_2fjmap_2eRefused_2eMissing.prototype.$tag = 26;
function _M0DTPC15error5Error52moonbitstack_2fmoonmail_2fjmap_2eRefused_2eWrongType(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error52moonbitstack_2fmoonmail_2fjmap_2eRefused_2eWrongType.prototype.$tag = 25;
function _M0DTPC15error5Error49moonbitstack_2fmoonmail_2fjmap_2eRefused_2eBadUrl(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error49moonbitstack_2fmoonmail_2fjmap_2eRefused_2eBadUrl.prototype.$tag = 24;
function _M0DTPC15error5Error49moonbitstack_2fmoonmail_2fjmap_2eRefused_2eFailed(param0, param1, param2) {
  this._0 = param0;
  this._1 = param1;
  this._2 = param2;
}
_M0DTPC15error5Error49moonbitstack_2fmoonmail_2fjmap_2eRefused_2eFailed.prototype.$tag = 23;
function _M0DTPC15error5Error50moonbitstack_2fmoonmime_2fqp_2eRefused_2eMalformed(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error50moonbitstack_2fmoonmime_2fqp_2eRefused_2eMalformed.prototype.$tag = 22;
function _M0DTPC15error5Error41moonbitstack_2fmoonbase_2eMalformed_2eBad(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error41moonbitstack_2fmoonbase_2eMalformed_2eBad.prototype.$tag = 21;
function _M0DTPC15error5Error47moonbitstack_2fmoonbase_2eMalformed_2eTruncated(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error47moonbitstack_2fmoonbase_2eMalformed_2eTruncated.prototype.$tag = 20;
function _M0DTPC15error5Error45moonbitstack_2fmoonbase_2eMalformed_2ePadding(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error45moonbitstack_2fmoonbase_2eMalformed_2ePadding.prototype.$tag = 19;
function _M0DTPC15error5Error46moonbitstack_2fmoonbase_2eMalformed_2eChecksum(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error46moonbitstack_2fmoonbase_2eMalformed_2eChecksum.prototype.$tag = 18;
function _M0DTPC15error5Error52moonbitlang_2fcore_2fjson_2eParseError_2eInvalidChar(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error52moonbitlang_2fcore_2fjson_2eParseError_2eInvalidChar.prototype.$tag = 17;
function _M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof() {}
_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof.prototype.$tag = 16;
const _M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__ = new _M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof();
function _M0DTPC15error5Error54moonbitlang_2fcore_2fjson_2eParseError_2eInvalidNumber(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error54moonbitlang_2fcore_2fjson_2eParseError_2eInvalidNumber.prototype.$tag = 15;
function _M0DTPC15error5Error59moonbitlang_2fcore_2fjson_2eParseError_2eInvalidIdentEscape(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error59moonbitlang_2fcore_2fjson_2eParseError_2eInvalidIdentEscape.prototype.$tag = 14;
function _M0DTPC15error5Error53moonbitlang_2fcore_2fjson_2eParseError_2eDuplicateKey(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error53moonbitlang_2fcore_2fjson_2eParseError_2eDuplicateKey.prototype.$tag = 13;
function _M0DTPC15error5Error59moonbitlang_2fcore_2fjson_2eParseError_2eDepthLimitExceeded() {}
_M0DTPC15error5Error59moonbitlang_2fcore_2fjson_2eParseError_2eDepthLimitExceeded.prototype.$tag = 12;
const _M0DTPC15error5Error59moonbitlang_2fcore_2fjson_2eParseError_2eDepthLimitExceeded__ = new _M0DTPC15error5Error59moonbitlang_2fcore_2fjson_2eParseError_2eDepthLimitExceeded();
function _M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure.prototype.$tag = 11;
function _M0DTPC15error5Error42moonbitstack_2fmoonmail_2eRefused_2eHeader(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error42moonbitstack_2fmoonmail_2eRefused_2eHeader.prototype.$tag = 10;
function _M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eAddress(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eAddress.prototype.$tag = 9;
function _M0DTPC15error5Error44moonbitstack_2fmoonmail_2eRefused_2eBoundary(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error44moonbitstack_2fmoonmail_2eRefused_2eBoundary.prototype.$tag = 8;
function _M0DTPC15error5Error44moonbitstack_2fmoonmail_2eRefused_2eEncoding(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error44moonbitstack_2fmoonmail_2eRefused_2eEncoding.prototype.$tag = 7;
function _M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eCharset(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eCharset.prototype.$tag = 6;
function _M0DTPC15error5Error40moonbitstack_2fmoonmail_2eRefused_2eDate() {}
_M0DTPC15error5Error40moonbitstack_2fmoonmail_2eRefused_2eDate.prototype.$tag = 5;
function _M0DTPC15error5Error41moonbitstack_2fmoonmime_2eRefused_2eParts(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error41moonbitstack_2fmoonmime_2eRefused_2eParts.prototype.$tag = 4;
function _M0DTPC15error5Error40moonbitstack_2fmoonmime_2eRefused_2ePart(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC15error5Error40moonbitstack_2fmoonmime_2eRefused_2ePart.prototype.$tag = 3;
function _M0DTPC15error5Error45moonbitstack_2fmoonmime_2eRefused_2eMalformed(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error45moonbitstack_2fmoonmime_2eRefused_2eMalformed.prototype.$tag = 2;
function _M0DTPC15error5Error43moonbitstack_2fmoonmime_2eRefused_2eCharset(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error43moonbitstack_2fmoonmime_2eRefused_2eCharset.prototype.$tag = 1;
function _M0DTPC15error5Error44moonbitstack_2fmoonmime_2eRefused_2eNotAForm(param0) {
  this._0 = param0;
}
_M0DTPC15error5Error44moonbitstack_2fmoonmime_2eRefused_2eNotAForm.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPB7FailureE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPB7FailureE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPB7FailureE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPB7FailureE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPB7FailureE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGORPC28internal7strconv6NumberRPB7FailureE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPB7FailureE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGORPC28internal7strconv6NumberRPB7FailureE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGdRPB7FailureE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGdRPB7FailureE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGdRPB7FailureE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGdRPB7FailureE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok.prototype.$tag = 1;
function _M0TPC28internal7strconv6Number(param0, param1, param2, param3) {
  this.exponent = param0;
  this.mantissa = param1;
  this.negative = param2;
  this.many_digits = param3;
}
function _M0DTPC16result6ResultGdRPC15error5ErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGdRPC15error5ErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGdRPC15error5ErrorE2Ok.prototype.$tag = 1;
function $i64_clz(a) {
  a = BigInt.asUintN(64, a);
  if (a === 0n) return 64;
  const hi = Number(a >> 32n);
  if (hi !== 0) {
    return Math.clz32(hi);
  }
  return 32 + Math.clz32(Number(a & 0xffffffffn));
}
function _M0TPC28internal7strconv12EiselProduct(param0, param1) {
  this.lo = param0;
  this.hi = param1;
}
function _M0TPC28internal7strconv7Decimal(param0, param1, param2, param3, param4, param5) {
  this.digits = param0;
  this.digits_num = param1;
  this.decimal_point = param2;
  this.negative = param3;
  this.truncated = param4;
  this.overflowed = param5;
}
function _M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPC15error5ErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPC15error5ErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPC15error5ErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPC15error5ErrorE2Ok.prototype.$tag = 1;
function $f64_convert_i64_u(a) {
  return Number(a);
}
function _M0DTPC16option6OptionGdE4None() {}
_M0DTPC16option6OptionGdE4None.prototype.$tag = 0;
const _M0DTPC16option6OptionGdE4None__ = new _M0DTPC16option6OptionGdE4None();
function _M0DTPC16option6OptionGdE4Some(param0) {
  this._0 = param0;
}
_M0DTPC16option6OptionGdE4Some.prototype.$tag = 1;
function _M0TPC14json8Position(param0, param1) {
  this.line = param0;
  this.column = param1;
}
function _M0DTPC16result6ResultGiRPC14json10ParseErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGiRPC14json10ParseErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGiRPC14json10ParseErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGiRPC14json10ParseErrorE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGuRPC14json10ParseErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRPC14json10ParseErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGuRPC14json10ParseErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRPC14json10ParseErrorE2Ok.prototype.$tag = 1;
function _M0TPC14json12ParseContext(param0, param1, param2, param3, param4) {
  this.offset = param0;
  this.input = param1;
  this.end_offset = param2;
  this.reject_duplicate_keys = param3;
  this.preserve_number_repr = param4;
}
function $f64_convert_i64(a) {
  return Number(BigInt.asIntN(64, a));
}
function _M0TPC14json11LexedNumber(param0, param1) {
  this.repr = param0;
  this.value = param1;
}
function _M0TPC14json14JsonNumberScan(param0, param1, param2, param3, param4) {
  this.negative = param0;
  this.is_integer = param1;
  this.mantissa = param2;
  this.exponent = param3;
  this.many_digits = param4;
}
function _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGsRPC14json10ParseErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGsRPC14json10ParseErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGsRPC14json10ParseErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGsRPC14json10ParseErrorE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok.prototype.$tag = 1;
function _M0DTPC14json5Token4Null() {}
_M0DTPC14json5Token4Null.prototype.$tag = 0;
const _M0DTPC14json5Token4Null__ = new _M0DTPC14json5Token4Null();
function _M0DTPC14json5Token4True() {}
_M0DTPC14json5Token4True.prototype.$tag = 1;
const _M0DTPC14json5Token4True__ = new _M0DTPC14json5Token4True();
function _M0DTPC14json5Token5False() {}
_M0DTPC14json5Token5False.prototype.$tag = 2;
const _M0DTPC14json5Token5False__ = new _M0DTPC14json5Token5False();
function _M0DTPC14json5Token6Number(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC14json5Token6Number.prototype.$tag = 3;
function _M0DTPC14json5Token6String(param0) {
  this._0 = param0;
}
_M0DTPC14json5Token6String.prototype.$tag = 4;
function _M0DTPC14json5Token6LBrace() {}
_M0DTPC14json5Token6LBrace.prototype.$tag = 5;
const _M0DTPC14json5Token6LBrace__ = new _M0DTPC14json5Token6LBrace();
function _M0DTPC14json5Token6RBrace() {}
_M0DTPC14json5Token6RBrace.prototype.$tag = 6;
const _M0DTPC14json5Token6RBrace__ = new _M0DTPC14json5Token6RBrace();
function _M0DTPC14json5Token8LBracket() {}
_M0DTPC14json5Token8LBracket.prototype.$tag = 7;
const _M0DTPC14json5Token8LBracket__ = new _M0DTPC14json5Token8LBracket();
function _M0DTPC14json5Token8RBracket() {}
_M0DTPC14json5Token8RBracket.prototype.$tag = 8;
const _M0DTPC14json5Token8RBracket__ = new _M0DTPC14json5Token8RBracket();
function _M0DTPC14json5Token5Comma() {}
_M0DTPC14json5Token5Comma.prototype.$tag = 9;
const _M0DTPC14json5Token5Comma__ = new _M0DTPC14json5Token5Comma();
function _M0DTPC16result6ResultGURPC14json5TokeniERPC14json10ParseErrorE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGURPC14json5TokeniERPC14json10ParseErrorE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGURPC14json5TokeniERPC14json10ParseErrorE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGURPC14json5TokeniERPC14json10ParseErrorE2Ok.prototype.$tag = 1;
function _M0TPB9ArrayViewGUsRPB4JsonEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0DTPC14json10WriteFrame5Array(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC14json10WriteFrame5Array.prototype.$tag = 0;
function _M0DTPC14json10WriteFrame6Object(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC14json10WriteFrame6Object.prototype.$tag = 1;
const $bytes_literal$3 = new Uint8Array([48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70]);
function _M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE2Ok.prototype.$tag = 1;
function _M0DTP412moonbitstack9mooncrypt4hash4sha24Core6Narrow(param0) {
  this._0 = param0;
}
_M0DTP412moonbitstack9mooncrypt4hash4sha24Core6Narrow.prototype.$tag = 0;
function _M0DTP412moonbitstack9mooncrypt4hash4sha24Core4Wide(param0) {
  this._0 = param0;
}
_M0DTP412moonbitstack9mooncrypt4hash4sha24Core4Wide.prototype.$tag = 1;
function _M0TP412moonbitstack9mooncrypt4hash4sha24Wide(param0, param1, param2, param3, param4) {
  this.h = param0;
  this.buf = param1;
  this.used = param2;
  this.lo = param3;
  this.hi = param4;
}
function _M0TP412moonbitstack9mooncrypt4hash4sha26Narrow(param0, param1, param2, param3) {
  this.h = param0;
  this.buf = param1;
  this.used = param2;
  this.n = param3;
}
function _M0TP412moonbitstack9mooncrypt4hash4sha26Hasher(param0, param1) {
  this.kind = param0;
  this.core = param1;
}
function _M0DTPC16result6ResultGzRP312moonbitstack8moonmime2qp7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGzRP312moonbitstack8moonmime2qp7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGzRP312moonbitstack8moonmime2qp7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGzRP312moonbitstack8moonmime2qp7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGsRP212moonbitstack8moonmime7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGsRP212moonbitstack8moonmime7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGsRP212moonbitstack8moonmime7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGsRP212moonbitstack8moonmime7RefusedE2Ok.prototype.$tag = 1;
function _M0TP212moonbitstack8moonmime9MediaType(param0, param1) {
  this.essence = param0;
  this.params = param1;
}
function _M0TP212moonbitstack8moonmime11Disposition(param0, param1) {
  this.kind = param0;
  this.params = param1;
}
function _M0DTPC16result6ResultGzRP212moonbitstack8moonmime7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGzRP212moonbitstack8moonmime7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGzRP212moonbitstack8moonmime7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGzRP212moonbitstack8moonmime7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGORPB5ArrayGURPC15bytes9BytesViewiEERP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGORPB5ArrayGURPC15bytes9BytesViewiEERP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGORPB5ArrayGURPC15bytes9BytesViewiEERP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGORPB5ArrayGURPC15bytes9BytesViewiEERP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16option6OptionGRPB5ArrayGURPC15bytes9BytesViewiEEE4None() {}
_M0DTPC16option6OptionGRPB5ArrayGURPC15bytes9BytesViewiEEE4None.prototype.$tag = 0;
const _M0DTPC16option6OptionGRPB5ArrayGURPC15bytes9BytesViewiEEE4None__ = new _M0DTPC16option6OptionGRPB5ArrayGURPC15bytes9BytesViewiEEE4None();
function _M0DTPC16option6OptionGRPB5ArrayGURPC15bytes9BytesViewiEEE4Some(param0) {
  this._0 = param0;
}
_M0DTPC16option6OptionGRPB5ArrayGURPC15bytes9BytesViewiEEE4Some.prototype.$tag = 1;
function _M0DTPC16result6ResultGzRP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGzRP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGzRP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGzRP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGURP212moonbitstack8moonmail7HeadersiERP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGURP212moonbitstack8moonmail7HeadersiERP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGURP212moonbitstack8moonmail7HeadersiERP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGURP212moonbitstack8moonmail7HeadersiERP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0TP212moonbitstack8moonmail7Headers(param0) {
  this.fields = param0;
}
function _M0DTPC16result6ResultGRP212moonbitstack8moonmail7MessageRP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP212moonbitstack8moonmail7MessageRP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP212moonbitstack8moonmail7MessageRP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP212moonbitstack8moonmail7MessageRP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0TP212moonbitstack8moonmail7Message(param0, param1) {
  this.headers = param0;
  this.body = param1;
}
function _M0DTPC16result6ResultGRP212moonbitstack8moonmail4BodyRP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP212moonbitstack8moonmail4BodyRP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP212moonbitstack8moonmail4BodyRP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP212moonbitstack8moonmail4BodyRP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0DTP212moonbitstack8moonmail4Body4Leaf(param0) {
  this._0 = param0;
}
_M0DTP212moonbitstack8moonmail4Body4Leaf.prototype.$tag = 0;
function _M0DTP212moonbitstack8moonmail4Body9Multipart(param0) {
  this._0 = param0;
}
_M0DTP212moonbitstack8moonmail4Body9Multipart.prototype.$tag = 1;
function _M0DTP212moonbitstack8moonmail4Body8Embedded(param0) {
  this._0 = param0;
}
_M0DTP212moonbitstack8moonmail4Body8Embedded.prototype.$tag = 2;
function _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7MessageERP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7MessageERP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7MessageERP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7MessageERP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGbRP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGbRP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGbRP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGbRP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGOUsbERP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGOUsbERP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGOUsbERP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGOUsbERP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0TP212moonbitstack8moonmail5Piece(param0, param1, param2) {
  this.text = param0;
  this.spaced = param1;
  this.quoted = param2;
}
function _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail5PieceERP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail5PieceERP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail5PieceERP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail5PieceERP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRP212moonbitstack8moonmail7MailboxRP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP212moonbitstack8moonmail7MailboxRP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP212moonbitstack8moonmail7MailboxRP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP212moonbitstack8moonmail7MailboxRP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0TP212moonbitstack8moonmail7Mailbox(param0, param1) {
  this.name = param0;
  this.address = param1;
}
function _M0DTPC16result6ResultGRP212moonbitstack8moonmail7AddressRP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP212moonbitstack8moonmail7AddressRP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP212moonbitstack8moonmail7AddressRP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP212moonbitstack8moonmail7AddressRP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0DTP212moonbitstack8moonmail7Address7Mailbox(param0) {
  this._0 = param0;
}
_M0DTP212moonbitstack8moonmail7Address7Mailbox.prototype.$tag = 0;
function _M0DTP212moonbitstack8moonmail7Address5Group(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTP212moonbitstack8moonmail7Address5Group.prototype.$tag = 1;
function _M0TP212moonbitstack8moonmail5Lexer(param0, param1) {
  this.text = param0;
  this.at = param1;
}
function _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7AddressERP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7AddressERP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7AddressERP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7AddressERP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGOsRP212moonbitstack8moonmail7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGOsRP212moonbitstack8moonmail7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGOsRP212moonbitstack8moonmail7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGOsRP212moonbitstack8moonmail7RefusedE2Ok.prototype.$tag = 1;
function _M0TPB9ArrayViewGRP212moonbitstack8moonmail7AddressE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TP212moonbitstack8moonmail10Attachment(param0, param1, param2, param3, param4) {
  this.name = param0;
  this.media_type = param1;
  this.data = param2;
  this.inline = param3;
  this.id = param4;
}
function _M0DTPC16result6ResultGRPB3MapGsRPB4JsonERP312moonbitstack8moonmail4jmap7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB3MapGsRPB4JsonERP312moonbitstack8moonmail4jmap7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPB3MapGsRPB4JsonERP312moonbitstack8moonmail4jmap7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB3MapGsRPB4JsonERP312moonbitstack8moonmail4jmap7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRPB4JsonRP312moonbitstack8moonmail4jmap7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB4JsonRP312moonbitstack8moonmail4jmap7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPB4JsonRP312moonbitstack8moonmail4jmap7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB4JsonRP312moonbitstack8moonmail4jmap7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRPB5ArrayGRPB4JsonERP312moonbitstack8moonmail4jmap7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRPB4JsonERP312moonbitstack8moonmail4jmap7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPB5ArrayGRPB4JsonERP312moonbitstack8moonmail4jmap7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRPB4JsonERP312moonbitstack8moonmail4jmap7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap10InvocationRP312moonbitstack8moonmail4jmap7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap10InvocationRP312moonbitstack8moonmail4jmap7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap10InvocationRP312moonbitstack8moonmail4jmap7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap10InvocationRP312moonbitstack8moonmail4jmap7RefusedE2Ok.prototype.$tag = 1;
function _M0TP312moonbitstack8moonmail4jmap7Mailbox(param0, param1, param2, param3, param4, param5) {
  this.id = param0;
  this.name = param1;
  this.role = param2;
  this.parent_id = param3;
  this.total = param4;
  this.unread = param5;
}
function _M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap7MailboxERP312moonbitstack8moonmail4jmap7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap7MailboxERP312moonbitstack8moonmail4jmap7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap7MailboxERP312moonbitstack8moonmail4jmap7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap7MailboxERP312moonbitstack8moonmail4jmap7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRPB5ArrayGsERP312moonbitstack8moonmail4jmap7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGsERP312moonbitstack8moonmail4jmap7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPB5ArrayGsERP312moonbitstack8moonmail4jmap7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGsERP312moonbitstack8moonmail4jmap7RefusedE2Ok.prototype.$tag = 1;
function _M0TP312moonbitstack8moonmail4jmap5Email(param0, param1, param2, param3, param4, param5) {
  this.id = param0;
  this.subject = param1;
  this.from = param2;
  this.received_at = param3;
  this.preview = param4;
  this.unread = param5;
}
function _M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap5EmailERP312moonbitstack8moonmail4jmap7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap5EmailERP312moonbitstack8moonmail4jmap7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap5EmailERP312moonbitstack8moonmail4jmap7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap5EmailERP312moonbitstack8moonmail4jmap7RefusedE2Ok.prototype.$tag = 1;
function _M0TP312moonbitstack8moonmail4jmap8Identity(param0, param1, param2) {
  this.id = param0;
  this.name = param1;
  this.email = param2;
}
function _M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap8IdentityERP312moonbitstack8moonmail4jmap7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap8IdentityERP312moonbitstack8moonmail4jmap7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap8IdentityERP312moonbitstack8moonmail4jmap7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap8IdentityERP312moonbitstack8moonmail4jmap7RefusedE2Ok.prototype.$tag = 1;
function _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap7SessionRP312moonbitstack8moonmail4jmap7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap7SessionRP312moonbitstack8moonmail4jmap7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap7SessionRP312moonbitstack8moonmail4jmap7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap7SessionRP312moonbitstack8moonmail4jmap7RefusedE2Ok.prototype.$tag = 1;
function _M0TP312moonbitstack8moonmail4jmap7Session(param0, param1, param2, param3, param4, param5, param6) {
  this.username = param0;
  this.account_id = param1;
  this.api_url = param2;
  this.download_url = param3;
  this.upload_url = param4;
  this.event_source_url = param5;
  this.state = param6;
}
function _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap8ResponseRP312moonbitstack8moonmail4jmap7RefusedE3Err(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap8ResponseRP312moonbitstack8moonmail4jmap7RefusedE3Err.prototype.$tag = 0;
function _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap8ResponseRP312moonbitstack8moonmail4jmap7RefusedE2Ok(param0) {
  this._0 = param0;
}
_M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap8ResponseRP312moonbitstack8moonmail4jmap7RefusedE2Ok.prototype.$tag = 1;
function _M0TP312moonbitstack8moonmail4jmap10Invocation(param0, param1, param2) {
  this.name = param0;
  this.args = param1;
  this.tag = param2;
}
function _M0TP312moonbitstack8moonmail4jmap8Response(param0, param1) {
  this.invocations = param0;
  this.session_state = param1;
}
function _M0TP312moonbitstack8moonmail4jmap7Request(param0, param1) {
  this.capabilities = param0;
  this.calls = param1;
}
function _M0TP312moonbitstack8moonmail4jmap4Call(param0, param1, param2) {
  this.name = param0;
  this.args = param1;
  this.tag = param2;
}
function _M0TP312moonbitstack8moonmail4jmap5Draft(param0, param1, param2, param3, param4, param5) {
  this.from = param0;
  this.to = param1;
  this.cc = param2;
  this.bcc = param3;
  this.subject = param4;
  this.text = param5;
}
function _M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail10AttachmentEE4None() {}
_M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail10AttachmentEE4None.prototype.$tag = 0;
const _M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail10AttachmentEE4None__ = new _M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail10AttachmentEE4None();
function _M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail10AttachmentEE4Some(param0) {
  this._0 = param0;
}
_M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail10AttachmentEE4Some.prototype.$tag = 1;
function _M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail7AddressEE4None() {}
_M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail7AddressEE4None.prototype.$tag = 0;
function _M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail7AddressEE4Some(param0) {
  this._0 = param0;
}
_M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail7AddressEE4Some.prototype.$tag = 1;
const _M0FP076moonbitstack_2fmoonmime_2fLatin1_24as_24_40moonbitstack_2fmoonmime_2eCharset = { method_0: _M0IP212moonbitstack8moonmime6Latin1P212moonbitstack8moonmime7Charset6decode, method_1: _M0IP212moonbitstack8moonmime6Latin1P212moonbitstack8moonmime7Charset6encode };
const _M0FP074moonbitstack_2fmoonmime_2fUtf8_24as_24_40moonbitstack_2fmoonmime_2eCharset = { method_0: _M0IP212moonbitstack8moonmime4Utf8P212moonbitstack8moonmime7Charset6decode, method_1: _M0IP212moonbitstack8moonmime4Utf8P212moonbitstack8moonmime7Charset6encode };
const _M0FP075moonbitstack_2fmoonmime_2fAscii_24as_24_40moonbitstack_2fmoonmime_2eCharset = { method_0: _M0IP212moonbitstack8moonmime5AsciiP212moonbitstack8moonmime7Charset6decode, method_1: _M0IP212moonbitstack8moonmime5AsciiP212moonbitstack8moonmime7Charset6encode };
const _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger = { method_0: _M0IPB13StringBuilderPB6Logger13write__string, method_1: _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE, method_2: _M0IPB13StringBuilderPB6Logger11write__view, method_3: _M0IPB13StringBuilderPB6Logger11write__char, method_4: _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE, method_5: _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE };
const _M0FPB4null = _M0DTPB4Json4Null__;
const _M0MPB4Iter4nextN6constrS191GyE = 0;
const _M0MPB4Iter4nextN6constrS192GyE = 0;
const _M0MPB4Iter4nextN6constrS199GUssEE = 0;
const _M0MPB4Iter4nextN6constrS200GUssEE = 0;
const _M0MPB4Iter4nextN6constrS215GcE = 0;
const _M0MPB4Iter4nextN6constrS216GcE = 0;
const _M0MPB4Iter3newN6constrS251GyE = 0;
const _M0MPB4Iter3newN6constrS257GUssEE = 0;
const _M0MPB4Iter3newN6constrS269GcE = 0;
const _M0FPC15float25f2s__pow5__inv__split__hi = [2305843009213693952n, 1844674407370955161n, 1475739525896764129n, 1180591620717411303n, 1888946593147858085n, 1511157274518286468n, 1208925819614629174n, 1934281311383406679n, 1547425049106725343n, 1237940039285380274n, 1980704062856608439n, 1584563250285286751n, 1267650600228229401n, 2028240960365167042n, 1622592768292133633n, 1298074214633706907n, 2076918743413931051n, 1661534994731144841n, 1329227995784915872n, 2126764793255865396n, 1701411834604692317n, 1361129467683753853n, 2177807148294006166n, 1742245718635204932n, 1393796574908163946n, 2230074519853062314n, 1784059615882449851n, 1427247692705959881n, 2283596308329535809n, 1826877046663628647n, 1461501637330902918n];
const _M0FPC15float20f2s__pow5__split__hi = [1152921504606846976n, 1441151880758558720n, 1801439850948198400n, 2251799813685248000n, 1407374883553280000n, 1759218604441600000n, 2199023255552000000n, 1374389534720000000n, 1717986918400000000n, 2147483648000000000n, 1342177280000000000n, 1677721600000000000n, 2097152000000000000n, 1310720000000000000n, 1638400000000000000n, 2048000000000000000n, 1280000000000000000n, 1600000000000000000n, 2000000000000000000n, 1250000000000000000n, 1562500000000000000n, 1953125000000000000n, 1220703125000000000n, 1525878906250000000n, 1907348632812500000n, 1192092895507812500n, 1490116119384765625n, 1862645149230957031n, 1164153218269348144n, 1455191522836685180n, 1818989403545856475n, 2273736754432320594n, 1421085471520200371n, 1776356839400250464n, 2220446049250313080n, 1387778780781445675n, 1734723475976807094n, 2168404344971008868n, 1355252715606880542n, 1694065894508600678n, 2117582368135750847n, 1323488980084844279n, 1654361225106055349n, 2067951531382569187n, 1292469707114105741n, 1615587133892632177n, 2019483917365790221n, 1262177448353618888n];
const _M0FPC16double14not__a__number = $i64_reinterpret_f64(9221120237041090561n);
const _M0FPC16double8infinity = $i64_reinterpret_f64(9218868437227405312n);
const _M0FPC16double13neg__infinity = $i64_reinterpret_f64(18442240474082181120n);
const _M0FPC28internal7strconv15range__err__str = "value out of range";
const _M0FPC28internal7strconv16syntax__err__str = "invalid syntax";
const _M0FPC28internal7strconv17min__19digit__int = 1000000000000000000n;
const _M0FPC28internal7strconv27eisel__lemire__pow10__table = [18054884314459144840n, 1671618768450675795n, 11284302696536965525n, 1044761730281672372n, 14105378370671206906n, 5917638181279478369n, 17631722963339008632n, 16620419763454123769n, 11019826852086880395n, 10387762352158827356n, 13774783565108600494n, 8373016921771146291n, 17218479456385750618n, 1242899115359157055n, 10761549660241094136n, 5388497965526861063n, 13451937075301367670n, 6735622456908576329n, 16814921344126709587n, 17642900107990496220n, 10509325840079193492n, 8720969558280366185n, 13136657300098991865n, 10901211947850457732n, 16420821625123739831n, 18238200953240460069n, 10263013515702337394n, 18316404623416369399n, 12828766894627921743n, 13672133742415685941n, 16035958618284902179n, 12478481159592219522n, 10022474136428063862n, 5493207715531443249n, 12528092670535079827n, 16089881681269079869n, 15660115838168849784n, 15500666083158961933n, 9787572398855531115n, 9687916301974351208n, 12234465498569413894n, 7498209359040551106n, 15293081873211767368n, 149389661945913074n, 9558176170757354605n, 93368538716195671n, 11947720213446693256n, 4728396691822632493n, 14934650266808366570n, 5910495864778290617n, 9334156416755229106n, 8305745933913819539n, 11667695520944036383n, 1158810380537498616n, 14584619401180045478n, 15283571030954036982n, 18230774251475056848n, 9881091751837770420n, 11394233907171910530n, 6175682344898606512n, 14242792383964888162n, 16942974967978033949n, 17803490479956110203n, 11955346673117766628n, 11127181549972568877n, 5166248661484910190n, 13908976937465711096n, 11069496845283525642n, 17386221171832138870n, 13836871056604407053n, 10866388232395086794n, 4036358391950366504n, 13582985290493858492n, 14268820026792733938n, 16978731613117323115n, 17836025033490917422n, 10611707258198326947n, 8841672636718129437n, 13264634072747908684n, 6440404777470273892n, 16580792590934885855n, 8050505971837842365n, 10362995369334303659n, 11949095260039733334n, 12953744211667879574n, 10324683056622278764n, 16192180264584849468n, 3682481783923072647n, 10120112665365530917n, 11524923151806696212n, 12650140831706913647n, 571095884476206553n, 15812676039633642058n, 14548927910877421904n, 9882922524771026286n, 13704765962725776594n, 12353653155963782858n, 7907585416552444934n, 15442066444954728573n, 661109733835780360n, 9651291528096705358n, 2719036592861056677n, 12064114410120881697n, 12622167777931096654n, 15080143012651102122n, 1942651667131707105n, 9425089382906938826n, 5825843310384704845n, 11781361728633673532n, 16505676174835656864n, 14726702160792091916n, 2185351144835019464n, 18408377700990114895n, 2731688931043774330n, 11505236063118821809n, 8624834609543440812n, 14381545078898527261n, 15392729280356688919n, 17976931348623159077n, 5405853545163697437n, 11235582092889474423n, 5684501474941004850n, 14044477616111843029n, 2493940825248868159n, 17555597020139803786n, 7729112049988473103n, 10972248137587377366n, 9442381049670183593n, 13715310171984221708n, 2579604275232953683n, 17144137714980277135n, 3224505344041192104n, 10715086071862673209n, 8932844867666826921n, 13393857589828341511n, 15777742103010921555n, 16742321987285426889n, 15110491610336264040n, 10463951242053391806n, 2526528228819083169n, 13079939052566739757n, 12381532322878629770n, 16349923815708424697n, 1641857348316123500n, 10218702384817765435n, 12555375888766046947n, 12773377981022206794n, 11082533842530170780n, 15966722476277758493n, 4629795266307937667n, 9979201547673599058n, 5199465050656154994n, 12474001934591998822n, 15722703350174969551n, 15592502418239998528n, 10430007150863936130n, 9745314011399999080n, 6518754469289960081n, 12181642514249998850n, 8148443086612450102n, 15227053142812498563n, 962181821410786819n, 9516908214257811601n, 16742264702877599426n, 11896135267822264502n, 7092772823314835570n, 14870169084777830627n, 18089338065998320271n, 9293855677986144142n, 8999993282035256217n, 11617319597482680178n, 2026619565689294464n, 14521649496853350222n, 11756646493966393888n, 18152061871066687778n, 5472436080603216552n, 11345038669416679861n, 8031958568804398249n, 14181298336770849826n, 14651634229432885715n, 17726622920963562283n, 9091170749936331336n, 11079139325602226427n, 3376138709496513133n, 13848924157002783033n, 18055231442152805128n, 17311155196253478792n, 8733981247408842698n, 10819471997658424245n, 5458738279630526686n, 13524339997073030306n, 11435108867965546262n, 16905424996341287883n, 5070514048102157020n, 10565890622713304927n, 863228270850154185n, 13207363278391631158n, 14914093393844856443n, 16509204097989538948n, 9419244705451294746n, 10318252561243461842n, 15110399977761835024n, 12897815701554327303n, 9664627935347517973n, 16122269626942909129n, 7469098900757009562n, 10076418516839318205n, 16197401859041600736n, 12595523146049147757n, 6411694268519837208n, 15744403932561434696n, 12626303854077184414n, 9840252457850896685n, 7891439908798240259n, 12300315572313620856n, 14475985904425188227n, 15375394465392026070n, 18094982380531485284n, 9609621540870016294n, 6697677969404790399n, 12012026926087520367n, 17595469498610763806n, 15015033657609400459n, 17382650854836066854n, 9384396036005875287n, 8558313775058847832n, 11730495045007344109n, 6086206200396171886n, 14663118806259180136n, 12219443768922602761n, 18328898507823975170n, 15274304711153253452n, 11455561567389984481n, 14158126462898171311n, 14319451959237480602n, 3862600023340550427n, 17899314949046850752n, 14051622066030463842n, 11187071843154281720n, 8782263791269039901n, 13983839803942852150n, 10977829739086299876n, 17479799754928565188n, 4498915137003099037n, 10924874846830353242n, 12035193997481712706n, 13656093558537941553n, 5820620459997365075n, 17070116948172426941n, 11887461593424094248n, 10668823092607766838n, 9735506505103752857n, 13336028865759708548n, 2946011094524915263n, 16670036082199635685n, 3682513868156144079n, 10418772551374772303n, 4607414176811284001n, 13023465689218465379n, 1147581702586717097n, 16279332111523081723n, 15269535183515560084n, 10174582569701926077n, 7237616480483531100n, 12718228212127407596n, 13658706619031801779n, 15897785265159259495n, 17073383273789752224n, 9936115790724537184n, 17588393573759676996n, 12420144738405671481n, 3538747893490044629n, 15525180923007089351n, 9035120885289943691n, 9703238076879430844n, 12564479580947296663n, 12129047596099288555n, 15705599476184120828n, 15161309495124110694n, 15020313326802763131n, 9475818434452569184n, 4776009810824339053n, 11844773043065711480n, 5970012263530423816n, 14805966303832139350n, 7462515329413029771n, 9253728939895087094n, 52386062455755702n, 11567161174868858867n, 9288854614924470436n, 14458951468586073584n, 6999382250228200141n, 18073689335732591980n, 8749227812785250177n, 11296055834832869987n, 14691639419845557168n, 14120069793541087484n, 13752863256379558556n, 17650087241926359355n, 17191079070474448196n, 11031304526203974597n, 8438581409832836170n, 13789130657754968246n, 15159912780718433117n, 17236413322193710308n, 9726518939043265588n, 10772758326371068942n, 15302446373756816800n, 13465947907963836178n, 9904685930341245193n, 16832434884954795223n, 3157485376071780683n, 10520271803096747014n, 8890957387685944783n, 13150339753870933768n, 1890324697752655170n, 16437924692338667210n, 2362905872190818963n, 10273702932711667006n, 6088502188546649756n, 12842128665889583757n, 16833999772538088003n, 16052660832361979697n, 7207441660390446292n, 10032913020226237310n, 16033866083812498692n, 12541141275282796638n, 10818960567910847557n, 15676426594103495798n, 4300328673033783639n, 9797766621314684873n, 16522763475928278486n, 12247208276643356092n, 6818396289628184396n, 15309010345804195115n, 8522995362035230495n, 9568131466127621947n, 3021029092058325107n, 11960164332659527433n, 17611344420355070096n, 14950205415824409292n, 8179122470161673908n, 9343878384890255807n, 14335323580705822000n, 11679847981112819759n, 13307468457454889596n, 14599809976391024699n, 12022649553391224092n, 18249762470488780874n, 10416625923311642211n, 11406101544055488046n, 11122077220497164286n, 14257626930069360058n, 4679224488766679549n, 17822033662586700072n, 15072402647813125244n, 11138771039116687545n, 9420251654883203278n, 13923463798895859431n, 16387000587031392001n, 17404329748619824289n, 15872064715361852097n, 10877706092887390181n, 3002511419460075705n, 13597132616109237726n, 8364825292752482535n, 16996415770136547158n, 1232659579085827361n, 10622759856335341973n, 14605470292210805812n, 13278449820419177467n, 4421779809981343554n, 16598062275523971834n, 915538744049291538n, 10373788922202482396n, 5183897733458195115n, 12967236152753102995n, 6479872166822743894n, 16209045190941378744n, 3488154190101041964n, 10130653244338361715n, 2180096368813151227n, 12663316555422952143n, 16560178516298602746n, 15829145694278690179n, 16088537126945865529n, 9893216058924181362n, 7749492695127472003n, 12366520073655226703n, 463493832054564196n, 15458150092069033378n, 14414425345350368957n, 9661343807543145861n, 13620701859271368502n, 12076679759428932327n, 3190819268807046916n, 15095849699286165408n, 17823582141290972357n, 9434906062053853380n, 11139738838306857723n, 11793632577567316725n, 13924673547883572154n, 14742040721959145907n, 3570783879572301480n, 18427550902448932383n, 18298537904747540562n, 11517219314030582739n, 18354115218108294707n, 14396524142538228424n, 18330958004207980480n, 17995655178172785531n, 4466953431550423984n, 11247284486357990957n, 486002885505321038n, 14059105607947488696n, 5219189625309039202n, 17573882009934360870n, 6523987031636299002n, 10983676256208975543n, 17912549950054850588n, 13729595320261219429n, 17779001419141175331n, 17161994150326524287n, 8388693718644305452n, 10726246343954077679n, 12160462601793772764n, 13407807929942597099n, 10588892233814828051n, 16759759912428246374n, 8624429273841147159n, 10474849945267653984n, 778582277723329070n, 13093562431584567480n, 973227847154161338n, 16366953039480709350n, 1216534808942701673n, 10229345649675443343n, 14595392310871352257n, 12786682062094304179n, 13632554370161802418n, 15983352577617880224n, 12429006944274865118n, 9989595361011175140n, 7768129340171790699n, 12486994201263968925n, 9710161675214738374n, 15608742751579961156n, 16749388112445810871n, 9755464219737475723n, 1244995533423855986n, 12194330274671844653n, 15391302472061983695n, 15242912843339805817n, 5404070034795315907n, 9526820527087378635n, 14906758817815542202n, 11908525658859223294n, 14021762503842039848n, 14885657073574029118n, 8303831092947774002n, 9303535670983768199n, 578208414664970847n, 11629419588729710248n, 14557818573613377271n, 14536774485912137810n, 18197273217016721589n, 18170968107390172263n, 13523219484416126178n, 11356855067118857664n, 15369541205401160717n, 14196068833898572081n, 765182433041899281n, 17745086042373215101n, 5568164059729762005n, 11090678776483259438n, 5785945546544795205n, 13863348470604074297n, 16455803970035769814n, 17329185588255092872n, 6734696907262548556n, 10830740992659433045n, 4209185567039092847n, 13538426240824291306n, 9873167977226253963n, 16923032801030364133n, 3118087934678041646n, 10576895500643977583n, 4254647968387469981n, 13221119375804971979n, 706623942056949572n, 16526399219756214973n, 14718337982853350677n, 10328999512347634358n, 11504804248497038125n, 12911249390434542948n, 5157633273766521849n, 16139061738043178685n, 6447041592208152311n, 10086913586276986678n, 6335244004343789146n, 12608641982846233347n, 17142427042284512241n, 15760802478557791684n, 16816347784428252397n, 9850501549098619803n, 1286845328412881940n, 12313126936373274753n, 15443614715798266137n, 15391408670466593442n, 5469460339465668959n, 9619630419041620901n, 8030098730593431003n, 12024538023802026126n, 14649309431669176658n, 15030672529752532658n, 9088264752731695015n, 9394170331095332911n, 10291851488884697288n, 11742712913869166139n, 8253128342678483706n, 14678391142336457674n, 5704724409920716729n, 18347988927920572092n, 16354277549255671720n, 11467493079950357558n, 998051431430019017n, 14334366349937946947n, 10470936326142299579n, 17917957937422433684n, 8476984389250486570n, 11198723710889021052n, 14521487280136329914n, 13998404638611276315n, 18151859100170412392n, 17498005798264095394n, 18078137856785627587n, 10936253623915059621n, 15910522178918405146n, 13670317029893824527n, 6053094668365842720n, 17087896287367280659n, 2954682317029915496n, 10679935179604550411n, 17987577512639554849n, 13349918974505688014n, 17872785872372055657n, 16687398718132110018n, 13117610303610293764n, 10429624198832568761n, 12810192458183821506n, 13037030248540710952n, 2177682517447613171n, 16296287810675888690n, 2722103146809516464n, 10185179881672430431n, 6313000485183335694n, 12731474852090538039n, 3279564588051781713n, 15914343565113172548n, 17934513790346890853n, 9946464728195732843n, 1985699082112030975n, 12433080910244666053n, 16317181907922202431n, 15541351137805832567n, 6561419329620589327n, 9713344461128645354n, 11018416108653950185n, 12141680576410806693n, 4549648098962661924n, 15177100720513508366n, 10298746142130715309n, 9485687950320942729n, 1825030320404309164n, 11857109937901178411n, 6892973918932774359n, 14821387422376473014n, 4004531380238580045n, 9263367138985295633n, 16337890167931276240n, 11579208923731619542n, 6587304654631931588n, 14474011154664524427n, 17457502855144690293n, 18092513943330655534n, 17210192550503474962n, 11307821214581659709n, 6144684325637283947n, 14134776518227074636n, 12292541425473992838n, 17668470647783843295n, 15365676781842491048n, 11042794154864902059n, 16521077016292638761n, 13803492693581127574n, 16039660251938410547n, 17254365866976409468n, 10826203278068237376n, 10783978666860255917n, 15989749085647424168n, 13479973333575319897n, 6152128301777116498n, 16849966666969149871n, 12301846395648783526n, 10531229166855718669n, 14606183024921571560n, 13164036458569648337n, 4422670725869800738n, 16455045573212060421n, 10140024425764638826n, 10284403483257537763n, 8643358275316593218n, 12855504354071922204n, 6192511825718353619n, 16069380442589902755n, 7740639782147942024n, 10043362776618689222n, 2532056854628769813n, 12554203470773361527n, 12388443105140738074n, 15692754338466701909n, 10873867862998534689n, 9807971461541688693n, 9102010423587778132n, 12259964326927110866n, 15989199047912110569n, 15324955408658888583n, 10763126773035362404n, 9578097130411805364n, 13644483260788183358n, 11972621413014756705n, 17055604075985229198n, 14965776766268445882n, 7484447039699372786n, 9353610478917778676n, 9289465418239495895n, 11692013098647223345n, 11611831772799369869n, 14615016373309029182n, 679731660717048624n, 18268770466636286477n, 10073036612751086588n, 11417981541647679048n, 8601490892183123069n, 14272476927059598810n, 10751863615228903837n, 17840596158824498513n, 4216457482181353988n, 11150372599265311570n, 14164500972431816002n, 13937965749081639463n, 8482254178684994195n, 17422457186352049329n, 5991131704928854840n, 10889035741470030830n, 15273672361649004035n, 13611294676837538538n, 9868718415206479236n, 17014118346046923173n, 3112525982153323237n, 10633823966279326983n, 4251171748059520975n, 13292279957849158729n, 702278666647013314n, 16615349947311448411n, 5489534351736154547n, 10384593717069655257n, 1125115960621402640n, 12980742146337069071n, 6018080969204141204n, 16225927682921336339n, 2910915193077788601n, 10141204801825835211n, 17960223060169475539n, 12676506002282294014n, 17838592806784456520n, 15845632502852867518n, 13074868971625794843n, 9903520314283042199n, 3560107088838733872n, 12379400392853802748n, 18285191916330581053n, 15474250491067253436n, 4409745821703674700n, 9671406556917033397n, 11979463175419572495n, 12089258196146291747n, 1139270913992301907n, 15111572745182864683n, 15259146697772541096n, 9444732965739290427n, 7231123676894144233n, 11805916207174113034n, 4427218577690292387n, 14757395258967641292n, 14757395258967641292n, 9223372036854775808n, 0n, 11529215046068469760n, 0n, 14411518807585587200n, 0n, 18014398509481984000n, 0n, 11258999068426240000n, 0n, 14073748835532800000n, 0n, 17592186044416000000n, 0n, 10995116277760000000n, 0n, 13743895347200000000n, 0n, 17179869184000000000n, 0n, 10737418240000000000n, 0n, 13421772800000000000n, 0n, 16777216000000000000n, 0n, 10485760000000000000n, 0n, 13107200000000000000n, 0n, 16384000000000000000n, 0n, 10240000000000000000n, 0n, 12800000000000000000n, 0n, 16000000000000000000n, 0n, 10000000000000000000n, 0n, 12500000000000000000n, 0n, 15625000000000000000n, 0n, 9765625000000000000n, 0n, 12207031250000000000n, 0n, 15258789062500000000n, 0n, 9536743164062500000n, 0n, 11920928955078125000n, 0n, 14901161193847656250n, 0n, 9313225746154785156n, 4611686018427387904n, 11641532182693481445n, 5764607523034234880n, 14551915228366851806n, 11817445422220181504n, 18189894035458564758n, 5548434740920451072n, 11368683772161602973n, 17302829768357445632n, 14210854715202003717n, 7793479155164643328n, 17763568394002504646n, 14353534962383192064n, 11102230246251565404n, 4359273333062107136n, 13877787807814456755n, 5449091666327633920n, 17347234759768070944n, 2199678564482154496n, 10842021724855044340n, 1374799102801346560n, 13552527156068805425n, 1718498878501683200n, 16940658945086006781n, 6759809616554491904n, 10587911840678754238n, 6530724019560251392n, 13234889800848442797n, 17386777061305090048n, 16543612251060553497n, 7898413271349198848n, 10339757656912845935n, 16465723340661719040n, 12924697071141057419n, 15970468157399760896n, 16155871338926321774n, 15351399178322313216n, 10097419586828951109n, 4982938468024057856n, 12621774483536188886n, 10840359103457460224n, 15777218104420236108n, 4327076842467049472n, 9860761315262647567n, 11927795063396681728n, 12325951644078309459n, 10298057810818464256n, 15407439555097886824n, 8260886245095692416n, 9629649721936179265n, 5163053903184807760n, 12037062152420224081n, 11065503397408397604n, 15046327690525280101n, 18443565265187884909n, 9403954806578300063n, 13833071299956122020n, 11754943508222875079n, 12679653106517764621n, 14693679385278593849n, 11237880364719817872n, 18367099231598242312n, 212292400617608628n, 11479437019748901445n, 132682750386005392n, 14349296274686126806n, 4777539456409894645n, 17936620343357658507n, 15195296357367144114n, 11210387714598536567n, 7191217214140771119n, 14012984643248170709n, 4377335499248575995n, 17516230804060213386n, 10083355392488107898n, 10947644252537633366n, 10913783138732455340n, 13684555315672041708n, 4418856886560793367n, 17105694144590052135n, 5523571108200991709n, 10691058840368782584n, 10369760970266701674n, 13363823550460978230n, 12962201212833377092n, 16704779438076222788n, 6979379479186945558n, 10440487148797639242n, 13585484211346616781n, 13050608935997049053n, 7758483227328495169n, 16313261169996311316n, 14309790052588006865n, 10195788231247694572n, 18166990819722280098n, 12744735289059618216n, 4261994450943298507n, 15930919111324522770n, 5327493063679123134n, 9956824444577826731n, 7941369183226839863n, 12446030555722283414n, 5315025460606161924n, 15557538194652854267n, 15867153862612478214n, 9723461371658033917n, 7611128154919104931n, 12154326714572542396n, 14125596212076269068n, 15192908393215677995n, 17656995265095336336n, 9495567745759798747n, 8729779031470891258n, 11869459682199748434n, 6300537770911226168n, 14836824602749685542n, 17099044250493808518n, 9273015376718553464n, 6075216638131242420n, 11591269220898191830n, 7594020797664053025n, 14489086526122739788n, 269153960225290473n, 18111358157653424735n, 336442450281613091n, 11319598848533390459n, 7127805559067090038n, 14149498560666738074n, 4298070930406474644n, 17686873200833422592n, 14595960699862869113n, 11054295750520889120n, 9122475437414293195n, 13817869688151111400n, 11403094296767866494n, 17272337110188889250n, 14253867870959833118n, 10795210693868055781n, 13520353437777283602n, 13494013367335069727n, 3065383741939440791n, 16867516709168837158n, 17666787732706464701n, 10542197943230523224n, 6430056314514152534n, 13177747429038154030n, 8037570393142690668n, 16472184286297692538n, 823590954573587527n, 10295115178936057836n, 5126430365035880108n, 12868893973670072295n, 6408037956294850135n, 16086117467087590369n, 3398361426941174765n, 10053823416929743980n, 13653190937906703988n, 12567279271162179975n, 17066488672383379985n, 15709099088952724969n, 16721424822051837077n, 9818186930595453106n, 3533361486141316317n, 12272733663244316382n, 13640073894531421205n, 15340917079055395478n, 7826720331309500698n, 9588073174409622174n, 280014188641050032n, 11985091468012027717n, 9573389772656088348n, 14981364335015034646n, 16578423234247498339n, 9363352709384396654n, 5749828502977298558n, 11704190886730495817n, 16410657665576399005n, 14630238608413119772n, 6678264026688335045n, 18287798260516399715n, 8347830033360418806n, 11429873912822749822n, 2911550761636567802n, 14287342391028437277n, 12862810488900485560n, 17859177988785546597n, 2243455055843443238n, 11161986242990966623n, 3708002419115845976n, 13952482803738708279n, 23317005467419566n, 17440603504673385348n, 13864204312116438170n, 10900377190420865842n, 17888499731927549664n, 13625471488026082303n, 13137252628054661272n, 17031839360032602879n, 11809879766640938686n, 10644899600020376799n, 14298703881791668535n, 13306124500025470999n, 13261693833812197764n, 16632655625031838749n, 11965431273837859301n, 10395409765644899218n, 9784237555362356015n, 12994262207056124023n, 3006924907348169211n, 16242827758820155028n, 17593714189467375226n, 10151767349262596893n, 1772699331562333708n, 12689709186578246116n, 6827560182880305039n, 15862136483222807645n, 8534450228600381299n, 9913835302014254778n, 7639874402088932264n, 12392294127517818473n, 326470965756389522n, 15490367659397273091n, 5019774725622874806n, 9681479787123295682n, 831516194300602802n, 12101849733904119602n, 10262767279730529310n, 15127312167380149503n, 3605087062808385830n, 9454570104612593439n, 9170708441896323000n, 11818212630765741799n, 6851699533943015846n, 14772765788457177249n, 3952938399001381903n, 9232978617785735780n, 13999801545444333449n, 11541223272232169725n, 17499751931805416812n, 14426529090290212157n, 8039631859474607303n, 18033161362862765196n, 14661225842770647033n, 11270725851789228247n, 18386638188586430203n, 14088407314736535309n, 18371611717305649850n, 17610509143420669137n, 9129456591349898601n, 11006568214637918210n, 17235125415662156385n, 13758210268297397763n, 12320534732722919674n, 17197762835371747204n, 10788982397476261688n, 10748601772107342002n, 15966486035277439363n, 13435752215134177503n, 10734735507242023396n, 16794690268917721879n, 8806733365625141341n, 10496681418073576174n, 12421737381156795194n, 13120851772591970218n, 6303799689591218185n, 16401064715739962772n, 17103121648843798539n, 10250665447337476733n, 1466078993672598279n, 12813331809171845916n, 6444284760518135752n, 16016664761464807395n, 8055355950647669691n, 10010415475915504622n, 2728754459941099604n, 12513019344894380777n, 12634315111781150314n, 15641274181117975972n, 1957835834444274180n, 9775796363198734982n, 10447019433382447170n, 12219745453998418728n, 3835402254873283155n, 15274681817498023410n, 4794252818591603944n, 9546676135936264631n, 7608094030047140369n, 11933345169920330789n, 4898431519131537557n, 14916681462400413486n, 10734725417341809851n, 9322925914000258429n, 2097517367411243253n, 11653657392500323036n, 7233582727691441970n, 14567071740625403795n, 9041978409614302462n, 18208839675781754744n, 6690786993590490174n, 11380524797363596715n, 4181741870994056359n, 14225655996704495894n, 615491320315182544n, 17782069995880619867n, 9992736187248753989n, 11113793747425387417n, 3939617107816777291n, 13892242184281734271n, 9536207403198359517n, 17365302730352167839n, 7308573235570561493n, 10853314206470104899n, 11485387299872682789n, 13566642758087631124n, 9745048106413465582n, 16958303447609538905n, 12181310133016831978n, 10598939654755961816n, 695789805494438130n, 13248674568444952270n, 869737256868047663n, 16560843210556190337n, 10310543607939835386n, 10350527006597618960n, 17973304801030866876n, 12938158758247023701n, 4019886927579031980n, 16172698447808779626n, 9636544677901177879n, 10107936529880487266n, 10634526442115624078n, 12634920662350609083n, 4069786015789754290n, 15793650827938261354n, 475546501309804958n, 9871031767461413346n, 4908902581746016003n, 12338789709326766682n, 15359500264037295811n, 15423487136658458353n, 9976003293191843956n, 9639679460411536470n, 17764217104313372233n, 12049599325514420588n, 12981899343536939483n, 15061999156893025735n, 16227374179421174354n, 9413749473058141084n, 17059637889779315827n, 11767186841322676356n, 2877803288514593168n, 14708983551653345445n, 3597254110643241460n, 18386229439566681806n, 9108253656731439729n, 11491393399729176129n, 1080972517029761926n, 14364241749661470161n, 5962901664714590312n, 17955302187076837701n, 12065313099320625794n, 11222063866923023563n, 9846663696289085073n, 14027579833653779454n, 7696643601933968437n, 17534474792067224318n, 397432465562684739n, 10959046745042015198n, 14083453346258841674n, 13698808431302518998n, 8380944645968776284n, 17123510539128148748n, 1252808770606194547n, 10702194086955092967n, 10006377518483647400n, 13377742608693866209n, 7896285879677171346n, 16722178260867332761n, 14482043368023852087n, 10451361413042082976n, 2133748077373825698n, 13064201766302603720n, 2667185096717282123n, 16330252207878254650n, 3333981370896602653n, 10206407629923909156n, 6695424375237764562n, 12758009537404886445n, 8369280469047205703n, 15947511921756108056n, 15073286604736395033n, 9967194951097567535n, 9420804127960246895n, 12458993688871959419n, 7164319141522920715n, 15573742111089949274n, 4343712908476262990n, 9733588819431218296n, 7326506586225052273n, 12166986024289022870n, 9158133232781315341n, 15208732530361278588n, 2224294504121868368n, 9505457831475799117n, 10613556101930943538n, 11881822289344748896n, 17878631145841067327n, 14852277861680936121n, 3901544858591782542n, 9282673663550585075n, 13967680582688333849n, 11603342079438231344n, 12847914709933029407n, 14504177599297789180n, 16059893387416286759n, 18130221999122236476n, 1628122660560806833n, 11331388749451397797n, 10240948699705280078n, 14164235936814247246n, 17412871893058988002n, 17705294921017809058n, 12542717829468959195n, 11065809325636130661n, 12450884661845487401n, 13832261657045163327n, 1728547772024695539n, 17290327071306454158n, 15995742770313033136n, 10806454419566533849n, 5385653213018257806n, 13508068024458167311n, 11343752534700210161n, 16885085030572709139n, 9568004649947874797n, 10553178144107943212n, 3674159897003727796n, 13191472680134929015n, 4592699871254659745n, 16489340850168661269n, 1129188820640936778n, 10305838031355413293n, 3011586022114279438n, 12882297539194266616n, 8376168546070237202n, 16102871923992833270n, 10470210682587796502n, 10064294952495520794n, 1932195658189984910n, 12580368690619400992n, 11638616609592256945n, 15725460863274251240n, 14548270761990321182n, 9828413039546407025n, 9092669226243950738n, 12285516299433008781n, 15977522551232326327n, 15356895374291260977n, 6136845133758244197n, 9598059608932038110n, 15364743254667372383n, 11997574511165047638n, 9982557031479439671n, 14996968138956309548n, 3254824252494523781n, 9373105086847693467n, 11257637194663853171n, 11716381358559616834n, 9460360474902428559n, 14645476698199521043n, 2602078556773259891n, 18306845872749401303n, 17087656251248738576n, 11441778670468375814n, 17597314184671543466n, 14302223338085469768n, 12773270693984653525n, 17877779172606837210n, 15966588367480816906n, 11173611982879273256n, 14590803748102898470n, 13967014978599091570n, 18238504685128623088n, 17458768723248864463n, 13574758819556003052n, 10911730452030540289n, 15401753289863583763n, 13639663065038175362n, 5417133557047315992n, 17049578831297719202n, 15994788983163920798n, 10655986769561074501n, 14608429132904838403n, 13319983461951343127n, 4425478360848884291n, 16649979327439178909n, 920161932633717460n, 10406237079649486818n, 2880944217109767365n, 13007796349561858522n, 12824552308241985014n, 16259745436952323153n, 6807318348447705459n, 10162340898095201970n, 15783789013848285672n, 12702926122619002463n, 10506364230455581282n, 15878657653273753079n, 8521269269642088699n, 9924161033296095674n, 12243322321167387293n, 12405201291620119593n, 6080780864604458308n, 15506501614525149491n, 12212662099182960789n, 9691563509078218432n, 5327070802775656541n, 12114454386347773040n, 6658838503469570676n, 15143067982934716300n, 8323548129336963345n, 9464417489334197687n, 14425589617690377899n, 11830521861667747109n, 13420301003685584469n, 14788152327084683887n, 2940318199324816875n, 9242595204427927429n, 8755227902219092403n, 11553244005534909286n, 15555720896201253407n, 14441555006918636608n, 10221279083396790951n, 18051943758648295760n, 12776598854245988689n, 11282464849155184850n, 7985374283903742931n, 14103081061443981063n, 758345818024902856n, 17628851326804976328n, 14782990327813292282n, 11018032079253110205n, 9239368954883307676n, 13772540099066387756n, 16160897212031522499n, 17215675123832984696n, 1754377441329851508n, 10759796952395615435n, 1096485900831157192n, 13449746190494519293n, 15205665431321110202n, 16812182738118149117n, 5172023733869224041n, 10507614211323843198n, 5538357842881958977n, 13134517764154803997n, 16146319340457224530n, 16418147205193504997n, 6347841120289366950n, 10261342003245940623n, 6273243709394548296n, 12826677504057425779n, 3229868618315797466n, 16033346880071782223n, 17872393828176910545n, 10020841800044863889n, 18087775170251650946n, 12526052250056079862n, 8774660907532399971n, 15657565312570099828n, 1744954097560724156n, 9785978320356312392n, 10313968347830228405n, 12232472900445390490n, 12892460434787785506n, 15290591125556738113n, 6892203506629956075n, 9556619453472961320n, 15836842237712192307n, 11945774316841201651n, 1349308723430688768n, 14932217896051502063n, 15521693959570524672n, 9332636185032188789n, 16618587752372659776n, 11665795231290235987n, 6938176635183661008n, 14582244039112794984n, 4061034775552188356n, 18227805048890993730n, 5076293469440235445n, 11392378155556871081n, 7784369436827535057n, 14240472694446088851n, 14342147814461806725n, 17800590868057611064n, 13315998749649870503n, 11125369292536006915n, 8322499218531169064n, 13906711615670008644n, 5791438004736573426n, 17383389519587510805n, 7239297505920716783n, 10864618449742194253n, 6830403950414141941n, 13580773062177742816n, 13149690956445065330n, 16975966327722178520n, 16437113695556331663n, 10609978954826361575n, 10273196059722707289n, 13262473693532951969n, 8229809056225996208n, 16578092116916189961n, 14898947338709883164n, 10361307573072618726n, 2394313059052595121n, 12951634466340773407n, 12216263360670519709n, 16189543082925966759n, 10658643182410761733n, 10118464426828729224n, 13579181016647807939n, 12648080533535911530n, 16973976270809759924n, 15810100666919889413n, 11994098301657424097n, 9881312916824930883n, 9802154447749584012n, 12351641146031163604n, 7641007041259592112n, 15439551432538954505n, 9551258801574490140n, 9649719645336846565n, 17498751797052526097n, 12062149556671058207n, 8038381691033493909n, 15077686945838822759n, 5436291095364479483n];
const _M0FPC28internal7strconv12double__info = new _M0TPC28internal7strconv9FloatInfo(52, 11, -1023);
const _M0FPC28internal7strconv25min__exponent__fast__path = 18446744073709551594n;
const _M0FPC28internal7strconv25max__exponent__fast__path = 22n;
const _M0FPC28internal7strconv36max__exponent__disguised__fast__path = 37n;
const _M0FPC28internal7strconv25max__mantissa__fast__path = 9007199254740992n;
const _M0FPC28internal7strconv6powtab = [1, 3, 6, 9, 13, 16, 19, 23, 26, 29, 33, 36, 39, 43, 46, 49, 53, 56, 59];
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1981 = { _0: 0, _1: "" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1982 = { _0: 1, _1: "5" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1983 = { _0: 1, _1: "25" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1984 = { _0: 1, _1: "125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1985 = { _0: 2, _1: "625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1986 = { _0: 2, _1: "3125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1987 = { _0: 2, _1: "15625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1988 = { _0: 3, _1: "78125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1989 = { _0: 3, _1: "390625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1990 = { _0: 3, _1: "1953125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1991 = { _0: 4, _1: "9765625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1992 = { _0: 4, _1: "48828125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1993 = { _0: 4, _1: "244140625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1994 = { _0: 4, _1: "1220703125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1995 = { _0: 5, _1: "6103515625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1996 = { _0: 5, _1: "30517578125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1997 = { _0: 5, _1: "152587890625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1998 = { _0: 6, _1: "762939453125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1999 = { _0: 6, _1: "3814697265625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2000 = { _0: 6, _1: "19073486328125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2001 = { _0: 7, _1: "95367431640625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2002 = { _0: 7, _1: "476837158203125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2003 = { _0: 7, _1: "2384185791015625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2004 = { _0: 7, _1: "11920928955078125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2005 = { _0: 8, _1: "59604644775390625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2006 = { _0: 8, _1: "298023223876953125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2007 = { _0: 8, _1: "1490116119384765625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2008 = { _0: 9, _1: "7450580596923828125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2009 = { _0: 9, _1: "37252902984619140625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2010 = { _0: 9, _1: "186264514923095703125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2011 = { _0: 10, _1: "931322574615478515625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2012 = { _0: 10, _1: "4656612873077392578125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2013 = { _0: 10, _1: "23283064365386962890625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2014 = { _0: 10, _1: "116415321826934814453125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2015 = { _0: 11, _1: "582076609134674072265625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2016 = { _0: 11, _1: "2910383045673370361328125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2017 = { _0: 11, _1: "14551915228366851806640625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2018 = { _0: 12, _1: "72759576141834259033203125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2019 = { _0: 12, _1: "363797880709171295166015625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2020 = { _0: 12, _1: "1818989403545856475830078125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2021 = { _0: 13, _1: "9094947017729282379150390625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2022 = { _0: 13, _1: "45474735088646411895751953125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2023 = { _0: 13, _1: "227373675443232059478759765625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2024 = { _0: 13, _1: "1136868377216160297393798828125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2025 = { _0: 14, _1: "5684341886080801486968994140625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2026 = { _0: 14, _1: "28421709430404007434844970703125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2027 = { _0: 14, _1: "142108547152020037174224853515625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2028 = { _0: 15, _1: "710542735760100185871124267578125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2029 = { _0: 15, _1: "3552713678800500929355621337890625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2030 = { _0: 15, _1: "17763568394002504646778106689453125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2031 = { _0: 16, _1: "88817841970012523233890533447265625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2032 = { _0: 16, _1: "444089209850062616169452667236328125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2033 = { _0: 16, _1: "2220446049250313080847263336181640625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2034 = { _0: 16, _1: "11102230246251565404236316680908203125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2035 = { _0: 17, _1: "55511151231257827021181583404541015625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2036 = { _0: 17, _1: "277555756156289135105907917022705078125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2037 = { _0: 17, _1: "1387778780781445675529539585113525390625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2038 = { _0: 18, _1: "6938893903907228377647697925567626953125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2039 = { _0: 18, _1: "34694469519536141888238489627838134765625" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2040 = { _0: 18, _1: "173472347597680709441192448139190673828125" };
const _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2041 = { _0: 19, _1: "867361737988403547205962240695953369140625" };
const _M0FPC28internal7strconv19left__shift__cheats = [_M0FPC28internal7strconv19left__shift__cheatsN5tupleS1981, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1982, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1983, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1984, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1985, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1986, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1987, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1988, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1989, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1990, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1991, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1992, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1993, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1994, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1995, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1996, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1997, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1998, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS1999, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2000, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2001, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2002, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2003, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2004, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2005, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2006, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2007, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2008, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2009, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2010, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2011, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2012, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2013, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2014, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2015, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2016, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2017, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2018, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2019, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2020, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2021, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2022, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2023, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2024, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2025, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2026, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2027, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2028, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2029, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2030, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2031, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2032, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2033, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2034, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2035, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2036, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2037, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2038, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2039, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2040, _M0FPC28internal7strconv19left__shift__cheatsN5tupleS2041];
const _M0FPC28internal7strconv10int__pow10 = [1n, 10n, 100n, 1000n, 10000n, 100000n, 1000000n, 10000000n, 100000000n, 1000000000n, 10000000000n, 100000000000n, 1000000000000n, 10000000000000n, 100000000000000n, 1000000000000000n];
const _M0FPC28internal7strconv5table = [1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, 10000000000, 100000000000, 1e+012, 1e+013, 1e+014, 1e+015, 1e+016, 1e+017, 1e+018, 1e+019, 1e+020, 1e+021, 1e+022, 0, 0, 0, 0, 0, 0, 0, 0, 0];
const _M0FPC28internal7strconv12checked__mulN6constrS2177 = 0n;
const _M0FPC14json17int__pow10__table = [1n, 10n, 100n, 1000n, 10000n, 100000n, 1000000n, 10000000n, 100000000n, 1000000000n, 10000000000n, 100000000000n, 1000000000000n, 10000000000000n, 100000000000000n, 1000000000000000n];
const _M0FPC14json12pow10__table = [1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000, 10000000000, 100000000000, 1e+012, 1e+013, 1e+014, 1e+015, 1e+016, 1e+017, 1e+018, 1e+019, 1e+020, 1e+021, 1e+022, 0, 0, 0, 0, 0, 0, 0, 0, 0];
const _M0FPC14json12checked__mulN6constrS2449 = 0n;
const _M0FP312moonbitstack8moonbase6base647letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
const _M0FP412moonbitstack9mooncrypt4hash4sha25iv224 = [-1056596264, 914150663, 812702999, -150054599, -4191439, 1750603025, 1694076839, -1090891868];
const _M0FP412moonbitstack9mooncrypt4hash4sha25iv256 = [1779033703, -1150833019, 1013904242, -1521486534, 1359893119, -1694144372, 528734635, 1541459225];
const _M0FP412moonbitstack9mooncrypt4hash4sha25iv384 = [14680500436340154072n, 7105036623409894663n, 10473403895298186519n, 1526699215303891257n, 7436329637833083697n, 10282925794625328401n, 15784041429090275239n, 5167115440072839076n];
const _M0FP412moonbitstack9mooncrypt4hash4sha25iv512 = [7640891576956012808n, 13503953896175478587n, 4354685564936845355n, 11912009170470909681n, 5840696475078001361n, 11170449401992604703n, 2270897969802886507n, 6620516959819538809n];
const _M0FP412moonbitstack9mooncrypt4hash4sha210iv512__224 = [10105294471447203234n, 8350123849800275158n, 2160240930085379202n, 7466358040605728719n, 1111592415079452072n, 8638871050018654530n, 4583966954114332360n, 1230299281376055969n];
const _M0FP412moonbitstack9mooncrypt4hash4sha210iv512__256 = [2463787394917988140n, 11481187982095705282n, 2563595384472711505n, 10824532655140301501n, 10819967247969091555n, 13717434660681038226n, 3098927326965381290n, 1060366662362279074n];
const _M0FP412moonbitstack9mooncrypt4hash4sha23k32 = [1116352408, 1899447441, -1245643825, -373957723, 961987163, 1508970993, -1841331548, -1424204075, -670586216, 310598401, 607225278, 1426881987, 1925078388, -2132889090, -1680079193, -1046744716, -459576895, -272742522, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, -1740746414, -1473132947, -1341970488, -1084653625, -958395405, -710438585, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, -2117940946, -1838011259, -1564481375, -1474664885, -1035236496, -949202525, -778901479, -694614492, -200395387, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, -2067236844, -1933114872, -1866530822, -1538233109, -1090935817, -965641998];
const _M0FP412moonbitstack9mooncrypt4hash4sha23k64 = [4794697086780616226n, 8158064640168781261n, 13096744586834688815n, 16840607885511220156n, 4131703408338449720n, 6480981068601479193n, 10538285296894168987n, 12329834152419229976n, 15566598209576043074n, 1334009975649890238n, 2608012711638119052n, 6128411473006802146n, 8268148722764581231n, 9286055187155687089n, 11230858885718282805n, 13951009754708518548n, 16472876342353939154n, 17275323862435702243n, 1135362057144423861n, 2597628984639134821n, 3308224258029322869n, 5365058923640841347n, 6679025012923562964n, 8573033837759648693n, 10970295158949994411n, 12119686244451234320n, 12683024718118986047n, 13788192230050041572n, 14330467153632333762n, 15395433587784984357n, 489312712824947311n, 1452737877330783856n, 2861767655752347644n, 3322285676063803686n, 5560940570517711597n, 5996557281743188959n, 7280758554555802590n, 8532644243296465576n, 9350256976987008742n, 10552545826968843579n, 11727347734174303076n, 12113106623233404929n, 14000437183269869457n, 14369950271660146224n, 15101387698204529176n, 15463397548674623760n, 17586052441742319658n, 1182934255886127544n, 1847814050463011016n, 2177327727835720531n, 2830643537854262169n, 3796741975233480872n, 4115178125766777443n, 5681478168544905931n, 6601373596472566643n, 7507060721942968483n, 8399075790359081724n, 8693463985226723168n, 9568029438360202098n, 10144078919501101548n, 10430055236837252648n, 11840083180663258601n, 13761210420658862357n, 14299343276471374635n, 14566680578165727644n, 15097957966210449927n, 16922976911328602910n, 17689382322260857208n, 500013540394364858n, 748580250866718886n, 1242879168328830382n, 1977374033974150939n, 2944078676154940804n, 3659926193048069267n, 4368137639120453308n, 4836135668995329356n, 5532061633213252278n, 6448918945643986474n, 6902733635092675308n, 7801388544844847127n];
const _M0FP212moonbitstack8moondate8weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
const _M0FP212moonbitstack8moondate6months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
const _M0FP212moonbitstack8moondate8midnight = new _M0TP212moonbitstack8moondate4Time(0, 0, 0, 0);
const _M0FP212moonbitstack8moondate10long__days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
const _M0FP212moonbitstack8moondate12long__months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
const _M0FP212moonbitstack8moonmime8fallback = "application/octet-stream";
const _M0FP212moonbitstack8moonmime5typesN5tupleS3160 = { _0: "txt", _1: "text/plain" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3161 = { _0: "text", _1: "text/plain" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3162 = { _0: "log", _1: "text/plain" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3163 = { _0: "conf", _1: "text/plain" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3164 = { _0: "ini", _1: "text/plain" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3165 = { _0: "html", _1: "text/html" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3166 = { _0: "htm", _1: "text/html" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3167 = { _0: "css", _1: "text/css" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3168 = { _0: "csv", _1: "text/csv" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3169 = { _0: "md", _1: "text/markdown" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3170 = { _0: "markdown", _1: "text/markdown" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3171 = { _0: "js", _1: "text/javascript" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3172 = { _0: "mjs", _1: "text/javascript" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3173 = { _0: "json", _1: "application/json" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3174 = { _0: "xml", _1: "application/xml" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3175 = { _0: "xsl", _1: "application/xml" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3176 = { _0: "yaml", _1: "application/yaml" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3177 = { _0: "yml", _1: "application/yaml" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3178 = { _0: "toml", _1: "application/toml" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3179 = { _0: "rst", _1: "text/x-rst" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3180 = { _0: "tex", _1: "application/x-tex" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3181 = { _0: "vtt", _1: "text/vtt" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3182 = { _0: "srt", _1: "application/x-subrip" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3183 = { _0: "sql", _1: "application/sql" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3184 = { _0: "ics", _1: "text/calendar" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3185 = { _0: "rtf", _1: "application/rtf" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3186 = { _0: "sh", _1: "text/x-shellscript" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3187 = { _0: "py", _1: "text/x-python" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3188 = { _0: "png", _1: "image/png" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3189 = { _0: "apng", _1: "image/apng" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3190 = { _0: "jpg", _1: "image/jpeg" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3191 = { _0: "jpeg", _1: "image/jpeg" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3192 = { _0: "jpe", _1: "image/jpeg" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3193 = { _0: "gif", _1: "image/gif" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3194 = { _0: "webp", _1: "image/webp" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3195 = { _0: "svg", _1: "image/svg+xml" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3196 = { _0: "svgz", _1: "image/svg+xml" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3197 = { _0: "ico", _1: "image/vnd.microsoft.icon" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3198 = { _0: "bmp", _1: "image/bmp" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3199 = { _0: "tif", _1: "image/tiff" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3200 = { _0: "tiff", _1: "image/tiff" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3201 = { _0: "avif", _1: "image/avif" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3202 = { _0: "heic", _1: "image/heif" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3203 = { _0: "heif", _1: "image/heif" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3204 = { _0: "jxl", _1: "image/jxl" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3205 = { _0: "mp3", _1: "audio/mpeg" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3206 = { _0: "wav", _1: "audio/wav" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3207 = { _0: "ogg", _1: "audio/ogg" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3208 = { _0: "oga", _1: "audio/ogg" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3209 = { _0: "m4a", _1: "audio/mp4" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3210 = { _0: "aac", _1: "audio/aac" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3211 = { _0: "flac", _1: "audio/flac" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3212 = { _0: "mid", _1: "audio/midi" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3213 = { _0: "midi", _1: "audio/midi" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3214 = { _0: "opus", _1: "audio/opus" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3215 = { _0: "weba", _1: "audio/webm" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3216 = { _0: "mp4", _1: "video/mp4" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3217 = { _0: "m4v", _1: "video/mp4" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3218 = { _0: "webm", _1: "video/webm" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3219 = { _0: "mov", _1: "video/quicktime" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3220 = { _0: "avi", _1: "video/x-msvideo" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3221 = { _0: "mpeg", _1: "video/mpeg" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3222 = { _0: "mpg", _1: "video/mpeg" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3223 = { _0: "mkv", _1: "video/x-matroska" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3224 = { _0: "ogv", _1: "video/ogg" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3225 = { _0: "ts", _1: "video/mp2t" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3226 = { _0: "3gp", _1: "video/3gpp" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3227 = { _0: "woff", _1: "font/woff" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3228 = { _0: "woff2", _1: "font/woff2" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3229 = { _0: "ttf", _1: "font/ttf" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3230 = { _0: "otf", _1: "font/otf" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3231 = { _0: "eot", _1: "application/vnd.ms-fontobject" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3232 = { _0: "pdf", _1: "application/pdf" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3233 = { _0: "doc", _1: "application/msword" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3234 = { _0: "docx", _1: "application/vnd.openxmlformats-officedocument.wordprocessingml.document" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3235 = { _0: "xls", _1: "application/vnd.ms-excel" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3236 = { _0: "xlsx", _1: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3237 = { _0: "ppt", _1: "application/vnd.ms-powerpoint" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3238 = { _0: "pptx", _1: "application/vnd.openxmlformats-officedocument.presentationml.presentation" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3239 = { _0: "odt", _1: "application/vnd.oasis.opendocument.text" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3240 = { _0: "ods", _1: "application/vnd.oasis.opendocument.spreadsheet" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3241 = { _0: "odp", _1: "application/vnd.oasis.opendocument.presentation" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3242 = { _0: "epub", _1: "application/epub+zip" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3243 = { _0: "zip", _1: "application/zip" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3244 = { _0: "gz", _1: "application/gzip" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3245 = { _0: "tgz", _1: "application/gzip" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3246 = { _0: "bz2", _1: "application/x-bzip2" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3247 = { _0: "xz", _1: "application/x-xz" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3248 = { _0: "tar", _1: "application/x-tar" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3249 = { _0: "7z", _1: "application/x-7z-compressed" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3250 = { _0: "rar", _1: "application/vnd.rar" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3251 = { _0: "zst", _1: "application/zstd" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3252 = { _0: "jar", _1: "application/java-archive" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3253 = { _0: "apk", _1: "application/vnd.android.package-archive" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3254 = { _0: "wasm", _1: "application/wasm" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3255 = { _0: "atom", _1: "application/atom+xml" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3256 = { _0: "rss", _1: "application/rss+xml" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3257 = { _0: "webmanifest", _1: "application/manifest+json" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3258 = { _0: "jsonld", _1: "application/ld+json" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3259 = { _0: "geojson", _1: "application/geo+json" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3260 = { _0: "m3u8", _1: "application/vnd.apple.mpegurl" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3261 = { _0: "plist", _1: "application/x-plist" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3262 = { _0: "pem", _1: "application/x-x509-ca-cert" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3263 = { _0: "crt", _1: "application/x-x509-ca-cert" };
const _M0FP212moonbitstack8moonmime5typesN5tupleS3264 = { _0: "der", _1: "application/x-x509-ca-cert" };
const _M0FP212moonbitstack8moonmime5types = [_M0FP212moonbitstack8moonmime5typesN5tupleS3160, _M0FP212moonbitstack8moonmime5typesN5tupleS3161, _M0FP212moonbitstack8moonmime5typesN5tupleS3162, _M0FP212moonbitstack8moonmime5typesN5tupleS3163, _M0FP212moonbitstack8moonmime5typesN5tupleS3164, _M0FP212moonbitstack8moonmime5typesN5tupleS3165, _M0FP212moonbitstack8moonmime5typesN5tupleS3166, _M0FP212moonbitstack8moonmime5typesN5tupleS3167, _M0FP212moonbitstack8moonmime5typesN5tupleS3168, _M0FP212moonbitstack8moonmime5typesN5tupleS3169, _M0FP212moonbitstack8moonmime5typesN5tupleS3170, _M0FP212moonbitstack8moonmime5typesN5tupleS3171, _M0FP212moonbitstack8moonmime5typesN5tupleS3172, _M0FP212moonbitstack8moonmime5typesN5tupleS3173, _M0FP212moonbitstack8moonmime5typesN5tupleS3174, _M0FP212moonbitstack8moonmime5typesN5tupleS3175, _M0FP212moonbitstack8moonmime5typesN5tupleS3176, _M0FP212moonbitstack8moonmime5typesN5tupleS3177, _M0FP212moonbitstack8moonmime5typesN5tupleS3178, _M0FP212moonbitstack8moonmime5typesN5tupleS3179, _M0FP212moonbitstack8moonmime5typesN5tupleS3180, _M0FP212moonbitstack8moonmime5typesN5tupleS3181, _M0FP212moonbitstack8moonmime5typesN5tupleS3182, _M0FP212moonbitstack8moonmime5typesN5tupleS3183, _M0FP212moonbitstack8moonmime5typesN5tupleS3184, _M0FP212moonbitstack8moonmime5typesN5tupleS3185, _M0FP212moonbitstack8moonmime5typesN5tupleS3186, _M0FP212moonbitstack8moonmime5typesN5tupleS3187, _M0FP212moonbitstack8moonmime5typesN5tupleS3188, _M0FP212moonbitstack8moonmime5typesN5tupleS3189, _M0FP212moonbitstack8moonmime5typesN5tupleS3190, _M0FP212moonbitstack8moonmime5typesN5tupleS3191, _M0FP212moonbitstack8moonmime5typesN5tupleS3192, _M0FP212moonbitstack8moonmime5typesN5tupleS3193, _M0FP212moonbitstack8moonmime5typesN5tupleS3194, _M0FP212moonbitstack8moonmime5typesN5tupleS3195, _M0FP212moonbitstack8moonmime5typesN5tupleS3196, _M0FP212moonbitstack8moonmime5typesN5tupleS3197, _M0FP212moonbitstack8moonmime5typesN5tupleS3198, _M0FP212moonbitstack8moonmime5typesN5tupleS3199, _M0FP212moonbitstack8moonmime5typesN5tupleS3200, _M0FP212moonbitstack8moonmime5typesN5tupleS3201, _M0FP212moonbitstack8moonmime5typesN5tupleS3202, _M0FP212moonbitstack8moonmime5typesN5tupleS3203, _M0FP212moonbitstack8moonmime5typesN5tupleS3204, _M0FP212moonbitstack8moonmime5typesN5tupleS3205, _M0FP212moonbitstack8moonmime5typesN5tupleS3206, _M0FP212moonbitstack8moonmime5typesN5tupleS3207, _M0FP212moonbitstack8moonmime5typesN5tupleS3208, _M0FP212moonbitstack8moonmime5typesN5tupleS3209, _M0FP212moonbitstack8moonmime5typesN5tupleS3210, _M0FP212moonbitstack8moonmime5typesN5tupleS3211, _M0FP212moonbitstack8moonmime5typesN5tupleS3212, _M0FP212moonbitstack8moonmime5typesN5tupleS3213, _M0FP212moonbitstack8moonmime5typesN5tupleS3214, _M0FP212moonbitstack8moonmime5typesN5tupleS3215, _M0FP212moonbitstack8moonmime5typesN5tupleS3216, _M0FP212moonbitstack8moonmime5typesN5tupleS3217, _M0FP212moonbitstack8moonmime5typesN5tupleS3218, _M0FP212moonbitstack8moonmime5typesN5tupleS3219, _M0FP212moonbitstack8moonmime5typesN5tupleS3220, _M0FP212moonbitstack8moonmime5typesN5tupleS3221, _M0FP212moonbitstack8moonmime5typesN5tupleS3222, _M0FP212moonbitstack8moonmime5typesN5tupleS3223, _M0FP212moonbitstack8moonmime5typesN5tupleS3224, _M0FP212moonbitstack8moonmime5typesN5tupleS3225, _M0FP212moonbitstack8moonmime5typesN5tupleS3226, _M0FP212moonbitstack8moonmime5typesN5tupleS3227, _M0FP212moonbitstack8moonmime5typesN5tupleS3228, _M0FP212moonbitstack8moonmime5typesN5tupleS3229, _M0FP212moonbitstack8moonmime5typesN5tupleS3230, _M0FP212moonbitstack8moonmime5typesN5tupleS3231, _M0FP212moonbitstack8moonmime5typesN5tupleS3232, _M0FP212moonbitstack8moonmime5typesN5tupleS3233, _M0FP212moonbitstack8moonmime5typesN5tupleS3234, _M0FP212moonbitstack8moonmime5typesN5tupleS3235, _M0FP212moonbitstack8moonmime5typesN5tupleS3236, _M0FP212moonbitstack8moonmime5typesN5tupleS3237, _M0FP212moonbitstack8moonmime5typesN5tupleS3238, _M0FP212moonbitstack8moonmime5typesN5tupleS3239, _M0FP212moonbitstack8moonmime5typesN5tupleS3240, _M0FP212moonbitstack8moonmime5typesN5tupleS3241, _M0FP212moonbitstack8moonmime5typesN5tupleS3242, _M0FP212moonbitstack8moonmime5typesN5tupleS3243, _M0FP212moonbitstack8moonmime5typesN5tupleS3244, _M0FP212moonbitstack8moonmime5typesN5tupleS3245, _M0FP212moonbitstack8moonmime5typesN5tupleS3246, _M0FP212moonbitstack8moonmime5typesN5tupleS3247, _M0FP212moonbitstack8moonmime5typesN5tupleS3248, _M0FP212moonbitstack8moonmime5typesN5tupleS3249, _M0FP212moonbitstack8moonmime5typesN5tupleS3250, _M0FP212moonbitstack8moonmime5typesN5tupleS3251, _M0FP212moonbitstack8moonmime5typesN5tupleS3252, _M0FP212moonbitstack8moonmime5typesN5tupleS3253, _M0FP212moonbitstack8moonmime5typesN5tupleS3254, _M0FP212moonbitstack8moonmime5typesN5tupleS3255, _M0FP212moonbitstack8moonmime5typesN5tupleS3256, _M0FP212moonbitstack8moonmime5typesN5tupleS3257, _M0FP212moonbitstack8moonmime5typesN5tupleS3258, _M0FP212moonbitstack8moonmime5typesN5tupleS3259, _M0FP212moonbitstack8moonmime5typesN5tupleS3260, _M0FP212moonbitstack8moonmime5typesN5tupleS3261, _M0FP212moonbitstack8moonmime5typesN5tupleS3262, _M0FP212moonbitstack8moonmime5typesN5tupleS3263, _M0FP212moonbitstack8moonmime5typesN5tupleS3264];
const _M0FPB4seed = _M0FPB12random__seed();
const _M0FPC28internal7strconv17parse__scientificN8exp__numS2079 = 0n;
const _M0FPC28internal7strconv17check__underscoreN25_2atransition__table__222S2181 = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 5, 5, 5, 5, 5, 0, 1, 2, 5];
const _M0FPC28internal7strconv15parse__inf__nanN25_2atransition__table__304S2157 = [14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 3, 4, 14, 14, 14, 14, 14, 14, 14, 7, 14, 14, 14, 14, 5, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 6, 14, 14, 14, 0, 14, 14, 14, 14, 14, 14, 14, 14, 14, 8, 14, 14, 14, 14, 14, 1, 14, 14, 9, 14, 14, 14, 14, 14, 14, 14, 14, 10, 14, 14, 14, 14, 14, 14, 11, 14, 14, 14, 14, 14, 14, 14, 14, 14, 12, 14, 14, 14, 14, 14, 14, 14, 14, 13, 14, 1, 14, 14, 14, 14, 14, 14, 14];
const _M0FPC15debug14print__contentN6recordS1830 = new _M0TPC16string10StringView("\n", 0, 1);
const _M0MPC16string6String4trimN6recordS768 = new _M0TPC16string10StringView("\t\n\r ", 0, 4);
const _M0FPC15debug15compact__middleN6recordS1722 = new _M0TPC16string10StringView("", 0, 0);
const _M0FPC15debug15compact__middleN6recordS1723 = new _M0TPC16string10StringView(" ", 0, 1);
const _M0FPC15debug15compact__middleN6recordS1724 = new _M0TPC16string10StringView(",", 0, 1);
const _M0FPC15debug14compact__linesN6recordS1733 = new _M0TPC16string10StringView(" ", 0, 1);
const _M0FPC15debug14compact__linesN6recordS1734 = new _M0TPC16string10StringView(" ", 0, 1);
const _M0FPC15debug14compact__linesN6recordS1735 = new _M0TPC16string10StringView("", 0, 0);
const _M0FPC15debug14compact__linesN6recordS1736 = new _M0TPC16string10StringView("(", 0, 1);
const _M0FPC15debug14compact__linesN6recordS1737 = new _M0TPC16string10StringView(" ", 0, 1);
const _M0FPC15debug19bracket__seq__linesN6recordS1780 = new _M0TPC16string10StringView("", 0, 0);
const _M0IPC15float5FloatPB4Show10to__stringN6constrS1625 = 1;
const _M0FPC15debug6renderN6constrS1924 = 16;
const _M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__reprN6constrS3558 = "at";
const _M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__reprN6constrS3559 = "at";
const _M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__reprN6constrS3560 = "at";
const _M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__reprN6constrS3561 = "at";
const _M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__reprN6constrS3562 = "name";
const _M0FP312moonbitstack8moonbase6base649url__text = `${_M0FP312moonbitstack8moonbase6base647letters}-_`;
const _M0FP312moonbitstack8moonbase6base6411url__lookup = _M0FP312moonbitstack8moonbase8internal10lookup__of(_M0FP312moonbitstack8moonbase6base649url__text);
const _M0FP312moonbitstack8moonbase6base649std__text = `${_M0FP312moonbitstack8moonbase6base647letters}+/`;
const _M0FP312moonbitstack8moonbase6base6411std__lookup = _M0FP312moonbitstack8moonbase8internal10lookup__of(_M0FP312moonbitstack8moonbase6base649std__text);
const _M0FP312moonbitstack8moonmime2qp14decode_2einnerN6recordS3129 = new _M0TPC16string10StringView("\r\n", 0, 2);
const _M0FP312moonbitstack8moonmime2qp14decode_2einnerN6recordS3130 = new _M0TPC16string10StringView("\r\n", 0, 2);
const _M0FP212moonbitstack8moonmime10take__wordN6constrS3358 = 1;
const _M0FP212moonbitstack8moonmime10take__wordN6constrS3359 = 0;
const _M0FP212moonbitstack8moonmime10take__wordN6constrS3360 = true;
const _M0MP212moonbitstack8moonmail7Message7subjectN6recordS3701 = new _M0TPC16string10StringView("Subject", 0, 7);
const _M0MPC16string10StringView4findN6constrS519 = 0;
const _M0FP212moonbitstack8moonmail8type__ofN5tupleS3639 = { _0: "charset", _1: "us-ascii" };
const _M0FP212moonbitstack8moonmail8type__ofN6recordS3640 = new _M0TPC16string10StringView("Content-Type", 0, 12);
const _M0FP212moonbitstack8moonmail8type__ofN6recordS3641 = new _M0TPC16string10StringView("/", 0, 1);
const _M0FP212moonbitstack8moonmail14is__attachmentN6recordS3837 = new _M0TPC16string10StringView("Content-Disposition", 0, 19);
const _M0MP212moonbitstack8moonmail7Message10body__textN6recordS3862 = new _M0TPC16string10StringView("charset", 0, 7);
const _M0FP212moonbitstack8moonmail12encoding__ofN6recordS3620 = new _M0TPC16string10StringView("Content-Transfer-Encoding", 0, 25);
const _M0MPC16string10StringView9trim__endN6recordS761 = new _M0TPC16string10StringView("\t\n\r ", 0, 4);
const _M0FP212moonbitstack8moonmail13read__headersN6constrS3648 = 5;
const _M0FP212moonbitstack8moonmail13read__headersN6recordS3649 = new _M0TPC15bytes9BytesView($bytes_literal$0, 0, 5);
const _M0FP212moonbitstack8moonmail13read__headersN6recordS3650 = new _M0TPC16string10StringView(":", 0, 1);
const _M0FP212moonbitstack8moonmail13read__headersN6recordS3651 = new _M0TPC16string10StringView(" \t", 0, 2);
const _M0FP212moonbitstack8moonmail10read__bodyN6recordS3677 = new _M0TPC16string10StringView("boundary", 0, 8);
const _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4126 = "at";
const _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4127 = "name";
const _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4128 = "name";
const _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4129 = "url";
const _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4130 = "call";
const _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4131 = "kind";
const _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4132 = "description";
const _M0FP312moonbitstack8moonmail4jmap11scheme__endN6recordS4285 = new _M0TPC16string10StringView("https://", 0, 8);
const _M0FP312moonbitstack8moonmail4jmap11scheme__endN6constrS4286 = 8;
const _M0FP312moonbitstack8moonmail4jmap11scheme__endN6recordS4287 = new _M0TPC16string10StringView("http://", 0, 7);
const _M0FP312moonbitstack8moonmail4jmap11scheme__endN6constrS4288 = 7;
const _M0FP312moonbitstack8moonmail4jmap10origin__ofN6recordS4290 = new _M0TPC16string10StringView("/", 0, 1);
const _M0FP312moonbitstack8moonmail4jmap11last__slashN6constrS4299 = 47;
const _M0FP312moonbitstack8moonmail4jmap7resolveN6recordS4303 = new _M0TPC16string10StringView("//", 0, 2);
const _M0FP312moonbitstack8moonmail4jmap7resolveN6recordS4304 = new _M0TPC16string10StringView("/", 0, 1);
const _M0FP312moonbitstack8moonmail4jmap7resolveN6recordS4305 = new _M0TPC16string10StringView("?", 0, 1);
const _M0MP212moonbitstack8moonmail5Lexer6phraseN6constrS3802 = 46;
const _M0FP212moonbitstack8moonmail7displayN6recordS3708 = new _M0TPC16string10StringView("=?", 0, 2);
const _M0MP212moonbitstack8moonmail5Lexer6domainN6constrS3752 = 91;
const _M0MP212moonbitstack8moonmail5Lexer6domainN6recordS3753 = new _M0TPC16string10StringView(".", 0, 1);
const _M0MP212moonbitstack8moonmail5Lexer10addr__specN6recordS3782 = new _M0TPC16string10StringView(".", 0, 1);
const _M0MP212moonbitstack8moonmail5Lexer10addr__specN6recordS3783 = new _M0TPC16string10StringView(".", 0, 1);
const _M0MP212moonbitstack8moonmail5Lexer5angleN6constrS3796 = 64;
const _M0MP212moonbitstack8moonmail5Lexer5angleN6constrS3797 = 64;
const _M0MP212moonbitstack8moonmail5Lexer5angleN6constrS3798 = 44;
const _M0MP212moonbitstack8moonmail5Lexer7mailboxN6constrS3812 = 60;
const _M0FP312moonbitstack8moonbase6base6411url__digits = _M0MPC16string6String9to__array(_M0FP312moonbitstack8moonbase6base649url__text);
const _M0FP312moonbitstack8moonbase6base6411std__digits = _M0MPC16string6String9to__array(_M0FP312moonbitstack8moonbase6base649std__text);
const _M0FP212moonbitstack8moonmail6phraseN6recordS3932 = new _M0TPC16string10StringView(" ", 0, 1);
const _M0MP212moonbitstack8moonmail7Address14encode_2einnerN6recordS3947 = new _M0TPC16string10StringView(", ", 0, 2);
const _M0FP212moonbitstack8moonmail25encode__addresses_2einnerN6recordS3956 = new _M0TPC16string10StringView(", ", 0, 2);
const _M0MP212moonbitstack8moondate6Moment8strftimeN6recordS3068 = new _M0TP212moonbitstack8moondate4Date(1900, 1, 1);
const _M0FP212moonbitstack8moonmail12format__dateN6recordS4063 = new _M0TPC16string10StringView("%a, %d %b %Y %H:%M:%S %z", 0, 24);
const _M0FP212moonbitstack8moonmail12header__textN6recordS3960 = new _M0TPC16string10StringView("resent-", 0, 7);
const _M0FP312moonbitstack8moonmime2qp6encodeN6recordS3112 = new _M0TPC16string10StringView("\r\n", 0, 2);
const _M0FP312moonbitstack8moonmime2qp6encodeN6recordS3113 = new _M0TPC16string10StringView("=\r\n", 0, 3);
const _M0FP212moonbitstack8moonmail4crlfN6recordS3899 = new _M0TPC15bytes9BytesView($bytes_literal$1, 0, 2);
const _M0FP212moonbitstack8moonmail4crlfN6recordS3900 = new _M0TPC15bytes9BytesView($bytes_literal$1, 0, 2);
const _M0FP212moonbitstack8moonmail12boundary__ofN6constrS3884 = 12;
const _M0FP212moonbitstack8moonmail12boundary__ofN6digitsS3885 = "0123456789abcdef";
const _M0FP212moonbitstack8moonmail5writeN5tupleS3976 = { _0: "Content-Transfer-Encoding", _1: "quoted-printable" };
const _M0FP212moonbitstack8moonmail5writeN5tupleS3977 = { _0: "Content-Transfer-Encoding", _1: "base64" };
const _M0FP212moonbitstack8moonmail5writeN6recordS3978 = new _M0TPC16string10StringView("boundary", 0, 8);
const _M0FP212moonbitstack8moonmail5writeN6recordS3979 = new _M0TPC15bytes9BytesView($bytes_literal$1, 0, 2);
const _M0FP212moonbitstack8moonmail5writeN6recordS3980 = new _M0TPC15bytes9BytesView($bytes_literal$1, 0, 2);
function _M0FPB13consume4__acc(acc, input) {
  const _p = (acc >>> 0) + ((Math.imul(input, -1028477379) | 0) >>> 0) | 0;
  const _p$2 = 17;
  return Math.imul(_p << _p$2 | (_p >>> (32 - _p$2 | 0) | 0), 668265263) | 0;
}
function _M0MPC15array10FixedArray12unsafe__blitGyE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGsEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGyEE(dst, dst_offset, src, src_offset, len) {
  if (dst === src && dst_offset < src_offset) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _tmp$2 = dst_offset + i | 0;
        const _tmp$3 = src_offset + i | 0;
        if (_tmp$2 >>> 0 < dst.length) {
          dst[_tmp$2] = _tmp$3 >>> 0 < src.length ? src[_tmp$3] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        return;
      }
    }
  } else {
    let _tmp = len - 1 | 0;
    let _tmp$2 = len > 0;
    while (true) {
      const i = _tmp;
      const _more = _tmp$2;
      if (_more) {
        const _tmp$3 = dst_offset + i | 0;
        const _tmp$4 = src_offset + i | 0;
        if (_tmp$3 >>> 0 < dst.length) {
          dst[_tmp$3] = _tmp$4 >>> 0 < src.length ? src[_tmp$4] : $oob();
        } else {
          $oob();
        }
        _tmp = i - 1 | 0;
        _tmp$2 = i > 0;
        continue;
      } else {
        return;
      }
    }
  }
}
function _M0MPB18UninitializedArray12unsafe__blitGyE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGyEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray12unsafe__blitGsE(dst, dst_offset, src, src_offset, len) {
  _M0MPC15array10FixedArray12unsafe__blitGRPB17UnsafeMaybeUninitGsEE(dst, dst_offset, src, src_offset, len);
}
function _M0MPB18UninitializedArray23unsafe__make__and__blitGyE(src, allocate_len, src_offset, dst_offset, blit_len) {
  const dst = new Uint8Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGyE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPB13StringBuilder13write__objectGsE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGsE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder13write__objectGiE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGiE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder13write__objectGRPC16string10StringViewE(self, obj) {
  const _p = { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger };
  _p.method_table.method_2(_p.self, obj);
}
function _M0MPB13StringBuilder13write__objectGdE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGdE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder21StringBuilder_2einner(size_hint) {
  if (size_hint >= 0) {
    return new _M0TPB13StringBuilder("");
  } else {
    console.error("size_hint must be non-negative");
    return $panic();
  }
}
function _M0IPB13StringBuilderPB6Logger11write__char(self, ch) {
  self.val = `${self.val}${String.fromCodePoint(ch)}`;
}
function _M0IPB13StringBuilderPB6Logger13write__string(self, str) {
  self.val = `${self.val}${str}`;
}
function _M0FPB32code__point__of__surrogate__pair(leading, trailing) {
  return (((Math.imul(leading - 55296 | 0, 1024) | 0) + trailing | 0) - 56320 | 0) + 65536 | 0;
}
function _M0MPC16string6String16unsafe__char__at(self, index) {
  const c1 = self.charCodeAt(index);
  if (c1 >= 55296 && c1 <= 56319) {
    const c2 = self.charCodeAt(index + 1 | 0);
    return _M0FPB32code__point__of__surrogate__pair(c1, c2);
  } else {
    return c1;
  }
}
function _M0MPC14byte4Byte7to__hexN14to__hex__digitS104(i) {
  if (i < 10) {
    const _p = 48;
    const _p$2 = (i + _p | 0) & 255;
    return _p$2;
  } else {
    const _p = 97;
    const _p$2 = (i + _p | 0) & 255;
    const _p$3 = 10;
    const _p$4 = (_p$2 - _p$3 | 0) & 255;
    return _p$4;
  }
}
function _M0MPC14byte4Byte7to__hex(b) {
  const _self = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  const _p = 16;
  _M0IPB13StringBuilderPB6Logger11write__char(_self, _M0MPC14byte4Byte7to__hexN14to__hex__digitS104((b / _p | 0) & 255));
  const _p$2 = 16;
  _M0IPB13StringBuilderPB6Logger11write__char(_self, _M0MPC14byte4Byte7to__hexN14to__hex__digitS104((b % _p$2 | 0) & 255));
  const _p$3 = _self;
  return _p$3.val;
}
function _M0MPC16string10StringView21clamped__view_2einner(self, start, end) {
  const len = self.end - self.start | 0;
  let lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _e = _Some;
    hi = _e < 0 ? 0 : _e > len ? len : _e;
  }
  const str = self.str;
  const base = self.start;
  let _tmp;
  if (lo > 0) {
    let _tmp$2;
    if (lo < len) {
      let _tmp$3;
      const _p = str.charCodeAt(base + lo | 0);
      if (_p >= 56320 && _p <= 57343) {
        const _p$2 = str.charCodeAt((base + lo | 0) - 1 | 0);
        _tmp$3 = _p$2 >= 55296 && _p$2 <= 56319;
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    lo = lo + 1 | 0;
  }
  let _tmp$2;
  if (hi > 0) {
    let _tmp$3;
    if (hi < len) {
      let _tmp$4;
      const _p = str.charCodeAt(base + hi | 0);
      if (_p >= 56320 && _p <= 57343) {
        const _p$2 = str.charCodeAt((base + hi | 0) - 1 | 0);
        _tmp$4 = _p$2 >= 55296 && _p$2 <= 56319;
      } else {
        _tmp$4 = false;
      }
      _tmp$3 = _tmp$4;
    } else {
      _tmp$3 = false;
    }
    _tmp$2 = _tmp$3;
  } else {
    _tmp$2 = false;
  }
  if (_tmp$2) {
    hi = hi - 1 | 0;
  }
  return lo >= hi ? new _M0TPC16string10StringView(str, base + lo | 0, base + lo | 0) : new _M0TPC16string10StringView(str, base + lo | 0, base + hi | 0);
}
function _M0MPC16string10StringView18escape__to_2einnerN14flush__segmentS118(_env, seg, i) {
  const self = _env._1;
  const logger = _env._0;
  if (i > seg) {
    logger.method_table.method_2(logger.self, _M0MPC16string10StringView21clamped__view_2einner(self, seg, i));
    return;
  } else {
    return;
  }
}
function _M0MPC16string10StringView18escape__to_2einner(self, logger, quote) {
  if (quote) {
    logger.method_table.method_3(logger.self, 34);
  }
  const len = self.end - self.start | 0;
  const _env = { _0: logger, _1: self };
  let _tmp = 0;
  let _tmp$2 = 0;
  _L: while (true) {
    const i = _tmp;
    const seg = _tmp$2;
    if (i >= len) {
      _M0MPC16string10StringView18escape__to_2einnerN14flush__segmentS118(_env, seg, i);
      break;
    }
    const code = self.str.charCodeAt(self.start + i | 0);
    let c;
    _L$2: {
      switch (code) {
        case 34: {
          c = code;
          break _L$2;
        }
        case 92: {
          c = code;
          break _L$2;
        }
        case 10: {
          _M0MPC16string10StringView18escape__to_2einnerN14flush__segmentS118(_env, seg, i);
          logger.method_table.method_0(logger.self, "\\n");
          _tmp = i + 1 | 0;
          _tmp$2 = i + 1 | 0;
          continue _L;
        }
        case 13: {
          _M0MPC16string10StringView18escape__to_2einnerN14flush__segmentS118(_env, seg, i);
          logger.method_table.method_0(logger.self, "\\r");
          _tmp = i + 1 | 0;
          _tmp$2 = i + 1 | 0;
          continue _L;
        }
        case 8: {
          _M0MPC16string10StringView18escape__to_2einnerN14flush__segmentS118(_env, seg, i);
          logger.method_table.method_0(logger.self, "\\b");
          _tmp = i + 1 | 0;
          _tmp$2 = i + 1 | 0;
          continue _L;
        }
        case 9: {
          _M0MPC16string10StringView18escape__to_2einnerN14flush__segmentS118(_env, seg, i);
          logger.method_table.method_0(logger.self, "\\t");
          _tmp = i + 1 | 0;
          _tmp$2 = i + 1 | 0;
          continue _L;
        }
        default: {
          if (code < 32) {
            _M0MPC16string10StringView18escape__to_2einnerN14flush__segmentS118(_env, seg, i);
            logger.method_table.method_0(logger.self, "\\u{");
            logger.method_table.method_0(logger.self, _M0MPC14byte4Byte7to__hex(code & 255));
            logger.method_table.method_0(logger.self, "}");
            _tmp = i + 1 | 0;
            _tmp$2 = i + 1 | 0;
            continue _L;
          } else {
            _tmp = i + 1 | 0;
            continue _L;
          }
        }
      }
    }
    _M0MPC16string10StringView18escape__to_2einnerN14flush__segmentS118(_env, seg, i);
    logger.method_table.method_3(logger.self, 92);
    logger.method_table.method_3(logger.self, c);
    _tmp = i + 1 | 0;
    _tmp$2 = i + 1 | 0;
    continue;
  }
  if (quote) {
    logger.method_table.method_3(logger.self, 34);
    return;
  } else {
    return;
  }
}
function _M0MPC16string6String14escape_2einner(self, quote) {
  const buf = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  _M0MPC16string10StringView18escape__to_2einner(new _M0TPC16string10StringView(self, 0, self.length), { self: buf, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger }, quote);
  return buf.val;
}
function _M0MPC16string10StringView19exact__view_2einner(self, start, end) {
  const str_len = self.str.length;
  let abs_end;
  if (end === undefined) {
    abs_end = self.end;
  } else {
    const _Some = end;
    const _end = _Some;
    abs_end = self.start + _end | 0;
  }
  const abs_start = self.start + start | 0;
  if (abs_start >= self.start && (abs_start <= abs_end && abs_end <= self.end)) {
    if (abs_start < str_len) {
      const _p = self.str.charCodeAt(abs_start);
      if (!(_p >= 56320 && _p <= 57343)) {
      } else {
        $panic();
      }
    }
    if (abs_end < str_len) {
      const _p = self.str.charCodeAt(abs_end);
      if (!(_p >= 56320 && _p <= 57343)) {
      } else {
        $panic();
      }
    }
    return new _M0TPC16string10StringView(self.str, abs_start, abs_end);
  } else {
    return $panic();
  }
}
function _M0IP016_24default__implPB2Eq10not__equalGOcE(x, y) {
  return !_M0IPC16option6OptionPB2Eq5equalGcE(x, y);
}
function _M0IP016_24default__implPB2Eq10not__equalGRPC16string10StringViewE(x, y) {
  return !_M0IPC16string10StringViewPB2Eq5equal(x, y);
}
function _M0FPB14avalanche__acc(acc) {
  let acc$2 = acc;
  acc$2 = acc$2 ^ (acc$2 >>> 15 | 0);
  acc$2 = Math.imul(acc$2, -2048144777) | 0;
  acc$2 = acc$2 ^ (acc$2 >>> 13 | 0);
  acc$2 = Math.imul(acc$2, -1028477379) | 0;
  acc$2 = acc$2 ^ (acc$2 >>> 16 | 0);
  return acc$2;
}
function _M0FPB13finalize__acc(acc) {
  return _M0FPB14avalanche__acc(acc);
}
function _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE(self, show) {
  show.method_table.method_0(show.self, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE(self, show) {
  show.method_table.method_0(show.self, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPC16string6String21clamped__view_2einner(self, start, end) {
  const len = self.length;
  let lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _e = _Some;
    hi = _e < 0 ? 0 : _e > len ? len : _e;
  }
  let _tmp;
  if (lo > 0) {
    let _tmp$2;
    if (lo < len) {
      let _tmp$3;
      const _p = self.charCodeAt(lo);
      if (_p >= 56320 && _p <= 57343) {
        const _p$2 = self.charCodeAt(lo - 1 | 0);
        _tmp$3 = _p$2 >= 55296 && _p$2 <= 56319;
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    lo = lo + 1 | 0;
  }
  let _tmp$2;
  if (hi > 0) {
    let _tmp$3;
    if (hi < len) {
      let _tmp$4;
      const _p = self.charCodeAt(hi);
      if (_p >= 56320 && _p <= 57343) {
        const _p$2 = self.charCodeAt(hi - 1 | 0);
        _tmp$4 = _p$2 >= 55296 && _p$2 <= 56319;
      } else {
        _tmp$4 = false;
      }
      _tmp$3 = _tmp$4;
    } else {
      _tmp$3 = false;
    }
    _tmp$2 = _tmp$3;
  } else {
    _tmp$2 = false;
  }
  if (_tmp$2) {
    hi = hi - 1 | 0;
  }
  return lo >= hi ? new _M0TPC16string10StringView(self, lo, lo) : new _M0TPC16string10StringView(self, lo, hi);
}
function _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(self, value, start, len) {
  _M0IPB13StringBuilderPB6Logger11write__view(self, _M0MPC16string6String21clamped__view_2einner(value, start, start + len | 0));
}
function _M0IP016_24default__implPB4Show6outputGsE(self, logger) {
  logger.method_table.method_0(logger.self, self);
}
function _M0IP016_24default__implPB4Show6outputGiE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC13int3IntPB4Show10to__string(self));
}
function _M0IP016_24default__implPB4Show6outputGdE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC16double6DoublePB4Show10to__string(self));
}
function _M0IP016_24default__implPB4Show10to__stringGRPC15debug4ReprE(self) {
  const logger = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  _M0IPC15debug4ReprPB4Show6output(self, { self: logger, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
  return logger.val;
}
function _M0MPB4Iter4nextGyE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === -1) {
    self.size_hint = _M0MPB4Iter4nextN6constrS192GyE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS191GyE;
    }
  }
  return result;
}
function _M0MPB4Iter4nextGUssEE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === undefined) {
    self.size_hint = _M0MPB4Iter4nextN6constrS200GUssEE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS199GUssEE;
    }
  }
  return result;
}
function _M0MPB4Iter4nextGcE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === -1) {
    self.size_hint = _M0MPB4Iter4nextN6constrS216GcE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS215GcE;
    }
  }
  return result;
}
function _M0MPC13int3Int18to__string_2einner(self, radix) {
  return _M0FPB19int__to__string__js(self, radix);
}
function _M0MPC14uint4UInt18to__string_2einner(self, radix) {
  return _M0FPB20uint__to__string__js(self, radix);
}
function _M0MPB4Iter3newGyE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS251GyE;
  }
  return new _M0TPB4IterGyE(f, size_hint$2);
}
function _M0MPB4Iter3newGUssEE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS257GUssEE;
  }
  return new _M0TPB4IterGUssEE(f, size_hint$2);
}
function _M0MPB4Iter3newGcE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS269GcE;
  }
  return new _M0TPB4IterGcE(f, size_hint$2);
}
function _M0MPC15array10FixedArray21clamped__view_2einnerGyE(self, start, end) {
  const len = self.length;
  const lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _end = _Some;
    hi = _end < 0 ? 0 : _end > len ? len : _end;
  }
  const count = hi > lo ? hi - lo | 0 : 0;
  const _bind = self;
  return new _M0TPB9ArrayViewGyE(_bind, lo, lo + count | 0);
}
function _M0MPC15array10FixedArray21clamped__view_2einnerGkE(self, start, end) {
  const len = self.length;
  const lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _end = _Some;
    hi = _end < 0 ? 0 : _end > len ? len : _end;
  }
  const count = hi > lo ? hi - lo | 0 : 0;
  const _bind = self;
  return new _M0TPB9ArrayViewGkE(_bind, lo, lo + count | 0);
}
function _M0MPC16string10StringView11code__units(self) {
  const _p = self.str.length;
  let _tmp;
  if (_p <= 0) {
    _tmp = [];
  } else {
    const _p$2 = 0;
    const _p$3 = $make_array_len_and_init(_p, self.str.charCodeAt(_p$2));
    let _tmp$2 = 1;
    while (true) {
      const _p$4 = _tmp$2;
      if (_p$4 < _p) {
        if (_p$4 >>> 0 < _p$3.length) {
          _p$3[_p$4] = self.str.charCodeAt(_p$4);
        } else {
          $oob();
        }
        _tmp$2 = _p$4 + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    _tmp = _p$3;
  }
  return _M0MPC15array10FixedArray21clamped__view_2einnerGkE(_tmp, self.start, self.end);
}
function _M0MPC16string10StringView9to__owned(self) {
  return self.str.substring(self.start, self.end);
}
function _M0MPC16string10StringView4iter(self) {
  const start = self.start;
  const end = self.end;
  const index = new _M0TPB8MutLocalGiE(start);
  return _M0MPB4Iter3newGcE(() => {
    if (index.val < end) {
      const c1 = self.str.charCodeAt(index.val);
      if (c1 >= 55296 && c1 <= 56319 && (index.val + 1 | 0) < self.end) {
        const c2 = self.str.charCodeAt(index.val + 1 | 0);
        if (c2 >= 56320 && c2 <= 57343) {
          index.val = index.val + 2 | 0;
          return _M0FPB32code__point__of__surrogate__pair(c1, c2);
        }
      }
      index.val = index.val + 1 | 0;
      return c1;
    } else {
      return -1;
    }
  }, undefined);
}
function _M0MPC16string6String20unsafe__range__equal(self, start, other, other_start, len) {
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < len) {
      if (self.charCodeAt(start + i | 0) === other.charCodeAt(other_start + i | 0)) {
      } else {
        return false;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0IPC16string10StringViewPB2Eq5equal(self, other) {
  const len = self.end - self.start | 0;
  if (len === (other.end - other.start | 0)) {
    if (self.str === other.str && self.start === other.start) {
      return true;
    }
    return _M0MPC16string6String20unsafe__range__equal(self.str, self.start, other.str, other.start, len);
  } else {
    return false;
  }
}
function _M0FPB23ascii__fold__lower__u16(c) {
  if (c >= 65 && c <= 90) {
    const _p = 32;
    return (c + _p | 0) & 65535;
  } else {
    return c;
  }
}
function _M0MPC16string10StringView26equal__ignore__ascii__case(self, other) {
  const len = self.end - self.start | 0;
  if (len !== (other.end - other.start | 0)) {
    return false;
  }
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < len) {
      _L: {
        const a = self.str.charCodeAt(self.start + i | 0);
        const b = other.str.charCodeAt(other.start + i | 0);
        if (a === b) {
          break _L;
        }
        if (_M0FPB23ascii__fold__lower__u16(a) !== _M0FPB23ascii__fold__lower__u16(b)) {
          return false;
        }
        break _L;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0MPC16string6String11from__array(chars) {
  const buf = _M0MPB13StringBuilder21StringBuilder_2einner(Math.imul(chars.end - chars.start | 0, 4) | 0);
  const _bind = chars.end - chars.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const c = chars.buf[chars.start + _ | 0];
      _M0IPB13StringBuilderPB6Logger11write__char(buf, c);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return buf.val;
}
function _M0MPC16string6String19exact__view_2einner(self, start, end) {
  const len = self.length;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    const _end = _Some;
    end$2 = _end;
  }
  if (start >= 0 && (start <= end$2 && end$2 <= len)) {
    if (start < len) {
      const _p = self.charCodeAt(start);
      if (!(_p >= 56320 && _p <= 57343)) {
      } else {
        $panic();
      }
    }
    if (end$2 < len) {
      const _p = self.charCodeAt(end$2);
      if (!(_p >= 56320 && _p <= 57343)) {
      } else {
        $panic();
      }
    }
    return new _M0TPC16string10StringView(self, start, end$2);
  } else {
    return $panic();
  }
}
function _M0MPC16string6String24char__length__ge_2einner(self, len, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  let _tmp = start_offset;
  let _tmp$2 = 0;
  while (true) {
    const index = _tmp;
    const count = _tmp$2;
    if (index < end_offset$2 && count < len) {
      const c1 = self.charCodeAt(index);
      if (c1 >= 55296 && c1 <= 56319 && (index + 1 | 0) < end_offset$2) {
        const c2 = self.charCodeAt(index + 1 | 0);
        if (c2 >= 56320 && c2 <= 57343) {
          _tmp = index + 2 | 0;
          _tmp$2 = count + 1 | 0;
          continue;
        } else {
          console.error("invalid surrogate pair");
          $panic();
        }
      }
      _tmp = index + 1 | 0;
      _tmp$2 = count + 1 | 0;
      continue;
    } else {
      return count >= len;
    }
  }
}
function _M0MPC16string6String31offset__of__nth__char__backward(self, n, start_offset, end_offset) {
  let _tmp = end_offset;
  let _tmp$2 = 0;
  while (true) {
    const utf16_offset = _tmp;
    const char_count = _tmp$2;
    if ((utf16_offset - 1 | 0) >= start_offset && char_count < n) {
      const c = self.charCodeAt(utf16_offset - 1 | 0);
      if (c >= 56320 && c <= 57343) {
        _tmp = utf16_offset - 2 | 0;
        _tmp$2 = char_count + 1 | 0;
        continue;
      } else {
        _tmp = utf16_offset - 1 | 0;
        _tmp$2 = char_count + 1 | 0;
        continue;
      }
    } else {
      return char_count < n || utf16_offset < start_offset ? undefined : utf16_offset;
    }
  }
}
function _M0MPC16string6String30offset__of__nth__char__forward(self, n, start_offset, end_offset) {
  if (start_offset >= 0 && start_offset <= end_offset) {
    let _tmp = start_offset;
    let _tmp$2 = 0;
    while (true) {
      const utf16_offset = _tmp;
      const char_count = _tmp$2;
      if (utf16_offset < end_offset && char_count < n) {
        const c = self.charCodeAt(utf16_offset);
        if (c >= 55296 && c <= 56319) {
          _tmp = utf16_offset + 2 | 0;
          _tmp$2 = char_count + 1 | 0;
          continue;
        } else {
          _tmp = utf16_offset + 1 | 0;
          _tmp$2 = char_count + 1 | 0;
          continue;
        }
      } else {
        return char_count < n || utf16_offset >= end_offset ? undefined : utf16_offset;
      }
    }
  } else {
    console.error("Invalid start index");
    return $panic();
  }
}
function _M0MPC16string6String29offset__of__nth__char_2einner(self, i, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  return i >= 0 ? _M0MPC16string6String30offset__of__nth__char__forward(self, i, start_offset, end_offset$2) : _M0MPC16string6String31offset__of__nth__char__backward(self, -i | 0, start_offset, end_offset$2);
}
function _M0MPC16string10StringView12view_2einner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.end - self.start | 0;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  if (start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= (self.end - self.start | 0))) {
    return new _M0TPC16string10StringView(self.str, self.start + start_offset | 0, self.start + end_offset$2 | 0);
  } else {
    console.error("Invalid index for View");
    return $panic();
  }
}
function _M0MPC16string6String12view_2einner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  if (start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= self.length)) {
    return new _M0TPC16string10StringView(self, start_offset, end_offset$2);
  } else {
    console.error("Invalid index for View");
    return $panic();
  }
}
function _M0IPB13StringBuilderPB6Logger11write__view(self, str) {
  self.val = `${self.val}${_M0MPC16string10StringView9to__owned(str)}`;
}
function _M0FPB19kmp__failure__table(pattern) {
  const m = pattern.end - pattern.start | 0;
  const table = $make_array_len_and_init(m, 0);
  let k = 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < m) {
      const c = pattern.str.charCodeAt(pattern.start + i | 0);
      while (true) {
        if (k > 0 && c !== pattern.str.charCodeAt(pattern.start + k | 0)) {
          const _tmp$2 = k - 1 | 0;
          k = _tmp$2 >>> 0 < table.length ? table[_tmp$2] : $oob();
          continue;
        } else {
          break;
        }
      }
      if (c === pattern.str.charCodeAt(pattern.start + k | 0)) {
        k = k + 1 | 0;
      }
      if (i >>> 0 < table.length) {
        table[i] = k;
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return table;
}
function _M0FPB24find__pattern__kmp__from(target, pattern, start) {
  const n = target.end - target.start | 0;
  const m = pattern.end - pattern.start | 0;
  const table = _M0FPB19kmp__failure__table(pattern);
  let k = 0;
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < n) {
      const c = target.str.charCodeAt(target.start + i | 0);
      while (true) {
        if (k > 0 && c !== pattern.str.charCodeAt(pattern.start + k | 0)) {
          const _tmp$2 = k - 1 | 0;
          k = _tmp$2 >>> 0 < table.length ? table[_tmp$2] : $oob();
          continue;
        } else {
          break;
        }
      }
      if (c === pattern.str.charCodeAt(pattern.start + k | 0)) {
        k = k + 1 | 0;
      }
      if (k === m) {
        return (i - m | 0) + 1 | 0;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FPB36find__two__anchor__candidate__scalar(data, start, candidate_end, first, last_offset, last) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    if (pos < candidate_end) {
      if (data.charCodeAt(pos) === first && data.charCodeAt(pos + last_offset | 0) === last) {
        return pos;
      }
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return -1;
    }
  }
}
function _M0FPB42find__two__anchor__candidate__from__string(data, start, candidate_end, first, last_offset, last) {
  return _M0FPB36find__two__anchor__candidate__scalar(data, start, candidate_end, first, last_offset, last);
}
function _M0FPB21string__ranges__equal(left, left_start, right, right_start, length) {
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < length) {
      if (left.charCodeAt(left_start + i | 0) !== right.charCodeAt(right_start + i | 0)) {
        return false;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0FPB22find__by__two__anchors(target, pattern) {
  const target_len = target.end - target.start | 0;
  const pattern_len = pattern.end - pattern.start | 0;
  const target_start = target.start;
  const pattern_start = pattern.start;
  const last_offset = pattern_len - 1 | 0;
  const candidate_end = ((target_start + target_len | 0) - pattern_len | 0) + 1 | 0;
  const first = pattern.str.charCodeAt(pattern.start);
  const last = pattern.str.charCodeAt(pattern.start + last_offset | 0);
  const middle_len = last_offset - 1 | 0;
  let _tmp = target_start;
  let _tmp$2 = 0;
  while (true) {
    const pos = _tmp;
    const failures = _tmp$2;
    if (pos < candidate_end) {
      const found = _M0FPB42find__two__anchor__candidate__from__string(target.str, pos, candidate_end, first, last_offset, last);
      if (found < 0) {
        return undefined;
      }
      if (_M0FPB21string__ranges__equal(target.str, found + 1 | 0, pattern.str, pattern_start + 1 | 0, middle_len)) {
        return found - target_start | 0;
      }
      const failures$2 = failures + 1 | 0;
      const scanned = found - target_start | 0;
      if (failures$2 > 64 || failures$2 > (4 + (scanned / 8 | 0) | 0)) {
        return _M0FPB24find__pattern__kmp__from(target, pattern, scanned + 1 | 0);
      }
      _tmp = found + 1 | 0;
      _tmp$2 = failures$2;
      continue;
    } else {
      return undefined;
    }
  }
}
function _M0FPB24find__code__unit__scalar(data, start, end, code) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    if (pos < end) {
      if (data.charCodeAt(pos) === code) {
        return pos;
      }
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return -1;
    }
  }
}
function _M0FPB30find__code__unit__from__string(data, start, end, code) {
  return _M0FPB24find__code__unit__scalar(data, start, end, code);
}
function _M0FPB28find__code__unit__from__view(target, start, end, code) {
  const target_start = target.start;
  const found = _M0FPB30find__code__unit__from__string(target.str, target_start + start | 0, target_start + end | 0, code);
  return found < 0 ? -1 : found - target_start | 0;
}
function _M0MPC16string10StringView4find(self, str) {
  const pattern_len = str.end - str.start | 0;
  switch (pattern_len) {
    case 0: {
      return _M0MPC16string10StringView4findN6constrS519;
    }
    case 1: {
      const found = _M0FPB28find__code__unit__from__view(self, 0, self.end - self.start | 0, str.str.charCodeAt(str.start));
      return found < 0 ? undefined : found;
    }
    default: {
      return pattern_len > (self.end - self.start | 0) ? undefined : _M0FPB22find__by__two__anchors(self, str);
    }
  }
}
function _M0MPC16string6String4find(self, str) {
  return _M0MPC16string10StringView4find(new _M0TPC16string10StringView(self, 0, self.length), str);
}
function _M0MPC16string6String6repeat(self, n) {
  if (n < 0) {
    console.error("negative repeat count");
    return $panic();
  } else {
    if (n === 0) {
      return "";
    } else {
      if (n === 1) {
        return self;
      } else {
        const len = self.length;
        const total = Math.imul(len, n) | 0;
        if (len === 0 || (total / n | 0) === len) {
          const buf = _M0MPB13StringBuilder21StringBuilder_2einner(total);
          const str = self;
          let _tmp = 0;
          while (true) {
            const _ = _tmp;
            if (_ < n) {
              _M0IPB13StringBuilderPB6Logger13write__string(buf, str);
              _tmp = _ + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          return buf.val;
        } else {
          console.error("repeat result too large");
          return $panic();
        }
      }
    }
  }
}
function _M0MPC16string6String8find__by(self, pred) {
  const _p = new _M0TPC16string10StringView(self, 0, self.length);
  const _p$2 = _p.str;
  const _p$3 = _p.start;
  const _p$4 = _p.end;
  let _tmp = _p$3;
  let _tmp$2 = 0;
  while (true) {
    const _p$5 = _tmp;
    const _p$6 = _tmp$2;
    if (_p$5 < _p$4) {
      let _p$7;
      let _p$8;
      _L: {
        const _p$9 = _p$2.charCodeAt(_p$5);
        if (_p$9 >= 55296 && _p$9 <= 56319 && (_p$5 + 1 | 0) < _p$4) {
          const _p$10 = _p$2.charCodeAt(_p$5 + 1 | 0);
          if (_p$10 >= 56320 && _p$10 <= 57343) {
            const _tmp$3 = _p$5 + 2 | 0;
            const _p$11 = (((Math.imul(_p$9 - 55296 | 0, 1024) | 0) + _p$10 | 0) - 56320 | 0) + 65536 | 0;
            _p$7 = _tmp$3;
            _p$8 = _p$11;
            break _L;
          } else {
            const _tmp$3 = _p$5 + 1 | 0;
            const _p$11 = _p$9;
            _p$7 = _tmp$3;
            _p$8 = _p$11;
            break _L;
          }
        } else {
          const _tmp$3 = _p$5 + 1 | 0;
          const _p$10 = _p$9;
          _p$7 = _tmp$3;
          _p$8 = _p$10;
          break _L;
        }
      }
      if (pred(_p$8)) {
        return _p$6;
      }
      _tmp = _p$7;
      const _p$9 = _p$8;
      _tmp$2 = _p$6 + (_p$9 <= 65535 ? 1 : 2) | 0;
      continue;
    } else {
      return undefined;
    }
  }
}
function _M0MPC16string10StringView11has__suffix(self, str) {
  const self_len = self.end - self.start | 0;
  const str_len = str.end - str.start | 0;
  if (str_len <= self_len) {
    const start = self_len - str_len | 0;
    return str_len === 0 || self.str.charCodeAt(self.start + start | 0) === str.str.charCodeAt(str.start) ? _M0MPC16string6String20unsafe__range__equal(self.str, self.start + start | 0, str.str, str.start, str_len) : false;
  } else {
    return false;
  }
}
function _M0MPC16string6String11has__suffix(self, str) {
  return _M0MPC16string10StringView11has__suffix(new _M0TPC16string10StringView(self, 0, self.length), str);
}
function _M0MPC16string10StringView11has__prefix(self, str) {
  const str_len = str.end - str.start | 0;
  return str_len <= (self.end - self.start | 0) ? (str_len === 0 || self.str.charCodeAt(self.start) === str.str.charCodeAt(str.start) ? _M0MPC16string6String20unsafe__range__equal(self.str, self.start, str.str, str.start, str_len) : false) : false;
}
function _M0MPC16string6String11has__prefix(self, str) {
  return _M0MPC16string10StringView11has__prefix(new _M0TPC16string10StringView(self, 0, self.length), str);
}
function _M0MPC16string10StringView13strip__suffix(self, suffix) {
  const self_len = self.end - self.start | 0;
  const suffix_len = suffix.end - suffix.start | 0;
  return self_len >= suffix_len && _M0IPC16string10StringViewPB2Eq5equal(_M0MPC16string10StringView12view_2einner(self, self_len - suffix_len | 0, undefined), suffix) ? _M0MPC16string10StringView12view_2einner(self, 0, self_len - suffix_len | 0) : undefined;
}
function _M0MPC16string6String13strip__suffix(self, suffix) {
  return _M0MPC16string10StringView13strip__suffix(new _M0TPC16string10StringView(self, 0, self.length), suffix);
}
function _M0MPC16string10StringView13strip__prefix(self, prefix) {
  const prefix_len = prefix.end - prefix.start | 0;
  return (self.end - self.start | 0) >= prefix_len && _M0IPC16string10StringViewPB2Eq5equal(_M0MPC16string10StringView12view_2einner(self, 0, prefix_len), prefix) ? _M0MPC16string10StringView12view_2einner(self, prefix_len, undefined) : undefined;
}
function _M0MPC15array5Array4pushGyE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0MPC15array5Array4pushGcE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0MPC15array5Array4pushGiE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0MPC16string10StringView9to__array(self) {
  const chars = [];
  const _bind = self.str;
  const _bind$2 = self.start;
  const _bind$3 = self.end;
  let _tmp = _bind$2;
  while (true) {
    const _string_index = _tmp;
    if (_string_index < _bind$3) {
      let _decoded_next_string_index;
      let _decoded_char;
      _L: {
        const _bind$4 = _bind.charCodeAt(_string_index);
        if (_bind$4 >= 55296 && _bind$4 <= 56319 && (_string_index + 1 | 0) < _bind$3) {
          const _bind$5 = _bind.charCodeAt(_string_index + 1 | 0);
          if (_bind$5 >= 56320 && _bind$5 <= 57343) {
            const _tmp$2 = _string_index + 2 | 0;
            const _p = (((Math.imul(_bind$4 - 55296 | 0, 1024) | 0) + _bind$5 | 0) - 56320 | 0) + 65536 | 0;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$4;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        } else {
          const _tmp$2 = _string_index + 1 | 0;
          const _p = _bind$4;
          _decoded_next_string_index = _tmp$2;
          _decoded_char = _p;
          break _L;
        }
      }
      _M0MPC15array5Array4pushGcE(chars, _decoded_char);
      _tmp = _decoded_next_string_index;
      continue;
    } else {
      break;
    }
  }
  return chars;
}
function _M0FPB36string__contains__code__unit__scalar(str, start, end, code) {
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < end) {
      if (str.charCodeAt(i) === code) {
        return true;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0FPB28string__contains__code__unit(str, start, end, code) {
  return _M0FPB36string__contains__code__unit__scalar(str, start, end, code);
}
function _M0MPC16string10StringView20contains__code__unit(self, code) {
  return _M0FPB28string__contains__code__unit(self.str, self.start, self.end, code);
}
function _M0MPC16string10StringView8contains(self, str) {
  const _bind = str.end - str.start | 0;
  switch (_bind) {
    case 0: {
      return true;
    }
    case 1: {
      return _M0MPC16string10StringView20contains__code__unit(self, str.str.charCodeAt(str.start));
    }
    default: {
      const _bind$2 = _M0MPC16string10StringView4find(self, str);
      return !(_bind$2 === undefined);
    }
  }
}
function _M0MPC16string6String8contains(self, str) {
  return _M0MPC16string10StringView8contains(new _M0TPC16string10StringView(self, 0, self.length), str);
}
function _M0FPB23build__ascii__char__set(chars) {
  let bits0 = 0;
  let bits1 = 0;
  let bits2 = 0;
  let bits3 = 0;
  const _bind = chars.str;
  const _bind$2 = chars.start;
  const _bind$3 = chars.end;
  let _tmp = _bind$2;
  while (true) {
    const _string_index = _tmp;
    if (_string_index < _bind$3) {
      let _decoded_next_string_index;
      let _decoded_char;
      _L: {
        const _bind$4 = _bind.charCodeAt(_string_index);
        if (_bind$4 >= 55296 && _bind$4 <= 56319 && (_string_index + 1 | 0) < _bind$3) {
          const _bind$5 = _bind.charCodeAt(_string_index + 1 | 0);
          if (_bind$5 >= 56320 && _bind$5 <= 57343) {
            const _tmp$2 = _string_index + 2 | 0;
            const _p = (((Math.imul(_bind$4 - 55296 | 0, 1024) | 0) + _bind$5 | 0) - 56320 | 0) + 65536 | 0;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$4;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        } else {
          const _tmp$2 = _string_index + 1 | 0;
          const _p = _bind$4;
          _decoded_next_string_index = _tmp$2;
          _decoded_char = _p;
          break _L;
        }
      }
      const code = _decoded_char;
      if (code >>> 0 < 128 >>> 0) {
        const bit = 1 << (code & 31);
        const _bind$4 = code >>> 5 | 0;
        switch (_bind$4) {
          case 0: {
            bits0 = bits0 | bit;
            break;
          }
          case 1: {
            bits1 = bits1 | bit;
            break;
          }
          case 2: {
            bits2 = bits2 | bit;
            break;
          }
          default: {
            bits3 = bits3 | bit;
          }
        }
      } else {
        return undefined;
      }
      _tmp = _decoded_next_string_index;
      continue;
    } else {
      break;
    }
  }
  return { _0: bits0, _1: bits1, _2: bits2, _3: bits3 };
}
function _M0FPB26ascii__char__set__contains(bits0, bits1, bits2, bits3, code) {
  if (code >>> 0 < 128 >>> 0) {
    const bit = 1 << (code & 31);
    const _bind = code >>> 5 | 0;
    switch (_bind) {
      case 0: {
        return (bits0 & bit) !== 0;
      }
      case 1: {
        return (bits1 & bit) !== 0;
      }
      case 2: {
        return (bits2 & bit) !== 0;
      }
      default: {
        return (bits3 & bit) !== 0;
      }
    }
  } else {
    return false;
  }
}
function _M0FPB34string__trim__start__ascii__scalar(str, start, end, bits0, bits1, bits2, bits3) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    let _tmp$2;
    if (pos < end) {
      const _p = str.charCodeAt(pos);
      _tmp$2 = _M0FPB26ascii__char__set__contains(bits0, bits1, bits2, bits3, _p);
    } else {
      _tmp$2 = false;
    }
    if (_tmp$2) {
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return pos;
    }
  }
}
function _M0FPB32string__trim__end__ascii__scalar(str, start, end, bits0, bits1, bits2, bits3) {
  let _tmp = end;
  while (true) {
    const pos = _tmp;
    let _tmp$2;
    if (pos > start) {
      const _p = str.charCodeAt(pos - 1 | 0);
      _tmp$2 = _M0FPB26ascii__char__set__contains(bits0, bits1, bits2, bits3, _p);
    } else {
      _tmp$2 = false;
    }
    if (_tmp$2) {
      _tmp = pos - 1 | 0;
      continue;
    } else {
      return pos;
    }
  }
}
function _M0FPB26string__trim__start__ascii(str, start, end, _chars, bits0, bits1, bits2, bits3) {
  return _M0FPB34string__trim__start__ascii__scalar(str, start, end, bits0, bits1, bits2, bits3);
}
function _M0FPB24string__trim__end__ascii(str, start, end, _chars, bits0, bits1, bits2, bits3) {
  return _M0FPB32string__trim__end__ascii__scalar(str, start, end, bits0, bits1, bits2, bits3);
}
function _M0MPC16string10StringView14contains__char(self, c) {
  const len = self.end - self.start | 0;
  if (len > 0) {
    const c$2 = c;
    if (c$2 >= 0 && c$2 <= 65535) {
      return _M0MPC16string10StringView20contains__code__unit(self, c$2 & 65535);
    } else {
      if (c$2 < 0) {
        return false;
      } else {
        if (len >= 2) {
          const adj = c$2 - 65536 | 0;
          const high = 55296 + (adj >> 10) | 0;
          if (high <= 65535) {
            const high$2 = high & 65535;
            const low = (56320 + (adj & 1023) | 0) & 65535;
            let _tmp = 0;
            while (true) {
              const i = _tmp;
              if (i < (len - 1 | 0)) {
                if (self.str.charCodeAt(self.start + i | 0) === high$2) {
                  if (self.str.charCodeAt(self.start + (i + 1 | 0) | 0) === low) {
                    return true;
                  }
                  _tmp = i + 2 | 0;
                  continue;
                }
                _tmp = i + 1 | 0;
                continue;
              } else {
                break;
              }
            }
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    }
    return false;
  } else {
    return false;
  }
}
function _M0MPC16string10StringView24trim__start__with__chars(self, chars) {
  let _tmp = self;
  while (true) {
    const x = _tmp;
    if ((x.end - x.start | 0) === 0) {
      return x;
    } else {
      const _c = _M0MPC16string6String16unsafe__char__at(x.str, _M0MPC16string6String29offset__of__nth__char_2einner(x.str, 0, x.start, x.end));
      const _tmp$2 = x.str;
      const _bind = _M0MPC16string6String29offset__of__nth__char_2einner(x.str, 1, x.start, x.end);
      let _tmp$3;
      if (_bind === undefined) {
        _tmp$3 = x.end;
      } else {
        const _Some = _bind;
        _tmp$3 = _Some;
      }
      const _x = new _M0TPC16string10StringView(_tmp$2, _tmp$3, x.end);
      if (_M0MPC16string10StringView14contains__char(chars, _c)) {
        _tmp = _x;
        continue;
      } else {
        return x;
      }
    }
  }
}
function _M0MPC16string10StringView22trim__end__with__chars(self, chars) {
  let _tmp = self;
  while (true) {
    const x = _tmp;
    if ((x.end - x.start | 0) === 0) {
      return x;
    } else {
      const _c = _M0MPC16string6String16unsafe__char__at(x.str, _M0MPC16string6String29offset__of__nth__char_2einner(x.str, -1, x.start, x.end));
      const _x = new _M0TPC16string10StringView(x.str, x.start, _M0MPC16string6String29offset__of__nth__char_2einner(x.str, -1, x.start, x.end));
      if (_M0MPC16string10StringView14contains__char(chars, _c)) {
        _tmp = _x;
        continue;
      } else {
        return x;
      }
    }
  }
}
function _M0MPC16string10StringView12trim_2einner(self, chars) {
  const _bind = _M0FPB23build__ascii__char__set(chars);
  if (_bind === undefined) {
    return _M0MPC16string10StringView22trim__end__with__chars(_M0MPC16string10StringView24trim__start__with__chars(self, chars), chars);
  } else {
    const _Some = _bind;
    const _x = _Some;
    const _bits0 = _x._0;
    const _bits1 = _x._1;
    const _bits2 = _x._2;
    const _bits3 = _x._3;
    const start = _M0FPB26string__trim__start__ascii(self.str, self.start, self.end, chars, _bits0, _bits1, _bits2, _bits3);
    const end = _M0FPB24string__trim__end__ascii(self.str, start, self.end, chars, _bits0, _bits1, _bits2, _bits3);
    return new _M0TPC16string10StringView(self.str, start, end);
  }
}
function _M0MPC16string6String14contains__char(self, c) {
  return _M0MPC16string10StringView14contains__char(new _M0TPC16string10StringView(self, 0, self.length), c);
}
function _M0MPC16string10StringView19trim__start_2einner(self, chars) {
  const _bind = _M0FPB23build__ascii__char__set(chars);
  if (_bind === undefined) {
    return _M0MPC16string10StringView24trim__start__with__chars(self, chars);
  } else {
    const _Some = _bind;
    const _x = _Some;
    const _bits0 = _x._0;
    const _bits1 = _x._1;
    const _bits2 = _x._2;
    const _bits3 = _x._3;
    const start = _M0FPB26string__trim__start__ascii(self.str, self.start, self.end, chars, _bits0, _bits1, _bits2, _bits3);
    return new _M0TPC16string10StringView(self.str, start, self.end);
  }
}
function _M0MPC16string10StringView17trim__end_2einner(self, chars) {
  const _bind = _M0FPB23build__ascii__char__set(chars);
  if (_bind === undefined) {
    return _M0MPC16string10StringView22trim__end__with__chars(self, chars);
  } else {
    const _Some = _bind;
    const _x = _Some;
    const _bits0 = _x._0;
    const _bits1 = _x._1;
    const _bits2 = _x._2;
    const _bits3 = _x._3;
    const end = _M0FPB24string__trim__end__ascii(self.str, self.start, self.end, chars, _bits0, _bits1, _bits2, _bits3);
    return new _M0TPC16string10StringView(self.str, self.start, end);
  }
}
function _M0MPC16string10StringView9trim__end(self, chars$46$opt) {
  let chars;
  if (chars$46$opt === undefined) {
    chars = _M0MPC16string10StringView9trim__endN6recordS761;
  } else {
    const _Some = chars$46$opt;
    chars = _Some;
  }
  return _M0MPC16string10StringView17trim__end_2einner(self, chars);
}
function _M0MPC16string6String12trim_2einner(self, chars) {
  return _M0MPC16string10StringView12trim_2einner(new _M0TPC16string10StringView(self, 0, self.length), chars);
}
function _M0MPC16string6String4trim(self, chars$46$opt) {
  let chars;
  if (chars$46$opt === undefined) {
    chars = _M0MPC16string6String4trimN6recordS768;
  } else {
    const _Some = chars$46$opt;
    chars = _Some;
  }
  return _M0MPC16string6String12trim_2einner(self, chars);
}
function _M0MPC16string6String4iter(self) {
  const len = self.length;
  const index = new _M0TPB8MutLocalGiE(0);
  return _M0MPB4Iter3newGcE(() => {
    if (index.val < len) {
      const c1 = self.charCodeAt(index.val);
      if (c1 >= 55296 && c1 <= 56319 && (index.val + 1 | 0) < len) {
        const c2 = self.charCodeAt(index.val + 1 | 0);
        if (c2 >= 56320 && c2 <= 57343) {
          const c = _M0FPB32code__point__of__surrogate__pair(c1, c2);
          index.val = index.val + 2 | 0;
          return c;
        }
      }
      index.val = index.val + 1 | 0;
      return c1;
    } else {
      return -1;
    }
  }, undefined);
}
function _M0MPB4Iter3mapGcRPC16string10StringViewE(self, f) {
  return new _M0TPB4IterGRPC16string10StringViewE(() => {
    const _bind = _M0MPB4Iter4nextGcE(self);
    if (_bind === -1) {
      return undefined;
    } else {
      const _Some = _bind;
      const _x = _Some;
      return f(_x);
    }
  }, self.size_hint);
}
function _M0IPC14char4CharPB4Show10to__string(self) {
  return String.fromCodePoint(self);
}
function _M0MPC16string10StringView5split(self, sep) {
  const sep_len = sep.end - sep.start | 0;
  if (sep_len === 0) {
    return _M0MPB4Iter3mapGcRPC16string10StringViewE(_M0MPC16string10StringView4iter(self), (c) => _M0MPC16string6String12view_2einner(_M0IPC14char4CharPB4Show10to__string(c), 0, undefined));
  }
  const remaining = new _M0TPB8MutLocalGORPC16string10StringViewE(self);
  return _M0MPB4Iter3newGUssEE(() => {
    const _bind = remaining.val;
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _view = _Some;
      const _bind$2 = _M0MPC16string10StringView4find(_view, sep);
      if (_bind$2 === undefined) {
        remaining.val = undefined;
        return _view;
      } else {
        const _Some$2 = _bind$2;
        const _end = _Some$2;
        remaining.val = _M0MPC16string10StringView12view_2einner(_view, _end + sep_len | 0, undefined);
        return _M0MPC16string10StringView12view_2einner(_view, 0, _end);
      }
    }
  }, undefined);
}
function _M0MPC16string6String5split(self, sep) {
  return _M0MPC16string10StringView5split(new _M0TPC16string10StringView(self, 0, self.length), sep);
}
function _M0MPB4Iter9to__arrayGcE(self) {
  const _bind = self.size_hint;
  let result;
  if (_bind === undefined) {
    result = [];
  } else {
    result = [];
  }
  while (true) {
    const _bind$2 = _M0MPB4Iter4nextGcE(self);
    if (_bind$2 === -1) {
      break;
    } else {
      const _Some = _bind$2;
      const _x = _Some;
      _M0MPC15array5Array4pushGcE(result, _x);
      continue;
    }
  }
  return result;
}
function _M0MPB4Iter9to__arrayGRPC16string10StringViewE(self) {
  const _bind = self.size_hint;
  let result;
  if (_bind === undefined) {
    result = [];
  } else {
    result = [];
  }
  while (true) {
    const _bind$2 = _M0MPB4Iter4nextGUssEE(self);
    if (_bind$2 === undefined) {
      break;
    } else {
      const _Some = _bind$2;
      const _x = _Some;
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(result, _x);
      continue;
    }
  }
  return result;
}
function _M0MPC14char4Char20is__ascii__uppercase(self) {
  return self >= 65 && self <= 90;
}
function _M0MPC16string10StringView9to__lower(self) {
  const _p = self.str;
  const _p$2 = self.start;
  const _p$3 = self.end;
  let _bind;
  let _tmp = _p$2;
  let _tmp$2 = 0;
  while (true) {
    const _p$4 = _tmp;
    const _p$5 = _tmp$2;
    if (_p$4 < _p$3) {
      let _p$6;
      let _p$7;
      _L: {
        const _p$8 = _p.charCodeAt(_p$4);
        if (_p$8 >= 55296 && _p$8 <= 56319 && (_p$4 + 1 | 0) < _p$3) {
          const _p$9 = _p.charCodeAt(_p$4 + 1 | 0);
          if (_p$9 >= 56320 && _p$9 <= 57343) {
            const _tmp$3 = _p$4 + 2 | 0;
            const _p$10 = (((Math.imul(_p$8 - 55296 | 0, 1024) | 0) + _p$9 | 0) - 56320 | 0) + 65536 | 0;
            _p$6 = _tmp$3;
            _p$7 = _p$10;
            break _L;
          } else {
            const _tmp$3 = _p$4 + 1 | 0;
            const _p$10 = _p$8;
            _p$6 = _tmp$3;
            _p$7 = _p$10;
            break _L;
          }
        } else {
          const _tmp$3 = _p$4 + 1 | 0;
          const _p$9 = _p$8;
          _p$6 = _tmp$3;
          _p$7 = _p$9;
          break _L;
        }
      }
      if (_M0MPC14char4Char20is__ascii__uppercase(_p$7)) {
        _bind = _p$5;
        break;
      }
      _tmp = _p$6;
      const _p$8 = _p$7;
      _tmp$2 = _p$5 + (_p$8 <= 65535 ? 1 : 2) | 0;
      continue;
    } else {
      _bind = undefined;
      break;
    }
  }
  if (_bind === undefined) {
    return self;
  } else {
    const _Some = _bind;
    const _idx = _Some;
    const buf = _M0MPB13StringBuilder21StringBuilder_2einner(self.end - self.start | 0);
    const head = _M0MPC16string10StringView12view_2einner(self, 0, _idx);
    _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(buf, head.str, head.start, head.end - head.start | 0);
    const _bind$2 = _M0MPC16string10StringView12view_2einner(self, _idx, undefined);
    const _bind$3 = _bind$2.str;
    const _bind$4 = _bind$2.start;
    const _bind$5 = _bind$2.end;
    let _tmp$3 = _bind$4;
    while (true) {
      const _string_index = _tmp$3;
      if (_string_index < _bind$5) {
        let _decoded_next_string_index;
        let _decoded_char;
        _L: {
          const _bind$6 = _bind$3.charCodeAt(_string_index);
          if (_bind$6 >= 55296 && _bind$6 <= 56319 && (_string_index + 1 | 0) < _bind$5) {
            const _bind$7 = _bind$3.charCodeAt(_string_index + 1 | 0);
            if (_bind$7 >= 56320 && _bind$7 <= 57343) {
              const _tmp$4 = _string_index + 2 | 0;
              const _p$4 = (((Math.imul(_bind$6 - 55296 | 0, 1024) | 0) + _bind$7 | 0) - 56320 | 0) + 65536 | 0;
              _decoded_next_string_index = _tmp$4;
              _decoded_char = _p$4;
              break _L;
            } else {
              const _tmp$4 = _string_index + 1 | 0;
              const _p$4 = _bind$6;
              _decoded_next_string_index = _tmp$4;
              _decoded_char = _p$4;
              break _L;
            }
          } else {
            const _tmp$4 = _string_index + 1 | 0;
            const _p$4 = _bind$6;
            _decoded_next_string_index = _tmp$4;
            _decoded_char = _p$4;
            break _L;
          }
        }
        if (_M0MPC14char4Char20is__ascii__uppercase(_decoded_char)) {
          _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char + 32 | 0);
        } else {
          _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char);
        }
        _tmp$3 = _decoded_next_string_index;
        continue;
      } else {
        break;
      }
    }
    const _bind$6 = buf.val;
    return new _M0TPC16string10StringView(_bind$6, 0, _bind$6.length);
  }
}
function _M0MPC16string6String9to__lower(self) {
  const _bind = _M0MPC16string6String8find__by(self, (c) => _M0MPC14char4Char20is__ascii__uppercase(c));
  if (_bind === undefined) {
    return self;
  } else {
    const _Some = _bind;
    const _idx = _Some;
    const buf = _M0MPB13StringBuilder21StringBuilder_2einner(self.length);
    const head = _M0MPC16string6String12view_2einner(self, 0, _idx);
    _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(buf, head.str, head.start, head.end - head.start | 0);
    const _bind$2 = _M0MPC16string6String12view_2einner(self, _idx, undefined);
    const _bind$3 = _bind$2.str;
    const _bind$4 = _bind$2.start;
    const _bind$5 = _bind$2.end;
    let _tmp = _bind$4;
    while (true) {
      const _string_index = _tmp;
      if (_string_index < _bind$5) {
        let _decoded_next_string_index;
        let _decoded_char;
        _L: {
          const _bind$6 = _bind$3.charCodeAt(_string_index);
          if (_bind$6 >= 55296 && _bind$6 <= 56319 && (_string_index + 1 | 0) < _bind$5) {
            const _bind$7 = _bind$3.charCodeAt(_string_index + 1 | 0);
            if (_bind$7 >= 56320 && _bind$7 <= 57343) {
              const _tmp$2 = _string_index + 2 | 0;
              const _p = (((Math.imul(_bind$6 - 55296 | 0, 1024) | 0) + _bind$7 | 0) - 56320 | 0) + 65536 | 0;
              _decoded_next_string_index = _tmp$2;
              _decoded_char = _p;
              break _L;
            } else {
              const _tmp$2 = _string_index + 1 | 0;
              const _p = _bind$6;
              _decoded_next_string_index = _tmp$2;
              _decoded_char = _p;
              break _L;
            }
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$6;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        }
        if (_M0MPC14char4Char20is__ascii__uppercase(_decoded_char)) {
          _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char + 32 | 0);
        } else {
          _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char);
        }
        _tmp = _decoded_next_string_index;
        continue;
      } else {
        break;
      }
    }
    return buf.val;
  }
}
function _M0MPC16string6String9get__char(self, idx) {
  if (idx >= 0 && idx < self.length) {
    const c = self.charCodeAt(idx);
    if (c >= 55296 && c <= 56319) {
      if ((idx + 1 | 0) < self.length) {
        const next = self.charCodeAt(idx + 1 | 0);
        return next >= 56320 && next <= 57343 ? _M0FPB32code__point__of__surrogate__pair(c, next) : -1;
      } else {
        return -1;
      }
    } else {
      return c >= 56320 && c <= 57343 ? -1 : c;
    }
  } else {
    return -1;
  }
}
function _M0MPC16string10StringView9get__char(self, idx) {
  if (idx >= 0 && idx < (self.end - self.start | 0)) {
    const c = self.str.charCodeAt(self.start + idx | 0);
    if (c >= 55296 && c <= 56319) {
      if ((idx + 1 | 0) < (self.end - self.start | 0)) {
        const next = self.str.charCodeAt(self.start + (idx + 1 | 0) | 0);
        return next >= 56320 && next <= 57343 ? _M0FPB32code__point__of__surrogate__pair(c, next) : -1;
      } else {
        return -1;
      }
    } else {
      return c >= 56320 && c <= 57343 ? -1 : c;
    }
  } else {
    return -1;
  }
}
function _M0IPC16string6StringPB12ToStringView16to__string__view(self) {
  return new _M0TPC16string10StringView(self, 0, self.length);
}
function _M0FPB19join__string__viewsGsE(parts, separator) {
  if ((parts.end - parts.start | 0) === 0) {
    return "";
  } else {
    if ((parts.end - parts.start | 0) === 1) {
      const _one = parts.buf[parts.start];
      return _M0MPC16string10StringView9to__owned(_M0IPC16string6StringPB12ToStringView16to__string__view(_one));
    } else {
      const _first = parts.buf[parts.start];
      const _x_buf = parts.buf;
      const _x_start = 1 + parts.start | 0;
      const _x_end = parts.end;
      const separator$2 = _M0MPC16string10StringView9to__owned(separator);
      let result = _M0MPC16string10StringView9to__owned(_M0IPC16string6StringPB12ToStringView16to__string__view(_first));
      const _bind = _x_end - _x_start | 0;
      let _tmp = 0;
      while (true) {
        const _ = _tmp;
        if (_ < _bind) {
          const part = _x_buf[_x_start + _ | 0];
          result = `${result}${separator$2}`;
          result = `${result}${_M0MPC16string10StringView9to__owned(_M0IPC16string6StringPB12ToStringView16to__string__view(part))}`;
          _tmp = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      return result;
    }
  }
}
function _M0FPB19join__string__viewsGRPC16string10StringViewE(parts, separator) {
  if ((parts.end - parts.start | 0) === 0) {
    return "";
  } else {
    if ((parts.end - parts.start | 0) === 1) {
      const _one = parts.buf[parts.start];
      return _M0MPC16string10StringView9to__owned(_one);
    } else {
      const _first = parts.buf[parts.start];
      const _x_buf = parts.buf;
      const _x_start = 1 + parts.start | 0;
      const _x_end = parts.end;
      const separator$2 = _M0MPC16string10StringView9to__owned(separator);
      let result = _M0MPC16string10StringView9to__owned(_first);
      const _bind = _x_end - _x_start | 0;
      let _tmp = 0;
      while (true) {
        const _ = _tmp;
        if (_ < _bind) {
          const part = _x_buf[_x_start + _ | 0];
          result = `${result}${separator$2}`;
          result = `${result}${_M0MPC16string10StringView9to__owned(part)}`;
          _tmp = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      return result;
    }
  }
}
function _M0MPC16string6String9to__array(self) {
  const chars = [];
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const _string_index = _tmp;
    if (_string_index < _bind) {
      let _decoded_next_string_index;
      let _decoded_char;
      _L: {
        const _bind$2 = self.charCodeAt(_string_index);
        if (_bind$2 >= 55296 && _bind$2 <= 56319 && (_string_index + 1 | 0) < _bind) {
          const _bind$3 = self.charCodeAt(_string_index + 1 | 0);
          if (_bind$3 >= 56320 && _bind$3 <= 57343) {
            const _tmp$2 = _string_index + 2 | 0;
            const _p = (((Math.imul(_bind$2 - 55296 | 0, 1024) | 0) + _bind$3 | 0) - 56320 | 0) + 65536 | 0;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$2;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        } else {
          const _tmp$2 = _string_index + 1 | 0;
          const _p = _bind$2;
          _decoded_next_string_index = _tmp$2;
          _decoded_char = _p;
          break _L;
        }
      }
      _M0MPC15array5Array4pushGcE(chars, _decoded_char);
      _tmp = _decoded_next_string_index;
      continue;
    } else {
      break;
    }
  }
  return chars;
}
function _M0IPC13int3IntPB4Show10to__string(self) {
  return _M0MPC13int3Int18to__string_2einner(self, 10);
}
function _M0MPC15array9ArrayView4iterGUssEE(self) {
  const i = new _M0TPB8MutLocalGiE(0);
  const len = self.end - self.start | 0;
  return _M0MPB4Iter3newGUssEE(() => {
    if (i.val < len) {
      const elem = self.buf[self.start + i.val | 0];
      i.val = i.val + 1 | 0;
      return elem;
    } else {
      return undefined;
    }
  }, len);
}
function _M0MPC15array5Array4iterGUssEE(self) {
  return _M0MPC15array9ArrayView4iterGUssEE(new _M0TPB9ArrayViewGUssEE(self, 0, self.length));
}
function _M0MPC15array9ArrayView21clamped__view_2einnerGkE(self, start, end) {
  const len = self.end - self.start | 0;
  const lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _end = _Some;
    hi = _end < 0 ? 0 : _end > len ? len : _end;
  }
  const count = hi > lo ? hi - lo | 0 : 0;
  const _bind = self.buf;
  const _bind$2 = self.start + lo | 0;
  return new _M0TPB9ArrayViewGkE(_bind, _bind$2, _bind$2 + count | 0);
}
function _M0MPC15array9ArrayView4joinGsE(self, separator) {
  return _M0FPB19join__string__viewsGsE(self, separator);
}
function _M0MPC15array9ArrayView4joinGRPC16string10StringViewE(self, separator) {
  return _M0FPB19join__string__viewsGRPC16string10StringViewE(self, separator);
}
function _M0IPC16option6OptionPB2Eq5equalGcE(self, other) {
  if (self === -1) {
    return other === -1;
  } else {
    const _Some = self;
    const _x = _Some;
    if (other === -1) {
      return false;
    } else {
      const _Some$2 = other;
      const _y = _Some$2;
      return _x === _y;
    }
  }
}
function _M0MPC16option6Option10unwrap__orGcE(self, default_) {
  if (self === -1) {
    return default_;
  } else {
    const _Some = self;
    const _t = _Some;
    return _t;
  }
}
function _M0MPC16option6Option10unwrap__orGsE(self, default_) {
  if (self === undefined) {
    return default_;
  } else {
    const _Some = self;
    const _t = _Some;
    return _t;
  }
}
function _M0MPC16option6Option10unwrap__orGRPB5ArrayGRP212moonbitstack8moonmail10AttachmentEE(self, default_) {
  if (self.$tag === 1) {
    const _Some = self;
    const _t = _Some._0;
    return _t;
  } else {
    return default_;
  }
}
function _M0MPC16option6Option16unwrap__or__elseGsE(self, default_) {
  if (self === undefined) {
    return default_();
  } else {
    const _Some = self;
    const _t = _Some;
    return _t;
  }
}
function _M0MPC16option6Option17unwrap__or__errorGRP212moonbitstack8moonmime7CharsetRP212moonbitstack8moonmime7RefusedE(self, err) {
  if (self === undefined) {
    return new _M0DTPC16result6ResultGRP212moonbitstack8moonmime7CharsetRP212moonbitstack8moonmime7RefusedE3Err(err);
  } else {
    const _Some = self;
    const _v = _Some;
    return new _M0DTPC16result6ResultGRP212moonbitstack8moonmime7CharsetRP212moonbitstack8moonmime7RefusedE2Ok(_v);
  }
}
function _M0MPC16option6Option3mapGssE(self, f) {
  if (self === undefined) {
    return undefined;
  } else {
    const _Some = self;
    const _t = _Some;
    return f(_t);
  }
}
function _M0MPC16option6Option3mapGRPC16string10StringViewsE(self, f) {
  if (self === undefined) {
    return undefined;
  } else {
    const _Some = self;
    const _t = _Some;
    return f(_t);
  }
}
function _M0MPC16option6Option3mapGsUsbEE(self, f) {
  if (self === undefined) {
    return undefined;
  } else {
    const _Some = self;
    const _t = _Some;
    return f(_t);
  }
}
function _M0MPC16option6Option4bindGRP212moonbitstack8moonmail7MessageRP212moonbitstack8moonmail7MessageE(self, f) {
  if (self === undefined) {
    return undefined;
  } else {
    const _Some = self;
    const _t = _Some;
    return f(_t);
  }
}
function _M0MPC15array5Array31unsafe__make__and__blit_2einnerGyE(src, allocate_len, len, src_offset, dst_offset) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGyE(dst, dst_offset, src, src_offset, len);
  return dst;
}
function _M0MPC15array5Array31unsafe__make__and__blit_2einnerGsE(src, allocate_len, len, src_offset, dst_offset) {
  const dst = new Array(allocate_len);
  _M0MPB18UninitializedArray12unsafe__blitGsE(dst, dst_offset, src, src_offset, len);
  return dst;
}
function _M0MPC15array9ArrayView9to__ownedGyE(self) {
  const len = self.end - self.start | 0;
  return len === 0 ? [] : _M0MPC15array5Array31unsafe__make__and__blit_2einnerGyE(self.buf, len, len, self.start, 0);
}
function _M0FPB21calc__grow__threshold(capacity) {
  return (Math.imul(capacity / 16 | 0, 13) | 0) + ((Math.imul(capacity % 16 | 0, 13) | 0) / 16 | 0) | 0;
}
function _M0MPC13int3Int20next__power__of__two(self) {
  if (self >= 0) {
    if (self <= 1) {
      return 1;
    }
    if (self > 1073741824) {
      return 1073741824;
    }
    return (2147483647 >> (Math.clz32(self - 1 | 0) - 1 | 0)) + 1 | 0;
  } else {
    return $panic();
  }
}
function _M0FPB8new__mapGsRPB4JsonE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = capacity$2 - 1 | 0;
  const _bind$2 = _M0FPB21calc__grow__threshold(capacity$2);
  const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$4 = undefined;
  return new _M0TPB3MapGsRPB4JsonE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
}
function _M0FPB21capacity__for__length(length) {
  if (length <= _M0FPB21calc__grow__threshold(1073741824)) {
    let capacity = _M0MPC13int3Int20next__power__of__two(length);
    if (length > _M0FPB21calc__grow__threshold(capacity)) {
      capacity = Math.imul(capacity, 2) | 0;
    }
    return capacity;
  } else {
    console.error("Map capacity overflow");
    return $panic();
  }
}
function _M0MPB3Map20add__entry__to__tailGsRPB4JsonE(self, idx, entry) {
  const _bind = self.tail;
  if (_bind === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    const _p = _bind >>> 0 < _tmp.length ? _tmp[_bind] : $oob();
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  self.entries[idx] = entry;
  self.size = self.size + 1 | 0;
}
function _M0MPB3Map10set__entryGsRPB4JsonE(self, entry, new_idx) {
  const _bind = entry.next;
  if (_bind === undefined) {
    self.tail = new_idx;
  } else {
    const _Some = _bind;
    const _next = _Some;
    _next.prev = new_idx;
  }
  self.entries[new_idx] = entry;
}
function _M0MPB3Map10push__awayGsRPB4JsonE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      _M0MPB3Map10set__entryGsRPB4JsonE(self, entry$2, idx$2);
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGsRPB4JsonE(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map20rehash__place__entryGsRPB4JsonE(self, outer) {
  const hash = outer.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      outer.psl = psl;
      outer.prev = self.tail;
      _M0MPB3Map20add__entry__to__tailGsRPB4JsonE(self, idx, outer);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPB3Map10push__awayGsRPB4JsonE(self, idx, _curr);
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGsRPB4JsonE(self, idx, outer);
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map4growGsRPB4JsonE(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  self.grow_at = _M0FPB21calc__grow__threshold(self.capacity);
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      return;
    } else {
      const _Some = x;
      const _e = _Some;
      const next_in_chain = _e.next;
      _e.next = undefined;
      _M0MPB3Map20rehash__place__entryGsRPB4JsonE(self, _e);
      _tmp = next_in_chain;
      continue;
    }
  }
}
function _M0MPB3Map15set__with__hashGsRPB4JsonE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= self.grow_at) {
        _M0MPB3Map4growGsRPB4JsonE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$2 = self.tail;
      const _bind$3 = undefined;
      const entry = new _M0TPB5EntryGsRPB4JsonE(_bind$2, _bind$3, psl, hash, key, value);
      _M0MPB3Map20add__entry__to__tailGsRPB4JsonE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGsRPB4JsonE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPB3Map10push__awayGsRPB4JsonE(self, idx, _curr_entry);
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGsRPB4JsonE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGsRPB4JsonE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map3setGsRPB4JsonE(self, key, value) {
  _M0MPB3Map15set__with__hashGsRPB4JsonE(self, key, value, _M0IPC16string6StringPB4Hash4hash(key));
}
function _M0MPB3Map3MapGsRPB4JsonE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    capacity$2 = _M0FPB21capacity__for__length(_capacity > length ? _capacity : length);
  }
  const m = _M0FPB8new__mapGsRPB4JsonE(capacity$2);
  const _bind = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = arr.buf[arr.start + _ | 0];
      _M0MPB3Map3setGsRPB4JsonE(m, e._0, e._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPB3Map3getGsRPB4JsonE(self, key) {
  const hash = _M0IPC16string6StringPB4Hash4hash(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map3getGsRP212moonbitstack8moonmime7CharsetE(self, key) {
  const hash = _M0IPC16string6StringPB4Hash4hash(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return _entry.value;
      }
      if (i > _entry.psl) {
        return undefined;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map8containsGsRPB4JsonE(self, key) {
  const hash = _M0IPC16string6StringPB4Hash4hash(key);
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const i = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      return false;
    } else {
      const _Some = _bind;
      const _entry = _Some;
      if (_entry.hash === hash && _entry.key === key) {
        return true;
      }
      if (i > _entry.psl) {
        return false;
      }
      _tmp = i + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map4iterGsRPB4JsonE(self) {
  const curr_entry = new _M0TPB8MutLocalGORPB5EntryGsRPB4JsonEE(self.head);
  const len = self.size;
  const remaining = new _M0TPB8MutLocalGiE(len);
  return _M0MPB4Iter3newGUssEE(() => {
    _L: {
      if (remaining.val > 0) {
        const _bind = curr_entry.val;
        if (_bind === undefined) {
          break _L;
        } else {
          const _Some = _bind;
          const _x = _Some;
          const _key = _x.key;
          const _value = _x.value;
          const _next = _x.next;
          curr_entry.val = _next;
          remaining.val = remaining.val - 1 | 0;
          return { _0: _key, _1: _value };
        }
      } else {
        break _L;
      }
    }
    return undefined;
  }, len);
}
function _M0MPB3Map5iter2GsRPB4JsonE(self) {
  return _M0MPB3Map4iterGsRPB4JsonE(self);
}
function _M0MPC15bytes5Bytes20unsafe__range__equal(self, self_off, other, other_off, len) {
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < len) {
      if (self[self_off + i | 0] === other[other_off + i | 0]) {
      } else {
        return false;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0MPB4Iter6filterGcE(self, f) {
  return _M0MPB4Iter3newGcE(() => {
    while (true) {
      const _bind = _M0MPB4Iter4nextGcE(self);
      if (_bind === -1) {
        return -1;
      } else {
        const _Some = _bind;
        const _x = _Some;
        if (f(_x)) {
          return _x;
        }
        continue;
      }
    }
  }, undefined);
}
function _M0MPB5Iter24nextGsRPB4JsonE(self) {
  return _M0MPB4Iter4nextGUssEE(self);
}
function _M0IPC16string6StringPB4Hash4hash(self) {
  let acc = (_M0FPB4seed >>> 0) + (374761393 >>> 0) | 0;
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      acc = (acc >>> 0) + (4 >>> 0) | 0;
      const v = self.charCodeAt(i);
      acc = _M0FPB13consume4__acc(acc, v);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0FPB13finalize__acc(acc);
}
function _M0MPC15array10FixedArray23unsafe__make__and__blitGyE(src, allocate_len, init, src_offset, dst_offset, blit_len) {
  const dst = $makebytes(allocate_len, init);
  _M0MPC15array10FixedArray12unsafe__blitGyE(dst, dst_offset, src, src_offset, blit_len);
  return dst;
}
function _M0MPC15array10FixedArray23make__and__blit_2einnerGyE(src, allocate_len, init, len, src_offset, dst_offset) {
  if (allocate_len >= 0 && (len >= 0 && (src_offset >= 0 && (dst_offset >= 0 && ((src_offset + len | 0) <= src.length && (dst_offset + len | 0) <= allocate_len))))) {
    return _M0MPC15array10FixedArray23unsafe__make__and__blitGyE(src, allocate_len, init, src_offset, dst_offset, len);
  } else {
    const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(89);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "bounds check failed: allocate_len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, allocate_len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", dst_offset = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, dst_offset);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", len = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, len);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, ", src.length = ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder, src.length);
    console.error(_string_builder.val);
    return $panic();
  }
}
function _M0MPC16double6Double7to__int(self) {
  return self !== self ? 0 : self >= 2147483647 ? 2147483647 : self <= -2147483648 ? -2147483648 : self | 0;
}
function _M0IPC16double6DoublePB4Show10to__string(self) {
  return String(self);
}
function _M0MPC14char4Char7to__hex(char) {
  const code = char;
  return code >= 0 && code <= 255 ? _M0MPC14byte4Byte7to__hex(code & 255) : code <= 65535 ? `${_M0MPC14byte4Byte7to__hex(code >> 8 & 255)}${_M0MPC14byte4Byte7to__hex(code & 255)}` : `${_M0MPC14byte4Byte7to__hex(code >> 16 & 255)}${_M0MPC14byte4Byte7to__hex(code >> 8 & 255)}${_M0MPC14byte4Byte7to__hex(code & 255)}`;
}
function _M0MPC14char4Char21is__ascii__whitespace(self) {
  return self >= 9 && self <= 13 ? true : self === 32;
}
function _M0MPC14char4Char11is__control(self) {
  return self >= 0 && self <= 31 ? true : self >= 127 && self <= 159;
}
function _M0MPC14char4Char14is__whitespace(self) {
  if (self <= 32) {
    return _M0MPC14char4Char21is__ascii__whitespace(self);
  }
  return self === 133 ? true : self === 160 ? true : self === 5760 ? true : self >= 8192 && self <= 8202 ? true : self === 8232 ? true : self === 8233 ? true : self === 8239 ? true : self === 8287 ? true : self === 12288;
}
function _M0MPC14char4Char13is__printable(self) {
  if (_M0MPC14char4Char11is__control(self)) {
    return false;
  }
  const self$2 = self;
  _L: {
    _L$2: {
      if (self$2 >= 57344 && self$2 <= 63743) {
        break _L$2;
      } else {
        if (self$2 >= 983040 && self$2 <= 1048573) {
          break _L$2;
        } else {
          if (self$2 >= 1048576 && self$2 <= 1114109) {
            break _L$2;
          }
        }
      }
      break _L;
    }
    return false;
  }
  _L$2: {
    _L$3: {
      if (self$2 === 173) {
        break _L$3;
      } else {
        if (self$2 >= 1536 && self$2 <= 1541) {
          break _L$3;
        } else {
          if (self$2 === 1564) {
            break _L$3;
          } else {
            if (self$2 === 1757) {
              break _L$3;
            } else {
              if (self$2 === 1807) {
                break _L$3;
              } else {
                if (self$2 >= 2192 && self$2 <= 2193) {
                  break _L$3;
                } else {
                  if (self$2 === 2274) {
                    break _L$3;
                  } else {
                    if (self$2 === 6158) {
                      break _L$3;
                    } else {
                      if (self$2 >= 8203 && self$2 <= 8207) {
                        break _L$3;
                      } else {
                        if (self$2 >= 8234 && self$2 <= 8238) {
                          break _L$3;
                        } else {
                          if (self$2 >= 8288 && self$2 <= 8292) {
                            break _L$3;
                          } else {
                            if (self$2 >= 8294 && self$2 <= 8303) {
                              break _L$3;
                            } else {
                              if (self$2 === 65279) {
                                break _L$3;
                              } else {
                                if (self$2 >= 65529 && self$2 <= 65531) {
                                  break _L$3;
                                } else {
                                  if (self$2 === 69821) {
                                    break _L$3;
                                  } else {
                                    if (self$2 === 69837) {
                                      break _L$3;
                                    } else {
                                      if (self$2 >= 78896 && self$2 <= 78911) {
                                        break _L$3;
                                      } else {
                                        if (self$2 >= 113824 && self$2 <= 113827) {
                                          break _L$3;
                                        } else {
                                          if (self$2 >= 119155 && self$2 <= 119162) {
                                            break _L$3;
                                          } else {
                                            if (self$2 === 917505) {
                                              break _L$3;
                                            } else {
                                              if (self$2 >= 917536 && self$2 <= 917631) {
                                                break _L$3;
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      break _L$2;
    }
    return false;
  }
  if (55296 <= self$2 && self$2 <= 57343) {
    return false;
  }
  if (self$2 === 8232 || self$2 === 8233) {
    return false;
  }
  _L$3: {
    _L$4: {
      if (self$2 >= 64976 && self$2 <= 65007) {
        break _L$4;
      } else {
        if (self$2 >= 65534 && self$2 <= 65535) {
          break _L$4;
        } else {
          if (self$2 >= 131070 && self$2 <= 131071) {
            break _L$4;
          } else {
            if (self$2 >= 196606 && self$2 <= 196607) {
              break _L$4;
            } else {
              if (self$2 >= 262142 && self$2 <= 262143) {
                break _L$4;
              } else {
                if (self$2 >= 327678 && self$2 <= 327679) {
                  break _L$4;
                } else {
                  if (self$2 >= 393214 && self$2 <= 393215) {
                    break _L$4;
                  } else {
                    if (self$2 >= 458750 && self$2 <= 458751) {
                      break _L$4;
                    } else {
                      if (self$2 >= 524286 && self$2 <= 524287) {
                        break _L$4;
                      } else {
                        if (self$2 >= 589822 && self$2 <= 589823) {
                          break _L$4;
                        } else {
                          if (self$2 >= 655358 && self$2 <= 655359) {
                            break _L$4;
                          } else {
                            if (self$2 >= 720894 && self$2 <= 720895) {
                              break _L$4;
                            } else {
                              if (self$2 >= 786430 && self$2 <= 786431) {
                                break _L$4;
                              } else {
                                if (self$2 >= 851966 && self$2 <= 851967) {
                                  break _L$4;
                                } else {
                                  if (self$2 >= 917502 && self$2 <= 917503) {
                                    break _L$4;
                                  } else {
                                    if (self$2 >= 983038 && self$2 <= 983039) {
                                      break _L$4;
                                    } else {
                                      if (self$2 >= 1048574 && self$2 <= 1048575) {
                                        break _L$4;
                                      } else {
                                        if (self$2 >= 1114110 && self$2 <= 1114111) {
                                          break _L$4;
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      break _L$3;
    }
    return false;
  }
  return true;
}
function _M0MPC14char4Char18escape__to_2einner(self, logger, quote) {
  if (quote) {
    logger.method_table.method_3(logger.self, 39);
  }
  _L: {
    _L$2: {
      if (self === 39) {
        break _L$2;
      } else {
        if (self === 92) {
          break _L$2;
        } else {
          if (self === 10) {
            logger.method_table.method_0(logger.self, "\\n");
          } else {
            if (self === 13) {
              logger.method_table.method_0(logger.self, "\\r");
            } else {
              if (self === 8) {
                logger.method_table.method_0(logger.self, "\\b");
              } else {
                if (self === 9) {
                  logger.method_table.method_0(logger.self, "\\t");
                } else {
                  if (self >= 32 && self <= 126) {
                    logger.method_table.method_3(logger.self, self);
                  } else {
                    if (!_M0MPC14char4Char13is__printable(self)) {
                      logger.method_table.method_0(logger.self, "\\u{");
                      logger.method_table.method_0(logger.self, _M0MPC14char4Char7to__hex(self));
                      logger.method_table.method_0(logger.self, "}");
                    } else {
                      logger.method_table.method_3(logger.self, self);
                    }
                  }
                }
              }
            }
          }
        }
      }
      break _L;
    }
    logger.method_table.method_3(logger.self, 92);
    logger.method_table.method_3(logger.self, self);
  }
  if (quote) {
    logger.method_table.method_3(logger.self, 39);
    return;
  } else {
    return;
  }
}
function _M0MPC14char4Char14escape_2einner(self, quote) {
  const buf = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  _M0MPC14char4Char18escape__to_2einner(self, { self: buf, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger }, quote);
  return buf.val;
}
function _M0MPC15bytes5Bytes21clamped__view_2einner(self, start, end) {
  const len = self.length;
  const lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _end = _Some;
    hi = _end < 0 ? 0 : _end > len ? len : _end;
  }
  const count = hi > lo ? hi - lo | 0 : 0;
  return new _M0TPC15bytes9BytesView(self, lo, lo + count | 0);
}
function _M0MPC15bytes9BytesView21clamped__view_2einner(self, start, end) {
  const len = self.end - self.start | 0;
  const lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _end = _Some;
    hi = _end < 0 ? 0 : _end > len ? len : _end;
  }
  const count = hi > lo ? hi - lo | 0 : 0;
  const _bind = self.buf;
  const _bind$2 = self.start + lo | 0;
  return new _M0TPC15bytes9BytesView(_bind, _bind$2, _bind$2 + count | 0);
}
function _M0MPC15bytes9BytesView4iter(self) {
  const i = new _M0TPB8MutLocalGiE(0);
  const len = self.end - self.start | 0;
  return _M0MPB4Iter3newGyE(() => {
    if (i.val < len) {
      const result = self.buf[self.start + i.val | 0];
      i.val = i.val + 1 | 0;
      return result;
    } else {
      return -1;
    }
  }, len);
}
function _M0IPC15bytes9BytesViewPB2Eq5equal(self, other) {
  const len = self.end - self.start | 0;
  return len === (other.end - other.start | 0) ? _M0MPC15bytes5Bytes20unsafe__range__equal(self.buf, self.start, other.buf, other.start, len) : false;
}
function _M0MPC15array10FixedArray17blit__from__bytes(self, bytes_offset, src, src_offset, length) {
  const len1 = self.length;
  const len2 = src.length;
  if (length >= 0 && (bytes_offset >= 0 && (bytes_offset <= len1 && (length <= (len1 - bytes_offset | 0) && (src_offset >= 0 && (src_offset <= len2 && length <= (len2 - src_offset | 0))))))) {
    _M0MPC15array10FixedArray12unsafe__blitGyE(self, bytes_offset, src, src_offset, length);
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15bytes9BytesView9to__owned(self) {
  if ((self.end - self.start | 0) === self.buf.length) {
    return self.buf;
  }
  const bytes = $makebytes(self.end - self.start | 0, 0);
  _M0MPC15array10FixedArray17blit__from__bytes(bytes, 0, self.buf, self.start, self.end - self.start | 0);
  return bytes;
}
function _M0MPC15bytes5Bytes11from__array(arr) {
  const len = arr.end - arr.start | 0;
  if (len === 0) {
    return $bytes_literal$2;
  }
  const result = _M0MPB18UninitializedArray23unsafe__make__and__blitGyE(arr.buf, len, arr.start, 0, len);
  return result;
}
function _M0MPC15array5Array21clamped__view_2einnerGyE(self, start, end) {
  const len = self.length;
  const lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _end = _Some;
    hi = _end < 0 ? 0 : _end > len ? len : _end;
  }
  const count = hi > lo ? hi - lo | 0 : 0;
  const _bind = self;
  return new _M0TPB9ArrayViewGyE(_bind, lo, lo + count | 0);
}
function _M0MPC15array5Array21clamped__view_2einnerGcE(self, start, end) {
  const len = self.length;
  const lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _end = _Some;
    hi = _end < 0 ? 0 : _end > len ? len : _end;
  }
  const count = hi > lo ? hi - lo | 0 : 0;
  const _bind = self;
  return new _M0TPB9ArrayViewGcE(_bind, lo, lo + count | 0);
}
function _M0MPC15array5Array6appendGsE(self, other) {
  const old_len = self.length;
  const append_len = other.end - other.start | 0;
  if ((old_len + append_len | 0) >= old_len) {
    _M0MPB7JSArray12append__view(self, other.buf, other.start, append_len);
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15array5Array11unsafe__popGRPC14json10WriteFrameE(self) {
  return _M0MPB7JSArray3pop(self);
}
function _M0MPC15array5Array3popGRPC14json10WriteFrameE(self) {
  if (self.length === 0) {
    return undefined;
  } else {
    const v = _M0MPC15array5Array11unsafe__popGRPC14json10WriteFrameE(self);
    return v;
  }
}
function _M0MPC15array5Array2atGUssEE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array2atGcE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array2atGiE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array3setGUssEE(self, index, value) {
  const len = self.length;
  if (index >= 0 && index < len) {
    self[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15array5Array3setGiE(self, index, value) {
  const len = self.length;
  if (index >= 0 && index < len) {
    self[index] = value;
    return;
  } else {
    $panic();
    return;
  }
}
function _M0MPC15array5Array4makeGiE(len, elem) {
  const arr = new Array(len);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < len) {
      arr[i] = elem;
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return arr;
}
function _M0MPC15array5Array3getGcE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : -1;
}
function _M0MPC15array5Array3getGRP212moonbitstack8moonmail7MessageE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : undefined;
}
function _M0IPC15array5ArrayPB3Add3addGsE(self, other) {
  const len_self = self.length;
  const len_other = other.length;
  if (len_self === 0) {
    return _M0MPC15array5Array31unsafe__make__and__blit_2einnerGsE(other, len_other, len_other, 0, 0);
  } else {
    const result = _M0MPC15array5Array31unsafe__make__and__blit_2einnerGsE(self, len_self + len_other | 0, len_self, 0, 0);
    _M0MPB18UninitializedArray12unsafe__blitGsE(result, len_self, other, 0, len_other);
    return result;
  }
}
function _M0MPC15array5Array6filterGsE(self, f) {
  const _acc = [];
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const v = self[_];
      if (f(v)) {
        _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_acc, v);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return _acc;
    }
  }
}
function _M0MPC15array5Array6filterGRP212moonbitstack8moonmail10AttachmentE(self, f) {
  const _acc = [];
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const v = self[_];
      if (f(v)) {
        _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_acc, v);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return _acc;
    }
  }
}
function _M0MPC15array5Array8containsGiE(self, value) {
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const v = self[_];
      if (v === value) {
        return true;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return false;
    }
  }
}
function _M0MPC15array5Array10push__iterGsE(self, iter) {
  const _bind = iter.size_hint;
  if (_bind === undefined) {
  }
  while (true) {
    const _bind$2 = _M0MPB4Iter4nextGUssEE(iter);
    if (_bind$2 === undefined) {
      return;
    } else {
      const _Some = _bind$2;
      const _x = _Some;
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(self, _x);
      continue;
    }
  }
}
function _M0MPC15array5Array4joinGsE(self, separator) {
  return _M0MPC15array9ArrayView4joinGsE(new _M0TPB9ArrayViewGsE(self, 0, self.length), separator);
}
function _M0MPC15array5Array4joinGRPC16string10StringViewE(self, separator) {
  return _M0MPC15array9ArrayView4joinGRPC16string10StringViewE(new _M0TPB9ArrayViewGRPC16string10StringViewE(self, 0, self.length), separator);
}
function _M0FPC15float35f2s__multiple__of__power__of__5__32(value, p) {
  let value$2 = value;
  let count = 0;
  while (true) {
    if (((value$2 >>> 0) % (5 >>> 0) | 0) === 0) {
      value$2 = (value$2 >>> 0) / (5 >>> 0) | 0;
      count = count + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return count >= p;
}
function _M0FPC15float19f2s__mul__shift__32(m, factor, shift) {
  const factor_lo = BigInt.asUintN(64, factor & 4294967295n);
  const factor_hi = BigInt.asUintN(64, BigInt.asUintN(64, factor) >> BigInt(32 & 63));
  const m$2 = BigInt.asUintN(64, BigInt(m >>> 0));
  const bits0 = BigInt.asUintN(64, m$2 * factor_lo);
  const bits1 = BigInt.asUintN(64, m$2 * factor_hi);
  const sum = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, bits0) >> BigInt(32 & 63)) + bits1);
  return Number(BigInt.asUintN(32, BigInt.asUintN(64, BigInt.asUintN(64, sum) >> BigInt(shift - 32 & 63)))) | 0;
}
function _M0FPC15float30f2s__mul__pow5__inv__div__pow2(m, q, j) {
  return _M0FPC15float19f2s__mul__shift__32(m, BigInt.asUintN(64, (q >>> 0 < _M0FPC15float25f2s__pow5__inv__split__hi.length ? _M0FPC15float25f2s__pow5__inv__split__hi[q] : $oob()) + 1n), j);
}
function _M0FPC15float25f2s__mul__pow5__div__pow2(m, i, j) {
  return _M0FPC15float19f2s__mul__shift__32(m, i >>> 0 < _M0FPC15float20f2s__pow5__split__hi.length ? _M0FPC15float20f2s__pow5__split__hi[i] : $oob(), j);
}
function _M0FPC15float3f2d(ieee_mantissa, ieee_exponent) {
  const e2 = ieee_exponent === 0 ? -151 : ((ieee_exponent - 127 | 0) - 23 | 0) - 2 | 0;
  const m2 = ieee_exponent === 0 ? ieee_mantissa : 8388608 | ieee_mantissa;
  const even = (m2 & 1) === 0;
  const mv = Math.imul(4, m2) | 0;
  const mp = ((Math.imul(4, m2) | 0) >>> 0) + (2 >>> 0) | 0;
  const mm_shift = ieee_mantissa !== 0 || ieee_exponent >>> 0 <= 1 >>> 0 ? 1 : 0;
  const mm = ((((Math.imul(4, m2) | 0) >>> 0) - (1 >>> 0) | 0) >>> 0) - (mm_shift >>> 0) | 0;
  let vr = 0;
  let vp = 0;
  let vm = 0;
  let e10 = 0;
  let vm_is_trailing_zeros = false;
  let vr_is_trailing_zeros = false;
  let last_removed_digit = 0;
  if (e2 >= 0) {
    const q = Math.imul(e2, 78913) >> 18;
    e10 = q;
    const k = (61 + ((Math.imul(q, 1217359) >> 19) + 1 | 0) | 0) - 1 | 0;
    const i = ((-e2 | 0) + q | 0) + k | 0;
    vr = _M0FPC15float30f2s__mul__pow5__inv__div__pow2(mv, q, i);
    vp = _M0FPC15float30f2s__mul__pow5__inv__div__pow2(mp, q, i);
    vm = _M0FPC15float30f2s__mul__pow5__inv__div__pow2(mm, q, i);
    if (q !== 0 && ((((vp >>> 0) - (1 >>> 0) | 0) >>> 0) / (10 >>> 0) | 0) >>> 0 <= ((vm >>> 0) / (10 >>> 0) | 0) >>> 0) {
      const _p = q - 1 | 0;
      const l = (61 + ((Math.imul(_p, 1217359) >> 19) + 1 | 0) | 0) - 1 | 0;
      last_removed_digit = (_M0FPC15float30f2s__mul__pow5__inv__div__pow2(mv, q - 1 | 0, (((-e2 | 0) + q | 0) - 1 | 0) + l | 0) >>> 0) % (10 >>> 0) | 0;
    }
    if (q <= 9) {
      if (((mv >>> 0) % (5 >>> 0) | 0) === 0) {
        vr_is_trailing_zeros = _M0FPC15float35f2s__multiple__of__power__of__5__32(mv, q);
      } else {
        if (even) {
          vm_is_trailing_zeros = _M0FPC15float35f2s__multiple__of__power__of__5__32(mm, q);
        } else {
          if (_M0FPC15float35f2s__multiple__of__power__of__5__32(mp, q)) {
            vp = (vp >>> 0) - (1 >>> 0) | 0;
          }
        }
      }
    }
  } else {
    const _p = -e2 | 0;
    const q = Math.imul(_p, 732923) >> 20;
    e10 = q + e2 | 0;
    const i = (-e2 | 0) - q | 0;
    const k = ((Math.imul(i, 1217359) >> 19) + 1 | 0) - 61 | 0;
    let j = q - k | 0;
    vr = _M0FPC15float25f2s__mul__pow5__div__pow2(mv, i, j);
    vp = _M0FPC15float25f2s__mul__pow5__div__pow2(mp, i, j);
    vm = _M0FPC15float25f2s__mul__pow5__div__pow2(mm, i, j);
    if (q !== 0 && ((((vp >>> 0) - (1 >>> 0) | 0) >>> 0) / (10 >>> 0) | 0) >>> 0 <= ((vm >>> 0) / (10 >>> 0) | 0) >>> 0) {
      const _tmp = q - 1 | 0;
      const _p$2 = i + 1 | 0;
      j = _tmp - (((Math.imul(_p$2, 1217359) >> 19) + 1 | 0) - 61 | 0) | 0;
      last_removed_digit = (_M0FPC15float25f2s__mul__pow5__div__pow2(mv, i + 1 | 0, j) >>> 0) % (10 >>> 0) | 0;
    }
    if (q <= 1) {
      vr_is_trailing_zeros = true;
      if (even) {
        vm_is_trailing_zeros = mm_shift === 1;
      } else {
        vp = (vp >>> 0) - (1 >>> 0) | 0;
      }
    } else {
      if (q < 31) {
        const _p$2 = q - 1 | 0;
        vr_is_trailing_zeros = (mv & ((1 << _p$2 >>> 0) - (1 >>> 0) | 0)) === 0;
      }
    }
  }
  let removed = 0;
  let output;
  if (vm_is_trailing_zeros || vr_is_trailing_zeros) {
    while (true) {
      if (((vp >>> 0) / (10 >>> 0) | 0) >>> 0 > ((vm >>> 0) / (10 >>> 0) | 0) >>> 0) {
        vm_is_trailing_zeros = vm_is_trailing_zeros && ((vm >>> 0) - ((Math.imul((vm >>> 0) / (10 >>> 0) | 0, 10) | 0) >>> 0) | 0) === 0;
        vr_is_trailing_zeros = vr_is_trailing_zeros && last_removed_digit === 0;
        last_removed_digit = (vr >>> 0) % (10 >>> 0) | 0;
        vr = (vr >>> 0) / (10 >>> 0) | 0;
        vp = (vp >>> 0) / (10 >>> 0) | 0;
        vm = (vm >>> 0) / (10 >>> 0) | 0;
        removed = removed + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    if (vm_is_trailing_zeros) {
      while (true) {
        if (((vm >>> 0) % (10 >>> 0) | 0) === 0) {
          vr_is_trailing_zeros = vr_is_trailing_zeros && last_removed_digit === 0;
          last_removed_digit = (vr >>> 0) % (10 >>> 0) | 0;
          vr = (vr >>> 0) / (10 >>> 0) | 0;
          vm = (vm >>> 0) / (10 >>> 0) | 0;
          removed = removed + 1 | 0;
          continue;
        } else {
          break;
        }
      }
    }
    if (vr_is_trailing_zeros && (last_removed_digit === 5 && ((vr >>> 0) % (2 >>> 0) | 0) === 0)) {
      last_removed_digit = 4;
    }
    output = vr === vm && (!even || !vm_is_trailing_zeros) || last_removed_digit >>> 0 >= 5 >>> 0 ? (vr >>> 0) + (1 >>> 0) | 0 : vr;
  } else {
    while (true) {
      if (((vp >>> 0) / (10 >>> 0) | 0) >>> 0 > ((vm >>> 0) / (10 >>> 0) | 0) >>> 0) {
        last_removed_digit = (vr >>> 0) % (10 >>> 0) | 0;
        vr = (vr >>> 0) / (10 >>> 0) | 0;
        vp = (vp >>> 0) / (10 >>> 0) | 0;
        vm = (vm >>> 0) / (10 >>> 0) | 0;
        removed = removed + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    output = vr === vm || last_removed_digit >>> 0 >= 5 >>> 0 ? (vr >>> 0) + (1 >>> 0) | 0 : vr;
  }
  return new _M0TPC15float17FloatingDecimal32(output, e10 + removed | 0);
}
function _M0IPC15float5FloatPB4Show10to__string(self) {
  const bits = $i32_reinterpret_f32(self);
  const ieee_mantissa = bits & 8388607;
  const ieee_exponent = bits >>> 23 & 255;
  if (ieee_exponent === 255 || ieee_exponent === 0 && ieee_mantissa === 0) {
    return String(self);
  }
  const decimal = _M0FPC15float3f2d(ieee_mantissa, ieee_exponent);
  let mantissa = decimal.mantissa;
  let exponent = decimal.exponent;
  while (true) {
    if (((mantissa >>> 0) % (10 >>> 0) | 0) === 0) {
      mantissa = (mantissa >>> 0) / (10 >>> 0) | 0;
      exponent = exponent + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const digits = _M0MPC14uint4UInt18to__string_2einner(mantissa, 10);
  const length = digits.length;
  const exp = (exponent + length | 0) - 1 | 0;
  const builder = _M0MPB13StringBuilder21StringBuilder_2einner(16);
  if ((bits >>> 31 | 0) !== 0) {
    _M0IPB13StringBuilderPB6Logger11write__char(builder, 45);
  }
  if (!(exp >= -6 && exp < 21)) {
    _M0IPB13StringBuilderPB6Logger11write__view(builder, _M0MPC16string6String21clamped__view_2einner(digits, 0, _M0IPC15float5FloatPB4Show10to__stringN6constrS1625));
    if (length > 1) {
      _M0IPB13StringBuilderPB6Logger11write__char(builder, 46);
      _M0IPB13StringBuilderPB6Logger11write__view(builder, _M0MPC16string6String21clamped__view_2einner(digits, 1, undefined));
    }
    _M0IPB13StringBuilderPB6Logger11write__char(builder, 101);
    _M0IPB13StringBuilderPB6Logger11write__char(builder, exp < 0 ? 45 : 43);
    _M0IPB13StringBuilderPB6Logger13write__string(builder, _M0MPC13int3Int18to__string_2einner(exp < 0 ? -exp | 0 : exp, 10));
  } else {
    if (exp < 0) {
      _M0IPB13StringBuilderPB6Logger13write__string(builder, "0.");
      const _bind = (-exp | 0) - 1 | 0;
      let _tmp = 0;
      while (true) {
        const _ = _tmp;
        if (_ < _bind) {
          _M0IPB13StringBuilderPB6Logger11write__char(builder, 48);
          _tmp = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _M0IPB13StringBuilderPB6Logger13write__string(builder, digits);
    } else {
      if ((exp + 1 | 0) >= length) {
        _M0IPB13StringBuilderPB6Logger13write__string(builder, digits);
        const _bind = (exp + 1 | 0) - length | 0;
        let _tmp = 0;
        while (true) {
          const _ = _tmp;
          if (_ < _bind) {
            _M0IPB13StringBuilderPB6Logger11write__char(builder, 48);
            _tmp = _ + 1 | 0;
            continue;
          } else {
            break;
          }
        }
      } else {
        _M0IPB13StringBuilderPB6Logger11write__view(builder, _M0MPC16string6String21clamped__view_2einner(digits, 0, exp + 1 | 0));
        _M0IPB13StringBuilderPB6Logger11write__char(builder, 46);
        _M0IPB13StringBuilderPB6Logger11write__view(builder, _M0MPC16string6String21clamped__view_2einner(digits, exp + 1 | 0, undefined));
      }
    }
  }
  return builder.val;
}
function _M0MPC15debug4Repr8children(self) {
  let value;
  _L: {
    _L$2: {
      switch (self.$tag) {
        case 0: {
          break _L$2;
        }
        case 1: {
          break _L$2;
        }
        case 2: {
          break _L$2;
        }
        case 3: {
          break _L$2;
        }
        case 4: {
          break _L$2;
        }
        case 5: {
          break _L$2;
        }
        case 6: {
          break _L$2;
        }
        case 15: {
          break _L$2;
        }
        case 17: {
          break _L$2;
        }
        case 7: {
          const _Tuple = self;
          const _xs = _Tuple._0;
          return _xs;
        }
        case 8: {
          const _Array = self;
          const _xs$2 = _Array._0;
          return _xs$2;
        }
        case 9: {
          const _Record = self;
          const _xs$3 = _Record._0;
          return _xs$3;
        }
        case 10: {
          const _Enum = self;
          const _xs$4 = _Enum._1;
          return _xs$4;
        }
        case 11: {
          const _Map = self;
          const _xs$5 = _Map._0;
          return _xs$5;
        }
        case 14: {
          const _Opaque = self;
          const _value = _Opaque._1;
          value = _value;
          break _L;
        }
        case 12: {
          const _RecordField = self;
          const _value$2 = _RecordField._1;
          value = _value$2;
          break _L;
        }
        case 13: {
          const _EnumLabeledArg = self;
          const _value$3 = _EnumLabeledArg._1;
          value = _value$3;
          break _L;
        }
        default: {
          const _MapEntry = self;
          const _key = _MapEntry._0;
          const _value$4 = _MapEntry._1;
          return [_key, _value$4];
        }
      }
    }
    return [];
  }
  return [value];
}
function _M0MPC15debug4Repr14with__children(self, children) {
  _L: {
    switch (self.$tag) {
      case 0: {
        break _L;
      }
      case 1: {
        break _L;
      }
      case 2: {
        break _L;
      }
      case 3: {
        break _L;
      }
      case 4: {
        break _L;
      }
      case 5: {
        break _L;
      }
      case 6: {
        break _L;
      }
      case 15: {
        break _L;
      }
      case 17: {
        break _L;
      }
      case 7: {
        return new _M0DTPC15debug4Repr5Tuple(children);
      }
      case 8: {
        return new _M0DTPC15debug4Repr5Array(children);
      }
      case 9: {
        return new _M0DTPC15debug4Repr6Record(children);
      }
      case 10: {
        const _Enum = self;
        const _name = _Enum._0;
        return new _M0DTPC15debug4Repr4Enum(_name, children);
      }
      case 11: {
        return new _M0DTPC15debug4Repr3Map(children);
      }
      case 12: {
        const _RecordField = self;
        const _name$2 = _RecordField._0;
        if (children.length === 1) {
          const _value = children[0];
          return new _M0DTPC15debug4Repr11RecordField(_name$2, _value);
        } else {
          return new _M0DTPC15debug4Repr11RecordField(_name$2, _M0DTPC15debug4Repr7Omitted__);
        }
      }
      case 13: {
        const _EnumLabeledArg = self;
        const _label = _EnumLabeledArg._0;
        if (children.length === 1) {
          const _value = children[0];
          return new _M0DTPC15debug4Repr14EnumLabeledArg(_label, _value);
        } else {
          return new _M0DTPC15debug4Repr14EnumLabeledArg(_label, _M0DTPC15debug4Repr7Omitted__);
        }
      }
      case 16: {
        if (children.length === 2) {
          const _key = children[0];
          const _value = children[1];
          return new _M0DTPC15debug4Repr8MapEntry(_key, _value);
        } else {
          return new _M0DTPC15debug4Repr8MapEntry(_M0DTPC15debug4Repr7Omitted__, _M0DTPC15debug4Repr7Omitted__);
        }
      }
      default: {
        const _Opaque = self;
        const _name$3 = _Opaque._0;
        if (children.length === 1) {
          const _value = children[0];
          return new _M0DTPC15debug4Repr6Opaque(_name$3, _value);
        } else {
          return new _M0DTPC15debug4Repr6Opaque(_name$3, _M0DTPC15debug4Repr7Omitted__);
        }
      }
    }
  }
  return self;
}
function _M0MPC15debug4Repr4ctor(name, args) {
  const _p = new Array(args.length);
  const _p$2 = args.length;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _p$4 = args[_p$3];
      const _p$5 = _p$4._0;
      const _p$6 = _p$4._1;
      let _tmp$2;
      if (_p$5 === undefined) {
        _tmp$2 = _p$6;
      } else {
        const _p$7 = _p$5;
        const _p$8 = _p$7;
        _tmp$2 = new _M0DTPC15debug4Repr14EnumLabeledArg(_p$8, _p$6);
      }
      _p[_p$3] = _tmp$2;
      _tmp = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC15debug4Repr4Enum(name, _p);
}
function _M0MPC15debug4Repr7shallow(self) {
  return _M0MPC15debug4Repr14with__children(self, []);
}
function _M0IPC15debug13ContentParensPB3Add3add(self, other) {
  return new _M0TPC15debug13ContentParens(self.size + other.size | 0, _M0IPC15array5ArrayPB3Add3addGsE(self.lines, other.lines));
}
function _M0FPC15debug14empty__content() {
  return new _M0TPC15debug7Content(0, [], false);
}
function _M0FPC15debug8verbatim(x) {
  return new _M0TPC15debug13ContentParens(1, [x]);
}
function _M0FPC15debug15content__parens(size, lines) {
  return new _M0TPC15debug13ContentParens(size, lines);
}
function _M0FPC15debug12leaf_2einner(x, needs_parens) {
  return new _M0TPC15debug7Content(1, [x], needs_parens);
}
function _M0FPC15debug11with__lines(r, f) {
  return new _M0TPC15debug13ContentParens(r.size, f(r.lines));
}
function _M0MPC15debug7Content20with__lines__content(r, f) {
  return new _M0TPC15debug7Content(r.size, f(r.lines), r.needs_parens);
}
function _M0FPC15debug15surround__lines(start, finish, lines) {
  if (lines.length === 0) {
    return [`${start}${finish}`];
  } else {
    if (lines.length === 1) {
      const _item = lines[0];
      return [`${start}${_item}${finish}`];
    } else {
      const _first = lines[0];
      const _last = lines[lines.length - 1 | 0];
      const _x = new _M0TPB9ArrayViewGsE(lines, 1, lines.length - 1 | 0);
      const _self = [];
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_self, `${start}${_first}`);
      _M0MPC15array5Array10push__iterGsE(_self, _M0MPC15array9ArrayView4iterGUssEE(_x));
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_self, `${_last}${finish}`);
      return _self;
    }
  }
}
function _M0FPC15debug8surround(start, finish, r) {
  return _M0FPC15debug11with__lines(r, (lines) => _M0FPC15debug15surround__lines(start, finish, lines));
}
function _M0MPC15debug7Content8no__wrap(c) {
  return new _M0TPC15debug13ContentParens(c.size, c.lines);
}
function _M0FPC15debug6parens(r) {
  return new _M0TPC15debug7Content(r.size, r.lines, true);
}
function _M0FPC15debug10no__parens(r) {
  return new _M0TPC15debug7Content(r.size, r.lines, false);
}
function _M0FPC15debug15compact__middle(middle) {
  const parts = [];
  const _bind = middle.end - middle.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const m = middle.buf[middle.start + _ | 0];
      const t = _M0MPC16string6String4trim(m, undefined);
      if (_M0IP016_24default__implPB2Eq10not__equalGRPC16string10StringViewE(t, _M0FPC15debug15compact__middleN6recordS1722)) {
        _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(parts, t);
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const joined0 = _M0MPC15array5Array4joinGRPC16string10StringViewE(parts, _M0FPC15debug15compact__middleN6recordS1723);
  return _M0MPC16option6Option10unwrap__orGsE(_M0MPC16string6String13strip__suffix(joined0, _M0FPC15debug15compact__middleN6recordS1724), new _M0TPC16string10StringView(joined0, 0, joined0.length));
}
function _M0FPC15debug14compact__lines(lines) {
  if (lines.length === 0) {
    return [];
  } else {
    if (lines.length === 1) {
      const _x = lines[0];
      return [_x];
    } else {
      const _first = lines[0];
      const _last = lines[lines.length - 1 | 0];
      const _bind = lines.length - 1 | 0;
      const _x = new _M0TPB9ArrayViewGsE(lines, 1, _bind);
      if (_first === "[" && _last === "]" || _first === "{" && _last === "}") {
        const joined = _M0FPC15debug15compact__middle(_x);
        if (_first === "{") {
          const s1 = _M0MPC16option6Option10unwrap__orGsE(_M0MPC16string10StringView13strip__prefix(joined, _M0FPC15debug14compact__linesN6recordS1733), joined);
          const inner = _M0MPC16option6Option10unwrap__orGsE(_M0MPC16string10StringView13strip__suffix(s1, _M0FPC15debug14compact__linesN6recordS1734), s1);
          if (_M0IPC16string10StringViewPB2Eq5equal(inner, _M0FPC15debug14compact__linesN6recordS1735)) {
            return ["{}"];
          } else {
            const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(4);
            _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "{ ");
            _M0MPB13StringBuilder13write__objectGRPC16string10StringViewE(_string_builder, inner);
            _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, " }");
            return [_string_builder.val];
          }
        } else {
          const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(2);
          _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "[");
          _M0MPB13StringBuilder13write__objectGRPC16string10StringViewE(_string_builder, joined);
          _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "]");
          return [_string_builder.val];
        }
      } else {
        if (_M0MPC16string6String11has__suffix(_first, _M0FPC15debug14compact__linesN6recordS1736) && _last === ")") {
          const joined = _M0FPC15debug15compact__middle(_x);
          const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(0);
          _M0MPB13StringBuilder13write__objectGsE(_string_builder, _first);
          _M0MPB13StringBuilder13write__objectGRPC16string10StringViewE(_string_builder, joined);
          _M0MPB13StringBuilder13write__objectGsE(_string_builder, _last);
          return [_string_builder.val];
        } else {
          const parts = [new _M0TPC16string10StringView(_first, 0, _first.length)];
          const _bind$2 = _bind - 1 | 0;
          let _tmp = 0;
          while (true) {
            const _ = _tmp;
            if (_ < _bind$2) {
              const m = lines[1 + _ | 0];
              _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(parts, _M0MPC16string6String4trim(m, undefined));
              _tmp = _ + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(parts, _M0MPC16string6String4trim(_last, undefined));
          return [_M0MPC15array5Array4joinGRPC16string10StringViewE(parts, _M0FPC15debug14compact__linesN6recordS1737)];
        }
      }
    }
  }
}
function _M0MPC15debug7Content7compact(r) {
  return _M0MPC15debug7Content20with__lines__content(r, _M0FPC15debug14compact__lines);
}
function _M0FPC15debug6indent(prefix, r) {
  return _M0FPC15debug11with__lines(r, (lines) => {
    const _p = new Array(lines.length);
    const _p$2 = lines.length;
    let _tmp = 0;
    while (true) {
      const _p$3 = _tmp;
      if (_p$3 < _p$2) {
        const _p$4 = lines[_p$3];
        _p[_p$3] = `${prefix}${_p$4}`;
        _tmp = _p$3 + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return _p;
  });
}
function _M0FPC15debug14indent__spaces(n, r) {
  return _M0FPC15debug6indent(_M0MPC16string6String6repeat(" ", n), r);
}
function _M0FPC15debug21push__indented__items(out, indent_by, contents) {
  const _bind = contents.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const item = contents[_];
      const item_lines = _M0MPC15array5Array6filterGsE(item, (line) => {
        const _p = "";
        return !(line === _p);
      });
      if (item_lines.length === 0) {
      } else {
        if (item_lines.length === 1) {
          const _x = item_lines[0];
          _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, `${_M0MPC16string6String6repeat(" ", indent_by)}${_x},`);
        } else {
          const _first = item_lines[0];
          const _last = item_lines[item_lines.length - 1 | 0];
          const _x_end = item_lines.length - 1 | 0;
          _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, `${_M0MPC16string6String6repeat(" ", indent_by)}${_first}`);
          const _bind$2 = _x_end - 1 | 0;
          let _tmp$2 = 0;
          while (true) {
            const _$2 = _tmp$2;
            if (_$2 < _bind$2) {
              const mid = item_lines[1 + _$2 | 0];
              _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, `${_M0MPC16string6String6repeat(" ", indent_by)}${mid}`);
              _tmp$2 = _$2 + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, `${_M0MPC16string6String6repeat(" ", indent_by)}${_last},`);
        }
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPC15debug19bracket__seq__lines(open, close, indent_by, contents) {
  if (contents.length === 0) {
    return [`${open}${close}`];
  } else {
    if (contents.length === 1) {
      const _item = contents[0];
      if (_item.length > 1) {
        const lines = _M0FPC15debug14indent__spaces(indent_by, new _M0TPC15debug13ContentParens(0, _item)).lines;
        if (!(lines.length === 0)) {
          const last_i = lines.length - 1 | 0;
          _M0MPC15array5Array3setGUssEE(lines, last_i, `${_M0MPC15array5Array2atGUssEE(lines, last_i)},`);
        }
        const _self = [];
        _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_self, open);
        _M0MPC15array5Array10push__iterGsE(_self, _M0MPC15array5Array4iterGUssEE(lines));
        _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_self, close);
        return _self;
      } else {
        const inner = _M0FPC15debug14compact__lines(_item);
        if (inner.length === 0) {
          return [`${open}${close}`];
        } else {
          if (inner.length === 1) {
            const _x = inner[0];
            if (open === "{" && close === "}") {
              const inner$2 = _M0MPC16string6String4trim(_x, undefined);
              if (_M0IPC16string10StringViewPB2Eq5equal(inner$2, _M0FPC15debug19bracket__seq__linesN6recordS1780)) {
                return ["{}"];
              } else {
                const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(4);
                _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "{ ");
                _M0MPB13StringBuilder13write__objectGRPC16string10StringViewE(_string_builder, inner$2);
                _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, " }");
                return [_string_builder.val];
              }
            } else {
              return [`${open}${_x}${close}`];
            }
          } else {
            const _self = [];
            _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_self, open);
            _M0MPC15array5Array10push__iterGsE(_self, _M0MPC15array5Array4iterGUssEE(_M0FPC15debug14indent__spaces(indent_by, new _M0TPC15debug13ContentParens(0, _item)).lines));
            _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_self, close);
            return _self;
          }
        }
      }
    } else {
      const out = [open];
      _M0FPC15debug21push__indented__items(out, indent_by, contents);
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, close);
      return out;
    }
  }
}
function _M0FPC15debug17comma__seq__lines(begin, end, contents) {
  if (begin === "[" && end === "]") {
    return _M0FPC15debug19bracket__seq__lines("[", "]", 2, contents);
  } else {
    if (begin === "{" && end === "}") {
      return _M0FPC15debug19bracket__seq__lines("{", "}", 2, contents);
    } else {
      if (begin === "" && end === "") {
        let lines;
        if (contents.length === 0) {
          lines = [`${begin}${end}`];
        } else {
          if (contents.length === 1) {
            const _item = contents[0];
            lines = _M0FPC15debug15surround__lines(begin, end, _item);
          } else {
            const _first = contents[0];
            const _last = contents[contents.length - 1 | 0];
            const _x_end = contents.length - 1 | 0;
            const space = _M0MPC16string6String6repeat(" ", begin.length);
            const middle_lines = [];
            const _bind = _x_end - 1 | 0;
            let _tmp = 0;
            while (true) {
              const _ = _tmp;
              if (_ < _bind) {
                const item = contents[1 + _ | 0];
                const _bind$2 = _M0FPC15debug15surround__lines(space, ",", item);
                _M0MPC15array5Array6appendGsE(middle_lines, new _M0TPB9ArrayViewGsE(_bind$2, 0, _bind$2.length));
                _tmp = _ + 1 | 0;
                continue;
              } else {
                break;
              }
            }
            const _self = [];
            _M0MPC15array5Array10push__iterGsE(_self, _M0MPC15array5Array4iterGUssEE(_M0FPC15debug15surround__lines(begin, ",", _first)));
            _M0MPC15array5Array10push__iterGsE(_self, _M0MPC15array5Array4iterGUssEE(middle_lines));
            _M0MPC15array5Array10push__iterGsE(_self, _M0MPC15array5Array4iterGUssEE(_M0FPC15debug15surround__lines(space, end, _last)));
            lines = _self;
          }
        }
        return _M0MPC15array5Array6filterGsE(lines, (line) => {
          const _p = "";
          return !(line === _p);
        });
      } else {
        if (contents.length === 0) {
          return [`${begin}${end}`];
        } else {
          if (contents.length === 1) {
            const _item = contents[0];
            const item_lines = _M0MPC15array5Array6filterGsE(_item, (line) => {
              const _p = "";
              return !(line === _p);
            });
            if (item_lines.length === 0) {
              return [`${begin}${end}`];
            } else {
              if (item_lines.length === 1) {
                const _x = item_lines[0];
                return [`${begin}${_x}${end}`];
              } else {
                const _last_line = item_lines[item_lines.length - 1 | 0];
                const _x = new _M0TPB9ArrayViewGsE(item_lines, 0, item_lines.length - 1 | 0);
                const _self = [];
                _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_self, begin);
                const _p = new Array(_x.end - _x.start | 0);
                const _p$2 = _x.end - _x.start | 0;
                let _tmp = 0;
                while (true) {
                  const _p$3 = _tmp;
                  if (_p$3 < _p$2) {
                    const _p$4 = _x.buf[_x.start + _p$3 | 0];
                    _p[_p$3] = `${_M0MPC16string6String6repeat(" ", 2)}${_p$4}`;
                    _tmp = _p$3 + 1 | 0;
                    continue;
                  } else {
                    break;
                  }
                }
                _M0MPC15array5Array10push__iterGsE(_self, _M0MPC15array5Array4iterGUssEE(_p));
                _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_self, `${_M0MPC16string6String6repeat(" ", 2)}${_last_line},`);
                _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_self, end);
                return _self;
              }
            }
          } else {
            const out = [begin];
            _M0FPC15debug21push__indented__items(out, 2, contents);
            _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, end);
            return out;
          }
        }
      }
    }
  }
}
function _M0FPC15debug10comma__seq(begin, end, contents) {
  const _bind = contents.length;
  let _tmp = 0;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp;
    const size = _tmp$2;
    if (_ < _bind) {
      const c = contents[_];
      _tmp = _ + 1 | 0;
      _tmp$2 = size + c.size | 0;
      continue;
    } else {
      const _p = new Array(contents.length);
      const _p$2 = contents.length;
      let _tmp$3 = 0;
      while (true) {
        const _p$3 = _tmp$3;
        if (_p$3 < _p$2) {
          const _p$4 = contents[_p$3];
          _p[_p$3] = _p$4.lines;
          _tmp$3 = _p$3 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      return new _M0TPC15debug7Content(size, _M0FPC15debug17comma__seq__lines(begin, end, _p), false);
    }
  }
}
function _M0FPC15debug14print__content(r) {
  return _M0MPC15array5Array4joinGsE(r.lines, _M0FPC15debug14print__contentN6recordS1830);
}
function _M0FPC15debug14with__resizing(threshold, rendered_children) {
  if (threshold <= 0) {
    return rendered_children;
  } else {
    const compacted = _M0MPC15debug7Content7compact(rendered_children);
    const _p = compacted.lines;
    let _tmp;
    let _p$2;
    _L: {
      _L$2: {
        const _p$3 = _p.length;
        let _tmp$2 = 0;
        while (true) {
          const _p$4 = _tmp$2;
          if (_p$4 < _p$3) {
            const _p$5 = _p[_p$4];
            if (!(_p$5.length <= threshold)) {
              _p$2 = false;
              break _L$2;
            }
            _tmp$2 = _p$4 + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        _tmp = true;
        break _L;
      }
      _tmp = _p$2;
    }
    if (_tmp) {
      return compacted;
    } else {
      return rendered_children;
    }
  }
}
function _M0MPC15debug4Repr17info__adds__depth(info) {
  let _tmp;
  switch (info.$tag) {
    case 12: {
      _tmp = true;
      break;
    }
    case 13: {
      _tmp = true;
      break;
    }
    case 16: {
      _tmp = true;
      break;
    }
    default: {
      _tmp = false;
    }
  }
  return !_tmp;
}
function _M0MPC15debug4Repr19prune__info_2einnerN2goS1837(replacement, d, node) {
  const children = _M0MPC15debug4Repr8children(node);
  if (d <= 0) {
    if (children.length === 0) {
      return node;
    } else {
      if (!_M0MPC15debug4Repr17info__adds__depth(node)) {
        const _p = new Array(children.length);
        const _p$2 = children.length;
        let _tmp = 0;
        while (true) {
          const _p$3 = _tmp;
          if (_p$3 < _p$2) {
            const _p$4 = children[_p$3];
            _p[_p$3] = _M0MPC15debug4Repr19prune__info_2einnerN2goS1837(replacement, d, _p$4);
            _tmp = _p$3 + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        return _M0MPC15debug4Repr14with__children(node, _p);
      } else {
        return replacement;
      }
    }
  } else {
    if (children.length === 0) {
      return node;
    } else {
      const next_depth = _M0MPC15debug4Repr17info__adds__depth(node) ? d - 1 | 0 : d;
      const _p = new Array(children.length);
      const _p$2 = children.length;
      let _tmp = 0;
      while (true) {
        const _p$3 = _tmp;
        if (_p$3 < _p$2) {
          const _p$4 = children[_p$3];
          _p[_p$3] = _M0MPC15debug4Repr19prune__info_2einnerN2goS1837(replacement, next_depth, _p$4);
          _tmp = _p$3 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      return _M0MPC15debug4Repr14with__children(node, _p);
    }
  }
}
function _M0MPC15debug4Repr19prune__info_2einner(self, replacement, max_depth) {
  if (max_depth === undefined) {
    return self;
  } else {
    const _Some = max_depth;
    const _depth = _Some;
    const _p = 1;
    return _M0MPC15debug4Repr19prune__info_2einnerN2goS1837(replacement, _p > _depth ? _p : _depth, self);
  }
}
function _M0MPC15debug4Repr11prune__info(self, replacement$46$opt, max_depth) {
  let replacement;
  if (replacement$46$opt === undefined) {
    replacement = _M0DTPC15debug4Repr7Omitted__;
  } else {
    const _Some = replacement$46$opt;
    replacement = _Some;
  }
  return _M0MPC15debug4Repr19prune__info_2einner(self, replacement, max_depth);
}
function _M0FPC15debug17is__unquoted__key(key) {
  let rest;
  _L: {
    if (key.length >= 1) {
      const _x = key.charCodeAt(0);
      if (_x >= 97 && _x <= 122) {
        const _x$2 = new _M0TPC16string10StringView(key, 1, key.length);
        rest = _x$2;
        break _L;
      } else {
        if (_x === 95) {
          const _x$2 = new _M0TPC16string10StringView(key, 1, key.length);
          rest = _x$2;
          break _L;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }
  const _p = rest.str;
  const _p$2 = rest.start;
  const _p$3 = rest.end;
  let _tmp = _p$2;
  while (true) {
    const _p$4 = _tmp;
    if (_p$4 < _p$3) {
      let _p$5;
      let _p$6;
      _L$2: {
        const _p$7 = _p.charCodeAt(_p$4);
        if (_p$7 >= 55296 && _p$7 <= 56319 && (_p$4 + 1 | 0) < _p$3) {
          const _p$8 = _p.charCodeAt(_p$4 + 1 | 0);
          if (_p$8 >= 56320 && _p$8 <= 57343) {
            const _tmp$2 = _p$4 + 2 | 0;
            const _p$9 = (((Math.imul(_p$7 - 55296 | 0, 1024) | 0) + _p$8 | 0) - 56320 | 0) + 65536 | 0;
            _p$5 = _tmp$2;
            _p$6 = _p$9;
            break _L$2;
          } else {
            const _tmp$2 = _p$4 + 1 | 0;
            const _p$9 = _p$7;
            _p$5 = _tmp$2;
            _p$6 = _p$9;
            break _L$2;
          }
        } else {
          const _tmp$2 = _p$4 + 1 | 0;
          const _p$8 = _p$7;
          _p$5 = _tmp$2;
          _p$6 = _p$8;
          break _L$2;
        }
      }
      if (!(_p$6 >= 97 && _p$6 <= 122 ? true : _p$6 >= 65 && _p$6 <= 90 ? true : _p$6 >= 48 && _p$6 <= 57 ? true : _p$6 === 95)) {
        return false;
      }
      _tmp = _p$5;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0FPC15debug20pretty__print__label(name) {
  return _M0FPC15debug17is__unquoted__key(name) ? name : _M0MPC16string6String14escape_2einner(name, true);
}
function _M0MPC15debug4Repr13pretty__print(self, children) {
  switch (self.$tag) {
    case 0: {
      return _M0FPC15debug10comma__seq("(", ")", []);
    }
    case 1: {
      const _Integer = self;
      const _s = _Integer._0;
      let _tmp;
      if (_s.length >= 1) {
        const _x = _s.charCodeAt(0);
        if (_x === 45) {
          _tmp = 1;
        } else {
          _tmp = 0;
        }
      } else {
        _tmp = 0;
      }
      return _M0FPC15debug10no__parens(_M0FPC15debug15content__parens(_tmp, [_s]));
    }
    case 2: {
      const _DoubleLit = self;
      const _x = _DoubleLit._0;
      const needs_parens = 1 / _x < 0;
      return _M0FPC15debug12leaf_2einner(String(_x), needs_parens);
    }
    case 3: {
      const _FloatLit = self;
      const _x$2 = _FloatLit._0;
      const _p = Math.fround(1);
      const _tmp$2 = Math.fround(_p / _x$2);
      const _p$2 = Math.fround(0);
      const needs_parens$2 = _tmp$2 < _p$2;
      return _M0FPC15debug12leaf_2einner(_M0IPC15float5FloatPB4Show10to__string(_x$2), needs_parens$2);
    }
    case 4: {
      const _BoolLit = self;
      const _x$3 = _BoolLit._0;
      return _M0FPC15debug12leaf_2einner(_x$3 ? "true" : "false", false);
    }
    case 5: {
      const _CharLit = self;
      const _x$4 = _CharLit._0;
      return _M0FPC15debug12leaf_2einner(_M0MPC14char4Char14escape_2einner(_x$4, true), false);
    }
    case 6: {
      const _StringLit = self;
      const _x$5 = _StringLit._0;
      return _M0FPC15debug10no__parens(_M0FPC15debug8verbatim(_M0MPC16string6String14escape_2einner(_x$5, true)));
    }
    case 7: {
      const _p$3 = new Array(children.length);
      const _p$4 = children.length;
      let _tmp$3 = 0;
      while (true) {
        const _p$5 = _tmp$3;
        if (_p$5 < _p$4) {
          const _p$6 = children[_p$5];
          _p$3[_p$5] = _M0MPC15debug7Content8no__wrap(_p$6);
          _tmp$3 = _p$5 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      return _M0FPC15debug10comma__seq("(", ")", _p$3);
    }
    case 10: {
      const _Enum = self;
      const _name = _Enum._0;
      if (children.length === 0) {
        return _M0FPC15debug10no__parens(_M0FPC15debug8verbatim(_name));
      } else {
        if (_name === "Tuple") {
          const _p$5 = new Array(children.length);
          const _p$6 = children.length;
          let _tmp$4 = 0;
          while (true) {
            const _p$7 = _tmp$4;
            if (_p$7 < _p$6) {
              const _p$8 = children[_p$7];
              _p$5[_p$7] = _M0MPC15debug7Content8no__wrap(_p$8);
              _tmp$4 = _p$7 + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          return _M0FPC15debug10comma__seq("(", ")", _p$5);
        } else {
          const _tmp$4 = `${_name}(`;
          const _p$5 = new Array(children.length);
          const _p$6 = children.length;
          let _tmp$5 = 0;
          while (true) {
            const _p$7 = _tmp$5;
            if (_p$7 < _p$6) {
              const _p$8 = children[_p$7];
              _p$5[_p$7] = _M0MPC15debug7Content8no__wrap(_p$8);
              _tmp$5 = _p$7 + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          return _M0FPC15debug10comma__seq(_tmp$4, ")", _p$5);
        }
      }
    }
    case 8: {
      const _p$5 = new Array(children.length);
      const _p$6 = children.length;
      let _tmp$4 = 0;
      while (true) {
        const _p$7 = _tmp$4;
        if (_p$7 < _p$6) {
          const _p$8 = children[_p$7];
          _p$5[_p$7] = _M0MPC15debug7Content8no__wrap(_p$8);
          _tmp$4 = _p$7 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      return _M0FPC15debug10comma__seq("[", "]", _p$5);
    }
    case 9: {
      const _p$7 = new Array(children.length);
      const _p$8 = children.length;
      let _tmp$5 = 0;
      while (true) {
        const _p$9 = _tmp$5;
        if (_p$9 < _p$8) {
          const _p$10 = children[_p$9];
          _p$7[_p$9] = _M0MPC15debug7Content8no__wrap(_p$10);
          _tmp$5 = _p$9 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      return _M0FPC15debug10comma__seq("{", "}", _p$7);
    }
    case 14: {
      const _Opaque = self;
      const _name$2 = _Opaque._0;
      if (children.length === 0) {
        return _M0FPC15debug10no__parens(_M0FPC15debug8surround("<", ">", _M0FPC15debug8verbatim(_name$2)));
      } else {
        const _tmp$6 = _M0FPC15debug8verbatim(`${_name$2}:`);
        const _p$9 = new Array(children.length);
        const _p$10 = children.length;
        let _tmp$7 = 0;
        while (true) {
          const _p$11 = _tmp$7;
          if (_p$11 < _p$10) {
            const _p$12 = children[_p$11];
            _p$9[_p$11] = _M0MPC15debug7Content8no__wrap(_p$12);
            _tmp$7 = _p$11 + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        const body = _M0IPC15debug13ContentParensPB3Add3add(_tmp$6, _M0FPC15debug6indent("  ", _M0MPC15debug7Content8no__wrap(_M0FPC15debug10comma__seq("", "", _p$9))));
        return _M0FPC15debug10no__parens(_M0FPC15debug8surround("<", ">", body));
      }
    }
    case 15: {
      const _Literal = self;
      const _str = _Literal._0;
      return _M0FPC15debug10no__parens(_M0FPC15debug8verbatim(_str));
    }
    case 11: {
      const _p$9 = new Array(children.length);
      const _p$10 = children.length;
      let _tmp$6 = 0;
      while (true) {
        const _p$11 = _tmp$6;
        if (_p$11 < _p$10) {
          const _p$12 = children[_p$11];
          _p$9[_p$11] = _M0MPC15debug7Content8no__wrap(_p$12);
          _tmp$6 = _p$11 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      return _M0FPC15debug10comma__seq("{", "}", _p$9);
    }
    case 16: {
      if (children.length === 2) {
        const _key = children[0];
        const _val = children[1];
        const k = _M0MPC15debug7Content8no__wrap(_key);
        const v = _M0MPC15debug7Content8no__wrap(_val);
        const _bind = v.lines;
        if (_bind.length === 0) {
          return _M0FPC15debug14empty__content();
        } else {
          const _first = _bind[0];
          const _x$6 = new _M0TPB9ArrayViewGsE(_bind, 1, _bind.length);
          const head = `${_M0FPC15debug14print__content(_M0FPC15debug8surround("", ": ", k))}${_first}`;
          const _tmp$7 = (1 + k.size | 0) + v.size | 0;
          const _self = [];
          _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_self, head);
          _M0MPC15array5Array10push__iterGsE(_self, _M0MPC15array9ArrayView4iterGUssEE(_x$6));
          return _M0FPC15debug10no__parens(_M0FPC15debug15content__parens(_tmp$7, _self));
        }
      } else {
        return _M0FPC15debug14empty__content();
      }
    }
    case 13: {
      const _EnumLabeledArg = self;
      const _name$3 = _EnumLabeledArg._0;
      if (children.length === 1) {
        const _val = children[0];
        const _bind = _val.lines;
        if (_bind.length === 0) {
          return _M0FPC15debug14empty__content();
        } else {
          const _first = _bind[0];
          const _x$6 = new _M0TPB9ArrayViewGsE(_bind, 1, _bind.length);
          const _tmp$7 = 1 + _val.size | 0;
          const _self = [];
          _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_self, `${_name$3}=${_first}`);
          _M0MPC15array5Array10push__iterGsE(_self, _M0MPC15array9ArrayView4iterGUssEE(_x$6));
          return _M0FPC15debug10no__parens(_M0FPC15debug15content__parens(_tmp$7, _self));
        }
      } else {
        return _M0FPC15debug14empty__content();
      }
    }
    case 12: {
      const _RecordField = self;
      const _name$4 = _RecordField._0;
      if (children.length === 1) {
        const _val = children[0];
        const label = _M0FPC15debug20pretty__print__label(_name$4);
        const v = _M0MPC15debug7Content8no__wrap(_val);
        const _bind = v.lines;
        if (_bind.length === 0) {
          return _M0FPC15debug14empty__content();
        } else {
          const _first = _bind[0];
          const _x$6 = new _M0TPB9ArrayViewGsE(_bind, 1, _bind.length);
          const _tmp$7 = 1 + v.size | 0;
          const _self = [];
          _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(_self, `${label}: ${_first}`);
          _M0MPC15array5Array10push__iterGsE(_self, _M0MPC15array9ArrayView4iterGUssEE(_x$6));
          return _M0FPC15debug10no__parens(_M0FPC15debug15content__parens(_tmp$7, _self));
        }
      } else {
        return _M0FPC15debug14empty__content();
      }
    }
    default: {
      return _M0FPC15debug6parens(_M0FPC15debug8verbatim("..."));
    }
  }
}
function _M0MPC15debug4Repr12render__repr(self, threshold) {
  const label = _M0MPC15debug4Repr7shallow(self);
  const _p = _M0MPC15debug4Repr8children(self);
  const _p$2 = new Array(_p.length);
  const _p$3 = _p.length;
  let _tmp = 0;
  while (true) {
    const _p$4 = _tmp;
    if (_p$4 < _p$3) {
      const _p$5 = _p[_p$4];
      _p$2[_p$4] = _M0MPC15debug4Repr12render__repr(_p$5, threshold);
      _tmp = _p$4 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const children = _p$2;
  return _M0FPC15debug14with__resizing(threshold, _M0MPC15debug4Repr13pretty__print(label, children));
}
function _M0FPC15debug6render(r, max_depth) {
  const max_depth$2 = max_depth === undefined ? _M0FPC15debug6renderN6constrS1924 : max_depth;
  const info = _M0MPC15debug4Repr11prune__info(r, undefined, max_depth$2);
  return _M0FPC15debug14print__content(_M0MPC15debug7Content8no__wrap(_M0MPC15debug4Repr12render__repr(info, 70)));
}
function _M0IPC15debug4ReprPB4Show6output(self, logger) {
  logger.method_table.method_0(logger.self, _M0FPC15debug6render(self, undefined));
}
function _M0IPC13int3IntPC15debug5Debug8to__repr(self) {
  const _p = _M0MPC13int3Int18to__string_2einner(self, 10);
  return new _M0DTPC15debug4Repr7Integer(_p);
}
function _M0IPC16string6StringPC15debug5Debug8to__repr(self) {
  return new _M0DTPC15debug4Repr9StringLit(self);
}
function _M0FPC16buffer24buffer__growth__capacity(current, len, required) {
  if (required < len) {
    console.error("Buffer capacity overflow");
    $panic();
  }
  const start = current <= 0 ? 1 : current;
  let _tmp = start;
  while (true) {
    const space = _tmp;
    if (space >= required) {
      return space;
    }
    const next = Math.imul(space, 2) | 0;
    if (next <= space) {
      return required;
    }
    _tmp = next;
    continue;
  }
}
function _M0MPC16buffer6Buffer4grow(self, required) {
  const new_capacity = _M0FPC16buffer24buffer__growth__capacity(self.data.length, self.len, required);
  const new_data = _M0MPC15array10FixedArray23make__and__blit_2einnerGyE(self.data, new_capacity, 0, self.len, 0, 0);
  self.data = new_data;
}
function _M0MPC16buffer6Buffer9to__bytes(self) {
  return _M0MPC15bytes5Bytes11from__array(_M0MPC15array10FixedArray21clamped__view_2einnerGyE(self.data, 0, self.len));
}
function _M0MPC16buffer6Buffer14Buffer_2einner(size_hint) {
  const initial = size_hint < 1 ? 1 : size_hint;
  const data = $makebytes(initial, 0);
  return new _M0TPC16buffer6Buffer(data, 0);
}
function _M0MPC16buffer6Buffer16write__bytesview(self, value) {
  const val_len = value.end - value.start | 0;
  const required = self.len + val_len | 0;
  if (required > self.data.length || required < self.len) {
    _M0MPC16buffer6Buffer4grow(self, required);
  }
  _M0MPC15array10FixedArray17blit__from__bytes(self.data, self.len, value.buf, value.start, value.end - value.start | 0);
  self.len = self.len + val_len | 0;
}
function _M0MPC16buffer6Buffer12write__bytes(self, value) {
  _M0MPC16buffer6Buffer16write__bytesview(self, value);
}
function _M0MPC16buffer6Buffer17write__char__utf8(buf, value) {
  const code = value;
  if (code >>> 0 < 128 >>> 0) {
    if (buf.len >= buf.data.length) {
      _M0MPC16buffer6Buffer4grow(buf, buf.len + 1 | 0);
    }
    const _tmp = buf.data;
    const _tmp$2 = buf.len;
    const _p = code & 127 | 0;
    _tmp[_tmp$2] = _p & 255;
    buf.len = buf.len + 1 | 0;
    return;
  } else {
    if (code >>> 0 < 2048 >>> 0) {
      if ((buf.data.length - buf.len | 0) < 2) {
        _M0MPC16buffer6Buffer4grow(buf, buf.len + 2 | 0);
      }
      const data = buf.data;
      const offset = buf.len;
      const _p = code >>> 6 & 31 | 192;
      data[offset] = _p & 255;
      const _tmp = offset + 1 | 0;
      const _p$2 = code & 63 | 128;
      data[_tmp] = _p$2 & 255;
      buf.len = buf.len + 2 | 0;
      return;
    } else {
      if (code >>> 0 < 65536 >>> 0) {
        if ((buf.data.length - buf.len | 0) < 3) {
          _M0MPC16buffer6Buffer4grow(buf, buf.len + 3 | 0);
        }
        const data = buf.data;
        const offset = buf.len;
        const _p = code >>> 12 & 15 | 224;
        data[offset] = _p & 255;
        const _tmp = offset + 1 | 0;
        const _p$2 = code >>> 6 & 63 | 128;
        data[_tmp] = _p$2 & 255;
        const _tmp$2 = offset + 2 | 0;
        const _p$3 = code & 63 | 128;
        data[_tmp$2] = _p$3 & 255;
        buf.len = buf.len + 3 | 0;
        return;
      } else {
        if (code >>> 0 < 1114112 >>> 0) {
          if ((buf.data.length - buf.len | 0) < 4) {
            _M0MPC16buffer6Buffer4grow(buf, buf.len + 4 | 0);
          }
          const data = buf.data;
          const offset = buf.len;
          const _p = code >>> 18 & 7 | 240;
          data[offset] = _p & 255;
          const _tmp = offset + 1 | 0;
          const _p$2 = code >>> 12 & 63 | 128;
          data[_tmp] = _p$2 & 255;
          const _tmp$2 = offset + 2 | 0;
          const _p$3 = code >>> 6 & 63 | 128;
          data[_tmp$2] = _p$3 & 255;
          const _tmp$3 = offset + 3 | 0;
          const _p$4 = code & 63 | 128;
          data[_tmp$3] = _p$4 & 255;
          buf.len = buf.len + 4 | 0;
          return;
        } else {
          console.error("Char out of range");
          $panic();
          return;
        }
      }
    }
  }
}
function _M0MPC16buffer6Buffer19write__string__utf8(buf, string) {
  const _bind = string.str;
  const _bind$2 = string.start;
  const _bind$3 = string.end;
  let _tmp = _bind$2;
  while (true) {
    const _string_index = _tmp;
    if (_string_index < _bind$3) {
      let _decoded_next_string_index;
      let _decoded_char;
      _L: {
        const _bind$4 = _bind.charCodeAt(_string_index);
        if (_bind$4 >= 55296 && _bind$4 <= 56319 && (_string_index + 1 | 0) < _bind$3) {
          const _bind$5 = _bind.charCodeAt(_string_index + 1 | 0);
          if (_bind$5 >= 56320 && _bind$5 <= 57343) {
            const _tmp$2 = _string_index + 2 | 0;
            const _p = (((Math.imul(_bind$4 - 55296 | 0, 1024) | 0) + _bind$5 | 0) - 56320 | 0) + 65536 | 0;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$4;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        } else {
          const _tmp$2 = _string_index + 1 | 0;
          const _p = _bind$4;
          _decoded_next_string_index = _tmp$2;
          _decoded_char = _p;
          break _L;
        }
      }
      _M0MPC16buffer6Buffer17write__char__utf8(buf, _decoded_char);
      _tmp = _decoded_next_string_index;
      continue;
    } else {
      return;
    }
  }
}
function _M0MPC16buffer6Buffer11write__byte(self, value) {
  if (self.len >= self.data.length) {
    _M0MPC16buffer6Buffer4grow(self, self.len + 1 | 0);
  }
  self.data[self.len] = value;
  self.len = self.len + 1 | 0;
}
function _M0FPC28encoding4utf814encode_2einner(str, bom) {
  return _M0FPC28encoding4utf816encode__utf8__js(str.str, str.start, str.end - str.start | 0, bom);
}
function _M0FPC28encoding4utf821decode__lossy_2einner(bytes, ignore_bom) {
  return _M0FPC28encoding4utf823decode__utf8__lossy__js(bytes.buf, bytes.start, bytes.end - bytes.start | 0, !ignore_bom);
}
function _M0FPC28internal7strconv10range__errGuE() {
  return new _M0DTPC16result6ResultGuRPB7FailureE3Err(new _M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure(_M0FPC28internal7strconv15range__err__str));
}
function _M0FPC28internal7strconv11syntax__errGRPC28internal7strconv7DecimalE() {
  return new _M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPB7FailureE3Err(new _M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure(_M0FPC28internal7strconv16syntax__err__str));
}
function _M0FPC28internal7strconv11syntax__errGORPC28internal7strconv6NumberE() {
  return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPB7FailureE3Err(new _M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure(_M0FPC28internal7strconv16syntax__err__str));
}
function _M0FPC28internal7strconv11syntax__errGuE() {
  return new _M0DTPC16result6ResultGuRPB7FailureE3Err(new _M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure(_M0FPC28internal7strconv16syntax__err__str));
}
function _M0FPC28internal7strconv11syntax__errGdE() {
  return new _M0DTPC16result6ResultGdRPB7FailureE3Err(new _M0DTPC15error5Error48moonbitlang_2fcore_2fbuiltin_2eFailure_2eFailure(_M0FPC28internal7strconv16syntax__err__str));
}
function _M0EPC16string10StringViewPC28internal7strconv12fold__digitsGlE(self, init, f) {
  let _tmp = self;
  let _tmp$2 = init;
  let _tmp$3 = 0;
  while (true) {
    const str = _tmp;
    const ret = _tmp$2;
    const len = _tmp$3;
    _L: {
      if ((str.end - str.start | 0) >= 1) {
        const _x = str.str.charCodeAt(str.start);
        if (_x >= 48 && _x <= 57) {
          const _x$2 = new _M0TPC16string10StringView(str.str, str.start + 1 | 0, str.end);
          _tmp = _x$2;
          _tmp$2 = f(_x - 48 | 0, ret);
          _tmp$3 = len + 1 | 0;
          continue;
        } else {
          if (_x === 95) {
            const _x$2 = new _M0TPC16string10StringView(str.str, str.start + 1 | 0, str.end);
            _tmp = _x$2;
            continue;
          } else {
            break _L;
          }
        }
      } else {
        break _L;
      }
    }
    return { _0: str, _1: ret, _2: len };
  }
}
function _M0FPC28internal7strconv13parse__digits(s, x) {
  return _M0EPC16string10StringViewPC28internal7strconv12fold__digitsGlE(s, x, (digit, acc) => BigInt.asUintN(64, BigInt.asUintN(64, acc * 10n) + BigInt.asUintN(64, BigInt(digit >>> 0))));
}
function _M0FPC28internal7strconv20try__parse__19digits(s, x) {
  let x$2 = x;
  let len = 0;
  let _tmp = s;
  while (true) {
    const s$2 = _tmp;
    let s$3;
    _L: {
      if ((s$2.end - s$2.start | 0) >= 1) {
        const _x = s$2.str.charCodeAt(s$2.start);
        if (_x >= 48 && _x <= 57) {
          const _x$2 = new _M0TPC16string10StringView(s$2.str, s$2.start + 1 | 0, s$2.end);
          if (BigInt.asUintN(64, x$2) < BigInt.asUintN(64, _M0FPC28internal7strconv17min__19digit__int)) {
            len = len + 1 | 0;
            x$2 = BigInt.asUintN(64, BigInt.asUintN(64, x$2 * 10n) + BigInt.asUintN(64, BigInt((_x - 48 | 0) >>> 0)));
            _tmp = _x$2;
            continue;
          } else {
            s$3 = s$2;
            break _L;
          }
        } else {
          if (_x === 95) {
            const _x$2 = new _M0TPC16string10StringView(s$2.str, s$2.start + 1 | 0, s$2.end);
            _tmp = _x$2;
            continue;
          } else {
            s$3 = s$2;
            break _L;
          }
        }
      } else {
        s$3 = s$2;
        break _L;
      }
    }
    return { _0: s$3, _1: x$2, _2: len };
  }
}
function _M0FPC28internal7strconv17parse__scientific(s) {
  let s$2 = s;
  let neg_exp = false;
  let rest;
  let ch;
  _L: {
    _L$2: {
      const _bind = s$2;
      if ((_bind.end - _bind.start | 0) >= 1) {
        const _x = _bind.str.charCodeAt(_bind.start);
        switch (_x) {
          case 43: {
            const _x$2 = new _M0TPC16string10StringView(_bind.str, _bind.start + 1 | 0, _bind.end);
            rest = _x$2;
            ch = _x;
            break _L$2;
          }
          case 45: {
            const _x$3 = new _M0TPC16string10StringView(_bind.str, _bind.start + 1 | 0, _bind.end);
            rest = _x$3;
            ch = _x;
            break _L$2;
          }
        }
      }
      break _L;
    }
    neg_exp = ch === 45;
    s$2 = rest;
  }
  _L$2: {
    const _bind = s$2;
    if ((_bind.end - _bind.start | 0) >= 1) {
      const _x = _bind.str.charCodeAt(_bind.start);
      if (_x >= 48 && _x <= 57) {
        const _bind$2 = _M0EPC16string10StringViewPC28internal7strconv12fold__digitsGlE(s$2, _M0FPC28internal7strconv17parse__scientificN8exp__numS2079, (digit, exp_num) => BigInt.asIntN(64, exp_num) < BigInt.asIntN(64, 65536n) ? BigInt.asUintN(64, BigInt.asUintN(64, 10n * exp_num) + BigInt.asUintN(64, BigInt(digit))) : exp_num);
        const _s = _bind$2._0;
        const _exp_num = _bind$2._1;
        return neg_exp ? { _0: _s, _1: BigInt.asUintN(64, -_exp_num) } : { _0: _s, _1: _exp_num };
      } else {
        break _L$2;
      }
    } else {
      break _L$2;
    }
  }
  return undefined;
}
function _M0FPC28internal7strconv13parse__number(s) {
  let s$2;
  let negative;
  _L: {
    let rest;
    _L$2: {
      if ((s.end - s.start | 0) >= 1) {
        const _x = s.str.charCodeAt(s.start);
        switch (_x) {
          case 45: {
            const _x$2 = new _M0TPC16string10StringView(s.str, s.start + 1 | 0, s.end);
            s$2 = _x$2;
            negative = true;
            break _L;
          }
          case 43: {
            const _x$3 = new _M0TPC16string10StringView(s.str, s.start + 1 | 0, s.end);
            rest = _x$3;
            break _L$2;
          }
          default: {
            rest = s;
            break _L$2;
          }
        }
      } else {
        rest = s;
        break _L$2;
      }
    }
    s$2 = rest;
    negative = false;
    break _L;
  }
  if ((s$2.end - s$2.start | 0) === 0) {
    return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(undefined);
  }
  const _bind = _M0FPC28internal7strconv13parse__digits(s$2, 0n);
  const _s = _bind._0;
  const _mantissa = _bind._1;
  const _consumed = _bind._2;
  let mantissa = _mantissa;
  let s$3 = _s;
  let n_digits = _consumed;
  let n_after_dot = 0;
  let exponent = 0n;
  const _bind$2 = s$3;
  if ((_bind$2.end - _bind$2.start | 0) >= 1) {
    const _x = _bind$2.str.charCodeAt(_bind$2.start);
    if (_x === 46) {
      const _x$2 = new _M0TPC16string10StringView(_bind$2.str, _bind$2.start + 1 | 0, _bind$2.end);
      s$3 = _x$2;
      const _bind$3 = _M0FPC28internal7strconv13parse__digits(s$3, mantissa);
      const _new_s = _bind$3._0;
      const _new_mantissa = _bind$3._1;
      const _consumed_digit = _bind$3._2;
      s$3 = _new_s;
      mantissa = _new_mantissa;
      n_after_dot = _consumed_digit;
      exponent = BigInt.asUintN(64, -BigInt.asUintN(64, BigInt(n_after_dot)));
    }
  }
  n_digits = n_digits + n_after_dot | 0;
  if (n_digits === 0) {
    return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(undefined);
  }
  let exp_number = 0n;
  let rest;
  _L$2: {
    _L$3: {
      const _bind$3 = s$3;
      if ((_bind$3.end - _bind$3.start | 0) >= 1) {
        const _x = _bind$3.str.charCodeAt(_bind$3.start);
        switch (_x) {
          case 101: {
            const _x$2 = new _M0TPC16string10StringView(_bind$3.str, _bind$3.start + 1 | 0, _bind$3.end);
            rest = _x$2;
            break _L$3;
          }
          case 69: {
            const _x$3 = new _M0TPC16string10StringView(_bind$3.str, _bind$3.start + 1 | 0, _bind$3.end);
            rest = _x$3;
            break _L$3;
          }
        }
      }
      break _L$2;
    }
    const _bind$3 = _M0FPC28internal7strconv17parse__scientific(rest);
    let _bind$4;
    if (_bind$3 === undefined) {
      return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(undefined);
    } else {
      const _Some = _bind$3;
      _bind$4 = _Some;
    }
    const _new_s = _bind$4._0;
    const _exp_number_val = _bind$4._1;
    s$3 = _new_s;
    exp_number = _exp_number_val;
    exponent = BigInt.asUintN(64, exponent + exp_number);
  }
  const _bind$3 = s$3;
  if ((_bind$3.end - _bind$3.start | 0) === 0) {
    if (n_digits <= 19) {
      return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(new _M0TPC28internal7strconv6Number(exponent, mantissa, negative, false));
    }
    n_digits = n_digits - 19 | 0;
    let many_digits = false;
    let _tmp = s.str;
    let _tmp$2 = s.start;
    let _tmp$3 = s.end;
    _L$3: while (true) {
      const s_str = _tmp;
      const s_start = _tmp$2;
      const s_end = _tmp$3;
      _L$4: {
        let rest$2;
        let ch;
        _L$5: {
          if ((s_end - s_start | 0) >= 1) {
            const _x = s_str.charCodeAt(s_start);
            switch (_x) {
              case 48: {
                const _x$2 = new _M0TPC16string10StringView(s_str, s_start + 1 | 0, s_end);
                rest$2 = _x$2;
                ch = _x;
                break _L$5;
              }
              case 46: {
                const _x$3 = new _M0TPC16string10StringView(s_str, s_start + 1 | 0, s_end);
                rest$2 = _x$3;
                ch = _x;
                break _L$5;
              }
              default: {
                break _L$4;
              }
            }
          } else {
            break _L$4;
          }
        }
        n_digits = n_digits - ((ch - 46 | 0) / 2 | 0) | 0;
        _tmp = rest$2.str;
        _tmp$2 = rest$2.start;
        _tmp$3 = rest$2.end;
        continue;
      }
      break;
    }
    if (n_digits > 0) {
      many_digits = true;
      mantissa = 0n;
      const _bind$4 = _M0FPC28internal7strconv20try__parse__19digits(s, mantissa);
      const _s$2 = _bind$4._0;
      const _new_mantissa = _bind$4._1;
      const _consumed_digit = _bind$4._2;
      mantissa = _new_mantissa;
      let _tmp$4;
      if (BigInt.asUintN(64, mantissa) >= BigInt.asUintN(64, _M0FPC28internal7strconv17min__19digit__int)) {
        _tmp$4 = _consumed_digit;
      } else {
        if (_M0MPC16string6String24char__length__ge_2einner(_s$2.str, 1, _s$2.start, _s$2.end)) {
          const _tmp$5 = _s$2.str;
          const _bind$5 = _M0MPC16string6String29offset__of__nth__char_2einner(_s$2.str, 1, _s$2.start, _s$2.end);
          let _tmp$6;
          if (_bind$5 === undefined) {
            _tmp$6 = _s$2.end;
          } else {
            const _Some = _bind$5;
            _tmp$6 = _Some;
          }
          const _x = new _M0TPC16string10StringView(_tmp$5, _tmp$6, _s$2.end);
          const _bind$6 = _M0FPC28internal7strconv20try__parse__19digits(_x, mantissa);
          const _new_mantissa$2 = _bind$6._1;
          const _consumed_digit$2 = _bind$6._2;
          mantissa = _new_mantissa$2;
          _tmp$4 = _consumed_digit$2;
        } else {
          return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(undefined);
        }
      }
      exponent = BigInt.asUintN(64, BigInt(_tmp$4));
      exponent = BigInt.asUintN(64, exponent + exp_number);
    }
    return new _M0DTPC16result6ResultGORPC28internal7strconv6NumberRPC15error5ErrorE2Ok(new _M0TPC28internal7strconv6Number(exponent, mantissa, negative, many_digits));
  } else {
    return _M0FPC28internal7strconv11syntax__errGORPC28internal7strconv6NumberE();
  }
}
function _M0FPC28internal7strconv15parse__inf__nan(rest) {
  let pos;
  let rest$2;
  _L: {
    let rest$3;
    _L$2: {
      if ((rest.end - rest.start | 0) >= 1) {
        const _x = rest.str.charCodeAt(rest.start);
        switch (_x) {
          case 45: {
            const _x$2 = new _M0TPC16string10StringView(rest.str, rest.start + 1 | 0, rest.end);
            pos = false;
            rest$2 = _x$2;
            break _L;
          }
          case 43: {
            const _x$3 = new _M0TPC16string10StringView(rest.str, rest.start + 1 | 0, rest.end);
            rest$3 = _x$3;
            break _L$2;
          }
          default: {
            rest$3 = rest;
            break _L$2;
          }
        }
      } else {
        rest$3 = rest;
        break _L$2;
      }
    }
    pos = true;
    rest$2 = rest$3;
    break _L;
  }
  let _cursor_295 = 0;
  const _input_end_297 = rest$2.end - rest$2.start | 0;
  const _start_296 = _cursor_295;
  let _accept_state_298 = -1;
  let _match_end_299 = -1;
  let _state_300 = 2;
  while (true) {
    if (_state_300 !== 14) {
      if (_state_300 < 2) {
        _accept_state_298 = _state_300;
        _match_end_299 = _cursor_295;
      }
      const _tmp = Math.imul(_state_300, 8) | 0;
      let _next_char_303;
      if (_cursor_295 < _input_end_297) {
        const _char_302 = rest$2.str.charCodeAt(rest$2.start + _cursor_295 | 0);
        _cursor_295 = _cursor_295 + 1 | 0;
        _next_char_303 = _char_302;
      } else {
        _next_char_303 = -1;
      }
      const _p = _tmp + (_next_char_303 < 90 ? (_next_char_303 < 73 ? (_next_char_303 < 66 ? (_next_char_303 < 0 ? 0 : _next_char_303 > 64 ? 1 : 7) : _next_char_303 > 69 ? (_next_char_303 < 71 ? 2 : 7) : 7) : _next_char_303 > 73 ? (_next_char_303 < 84 ? (_next_char_303 < 78 ? 7 : _next_char_303 > 78 ? 7 : 4) : _next_char_303 > 84 ? (_next_char_303 < 89 ? 7 : 6) : 5) : 3) : _next_char_303 > 96 ? (_next_char_303 < 110 ? (_next_char_303 < 103 ? (_next_char_303 < 98 ? 1 : _next_char_303 > 101 ? 2 : 7) : _next_char_303 > 104 ? (_next_char_303 < 106 ? 3 : 7) : 7) : _next_char_303 > 110 ? (_next_char_303 < 117 ? (_next_char_303 < 116 ? 7 : 5) : _next_char_303 > 120 ? (_next_char_303 < 122 ? 6 : 7) : 7) : 4) : 7) | 0;
      _state_300 = _M0FPC28internal7strconv15parse__inf__nanN25_2atransition__table__304S2157[_p];
      continue;
    } else {
      break;
    }
  }
  const _bind = _accept_state_298;
  switch (_bind) {
    case 0: {
      _cursor_295 = _match_end_299;
      return new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok(_M0FPC16double14not__a__number);
    }
    case 1: {
      _cursor_295 = _match_end_299;
      return pos ? new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok(_M0FPC16double8infinity) : new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok(_M0FPC16double13neg__infinity);
    }
    default: {
      _cursor_295 = _start_296;
      return _M0FPC28internal7strconv11syntax__errGdE();
    }
  }
}
function _M0FPC28internal7strconv12checked__mul(a, b) {
  if (BigInt.asUintN(64, a) === BigInt.asUintN(64, 0n) || BigInt.asUintN(64, b) === BigInt.asUintN(64, 0n)) {
    return _M0FPC28internal7strconv12checked__mulN6constrS2177;
  }
  if (BigInt.asUintN(64, a) === BigInt.asUintN(64, 1n)) {
    return b;
  }
  if (BigInt.asUintN(64, b) === BigInt.asUintN(64, 1n)) {
    return a;
  }
  if ($i64_clz(b) === 0 || $i64_clz(a) === 0) {
    return undefined;
  }
  if (b === 0n) {
    $panic();
  }
  const quotient = BigInt.asUintN(64, BigInt.asUintN(64, 18446744073709551615n) / BigInt.asUintN(64, b));
  if (BigInt.asUintN(64, a) > BigInt.asUintN(64, quotient)) {
    return undefined;
  }
  return BigInt.asUintN(64, a * b);
}
function _M0FPC28internal7strconv17check__underscore(str) {
  const _p = 95;
  if (_M0MPC16string10StringView20contains__code__unit(str, _p)) {
    let rest;
    if ((str.end - str.start | 0) >= 1) {
      const _x = str.str.charCodeAt(str.start);
      switch (_x) {
        case 43: {
          const _x$2 = new _M0TPC16string10StringView(str.str, str.start + 1 | 0, str.end);
          rest = _x$2;
          break;
        }
        case 45: {
          const _x$3 = new _M0TPC16string10StringView(str.str, str.start + 1 | 0, str.end);
          rest = _x$3;
          break;
        }
        default: {
          rest = str;
        }
      }
    } else {
      rest = str;
    }
    let rest$2;
    let allow_underscore;
    let hex;
    _L: {
      let _cursor_213 = 0;
      const _input_end_215 = rest.end - rest.start | 0;
      const _start_214 = _cursor_213;
      let _accept_state_216 = -1;
      let _match_end_217 = -1;
      let _state_218 = 3;
      while (true) {
        if (_state_218 !== 5) {
          if (_state_218 < 3) {
            _accept_state_216 = _state_218;
            _match_end_217 = _cursor_213;
          }
          const _tmp = Math.imul(_state_218, 5) | 0;
          let _next_char_221;
          if (_cursor_213 < _input_end_215) {
            const _char_220 = rest.str.charCodeAt(rest.start + _cursor_213 | 0);
            _cursor_213 = _cursor_213 + 1 | 0;
            _next_char_221 = _char_220;
          } else {
            _next_char_221 = -1;
          }
          const _p$2 = _tmp + (_next_char_221 < 88 ? (_next_char_221 < 66 ? (_next_char_221 < 48 ? 4 : _next_char_221 > 48 ? 4 : 0) : _next_char_221 > 66 ? (_next_char_221 < 79 ? 4 : _next_char_221 > 79 ? 4 : 2) : 1) : _next_char_221 > 88 ? (_next_char_221 < 111 ? (_next_char_221 < 98 ? 4 : _next_char_221 > 98 ? 4 : 1) : _next_char_221 > 111 ? (_next_char_221 < 120 ? 4 : _next_char_221 > 120 ? 4 : 3) : 2) : 3) | 0;
          _state_218 = _M0FPC28internal7strconv17check__underscoreN25_2atransition__table__222S2181[_p$2];
          continue;
        } else {
          break;
        }
      }
      const _bind = _accept_state_216;
      switch (_bind) {
        case 0: {
          _cursor_213 = _match_end_217;
          const rest$3 = _M0MPC16string10StringView19exact__view_2einner(rest, _match_end_217, _input_end_215);
          rest$2 = rest$3;
          allow_underscore = true;
          hex = false;
          break _L;
        }
        case 1: {
          _cursor_213 = _match_end_217;
          const rest$4 = _M0MPC16string10StringView19exact__view_2einner(rest, _match_end_217, _input_end_215);
          rest$2 = rest$4;
          allow_underscore = true;
          hex = false;
          break _L;
        }
        case 2: {
          _cursor_213 = _match_end_217;
          const rest$5 = _M0MPC16string10StringView19exact__view_2einner(rest, _match_end_217, _input_end_215);
          rest$2 = rest$5;
          allow_underscore = true;
          hex = true;
          break _L;
        }
        default: {
          _cursor_213 = _start_214;
          rest$2 = rest;
          allow_underscore = false;
          hex = false;
          break _L;
        }
      }
    }
    let _tmp = rest$2.str;
    let _tmp$2 = rest$2.start;
    let _tmp$3 = rest$2.end;
    let _tmp$4 = allow_underscore;
    let _tmp$5 = false;
    while (true) {
      const rest_str = _tmp;
      const rest_start = _tmp$2;
      const rest_end = _tmp$3;
      const allow_underscore$2 = _tmp$4;
      const follow_underscore = _tmp$5;
      let rest$3;
      _L$2: {
        _L$3: {
          let rest$4;
          _L$4: {
            _L$5: {
              let rest$5;
              _L$6: {
                let rest$6;
                _L$7: {
                  if ((rest_end - rest_start | 0) === 0) {
                    return true;
                  } else {
                    if ((rest_end - rest_start | 0) === 1) {
                      const _x = rest_str.charCodeAt(rest_start);
                      if (_x === 95) {
                        return false;
                      } else {
                        if (_x >= 48 && _x <= 57) {
                          const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                          rest$6 = _x$2;
                          break _L$7;
                        } else {
                          if (_x >= 97 && _x <= 102) {
                            const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                            if (hex) {
                              rest$5 = _x$2;
                              break _L$6;
                            } else {
                              if (_x === 101) {
                                if (follow_underscore === true) {
                                  break _L$5;
                                } else {
                                  rest$4 = _x$2;
                                  break _L$4;
                                }
                              } else {
                                if (follow_underscore === true) {
                                  break _L$3;
                                } else {
                                  rest$3 = _x$2;
                                  break _L$2;
                                }
                              }
                            }
                          } else {
                            if (_x >= 65 && _x <= 70) {
                              const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                              if (hex) {
                                rest$5 = _x$2;
                                break _L$6;
                              } else {
                                if (_x === 69) {
                                  if (follow_underscore === true) {
                                    break _L$5;
                                  } else {
                                    rest$4 = _x$2;
                                    break _L$4;
                                  }
                                } else {
                                  if (follow_underscore === true) {
                                    break _L$3;
                                  } else {
                                    rest$3 = _x$2;
                                    break _L$2;
                                  }
                                }
                              }
                            } else {
                              if (_x === 46) {
                                if (follow_underscore === true) {
                                  break _L$5;
                                } else {
                                  const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                                  rest$4 = _x$2;
                                  break _L$4;
                                }
                              } else {
                                if (_x === 43) {
                                  if (follow_underscore === true) {
                                    break _L$5;
                                  } else {
                                    const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                                    rest$4 = _x$2;
                                    break _L$4;
                                  }
                                } else {
                                  if (_x === 45) {
                                    if (follow_underscore === true) {
                                      break _L$5;
                                    } else {
                                      const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                                      rest$4 = _x$2;
                                      break _L$4;
                                    }
                                  } else {
                                    if (follow_underscore === true) {
                                      break _L$3;
                                    } else {
                                      const _bind = _M0MPC16string6String29offset__of__nth__char_2einner(rest_str, 1, rest_start, rest_end);
                                      let _tmp$6;
                                      if (_bind === undefined) {
                                        _tmp$6 = rest_end;
                                      } else {
                                        const _Some = _bind;
                                        _tmp$6 = _Some;
                                      }
                                      const _x$2 = new _M0TPC16string10StringView(rest_str, _tmp$6, rest_end);
                                      rest$3 = _x$2;
                                      break _L$2;
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    } else {
                      const _x = rest_str.charCodeAt(rest_start);
                      if (_x === 95) {
                        if (allow_underscore$2 === false) {
                          return false;
                        } else {
                          const _bind = rest_start + 1 | 0;
                          _tmp$2 = _bind;
                          _tmp$4 = false;
                          _tmp$5 = true;
                          continue;
                        }
                      } else {
                        if (_x >= 48 && _x <= 57) {
                          const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                          rest$6 = _x$2;
                          break _L$7;
                        } else {
                          if (_x >= 97 && _x <= 102) {
                            const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                            if (hex) {
                              rest$5 = _x$2;
                              break _L$6;
                            } else {
                              if (_x === 101) {
                                if (follow_underscore === true) {
                                  break _L$5;
                                } else {
                                  rest$4 = _x$2;
                                  break _L$4;
                                }
                              } else {
                                if (follow_underscore === true) {
                                  break _L$3;
                                } else {
                                  rest$3 = _x$2;
                                  break _L$2;
                                }
                              }
                            }
                          } else {
                            if (_x >= 65 && _x <= 70) {
                              const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                              if (hex) {
                                rest$5 = _x$2;
                                break _L$6;
                              } else {
                                if (_x === 69) {
                                  if (follow_underscore === true) {
                                    break _L$5;
                                  } else {
                                    rest$4 = _x$2;
                                    break _L$4;
                                  }
                                } else {
                                  if (follow_underscore === true) {
                                    break _L$3;
                                  } else {
                                    rest$3 = _x$2;
                                    break _L$2;
                                  }
                                }
                              }
                            } else {
                              if (_x === 46) {
                                if (follow_underscore === true) {
                                  break _L$5;
                                } else {
                                  const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                                  rest$4 = _x$2;
                                  break _L$4;
                                }
                              } else {
                                if (_x === 43) {
                                  if (follow_underscore === true) {
                                    break _L$5;
                                  } else {
                                    const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                                    rest$4 = _x$2;
                                    break _L$4;
                                  }
                                } else {
                                  if (_x === 45) {
                                    if (follow_underscore === true) {
                                      break _L$5;
                                    } else {
                                      const _x$2 = new _M0TPC16string10StringView(rest_str, rest_start + 1 | 0, rest_end);
                                      rest$4 = _x$2;
                                      break _L$4;
                                    }
                                  } else {
                                    if (follow_underscore === true) {
                                      break _L$3;
                                    } else {
                                      const _bind = _M0MPC16string6String29offset__of__nth__char_2einner(rest_str, 1, rest_start, rest_end);
                                      let _tmp$6;
                                      if (_bind === undefined) {
                                        _tmp$6 = rest_end;
                                      } else {
                                        const _Some = _bind;
                                        _tmp$6 = _Some;
                                      }
                                      const _x$2 = new _M0TPC16string10StringView(rest_str, _tmp$6, rest_end);
                                      rest$3 = _x$2;
                                      break _L$2;
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
                _tmp = rest$6.str;
                _tmp$2 = rest$6.start;
                _tmp$3 = rest$6.end;
                _tmp$4 = true;
                _tmp$5 = false;
                continue;
              }
              _tmp = rest$5.str;
              _tmp$2 = rest$5.start;
              _tmp$3 = rest$5.end;
              _tmp$4 = true;
              _tmp$5 = false;
              continue;
            }
            return false;
          }
          _tmp = rest$4.str;
          _tmp$2 = rest$4.start;
          _tmp$3 = rest$4.end;
          _tmp$4 = false;
          _tmp$5 = false;
          continue;
        }
        return false;
      }
      _tmp = rest$3.str;
      _tmp$2 = rest$3.start;
      _tmp$3 = rest$3.end;
      _tmp$4 = false;
      _tmp$5 = false;
      continue;
    }
  } else {
    return true;
  }
}
function _M0FPC28internal7strconv14eisel__umul128(a, b) {
  const a_lo = BigInt.asUintN(64, a & 4294967295n);
  const a_hi = BigInt.asUintN(64, BigInt.asUintN(64, a) >> BigInt(32 & 63));
  const b_lo = BigInt.asUintN(64, b & 4294967295n);
  const b_hi = BigInt.asUintN(64, BigInt.asUintN(64, b) >> BigInt(32 & 63));
  const x = BigInt.asUintN(64, a_lo * b_lo);
  const y = BigInt.asUintN(64, BigInt.asUintN(64, a_hi * b_lo) + BigInt.asUintN(64, BigInt.asUintN(64, x) >> BigInt(32 & 63)));
  const z = BigInt.asUintN(64, BigInt.asUintN(64, a_lo * b_hi) + BigInt.asUintN(64, y & 4294967295n));
  const hi = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, a_hi * b_hi) + BigInt.asUintN(64, BigInt.asUintN(64, y) >> BigInt(32 & 63))) + BigInt.asUintN(64, BigInt.asUintN(64, z) >> BigInt(32 & 63)));
  return new _M0TPC28internal7strconv12EiselProduct(BigInt.asUintN(64, a * b), hi);
}
function _M0FPC28internal7strconv20try__eisel__lemire64(mantissa, exponent, negative) {
  if (BigInt.asUintN(64, mantissa) === BigInt.asUintN(64, 0n)) {
    return negative ? $i64_reinterpret_f64(9223372036854775808n) : 0;
  }
  if (BigInt.asIntN(64, exponent) < BigInt.asIntN(64, 18446744073709551268n) || BigInt.asIntN(64, exponent) > BigInt.asIntN(64, 347n)) {
    return _M0FPC16double14not__a__number;
  }
  const exponent$2 = Number(BigInt.asIntN(32, exponent)) | 0;
  const table_index = Math.imul(exponent$2 - -348 | 0, 2) | 0;
  const pow_hi = table_index >>> 0 < _M0FPC28internal7strconv27eisel__lemire__pow10__table.length ? _M0FPC28internal7strconv27eisel__lemire__pow10__table[table_index] : $oob();
  const _p = table_index + 1 | 0;
  const pow_lo = _p >>> 0 < _M0FPC28internal7strconv27eisel__lemire__pow10__table.length ? _M0FPC28internal7strconv27eisel__lemire__pow10__table[_p] : $oob();
  const pow_exp2 = 1 + (Math.imul(exponent$2, 108853) >> 15) | 0;
  const leading_zeros = $i64_clz(mantissa);
  const normalized = BigInt.asUintN(64, mantissa << BigInt(leading_zeros & 63));
  let result_exp2 = ((pow_exp2 + 63 | 0) + 1023 | 0) - leading_zeros | 0;
  const product = _M0FPC28internal7strconv14eisel__umul128(normalized, pow_hi);
  let product_hi = product.hi;
  let product_lo = product.lo;
  if (BigInt.asUintN(64, BigInt.asUintN(64, product_hi & 511n)) === BigInt.asUintN(64, 511n) && BigInt.asUintN(64, BigInt.asUintN(64, product_lo + normalized)) < BigInt.asUintN(64, normalized)) {
    const wider = _M0FPC28internal7strconv14eisel__umul128(normalized, pow_lo);
    let merged_hi = product_hi;
    const merged_lo = BigInt.asUintN(64, product_lo + wider.hi);
    if (BigInt.asUintN(64, merged_lo) < BigInt.asUintN(64, product_lo)) {
      merged_hi = BigInt.asUintN(64, merged_hi + 1n);
    }
    if (BigInt.asUintN(64, BigInt.asUintN(64, merged_hi & 511n)) === BigInt.asUintN(64, 511n) && (BigInt.asUintN(64, BigInt.asUintN(64, merged_lo + 1n)) === BigInt.asUintN(64, 0n) && BigInt.asUintN(64, BigInt.asUintN(64, wider.lo + normalized)) < BigInt.asUintN(64, normalized))) {
      return _M0FPC16double14not__a__number;
    }
    product_hi = merged_hi;
    product_lo = merged_lo;
  }
  const top_bit = Number(BigInt.asIntN(32, BigInt.asUintN(64, BigInt.asUintN(64, product_hi) >> BigInt(63 & 63)))) | 0;
  let result_mantissa = BigInt.asUintN(64, BigInt.asUintN(64, product_hi) >> BigInt(top_bit + 9 & 63));
  result_exp2 = result_exp2 - (1 - top_bit | 0) | 0;
  if (BigInt.asUintN(64, product_lo) === BigInt.asUintN(64, 0n) && (BigInt.asUintN(64, BigInt.asUintN(64, product_hi & 511n)) === BigInt.asUintN(64, 0n) && BigInt.asUintN(64, BigInt.asUintN(64, result_mantissa & 3n)) === BigInt.asUintN(64, 1n))) {
    return _M0FPC16double14not__a__number;
  }
  result_mantissa = BigInt.asUintN(64, result_mantissa + BigInt.asUintN(64, result_mantissa & 1n));
  result_mantissa = BigInt.asUintN(64, BigInt.asUintN(64, result_mantissa) >> BigInt(1 & 63));
  if (BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, result_mantissa) >> BigInt(53 & 63))) > BigInt.asUintN(64, 0n)) {
    result_mantissa = BigInt.asUintN(64, BigInt.asUintN(64, result_mantissa) >> BigInt(1 & 63));
    result_exp2 = result_exp2 + 1 | 0;
  }
  if (result_exp2 <= 0 || result_exp2 >= 2047) {
    return _M0FPC16double14not__a__number;
  }
  const exponent_bits = BigInt.asUintN(64, BigInt.asUintN(64, BigInt(result_exp2 >>> 0)) << BigInt(52 & 63));
  let result_bits = BigInt.asUintN(64, exponent_bits | BigInt.asUintN(64, result_mantissa & 4503599627370495n));
  if (negative) {
    result_bits = BigInt.asUintN(64, result_bits | 9223372036854775808n);
  }
  return $i64_reinterpret_f64(result_bits);
}
function _M0MPC28internal7strconv7Decimal9new__priv() {
  return new _M0TPC28internal7strconv7Decimal($makebytes(800, 0), 0, 0, false, false, 0);
}
function _M0MPC28internal7strconv7Decimal4trim(self) {
  while (true) {
    let _tmp;
    if (self.digits_num > 0) {
      const _tmp$2 = self.digits;
      const _tmp$3 = self.digits_num - 1 | 0;
      _tmp = (_tmp$3 >>> 0 < _tmp$2.length ? _tmp$2[_tmp$3] : $oob()) === 0;
    } else {
      _tmp = false;
    }
    if (_tmp) {
      self.digits_num = self.digits_num - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (self.digits_num === 0) {
    self.decimal_point = 0;
    return;
  } else {
    return;
  }
}
function _M0FPC28internal7strconv26parse__decimal__from__view(str) {
  const d = _M0MPC28internal7strconv7Decimal9new__priv();
  let has_dp = false;
  let has_digits = false;
  let rest;
  _L: {
    _L$2: {
      if ((str.end - str.start | 0) >= 1) {
        const _x = str.str.charCodeAt(str.start);
        switch (_x) {
          case 45: {
            const _x$2 = new _M0TPC16string10StringView(str.str, str.start + 1 | 0, str.end);
            d.negative = true;
            rest = _x$2;
            break;
          }
          case 43: {
            rest = new _M0TPC16string10StringView(str.str, str.start + 1 | 0, str.end);
            break;
          }
          default: {
            break _L$2;
          }
        }
      } else {
        break _L$2;
      }
      break _L;
    }
    rest = str;
  }
  let rest$2;
  let _tmp = rest;
  while (true) {
    const rest$3 = _tmp;
    let rest$4;
    _L$2: {
      _L$3: {
        if ((rest$3.end - rest$3.start | 0) >= 1) {
          const _x = rest$3.str.charCodeAt(rest$3.start);
          if (_x === 95) {
            const _x$2 = new _M0TPC16string10StringView(rest$3.str, rest$3.start + 1 | 0, rest$3.end);
            _tmp = _x$2;
            continue;
          } else {
            if (_x === 46) {
              const _x$2 = new _M0TPC16string10StringView(rest$3.str, rest$3.start + 1 | 0, rest$3.end);
              if (!has_dp) {
                has_dp = true;
                d.decimal_point = d.digits_num;
                _tmp = _x$2;
                continue;
              } else {
                const _bind = _M0FPC28internal7strconv11syntax__errGuE();
                if (_bind.$tag === 1) {
                  const _ok = _bind;
                  _ok._0;
                } else {
                  return _bind;
                }
              }
            } else {
              if (_x >= 48 && _x <= 57) {
                const _x$2 = new _M0TPC16string10StringView(rest$3.str, rest$3.start + 1 | 0, rest$3.end);
                has_digits = true;
                if (_x === 48 && d.digits_num === 0) {
                  d.decimal_point = d.decimal_point - 1 | 0;
                  _tmp = _x$2;
                  continue;
                }
                if (d.digits_num < d.digits.length) {
                  const _tmp$2 = d.digits;
                  const _tmp$3 = d.digits_num;
                  if (_tmp$3 >>> 0 < _tmp$2.length) {
                    _tmp$2[_tmp$3] = (_x - 48 | 0) & 255;
                  } else {
                    $oob();
                  }
                  d.digits_num = d.digits_num + 1 | 0;
                } else {
                  if (!has_dp) {
                    d.overflowed = d.overflowed + 1 | 0;
                  }
                  if (_x !== 48) {
                    d.truncated = true;
                  }
                }
                _tmp = _x$2;
                continue;
              } else {
                rest$4 = rest$3;
                break _L$3;
              }
            }
          }
        } else {
          rest$4 = rest$3;
          break _L$3;
        }
        break _L$2;
      }
      rest$2 = rest$4;
      break;
    }
    continue;
  }
  if (has_digits) {
    if (!has_dp) {
      d.decimal_point = d.digits_num;
    }
    let rest$3;
    let rest$4;
    _L$2: {
      _L$3: {
        if ((rest$2.end - rest$2.start | 0) >= 1) {
          const _x = rest$2.str.charCodeAt(rest$2.start);
          switch (_x) {
            case 101: {
              const _x$2 = new _M0TPC16string10StringView(rest$2.str, rest$2.start + 1 | 0, rest$2.end);
              rest$4 = _x$2;
              break _L$3;
            }
            case 69: {
              const _x$3 = new _M0TPC16string10StringView(rest$2.str, rest$2.start + 1 | 0, rest$2.end);
              rest$4 = _x$3;
              break _L$3;
            }
            default: {
              rest$3 = rest$2;
            }
          }
        } else {
          rest$3 = rest$2;
        }
        break _L$2;
      }
      let exp_sign = 1;
      let rest$5;
      if ((rest$4.end - rest$4.start | 0) >= 1) {
        const _x = rest$4.str.charCodeAt(rest$4.start);
        switch (_x) {
          case 43: {
            rest$5 = new _M0TPC16string10StringView(rest$4.str, rest$4.start + 1 | 0, rest$4.end);
            break;
          }
          case 45: {
            const _x$2 = new _M0TPC16string10StringView(rest$4.str, rest$4.start + 1 | 0, rest$4.end);
            exp_sign = -1;
            rest$5 = _x$2;
            break;
          }
          default: {
            rest$5 = rest$4;
          }
        }
      } else {
        rest$5 = rest$4;
      }
      _L$4: {
        _L$5: {
          if ((rest$5.end - rest$5.start | 0) >= 1) {
            const _x = rest$5.str.charCodeAt(rest$5.start);
            if (_x >= 48 && _x <= 57) {
              const effective_dp = d.decimal_point + d.overflowed | 0;
              const exp_limit = exp_sign > 0 ? (effective_dp < 311 ? 311 - effective_dp | 0 : 0) : effective_dp > -331 ? effective_dp + 331 | 0 : 0;
              let exp = 0;
              let rest$6;
              let _tmp$2 = rest$5;
              while (true) {
                const rest$7 = _tmp$2;
                let rest$8;
                _L$6: {
                  if ((rest$7.end - rest$7.start | 0) >= 1) {
                    const _x$2 = rest$7.str.charCodeAt(rest$7.start);
                    if (_x$2 === 95) {
                      const _x$3 = new _M0TPC16string10StringView(rest$7.str, rest$7.start + 1 | 0, rest$7.end);
                      _tmp$2 = _x$3;
                      continue;
                    } else {
                      if (_x$2 >= 48 && _x$2 <= 57) {
                        const _x$3 = new _M0TPC16string10StringView(rest$7.str, rest$7.start + 1 | 0, rest$7.end);
                        if (exp < exp_limit) {
                          exp = (Math.imul(exp, 10) | 0) + (_x$2 - 48 | 0) | 0;
                          if (exp > exp_limit) {
                            exp = exp_limit;
                          }
                        }
                        _tmp$2 = _x$3;
                        continue;
                      } else {
                        rest$8 = rest$7;
                        break _L$6;
                      }
                    }
                  } else {
                    rest$8 = rest$7;
                    break _L$6;
                  }
                }
                rest$6 = rest$8;
                break;
              }
              d.decimal_point = d.decimal_point + (Math.imul(exp_sign, exp) | 0) | 0;
              rest$3 = rest$6;
            } else {
              break _L$5;
            }
          } else {
            break _L$5;
          }
          break _L$4;
        }
        const _bind = _M0FPC28internal7strconv11syntax__errGRPC28internal7strconv7DecimalE();
        if (_bind.$tag === 1) {
          const _ok = _bind;
          rest$3 = _ok._0;
        } else {
          return _bind;
        }
      }
    }
    if ((rest$3.end - rest$3.start | 0) === 0) {
      _M0MPC28internal7strconv7Decimal4trim(d);
      return new _M0DTPC16result6ResultGRPC28internal7strconv7DecimalRPC15error5ErrorE2Ok(d);
    } else {
      return _M0FPC28internal7strconv11syntax__errGRPC28internal7strconv7DecimalE();
    }
  } else {
    return _M0FPC28internal7strconv11syntax__errGRPC28internal7strconv7DecimalE();
  }
}
function _M0FPC28internal7strconv20parse__decimal__priv(str) {
  return _M0FPC28internal7strconv26parse__decimal__from__view(str);
}
function _M0FPC28internal7strconv14assemble__bits(mantissa, exponent, negative) {
  const biased_exp = exponent - _M0FPC28internal7strconv12double__info.bias | 0;
  let bits = BigInt.asUintN(64, mantissa & BigInt.asUintN(64, BigInt.asUintN(64, 1n << BigInt(_M0FPC28internal7strconv12double__info.mantissa_bits & 63)) - 1n));
  const exp_bits = BigInt.asUintN(64, BigInt(biased_exp & ((1 << _M0FPC28internal7strconv12double__info.exponent_bits) - 1 | 0)));
  bits = BigInt.asUintN(64, bits | BigInt.asUintN(64, exp_bits << BigInt(_M0FPC28internal7strconv12double__info.mantissa_bits & 63)));
  if (negative) {
    bits = BigInt.asUintN(64, bits | BigInt.asUintN(64, BigInt.asUintN(64, 1n << BigInt(_M0FPC28internal7strconv12double__info.mantissa_bits & 63)) << BigInt(_M0FPC28internal7strconv12double__info.exponent_bits & 63)));
  }
  return bits;
}
function _M0MPC28internal7strconv7Decimal17should__round__up(self, d) {
  if (d < 0 || d >= self.digits_num) {
    return false;
  }
  let _tmp;
  const _tmp$2 = self.digits;
  if ((d >>> 0 < _tmp$2.length ? _tmp$2[d] : $oob()) === 5) {
    _tmp = (d + 1 | 0) === self.digits_num;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    if (self.truncated) {
      return true;
    }
    let _tmp$3;
    if (d > 0) {
      const _tmp$4 = self.digits;
      const _tmp$5 = d - 1 | 0;
      _tmp$3 = ((_tmp$5 >>> 0 < _tmp$4.length ? _tmp$4[_tmp$5] : $oob()) % 2 | 0) !== 0;
    } else {
      _tmp$3 = false;
    }
    return _tmp$3;
  }
  const _tmp$3 = self.digits;
  return (d >>> 0 < _tmp$3.length ? _tmp$3[d] : $oob()) >= 5;
}
function _M0MPC28internal7strconv7Decimal16rounded__integer(self) {
  if (self.decimal_point > 20) {
    return 18446744073709551615n;
  }
  let _tmp = 0n;
  let _tmp$2 = 0;
  while (true) {
    const n = _tmp;
    const i = _tmp$2;
    if (i < self.decimal_point && i < self.digits_num) {
      const _tmp$3 = BigInt.asUintN(64, n * 10n);
      const _tmp$4 = self.digits;
      const _p = i >>> 0 < _tmp$4.length ? _tmp$4[i] : $oob();
      _tmp = BigInt.asUintN(64, _tmp$3 + BigInt.asUintN(64, BigInt(_p)));
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      let n$2;
      let _tmp$3 = n;
      let _tmp$4 = i;
      while (true) {
        const n$3 = _tmp$3;
        const i$2 = _tmp$4;
        if (i$2 < self.decimal_point) {
          _tmp$3 = BigInt.asUintN(64, n$3 * 10n);
          _tmp$4 = i$2 + 1 | 0;
          continue;
        } else {
          n$2 = n$3;
          break;
        }
      }
      return _M0MPC28internal7strconv7Decimal17should__round__up(self, self.decimal_point) ? BigInt.asUintN(64, n$2 + 1n) : n$2;
    }
  }
}
function _M0MPC28internal7strconv7Decimal11new__digits(self, s) {
  const new_digits = (s >>> 0 < _M0FPC28internal7strconv19left__shift__cheats.length ? _M0FPC28internal7strconv19left__shift__cheats[s] : $oob())._0;
  const cheat_num = (s >>> 0 < _M0FPC28internal7strconv19left__shift__cheats.length ? _M0FPC28internal7strconv19left__shift__cheats[s] : $oob())._1;
  const _bind = cheat_num.length;
  let less;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const code_unit = cheat_num.charCodeAt(i);
      if (i >= self.digits_num) {
        less = true;
        break;
      }
      const d = code_unit - 48 | 0;
      const _tmp$2 = self.digits;
      if ((i >>> 0 < _tmp$2.length ? _tmp$2[i] : $oob()) !== d) {
        const _tmp$3 = self.digits;
        less = (i >>> 0 < _tmp$3.length ? _tmp$3[i] : $oob()) < d;
        break;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      less = false;
      break;
    }
  }
  return less ? new_digits - 1 | 0 : new_digits;
}
function _M0MPC28internal7strconv7Decimal11left__shift(self, s) {
  const new_digits = _M0MPC28internal7strconv7Decimal11new__digits(self, s);
  let read_index = self.digits_num - 1 | 0;
  let write_index = self.digits_num + new_digits | 0;
  let acc = 0n;
  while (true) {
    if (read_index >= 0) {
      const _tmp = self.digits;
      const _tmp$2 = read_index;
      const _p = _tmp$2 >>> 0 < _tmp.length ? _tmp[_tmp$2] : $oob();
      const d = BigInt.asUintN(64, BigInt(_p));
      acc = BigInt.asUintN(64, acc + BigInt.asUintN(64, d << BigInt(s & 63)));
      if (10n === 0n) {
        $panic();
      }
      const quo = BigInt.asUintN(64, BigInt.asIntN(64, acc) / BigInt.asIntN(64, 10n));
      const rem = Number(BigInt.asIntN(32, BigInt.asUintN(64, acc - BigInt.asUintN(64, quo * 10n)))) | 0;
      write_index = write_index - 1 | 0;
      if (write_index < self.digits.length) {
        const _tmp$3 = self.digits;
        const _tmp$4 = write_index;
        if (_tmp$4 >>> 0 < _tmp$3.length) {
          _tmp$3[_tmp$4] = rem & 255;
        } else {
          $oob();
        }
      } else {
        if (rem !== 0) {
          self.truncated = true;
        }
      }
      acc = quo;
      read_index = read_index - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    if (BigInt.asIntN(64, acc) > BigInt.asIntN(64, 0n)) {
      if (10n === 0n) {
        $panic();
      }
      const quo = BigInt.asUintN(64, BigInt.asIntN(64, acc) / BigInt.asIntN(64, 10n));
      const rem = Number(BigInt.asIntN(32, BigInt.asUintN(64, acc - BigInt.asUintN(64, 10n * quo)))) | 0;
      write_index = write_index - 1 | 0;
      if (write_index < self.digits.length) {
        const _tmp = self.digits;
        const _tmp$2 = write_index;
        if (_tmp$2 >>> 0 < _tmp.length) {
          _tmp[_tmp$2] = rem & 255;
        } else {
          $oob();
        }
      } else {
        if (rem !== 0) {
          self.truncated = true;
        }
      }
      acc = quo;
      continue;
    } else {
      break;
    }
  }
  self.digits_num = self.digits_num + new_digits | 0;
  if (self.digits_num > self.digits.length) {
    self.digits_num = self.digits.length;
  }
  self.decimal_point = self.decimal_point + new_digits | 0;
  _M0MPC28internal7strconv7Decimal4trim(self);
}
function _M0MPC28internal7strconv7Decimal12right__shift(self, s) {
  let read_index = 0;
  let write_index = 0;
  let acc = 0n;
  while (true) {
    if (BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, acc) >> BigInt(s & 63))) === BigInt.asUintN(64, 0n)) {
      if (read_index >= self.digits_num) {
        while (true) {
          if (BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, acc) >> BigInt(s & 63))) === BigInt.asUintN(64, 0n)) {
            acc = BigInt.asUintN(64, acc * 10n);
            read_index = read_index + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        break;
      }
      const _tmp = self.digits;
      const _tmp$2 = read_index;
      const d = _tmp$2 >>> 0 < _tmp.length ? _tmp[_tmp$2] : $oob();
      acc = BigInt.asUintN(64, BigInt.asUintN(64, acc * 10n) + BigInt.asUintN(64, BigInt(d)));
      read_index = read_index + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  self.decimal_point = self.decimal_point - (read_index - 1 | 0) | 0;
  const mask = BigInt.asUintN(64, BigInt.asUintN(64, 1n << BigInt(s & 63)) - 1n);
  while (true) {
    if (read_index < self.digits_num) {
      const out = BigInt.asUintN(64, BigInt.asUintN(64, acc) >> BigInt(s & 63));
      const _tmp = self.digits;
      const _tmp$2 = write_index;
      if (_tmp$2 >>> 0 < _tmp.length) {
        _tmp[_tmp$2] = (Number(BigInt.asIntN(32, out)) | 0) & 255;
      } else {
        $oob();
      }
      write_index = write_index + 1 | 0;
      acc = BigInt.asUintN(64, acc & mask);
      const _tmp$3 = self.digits;
      const _tmp$4 = read_index;
      const d = _tmp$4 >>> 0 < _tmp$3.length ? _tmp$3[_tmp$4] : $oob();
      acc = BigInt.asUintN(64, BigInt.asUintN(64, acc * 10n) + BigInt.asUintN(64, BigInt(d)));
      read_index = read_index + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    if (BigInt.asUintN(64, acc) > BigInt.asUintN(64, 0n)) {
      const out = BigInt.asUintN(64, BigInt.asUintN(64, acc) >> BigInt(s & 63));
      if (write_index < self.digits.length) {
        const _tmp = self.digits;
        const _tmp$2 = write_index;
        if (_tmp$2 >>> 0 < _tmp.length) {
          _tmp[_tmp$2] = (Number(BigInt.asIntN(32, out)) | 0) & 255;
        } else {
          $oob();
        }
        write_index = write_index + 1 | 0;
      } else {
        if (BigInt.asUintN(64, out) > BigInt.asUintN(64, 0n)) {
          self.truncated = true;
        }
      }
      acc = BigInt.asUintN(64, acc & mask);
      acc = BigInt.asUintN(64, acc * 10n);
      continue;
    } else {
      break;
    }
  }
  self.digits_num = write_index;
  _M0MPC28internal7strconv7Decimal4trim(self);
}
function _M0MPC28internal7strconv7Decimal11shift__priv(self, s) {
  if (self.digits_num === 0) {
    return undefined;
  }
  let s$2 = s;
  if (s$2 > 0) {
    while (true) {
      if (s$2 > 59) {
        _M0MPC28internal7strconv7Decimal11left__shift(self, 59);
        s$2 = s$2 - 59 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0MPC28internal7strconv7Decimal11left__shift(self, s$2);
  }
  if (s$2 < 0) {
    while (true) {
      if (s$2 < -59) {
        _M0MPC28internal7strconv7Decimal12right__shift(self, 59);
        s$2 = s$2 + 59 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0MPC28internal7strconv7Decimal12right__shift(self, -s$2 | 0);
    return;
  } else {
    return;
  }
}
function _M0MPC28internal7strconv7Decimal16to__double__priv(self) {
  let exponent = 0;
  let mantissa = 0n;
  const effective_dp = self.decimal_point + self.overflowed | 0;
  if (self.digits_num === 0 || effective_dp < -330) {
    mantissa = 0n;
    exponent = _M0FPC28internal7strconv12double__info.bias;
    const bits = _M0FPC28internal7strconv14assemble__bits(mantissa, exponent, self.negative);
    return new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok($i64_reinterpret_f64(bits));
  }
  if (self.decimal_point > 310) {
    const _bind = _M0FPC28internal7strconv10range__errGuE();
    if (_bind.$tag === 1) {
      const _ok = _bind;
      _ok._0;
    } else {
      return _bind;
    }
  }
  self.decimal_point = self.decimal_point + self.overflowed | 0;
  while (true) {
    if (self.decimal_point > 0) {
      let n;
      if (self.decimal_point >= _M0FPC28internal7strconv6powtab.length) {
        n = 60;
      } else {
        const _p = self.decimal_point;
        n = _p >>> 0 < _M0FPC28internal7strconv6powtab.length ? _M0FPC28internal7strconv6powtab[_p] : $oob();
      }
      _M0MPC28internal7strconv7Decimal11shift__priv(self, -n | 0);
      exponent = exponent + n | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    let _tmp;
    if (self.decimal_point < 0) {
      _tmp = true;
    } else {
      let _tmp$2;
      if (self.decimal_point === 0) {
        const _tmp$3 = self.digits;
        _tmp$2 = (0 >>> 0 < _tmp$3.length ? _tmp$3[0] : $oob()) < 5;
      } else {
        _tmp$2 = false;
      }
      _tmp = _tmp$2;
    }
    if (_tmp) {
      let n;
      if ((-self.decimal_point | 0) >= _M0FPC28internal7strconv6powtab.length) {
        n = 60;
      } else {
        const _p = -self.decimal_point | 0;
        n = _p >>> 0 < _M0FPC28internal7strconv6powtab.length ? _M0FPC28internal7strconv6powtab[_p] : $oob();
      }
      _M0MPC28internal7strconv7Decimal11shift__priv(self, n);
      exponent = exponent - n | 0;
      continue;
    } else {
      break;
    }
  }
  exponent = exponent - 1 | 0;
  if (exponent < (_M0FPC28internal7strconv12double__info.bias + 1 | 0)) {
    const n = (_M0FPC28internal7strconv12double__info.bias + 1 | 0) - exponent | 0;
    _M0MPC28internal7strconv7Decimal11shift__priv(self, -n | 0);
    exponent = exponent + n | 0;
  }
  if ((exponent - _M0FPC28internal7strconv12double__info.bias | 0) >= ((1 << _M0FPC28internal7strconv12double__info.exponent_bits) - 1 | 0)) {
    const _bind = _M0FPC28internal7strconv10range__errGuE();
    if (_bind.$tag === 1) {
      const _ok = _bind;
      _ok._0;
    } else {
      return _bind;
    }
  }
  _M0MPC28internal7strconv7Decimal11shift__priv(self, _M0FPC28internal7strconv12double__info.mantissa_bits + 1 | 0);
  mantissa = _M0MPC28internal7strconv7Decimal16rounded__integer(self);
  if (BigInt.asUintN(64, mantissa) === BigInt.asUintN(64, BigInt.asUintN(64, 2n << BigInt(_M0FPC28internal7strconv12double__info.mantissa_bits & 63)))) {
    mantissa = BigInt.asUintN(64, BigInt.asIntN(64, mantissa) >> BigInt(1 & 63));
    exponent = exponent + 1 | 0;
    if ((exponent - _M0FPC28internal7strconv12double__info.bias | 0) >= ((1 << _M0FPC28internal7strconv12double__info.exponent_bits) - 1 | 0)) {
      const _bind = _M0FPC28internal7strconv10range__errGuE();
      if (_bind.$tag === 1) {
        const _ok = _bind;
        _ok._0;
      } else {
        return _bind;
      }
    }
  }
  if (BigInt.asUintN(64, BigInt.asUintN(64, mantissa & BigInt.asUintN(64, 1n << BigInt(_M0FPC28internal7strconv12double__info.mantissa_bits & 63)))) === BigInt.asUintN(64, 0n)) {
    exponent = _M0FPC28internal7strconv12double__info.bias;
  }
  const bits = _M0FPC28internal7strconv14assemble__bits(mantissa, exponent, self.negative);
  return new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok($i64_reinterpret_f64(bits));
}
function _M0FPC28internal7strconv17pow10__fast__path(exponent) {
  const _p = exponent & 31;
  return _p >>> 0 < _M0FPC28internal7strconv5table.length ? _M0FPC28internal7strconv5table[_p] : $oob();
}
function _M0MPC28internal7strconv6Number14is__fast__path(self) {
  return BigInt.asIntN(64, _M0FPC28internal7strconv25min__exponent__fast__path) <= BigInt.asIntN(64, self.exponent) && (BigInt.asIntN(64, self.exponent) <= BigInt.asIntN(64, _M0FPC28internal7strconv36max__exponent__disguised__fast__path) && (BigInt.asUintN(64, self.mantissa) <= BigInt.asUintN(64, _M0FPC28internal7strconv25max__mantissa__fast__path) && !self.many_digits));
}
function _M0MPC28internal7strconv6Number15try__fast__path(self) {
  if (_M0MPC28internal7strconv6Number14is__fast__path(self)) {
    let value;
    if (BigInt.asIntN(64, self.exponent) <= BigInt.asIntN(64, _M0FPC28internal7strconv25max__exponent__fast__path)) {
      const value$2 = $f64_convert_i64_u(BigInt.asUintN(64, self.mantissa));
      value = BigInt.asIntN(64, self.exponent) < BigInt.asIntN(64, 0n) ? value$2 / _M0FPC28internal7strconv17pow10__fast__path(-(Number(BigInt.asIntN(32, self.exponent)) | 0) | 0) : value$2 * _M0FPC28internal7strconv17pow10__fast__path(Number(BigInt.asIntN(32, self.exponent)) | 0);
    } else {
      const shift = BigInt.asUintN(64, self.exponent - _M0FPC28internal7strconv25max__exponent__fast__path);
      const _tmp = self.mantissa;
      const _p = Number(BigInt.asIntN(32, shift)) | 0;
      const _bind = _M0FPC28internal7strconv12checked__mul(_tmp, _p >>> 0 < _M0FPC28internal7strconv10int__pow10.length ? _M0FPC28internal7strconv10int__pow10[_p] : $oob());
      if (_bind === undefined) {
        return _M0DTPC16option6OptionGdE4None__;
      } else {
        const _Some = _bind;
        const _mantissa = _Some;
        if (BigInt.asUintN(64, _mantissa) > BigInt.asUintN(64, _M0FPC28internal7strconv25max__mantissa__fast__path)) {
          return _M0DTPC16option6OptionGdE4None__;
        }
        value = $f64_convert_i64_u(BigInt.asUintN(64, _mantissa)) * _M0FPC28internal7strconv17pow10__fast__path(Number(BigInt.asIntN(32, _M0FPC28internal7strconv25max__exponent__fast__path)) | 0);
      }
    }
    return new _M0DTPC16option6OptionGdE4Some(self.negative ? -value : value);
  } else {
    return _M0DTPC16option6OptionGdE4None__;
  }
}
function _M0FPC28internal7strconv13parse__double(str) {
  if (!((str.end - str.start | 0) === 0)) {
    if (_M0FPC28internal7strconv17check__underscore(str)) {
      const _bind = _M0FPC28internal7strconv13parse__number(str);
      let _bind$2;
      if (_bind.$tag === 1) {
        const _ok = _bind;
        _bind$2 = _ok._0;
      } else {
        return _bind;
      }
      if (_bind$2 === undefined) {
        return _M0FPC28internal7strconv15parse__inf__nan(str);
      } else {
        const _Some = _bind$2;
        const _num = _Some;
        const _bind$3 = _M0MPC28internal7strconv6Number15try__fast__path(_num);
        if (_bind$3.$tag === 1) {
          const _Some$2 = _bind$3;
          const _value = _Some$2._0;
          return new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok(_value);
        } else {
          const fast = _num.many_digits ? _M0FPC16double14not__a__number : _M0FPC28internal7strconv20try__eisel__lemire64(_num.mantissa, _num.exponent, _num.negative);
          if (fast !== fast) {
            const _bind$4 = _M0FPC28internal7strconv20parse__decimal__priv(str);
            let _tmp;
            if (_bind$4.$tag === 1) {
              const _ok = _bind$4;
              _tmp = _ok._0;
            } else {
              return _bind$4;
            }
            return _M0MPC28internal7strconv7Decimal16to__double__priv(_tmp);
          } else {
            return new _M0DTPC16result6ResultGdRPC15error5ErrorE2Ok(fast);
          }
        }
      }
    } else {
      return _M0FPC28internal7strconv11syntax__errGdE();
    }
  } else {
    return _M0FPC28internal7strconv11syntax__errGdE();
  }
}
function _M0FPC14json20offset__to__position(input, offset) {
  const _bind = _M0MPC15array9ArrayView21clamped__view_2einnerGkE(_M0MPC16string10StringView11code__units(input), 0, offset);
  const _bind$2 = _bind.end - _bind.start | 0;
  let _tmp = 0;
  let _tmp$2 = 1;
  let _tmp$3 = 0;
  while (true) {
    const _ = _tmp;
    const line = _tmp$2;
    const column = _tmp$3;
    if (_ < _bind$2) {
      const code_unit = _bind.buf[_bind.start + _ | 0];
      if (code_unit === 10) {
        _tmp = _ + 1 | 0;
        _tmp$2 = line + 1 | 0;
        _tmp$3 = 0;
        continue;
      } else {
        _tmp = _ + 1 | 0;
        _tmp$3 = column + 1 | 0;
        continue;
      }
    } else {
      return new _M0TPC14json8Position(line, column);
    }
  }
}
function _M0MPC14json12ParseContext21invalid__char_2einnerGiE(ctx, shift) {
  const offset = ctx.offset + shift | 0;
  return new _M0DTPC16result6ResultGiRPC14json10ParseErrorE3Err(new _M0DTPC15error5Error52moonbitlang_2fcore_2fjson_2eParseError_2eInvalidChar(_M0FPC14json20offset__to__position(ctx.input, offset), _M0MPC16option6Option10unwrap__orGcE(_M0MPC16string10StringView9get__char(ctx.input, offset), 65533)));
}
function _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, shift) {
  const offset = ctx.offset + shift | 0;
  return new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE3Err(new _M0DTPC15error5Error52moonbitlang_2fcore_2fjson_2eParseError_2eInvalidChar(_M0FPC14json20offset__to__position(ctx.input, offset), _M0MPC16option6Option10unwrap__orGcE(_M0MPC16string10StringView9get__char(ctx.input, offset), 65533)));
}
function _M0MPC14json12ParseContext21invalid__char_2einnerGuE(ctx, shift) {
  const offset = ctx.offset + shift | 0;
  return new _M0DTPC16result6ResultGuRPC14json10ParseErrorE3Err(new _M0DTPC15error5Error52moonbitlang_2fcore_2fjson_2eParseError_2eInvalidChar(_M0FPC14json20offset__to__position(ctx.input, offset), _M0MPC16option6Option10unwrap__orGcE(_M0MPC16string10StringView9get__char(ctx.input, offset), 65533)));
}
function _M0MPC14json12ParseContext21lex__skip__whitespace(ctx) {
  const end = ctx.end_offset;
  let _tmp;
  let _tmp$2 = ctx.offset;
  _L: while (true) {
    const offset = _tmp$2;
    if (offset >= end) {
      _tmp = offset;
      break;
    }
    _L$2: {
      const _bind = ctx.input;
      const _bind$2 = _bind.str.charCodeAt(_bind.start + offset | 0);
      switch (_bind$2) {
        case 32: {
          break _L$2;
        }
        case 9: {
          break _L$2;
        }
        case 13: {
          break _L$2;
        }
        case 10: {
          break _L$2;
        }
        default: {
          _tmp = offset;
          break _L;
        }
      }
    }
    _tmp$2 = offset + 1 | 0;
    continue;
  }
  ctx.offset = _tmp;
}
function _M0MPC14json12ParseContext12make_2einner(input, reject_duplicate_keys, preserve_number_repr) {
  return new _M0TPC14json12ParseContext(0, input, input.end - input.start | 0, reject_duplicate_keys, preserve_number_repr);
}
function _M0MPC14json12ParseContext19expect__ascii__char(ctx, c) {
  if (ctx.offset < ctx.end_offset) {
    const _bind = ctx.input;
    const c1 = _bind.str.charCodeAt(_bind.start + ctx.offset | 0);
    ctx.offset = ctx.offset + 1 | 0;
    return c !== c1 ? _M0MPC14json12ParseContext21invalid__char_2einnerGuE(ctx, -1) : new _M0DTPC16result6ResultGuRPC14json10ParseErrorE2Ok(undefined);
  } else {
    return new _M0DTPC16result6ResultGuRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
  }
}
function _M0FPC14json12checked__mul(a, b) {
  if (BigInt.asUintN(64, a) === BigInt.asUintN(64, 0n) || BigInt.asUintN(64, b) === BigInt.asUintN(64, 0n)) {
    return _M0FPC14json12checked__mulN6constrS2449;
  }
  if (BigInt.asUintN(64, a) === BigInt.asUintN(64, 1n)) {
    return b;
  }
  if (BigInt.asUintN(64, b) === BigInt.asUintN(64, 1n)) {
    return a;
  }
  if ($i64_clz(b) === 0 || $i64_clz(a) === 0) {
    return undefined;
  }
  if (b === 0n) {
    $panic();
  }
  const quotient = BigInt.asUintN(64, BigInt.asUintN(64, 18446744073709551615n) / BigInt.asUintN(64, b));
  return BigInt.asUintN(64, a) > BigInt.asUintN(64, quotient) ? undefined : BigInt.asUintN(64, a * b);
}
function _M0FPC14json23json__pow10__fast__path(exponent) {
  const _p = exponent & 31;
  return _p >>> 0 < _M0FPC14json12pow10__table.length ? _M0FPC14json12pow10__table[_p] : $oob();
}
function _M0MPC14json14JsonNumberScan17try__fast__double(self) {
  if (BigInt.asUintN(64, self.mantissa) === BigInt.asUintN(64, 0n)) {
    return self.negative ? -0 : 0;
  }
  if (self.many_digits || (BigInt.asIntN(64, self.exponent) < BigInt.asIntN(64, 18446744073709551594n) || (BigInt.asIntN(64, self.exponent) > BigInt.asIntN(64, 37n) || BigInt.asUintN(64, self.mantissa) > BigInt.asUintN(64, 9007199254740992n)))) {
    return _M0FPC16double14not__a__number;
  }
  let value;
  if (BigInt.asIntN(64, self.exponent) <= BigInt.asIntN(64, 22n)) {
    const value$2 = $f64_convert_i64_u(BigInt.asUintN(64, self.mantissa));
    value = BigInt.asIntN(64, self.exponent) < BigInt.asIntN(64, 0n) ? value$2 / _M0FPC14json23json__pow10__fast__path(-(Number(BigInt.asIntN(32, self.exponent)) | 0) | 0) : value$2 * _M0FPC14json23json__pow10__fast__path(Number(BigInt.asIntN(32, self.exponent)) | 0);
  } else {
    const shift = BigInt.asUintN(64, self.exponent - 22n);
    const _tmp = self.mantissa;
    const _p = Number(BigInt.asIntN(32, shift)) | 0;
    const _bind = _M0FPC14json12checked__mul(_tmp, _p >>> 0 < _M0FPC14json17int__pow10__table.length ? _M0FPC14json17int__pow10__table[_p] : $oob());
    if (_bind === undefined) {
      return _M0FPC16double14not__a__number;
    } else {
      const _Some = _bind;
      const _mantissa = _Some;
      if (BigInt.asUintN(64, _mantissa) > BigInt.asUintN(64, 9007199254740992n)) {
        return _M0FPC16double14not__a__number;
      }
      value = $f64_convert_i64_u(BigInt.asUintN(64, _mantissa)) * _M0FPC14json23json__pow10__fast__path(22);
    }
  }
  return self.negative ? -value : value;
}
function _M0MPC14json12ParseContext17lex__integer__end(ctx, start, end) {
  const _bind = ctx.input;
  const negative = _bind.str.charCodeAt(_bind.start + start | 0) === 45;
  const number_start = negative ? start + 1 | 0 : start;
  let _tmp = number_start;
  let _tmp$2 = 0n;
  while (true) {
    const i = _tmp;
    const acc = _tmp$2;
    if (i >= end) {
      const value = negative ? BigInt.asUintN(64, -acc) : acc;
      const _bind$2 = $f64_convert_i64(BigInt.asIntN(64, value));
      const _bind$3 = undefined;
      return new _M0TPC14json11LexedNumber(_bind$3, _bind$2);
    }
    const _bind$2 = ctx.input;
    const digit = BigInt.asUintN(64, BigInt(_bind$2.str.charCodeAt(_bind$2.start + i | 0) - 48 | 0));
    if (10n === 0n) {
      $panic();
    }
    if (BigInt.asIntN(64, acc) > BigInt.asIntN(64, BigInt.asUintN(64, BigInt.asIntN(64, BigInt.asUintN(64, 9007199254740991n - digit)) / BigInt.asIntN(64, 10n)))) {
      const s = _M0MPC16string10StringView12view_2einner(ctx.input, start, end);
      let _try_err;
      _L: {
        const _bind$3 = _M0FPC28internal7strconv13parse__double(s);
        let value;
        if (_bind$3.$tag === 1) {
          const _ok = _bind$3;
          value = _ok._0;
        } else {
          const _err = _bind$3;
          _try_err = _err._0;
          break _L;
        }
        const _bind$4 = s;
        return new _M0TPC14json11LexedNumber(_bind$4, value);
      }
      let _tmp$3;
      if (negative) {
        const _bind$3 = s;
        _tmp$3 = new _M0TPC14json11LexedNumber(_bind$3, _M0FPC16double13neg__infinity);
      } else {
        const _bind$3 = s;
        _tmp$3 = new _M0TPC14json11LexedNumber(_bind$3, _M0FPC16double8infinity);
      }
      return _tmp$3;
    }
    _tmp = i + 1 | 0;
    _tmp$2 = BigInt.asUintN(64, BigInt.asUintN(64, acc * 10n) + digit);
    continue;
  }
}
function _M0MPC14json12ParseContext18scan__json__number(ctx, start, end) {
  const _bind = ctx.input;
  const negative = _bind.str.charCodeAt(_bind.start + start | 0) === 45;
  let has_decimal = false;
  let has_exponent = false;
  let exponent_negative = false;
  let exponent_part = 0n;
  let fractional_digits = 0;
  let mantissa = 0n;
  let significant_digits = 0;
  let seen_nonzero = false;
  const _bind$2 = negative ? start + 1 | 0 : start;
  let _tmp = _bind$2;
  while (true) {
    const i = _tmp;
    if (i < end) {
      _L: {
        _L$2: {
          const _bind$3 = ctx.input;
          const _bind$4 = _bind$3.str.charCodeAt(_bind$3.start + i | 0);
          if (_bind$4 >= 48 && _bind$4 <= 57) {
            const digit = _bind$4 - 48 | 0;
            if (has_exponent) {
              if (BigInt.asIntN(64, exponent_part) < BigInt.asIntN(64, 100000n)) {
                const next_exponent = BigInt.asUintN(64, BigInt.asUintN(64, exponent_part * 10n) + BigInt.asUintN(64, BigInt(digit)));
                exponent_part = BigInt.asIntN(64, next_exponent) > BigInt.asIntN(64, 100000n) ? 100000n : next_exponent;
              }
            } else {
              if (has_decimal) {
                fractional_digits = fractional_digits + 1 | 0;
              }
              if (digit !== 0 || seen_nonzero) {
                seen_nonzero = true;
                significant_digits = significant_digits + 1 | 0;
                if (significant_digits <= 19) {
                  mantissa = BigInt.asUintN(64, BigInt.asUintN(64, mantissa * 10n) + BigInt.asUintN(64, BigInt(digit >>> 0)));
                }
              }
            }
          } else {
            if (_bind$4 === 46) {
              has_decimal = true;
            } else {
              if (_bind$4 === 101) {
                break _L$2;
              } else {
                if (_bind$4 === 69) {
                  break _L$2;
                }
              }
            }
          }
          break _L;
        }
        has_exponent = true;
        if ((i + 1 | 0) < end) {
          const _bind$3 = ctx.input;
          const next = _bind$3.str.charCodeAt(_bind$3.start + (i + 1 | 0) | 0);
          if (next === 45) {
            exponent_negative = true;
          }
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const exponent_part$2 = exponent_negative ? BigInt.asUintN(64, -exponent_part) : exponent_part;
  return new _M0TPC14json14JsonNumberScan(negative, !has_decimal && !has_exponent, mantissa, BigInt.asUintN(64, exponent_part$2 - BigInt.asUintN(64, BigInt(fractional_digits))), significant_digits > 19);
}
function _M0MPC14json12ParseContext18lex__number__value(ctx, start, end) {
  const scan = _M0MPC14json12ParseContext18scan__json__number(ctx, start, end);
  if (scan.is_integer) {
    if (!scan.many_digits && (BigInt.asUintN(64, scan.exponent) === BigInt.asUintN(64, 0n) && BigInt.asUintN(64, scan.mantissa) <= BigInt.asUintN(64, 9007199254740991n))) {
      const v = $f64_convert_i64(BigInt.asIntN(64, scan.mantissa));
      const value = scan.negative ? -v : v;
      const _bind = undefined;
      return new _M0TPC14json11LexedNumber(_bind, value);
    }
    return _M0MPC14json12ParseContext17lex__integer__end(ctx, start, end);
  }
  const fast = _M0MPC14json14JsonNumberScan17try__fast__double(scan);
  if (!(fast !== fast)) {
    const _bind = undefined;
    return new _M0TPC14json11LexedNumber(_bind, fast);
  }
  if (!scan.many_digits) {
    const fast$2 = _M0FPC28internal7strconv20try__eisel__lemire64(scan.mantissa, scan.exponent, scan.negative);
    if (!(fast$2 !== fast$2)) {
      const _bind = undefined;
      return new _M0TPC14json11LexedNumber(_bind, fast$2);
    }
  }
  const s = _M0MPC16string10StringView12view_2einner(ctx.input, start, end);
  let _try_err;
  _L: {
    const _bind = _M0FPC28internal7strconv13parse__double(s);
    let d;
    if (_bind.$tag === 1) {
      const _ok = _bind;
      d = _ok._0;
    } else {
      const _err = _bind;
      _try_err = _err._0;
      break _L;
    }
    const _bind$2 = undefined;
    return new _M0TPC14json11LexedNumber(_bind$2, d);
  }
  if (scan.negative) {
    const _bind = s;
    return new _M0TPC14json11LexedNumber(_bind, _M0FPC16double13neg__infinity);
  } else {
    const _bind = s;
    return new _M0TPC14json11LexedNumber(_bind, _M0FPC16double8infinity);
  }
}
function _M0MPC14json12ParseContext16lex__number__end(ctx, start, end) {
  const number = _M0MPC14json12ParseContext18lex__number__value(ctx, start, end);
  if (ctx.preserve_number_repr) {
    const _bind = number.value;
    const _bind$2 = _M0MPC16string10StringView12view_2einner(ctx.input, start, end);
    return new _M0TPC14json11LexedNumber(_bind$2, _bind);
  } else {
    return number;
  }
}
function _M0MPC14json12ParseContext10read__char(ctx) {
  if (ctx.offset < ctx.end_offset) {
    const _bind = ctx.input;
    const c1 = _bind.str.charCodeAt(_bind.start + ctx.offset | 0);
    ctx.offset = ctx.offset + 1 | 0;
    if (c1 >= 55296 && c1 <= 56319) {
      if (ctx.offset < ctx.end_offset) {
        const _bind$2 = ctx.input;
        const c2 = _bind$2.str.charCodeAt(_bind$2.start + ctx.offset | 0);
        if (c2 >= 56320 && c2 <= 57343) {
          ctx.offset = ctx.offset + 1 | 0;
          const c3 = ((c1 << 10) + c2 | 0) - 56613888 | 0;
          return c3;
        }
      }
    }
    return c1;
  } else {
    return -1;
  }
}
function _M0MPC14json12ParseContext31lex__decimal__exponent__integer(ctx, start) {
  while (true) {
    const _bind = _M0MPC14json12ParseContext10read__char(ctx);
    if (_bind === -1) {
      return _M0MPC14json12ParseContext16lex__number__end(ctx, start, ctx.offset);
    } else {
      const _Some = _bind;
      const _x = _Some;
      if (_x >= 48 && _x <= 57) {
        continue;
      } else {
        const _tmp = ctx.offset;
        const _p = _x;
        ctx.offset = _tmp - (_p <= 65535 ? 1 : 2) | 0;
        return _M0MPC14json12ParseContext16lex__number__end(ctx, start, ctx.offset);
      }
    }
  }
}
function _M0MPC14json12ParseContext28lex__decimal__exponent__sign(ctx, start) {
  const _bind = _M0MPC14json12ParseContext10read__char(ctx);
  if (_bind === -1) {
    return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
  } else {
    const _Some = _bind;
    const _x = _Some;
    if (_x >= 48 && _x <= 57) {
      return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(_M0MPC14json12ParseContext31lex__decimal__exponent__integer(ctx, start));
    } else {
      const _p = _x;
      return _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, -(_p <= 65535 ? 1 : 2) | 0);
    }
  }
}
function _M0MPC14json12ParseContext22lex__decimal__exponent(ctx, start) {
  _L: {
    const _bind = _M0MPC14json12ParseContext10read__char(ctx);
    if (_bind === -1) {
      return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
    } else {
      const _Some = _bind;
      const _x = _Some;
      if (_x === 43) {
        break _L;
      } else {
        if (_x === 45) {
          break _L;
        } else {
          if (_x >= 48 && _x <= 57) {
            return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(_M0MPC14json12ParseContext31lex__decimal__exponent__integer(ctx, start));
          } else {
            const _p = _x;
            return _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, -(_p <= 65535 ? 1 : 2) | 0);
          }
        }
      }
    }
  }
  const _bind = _M0MPC14json12ParseContext28lex__decimal__exponent__sign(ctx, start);
  let _tmp;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _tmp = _ok._0;
  } else {
    return _bind;
  }
  return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(_tmp);
}
function _M0MPC14json12ParseContext22lex__decimal__fraction(ctx, start) {
  while (true) {
    _L: {
      const _bind = _M0MPC14json12ParseContext10read__char(ctx);
      if (_bind === -1) {
        return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(_M0MPC14json12ParseContext16lex__number__end(ctx, start, ctx.offset));
      } else {
        const _Some = _bind;
        const _x = _Some;
        if (_x === 101) {
          break _L;
        } else {
          if (_x === 69) {
            break _L;
          } else {
            if (_x >= 48 && _x <= 57) {
              continue;
            } else {
              const _tmp = ctx.offset;
              const _p = _x;
              ctx.offset = _tmp - (_p <= 65535 ? 1 : 2) | 0;
              return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(_M0MPC14json12ParseContext16lex__number__end(ctx, start, ctx.offset));
            }
          }
        }
      }
    }
    const _bind = _M0MPC14json12ParseContext22lex__decimal__exponent(ctx, start);
    let _tmp;
    if (_bind.$tag === 1) {
      const _ok = _bind;
      _tmp = _ok._0;
    } else {
      return _bind;
    }
    return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(_tmp);
  }
}
function _M0MPC14json12ParseContext19lex__decimal__point(ctx, start) {
  const _bind = _M0MPC14json12ParseContext10read__char(ctx);
  if (_bind === -1) {
    return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
  } else {
    const _Some = _bind;
    const _x = _Some;
    if (_x >= 48 && _x <= 57) {
      return _M0MPC14json12ParseContext22lex__decimal__fraction(ctx, start);
    } else {
      const _p = _x;
      return _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, -(_p <= 65535 ? 1 : 2) | 0);
    }
  }
}
function _M0MPC14json12ParseContext21lex__decimal__integer(ctx, start) {
  while (true) {
    _L: {
      const _bind = _M0MPC14json12ParseContext10read__char(ctx);
      if (_bind === -1) {
        return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(_M0MPC14json12ParseContext16lex__number__end(ctx, start, ctx.offset));
      } else {
        const _Some = _bind;
        const _x = _Some;
        if (_x === 46) {
          const _bind$2 = _M0MPC14json12ParseContext19lex__decimal__point(ctx, start);
          let _tmp;
          if (_bind$2.$tag === 1) {
            const _ok = _bind$2;
            _tmp = _ok._0;
          } else {
            return _bind$2;
          }
          return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(_tmp);
        } else {
          if (_x === 101) {
            break _L;
          } else {
            if (_x === 69) {
              break _L;
            } else {
              if (_x >= 48 && _x <= 57) {
                continue;
              } else {
                const _tmp = ctx.offset;
                const _p = _x;
                ctx.offset = _tmp - (_p <= 65535 ? 1 : 2) | 0;
                return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(_M0MPC14json12ParseContext16lex__number__end(ctx, start, ctx.offset));
              }
            }
          }
        }
      }
    }
    const _bind = _M0MPC14json12ParseContext22lex__decimal__exponent(ctx, start);
    let _tmp;
    if (_bind.$tag === 1) {
      const _ok = _bind;
      _tmp = _ok._0;
    } else {
      return _bind;
    }
    return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(_tmp);
  }
}
function _M0MPC14json12ParseContext16lex__hex__digits(ctx, n) {
  let _tmp;
  let _tmp$2 = 0;
  let _tmp$3 = 0;
  while (true) {
    const _ = _tmp$2;
    const r = _tmp$3;
    if (_ < n) {
      const _bind = _M0MPC14json12ParseContext10read__char(ctx);
      let d;
      if (_bind === -1) {
        return new _M0DTPC16result6ResultGiRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
      } else {
        const _Some = _bind;
        const _x = _Some;
        if (_x >= 48 && _x <= 57) {
          d = _x - 48 | 0;
        } else {
          if (_x >= 65 && _x <= 70) {
            d = (_x - 65 | 0) + 10 | 0;
          } else {
            if (_x >= 97 && _x <= 102) {
              d = (_x - 97 | 0) + 10 | 0;
            } else {
              const _p = _x;
              const _bind$2 = _M0MPC14json12ParseContext21invalid__char_2einnerGiE(ctx, -(_p <= 65535 ? 1 : 2) | 0);
              if (_bind$2.$tag === 1) {
                const _ok = _bind$2;
                d = _ok._0;
              } else {
                return _bind$2;
              }
            }
          }
        }
      }
      _tmp$2 = _ + 1 | 0;
      _tmp$3 = r << 4 | d;
      continue;
    } else {
      _tmp = r;
      break;
    }
  }
  return new _M0DTPC16result6ResultGiRPC14json10ParseErrorE2Ok(_tmp);
}
function _M0MPC14json12ParseContext19unpaired__surrogateGuE(ctx, escape_start) {
  return _M0MPC14json12ParseContext21invalid__char_2einnerGuE(ctx, escape_start - ctx.offset | 0);
}
function _M0MPC14json12ParseContext17lex__string__slow(ctx, run_start) {
  const buf = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  let start = run_start;
  const end = ctx.end_offset;
  let _tmp = ctx.offset;
  while (true) {
    const i = _tmp;
    if (i < end) {
      const _bind = ctx.input;
      const c = _bind.str.charCodeAt(_bind.start + i | 0);
      if (c === 34) {
        ctx.offset = i + 1 | 0;
        if (start > 0 && i > start) {
          _M0IPB13StringBuilderPB6Logger11write__view(buf, _M0MPC16string10StringView21clamped__view_2einner(ctx.input, start, i));
        }
        break;
      } else {
        if (c === 92) {
          ctx.offset = i + 1 | 0;
          if (start > 0 && i > start) {
            _M0IPB13StringBuilderPB6Logger11write__view(buf, _M0MPC16string10StringView21clamped__view_2einner(ctx.input, start, i));
          }
          const _bind$2 = _M0MPC14json12ParseContext10read__char(ctx);
          if (_bind$2 === -1) {
            return new _M0DTPC16result6ResultGsRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
          } else {
            const _Some = _bind$2;
            const _x = _Some;
            switch (_x) {
              case 98: {
                _M0IPB13StringBuilderPB6Logger11write__char(buf, 8);
                break;
              }
              case 102: {
                _M0IPB13StringBuilderPB6Logger11write__char(buf, 12);
                break;
              }
              case 110: {
                _M0IPB13StringBuilderPB6Logger11write__char(buf, 10);
                break;
              }
              case 114: {
                _M0IPB13StringBuilderPB6Logger11write__char(buf, 13);
                break;
              }
              case 116: {
                _M0IPB13StringBuilderPB6Logger11write__char(buf, 9);
                break;
              }
              case 34: {
                _M0IPB13StringBuilderPB6Logger11write__char(buf, 34);
                break;
              }
              case 92: {
                _M0IPB13StringBuilderPB6Logger11write__char(buf, 92);
                break;
              }
              case 47: {
                _M0IPB13StringBuilderPB6Logger11write__char(buf, 47);
                break;
              }
              case 117: {
                const escape_start = ctx.offset - 2 | 0;
                const _bind$3 = _M0MPC14json12ParseContext16lex__hex__digits(ctx, 4);
                let c$2;
                if (_bind$3.$tag === 1) {
                  const _ok = _bind$3;
                  c$2 = _ok._0;
                } else {
                  return _bind$3;
                }
                if (c$2 >= 55296 && c$2 <= 56319) {
                  const _bind$4 = _M0MPC14json12ParseContext10read__char(ctx);
                  if (_bind$4 === -1) {
                    return new _M0DTPC16result6ResultGsRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
                  } else {
                    const _Some$2 = _bind$4;
                    const _x$2 = _Some$2;
                    if (_x$2 === 92) {
                    } else {
                      const _bind$5 = _M0MPC14json12ParseContext19unpaired__surrogateGuE(ctx, escape_start);
                      if (_bind$5.$tag === 1) {
                        const _ok = _bind$5;
                        _ok._0;
                      } else {
                        return _bind$5;
                      }
                    }
                  }
                  const _bind$5 = _M0MPC14json12ParseContext10read__char(ctx);
                  if (_bind$5 === -1) {
                    return new _M0DTPC16result6ResultGsRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
                  } else {
                    const _Some$2 = _bind$5;
                    const _x$2 = _Some$2;
                    if (_x$2 === 117) {
                    } else {
                      const _bind$6 = _M0MPC14json12ParseContext19unpaired__surrogateGuE(ctx, escape_start);
                      if (_bind$6.$tag === 1) {
                        const _ok = _bind$6;
                        _ok._0;
                      } else {
                        return _bind$6;
                      }
                    }
                  }
                  const _bind$6 = _M0MPC14json12ParseContext16lex__hex__digits(ctx, 4);
                  let c2;
                  if (_bind$6.$tag === 1) {
                    const _ok = _bind$6;
                    c2 = _ok._0;
                  } else {
                    return _bind$6;
                  }
                  if (c2 >= 56320 && c2 <= 57343) {
                    const combined = ((c$2 << 10) + c2 | 0) - 56613888 | 0;
                    _M0IPB13StringBuilderPB6Logger11write__char(buf, combined);
                  } else {
                    const _bind$7 = _M0MPC14json12ParseContext19unpaired__surrogateGuE(ctx, escape_start);
                    if (_bind$7.$tag === 1) {
                      const _ok = _bind$7;
                      _ok._0;
                    } else {
                      return _bind$7;
                    }
                  }
                } else {
                  if (c$2 >= 56320 && c$2 <= 57343) {
                    const _bind$4 = _M0MPC14json12ParseContext19unpaired__surrogateGuE(ctx, escape_start);
                    if (_bind$4.$tag === 1) {
                      const _ok = _bind$4;
                      _ok._0;
                    } else {
                      return _bind$4;
                    }
                  } else {
                    _M0IPB13StringBuilderPB6Logger11write__char(buf, c$2);
                  }
                }
                break;
              }
              default: {
                const _p = _x;
                const _bind$4 = _M0MPC14json12ParseContext21invalid__char_2einnerGuE(ctx, -(_p <= 65535 ? 1 : 2) | 0);
                if (_bind$4.$tag === 1) {
                  const _ok = _bind$4;
                  _ok._0;
                } else {
                  return _bind$4;
                }
              }
            }
          }
          start = ctx.offset;
          _tmp = ctx.offset;
          continue;
        } else {
          if (c < 32) {
            ctx.offset = i + 1 | 0;
            const _bind$2 = _M0MPC14json12ParseContext21invalid__char_2einnerGuE(ctx, -1);
            if (_bind$2.$tag === 1) {
              const _ok = _bind$2;
              _ok._0;
            } else {
              return _bind$2;
            }
          } else {
            _tmp = i + 1 | 0;
            continue;
          }
        }
      }
    } else {
      return new _M0DTPC16result6ResultGsRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
    }
    continue;
  }
  return new _M0DTPC16result6ResultGsRPC14json10ParseErrorE2Ok(buf.val);
}
function _M0MPC14json12ParseContext11lex__string(ctx) {
  const string_start = ctx.offset;
  const end = ctx.end_offset;
  let _tmp = string_start;
  while (true) {
    const i = _tmp;
    if (i < end) {
      const _bind = ctx.input;
      const c = _bind.str.charCodeAt(_bind.start + i | 0);
      if (c === 34) {
        ctx.offset = i + 1 | 0;
        const _p = ctx.input;
        const base = _p.start;
        const _p$2 = ctx.input;
        return new _M0DTPC16result6ResultGsRPC14json10ParseErrorE2Ok(_p$2.str.substring(base + string_start | 0, base + i | 0));
      } else {
        if (c === 92) {
          ctx.offset = i;
          const _bind$2 = _M0MPC14json12ParseContext17lex__string__slow(ctx, string_start);
          let _tmp$2;
          if (_bind$2.$tag === 1) {
            const _ok = _bind$2;
            _tmp$2 = _ok._0;
          } else {
            return _bind$2;
          }
          return new _M0DTPC16result6ResultGsRPC14json10ParseErrorE2Ok(_tmp$2);
        } else {
          if (c < 32) {
            ctx.offset = i + 1 | 0;
            const _bind$2 = _M0MPC14json12ParseContext21invalid__char_2einnerGuE(ctx, -1);
            if (_bind$2.$tag === 1) {
              const _ok = _bind$2;
              _ok._0;
            } else {
              return _bind$2;
            }
          }
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGsRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
}
function _M0MPC14json12ParseContext9lex__zero(ctx, start) {
  _L: {
    const _bind = _M0MPC14json12ParseContext10read__char(ctx);
    if (_bind === -1) {
      return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(_M0MPC14json12ParseContext16lex__number__end(ctx, start, ctx.offset));
    } else {
      const _Some = _bind;
      const _x = _Some;
      if (_x === 46) {
        return _M0MPC14json12ParseContext19lex__decimal__point(ctx, start);
      } else {
        if (_x === 101) {
          break _L;
        } else {
          if (_x === 69) {
            break _L;
          } else {
            if (_x >= 48 && _x <= 57) {
              ctx.offset = ctx.offset - 1 | 0;
              return _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, 0);
            } else {
              const _tmp = ctx.offset;
              const _p = _x;
              ctx.offset = _tmp - (_p <= 65535 ? 1 : 2) | 0;
              return new _M0DTPC16result6ResultGRPC14json11LexedNumberRPC14json10ParseErrorE2Ok(_M0MPC14json12ParseContext16lex__number__end(ctx, start, ctx.offset));
            }
          }
        }
      }
    }
  }
  return _M0MPC14json12ParseContext22lex__decimal__exponent(ctx, start);
}
function _M0MPC14json12ParseContext10lex__value(ctx, allow_rbracket) {
  _M0MPC14json12ParseContext21lex__skip__whitespace(ctx);
  const _bind = _M0MPC14json12ParseContext10read__char(ctx);
  if (_bind === -1) {
    return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
  } else {
    const _Some = _bind;
    const _x = _Some;
    if (_x === 123) {
      return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(_M0DTPC14json5Token6LBrace__);
    } else {
      if (_x === 91) {
        return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(_M0DTPC14json5Token8LBracket__);
      } else {
        if (_x === 93) {
          if (allow_rbracket) {
            return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(_M0DTPC14json5Token8RBracket__);
          } else {
            return _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, -1);
          }
        } else {
          if (_x === 110) {
            const _bind$2 = _M0MPC14json12ParseContext19expect__ascii__char(ctx, 117);
            if (_bind$2.$tag === 1) {
              const _ok = _bind$2;
              _ok._0;
            } else {
              return _bind$2;
            }
            const _bind$3 = _M0MPC14json12ParseContext19expect__ascii__char(ctx, 108);
            if (_bind$3.$tag === 1) {
              const _ok = _bind$3;
              _ok._0;
            } else {
              return _bind$3;
            }
            const _bind$4 = _M0MPC14json12ParseContext19expect__ascii__char(ctx, 108);
            if (_bind$4.$tag === 1) {
              const _ok = _bind$4;
              _ok._0;
            } else {
              return _bind$4;
            }
            return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(_M0DTPC14json5Token4Null__);
          } else {
            if (_x === 116) {
              const _bind$2 = _M0MPC14json12ParseContext19expect__ascii__char(ctx, 114);
              if (_bind$2.$tag === 1) {
                const _ok = _bind$2;
                _ok._0;
              } else {
                return _bind$2;
              }
              const _bind$3 = _M0MPC14json12ParseContext19expect__ascii__char(ctx, 117);
              if (_bind$3.$tag === 1) {
                const _ok = _bind$3;
                _ok._0;
              } else {
                return _bind$3;
              }
              const _bind$4 = _M0MPC14json12ParseContext19expect__ascii__char(ctx, 101);
              if (_bind$4.$tag === 1) {
                const _ok = _bind$4;
                _ok._0;
              } else {
                return _bind$4;
              }
              return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(_M0DTPC14json5Token4True__);
            } else {
              if (_x === 102) {
                const _bind$2 = _M0MPC14json12ParseContext19expect__ascii__char(ctx, 97);
                if (_bind$2.$tag === 1) {
                  const _ok = _bind$2;
                  _ok._0;
                } else {
                  return _bind$2;
                }
                const _bind$3 = _M0MPC14json12ParseContext19expect__ascii__char(ctx, 108);
                if (_bind$3.$tag === 1) {
                  const _ok = _bind$3;
                  _ok._0;
                } else {
                  return _bind$3;
                }
                const _bind$4 = _M0MPC14json12ParseContext19expect__ascii__char(ctx, 115);
                if (_bind$4.$tag === 1) {
                  const _ok = _bind$4;
                  _ok._0;
                } else {
                  return _bind$4;
                }
                const _bind$5 = _M0MPC14json12ParseContext19expect__ascii__char(ctx, 101);
                if (_bind$5.$tag === 1) {
                  const _ok = _bind$5;
                  _ok._0;
                } else {
                  return _bind$5;
                }
                return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(_M0DTPC14json5Token5False__);
              } else {
                if (_x === 45) {
                  const _bind$2 = _M0MPC14json12ParseContext10read__char(ctx);
                  if (_bind$2 === -1) {
                    return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
                  } else {
                    const _Some$2 = _bind$2;
                    const _x$2 = _Some$2;
                    if (_x$2 === 48) {
                      const _bind$3 = _M0MPC14json12ParseContext9lex__zero(ctx, ctx.offset - 2 | 0);
                      let _bind$4;
                      if (_bind$3.$tag === 1) {
                        const _ok = _bind$3;
                        _bind$4 = _ok._0;
                      } else {
                        return _bind$3;
                      }
                      const _n = _bind$4.value;
                      const _repr = _bind$4.repr;
                      return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(new _M0DTPC14json5Token6Number(_n, _M0MPC16option6Option3mapGRPC16string10StringViewsE(_repr, (repr) => _M0MPC16string10StringView9to__owned(repr))));
                    } else {
                      if (_x$2 >= 49 && _x$2 <= 57) {
                        const _bind$3 = _M0MPC14json12ParseContext21lex__decimal__integer(ctx, ctx.offset - 2 | 0);
                        let _bind$4;
                        if (_bind$3.$tag === 1) {
                          const _ok = _bind$3;
                          _bind$4 = _ok._0;
                        } else {
                          return _bind$3;
                        }
                        const _n = _bind$4.value;
                        const _repr = _bind$4.repr;
                        return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(new _M0DTPC14json5Token6Number(_n, _M0MPC16option6Option3mapGRPC16string10StringViewsE(_repr, (repr) => _M0MPC16string10StringView9to__owned(repr))));
                      } else {
                        const _p = _x$2;
                        return _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, -(_p <= 65535 ? 1 : 2) | 0);
                      }
                    }
                  }
                } else {
                  if (_x === 48) {
                    const _bind$2 = _M0MPC14json12ParseContext9lex__zero(ctx, ctx.offset - 1 | 0);
                    let _bind$3;
                    if (_bind$2.$tag === 1) {
                      const _ok = _bind$2;
                      _bind$3 = _ok._0;
                    } else {
                      return _bind$2;
                    }
                    const _n = _bind$3.value;
                    const _repr = _bind$3.repr;
                    return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(new _M0DTPC14json5Token6Number(_n, _M0MPC16option6Option3mapGRPC16string10StringViewsE(_repr, (repr) => _M0MPC16string10StringView9to__owned(repr))));
                  } else {
                    if (_x >= 49 && _x <= 57) {
                      const _bind$2 = _M0MPC14json12ParseContext21lex__decimal__integer(ctx, ctx.offset - 1 | 0);
                      let _bind$3;
                      if (_bind$2.$tag === 1) {
                        const _ok = _bind$2;
                        _bind$3 = _ok._0;
                      } else {
                        return _bind$2;
                      }
                      const _n = _bind$3.value;
                      const _repr = _bind$3.repr;
                      return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(new _M0DTPC14json5Token6Number(_n, _M0MPC16option6Option3mapGRPC16string10StringViewsE(_repr, (repr) => _M0MPC16string10StringView9to__owned(repr))));
                    } else {
                      if (_x === 34) {
                        const _bind$2 = _M0MPC14json12ParseContext11lex__string(ctx);
                        let s;
                        if (_bind$2.$tag === 1) {
                          const _ok = _bind$2;
                          s = _ok._0;
                        } else {
                          return _bind$2;
                        }
                        return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(new _M0DTPC14json5Token6String(s));
                      } else {
                        const _p = _x;
                        const shift = -(_p <= 65535 ? 1 : 2) | 0;
                        return _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, shift);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
function _M0MPC14json12ParseContext24lex__after__array__value(ctx) {
  _M0MPC14json12ParseContext21lex__skip__whitespace(ctx);
  const _bind = _M0MPC14json12ParseContext10read__char(ctx);
  if (_bind === -1) {
    return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
  } else {
    const _Some = _bind;
    const _x = _Some;
    switch (_x) {
      case 93: {
        return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(_M0DTPC14json5Token8RBracket__);
      }
      case 44: {
        return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(_M0DTPC14json5Token5Comma__);
      }
      default: {
        const _p = _x;
        return _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, -(_p <= 65535 ? 1 : 2) | 0);
      }
    }
  }
}
function _M0MPC14json12ParseContext25lex__after__object__value(ctx) {
  _M0MPC14json12ParseContext21lex__skip__whitespace(ctx);
  const _bind = _M0MPC14json12ParseContext10read__char(ctx);
  if (_bind === -1) {
    return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
  } else {
    const _Some = _bind;
    const _x = _Some;
    switch (_x) {
      case 125: {
        return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(_M0DTPC14json5Token6RBrace__);
      }
      case 44: {
        return new _M0DTPC16result6ResultGRPC14json5TokenRPC14json10ParseErrorE2Ok(_M0DTPC14json5Token5Comma__);
      }
      default: {
        const _p = _x;
        return _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, -(_p <= 65535 ? 1 : 2) | 0);
      }
    }
  }
}
function _M0MPC14json12ParseContext26lex__after__property__name(ctx) {
  _M0MPC14json12ParseContext21lex__skip__whitespace(ctx);
  const _bind = _M0MPC14json12ParseContext10read__char(ctx);
  if (_bind === -1) {
    return new _M0DTPC16result6ResultGuRPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
  } else {
    const _Some = _bind;
    const _x = _Some;
    if (_x === 58) {
      return new _M0DTPC16result6ResultGuRPC14json10ParseErrorE2Ok(undefined);
    } else {
      const _p = _x;
      return _M0MPC14json12ParseContext21invalid__char_2einnerGuE(ctx, -(_p <= 65535 ? 1 : 2) | 0);
    }
  }
}
function _M0MPC14json12ParseContext19lex__property__name(ctx) {
  _M0MPC14json12ParseContext21lex__skip__whitespace(ctx);
  const offset = ctx.offset;
  const _bind = _M0MPC14json12ParseContext10read__char(ctx);
  if (_bind === -1) {
    return new _M0DTPC16result6ResultGURPC14json5TokeniERPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
  } else {
    const _Some = _bind;
    const _x = _Some;
    switch (_x) {
      case 125: {
        return new _M0DTPC16result6ResultGURPC14json5TokeniERPC14json10ParseErrorE2Ok({ _0: _M0DTPC14json5Token6RBrace__, _1: offset });
      }
      case 34: {
        const _bind$2 = _M0MPC14json12ParseContext11lex__string(ctx);
        let s;
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          s = _ok._0;
        } else {
          return _bind$2;
        }
        return new _M0DTPC16result6ResultGURPC14json5TokeniERPC14json10ParseErrorE2Ok({ _0: new _M0DTPC14json5Token6String(s), _1: offset });
      }
      default: {
        const _p = _x;
        return _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, -(_p <= 65535 ? 1 : 2) | 0);
      }
    }
  }
}
function _M0MPC14json12ParseContext20lex__property__name2(ctx) {
  _M0MPC14json12ParseContext21lex__skip__whitespace(ctx);
  const offset = ctx.offset;
  const _bind = _M0MPC14json12ParseContext10read__char(ctx);
  if (_bind === -1) {
    return new _M0DTPC16result6ResultGURPC14json5TokeniERPC14json10ParseErrorE3Err(_M0DTPC15error5Error51moonbitlang_2fcore_2fjson_2eParseError_2eInvalidEof__);
  } else {
    const _Some = _bind;
    const _x = _Some;
    if (_x === 34) {
      const _bind$2 = _M0MPC14json12ParseContext11lex__string(ctx);
      let s;
      if (_bind$2.$tag === 1) {
        const _ok = _bind$2;
        s = _ok._0;
      } else {
        return _bind$2;
      }
      return new _M0DTPC16result6ResultGURPC14json5TokeniERPC14json10ParseErrorE2Ok({ _0: new _M0DTPC14json5Token6String(s), _1: offset });
    } else {
      const _p = _x;
      return _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, -(_p <= 65535 ? 1 : 2) | 0);
    }
  }
}
function _M0MPC14json12ParseContext12parse__value(ctx, remaining_available_depth) {
  const _bind = _M0MPC14json12ParseContext10lex__value(ctx, false);
  let tok;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    tok = _ok._0;
  } else {
    return _bind;
  }
  return _M0MPC14json12ParseContext13parse__value2(ctx, tok, remaining_available_depth);
}
function _M0MPC14json12ParseContext13parse__value2(ctx, tok, remaining_available_depth) {
  _L: {
    switch (tok.$tag) {
      case 0: {
        return new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE2Ok(_M0FPB4null);
      }
      case 1: {
        const _p = true;
        return new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE2Ok(_p ? _M0DTPB4Json4True__ : _M0DTPB4Json5False__);
      }
      case 2: {
        const _p$2 = false;
        return new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE2Ok(_p$2 ? _M0DTPB4Json4True__ : _M0DTPB4Json5False__);
      }
      case 3: {
        const _Number = tok;
        const _n = _Number._0;
        const _repr = _Number._1;
        return new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE2Ok(new _M0DTPB4Json6Number(_n, _repr));
      }
      case 4: {
        const _String = tok;
        const _s = _String._0;
        return new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE2Ok(new _M0DTPB4Json6String(_s));
      }
      case 5: {
        return _M0MPC14json12ParseContext13parse__object(ctx, remaining_available_depth);
      }
      case 7: {
        return _M0MPC14json12ParseContext12parse__array(ctx, remaining_available_depth);
      }
      case 8: {
        break _L;
      }
      case 6: {
        break _L;
      }
      default: {
        break _L;
      }
    }
  }
  console.error("unreachable");
  return new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE2Ok($panic());
}
function _M0MPC14json12ParseContext12parse__array(ctx, remaining_available_depth) {
  if (remaining_available_depth <= 0) {
    return new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE3Err(_M0DTPC15error5Error59moonbitlang_2fcore_2fjson_2eParseError_2eDepthLimitExceeded__);
  }
  const child_remaining_available_depth = remaining_available_depth - 1 | 0;
  const vec = [];
  let _tmp;
  const _bind = _M0MPC14json12ParseContext10lex__value(ctx, true);
  let _tmp$2;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _tmp$2 = _ok._0;
  } else {
    return _bind;
  }
  let _tmp$3 = _tmp$2;
  _L: while (true) {
    const x = _tmp$3;
    if (x.$tag === 8) {
      _tmp = new _M0DTPB4Json5Array(vec);
      break;
    } else {
      const _bind$2 = _M0MPC14json12ParseContext13parse__value2(ctx, x, child_remaining_available_depth);
      let _tmp$4;
      if (_bind$2.$tag === 1) {
        const _ok = _bind$2;
        _tmp$4 = _ok._0;
      } else {
        return _bind$2;
      }
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(vec, _tmp$4);
      const _bind$3 = _M0MPC14json12ParseContext24lex__after__array__value(ctx);
      let tok2;
      if (_bind$3.$tag === 1) {
        const _ok = _bind$3;
        tok2 = _ok._0;
      } else {
        return _bind$3;
      }
      switch (tok2.$tag) {
        case 9: {
          const _bind$4 = _M0MPC14json12ParseContext10lex__value(ctx, false);
          if (_bind$4.$tag === 1) {
            const _ok = _bind$4;
            _tmp$3 = _ok._0;
          } else {
            return _bind$4;
          }
          continue _L;
        }
        case 8: {
          _tmp = new _M0DTPB4Json5Array(vec);
          break _L;
        }
        default: {
          console.error("unreachable");
          $panic();
        }
      }
    }
    continue;
  }
  return new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE2Ok(_tmp);
}
function _M0MPC14json12ParseContext13parse__object(ctx, remaining_available_depth) {
  if (remaining_available_depth <= 0) {
    return new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE3Err(_M0DTPC15error5Error59moonbitlang_2fcore_2fjson_2eParseError_2eDepthLimitExceeded__);
  }
  const child_remaining_available_depth = remaining_available_depth - 1 | 0;
  const _bind = [];
  const map = _M0MPB3Map3MapGsRPB4JsonE(new _M0TPB9ArrayViewGUsRPB4JsonEE(_bind, 0, 0), undefined);
  let _tmp;
  const _bind$2 = _M0MPC14json12ParseContext19lex__property__name(ctx);
  let _tmp$2;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _tmp$2 = _ok._0;
  } else {
    return _bind$2;
  }
  let _tmp$3 = _tmp$2;
  _L: while (true) {
    const x = _tmp$3;
    const _x = x._0;
    switch (_x.$tag) {
      case 6: {
        _tmp = new _M0DTPB4Json6Object(map);
        break _L;
      }
      case 4: {
        const _String = _x;
        const _name = _String._0;
        const _offset = x._1;
        if (ctx.reject_duplicate_keys && _M0MPB3Map8containsGsRPB4JsonE(map, _name)) {
          return new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE3Err(new _M0DTPC15error5Error53moonbitlang_2fcore_2fjson_2eParseError_2eDuplicateKey(_M0FPC14json20offset__to__position(ctx.input, _offset), _name));
        }
        const _bind$3 = _M0MPC14json12ParseContext26lex__after__property__name(ctx);
        if (_bind$3.$tag === 1) {
          const _ok = _bind$3;
          _ok._0;
        } else {
          return _bind$3;
        }
        const _bind$4 = _M0MPC14json12ParseContext12parse__value(ctx, child_remaining_available_depth);
        let _tmp$4;
        if (_bind$4.$tag === 1) {
          const _ok = _bind$4;
          _tmp$4 = _ok._0;
        } else {
          return _bind$4;
        }
        _M0MPB3Map3setGsRPB4JsonE(map, _name, _tmp$4);
        const _bind$5 = _M0MPC14json12ParseContext25lex__after__object__value(ctx);
        let _bind$6;
        if (_bind$5.$tag === 1) {
          const _ok = _bind$5;
          _bind$6 = _ok._0;
        } else {
          return _bind$5;
        }
        switch (_bind$6.$tag) {
          case 9: {
            const _bind$7 = _M0MPC14json12ParseContext20lex__property__name2(ctx);
            if (_bind$7.$tag === 1) {
              const _ok = _bind$7;
              _tmp$3 = _ok._0;
            } else {
              return _bind$7;
            }
            continue _L;
          }
          case 6: {
            _tmp = new _M0DTPB4Json6Object(map);
            break _L;
          }
          default: {
            console.error("unreachable");
            $panic();
          }
        }
        break;
      }
      default: {
        console.error("unreachable");
        $panic();
      }
    }
    continue;
  }
  return new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE2Ok(_tmp);
}
function _M0FPC14json13parse_2einner(input, max_nesting_depth, reject_duplicate_keys, preserve_number_repr) {
  const ctx = _M0MPC14json12ParseContext12make_2einner(input, reject_duplicate_keys, preserve_number_repr);
  const _bind = _M0MPC14json12ParseContext12parse__value(ctx, max_nesting_depth);
  let val;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    val = _ok._0;
  } else {
    return _bind;
  }
  _M0MPC14json12ParseContext21lex__skip__whitespace(ctx);
  return ctx.offset >= ctx.end_offset ? new _M0DTPC16result6ResultGRPB4JsonRPC14json10ParseErrorE2Ok(val) : _M0MPC14json12ParseContext21invalid__char_2einnerGRPB4JsonE(ctx, 0);
}
function _M0FPC14json20need__escape__scalar(str, escape_slash, start, end) {
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < end) {
      const _p = str.charCodeAt(i);
      if (_p === 34 || (_p === 92 || (_p < 32 || escape_slash && _p === 47))) {
        return true;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0FPC14json12need__escape(str, escape_slash) {
  return _M0FPC14json20need__escape__scalar(str, escape_slash, 0, str.length);
}
function _M0FPC14json13write__escape(buf, code) {
  switch (code) {
    case 34: {
      _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\\"");
      return;
    }
    case 92: {
      _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\\\");
      return;
    }
    case 47: {
      _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\/");
      return;
    }
    case 10: {
      _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\n");
      return;
    }
    case 13: {
      _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\r");
      return;
    }
    case 8: {
      _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\b");
      return;
    }
    case 9: {
      _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\t");
      return;
    }
    case 12: {
      _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\f");
      return;
    }
    default: {
      _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\u00");
      _M0IPB13StringBuilderPB6Logger13write__string(buf, _M0MPC14byte4Byte7to__hex(code & 255));
      return;
    }
  }
}
function _M0FPC14json14write__escaped(buf, str, escape_slash) {
  if (!_M0FPC14json12need__escape(str, escape_slash)) {
    _M0IPB13StringBuilderPB6Logger13write__string(buf, str);
    return undefined;
  }
  const _bind = str.length;
  let _tmp = 0;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp;
    const run_start = _tmp$2;
    if (i < _bind) {
      const code = str.charCodeAt(i);
      if (code === 34 || (code === 92 || (code < 32 || escape_slash && code === 47))) {
        _M0IPB13StringBuilderPB6Logger11write__view(buf, _M0MPC16string6String19exact__view_2einner(str, run_start, i));
        _M0FPC14json13write__escape(buf, code);
        _tmp = i + 1 | 0;
        _tmp$2 = i + 1 | 0;
        continue;
      } else {
        _tmp = i + 1 | 0;
        continue;
      }
    } else {
      _M0IPB13StringBuilderPB6Logger11write__view(buf, _M0MPC16string6String19exact__view_2einner(str, run_start, undefined));
      return;
    }
  }
}
function _M0FPC14json13write__indent(buf, cache, level, indent) {
  while (true) {
    if (cache.length <= level) {
      if (cache.length >= 1) {
        const _last = cache[cache.length - 1 | 0];
        _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(cache, `${_last}${_M0MPC16string6String6repeat(" ", indent)}`);
      } else {
        _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(cache, "\n");
      }
      continue;
    } else {
      break;
    }
  }
  _M0IPB13StringBuilderPB6Logger13write__string(buf, _M0MPC15array5Array2atGUssEE(cache, level));
}
function _M0MPC14json4Json17stringify_2einner(self, escape_slash, indent, replacer) {
  const buf = _M0MPB13StringBuilder21StringBuilder_2einner(0);
  const indent_cache = [];
  const stack = [];
  let depth = 0;
  let _tmp = self;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      if (stack.length === 0) {
        break;
      } else {
        const _x = stack[stack.length - 1 | 0];
        if (_x.$tag === 0) {
          const _Array = _x;
          const _arr = _Array._0;
          const _i = _Array._1;
          if (_i < _arr.length) {
            const element = _M0MPC15array5Array2atGUssEE(_arr, _i);
            _Array._1 = _i + 1 | 0;
            if (_i > 0) {
              _M0IPB13StringBuilderPB6Logger11write__char(buf, 44);
              if (indent > 0) {
                _M0FPC14json13write__indent(buf, indent_cache, depth, indent);
              }
            }
            _tmp = element;
            continue;
          } else {
            depth = depth - 1 | 0;
            _M0MPC15array5Array3popGRPC14json10WriteFrameE(stack);
            if (indent > 0) {
              _M0FPC14json13write__indent(buf, indent_cache, depth, indent);
            }
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 93);
            _tmp = undefined;
            continue;
          }
        } else {
          const _Object = _x;
          const _iterator = _Object._0;
          const _first = _Object._1;
          const _bind = _M0MPB4Iter4nextGUssEE(_iterator);
          if (_bind === undefined) {
            depth = depth - 1 | 0;
            _M0MPC15array5Array3popGRPC14json10WriteFrameE(stack);
            if (indent > 0 && !_first) {
              _M0FPC14json13write__indent(buf, indent_cache, depth, indent);
            }
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 125);
            _tmp = undefined;
            continue;
          } else {
            const _Some = _bind;
            const _x$2 = _Some;
            const _k = _x$2._0;
            const _v = _x$2._1;
            let v2 = _v;
            if (replacer === undefined) {
            } else {
              const _Some$2 = replacer;
              const _replacer = _Some$2;
              const _func = _replacer.f;
              const _bind$2 = _func(_k, _v);
              if (_bind$2 === undefined) {
                _tmp = undefined;
                continue;
              } else {
                const _Some$3 = _bind$2;
                const _v$2 = _Some$3;
                v2 = _v$2;
              }
            }
            if (!_first) {
              _M0IPB13StringBuilderPB6Logger11write__char(buf, 44);
            }
            if (indent > 0) {
              _M0FPC14json13write__indent(buf, indent_cache, depth, indent);
            }
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 34);
            _M0FPC14json14write__escaped(buf, _k, escape_slash);
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 34);
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 58);
            if (indent > 0) {
              _M0IPB13StringBuilderPB6Logger11write__char(buf, 32);
            }
            _Object._1 = false;
            _tmp = v2;
            continue;
          }
        }
      }
    } else {
      const _Some = x;
      const _value = _Some;
      switch (_value.$tag) {
        case 6: {
          const _Object = _value;
          const _members = _Object._0;
          if (_members.size === 0) {
            _M0IPB13StringBuilderPB6Logger13write__string(buf, "{}");
          } else {
            depth = depth + 1 | 0;
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 123);
            _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(stack, new _M0DTPC14json10WriteFrame6Object(_M0MPB3Map4iterGsRPB4JsonE(_members), true));
          }
          break;
        }
        case 5: {
          const _Array = _value;
          const _arr = _Array._0;
          if (_arr.length === 0) {
            _M0IPB13StringBuilderPB6Logger13write__string(buf, "[]");
          } else {
            depth = depth + 1 | 0;
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 91);
            if (indent > 0) {
              _M0FPC14json13write__indent(buf, indent_cache, depth, indent);
            }
            _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(stack, new _M0DTPC14json10WriteFrame5Array(_arr, 0));
          }
          break;
        }
        case 4: {
          const _String = _value;
          const _s = _String._0;
          _M0IPB13StringBuilderPB6Logger11write__char(buf, 34);
          _M0FPC14json14write__escaped(buf, _s, escape_slash);
          _M0IPB13StringBuilderPB6Logger11write__char(buf, 34);
          break;
        }
        case 3: {
          const _Number = _value;
          const _n = _Number._0;
          const _repr = _Number._1;
          if (_repr === undefined) {
            _M0MPB13StringBuilder13write__objectGdE(buf, _n);
          } else {
            const _Some$2 = _repr;
            const _r = _Some$2;
            _M0IPB13StringBuilderPB6Logger13write__string(buf, _r);
          }
          break;
        }
        case 1: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "true");
          break;
        }
        case 2: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "false");
          break;
        }
        default: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "null");
        }
      }
      _tmp = undefined;
      continue;
    }
  }
  return buf.val;
}
function _M0FPC28encoding7percent14is__unreserved(code_unit) {
  return code_unit >= 65 && code_unit <= 90 ? true : code_unit >= 97 && code_unit <= 122 ? true : code_unit >= 48 && code_unit <= 57 ? true : code_unit === 45 ? true : code_unit === 46 ? true : code_unit === 95 ? true : code_unit === 126;
}
function _M0FPC28encoding7percent13write__escape(builder, byte) {
  _M0IPB13StringBuilderPB6Logger11write__char(builder, 37);
  const _tmp = $bytes_literal$3;
  const _tmp$2 = byte >> 4 & 15;
  const _p = _tmp$2 >>> 0 < _tmp.length ? _tmp[_tmp$2] : $oob();
  _M0IPB13StringBuilderPB6Logger11write__char(builder, _p);
  const _tmp$3 = $bytes_literal$3;
  const _tmp$4 = byte & 15;
  const _p$2 = _tmp$4 >>> 0 < _tmp$3.length ? _tmp$3[_tmp$4] : $oob();
  _M0IPB13StringBuilderPB6Logger11write__char(builder, _p$2);
}
function _M0FPC28encoding7percent6encode(text) {
  const builder = _M0MPB13StringBuilder21StringBuilder_2einner(text.end - text.start | 0);
  const length = text.end - text.start | 0;
  let i = 0;
  let literal_start = 0;
  while (true) {
    if (i < length) {
      const unit = text.str.charCodeAt(text.start + i | 0);
      if (unit < 128) {
        if (_M0FPC28encoding7percent14is__unreserved(unit)) {
          i = i + 1 | 0;
          continue;
        }
        _M0IPB13StringBuilderPB6Logger11write__view(builder, _M0MPC16string10StringView12view_2einner(text, literal_start, i));
        _M0FPC28encoding7percent13write__escape(builder, unit);
        i = i + 1 | 0;
      } else {
        _M0IPB13StringBuilderPB6Logger11write__view(builder, _M0MPC16string10StringView12view_2einner(text, literal_start, i));
        if (unit < 2048) {
          _M0FPC28encoding7percent13write__escape(builder, 192 | unit >> 6);
          _M0FPC28encoding7percent13write__escape(builder, 128 | unit & 63);
          i = i + 1 | 0;
        } else {
          let _tmp;
          if (55296 <= unit && unit <= 56319) {
            let _tmp$2;
            if ((i + 1 | 0) < length) {
              const _p = text.str.charCodeAt(text.start + (i + 1 | 0) | 0);
              _tmp$2 = _p >= 56320 && _p <= 57343;
            } else {
              _tmp$2 = false;
            }
            _tmp = _tmp$2;
          } else {
            _tmp = false;
          }
          if (_tmp) {
            const low = text.str.charCodeAt(text.start + (i + 1 | 0) | 0);
            const code_point = (65536 + (unit - 55296 << 10) | 0) + (low - 56320 | 0) | 0;
            _M0FPC28encoding7percent13write__escape(builder, 240 | code_point >> 18);
            _M0FPC28encoding7percent13write__escape(builder, 128 | code_point >> 12 & 63);
            _M0FPC28encoding7percent13write__escape(builder, 128 | code_point >> 6 & 63);
            _M0FPC28encoding7percent13write__escape(builder, 128 | code_point & 63);
            i = i + 2 | 0;
          } else {
            const scalar = 55296 <= unit && unit <= 56319 || 56320 <= unit && unit <= 57343 ? 65533 : unit;
            _M0FPC28encoding7percent13write__escape(builder, 224 | scalar >> 12);
            _M0FPC28encoding7percent13write__escape(builder, 128 | scalar >> 6 & 63);
            _M0FPC28encoding7percent13write__escape(builder, 128 | scalar & 63);
            i = i + 1 | 0;
          }
        }
      }
      literal_start = i;
      continue;
    } else {
      break;
    }
  }
  _M0IPB13StringBuilderPB6Logger11write__view(builder, _M0MPC16string10StringView12view_2einner(text, literal_start, length));
  return builder.val;
}
function _M0FP312moonbitstack8moonbase8internal9group__of(bits) {
  let chars = 1;
  while (true) {
    if (((Math.imul(chars, bits) | 0) % 8 | 0) !== 0) {
      chars = chars + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return chars;
}
function _M0FP312moonbitstack8moonbase8internal4pack(input, bits, digits, pad) {
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  let buffer = 0;
  let held = 0;
  const mask = (1 << bits) - 1 | 0;
  let count = 0;
  const _bind = input.end - input.start | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const _tmp$2 = buffer << 8;
      if (i < 0 || i >= (input.end - input.start | 0)) {
        $panic();
      }
      buffer = _tmp$2 | input.buf[input.start + i | 0];
      held = held + 8 | 0;
      while (true) {
        if (held >= bits) {
          held = held - bits | 0;
          _M0IPB13StringBuilderPB6Logger11write__char(out, _M0MPC15array5Array2atGcE(digits, buffer >> held & mask));
          count = count + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      buffer = buffer & ((1 << held) - 1 | 0);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (held > 0) {
    _M0IPB13StringBuilderPB6Logger11write__char(out, _M0MPC15array5Array2atGcE(digits, buffer << (bits - held | 0) & mask));
    count = count + 1 | 0;
  }
  if (pad) {
    const group = _M0FP312moonbitstack8moonbase8internal9group__of(bits);
    while (true) {
      if ((count % group | 0) !== 0) {
        _M0IPB13StringBuilderPB6Logger11write__char(out, 61);
        count = count + 1 | 0;
        continue;
      } else {
        break;
      }
    }
  }
  return out.val;
}
function _M0FP312moonbitstack8moonbase8internal14unpack_2einner(input, bits, lookup, lossy, padding, strict) {
  const out = [];
  let buffer = 0;
  let held = 0;
  let taken = 0;
  let pads = 0;
  let first_pad = -1;
  let last = -1;
  const _bind = input.end - input.start | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      _L: {
        if (i < 0 || i >= (input.end - input.start | 0)) {
          $panic();
        }
        const code = input.str.charCodeAt(input.start + i | 0);
        if (code === 61) {
          if (first_pad < 0) {
            first_pad = i;
          }
          pads = pads + 1 | 0;
          break _L;
        }
        if (first_pad >= 0 && !lossy) {
          return new _M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonbase_2eMalformed_2ePadding(i));
        }
        const value = code >= 0 && code < 128 ? _M0MPC15array5Array2atGiE(lookup, code) : -1;
        if (value < 0) {
          if (lossy) {
            break _L;
          }
          return new _M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE3Err(new _M0DTPC15error5Error41moonbitstack_2fmoonbase_2eMalformed_2eBad(i, code));
        }
        buffer = buffer << bits | value;
        held = held + bits | 0;
        taken = taken + 1 | 0;
        last = i;
        while (true) {
          if (held >= 8) {
            held = held - 8 | 0;
            _M0MPC15array5Array4pushGyE(out, buffer >> held & 255);
            continue;
          } else {
            break;
          }
        }
        buffer = buffer & ((1 << held) - 1 | 0);
        break _L;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (((Math.imul(taken, bits) | 0) % 8 | 0) >= bits) {
    return new _M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE3Err(new _M0DTPC15error5Error47moonbitstack_2fmoonbase_2eMalformed_2eTruncated(input.end - input.start | 0));
  }
  if (lossy) {
    return new _M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE2Ok(_M0MPC15bytes5Bytes11from__array(new _M0TPB9ArrayViewGyE(out, 0, out.length)));
  }
  const group = _M0FP312moonbitstack8moonbase8internal9group__of(bits);
  const want = (group - (taken % group | 0) | 0) % group | 0;
  if (padding === -1) {
  } else {
    const _Some = padding;
    const _x = _Some;
    if (_x === true) {
      if (pads < want) {
        return new _M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonbase_2eMalformed_2ePadding(input.end - input.start | 0));
      } else {
        if (pads > want) {
          return new _M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonbase_2eMalformed_2ePadding(first_pad + want | 0));
        }
      }
    } else {
      if (pads > 0) {
        return new _M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonbase_2eMalformed_2ePadding(first_pad));
      }
    }
  }
  if (strict) {
    if (pads > 0 && pads !== want) {
      return new _M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonbase_2eMalformed_2ePadding(first_pad));
    }
    if (buffer !== 0) {
      return new _M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE3Err(new _M0DTPC15error5Error45moonbitstack_2fmoonbase_2eMalformed_2ePadding(last));
    }
  }
  return new _M0DTPC16result6ResultGzRP212moonbitstack8moonbase9MalformedE2Ok(_M0MPC15bytes5Bytes11from__array(new _M0TPB9ArrayViewGyE(out, 0, out.length)));
}
function _M0FP312moonbitstack8moonbase8internal10lookup__of(chars) {
  const table = _M0MPC15array5Array4makeGiE(128, -1);
  const digits = _M0MPC16string6String9to__array(chars);
  const _bind = digits.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const code = _M0MPC15array5Array2atGcE(digits, i);
      if (code >= 0 && code < 128) {
        _M0MPC15array5Array3setGiE(table, code, i);
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return table;
}
function _M0FP312moonbitstack8moonbase6base646digits(kind) {
  if (kind === 0) {
    return _M0FP312moonbitstack8moonbase6base6411std__digits;
  } else {
    return _M0FP312moonbitstack8moonbase6base6411url__digits;
  }
}
function _M0FP312moonbitstack8moonbase6base6414encode_2einner(input, kind, padding) {
  return _M0FP312moonbitstack8moonbase8internal4pack(input, 6, _M0FP312moonbitstack8moonbase6base646digits(kind), padding);
}
function _M0FP312moonbitstack8moonbase6base646encode(input, kind$46$opt, padding$46$opt) {
  let kind;
  if (kind$46$opt === undefined) {
    kind = 0;
  } else {
    const _Some = kind$46$opt;
    kind = _Some;
  }
  const padding = padding$46$opt === -1 ? true : padding$46$opt;
  return _M0FP312moonbitstack8moonbase6base6414encode_2einner(input, kind, padding);
}
function _M0FP312moonbitstack8moonbase6base646lookup(kind) {
  if (kind === 0) {
    return _M0FP312moonbitstack8moonbase6base6411std__lookup;
  } else {
    return _M0FP312moonbitstack8moonbase6base6411url__lookup;
  }
}
function _M0FP312moonbitstack8moonbase6base6414decode_2einner(input, kind, padding, strict) {
  return _M0FP312moonbitstack8moonbase8internal14unpack_2einner(input, 6, _M0FP312moonbitstack8moonbase6base646lookup(kind), false, padding, strict);
}
function _M0FP312moonbitstack8moonbase6base646decode(input, kind$46$opt, padding, strict$46$opt) {
  let kind;
  if (kind$46$opt === undefined) {
    kind = 0;
  } else {
    const _Some = kind$46$opt;
    kind = _Some;
  }
  const strict = strict$46$opt === -1 ? false : strict$46$opt;
  return _M0FP312moonbitstack8moonbase6base6414decode_2einner(input, kind, padding, strict);
}
function _M0FP312moonbitstack8moonbase6base6421decode__lossy_2einner(input, kind) {
  let _try_err;
  _L: {
    const _bind = _M0FP312moonbitstack8moonbase8internal14unpack_2einner(input, 6, _M0FP312moonbitstack8moonbase6base646lookup(kind), true, -1, false);
    if (_bind.$tag === 1) {
      const _ok = _bind;
      return _ok._0;
    } else {
      const _err = _bind;
      _try_err = _err._0;
      break _L;
    }
  }
  return $bytes_literal$2;
}
function _M0FP312moonbitstack8moonbase6base6413decode__lossy(input, kind$46$opt) {
  let kind;
  if (kind$46$opt === undefined) {
    kind = 0;
  } else {
    const _Some = kind$46$opt;
    kind = _Some;
  }
  return _M0FP312moonbitstack8moonbase6base6421decode__lossy_2einner(input, kind);
}
function _M0IP412moonbitstack9mooncrypt4hash4sha24KindPB2Eq5equal(_x_187, _x_188) {
  switch (_x_187) {
    case 0: {
      if (_x_188 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_188 === 1) {
        return true;
      } else {
        return false;
      }
    }
    case 2: {
      if (_x_188 === 2) {
        return true;
      } else {
        return false;
      }
    }
    case 3: {
      if (_x_188 === 3) {
        return true;
      } else {
        return false;
      }
    }
    case 4: {
      if (_x_188 === 4) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_188 === 5) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function _M0MP412moonbitstack9mooncrypt4hash4sha24Kind4size(self) {
  switch (self) {
    case 0: {
      return 28;
    }
    case 1: {
      return 32;
    }
    case 2: {
      return 48;
    }
    case 3: {
      return 64;
    }
    case 4: {
      return 28;
    }
    default: {
      return 32;
    }
  }
}
function _M0IP412moonbitstack9mooncrypt4hash4sha26HasherP312moonbitstack9mooncrypt4spec4Hash5reset(self) {
  const _bind = self.core;
  if (_bind.$tag === 0) {
    const _Narrow = _bind;
    const _s = _Narrow._0;
    const iv = _M0IP412moonbitstack9mooncrypt4hash4sha24KindPB2Eq5equal(self.kind, 0) ? _M0FP412moonbitstack9mooncrypt4hash4sha25iv224 : _M0FP412moonbitstack9mooncrypt4hash4sha25iv256;
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < 8) {
        const _tmp$2 = _s.h;
        if (i >>> 0 < _tmp$2.length) {
          _tmp$2[i] = i >>> 0 < iv.length ? iv[i] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    _s.used = 0;
    _s.n = 0n;
    return;
  } else {
    const _Wide = _bind;
    const _s = _Wide._0;
    const _bind$2 = self.kind;
    let iv;
    switch (_bind$2) {
      case 2: {
        iv = _M0FP412moonbitstack9mooncrypt4hash4sha25iv384;
        break;
      }
      case 4: {
        iv = _M0FP412moonbitstack9mooncrypt4hash4sha210iv512__224;
        break;
      }
      case 5: {
        iv = _M0FP412moonbitstack9mooncrypt4hash4sha210iv512__256;
        break;
      }
      default: {
        iv = _M0FP412moonbitstack9mooncrypt4hash4sha25iv512;
      }
    }
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < 8) {
        const _tmp$2 = _s.h;
        if (i >>> 0 < _tmp$2.length) {
          _tmp$2[i] = i >>> 0 < iv.length ? iv[i] : $oob();
        } else {
          $oob();
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    _s.used = 0;
    _s.lo = 0n;
    _s.hi = 0n;
    return;
  }
}
function _M0MP412moonbitstack9mooncrypt4hash4sha26Hasher11new_2einner(kind) {
  let core;
  _L: {
    _L$2: {
      switch (kind) {
        case 0: {
          break _L$2;
        }
        case 1: {
          break _L$2;
        }
        default: {
          core = new _M0DTP412moonbitstack9mooncrypt4hash4sha24Core4Wide(new _M0TP412moonbitstack9mooncrypt4hash4sha24Wide($make_array_len_and_init(8, 0n), $makebytes(128, 0), 0, 0n, 0n));
        }
      }
      break _L;
    }
    core = new _M0DTP412moonbitstack9mooncrypt4hash4sha24Core6Narrow(new _M0TP412moonbitstack9mooncrypt4hash4sha26Narrow($make_array_len_and_init(8, 0), $makebytes(64, 0), 0, 0n));
  }
  const hasher = new _M0TP412moonbitstack9mooncrypt4hash4sha26Hasher(kind, core);
  _M0IP412moonbitstack9mooncrypt4hash4sha26HasherP312moonbitstack9mooncrypt4spec4Hash5reset(hasher);
  return hasher;
}
function _M0MP412moonbitstack9mooncrypt4hash4sha26Hasher3new(kind$46$opt) {
  let kind;
  if (kind$46$opt === undefined) {
    kind = 1;
  } else {
    const _Some = kind$46$opt;
    kind = _Some;
  }
  return _M0MP412moonbitstack9mooncrypt4hash4sha26Hasher11new_2einner(kind);
}
function _M0FP412moonbitstack9mooncrypt4hash4sha213narrow__block(h, data, off) {
  const w = $make_array_len_and_init(64, 0);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < 16) {
      const j = off + (Math.imul(i, 4) | 0) | 0;
      const _tmp$2 = (j >>> 0 < data.length ? data[j] : $oob()) << 24;
      const _tmp$3 = j + 1 | 0;
      const _tmp$4 = _tmp$2 | (_tmp$3 >>> 0 < data.length ? data[_tmp$3] : $oob()) << 16;
      const _tmp$5 = j + 2 | 0;
      const _tmp$6 = _tmp$4 | (_tmp$5 >>> 0 < data.length ? data[_tmp$5] : $oob()) << 8;
      const _tmp$7 = j + 3 | 0;
      if (i >>> 0 < w.length) {
        w[i] = _tmp$6 | (_tmp$7 >>> 0 < data.length ? data[_tmp$7] : $oob());
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$2 = 16;
  while (true) {
    const i = _tmp$2;
    if (i < 64) {
      const _tmp$3 = i - 15 | 0;
      const _p = _tmp$3 >>> 0 < w.length ? w[_tmp$3] : $oob();
      const _p$2 = 7;
      const _tmp$4 = _p >>> _p$2 | _p << (32 - _p$2 | 0);
      const _tmp$5 = i - 15 | 0;
      const _p$3 = _tmp$5 >>> 0 < w.length ? w[_tmp$5] : $oob();
      const _p$4 = 18;
      const _tmp$6 = _tmp$4 ^ (_p$3 >>> _p$4 | _p$3 << (32 - _p$4 | 0));
      const _tmp$7 = i - 15 | 0;
      const s0 = _tmp$6 ^ ((_tmp$7 >>> 0 < w.length ? w[_tmp$7] : $oob()) >>> 3 | 0);
      const _tmp$8 = i - 2 | 0;
      const _p$5 = _tmp$8 >>> 0 < w.length ? w[_tmp$8] : $oob();
      const _p$6 = 17;
      const _tmp$9 = _p$5 >>> _p$6 | _p$5 << (32 - _p$6 | 0);
      const _tmp$10 = i - 2 | 0;
      const _p$7 = _tmp$10 >>> 0 < w.length ? w[_tmp$10] : $oob();
      const _p$8 = 19;
      const _tmp$11 = _tmp$9 ^ (_p$7 >>> _p$8 | _p$7 << (32 - _p$8 | 0));
      const _tmp$12 = i - 2 | 0;
      const s1 = _tmp$11 ^ ((_tmp$12 >>> 0 < w.length ? w[_tmp$12] : $oob()) >>> 10 | 0);
      const _tmp$13 = i - 16 | 0;
      const _tmp$14 = ((_tmp$13 >>> 0 < w.length ? w[_tmp$13] : $oob()) >>> 0) + (s0 >>> 0) | 0;
      const _tmp$15 = i - 7 | 0;
      if (i >>> 0 < w.length) {
        w[i] = (((_tmp$14 >>> 0) + ((_tmp$15 >>> 0 < w.length ? w[_tmp$15] : $oob()) >>> 0) | 0) >>> 0) + (s1 >>> 0) | 0;
      } else {
        $oob();
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let a = 0 >>> 0 < h.length ? h[0] : $oob();
  let b = 1 >>> 0 < h.length ? h[1] : $oob();
  let c = 2 >>> 0 < h.length ? h[2] : $oob();
  let d = 3 >>> 0 < h.length ? h[3] : $oob();
  let e = 4 >>> 0 < h.length ? h[4] : $oob();
  let f = 5 >>> 0 < h.length ? h[5] : $oob();
  let g = 6 >>> 0 < h.length ? h[6] : $oob();
  let s = 7 >>> 0 < h.length ? h[7] : $oob();
  let _tmp$3 = 0;
  while (true) {
    const i = _tmp$3;
    if (i < 64) {
      const _p = e;
      const _p$2 = 6;
      const _tmp$4 = _p >>> _p$2 | _p << (32 - _p$2 | 0);
      const _p$3 = e;
      const _p$4 = 11;
      const _tmp$5 = _tmp$4 ^ (_p$3 >>> _p$4 | _p$3 << (32 - _p$4 | 0));
      const _p$5 = e;
      const _p$6 = 25;
      const s1 = _tmp$5 ^ (_p$5 >>> _p$6 | _p$5 << (32 - _p$6 | 0));
      const ch = e & f ^ ~e & g;
      const t1 = (((((((s >>> 0) + (s1 >>> 0) | 0) >>> 0) + (ch >>> 0) | 0) >>> 0) + ((i >>> 0 < _M0FP412moonbitstack9mooncrypt4hash4sha23k32.length ? _M0FP412moonbitstack9mooncrypt4hash4sha23k32[i] : $oob()) >>> 0) | 0) >>> 0) + ((i >>> 0 < w.length ? w[i] : $oob()) >>> 0) | 0;
      const _p$7 = a;
      const _p$8 = 2;
      const _tmp$6 = _p$7 >>> _p$8 | _p$7 << (32 - _p$8 | 0);
      const _p$9 = a;
      const _p$10 = 13;
      const _tmp$7 = _tmp$6 ^ (_p$9 >>> _p$10 | _p$9 << (32 - _p$10 | 0));
      const _p$11 = a;
      const _p$12 = 22;
      const s0 = _tmp$7 ^ (_p$11 >>> _p$12 | _p$11 << (32 - _p$12 | 0));
      const maj = a & b ^ a & c ^ b & c;
      const t2 = (s0 >>> 0) + (maj >>> 0) | 0;
      s = g;
      g = f;
      f = e;
      e = (d >>> 0) + (t1 >>> 0) | 0;
      d = c;
      c = b;
      b = a;
      a = (t1 >>> 0) + (t2 >>> 0) | 0;
      _tmp$3 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (0 >>> 0 < h.length) {
    h[0] = ((0 >>> 0 < h.length ? h[0] : $oob()) >>> 0) + (a >>> 0) | 0;
  } else {
    $oob();
  }
  if (1 >>> 0 < h.length) {
    h[1] = ((1 >>> 0 < h.length ? h[1] : $oob()) >>> 0) + (b >>> 0) | 0;
  } else {
    $oob();
  }
  if (2 >>> 0 < h.length) {
    h[2] = ((2 >>> 0 < h.length ? h[2] : $oob()) >>> 0) + (c >>> 0) | 0;
  } else {
    $oob();
  }
  if (3 >>> 0 < h.length) {
    h[3] = ((3 >>> 0 < h.length ? h[3] : $oob()) >>> 0) + (d >>> 0) | 0;
  } else {
    $oob();
  }
  if (4 >>> 0 < h.length) {
    h[4] = ((4 >>> 0 < h.length ? h[4] : $oob()) >>> 0) + (e >>> 0) | 0;
  } else {
    $oob();
  }
  if (5 >>> 0 < h.length) {
    h[5] = ((5 >>> 0 < h.length ? h[5] : $oob()) >>> 0) + (f >>> 0) | 0;
  } else {
    $oob();
  }
  if (6 >>> 0 < h.length) {
    h[6] = ((6 >>> 0 < h.length ? h[6] : $oob()) >>> 0) + (g >>> 0) | 0;
  } else {
    $oob();
  }
  if (7 >>> 0 < h.length) {
    h[7] = ((7 >>> 0 < h.length ? h[7] : $oob()) >>> 0) + (s >>> 0) | 0;
  } else {
    $oob();
  }
}
function _M0FP412moonbitstack9mooncrypt4hash4sha214narrow__finish(s, out) {
  const h = $make_array_len_and_init(8, 0);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < 8) {
      const _tmp$2 = s.h;
      if (i >>> 0 < h.length) {
        h[i] = i >>> 0 < _tmp$2.length ? _tmp$2[i] : $oob();
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const pad = $makebytes(128, 0);
  const _bind = s.used;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < _bind) {
      const _tmp$3 = s.buf;
      if (i >>> 0 < pad.length) {
        pad[i] = i >>> 0 < _tmp$3.length ? _tmp$3[i] : $oob();
      } else {
        $oob();
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _tmp$3 = s.used;
  if (_tmp$3 >>> 0 < pad.length) {
    pad[_tmp$3] = 128;
  } else {
    $oob();
  }
  const total = s.used < 56 ? 64 : 128;
  const bits = BigInt.asUintN(64, s.n * 8n);
  let _tmp$4 = 0;
  while (true) {
    const i = _tmp$4;
    if (i < 8) {
      const _tmp$5 = (total - 1 | 0) - i | 0;
      const _p = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, bits) >> BigInt(Math.imul(i, 8) & 63)) & 255n);
      if (_tmp$5 >>> 0 < pad.length) {
        pad[_tmp$5] = (Number(BigInt.asIntN(32, _p)) | 0) & 255;
      } else {
        $oob();
      }
      _tmp$4 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$5 = 0;
  while (true) {
    const off = _tmp$5;
    if (off < total) {
      _M0FP412moonbitstack9mooncrypt4hash4sha213narrow__block(h, pad, off);
      _tmp$5 = off + 64 | 0;
      continue;
    } else {
      break;
    }
  }
  const digest = [];
  const _bind$2 = (out + 3 | 0) / 4 | 0;
  let _tmp$6 = 0;
  while (true) {
    const i = _tmp$6;
    if (i < _bind$2) {
      let _tmp$7 = 3;
      while (true) {
        const k = _tmp$7;
        if (k >= 0) {
          const _p = (i >>> 0 < h.length ? h[i] : $oob()) >>> (Math.imul(k, 8) | 0) & 255;
          _M0MPC15array5Array4pushGyE(digest, _p & 255);
          _tmp$7 = k - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp$6 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$3 = _M0MPC15array9ArrayView9to__ownedGyE(_M0MPC15array5Array21clamped__view_2einnerGyE(digest, 0, out));
  return _M0MPC15bytes5Bytes11from__array(new _M0TPB9ArrayViewGyE(_bind$3, 0, _bind$3.length));
}
function _M0FP412moonbitstack9mooncrypt4hash4sha211wide__block(h, data, off) {
  const w = $make_array_len_and_init(80, 0n);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < 16) {
      const j = off + (Math.imul(i, 8) | 0) | 0;
      let v = 0n;
      let _tmp$2 = 0;
      while (true) {
        const b = _tmp$2;
        if (b < 8) {
          const _tmp$3 = BigInt.asUintN(64, v << BigInt(8 & 63));
          const _tmp$4 = j + b | 0;
          const _p = _tmp$4 >>> 0 < data.length ? data[_tmp$4] : $oob();
          v = BigInt.asUintN(64, _tmp$3 | BigInt.asUintN(64, BigInt(_p)));
          _tmp$2 = b + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      if (i >>> 0 < w.length) {
        w[i] = v;
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$2 = 16;
  while (true) {
    const i = _tmp$2;
    if (i < 80) {
      const _tmp$3 = i - 15 | 0;
      const _p = _tmp$3 >>> 0 < w.length ? w[_tmp$3] : $oob();
      const _p$2 = 1;
      const _tmp$4 = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, _p) >> BigInt(_p$2 & 63)) | BigInt.asUintN(64, _p << BigInt(64 - _p$2 & 63)));
      const _tmp$5 = i - 15 | 0;
      const _p$3 = _tmp$5 >>> 0 < w.length ? w[_tmp$5] : $oob();
      const _p$4 = 8;
      const _tmp$6 = BigInt.asUintN(64, _tmp$4 ^ BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, _p$3) >> BigInt(_p$4 & 63)) | BigInt.asUintN(64, _p$3 << BigInt(64 - _p$4 & 63))));
      const _tmp$7 = i - 15 | 0;
      const s0 = BigInt.asUintN(64, _tmp$6 ^ BigInt.asUintN(64, BigInt.asUintN(64, _tmp$7 >>> 0 < w.length ? w[_tmp$7] : $oob()) >> BigInt(7 & 63)));
      const _tmp$8 = i - 2 | 0;
      const _p$5 = _tmp$8 >>> 0 < w.length ? w[_tmp$8] : $oob();
      const _p$6 = 19;
      const _tmp$9 = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, _p$5) >> BigInt(_p$6 & 63)) | BigInt.asUintN(64, _p$5 << BigInt(64 - _p$6 & 63)));
      const _tmp$10 = i - 2 | 0;
      const _p$7 = _tmp$10 >>> 0 < w.length ? w[_tmp$10] : $oob();
      const _p$8 = 61;
      const _tmp$11 = BigInt.asUintN(64, _tmp$9 ^ BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, _p$7) >> BigInt(_p$8 & 63)) | BigInt.asUintN(64, _p$7 << BigInt(64 - _p$8 & 63))));
      const _tmp$12 = i - 2 | 0;
      const s1 = BigInt.asUintN(64, _tmp$11 ^ BigInt.asUintN(64, BigInt.asUintN(64, _tmp$12 >>> 0 < w.length ? w[_tmp$12] : $oob()) >> BigInt(6 & 63)));
      const _tmp$13 = i - 16 | 0;
      const _tmp$14 = BigInt.asUintN(64, (_tmp$13 >>> 0 < w.length ? w[_tmp$13] : $oob()) + s0);
      const _tmp$15 = i - 7 | 0;
      if (i >>> 0 < w.length) {
        w[i] = BigInt.asUintN(64, BigInt.asUintN(64, _tmp$14 + (_tmp$15 >>> 0 < w.length ? w[_tmp$15] : $oob())) + s1);
      } else {
        $oob();
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let a = 0 >>> 0 < h.length ? h[0] : $oob();
  let b = 1 >>> 0 < h.length ? h[1] : $oob();
  let c = 2 >>> 0 < h.length ? h[2] : $oob();
  let d = 3 >>> 0 < h.length ? h[3] : $oob();
  let e = 4 >>> 0 < h.length ? h[4] : $oob();
  let f = 5 >>> 0 < h.length ? h[5] : $oob();
  let g = 6 >>> 0 < h.length ? h[6] : $oob();
  let s = 7 >>> 0 < h.length ? h[7] : $oob();
  let _tmp$3 = 0;
  while (true) {
    const i = _tmp$3;
    if (i < 80) {
      const _p = e;
      const _p$2 = 14;
      const _tmp$4 = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, _p) >> BigInt(_p$2 & 63)) | BigInt.asUintN(64, _p << BigInt(64 - _p$2 & 63)));
      const _p$3 = e;
      const _p$4 = 18;
      const _tmp$5 = BigInt.asUintN(64, _tmp$4 ^ BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, _p$3) >> BigInt(_p$4 & 63)) | BigInt.asUintN(64, _p$3 << BigInt(64 - _p$4 & 63))));
      const _p$5 = e;
      const _p$6 = 41;
      const s1 = BigInt.asUintN(64, _tmp$5 ^ BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, _p$5) >> BigInt(_p$6 & 63)) | BigInt.asUintN(64, _p$5 << BigInt(64 - _p$6 & 63))));
      const ch = BigInt.asUintN(64, BigInt.asUintN(64, e & f) ^ BigInt.asUintN(64, BigInt.asUintN(64, ~e) & g));
      const t1 = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, s + s1) + ch) + (i >>> 0 < _M0FP412moonbitstack9mooncrypt4hash4sha23k64.length ? _M0FP412moonbitstack9mooncrypt4hash4sha23k64[i] : $oob())) + (i >>> 0 < w.length ? w[i] : $oob()));
      const _p$7 = a;
      const _p$8 = 28;
      const _tmp$6 = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, _p$7) >> BigInt(_p$8 & 63)) | BigInt.asUintN(64, _p$7 << BigInt(64 - _p$8 & 63)));
      const _p$9 = a;
      const _p$10 = 34;
      const _tmp$7 = BigInt.asUintN(64, _tmp$6 ^ BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, _p$9) >> BigInt(_p$10 & 63)) | BigInt.asUintN(64, _p$9 << BigInt(64 - _p$10 & 63))));
      const _p$11 = a;
      const _p$12 = 39;
      const s0 = BigInt.asUintN(64, _tmp$7 ^ BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, _p$11) >> BigInt(_p$12 & 63)) | BigInt.asUintN(64, _p$11 << BigInt(64 - _p$12 & 63))));
      const maj = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, a & b) ^ BigInt.asUintN(64, a & c)) ^ BigInt.asUintN(64, b & c));
      const t2 = BigInt.asUintN(64, s0 + maj);
      s = g;
      g = f;
      f = e;
      e = BigInt.asUintN(64, d + t1);
      d = c;
      c = b;
      b = a;
      a = BigInt.asUintN(64, t1 + t2);
      _tmp$3 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (0 >>> 0 < h.length) {
    h[0] = BigInt.asUintN(64, (0 >>> 0 < h.length ? h[0] : $oob()) + a);
  } else {
    $oob();
  }
  if (1 >>> 0 < h.length) {
    h[1] = BigInt.asUintN(64, (1 >>> 0 < h.length ? h[1] : $oob()) + b);
  } else {
    $oob();
  }
  if (2 >>> 0 < h.length) {
    h[2] = BigInt.asUintN(64, (2 >>> 0 < h.length ? h[2] : $oob()) + c);
  } else {
    $oob();
  }
  if (3 >>> 0 < h.length) {
    h[3] = BigInt.asUintN(64, (3 >>> 0 < h.length ? h[3] : $oob()) + d);
  } else {
    $oob();
  }
  if (4 >>> 0 < h.length) {
    h[4] = BigInt.asUintN(64, (4 >>> 0 < h.length ? h[4] : $oob()) + e);
  } else {
    $oob();
  }
  if (5 >>> 0 < h.length) {
    h[5] = BigInt.asUintN(64, (5 >>> 0 < h.length ? h[5] : $oob()) + f);
  } else {
    $oob();
  }
  if (6 >>> 0 < h.length) {
    h[6] = BigInt.asUintN(64, (6 >>> 0 < h.length ? h[6] : $oob()) + g);
  } else {
    $oob();
  }
  if (7 >>> 0 < h.length) {
    h[7] = BigInt.asUintN(64, (7 >>> 0 < h.length ? h[7] : $oob()) + s);
  } else {
    $oob();
  }
}
function _M0FP412moonbitstack9mooncrypt4hash4sha212wide__finish(s, out) {
  const h = $make_array_len_and_init(8, 0n);
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < 8) {
      const _tmp$2 = s.h;
      if (i >>> 0 < h.length) {
        h[i] = i >>> 0 < _tmp$2.length ? _tmp$2[i] : $oob();
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const pad = $makebytes(256, 0);
  const _bind = s.used;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < _bind) {
      const _tmp$3 = s.buf;
      if (i >>> 0 < pad.length) {
        pad[i] = i >>> 0 < _tmp$3.length ? _tmp$3[i] : $oob();
      } else {
        $oob();
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _tmp$3 = s.used;
  if (_tmp$3 >>> 0 < pad.length) {
    pad[_tmp$3] = 128;
  } else {
    $oob();
  }
  const total = s.used < 112 ? 128 : 256;
  const low = BigInt.asUintN(64, s.lo << BigInt(3 & 63));
  const high = BigInt.asUintN(64, BigInt.asUintN(64, s.hi << BigInt(3 & 63)) | BigInt.asUintN(64, BigInt.asUintN(64, s.lo) >> BigInt(61 & 63)));
  let _tmp$4 = 0;
  while (true) {
    const i = _tmp$4;
    if (i < 8) {
      const _tmp$5 = (total - 1 | 0) - i | 0;
      const _p = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, low) >> BigInt(Math.imul(i, 8) & 63)) & 255n);
      if (_tmp$5 >>> 0 < pad.length) {
        pad[_tmp$5] = (Number(BigInt.asIntN(32, _p)) | 0) & 255;
      } else {
        $oob();
      }
      const _tmp$6 = (total - 9 | 0) - i | 0;
      const _p$2 = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, high) >> BigInt(Math.imul(i, 8) & 63)) & 255n);
      if (_tmp$6 >>> 0 < pad.length) {
        pad[_tmp$6] = (Number(BigInt.asIntN(32, _p$2)) | 0) & 255;
      } else {
        $oob();
      }
      _tmp$4 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$5 = 0;
  while (true) {
    const off = _tmp$5;
    if (off < total) {
      _M0FP412moonbitstack9mooncrypt4hash4sha211wide__block(h, pad, off);
      _tmp$5 = off + 128 | 0;
      continue;
    } else {
      break;
    }
  }
  const digest = [];
  const _bind$2 = (out + 7 | 0) / 8 | 0;
  let _tmp$6 = 0;
  while (true) {
    const i = _tmp$6;
    if (i < _bind$2) {
      let _tmp$7 = 7;
      while (true) {
        const k = _tmp$7;
        if (k >= 0) {
          const _p = BigInt.asUintN(64, BigInt.asUintN(64, BigInt.asUintN(64, i >>> 0 < h.length ? h[i] : $oob()) >> BigInt(Math.imul(k, 8) & 63)) & 255n);
          _M0MPC15array5Array4pushGyE(digest, (Number(BigInt.asIntN(32, _p)) | 0) & 255);
          _tmp$7 = k - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp$6 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$3 = _M0MPC15array9ArrayView9to__ownedGyE(_M0MPC15array5Array21clamped__view_2einnerGyE(digest, 0, out));
  return _M0MPC15bytes5Bytes11from__array(new _M0TPB9ArrayViewGyE(_bind$3, 0, _bind$3.length));
}
function _M0IP412moonbitstack9mooncrypt4hash4sha26HasherP312moonbitstack9mooncrypt4spec4Hash6finish(self) {
  const _bind = self.core;
  if (_bind.$tag === 0) {
    const _Narrow = _bind;
    const _s = _Narrow._0;
    return _M0FP412moonbitstack9mooncrypt4hash4sha214narrow__finish(_s, _M0MP412moonbitstack9mooncrypt4hash4sha24Kind4size(self.kind));
  } else {
    const _Wide = _bind;
    const _s = _Wide._0;
    return _M0FP412moonbitstack9mooncrypt4hash4sha212wide__finish(_s, _M0MP412moonbitstack9mooncrypt4hash4sha24Kind4size(self.kind));
  }
}
function _M0FP412moonbitstack9mooncrypt4hash4sha213narrow__write(s, msg) {
  const _tmp = s.n;
  const _p = msg.end - msg.start | 0;
  s.n = BigInt.asUintN(64, _tmp + BigInt.asUintN(64, BigInt(_p)));
  let at = 0;
  while (true) {
    if (at < (msg.end - msg.start | 0)) {
      const room = 64 - s.used | 0;
      const left = (msg.end - msg.start | 0) - at | 0;
      const take = room < left ? room : left;
      let _tmp$2 = 0;
      while (true) {
        const i = _tmp$2;
        if (i < take) {
          const _tmp$3 = s.buf;
          const _tmp$4 = s.used + i | 0;
          const _bind = at + i | 0;
          if (_bind < 0 || _bind >= (msg.end - msg.start | 0)) {
            $panic();
          }
          if (_tmp$4 >>> 0 < _tmp$3.length) {
            _tmp$3[_tmp$4] = msg.buf[msg.start + _bind | 0];
          } else {
            $oob();
          }
          _tmp$2 = i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      s.used = s.used + take | 0;
      at = at + take | 0;
      if (s.used === 64) {
        _M0FP412moonbitstack9mooncrypt4hash4sha213narrow__block(s.h, s.buf, 0);
        s.used = 0;
      }
      continue;
    } else {
      return;
    }
  }
}
function _M0FP412moonbitstack9mooncrypt4hash4sha211wide__write(s, msg) {
  const before = s.lo;
  const _tmp = s.lo;
  const _p = msg.end - msg.start | 0;
  s.lo = BigInt.asUintN(64, _tmp + BigInt.asUintN(64, BigInt(_p)));
  if (BigInt.asUintN(64, s.lo) < BigInt.asUintN(64, before)) {
    s.hi = BigInt.asUintN(64, s.hi + 1n);
  }
  let at = 0;
  while (true) {
    if (at < (msg.end - msg.start | 0)) {
      const room = 128 - s.used | 0;
      const left = (msg.end - msg.start | 0) - at | 0;
      const take = room < left ? room : left;
      let _tmp$2 = 0;
      while (true) {
        const i = _tmp$2;
        if (i < take) {
          const _tmp$3 = s.buf;
          const _tmp$4 = s.used + i | 0;
          const _bind = at + i | 0;
          if (_bind < 0 || _bind >= (msg.end - msg.start | 0)) {
            $panic();
          }
          if (_tmp$4 >>> 0 < _tmp$3.length) {
            _tmp$3[_tmp$4] = msg.buf[msg.start + _bind | 0];
          } else {
            $oob();
          }
          _tmp$2 = i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      s.used = s.used + take | 0;
      at = at + take | 0;
      if (s.used === 128) {
        _M0FP412moonbitstack9mooncrypt4hash4sha211wide__block(s.h, s.buf, 0);
        s.used = 0;
      }
      continue;
    } else {
      return;
    }
  }
}
function _M0IP412moonbitstack9mooncrypt4hash4sha26HasherP312moonbitstack9mooncrypt4spec4Hash5write(self, msg) {
  const _bind = self.core;
  if (_bind.$tag === 0) {
    const _Narrow = _bind;
    const _s = _Narrow._0;
    _M0FP412moonbitstack9mooncrypt4hash4sha213narrow__write(_s, msg);
    return;
  } else {
    const _Wide = _bind;
    const _s = _Wide._0;
    _M0FP412moonbitstack9mooncrypt4hash4sha211wide__write(_s, msg);
    return;
  }
}
function _M0FP212moonbitstack8moondate3pad(n, width) {
  const s = _M0MPC13int3Int18to__string_2einner(n, 10);
  if (s.length >= width) {
    return s;
  }
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  let _tmp = s.length;
  while (true) {
    const i = _tmp;
    if (i < width) {
      _M0IPB13StringBuilderPB6Logger11write__char(out, 48);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0IPB13StringBuilderPB6Logger13write__string(out, s);
  return out.val;
}
function _M0MP212moonbitstack8moondate4Date4days(self) {
  const y = self.month <= 2 ? self.year - 1 | 0 : self.year;
  const era = (y >= 0 ? y : y - 399 | 0) / 400 | 0;
  const yoe = y - (Math.imul(era, 400) | 0) | 0;
  const m = self.month;
  const doy = ((((Math.imul(153, m > 2 ? m - 3 | 0 : m + 9 | 0) | 0) + 2 | 0) / 5 | 0) + self.day | 0) - 1 | 0;
  const doe = (((Math.imul(yoe, 365) | 0) + (yoe / 4 | 0) | 0) - (yoe / 100 | 0) | 0) + doy | 0;
  return ((Math.imul(era, 146097) | 0) + doe | 0) - 719468 | 0;
}
function _M0MP212moonbitstack8moondate4Date7weekday(self) {
  const d = (_M0MP212moonbitstack8moondate4Date4days(self) + 4 | 0) % 7 | 0;
  return d < 0 ? d + 7 | 0 : d;
}
function _M0MP212moonbitstack8moondate4Date8of__days(n) {
  const z = n + 719468 | 0;
  const era = (z >= 0 ? z : z - 146096 | 0) / 146097 | 0;
  const doe = z - (Math.imul(era, 146097) | 0) | 0;
  const yoe = (((doe - (doe / 1460 | 0) | 0) + (doe / 36524 | 0) | 0) - (doe / 146096 | 0) | 0) / 365 | 0;
  const y = yoe + (Math.imul(era, 400) | 0) | 0;
  const doy = doe - (((Math.imul(365, yoe) | 0) + (yoe / 4 | 0) | 0) - (yoe / 100 | 0) | 0) | 0;
  const mp = ((Math.imul(5, doy) | 0) + 2 | 0) / 153 | 0;
  const d = (doy - (((Math.imul(153, mp) | 0) + 2 | 0) / 5 | 0) | 0) + 1 | 0;
  const m = mp < 10 ? mp + 3 | 0 : mp - 9 | 0;
  return new _M0TP212moonbitstack8moondate4Date(m <= 2 ? y + 1 | 0 : y, m, d);
}
function _M0MP212moonbitstack8moondate4Date10plus__days(self, n) {
  return _M0MP212moonbitstack8moondate4Date8of__days(_M0MP212moonbitstack8moondate4Date4days(self) + n | 0);
}
function _M0MP212moonbitstack8moondate4Date10isoweekday(self) {
  const d = _M0MP212moonbitstack8moondate4Date7weekday(self);
  return d === 0 ? 7 : d;
}
function _M0MP212moonbitstack8moondate4Date11isocalendar(self) {
  const weekday = _M0MP212moonbitstack8moondate4Date10isoweekday(self);
  const thursday = _M0MP212moonbitstack8moondate4Date10plus__days(self, 4 - weekday | 0);
  const year = thursday.year;
  const jan1 = new _M0TP212moonbitstack8moondate4Date(year, 1, 1);
  const week = ((_M0MP212moonbitstack8moondate4Date4days(thursday) - _M0MP212moonbitstack8moondate4Date4days(jan1) | 0) / 7 | 0) + 1 | 0;
  return { _0: year, _1: week, _2: weekday };
}
function _M0MP212moonbitstack8moondate4Date7yearday(self) {
  return (_M0MP212moonbitstack8moondate4Date4days(self) - _M0MP212moonbitstack8moondate4Date4days(new _M0TP212moonbitstack8moondate4Date(self.year, 1, 1)) | 0) + 1 | 0;
}
function _M0MP212moonbitstack8moondate6Moment8strftime(self, format) {
  let d;
  let t;
  let z;
  _L: {
    switch (self.$tag) {
      case 0: {
        const _Zoned = self;
        const _date = _Zoned._0;
        const _time = _Zoned._1;
        const _zone = _Zoned._2;
        d = _date;
        t = _time;
        z = _zone;
        break _L;
      }
      case 1: {
        const _Plain = self;
        const _date$2 = _Plain._0;
        const _time$2 = _Plain._1;
        d = _date$2;
        t = _time$2;
        z = undefined;
        break _L;
      }
      case 2: {
        const _Day = self;
        const _date$3 = _Day._0;
        d = _date$3;
        t = _M0FP212moonbitstack8moondate8midnight;
        z = undefined;
        break _L;
      }
      default: {
        const _Clock = self;
        const _time$3 = _Clock._0;
        d = _M0MP212moonbitstack8moondate6Moment8strftimeN6recordS3068;
        t = _time$3;
        z = undefined;
        break _L;
      }
    }
  }
  const f = _M0MPC16string10StringView9to__owned(format);
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  let i = 0;
  while (true) {
    if (i < f.length) {
      let _tmp;
      const _tmp$2 = i;
      if ((_tmp$2 >>> 0 < f.length ? f.charCodeAt(_tmp$2) : $oob()) !== 37) {
        _tmp = true;
      } else {
        _tmp = (i + 1 | 0) >= f.length;
      }
      if (_tmp) {
        const _tmp$3 = i;
        const _p = _tmp$3 >>> 0 < f.length ? f.charCodeAt(_tmp$3) : $oob();
        _M0IPB13StringBuilderPB6Logger11write__char(out, _p);
        i = i + 1 | 0;
        continue;
      }
      const _tmp$3 = i + 1 | 0;
      const _p = _tmp$3 >>> 0 < f.length ? f.charCodeAt(_tmp$3) : $oob();
      const c = _p;
      i = i + 2 | 0;
      const _bind = _M0MP212moonbitstack8moondate4Date11isocalendar(d);
      const _iso_year = _bind._0;
      const _iso_week = _bind._1;
      const _iso_day = _bind._2;
      let _tmp$4;
      switch (c) {
        case 89: {
          _tmp$4 = _M0MPC13int3Int18to__string_2einner(d.year, 10);
          break;
        }
        case 121: {
          _tmp$4 = _M0FP212moonbitstack8moondate3pad(d.year % 100 | 0, 2);
          break;
        }
        case 109: {
          _tmp$4 = _M0FP212moonbitstack8moondate3pad(d.month, 2);
          break;
        }
        case 100: {
          _tmp$4 = _M0FP212moonbitstack8moondate3pad(d.day, 2);
          break;
        }
        case 72: {
          _tmp$4 = _M0FP212moonbitstack8moondate3pad(t.hour, 2);
          break;
        }
        case 73: {
          _tmp$4 = _M0FP212moonbitstack8moondate3pad((t.hour % 12 | 0) === 0 ? 12 : t.hour % 12 | 0, 2);
          break;
        }
        case 77: {
          _tmp$4 = _M0FP212moonbitstack8moondate3pad(t.minute, 2);
          break;
        }
        case 83: {
          _tmp$4 = _M0FP212moonbitstack8moondate3pad(t.second, 2);
          break;
        }
        case 102: {
          _tmp$4 = _M0FP212moonbitstack8moondate3pad(t.nano / 1000 | 0, 6);
          break;
        }
        case 112: {
          _tmp$4 = t.hour < 12 ? "AM" : "PM";
          break;
        }
        case 106: {
          _tmp$4 = _M0FP212moonbitstack8moondate3pad(_M0MP212moonbitstack8moondate4Date7yearday(d), 3);
          break;
        }
        case 97: {
          _tmp$4 = _M0MPC15array5Array2atGUssEE(_M0FP212moonbitstack8moondate8weekdays, _M0MP212moonbitstack8moondate4Date7weekday(d));
          break;
        }
        case 65: {
          _tmp$4 = _M0MPC15array5Array2atGUssEE(_M0FP212moonbitstack8moondate10long__days, _M0MP212moonbitstack8moondate4Date7weekday(d));
          break;
        }
        case 98: {
          _tmp$4 = _M0MPC15array5Array2atGUssEE(_M0FP212moonbitstack8moondate6months, d.month - 1 | 0);
          break;
        }
        case 66: {
          _tmp$4 = _M0MPC15array5Array2atGUssEE(_M0FP212moonbitstack8moondate12long__months, d.month - 1 | 0);
          break;
        }
        case 71: {
          _tmp$4 = _M0MPC13int3Int18to__string_2einner(_iso_year, 10);
          break;
        }
        case 86: {
          _tmp$4 = _M0FP212moonbitstack8moondate3pad(_iso_week, 2);
          break;
        }
        case 117: {
          _tmp$4 = _M0MPC13int3Int18to__string_2einner(_iso_day, 10);
          break;
        }
        case 119: {
          _tmp$4 = _M0MPC13int3Int18to__string_2einner(_M0MP212moonbitstack8moondate4Date7weekday(d), 10);
          break;
        }
        case 122: {
          if (z === undefined) {
            _tmp$4 = "";
          } else {
            const _Some = z;
            const _x = _Some;
            if (_x.$tag === 0) {
              _tmp$4 = "+0000";
            } else {
              const _Offset = _x;
              const _m = _Offset._0;
              const sign = _m < 0 ? "-" : "+";
              const a = _m < 0 ? -_m | 0 : _m;
              _tmp$4 = `${sign}${_M0FP212moonbitstack8moondate3pad(a / 60 | 0, 2)}${_M0FP212moonbitstack8moondate3pad(a % 60 | 0, 2)}`;
            }
          }
          break;
        }
        case 90: {
          _tmp$4 = z === undefined ? "" : "UTC";
          break;
        }
        case 37: {
          _tmp$4 = "%";
          break;
        }
        default: {
          _tmp$4 = `%${_M0IPC14char4CharPB4Show10to__string(c)}`;
        }
      }
      _M0IPB13StringBuilderPB6Logger13write__string(out, _tmp$4);
      continue;
    } else {
      break;
    }
  }
  return out.val;
}
function _M0FP312moonbitstack8moonmime2qp8qp__safe(b) {
  const n = b;
  return n >= 33 && (n <= 126 && n !== 61) || (n === 32 || n === 9);
}
function _M0FP312moonbitstack8moonmime2qp13is__wsp__byte(b) {
  return b === 32 || b === 9;
}
function _M0FP312moonbitstack8moonmime2qp13trailing__wsp(data, at) {
  let i = at;
  while (true) {
    if (i < (data.end - data.start | 0)) {
      const _bind = i;
      if (_bind < 0 || _bind >= (data.end - data.start | 0)) {
        $panic();
      }
      const b = data.buf[data.start + _bind | 0];
      if (b === 13 || b === 10) {
        return true;
      }
      if (!_M0FP312moonbitstack8moonmime2qp13is__wsp__byte(b)) {
        return false;
      }
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0FP312moonbitstack8moonmime2qp10hex__digit(n) {
  return n < 10 ? 48 + n | 0 : (65 + n | 0) - 10 | 0;
}
function _M0FP312moonbitstack8moonmime2qp6encode(data) {
  const out = _M0MPC16buffer6Buffer14Buffer_2einner(0);
  const n = data.end - data.start | 0;
  let col = 0;
  let i = 0;
  while (true) {
    if (i < n) {
      const _bind = i;
      if (_bind < 0 || _bind >= (data.end - data.start | 0)) {
        $panic();
      }
      const b = data.buf[data.start + _bind | 0];
      if (b === 13 || b === 10) {
        _M0MPC16buffer6Buffer19write__string__utf8(out, _M0FP312moonbitstack8moonmime2qp6encodeN6recordS3112);
        col = 0;
        let _tmp;
        if (b === 13) {
          let _tmp$2;
          if ((i + 1 | 0) < n) {
            const _bind$2 = i + 1 | 0;
            if (_bind$2 < 0 || _bind$2 >= (data.end - data.start | 0)) {
              $panic();
            }
            _tmp$2 = data.buf[data.start + _bind$2 | 0] === 10;
          } else {
            _tmp$2 = false;
          }
          _tmp = _tmp$2;
        } else {
          _tmp = false;
        }
        if (_tmp) {
          i = i + 2 | 0;
        } else {
          i = i + 1 | 0;
        }
        continue;
      }
      let piece;
      if (_M0FP312moonbitstack8moonmime2qp8qp__safe(b) && !_M0FP312moonbitstack8moonmime2qp13trailing__wsp(data, i)) {
        const one = _M0MPC16buffer6Buffer14Buffer_2einner(0);
        _M0MPC16buffer6Buffer11write__byte(one, b);
        piece = _M0MPC16buffer6Buffer9to__bytes(one);
      } else {
        const upper = _M0FP312moonbitstack8moonmime2qp10hex__digit(b / 16 | 0);
        const lower = _M0FP312moonbitstack8moonmime2qp10hex__digit(b % 16 | 0);
        const _bind$2 = `=${_M0IPC14char4CharPB4Show10to__string(upper)}${_M0IPC14char4CharPB4Show10to__string(lower)}`;
        piece = _M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(_bind$2, 0, _bind$2.length), false);
      }
      if ((col + piece.length | 0) > 75) {
        _M0MPC16buffer6Buffer19write__string__utf8(out, _M0FP312moonbitstack8moonmime2qp6encodeN6recordS3113);
        col = 0;
      }
      _M0MPC16buffer6Buffer12write__bytes(out, new _M0TPC15bytes9BytesView(piece, 0, piece.length));
      col = col + piece.length | 0;
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0MPC16buffer6Buffer9to__bytes(out);
}
function _M0FP312moonbitstack8moonmime2qp10hex__value(c) {
  return c >= 48 && c <= 57 ? c - 48 | 0 : c >= 97 && c <= 102 ? (c - 97 | 0) + 10 | 0 : c >= 65 && c <= 70 ? (c - 65 | 0) + 10 | 0 : undefined;
}
function _M0FP312moonbitstack8moonmime2qp14decode_2einner(data, strict) {
  const out = _M0MPC16buffer6Buffer14Buffer_2einner(0);
  const n = data.end - data.start | 0;
  let i = 0;
  while (true) {
    if (i < n) {
      const _bind = i;
      if (_bind < 0 || _bind >= (data.end - data.start | 0)) {
        $panic();
      }
      const b = data.buf[data.start + _bind | 0];
      if (b === 13 || b === 10) {
        let _tmp;
        if (b === 13) {
          let _tmp$2;
          if ((i + 1 | 0) < n) {
            const _bind$2 = i + 1 | 0;
            if (_bind$2 < 0 || _bind$2 >= (data.end - data.start | 0)) {
              $panic();
            }
            _tmp$2 = data.buf[data.start + _bind$2 | 0] === 10;
          } else {
            _tmp$2 = false;
          }
          _tmp = _tmp$2;
        } else {
          _tmp = false;
        }
        if (_tmp) {
          _M0MPC16buffer6Buffer19write__string__utf8(out, _M0FP312moonbitstack8moonmime2qp14decode_2einnerN6recordS3129);
          i = i + 2 | 0;
        } else {
          _M0MPC16buffer6Buffer19write__string__utf8(out, _M0FP312moonbitstack8moonmime2qp14decode_2einnerN6recordS3130);
          i = i + 1 | 0;
        }
        continue;
      }
      if (_M0FP312moonbitstack8moonmime2qp13is__wsp__byte(b)) {
        if (_M0FP312moonbitstack8moonmime2qp13trailing__wsp(data, i)) {
          while (true) {
            if (i < n) {
              const _bind$2 = i;
              if (_bind$2 < 0 || _bind$2 >= (data.end - data.start | 0)) {
                $panic();
              }
              const c = data.buf[data.start + _bind$2 | 0];
              if (c === 13 || c === 10) {
                break;
              }
              i = i + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          continue;
        }
        _M0MPC16buffer6Buffer11write__byte(out, b);
        i = i + 1 | 0;
        continue;
      }
      if (b === 61) {
        let j = i + 1 | 0;
        while (true) {
          let _tmp;
          if (j < n) {
            const _bind$2 = j;
            if (_bind$2 < 0 || _bind$2 >= (data.end - data.start | 0)) {
              $panic();
            }
            _tmp = _M0FP312moonbitstack8moonmime2qp13is__wsp__byte(data.buf[data.start + _bind$2 | 0]);
          } else {
            _tmp = false;
          }
          if (_tmp) {
            j = j + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        let _tmp;
        if (j < n) {
          let _tmp$2;
          const _bind$2 = j;
          if (_bind$2 < 0 || _bind$2 >= (data.end - data.start | 0)) {
            $panic();
          }
          if (data.buf[data.start + _bind$2 | 0] === 13) {
            _tmp$2 = true;
          } else {
            const _bind$3 = j;
            if (_bind$3 < 0 || _bind$3 >= (data.end - data.start | 0)) {
              $panic();
            }
            _tmp$2 = data.buf[data.start + _bind$3 | 0] === 10;
          }
          _tmp = _tmp$2;
        } else {
          _tmp = false;
        }
        if (_tmp) {
          let _tmp$2;
          const _bind$2 = j;
          if (_bind$2 < 0 || _bind$2 >= (data.end - data.start | 0)) {
            $panic();
          }
          if (data.buf[data.start + _bind$2 | 0] === 13) {
            let _tmp$3;
            if ((j + 1 | 0) < n) {
              const _bind$3 = j + 1 | 0;
              if (_bind$3 < 0 || _bind$3 >= (data.end - data.start | 0)) {
                $panic();
              }
              _tmp$3 = data.buf[data.start + _bind$3 | 0] === 10;
            } else {
              _tmp$3 = false;
            }
            _tmp$2 = _tmp$3;
          } else {
            _tmp$2 = false;
          }
          if (_tmp$2) {
            i = j + 2 | 0;
          } else {
            i = j + 1 | 0;
          }
          continue;
        }
        const rest = (data.end - data.start | 0) - i | 0;
        if (rest >= 3) {
          const _bind$2 = i + 1 | 0;
          if (_bind$2 < 0 || _bind$2 >= (data.end - data.start | 0)) {
            $panic();
          }
          const _p = data.buf[data.start + _bind$2 | 0];
          const high = _M0FP312moonbitstack8moonmime2qp10hex__value(_p);
          const _bind$3 = i + 2 | 0;
          if (_bind$3 < 0 || _bind$3 >= (data.end - data.start | 0)) {
            $panic();
          }
          const _p$2 = data.buf[data.start + _bind$3 | 0];
          const low = _M0FP312moonbitstack8moonmime2qp10hex__value(_p$2);
          _L: {
            if (high === undefined) {
              break _L;
            } else {
              const _Some = high;
              const _h = _Some;
              if (low === undefined) {
                break _L;
              } else {
                const _Some$2 = low;
                const _l = _Some$2;
                _M0MPC16buffer6Buffer11write__byte(out, ((Math.imul(_h, 16) | 0) + _l | 0) & 255);
                i = i + 3 | 0;
                continue;
              }
            }
          }
          if (strict) {
            return new _M0DTPC16result6ResultGzRP312moonbitstack8moonmime2qp7RefusedE3Err(new _M0DTPC15error5Error50moonbitstack_2fmoonmime_2fqp_2eRefused_2eMalformed(i));
          } else {
            _M0MPC16buffer6Buffer11write__byte(out, b);
            i = i + 1 | 0;
          }
          continue;
        }
        if (strict) {
          return new _M0DTPC16result6ResultGzRP312moonbitstack8moonmime2qp7RefusedE3Err(new _M0DTPC15error5Error50moonbitstack_2fmoonmime_2fqp_2eRefused_2eMalformed(i));
        }
        _M0MPC16buffer6Buffer11write__byte(out, b);
        i = i + 1 | 0;
        continue;
      }
      _M0MPC16buffer6Buffer11write__byte(out, b);
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGzRP312moonbitstack8moonmime2qp7RefusedE2Ok(_M0MPC16buffer6Buffer9to__bytes(out));
}
function _M0MP212moonbitstack8moonmime12WordEncoding6letter(self) {
  if (self === 0) {
    return 66;
  } else {
    return 81;
  }
}
function _M0FP212moonbitstack8moonmime10hex__digit(n) {
  if (n < 10) {
    const _p = 48;
    return _p + n | 0;
  } else {
    const _p = 65;
    return (_p + n | 0) - 10 | 0;
  }
}
function _M0FP212moonbitstack8moonmime9is__alpha(c) {
  return c >= 97 && c <= 122 || c >= 65 && c <= 90;
}
function _M0FP212moonbitstack8moonmime15q__word__encode(data) {
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  const _bind = data.end - data.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = data.buf[data.start + _ | 0];
      const c = b;
      if (_M0FP212moonbitstack8moonmime9is__alpha(c) || c >= 48 && c <= 57) {
        _M0IPB13StringBuilderPB6Logger11write__char(out, c);
      } else {
        if (c === 32) {
          _M0IPB13StringBuilderPB6Logger11write__char(out, 95);
        } else {
          if (c === 45 || (c === 33 || (c === 42 || (c === 43 || c === 47)))) {
            _M0IPB13StringBuilderPB6Logger11write__char(out, c);
          } else {
            const n = b;
            _M0IPB13StringBuilderPB6Logger11write__char(out, 61);
            _M0IPB13StringBuilderPB6Logger11write__char(out, _M0FP212moonbitstack8moonmime10hex__digit(n / 16 | 0));
            _M0IPB13StringBuilderPB6Logger11write__char(out, _M0FP212moonbitstack8moonmime10hex__digit(n % 16 | 0));
          }
        }
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return out.val;
}
function _M0FP212moonbitstack8moonmime10word__body(data, encoding) {
  if (encoding === 0) {
    return _M0FP312moonbitstack8moonbase6base646encode(data, undefined, -1);
  } else {
    return _M0FP212moonbitstack8moonmime15q__word__encode(data);
  }
}
function _M0FP212moonbitstack8moonmime10wrap__word(data, charset, encoding) {
  return `=?${_M0MPC16string10StringView9to__owned(charset)}?${_M0IPC14char4CharPB4Show10to__string(_M0MP212moonbitstack8moonmime12WordEncoding6letter(encoding))}?${_M0FP212moonbitstack8moonmime10word__body(data, encoding)}?=`;
}
function _M0FP212moonbitstack8moonmime7builtin(name) {
  _L: {
    _L$2: {
      _L$3: {
        switch (name) {
          case "utf-8": {
            break _L$3;
          }
          case "utf8": {
            break _L$3;
          }
          case "us-ascii": {
            break _L$2;
          }
          case "ascii": {
            break _L$2;
          }
          case "iso-8859-1": {
            break _L;
          }
          case "latin1": {
            break _L;
          }
          case "l1": {
            break _L;
          }
          default: {
            return undefined;
          }
        }
      }
      return { self: undefined, method_table: _M0FP074moonbitstack_2fmoonmime_2fUtf8_24as_24_40moonbitstack_2fmoonmime_2eCharset };
    }
    return { self: undefined, method_table: _M0FP075moonbitstack_2fmoonmime_2fAscii_24as_24_40moonbitstack_2fmoonmime_2eCharset };
  }
  return { self: undefined, method_table: _M0FP076moonbitstack_2fmoonmime_2fLatin1_24as_24_40moonbitstack_2fmoonmime_2eCharset };
}
function _M0FP212moonbitstack8moonmime5lower(s) {
  return _M0MPC16string6String9to__lower(_M0MPC16string10StringView9to__owned(s));
}
function _M0FP212moonbitstack8moonmime6lookup(name, charsets) {
  const known = _M0FP212moonbitstack8moonmime5lower(name);
  if (charsets === undefined) {
  } else {
    const _Some = charsets;
    const _map = _Some;
    const _bind = _M0MPB3Map3getGsRP212moonbitstack8moonmime7CharsetE(_map, known);
    if (_bind === undefined) {
    } else {
      const _Some$2 = _bind;
      const _codec = _Some$2;
      return new _M0DTPC16result6ResultGRP212moonbitstack8moonmime7CharsetRP212moonbitstack8moonmime7RefusedE2Ok(_codec);
    }
  }
  return _M0MPC16option6Option17unwrap__or__errorGRP212moonbitstack8moonmime7CharsetRP212moonbitstack8moonmime7RefusedE(_M0FP212moonbitstack8moonmime7builtin(known), new _M0DTPC15error5Error43moonbitstack_2fmoonmime_2eRefused_2eCharset(known));
}
function _M0FP212moonbitstack8moonmime15encode__charset(name, text, charsets) {
  const _bind = _M0FP212moonbitstack8moonmime6lookup(name, charsets);
  let _tmp;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _tmp = _ok._0;
  } else {
    return _bind;
  }
  const _tmp$2 = _tmp;
  return _tmp$2.method_table.method_1(_tmp$2.self, text);
}
function _M0FP212moonbitstack8moonmime14word__capacity(charset, encoding) {
  const budget = 75 - (7 + (charset.end - charset.start | 0) | 0) | 0;
  const room = budget < 1 ? 1 : budget;
  if (encoding === 0) {
    const per = Math.imul(room / 4 | 0, 3) | 0;
    return per < 3 ? 3 : per;
  } else {
    return room < 3 ? 1 : room;
  }
}
function _M0FP212moonbitstack8moonmime22is__continuation__byte(b) {
  const n = b;
  return n >= 128 && n <= 191;
}
function _M0FP212moonbitstack8moonmime12word__slices(data, charset, encoding) {
  const step = _M0FP212moonbitstack8moonmime14word__capacity(charset, encoding);
  const name = _M0FP212moonbitstack8moonmime5lower(charset);
  const utf8 = name === "utf-8" || name === "utf8";
  const slices = [];
  if (encoding === 0) {
    let at = 0;
    while (true) {
      if (at < (data.end - data.start | 0)) {
        let stop = at + step | 0;
        if (stop > (data.end - data.start | 0)) {
          stop = data.end - data.start | 0;
        }
        if (utf8) {
          while (true) {
            let _tmp;
            if (stop < (data.end - data.start | 0)) {
              let _tmp$2;
              if (stop > at) {
                const _bind = stop;
                if (_bind < 0 || _bind >= (data.end - data.start | 0)) {
                  $panic();
                }
                _tmp$2 = _M0FP212moonbitstack8moonmime22is__continuation__byte(data.buf[data.start + _bind | 0]);
              } else {
                _tmp$2 = false;
              }
              _tmp = _tmp$2;
            } else {
              _tmp = false;
            }
            if (_tmp) {
              stop = stop - 1 | 0;
              continue;
            } else {
              break;
            }
          }
        }
        _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(slices, _M0MPC15bytes9BytesView9to__owned(_M0MPC15bytes9BytesView21clamped__view_2einner(data, at, stop)));
        at = stop;
        continue;
      } else {
        break;
      }
    }
  } else {
    let start = 0;
    while (true) {
      if (start < (data.end - data.start | 0)) {
        let stop = start;
        let width = 0;
        while (true) {
          if (stop < (data.end - data.start | 0)) {
            const piece = _M0FP212moonbitstack8moonmime15q__word__encode(_M0MPC15bytes9BytesView21clamped__view_2einner(data, stop, stop + 1 | 0)).length;
            if ((width + piece | 0) > step && stop > start) {
              break;
            }
            width = width + piece | 0;
            stop = stop + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        if (stop === start) {
          stop = (start + 1 | 0) > (data.end - data.start | 0) ? data.end - data.start | 0 : start + 1 | 0;
        }
        _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(slices, _M0MPC15bytes9BytesView9to__owned(_M0MPC15bytes9BytesView21clamped__view_2einner(data, start, stop)));
        start = stop;
        continue;
      } else {
        break;
      }
    }
  }
  return slices;
}
function _M0FP212moonbitstack8moonmime20is__ascii__printable(s) {
  const _p = s.str;
  const _p$2 = s.start;
  const _p$3 = s.end;
  let _tmp = _p$2;
  while (true) {
    const _p$4 = _tmp;
    if (_p$4 < _p$3) {
      let _p$5;
      let _p$6;
      _L: {
        const _p$7 = _p.charCodeAt(_p$4);
        if (_p$7 >= 55296 && _p$7 <= 56319 && (_p$4 + 1 | 0) < _p$3) {
          const _p$8 = _p.charCodeAt(_p$4 + 1 | 0);
          if (_p$8 >= 56320 && _p$8 <= 57343) {
            const _tmp$2 = _p$4 + 2 | 0;
            const _p$9 = (((Math.imul(_p$7 - 55296 | 0, 1024) | 0) + _p$8 | 0) - 56320 | 0) + 65536 | 0;
            _p$5 = _tmp$2;
            _p$6 = _p$9;
            break _L;
          } else {
            const _tmp$2 = _p$4 + 1 | 0;
            const _p$9 = _p$7;
            _p$5 = _tmp$2;
            _p$6 = _p$9;
            break _L;
          }
        } else {
          const _tmp$2 = _p$4 + 1 | 0;
          const _p$8 = _p$7;
          _p$5 = _tmp$2;
          _p$6 = _p$8;
          break _L;
        }
      }
      if (!(_p$6 >= 32 && _p$6 <= 126)) {
        return false;
      }
      _tmp = _p$5;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0FP212moonbitstack8moonmime21encode__words_2einner(text, charset, encoding, column, max, charsets) {
  if ((text.end - text.start | 0) === 0 || _M0FP212moonbitstack8moonmime20is__ascii__printable(text)) {
    return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmime7RefusedE2Ok(_M0MPC16string10StringView9to__owned(text));
  }
  const _bind = _M0FP212moonbitstack8moonmime15encode__charset(new _M0TPC16string10StringView(charset, 0, charset.length), text, charsets);
  let data;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    data = _ok._0;
  } else {
    return _bind;
  }
  const slices = _M0FP212moonbitstack8moonmime12word__slices(new _M0TPC15bytes9BytesView(data, 0, data.length), new _M0TPC16string10StringView(charset, 0, charset.length), encoding);
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  let col = column;
  let first = true;
  const _bind$2 = slices.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const slice = slices[_];
      const word = _M0FP212moonbitstack8moonmime10wrap__word(new _M0TPC15bytes9BytesView(slice, 0, slice.length), new _M0TPC16string10StringView(charset, 0, charset.length), encoding);
      if (first) {
        first = false;
      } else {
        if (((col + 1 | 0) + word.length | 0) <= max) {
          _M0IPB13StringBuilderPB6Logger11write__char(out, 32);
          col = col + 1 | 0;
        } else {
          _M0IPB13StringBuilderPB6Logger13write__string(out, "\r\n ");
          col = 1;
        }
      }
      _M0IPB13StringBuilderPB6Logger13write__string(out, word);
      col = col + word.length | 0;
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmime7RefusedE2Ok(out.val);
}
function _M0FP212moonbitstack8moonmime13encode__words(text, charset$46$opt, encoding$46$opt, column$46$opt, max$46$opt, charsets) {
  let charset;
  if (charset$46$opt === undefined) {
    charset = "utf-8";
  } else {
    const _Some = charset$46$opt;
    charset = _Some;
  }
  let encoding;
  if (encoding$46$opt === undefined) {
    encoding = 0;
  } else {
    const _Some = encoding$46$opt;
    encoding = _Some;
  }
  let column;
  if (column$46$opt === undefined) {
    column = 0;
  } else {
    const _Some = column$46$opt;
    column = _Some;
  }
  let max;
  if (max$46$opt === undefined) {
    max = 76;
  } else {
    const _Some = max$46$opt;
    max = _Some;
  }
  return _M0FP212moonbitstack8moonmime21encode__words_2einner(text, charset, encoding, column, max, charsets);
}
function _M0FP212moonbitstack8moonmime10take__word(chars, at) {
  const n = chars.end - chars.start | 0;
  if ((at + 2 | 0) > n) {
    return undefined;
  }
  let _tmp;
  if (at < 0 || at >= (chars.end - chars.start | 0)) {
    $panic();
  }
  if (chars.buf[chars.start + at | 0] !== 61) {
    _tmp = true;
  } else {
    const _bind = at + 1 | 0;
    if (_bind < 0 || _bind >= (chars.end - chars.start | 0)) {
      $panic();
    }
    _tmp = chars.buf[chars.start + _bind | 0] !== 63;
  }
  if (_tmp) {
    return undefined;
  }
  const name = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  let i = at + 2 | 0;
  while (true) {
    if (i < n) {
      const _bind = i;
      if (_bind < 0 || _bind >= (chars.end - chars.start | 0)) {
        $panic();
      }
      const c = chars.buf[chars.start + _bind | 0];
      if (c === 63) {
        break;
      }
      if (c === 32 || c === 9) {
        return undefined;
      }
      _M0IPB13StringBuilderPB6Logger11write__char(name, c);
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const charset = name.val;
  if (charset === "") {
    return undefined;
  }
  if ((i + 3 | 0) >= n) {
    return undefined;
  }
  let encoding;
  _L: {
    _L$2: {
      _L$3: {
        _L$4: {
          const _bind = i + 1 | 0;
          if (_bind < 0 || _bind >= (chars.end - chars.start | 0)) {
            $panic();
          }
          const _bind$2 = chars.buf[chars.start + _bind | 0];
          switch (_bind$2) {
            case 66: {
              break _L$4;
            }
            case 98: {
              break _L$4;
            }
            case 81: {
              break _L$2;
            }
            case 113: {
              break _L$2;
            }
            default: {
              encoding = undefined;
            }
          }
          break _L$3;
        }
        encoding = _M0FP212moonbitstack8moonmime10take__wordN6constrS3359;
      }
      break _L;
    }
    encoding = _M0FP212moonbitstack8moonmime10take__wordN6constrS3358;
  }
  if (encoding === undefined) {
    return undefined;
  }
  let encoding$2;
  if (encoding === undefined) {
    encoding$2 = $panic();
  } else {
    const _p = encoding;
    encoding$2 = _p;
  }
  const _bind = i + 2 | 0;
  if (_bind < 0 || _bind >= (chars.end - chars.start | 0)) {
    $panic();
  }
  if (chars.buf[chars.start + _bind | 0] !== 63) {
    return undefined;
  }
  const body = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  let j = i + 3 | 0;
  while (true) {
    if ((j + 1 | 0) < n) {
      let _tmp$2;
      const _bind$2 = j;
      if (_bind$2 < 0 || _bind$2 >= (chars.end - chars.start | 0)) {
        $panic();
      }
      if (chars.buf[chars.start + _bind$2 | 0] === 63) {
        const _bind$3 = j + 1 | 0;
        if (_bind$3 < 0 || _bind$3 >= (chars.end - chars.start | 0)) {
          $panic();
        }
        _tmp$2 = chars.buf[chars.start + _bind$3 | 0] === 61;
      } else {
        _tmp$2 = false;
      }
      if (_tmp$2) {
        break;
      }
      const _bind$3 = j;
      if (_bind$3 < 0 || _bind$3 >= (chars.end - chars.start | 0)) {
        $panic();
      }
      _M0IPB13StringBuilderPB6Logger11write__char(body, chars.buf[chars.start + _bind$3 | 0]);
      j = j + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if ((j + 1 | 0) >= n) {
    return undefined;
  }
  const text = body.val;
  let octets;
  if (encoding$2 === 0) {
    let _try_err;
    _L$2: {
      _L$3: {
        const _bind$2 = _M0FP312moonbitstack8moonbase6base646decode(new _M0TPC16string10StringView(text, 0, text.length), undefined, _M0FP212moonbitstack8moonmime10take__wordN6constrS3360, -1);
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          octets = _ok._0;
        } else {
          const _err = _bind$2;
          _try_err = _err._0;
          break _L$3;
        }
        break _L$2;
      }
      octets = undefined;
    }
  } else {
    let _try_err;
    _L$2: {
      _L$3: {
        let replaced = "";
        const _bind$2 = text.length;
        let _tmp$2 = 0;
        while (true) {
          const _string_index = _tmp$2;
          if (_string_index < _bind$2) {
            let _decoded_next_string_index;
            let _decoded_char;
            _L$4: {
              const _bind$3 = text.charCodeAt(_string_index);
              if (_bind$3 >= 55296 && _bind$3 <= 56319 && (_string_index + 1 | 0) < _bind$2) {
                const _bind$4 = text.charCodeAt(_string_index + 1 | 0);
                if (_bind$4 >= 56320 && _bind$4 <= 57343) {
                  const _tmp$3 = _string_index + 2 | 0;
                  const _p = (((Math.imul(_bind$3 - 55296 | 0, 1024) | 0) + _bind$4 | 0) - 56320 | 0) + 65536 | 0;
                  _decoded_next_string_index = _tmp$3;
                  _decoded_char = _p;
                  break _L$4;
                } else {
                  const _tmp$3 = _string_index + 1 | 0;
                  const _p = _bind$3;
                  _decoded_next_string_index = _tmp$3;
                  _decoded_char = _p;
                  break _L$4;
                }
              } else {
                const _tmp$3 = _string_index + 1 | 0;
                const _p = _bind$3;
                _decoded_next_string_index = _tmp$3;
                _decoded_char = _p;
                break _L$4;
              }
            }
            replaced = `${replaced}${_decoded_char === 95 ? " " : _M0IPC14char4CharPB4Show10to__string(_decoded_char)}`;
            _tmp$2 = _decoded_next_string_index;
            continue;
          } else {
            break;
          }
        }
        const _bind$3 = replaced;
        const _bind$4 = _M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(_bind$3, 0, _bind$3.length), false);
        const _bind$5 = _M0FP312moonbitstack8moonmime2qp14decode_2einner(new _M0TPC15bytes9BytesView(_bind$4, 0, _bind$4.length), false);
        if (_bind$5.$tag === 1) {
          const _ok = _bind$5;
          octets = _ok._0;
        } else {
          const _err = _bind$5;
          _try_err = _err._0;
          break _L$3;
        }
        break _L$2;
      }
      octets = undefined;
    }
  }
  if (octets === undefined) {
    return undefined;
  }
  let _tmp$2;
  if (octets === undefined) {
    _tmp$2 = $panic();
  } else {
    const _p = octets;
    _tmp$2 = _p;
  }
  return { _0: charset, _1: encoding$2, _2: _tmp$2, _3: j + 2 | 0 };
}
function _M0FP212moonbitstack8moonmime15decode__charset(name, data, charsets) {
  const _bind = _M0FP212moonbitstack8moonmime6lookup(name, charsets);
  let _tmp;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _tmp = _ok._0;
  } else {
    return _bind;
  }
  const _tmp$2 = _tmp;
  return _tmp$2.method_table.method_0(_tmp$2.self, data);
}
function _M0FP212moonbitstack8moonmime12latin1__text(data) {
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  const _bind = data.end - data.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = data.buf[data.start + _ | 0];
      _M0IPB13StringBuilderPB6Logger11write__char(out, b);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return out.val;
}
function _M0FP212moonbitstack8moonmime13write__spaces(out, count) {
  let left = count;
  while (true) {
    if (left > 0) {
      _M0IPB13StringBuilderPB6Logger11write__char(out, 32);
      left = left - 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP212moonbitstack8moonmime13decode__words(value, charsets) {
  const chars = _M0MPC16string6String9to__array(_M0MPC16string10StringView9to__owned(value));
  const n = chars.length;
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  let pending = 0;
  let after_word = false;
  let i = 0;
  while (true) {
    if (i < n) {
      const c = _M0MPC15array5Array2atGcE(chars, i);
      if (c === 61 && ((i + 1 | 0) < n && _M0MPC15array5Array2atGcE(chars, i + 1 | 0) === 63)) {
        const _bind = _M0FP212moonbitstack8moonmime10take__word(new _M0TPB9ArrayViewGcE(chars, 0, chars.length), i);
        if (_bind === undefined) {
          _M0FP212moonbitstack8moonmime13write__spaces(out, pending);
          pending = 0;
          _M0IPB13StringBuilderPB6Logger11write__char(out, c);
          after_word = false;
          i = i + 1 | 0;
          continue;
        } else {
          const _Some = _bind;
          const _x = _Some;
          const _charset = _x._0;
          const _octets = _x._2;
          const _stop = _x._3;
          if (!after_word) {
            const _bind$2 = pending;
            let _tmp = 0;
            while (true) {
              const _k = _tmp;
              if (_k < _bind$2) {
                _M0IPB13StringBuilderPB6Logger11write__char(out, 32);
                _tmp = _k + 1 | 0;
                continue;
              } else {
                break;
              }
            }
          }
          pending = 0;
          let text;
          let _try_err;
          _L: {
            _L$2: {
              const _bind$2 = _M0FP212moonbitstack8moonmime15decode__charset(new _M0TPC16string10StringView(_charset, 0, _charset.length), new _M0TPC15bytes9BytesView(_octets, 0, _octets.length), charsets);
              if (_bind$2.$tag === 1) {
                const _ok = _bind$2;
                text = _ok._0;
              } else {
                const _err = _bind$2;
                _try_err = _err._0;
                break _L$2;
              }
              break _L;
            }
            text = _M0FP212moonbitstack8moonmime12latin1__text(new _M0TPC15bytes9BytesView(_octets, 0, _octets.length));
          }
          _M0IPB13StringBuilderPB6Logger13write__string(out, text);
          after_word = true;
          i = _stop;
          continue;
        }
      }
      if (c === 32 || c === 9 || (c === 13 || c === 10)) {
        pending = pending + 1 | 0;
        i = i + 1 | 0;
        continue;
      }
      _M0FP212moonbitstack8moonmime13write__spaces(out, pending);
      pending = 0;
      _M0IPB13StringBuilderPB6Logger11write__char(out, c);
      after_word = false;
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0FP212moonbitstack8moonmime13write__spaces(out, pending);
  return out.val;
}
function _M0FP212moonbitstack8moonmime11guess__type(filename) {
  const lower = _M0MPC16string10StringView9to__lower(filename);
  let dot = -1;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < (lower.end - lower.start | 0)) {
      if (i < 0 || i >= (lower.end - lower.start | 0)) {
        $panic();
      }
      if (lower.str.charCodeAt(lower.start + i | 0) === 46) {
        dot = i;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (dot < 0 || dot === ((lower.end - lower.start | 0) - 1 | 0)) {
    return _M0FP212moonbitstack8moonmime8fallback;
  }
  const ext = _M0MPC16string10StringView21clamped__view_2einner(lower, dot + 1 | 0, undefined);
  const _bind = _M0FP212moonbitstack8moonmime5types.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind) {
      const pair = _M0FP212moonbitstack8moonmime5types[_];
      const _bind$2 = pair._0;
      if (_M0IPC16string10StringViewPB2Eq5equal(new _M0TPC16string10StringView(_bind$2, 0, _bind$2.length), ext)) {
        return pair._1;
      }
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0FP212moonbitstack8moonmime8fallback;
}
function _M0FP212moonbitstack8moonmime11index__char(s, needle, from) {
  let _tmp = from;
  while (true) {
    const i = _tmp;
    if (i < (s.end - s.start | 0)) {
      if (i < 0 || i >= (s.end - s.start | 0)) {
        $panic();
      }
      if (s.str.charCodeAt(s.start + i | 0) === needle) {
        return i;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return -1;
}
function _M0FP212moonbitstack8moonmime9is__space(c) {
  return c === 32 || (c === 9 || (c === 13 || c === 10));
}
function _M0FP212moonbitstack8moonmime4trim(s) {
  let from = 0;
  let to = s.end - s.start | 0;
  while (true) {
    let _tmp;
    if (from < to) {
      const _bind = from;
      if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
        $panic();
      }
      _tmp = _M0FP212moonbitstack8moonmime9is__space(s.str.charCodeAt(s.start + _bind | 0));
    } else {
      _tmp = false;
    }
    if (_tmp) {
      from = from + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  while (true) {
    let _tmp;
    if (to > from) {
      const _bind = to - 1 | 0;
      if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
        $panic();
      }
      _tmp = _M0FP212moonbitstack8moonmime9is__space(s.str.charCodeAt(s.start + _bind | 0));
    } else {
      _tmp = false;
    }
    if (_tmp) {
      to = to - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0MPC16string10StringView9to__owned(_M0MPC16string10StringView21clamped__view_2einner(s, from, to));
}
function _M0FP212moonbitstack8moonmime13parse__params(s) {
  const out = [];
  const n = s.end - s.start | 0;
  let i = 0;
  while (true) {
    if (i < n) {
      while (true) {
        let _tmp;
        if (i < n) {
          let _tmp$2;
          const _bind = i;
          if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
            $panic();
          }
          if (_M0FP212moonbitstack8moonmime9is__space(s.str.charCodeAt(s.start + _bind | 0))) {
            _tmp$2 = true;
          } else {
            const _bind$2 = i;
            if (_bind$2 < 0 || _bind$2 >= (s.end - s.start | 0)) {
              $panic();
            }
            _tmp$2 = s.str.charCodeAt(s.start + _bind$2 | 0) === 59;
          }
          _tmp = _tmp$2;
        } else {
          _tmp = false;
        }
        if (_tmp) {
          i = i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      const name_start = i;
      while (true) {
        let _tmp;
        if (i < n) {
          let _tmp$2;
          const _bind = i;
          if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
            $panic();
          }
          if (s.str.charCodeAt(s.start + _bind | 0) !== 61) {
            let _tmp$3;
            const _bind$2 = i;
            if (_bind$2 < 0 || _bind$2 >= (s.end - s.start | 0)) {
              $panic();
            }
            if (s.str.charCodeAt(s.start + _bind$2 | 0) !== 59) {
              const _bind$3 = i;
              if (_bind$3 < 0 || _bind$3 >= (s.end - s.start | 0)) {
                $panic();
              }
              _tmp$3 = !_M0FP212moonbitstack8moonmime9is__space(s.str.charCodeAt(s.start + _bind$3 | 0));
            } else {
              _tmp$3 = false;
            }
            _tmp$2 = _tmp$3;
          } else {
            _tmp$2 = false;
          }
          _tmp = _tmp$2;
        } else {
          _tmp = false;
        }
        if (_tmp) {
          i = i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      let name_end = i;
      while (true) {
        let _tmp;
        if (name_end > name_start) {
          const _bind = name_end - 1 | 0;
          if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
            $panic();
          }
          _tmp = _M0FP212moonbitstack8moonmime9is__space(s.str.charCodeAt(s.start + _bind | 0));
        } else {
          _tmp = false;
        }
        if (_tmp) {
          name_end = name_end - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      while (true) {
        let _tmp;
        if (i < n) {
          const _bind = i;
          if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
            $panic();
          }
          _tmp = _M0FP212moonbitstack8moonmime9is__space(s.str.charCodeAt(s.start + _bind | 0));
        } else {
          _tmp = false;
        }
        if (_tmp) {
          i = i + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      let _tmp;
      if (i < n) {
        const _bind = i;
        if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
          $panic();
        }
        _tmp = s.str.charCodeAt(s.start + _bind | 0) === 61;
      } else {
        _tmp = false;
      }
      if (_tmp) {
        const name = _M0MPC16string10StringView9to__owned(_M0MPC16string10StringView21clamped__view_2einner(s, name_start, name_end));
        i = i + 1 | 0;
        while (true) {
          let _tmp$2;
          if (i < n) {
            const _bind = i;
            if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
              $panic();
            }
            _tmp$2 = _M0FP212moonbitstack8moonmime9is__space(s.str.charCodeAt(s.start + _bind | 0));
          } else {
            _tmp$2 = false;
          }
          if (_tmp$2) {
            i = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        let _tmp$2;
        if (i < n) {
          const _bind = i;
          if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
            $panic();
          }
          _tmp$2 = s.str.charCodeAt(s.start + _bind | 0) === 34;
        } else {
          _tmp$2 = false;
        }
        if (_tmp$2) {
          i = i + 1 | 0;
          const value = _M0MPB13StringBuilder21StringBuilder_2einner(8);
          while (true) {
            let _tmp$3;
            if (i < n) {
              const _bind = i;
              if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
                $panic();
              }
              _tmp$3 = s.str.charCodeAt(s.start + _bind | 0) !== 34;
            } else {
              _tmp$3 = false;
            }
            if (_tmp$3) {
              let _tmp$4;
              const _bind = i;
              if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
                $panic();
              }
              if (s.str.charCodeAt(s.start + _bind | 0) === 92) {
                _tmp$4 = (i + 1 | 0) < n;
              } else {
                _tmp$4 = false;
              }
              if (_tmp$4) {
                i = i + 1 | 0;
              }
              _M0IPB13StringBuilderPB6Logger11write__view(value, _M0MPC16string10StringView21clamped__view_2einner(s, i, i + 1 | 0));
              i = i + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          if (i < n) {
            i = i + 1 | 0;
          }
          _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, { _0: _M0MPC16string6String9to__lower(name), _1: value.val });
        } else {
          const value_start = i;
          while (true) {
            let _tmp$3;
            if (i < n) {
              const _bind = i;
              if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
                $panic();
              }
              _tmp$3 = s.str.charCodeAt(s.start + _bind | 0) !== 59;
            } else {
              _tmp$3 = false;
            }
            if (_tmp$3) {
              i = i + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, { _0: _M0MPC16string6String9to__lower(name), _1: _M0FP212moonbitstack8moonmime4trim(_M0MPC16string10StringView21clamped__view_2einner(s, value_start, i)) });
        }
      } else {
        while (true) {
          let _tmp$2;
          if (i < n) {
            const _bind = i;
            if (_bind < 0 || _bind >= (s.end - s.start | 0)) {
              $panic();
            }
            _tmp$2 = s.str.charCodeAt(s.start + _bind | 0) !== 59;
          } else {
            _tmp$2 = false;
          }
          if (_tmp$2) {
            i = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        continue;
      }
      continue;
    } else {
      break;
    }
  }
  return out;
}
function _M0FP212moonbitstack8moonmime11media__type(s) {
  const semi = _M0FP212moonbitstack8moonmime11index__char(s, 59, 0);
  const head = semi < 0 ? s : _M0MPC16string10StringView21clamped__view_2einner(s, 0, semi);
  const params = semi < 0 ? [] : _M0FP212moonbitstack8moonmime13parse__params(_M0MPC16string10StringView21clamped__view_2einner(s, semi + 1 | 0, undefined));
  return new _M0TP212moonbitstack8moonmime9MediaType(_M0MPC16string6String9to__lower(_M0FP212moonbitstack8moonmime4trim(head)), params);
}
function _M0MP212moonbitstack8moonmime11Disposition5parse(s) {
  const semi = _M0FP212moonbitstack8moonmime11index__char(s, 59, 0);
  const head = semi < 0 ? s : _M0MPC16string10StringView21clamped__view_2einner(s, 0, semi);
  const params = semi < 0 ? [] : _M0FP212moonbitstack8moonmime13parse__params(_M0MPC16string10StringView21clamped__view_2einner(s, semi + 1 | 0, undefined));
  return new _M0TP212moonbitstack8moonmime11Disposition(_M0MPC16string6String9to__lower(_M0FP212moonbitstack8moonmime4trim(head)), params);
}
function _M0MP212moonbitstack8moonmime9MediaType6type__(self) {
  const _bind = self.essence;
  const _bind$2 = _M0FP212moonbitstack8moonmime11index__char(new _M0TPC16string10StringView(_bind, 0, _bind.length), 47, 0);
  if (_bind$2 === -1) {
    return self.essence;
  } else {
    return _M0MPC16string10StringView9to__owned(_M0MPC16string6String21clamped__view_2einner(self.essence, 0, _bind$2));
  }
}
function _M0MP212moonbitstack8moonmime9MediaType7subtype(self) {
  const _bind = self.essence;
  const _bind$2 = _M0FP212moonbitstack8moonmime11index__char(new _M0TPC16string10StringView(_bind, 0, _bind.length), 47, 0);
  if (_bind$2 === -1) {
    return "";
  } else {
    return _M0MPC16string10StringView9to__owned(_M0MPC16string6String21clamped__view_2einner(self.essence, _bind$2 + 1 | 0, undefined));
  }
}
function _M0MP212moonbitstack8moonmime9MediaType5param(self, name) {
  const _bind = self.params;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const pair = _bind[_];
      const _bind$3 = pair._0;
      if (_M0IPC16string10StringViewPB2Eq5equal(new _M0TPC16string10StringView(_bind$3, 0, _bind$3.length), name)) {
        return pair._1;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FP212moonbitstack8moonmime12quoted__safe(s) {
  const _bind = s.end - s.start | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      if (i < 0 || i >= (s.end - s.start | 0)) {
        $panic();
      }
      const c = s.str.charCodeAt(s.start + i | 0);
      if (c < 32 || (c > 126 || (c === 34 || c === 92))) {
        return false;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0FP212moonbitstack8moonmime28content__disposition_2einner(filename, inline) {
  const kind = inline ? "inline" : "attachment";
  return _M0FP212moonbitstack8moonmime12quoted__safe(filename) ? `${kind}; filename=\"${_M0MPC16string10StringView9to__owned(filename)}\"` : `${kind}; filename*=utf-8''${_M0FPC28encoding7percent6encode(filename)}`;
}
function _M0IP212moonbitstack8moonmime4Utf8P212moonbitstack8moonmime7Charset6decode(_self, data) {
  return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmime7RefusedE2Ok(_M0FPC28encoding4utf821decode__lossy_2einner(data, false));
}
function _M0IP212moonbitstack8moonmime4Utf8P212moonbitstack8moonmime7Charset6encode(_self, text) {
  return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmime7RefusedE2Ok(_M0FPC28encoding4utf814encode_2einner(text, false));
}
function _M0IP212moonbitstack8moonmime5AsciiP212moonbitstack8moonmime7Charset6decode(_self, data) {
  return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmime7RefusedE2Ok(_M0FP212moonbitstack8moonmime12latin1__text(data));
}
function _M0IP212moonbitstack8moonmime5AsciiP212moonbitstack8moonmime7Charset6encode(_self, text) {
  const out = _M0MPC16buffer6Buffer14Buffer_2einner(0);
  const _bind = text.str;
  const _bind$2 = text.start;
  const _bind$3 = text.end;
  let _tmp = _bind$2;
  while (true) {
    const _string_index = _tmp;
    if (_string_index < _bind$3) {
      let _decoded_next_string_index;
      let _decoded_char;
      _L: {
        const _bind$4 = _bind.charCodeAt(_string_index);
        if (_bind$4 >= 55296 && _bind$4 <= 56319 && (_string_index + 1 | 0) < _bind$3) {
          const _bind$5 = _bind.charCodeAt(_string_index + 1 | 0);
          if (_bind$5 >= 56320 && _bind$5 <= 57343) {
            const _tmp$2 = _string_index + 2 | 0;
            const _p = (((Math.imul(_bind$4 - 55296 | 0, 1024) | 0) + _bind$5 | 0) - 56320 | 0) + 65536 | 0;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$4;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        } else {
          const _tmp$2 = _string_index + 1 | 0;
          const _p = _bind$4;
          _decoded_next_string_index = _tmp$2;
          _decoded_char = _p;
          break _L;
        }
      }
      const n = _decoded_char;
      if (n > 127) {
        return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmime7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonmime_2eRefused_2eCharset("us-ascii"));
      }
      _M0MPC16buffer6Buffer11write__byte(out, n & 255);
      _tmp = _decoded_next_string_index;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmime7RefusedE2Ok(_M0MPC16buffer6Buffer9to__bytes(out));
}
function _M0IP212moonbitstack8moonmime6Latin1P212moonbitstack8moonmime7Charset6decode(_self, data) {
  return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmime7RefusedE2Ok(_M0FP212moonbitstack8moonmime12latin1__text(data));
}
function _M0IP212moonbitstack8moonmime6Latin1P212moonbitstack8moonmime7Charset6encode(_self, text) {
  const out = _M0MPC16buffer6Buffer14Buffer_2einner(0);
  const _bind = text.str;
  const _bind$2 = text.start;
  const _bind$3 = text.end;
  let _tmp = _bind$2;
  while (true) {
    const _string_index = _tmp;
    if (_string_index < _bind$3) {
      let _decoded_next_string_index;
      let _decoded_char;
      _L: {
        const _bind$4 = _bind.charCodeAt(_string_index);
        if (_bind$4 >= 55296 && _bind$4 <= 56319 && (_string_index + 1 | 0) < _bind$3) {
          const _bind$5 = _bind.charCodeAt(_string_index + 1 | 0);
          if (_bind$5 >= 56320 && _bind$5 <= 57343) {
            const _tmp$2 = _string_index + 2 | 0;
            const _p = (((Math.imul(_bind$4 - 55296 | 0, 1024) | 0) + _bind$5 | 0) - 56320 | 0) + 65536 | 0;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$4;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        } else {
          const _tmp$2 = _string_index + 1 | 0;
          const _p = _bind$4;
          _decoded_next_string_index = _tmp$2;
          _decoded_char = _p;
          break _L;
        }
      }
      const n = _decoded_char;
      if (n > 255) {
        return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmime7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonmime_2eRefused_2eCharset("iso-8859-1"));
      }
      _M0MPC16buffer6Buffer11write__byte(out, n & 255);
      _tmp = _decoded_next_string_index;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmime7RefusedE2Ok(_M0MPC16buffer6Buffer9to__bytes(out));
}
function _M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__repr(_x_426) {
  switch (_x_426.$tag) {
    case 10: {
      const _Header = _x_426;
      const _$42$arg_427 = _Header._0;
      return _M0MPC15debug4Repr4ctor("Header", [{ _0: _M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__reprN6constrS3558, _1: _M0IPC13int3IntPC15debug5Debug8to__repr(_$42$arg_427) }]);
    }
    case 9: {
      const _Address = _x_426;
      const _$42$arg_428 = _Address._0;
      return _M0MPC15debug4Repr4ctor("Address", [{ _0: _M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__reprN6constrS3559, _1: _M0IPC13int3IntPC15debug5Debug8to__repr(_$42$arg_428) }]);
    }
    case 8: {
      const _Boundary = _x_426;
      const _$42$arg_429 = _Boundary._0;
      return _M0MPC15debug4Repr4ctor("Boundary", [{ _0: _M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__reprN6constrS3560, _1: _M0IPC13int3IntPC15debug5Debug8to__repr(_$42$arg_429) }]);
    }
    case 7: {
      const _Encoding = _x_426;
      const _$42$arg_430 = _Encoding._0;
      return _M0MPC15debug4Repr4ctor("Encoding", [{ _0: _M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__reprN6constrS3561, _1: _M0IPC13int3IntPC15debug5Debug8to__repr(_$42$arg_430) }]);
    }
    case 6: {
      const _Charset = _x_426;
      const _$42$arg_431 = _Charset._0;
      return _M0MPC15debug4Repr4ctor("Charset", [{ _0: _M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__reprN6constrS3562, _1: _M0IPC16string6StringPC15debug5Debug8to__repr(_$42$arg_431) }]);
    }
    default: {
      return _M0MPC15debug4Repr4ctor("Date", []);
    }
  }
}
function _M0FP212moonbitstack8moonmail11before__eol(data, at) {
  let stop = at;
  let _tmp;
  if (stop > 0) {
    const _bind = stop - 1 | 0;
    if (_bind < 0 || _bind >= (data.end - data.start | 0)) {
      $panic();
    }
    _tmp = data.buf[data.start + _bind | 0] === 10;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    stop = stop - 1 | 0;
  }
  let _tmp$2;
  if (stop > 0) {
    const _bind = stop - 1 | 0;
    if (_bind < 0 || _bind >= (data.end - data.start | 0)) {
      $panic();
    }
    _tmp$2 = data.buf[data.start + _bind | 0] === 13;
  } else {
    _tmp$2 = false;
  }
  if (_tmp$2) {
    stop = stop - 1 | 0;
  }
  return stop;
}
function _M0FP212moonbitstack8moonmail9line__end(data, at) {
  let i = at;
  while (true) {
    let _tmp;
    if (i < (data.end - data.start | 0)) {
      const _bind = i;
      if (_bind < 0 || _bind >= (data.end - data.start | 0)) {
        $panic();
      }
      _tmp = data.buf[data.start + _bind | 0] !== 10;
    } else {
      _tmp = false;
    }
    if (_tmp) {
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return i < (data.end - data.start | 0) ? i + 1 | 0 : i;
}
function _M0FP212moonbitstack8moonmail9trim__eol(line) {
  return _M0MPC15bytes9BytesView21clamped__view_2einner(line, 0, _M0FP212moonbitstack8moonmail11before__eol(line, line.end - line.start | 0));
}
function _M0FP212moonbitstack8moonmail5split(data, boundary, base, strict) {
  const _bind = `--${boundary}`;
  const dash = _M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(_bind, 0, _bind.length), false);
  const parts = [];
  let open = undefined;
  let closed = false;
  let at = 0;
  while (true) {
    if (at < (data.end - data.start | 0)) {
      const end = _M0FP212moonbitstack8moonmail9line__end(data, at);
      const line = _M0FP212moonbitstack8moonmail9trim__eol(_M0MPC15bytes9BytesView21clamped__view_2einner(data, at, end));
      if ((line.end - line.start | 0) >= dash.length && _M0IPC15bytes9BytesViewPB2Eq5equal(_M0MPC15bytes9BytesView21clamped__view_2einner(line, 0, dash.length), new _M0TPC15bytes9BytesView(dash, 0, dash.length))) {
        const tail = _M0MPC15bytes9BytesView21clamped__view_2einner(line, dash.length, undefined);
        let close;
        if ((tail.end - tail.start | 0) >= 2) {
          let _tmp;
          if (0 >= (tail.end - tail.start | 0)) {
            $panic();
          }
          if (tail.buf[tail.start] === 45) {
            if (1 >= (tail.end - tail.start | 0)) {
              $panic();
            }
            _tmp = tail.buf[tail.start + 1 | 0] === 45;
          } else {
            _tmp = false;
          }
          close = _tmp;
        } else {
          close = false;
        }
        const _p = _M0MPC15bytes9BytesView4iter(tail);
        let padding;
        while (true) {
          const _p$2 = _M0MPB4Iter4nextGyE(_p);
          if (_p$2 === -1) {
            padding = true;
            break;
          } else {
            const _p$3 = _p$2;
            const _p$4 = _p$3;
            if (_p$4 === 32 || _p$4 === 9) {
            } else {
              padding = false;
              break;
            }
            continue;
          }
        }
        if (close || padding) {
          const _bind$2 = open;
          if (_bind$2 === undefined) {
          } else {
            const _Some = _bind$2;
            const _start = _Some;
            const stop = _M0FP212moonbitstack8moonmail11before__eol(data, at);
            _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(parts, { _0: _M0MPC15bytes9BytesView21clamped__view_2einner(data, _start, stop < _start ? _start : stop), _1: base + _start | 0 });
          }
          if (close) {
            closed = true;
            break;
          }
          open = end;
        }
      }
      at = end;
      continue;
    } else {
      break;
    }
  }
  const _bind$2 = open;
  if (_bind$2 === undefined) {
    if (strict) {
      return new _M0DTPC16result6ResultGORPB5ArrayGURPC15bytes9BytesViewiEERP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error44moonbitstack_2fmoonmail_2eRefused_2eBoundary(base));
    }
    return new _M0DTPC16result6ResultGORPB5ArrayGURPC15bytes9BytesViewiEERP212moonbitstack8moonmail7RefusedE2Ok(_M0DTPC16option6OptionGRPB5ArrayGURPC15bytes9BytesViewiEEE4None__);
  }
  if (!closed) {
    if (strict) {
      return new _M0DTPC16result6ResultGORPB5ArrayGURPC15bytes9BytesViewiEERP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error44moonbitstack_2fmoonmail_2eRefused_2eBoundary(base + (data.end - data.start | 0) | 0));
    }
    const _bind$3 = open;
    if (_bind$3 === undefined) {
    } else {
      const _Some = _bind$3;
      const _start = _Some;
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(parts, { _0: _M0MPC15bytes9BytesView21clamped__view_2einner(data, _start, undefined), _1: base + _start | 0 });
    }
  }
  return new _M0DTPC16result6ResultGORPB5ArrayGURPC15bytes9BytesViewiEERP212moonbitstack8moonmail7RefusedE2Ok(new _M0DTPC16option6OptionGRPB5ArrayGURPC15bytes9BytesViewiEEE4Some(parts));
}
function _M0FP212moonbitstack8moonmail4same(a, b) {
  return _M0MPC16string10StringView26equal__ignore__ascii__case(a, b);
}
function _M0MP212moonbitstack8moonmail7Headers3get(self, name) {
  const _bind = self.fields;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const field = _bind[_];
      const _bind$3 = field._0;
      if (_M0FP212moonbitstack8moonmail4same(new _M0TPC16string10StringView(_bind$3, 0, _bind$3.length), name)) {
        return field._1;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FP212moonbitstack8moonmail12encoding__of(headers) {
  return _M0MPC16option6Option3mapGssE(_M0MP212moonbitstack8moonmail7Headers3get(headers, _M0FP212moonbitstack8moonmail12encoding__ofN6recordS3620), (v) => _M0MPC16string10StringView9to__owned(_M0MPC16string10StringView9to__lower(_M0MPC16string6String4trim(v, undefined))));
}
function _M0FP212moonbitstack8moonmail16transfer__decode(headers, data, base, strict) {
  _L: {
    const _bind = _M0FP212moonbitstack8moonmail12encoding__of(headers);
    if (_bind === undefined) {
      break _L;
    } else {
      const _Some = _bind;
      const _x = _Some;
      switch (_x) {
        case "base64": {
          if (strict) {
            const text = _M0MPB4Iter9to__arrayGcE(_M0MPB4Iter6filterGcE(_M0MPC16string6String4iter(_M0FPC28encoding4utf821decode__lossy_2einner(data, false)), (c) => !_M0MPC14char4Char14is__whitespace(c)));
            let _try_err;
            _L$2: {
              const _bind$2 = _M0MPC16string6String11from__array(new _M0TPB9ArrayViewGcE(text, 0, text.length));
              const _bind$3 = _M0FP312moonbitstack8moonbase6base646decode(new _M0TPC16string10StringView(_bind$2, 0, _bind$2.length), undefined, -1, -1);
              let _tmp;
              if (_bind$3.$tag === 1) {
                const _ok = _bind$3;
                _tmp = _ok._0;
              } else {
                const _err = _bind$3;
                _try_err = _err._0;
                break _L$2;
              }
              return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmail7RefusedE2Ok(_tmp);
            }
            return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error44moonbitstack_2fmoonmail_2eRefused_2eEncoding(base));
          } else {
            const _bind$2 = _M0FPC28encoding4utf821decode__lossy_2einner(data, false);
            return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmail7RefusedE2Ok(_M0FP312moonbitstack8moonbase6base6413decode__lossy(new _M0TPC16string10StringView(_bind$2, 0, _bind$2.length), undefined));
          }
        }
        case "quoted-printable": {
          let _try_err;
          _L$2: {
            const _bind$2 = _M0FP312moonbitstack8moonmime2qp14decode_2einner(data, strict);
            let _tmp;
            if (_bind$2.$tag === 1) {
              const _ok = _bind$2;
              _tmp = _ok._0;
            } else {
              const _err = _bind$2;
              _try_err = _err._0;
              break _L$2;
            }
            return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmail7RefusedE2Ok(_tmp);
          }
          return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error44moonbitstack_2fmoonmail_2eRefused_2eEncoding(base));
        }
        case "7bit": {
          break _L;
        }
        case "8bit": {
          break _L;
        }
        case "binary": {
          break _L;
        }
        default: {
          if (strict) {
            return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error44moonbitstack_2fmoonmail_2eRefused_2eEncoding(base));
          }
          return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmail7RefusedE2Ok(_M0MPC15bytes9BytesView9to__owned(data));
        }
      }
    }
  }
  return new _M0DTPC16result6ResultGzRP212moonbitstack8moonmail7RefusedE2Ok(_M0MPC15bytes9BytesView9to__owned(data));
}
function _M0FP212moonbitstack8moonmail8type__of(headers, digest) {
  _L: {
    const _bind = _M0MP212moonbitstack8moonmail7Headers3get(headers, _M0FP212moonbitstack8moonmail8type__ofN6recordS3640);
    if (_bind === undefined) {
      break _L;
    } else {
      const _Some = _bind;
      const _value = _Some;
      if (_M0MPC16string6String8contains(_value, _M0FP212moonbitstack8moonmail8type__ofN6recordS3641)) {
        return _M0FP212moonbitstack8moonmime11media__type(new _M0TPC16string10StringView(_value, 0, _value.length));
      } else {
        break _L;
      }
    }
  }
  return digest ? new _M0TP212moonbitstack8moonmime9MediaType("message/rfc822", []) : new _M0TP212moonbitstack8moonmime9MediaType("text/plain", [_M0FP212moonbitstack8moonmail8type__ofN5tupleS3639]);
}
function _M0FP212moonbitstack8moonmail13read__headers(data, base, strict) {
  const fields = [];
  let at = 0;
  if ((data.end - data.start | 0) >= 5 && _M0IPC15bytes9BytesViewPB2Eq5equal(_M0MPC15bytes9BytesView21clamped__view_2einner(data, 0, _M0FP212moonbitstack8moonmail13read__headersN6constrS3648), _M0FP212moonbitstack8moonmail13read__headersN6recordS3649)) {
    at = _M0FP212moonbitstack8moonmail9line__end(data, 0);
  }
  while (true) {
    if (at < (data.end - data.start | 0)) {
      const end = _M0FP212moonbitstack8moonmail9line__end(data, at);
      const line = _M0FP212moonbitstack8moonmail9trim__eol(_M0MPC15bytes9BytesView21clamped__view_2einner(data, at, end));
      if ((line.end - line.start | 0) === 0) {
        return new _M0DTPC16result6ResultGURP212moonbitstack8moonmail7HeadersiERP212moonbitstack8moonmail7RefusedE2Ok({ _0: new _M0TP212moonbitstack8moonmail7Headers(fields), _1: end });
      }
      let _tmp;
      let _tmp$2;
      if (0 >= (line.end - line.start | 0)) {
        $panic();
      }
      if (line.buf[line.start] === 32) {
        _tmp$2 = true;
      } else {
        if (0 >= (line.end - line.start | 0)) {
          $panic();
        }
        _tmp$2 = line.buf[line.start] === 9;
      }
      if (_tmp$2) {
        _tmp = fields.length > 0;
      } else {
        _tmp = false;
      }
      if (_tmp) {
        const last = fields.length - 1 | 0;
        _M0MPC15array5Array3setGUssEE(fields, last, { _0: _M0MPC15array5Array2atGUssEE(fields, last)._0, _1: `${_M0MPC15array5Array2atGUssEE(fields, last)._1}${_M0FPC28encoding4utf821decode__lossy_2einner(line, false)}` });
        at = end;
        continue;
      }
      const text = _M0FPC28encoding4utf821decode__lossy_2einner(line, false);
      _L: {
        _L$2: {
          const _bind = _M0MPC16string6String4find(text, _M0FP212moonbitstack8moonmail13read__headersN6recordS3650);
          if (_bind === undefined) {
            break _L$2;
          } else {
            const _Some = _bind;
            const _colon = _Some;
            let _tmp$3;
            if (_colon > 0) {
              const _p = _M0MPC16string10StringView4iter(_M0MPC16string10StringView9trim__end(_M0MPC16string6String21clamped__view_2einner(text, 0, _colon), undefined));
              let _tmp$4;
              while (true) {
                const _p$2 = _M0MPB4Iter4nextGcE(_p);
                if (_p$2 === -1) {
                  _tmp$4 = true;
                  break;
                } else {
                  const _p$3 = _p$2;
                  const _p$4 = _p$3;
                  if (_p$4 > 32 && _p$4 < 127) {
                  } else {
                    _tmp$4 = false;
                    break;
                  }
                  continue;
                }
              }
              _tmp$3 = _tmp$4;
            } else {
              _tmp$3 = false;
            }
            if (_tmp$3) {
              const name = _M0MPC16string10StringView9to__owned(_M0MPC16string10StringView9trim__end(_M0MPC16string6String21clamped__view_2einner(text, 0, _colon), undefined));
              const value = _M0MPC16string10StringView9to__owned(_M0MPC16string10StringView19trim__start_2einner(_M0MPC16string6String21clamped__view_2einner(text, _colon + 1 | 0, undefined), _M0FP212moonbitstack8moonmail13read__headersN6recordS3651));
              _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(fields, { _0: name, _1: value });
            } else {
              break _L$2;
            }
          }
          break _L;
        }
        if (strict) {
          return new _M0DTPC16result6ResultGURP212moonbitstack8moonmail7HeadersiERP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error42moonbitstack_2fmoonmail_2eRefused_2eHeader(base + at | 0));
        }
        return new _M0DTPC16result6ResultGURP212moonbitstack8moonmail7HeadersiERP212moonbitstack8moonmail7RefusedE2Ok({ _0: new _M0TP212moonbitstack8moonmail7Headers(fields), _1: at });
      }
      at = end;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGURP212moonbitstack8moonmail7HeadersiERP212moonbitstack8moonmail7RefusedE2Ok({ _0: new _M0TP212moonbitstack8moonmail7Headers(fields), _1: data.end - data.start | 0 });
}
function _M0FP212moonbitstack8moonmail4read(data, base, strict, digest) {
  const _bind = _M0FP212moonbitstack8moonmail13read__headers(data, base, strict);
  let _bind$2;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _bind$2 = _ok._0;
  } else {
    return _bind;
  }
  const _headers = _bind$2._0;
  const _start = _bind$2._1;
  const _bind$3 = _M0FP212moonbitstack8moonmail10read__body(_headers, _M0MPC15bytes9BytesView21clamped__view_2einner(data, _start, undefined), base + _start | 0, strict, digest);
  let body;
  if (_bind$3.$tag === 1) {
    const _ok = _bind$3;
    body = _ok._0;
  } else {
    return _bind$3;
  }
  return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail7MessageRP212moonbitstack8moonmail7RefusedE2Ok(new _M0TP212moonbitstack8moonmail7Message(_headers, body));
}
function _M0FP212moonbitstack8moonmail10read__body(headers, data, base, strict, digest) {
  const kind = _M0FP212moonbitstack8moonmail8type__of(headers, digest);
  _L: {
    const _bind = _M0MP212moonbitstack8moonmime9MediaType6type__(kind);
    switch (_bind) {
      case "multipart": {
        _L$2: {
          const _bind$2 = _M0MP212moonbitstack8moonmime9MediaType5param(kind, _M0FP212moonbitstack8moonmail10read__bodyN6recordS3677);
          if (_bind$2 === undefined) {
            break _L$2;
          } else {
            const _Some = _bind$2;
            const _boundary = _Some;
            if (!(_boundary === "")) {
              const _bind$3 = _M0FP212moonbitstack8moonmail5split(data, _boundary, base, strict);
              let _bind$4;
              if (_bind$3.$tag === 1) {
                const _ok = _bind$3;
                _bind$4 = _ok._0;
              } else {
                return _bind$3;
              }
              if (_bind$4.$tag === 1) {
                const _Some$2 = _bind$4;
                const _parts = _Some$2._0;
                const digest$2 = _M0MP212moonbitstack8moonmime9MediaType7subtype(kind) === "digest";
                let _bind$5;
                let _p;
                _L$3: {
                  _L$4: {
                    const _p$2 = new Array(_parts.length);
                    const _p$3 = _parts.length;
                    let _tmp = 0;
                    while (true) {
                      const _p$4 = _tmp;
                      if (_p$4 < _p$3) {
                        const _p$5 = _parts[_p$4];
                        const _bind$6 = _M0FP212moonbitstack8moonmail4read(_p$5._0, _p$5._1, strict, digest$2);
                        let _tmp$2;
                        if (_bind$6.$tag === 1) {
                          const _ok = _bind$6;
                          _tmp$2 = _ok._0;
                        } else {
                          const _err = _bind$6;
                          _p = _err._0;
                          break _L$4;
                        }
                        _p$2[_p$4] = _tmp$2;
                        _tmp = _p$4 + 1 | 0;
                        continue;
                      } else {
                        break;
                      }
                    }
                    _bind$5 = new _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7MessageERP212moonbitstack8moonmail7RefusedE2Ok(_p$2);
                    break _L$3;
                  }
                  _bind$5 = new _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7MessageERP212moonbitstack8moonmail7RefusedE3Err(_p);
                }
                let _tmp;
                if (_bind$5.$tag === 1) {
                  const _ok = _bind$5;
                  _tmp = _ok._0;
                } else {
                  return _bind$5;
                }
                return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail4BodyRP212moonbitstack8moonmail7RefusedE2Ok(new _M0DTP212moonbitstack8moonmail4Body9Multipart(_tmp));
              } else {
                return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail4BodyRP212moonbitstack8moonmail7RefusedE2Ok(new _M0DTP212moonbitstack8moonmail4Body4Leaf(_M0MPC15bytes9BytesView9to__owned(data)));
              }
            } else {
              break _L$2;
            }
          }
        }
        if (strict) {
          return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail4BodyRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error44moonbitstack_2fmoonmail_2eRefused_2eBoundary(base));
        }
        return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail4BodyRP212moonbitstack8moonmail7RefusedE2Ok(new _M0DTP212moonbitstack8moonmail4Body4Leaf(_M0MPC15bytes9BytesView9to__owned(data)));
      }
      case "message": {
        _L$3: {
          const _bind$2 = _M0MP212moonbitstack8moonmime9MediaType7subtype(kind);
          switch (_bind$2) {
            case "rfc822": {
              break _L$3;
            }
            case "global": {
              break _L$3;
            }
            default: {
              break _L;
            }
          }
        }
        const _bind$2 = _M0FP212moonbitstack8moonmail16transfer__decode(headers, data, base, strict);
        let inner;
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          inner = _ok._0;
        } else {
          return _bind$2;
        }
        const _bind$3 = _M0FP212moonbitstack8moonmail4read(new _M0TPC15bytes9BytesView(inner, 0, inner.length), base, strict, false);
        let _tmp;
        if (_bind$3.$tag === 1) {
          const _ok = _bind$3;
          _tmp = _ok._0;
        } else {
          return _bind$3;
        }
        return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail4BodyRP212moonbitstack8moonmail7RefusedE2Ok(new _M0DTP212moonbitstack8moonmail4Body8Embedded(_tmp));
      }
      default: {
        break _L;
      }
    }
  }
  const _bind = _M0FP212moonbitstack8moonmail16transfer__decode(headers, data, base, strict);
  let _tmp;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _tmp = _ok._0;
  } else {
    return _bind;
  }
  return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail4BodyRP212moonbitstack8moonmail7RefusedE2Ok(new _M0DTP212moonbitstack8moonmail4Body4Leaf(_tmp));
}
function _M0MP212moonbitstack8moonmail7Message13parse_2einner(data, strict) {
  return _M0FP212moonbitstack8moonmail4read(data, 0, strict, false);
}
function _M0MP212moonbitstack8moonmail7Message13content__type(self) {
  return _M0FP212moonbitstack8moonmail8type__of(self.headers, false);
}
function _M0MP212moonbitstack8moonmail7Message7subject(self) {
  return _M0MPC16option6Option3mapGssE(_M0MP212moonbitstack8moonmail7Headers3get(self.headers, _M0MP212moonbitstack8moonmail7Message7subjectN6recordS3701), (v) => _M0FP212moonbitstack8moonmime13decode__words(new _M0TPC16string10StringView(v, 0, v.length), undefined));
}
function _M0MP212moonbitstack8moonmail7Address9mailboxes(self) {
  if (self.$tag === 0) {
    const _Mailbox = self;
    const _m = _Mailbox._0;
    return [_m];
  } else {
    const _Group = self;
    return _Group._1;
  }
}
function _M0FP212moonbitstack8moonmail7display(pieces) {
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  const _bind = pieces.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const piece = pieces[i];
      if (i > 0 && piece.spaced) {
        _M0IPB13StringBuilderPB6Logger11write__char(out, 32);
      }
      _M0IPB13StringBuilderPB6Logger13write__string(out, piece.text);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const joined = out.val;
  const _p = _M0MPC15array5Array4iterGUssEE(pieces);
  let _tmp$2;
  while (true) {
    const _p$2 = _M0MPB4Iter4nextGUssEE(_p);
    if (_p$2 === undefined) {
      _tmp$2 = false;
      break;
    } else {
      const _p$3 = _p$2;
      const _p$4 = _p$3;
      if (!_p$4.quoted && _M0MPC16string6String8contains(_p$4.text, _M0FP212moonbitstack8moonmail7displayN6recordS3708)) {
        _tmp$2 = true;
        break;
      }
      continue;
    }
  }
  if (_tmp$2) {
    return _M0FP212moonbitstack8moonmime13decode__words(new _M0TPC16string10StringView(joined, 0, joined.length), undefined);
  } else {
    return joined;
  }
}
function _M0MP212moonbitstack8moonmail5Lexer4peek(self) {
  return _M0MPC15array5Array3getGcE(self.text, self.at);
}
function _M0MP212moonbitstack8moonmail5Lexer7comment(self) {
  const start = self.at;
  self.at = self.at + 1 | 0;
  let depth = 1;
  while (true) {
    if (depth > 0) {
      const _bind = _M0MP212moonbitstack8moonmail5Lexer4peek(self);
      if (_bind === -1) {
        return new _M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eAddress(start));
      } else {
        const _Some = _bind;
        const _c = _Some;
        self.at = self.at + 1 | 0;
        if (_c === 92) {
          self.at = self.at + 1 | 0;
        } else {
          if (_c === 40) {
            depth = depth + 1 | 0;
          } else {
            if (_c === 41) {
              depth = depth - 1 | 0;
            }
          }
        }
      }
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE2Ok(undefined);
}
function _M0MP212moonbitstack8moonmail5Lexer4cfws(self) {
  const start = self.at;
  while (true) {
    const _bind = _M0MP212moonbitstack8moonmail5Lexer4peek(self);
    if (_bind === -1) {
      break;
    } else {
      const _Some = _bind;
      const _c = _Some;
      if (_c === 32 || (_c === 9 || (_c === 13 || _c === 10))) {
        self.at = self.at + 1 | 0;
      } else {
        if (_c === 40) {
          const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer7comment(self);
          if (_bind$2.$tag === 1) {
            const _ok = _bind$2;
            _ok._0;
          } else {
            return _bind$2;
          }
        } else {
          break;
        }
      }
      continue;
    }
  }
  return new _M0DTPC16result6ResultGbRP212moonbitstack8moonmail7RefusedE2Ok(self.at > start);
}
function _M0MP212moonbitstack8moonmail5Lexer3eat(self, c) {
  if (_M0IPC16option6OptionPB2Eq5equalGcE(_M0MP212moonbitstack8moonmail5Lexer4peek(self), c)) {
    self.at = self.at + 1 | 0;
    return true;
  } else {
    return false;
  }
}
function _M0FP212moonbitstack8moonmail9is__atext(c) {
  return c >= 97 && c <= 122 || (c >= 65 && c <= 90 || (c >= 48 && c <= 57 || (_M0MPC16string6String14contains__char("!#$%&'*+-/=?^_`{|}~", c) || c >= 128)));
}
function _M0FP212moonbitstack8moonmail5quote(text) {
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  _M0IPB13StringBuilderPB6Logger11write__char(out, 34);
  const _bind = text.length;
  let _tmp = 0;
  while (true) {
    const _string_index = _tmp;
    if (_string_index < _bind) {
      let _decoded_next_string_index;
      let _decoded_char;
      _L: {
        const _bind$2 = text.charCodeAt(_string_index);
        if (_bind$2 >= 55296 && _bind$2 <= 56319 && (_string_index + 1 | 0) < _bind) {
          const _bind$3 = text.charCodeAt(_string_index + 1 | 0);
          if (_bind$3 >= 56320 && _bind$3 <= 57343) {
            const _tmp$2 = _string_index + 2 | 0;
            const _p = (((Math.imul(_bind$2 - 55296 | 0, 1024) | 0) + _bind$3 | 0) - 56320 | 0) + 65536 | 0;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$2;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        } else {
          const _tmp$2 = _string_index + 1 | 0;
          const _p = _bind$2;
          _decoded_next_string_index = _tmp$2;
          _decoded_char = _p;
          break _L;
        }
      }
      if (_decoded_char === 34 || _decoded_char === 92) {
        _M0IPB13StringBuilderPB6Logger11write__char(out, 92);
      }
      _M0IPB13StringBuilderPB6Logger11write__char(out, _decoded_char);
      _tmp = _decoded_next_string_index;
      continue;
    } else {
      break;
    }
  }
  _M0IPB13StringBuilderPB6Logger11write__char(out, 34);
  return out.val;
}
function _M0MP212moonbitstack8moonmail5Lexer4atom(self) {
  const start = self.at;
  while (true) {
    const _bind = _M0MP212moonbitstack8moonmail5Lexer4peek(self);
    if (_bind === -1) {
      break;
    } else {
      const _Some = _bind;
      const _c = _Some;
      if (_M0FP212moonbitstack8moonmail9is__atext(_c)) {
        self.at = self.at + 1 | 0;
        continue;
      } else {
        break;
      }
    }
  }
  return self.at === start ? undefined : _M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(self.text, start, self.at));
}
function _M0MP212moonbitstack8moonmail5Lexer6expect(self, c) {
  if (!_M0MP212moonbitstack8moonmail5Lexer3eat(self, c)) {
    return new _M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eAddress(self.at));
  } else {
    return new _M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE2Ok(undefined);
  }
}
function _M0MP212moonbitstack8moonmail5Lexer6domain(self) {
  const _bind = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  if (_M0IPC16option6OptionPB2Eq5equalGcE(_M0MP212moonbitstack8moonmail5Lexer4peek(self), _M0MP212moonbitstack8moonmail5Lexer6domainN6constrS3752)) {
    const start = self.at;
    while (true) {
      const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer4peek(self);
      if (_bind$2 === -1) {
        break;
      } else {
        const _Some = _bind$2;
        const _c = _Some;
        if (_c !== 93) {
          if (_c === 92) {
            self.at = self.at + 1 | 0;
          }
          self.at = self.at + 1 | 0;
          continue;
        } else {
          break;
        }
      }
    }
    const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer6expect(self, 93);
    if (_bind$2.$tag === 1) {
      const _ok = _bind$2;
      _ok._0;
    } else {
      return _bind$2;
    }
    return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE2Ok(_M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(self.text, start, self.at)));
  }
  const atoms = [];
  while (true) {
    const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
    if (_bind$2.$tag === 1) {
      const _ok = _bind$2;
      _ok._0;
    } else {
      return _bind$2;
    }
    const _bind$3 = _M0MP212moonbitstack8moonmail5Lexer4atom(self);
    if (_bind$3 === undefined) {
      return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eAddress(self.at));
    } else {
      const _Some = _bind$3;
      const _atom = _Some;
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(atoms, _atom);
      const mark = self.at;
      const _bind$4 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
      if (_bind$4.$tag === 1) {
        const _ok = _bind$4;
        _ok._0;
      } else {
        return _bind$4;
      }
      if (!_M0MP212moonbitstack8moonmail5Lexer3eat(self, 46)) {
        self.at = mark;
        break;
      }
    }
    continue;
  }
  return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE2Ok(_M0MPC15array5Array4joinGsE(atoms, _M0MP212moonbitstack8moonmail5Lexer6domainN6recordS3753));
}
function _M0MP212moonbitstack8moonmail5Lexer6quoted(self) {
  const start = self.at;
  self.at = self.at + 1 | 0;
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  _L: while (true) {
    const _bind = _M0MP212moonbitstack8moonmail5Lexer4peek(self);
    if (_bind === -1) {
      return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eAddress(start));
    } else {
      const _Some = _bind;
      const _c = _Some;
      self.at = self.at + 1 | 0;
      switch (_c) {
        case 34: {
          break _L;
        }
        case 92: {
          const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer4peek(self);
          if (_bind$2 === -1) {
            return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eAddress(start));
          } else {
            const _Some$2 = _bind$2;
            const _next = _Some$2;
            _M0IPB13StringBuilderPB6Logger11write__char(out, _next);
            self.at = self.at + 1 | 0;
          }
          break;
        }
        case 13: {
          break;
        }
        case 10: {
          break;
        }
        default: {
          _M0IPB13StringBuilderPB6Logger11write__char(out, _c);
        }
      }
    }
    continue;
  }
  return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE2Ok(out.val);
}
function _M0MP212moonbitstack8moonmail5Lexer4word(self) {
  _L: {
    const _bind = _M0MP212moonbitstack8moonmail5Lexer4peek(self);
    if (_bind === -1) {
      break _L;
    } else {
      const _Some = _bind;
      const _x = _Some;
      if (_x === 34) {
        const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer6quoted(self);
        let _tmp;
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          _tmp = _ok._0;
        } else {
          return _bind$2;
        }
        return new _M0DTPC16result6ResultGOUsbERP212moonbitstack8moonmail7RefusedE2Ok({ _0: _tmp, _1: true });
      } else {
        break _L;
      }
    }
  }
  return new _M0DTPC16result6ResultGOUsbERP212moonbitstack8moonmail7RefusedE2Ok(_M0MPC16option6Option3mapGsUsbEE(_M0MP212moonbitstack8moonmail5Lexer4atom(self), (a) => ({ _0: a, _1: false })));
}
function _M0MP212moonbitstack8moonmail5Lexer10addr__spec(self) {
  const _bind = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  const words = [];
  let quoted = false;
  while (true) {
    const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
    if (_bind$2.$tag === 1) {
      const _ok = _bind$2;
      _ok._0;
    } else {
      return _bind$2;
    }
    const _bind$3 = _M0MP212moonbitstack8moonmail5Lexer4word(self);
    let _bind$4;
    if (_bind$3.$tag === 1) {
      const _ok = _bind$3;
      _bind$4 = _ok._0;
    } else {
      return _bind$3;
    }
    if (_bind$4 === undefined) {
      return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eAddress(self.at));
    } else {
      const _Some = _bind$4;
      const _x = _Some;
      const _text = _x._0;
      const _q = _x._1;
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(words, _text);
      quoted = quoted || _q;
      const _bind$5 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
      if (_bind$5.$tag === 1) {
        const _ok = _bind$5;
        _ok._0;
      } else {
        return _bind$5;
      }
      if (!_M0MP212moonbitstack8moonmail5Lexer3eat(self, 46)) {
        break;
      }
    }
    continue;
  }
  const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _ok._0;
  } else {
    return _bind$2;
  }
  const _bind$3 = _M0MP212moonbitstack8moonmail5Lexer6expect(self, 64);
  if (_bind$3.$tag === 1) {
    const _ok = _bind$3;
    _ok._0;
  } else {
    return _bind$3;
  }
  const user = _M0MPC15array5Array4joinGsE(words, _M0MP212moonbitstack8moonmail5Lexer10addr__specN6recordS3782);
  const _p = _M0MPC16string6String5split(user, _M0MP212moonbitstack8moonmail5Lexer10addr__specN6recordS3783);
  let dot_atom;
  while (true) {
    const _p$2 = _M0MPB4Iter4nextGUssEE(_p);
    if (_p$2 === undefined) {
      dot_atom = true;
      break;
    } else {
      const _p$3 = _p$2;
      const _p$4 = _p$3;
      let _tmp;
      if (!((_p$4.end - _p$4.start | 0) === 0)) {
        const _p$5 = _M0MPC16string10StringView4iter(_p$4);
        let _tmp$2;
        while (true) {
          const _p$6 = _M0MPB4Iter4nextGcE(_p$5);
          if (_p$6 === -1) {
            _tmp$2 = true;
            break;
          } else {
            const _p$7 = _p$6;
            const _p$8 = _p$7;
            if (_M0FP212moonbitstack8moonmail9is__atext(_p$8)) {
            } else {
              _tmp$2 = false;
              break;
            }
            continue;
          }
        }
        _tmp = _tmp$2;
      } else {
        _tmp = false;
      }
      if (_tmp) {
      } else {
        dot_atom = false;
        break;
      }
      continue;
    }
  }
  const _tmp = dot_atom ? user : _M0FP212moonbitstack8moonmail5quote(user);
  const _bind$4 = _M0MP212moonbitstack8moonmail5Lexer6domain(self);
  let _tmp$2;
  if (_bind$4.$tag === 1) {
    const _ok = _bind$4;
    _tmp$2 = _ok._0;
  } else {
    return _bind$4;
  }
  return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE2Ok(`${_tmp}@${_tmp$2}`);
}
function _M0MP212moonbitstack8moonmail5Lexer5angle(self) {
  const _bind = _M0MP212moonbitstack8moonmail5Lexer6expect(self, 60);
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _ok._0;
  } else {
    return _bind$2;
  }
  if (_M0IPC16option6OptionPB2Eq5equalGcE(_M0MP212moonbitstack8moonmail5Lexer4peek(self), _M0MP212moonbitstack8moonmail5Lexer5angleN6constrS3796)) {
    while (true) {
      if (_M0MP212moonbitstack8moonmail5Lexer3eat(self, 64) || _M0MP212moonbitstack8moonmail5Lexer3eat(self, 44)) {
        const _bind$3 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
        if (_bind$3.$tag === 1) {
          const _ok = _bind$3;
          _ok._0;
        } else {
          return _bind$3;
        }
        if (_M0IP016_24default__implPB2Eq10not__equalGOcE(_M0MP212moonbitstack8moonmail5Lexer4peek(self), _M0MP212moonbitstack8moonmail5Lexer5angleN6constrS3797) && _M0IP016_24default__implPB2Eq10not__equalGOcE(_M0MP212moonbitstack8moonmail5Lexer4peek(self), _M0MP212moonbitstack8moonmail5Lexer5angleN6constrS3798)) {
          const _bind$4 = _M0MP212moonbitstack8moonmail5Lexer6domain(self);
          if (_bind$4.$tag === 1) {
            const _ok = _bind$4;
            _ok._0;
          } else {
            return _bind$4;
          }
        }
        const _bind$4 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
        if (_bind$4.$tag === 1) {
          const _ok = _bind$4;
          _ok._0;
        } else {
          return _bind$4;
        }
        continue;
      } else {
        break;
      }
    }
    const _bind$3 = _M0MP212moonbitstack8moonmail5Lexer6expect(self, 58);
    if (_bind$3.$tag === 1) {
      const _ok = _bind$3;
      _ok._0;
    } else {
      return _bind$3;
    }
  }
  const _bind$3 = _M0MP212moonbitstack8moonmail5Lexer10addr__spec(self);
  let address;
  if (_bind$3.$tag === 1) {
    const _ok = _bind$3;
    address = _ok._0;
  } else {
    return _bind$3;
  }
  const _bind$4 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
  if (_bind$4.$tag === 1) {
    const _ok = _bind$4;
    _ok._0;
  } else {
    return _bind$4;
  }
  const _bind$5 = _M0MP212moonbitstack8moonmail5Lexer6expect(self, 62);
  if (_bind$5.$tag === 1) {
    const _ok = _bind$5;
    _ok._0;
  } else {
    return _bind$5;
  }
  return new _M0DTPC16result6ResultGsRP212moonbitstack8moonmail7RefusedE2Ok(address);
}
function _M0MP212moonbitstack8moonmail5Lexer6phrase(self) {
  const pieces = [];
  while (true) {
    const _bind = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
    let spaced;
    if (_bind.$tag === 1) {
      const _ok = _bind;
      spaced = _ok._0;
    } else {
      return _bind;
    }
    if (_M0IPC16option6OptionPB2Eq5equalGcE(_M0MP212moonbitstack8moonmail5Lexer4peek(self), _M0MP212moonbitstack8moonmail5Lexer6phraseN6constrS3802) && pieces.length > 0) {
      self.at = self.at + 1 | 0;
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(pieces, new _M0TP212moonbitstack8moonmail5Piece(".", spaced, false));
      continue;
    }
    const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer4word(self);
    let _bind$3;
    if (_bind$2.$tag === 1) {
      const _ok = _bind$2;
      _bind$3 = _ok._0;
    } else {
      return _bind$2;
    }
    if (_bind$3 === undefined) {
      break;
    } else {
      const _Some = _bind$3;
      const _x = _Some;
      const _text = _x._0;
      const _quoted = _x._1;
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(pieces, new _M0TP212moonbitstack8moonmail5Piece(_text, spaced, _quoted));
    }
    continue;
  }
  return new _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail5PieceERP212moonbitstack8moonmail7RefusedE2Ok(pieces);
}
function _M0MP212moonbitstack8moonmail5Lexer7mailbox(self) {
  const _bind = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  const start = self.at;
  const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer6phrase(self);
  let pieces;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    pieces = _ok._0;
  } else {
    return _bind$2;
  }
  const _bind$3 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
  if (_bind$3.$tag === 1) {
    const _ok = _bind$3;
    _ok._0;
  } else {
    return _bind$3;
  }
  if (_M0IPC16option6OptionPB2Eq5equalGcE(_M0MP212moonbitstack8moonmail5Lexer4peek(self), _M0MP212moonbitstack8moonmail5Lexer7mailboxN6constrS3812)) {
    const _bind$4 = _M0MP212moonbitstack8moonmail5Lexer5angle(self);
    let address;
    if (_bind$4.$tag === 1) {
      const _ok = _bind$4;
      address = _ok._0;
    } else {
      return _bind$4;
    }
    const name = _M0FP212moonbitstack8moonmail7display(pieces);
    return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail7MailboxRP212moonbitstack8moonmail7RefusedE2Ok(new _M0TP212moonbitstack8moonmail7Mailbox(name === "" ? undefined : name, address));
  }
  self.at = start;
  const _bind$4 = _M0MP212moonbitstack8moonmail5Lexer10addr__spec(self);
  let address;
  if (_bind$4.$tag === 1) {
    const _ok = _bind$4;
    address = _ok._0;
  } else {
    return _bind$4;
  }
  const _bind$5 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
  if (_bind$5.$tag === 1) {
    const _ok = _bind$5;
    _ok._0;
  } else {
    return _bind$5;
  }
  return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail7MailboxRP212moonbitstack8moonmail7RefusedE2Ok(new _M0TP212moonbitstack8moonmail7Mailbox(undefined, address));
}
function _M0MP212moonbitstack8moonmail5Lexer7address(self) {
  const start = self.at;
  const _bind = _M0MP212moonbitstack8moonmail5Lexer6phrase(self);
  let pieces;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    pieces = _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _ok._0;
  } else {
    return _bind$2;
  }
  _L: {
    const _bind$3 = _M0MP212moonbitstack8moonmail5Lexer4peek(self);
    if (_bind$3 === -1) {
      break _L;
    } else {
      const _Some = _bind$3;
      const _x = _Some;
      if (_x === 58) {
        if (pieces.length > 0) {
          self.at = self.at + 1 | 0;
          const members = [];
          while (true) {
            const _bind$4 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
            if (_bind$4.$tag === 1) {
              const _ok = _bind$4;
              _ok._0;
            } else {
              return _bind$4;
            }
            if (_M0MP212moonbitstack8moonmail5Lexer3eat(self, 59)) {
              break;
            }
            if (_M0MP212moonbitstack8moonmail5Lexer3eat(self, 44)) {
              continue;
            }
            const _bind$5 = _M0MP212moonbitstack8moonmail5Lexer7mailbox(self);
            let _tmp;
            if (_bind$5.$tag === 1) {
              const _ok = _bind$5;
              _tmp = _ok._0;
            } else {
              return _bind$5;
            }
            _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(members, _tmp);
            const _bind$6 = _M0MP212moonbitstack8moonmail5Lexer4cfws(self);
            if (_bind$6.$tag === 1) {
              const _ok = _bind$6;
              _ok._0;
            } else {
              return _bind$6;
            }
            const _bind$7 = _M0MP212moonbitstack8moonmail5Lexer4peek(self);
            if (_bind$7 === -1) {
            } else {
              const _Some$2 = _bind$7;
              const _c = _Some$2;
              if (_c !== 44) {
                if (_c !== 59) {
                  return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail7AddressRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eAddress(self.at));
                }
              }
            }
            continue;
          }
          return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail7AddressRP212moonbitstack8moonmail7RefusedE2Ok(new _M0DTP212moonbitstack8moonmail7Address5Group(_M0FP212moonbitstack8moonmail7display(pieces), members));
        } else {
          break _L;
        }
      } else {
        break _L;
      }
    }
  }
  self.at = start;
  const _bind$3 = _M0MP212moonbitstack8moonmail5Lexer7mailbox(self);
  let _tmp;
  if (_bind$3.$tag === 1) {
    const _ok = _bind$3;
    _tmp = _ok._0;
  } else {
    return _bind$3;
  }
  return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail7AddressRP212moonbitstack8moonmail7RefusedE2Ok(new _M0DTP212moonbitstack8moonmail7Address7Mailbox(_tmp));
}
function _M0MP212moonbitstack8moonmail5Lexer3new(text) {
  return new _M0TP212moonbitstack8moonmail5Lexer(_M0MPC16string10StringView9to__array(text), 0);
}
function _M0FP212moonbitstack8moonmail16parse__addresses(text) {
  const lex = _M0MP212moonbitstack8moonmail5Lexer3new(text);
  const out = [];
  while (true) {
    const _bind = _M0MP212moonbitstack8moonmail5Lexer4cfws(lex);
    if (_bind.$tag === 1) {
      const _ok = _bind;
      _ok._0;
    } else {
      return _bind;
    }
    if (lex.at >= lex.text.length) {
      break;
    }
    if (_M0MP212moonbitstack8moonmail5Lexer3eat(lex, 44)) {
      continue;
    }
    const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer7address(lex);
    let _tmp;
    if (_bind$2.$tag === 1) {
      const _ok = _bind$2;
      _tmp = _ok._0;
    } else {
      return _bind$2;
    }
    _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, _tmp);
    const _bind$3 = _M0MP212moonbitstack8moonmail5Lexer4cfws(lex);
    if (_bind$3.$tag === 1) {
      const _ok = _bind$3;
      _ok._0;
    } else {
      return _bind$3;
    }
    if (lex.at >= lex.text.length) {
      break;
    }
    if (!_M0MP212moonbitstack8moonmail5Lexer3eat(lex, 44)) {
      return new _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7AddressERP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eAddress(lex.at));
    }
    continue;
  }
  return new _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7AddressERP212moonbitstack8moonmail7RefusedE2Ok(out);
}
function _M0FP212moonbitstack8moonmail14is__attachment(message) {
  const _bind = _M0MP212moonbitstack8moonmail7Headers3get(message.headers, _M0FP212moonbitstack8moonmail14is__attachmentN6recordS3837);
  if (_bind === undefined) {
    return false;
  } else {
    const _Some = _bind;
    const _value = _Some;
    return _M0MPC16string6String9to__lower(_M0MP212moonbitstack8moonmime11Disposition5parse(new _M0TPC16string10StringView(_value, 0, _value.length)).kind) === "attachment";
  }
}
function _M0FP212moonbitstack8moonmail10find__body(message, subtype) {
  const kind = _M0MP212moonbitstack8moonmail7Message13content__type(message);
  const _bind = message.body;
  switch (_bind.$tag) {
    case 0: {
      return kind.essence === `text/${subtype}` && !_M0FP212moonbitstack8moonmail14is__attachment(message) ? message : undefined;
    }
    case 1: {
      const _Multipart = _bind;
      const _parts = _Multipart._0;
      const _bind$2 = _M0MP212moonbitstack8moonmime9MediaType7subtype(kind);
      switch (_bind$2) {
        case "alternative": {
          let _tmp = _parts.length - 1 | 0;
          while (true) {
            const i = _tmp;
            if (i >= 0) {
              const _bind$3 = _M0FP212moonbitstack8moonmail10find__body(_M0MPC15array5Array2atGUssEE(_parts, i), subtype);
              if (_bind$3 === undefined) {
              } else {
                const _Some = _bind$3;
                const _found = _Some;
                return _found;
              }
              _tmp = i - 1 | 0;
              continue;
            } else {
              break;
            }
          }
          return undefined;
        }
        case "related": {
          return _M0MPC16option6Option4bindGRP212moonbitstack8moonmail7MessageRP212moonbitstack8moonmail7MessageE(_M0MPC15array5Array3getGRP212moonbitstack8moonmail7MessageE(_parts, 0), (root) => _M0FP212moonbitstack8moonmail10find__body(root, subtype));
        }
        default: {
          const _bind$3 = _parts.length;
          let _tmp$2 = 0;
          while (true) {
            const _ = _tmp$2;
            if (_ < _bind$3) {
              const part = _parts[_];
              const _bind$4 = _M0FP212moonbitstack8moonmail10find__body(part, subtype);
              if (_bind$4 === undefined) {
              } else {
                const _Some = _bind$4;
                const _found = _Some;
                return _found;
              }
              _tmp$2 = _ + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          return undefined;
        }
      }
    }
    default: {
      return undefined;
    }
  }
}
function _M0MP212moonbitstack8moonmail7Message10body__text(self, subtype, charsets) {
  const _bind = _M0FP212moonbitstack8moonmail10find__body(self, subtype);
  if (_bind === undefined) {
    return new _M0DTPC16result6ResultGOsRP212moonbitstack8moonmail7RefusedE2Ok(undefined);
  } else {
    const _Some = _bind;
    const _part = _Some;
    const _bind$2 = _part.body;
    if (_bind$2.$tag === 0) {
      const _Leaf = _bind$2;
      const _data = _Leaf._0;
      const charset = _M0MPC16option6Option10unwrap__orGsE(_M0MP212moonbitstack8moonmime9MediaType5param(_M0MP212moonbitstack8moonmail7Message13content__type(_part), _M0MP212moonbitstack8moonmail7Message10body__textN6recordS3862), "us-ascii");
      let _tmp;
      let _try_err;
      _L: {
        _L$2: {
          const _bind$3 = _M0FP212moonbitstack8moonmime15decode__charset(new _M0TPC16string10StringView(charset, 0, charset.length), new _M0TPC15bytes9BytesView(_data, 0, _data.length), charsets);
          if (_bind$3.$tag === 1) {
            const _ok = _bind$3;
            _tmp = _ok._0;
          } else {
            const _err = _bind$3;
            _try_err = _err._0;
            break _L$2;
          }
          break _L;
        }
        return new _M0DTPC16result6ResultGOsRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eCharset(charset));
      }
      return new _M0DTPC16result6ResultGOsRP212moonbitstack8moonmail7RefusedE2Ok(_tmp);
    } else {
      return new _M0DTPC16result6ResultGOsRP212moonbitstack8moonmail7RefusedE2Ok(undefined);
    }
  }
}
function _M0MP212moonbitstack8moonmail7Message4text(self, charsets) {
  return _M0MP212moonbitstack8moonmail7Message10body__text(self, "plain", charsets);
}
function _M0FP212moonbitstack8moonmail13base64__lines(data) {
  const text = _M0FP312moonbitstack8moonbase6base646encode(new _M0TPC15bytes9BytesView(data, 0, data.length), undefined, -1);
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  let at = 0;
  while (true) {
    if (at < text.length) {
      const stop = (at + 76 | 0) < text.length ? at + 76 | 0 : text.length;
      _M0IPB13StringBuilderPB6Logger13write__string(out, _M0MPC16string10StringView9to__owned(_M0MPC16string6String21clamped__view_2einner(text, at, stop)));
      _M0IPB13StringBuilderPB6Logger13write__string(out, "\r\n");
      at = stop;
      continue;
    } else {
      break;
    }
  }
  const _bind = out.val;
  return _M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(_bind, 0, _bind.length), false);
}
function _M0FP212moonbitstack8moonmail12boundary__of(parts) {
  const hasher = _M0MP412moonbitstack9mooncrypt4hash4sha26Hasher3new(undefined);
  const _bind = parts.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const part = parts[_];
      _M0IP412moonbitstack9mooncrypt4hash4sha26HasherP312moonbitstack9mooncrypt4spec4Hash5write(hasher, new _M0TPC15bytes9BytesView(part, 0, part.length));
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const digest = _M0IP412moonbitstack9mooncrypt4hash4sha26HasherP312moonbitstack9mooncrypt4spec4Hash6finish(hasher);
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  _M0IPB13StringBuilderPB6Logger13write__string(out, "=_");
  const _bind$2 = _M0MPC15bytes5Bytes21clamped__view_2einner(digest, 0, _M0FP212moonbitstack8moonmail12boundary__ofN6constrS3884);
  const _bind$3 = _bind$2.end - _bind$2.start | 0;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$3) {
      const b = _bind$2.buf[_bind$2.start + _ | 0];
      const _tmp$3 = b / 16 | 0;
      const _p = _tmp$3 >>> 0 < _M0FP212moonbitstack8moonmail12boundary__ofN6digitsS3885.length ? _M0FP212moonbitstack8moonmail12boundary__ofN6digitsS3885.charCodeAt(_tmp$3) : $oob();
      _M0IPB13StringBuilderPB6Logger11write__char(out, _p);
      const _tmp$4 = b % 16 | 0;
      const _p$2 = _tmp$4 >>> 0 < _M0FP212moonbitstack8moonmail12boundary__ofN6digitsS3885.length ? _M0FP212moonbitstack8moonmail12boundary__ofN6digitsS3885.charCodeAt(_tmp$4) : $oob();
      _M0IPB13StringBuilderPB6Logger11write__char(out, _p$2);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return out.val;
}
function _M0FP212moonbitstack8moonmail4crlf(data) {
  const out = _M0MPC16buffer6Buffer14Buffer_2einner(data.length + 16 | 0);
  let i = 0;
  while (true) {
    if (i < data.length) {
      const _tmp = i;
      const b = _tmp >>> 0 < data.length ? data[_tmp] : $oob();
      if (b === 13) {
        _M0MPC16buffer6Buffer12write__bytes(out, _M0FP212moonbitstack8moonmail4crlfN6recordS3899);
        let _tmp$2;
        if ((i + 1 | 0) < data.length) {
          const _tmp$3 = i + 1 | 0;
          _tmp$2 = (_tmp$3 >>> 0 < data.length ? data[_tmp$3] : $oob()) === 10;
        } else {
          _tmp$2 = false;
        }
        if (_tmp$2) {
          i = i + 1 | 0;
        }
      } else {
        if (b === 10) {
          _M0MPC16buffer6Buffer12write__bytes(out, _M0FP212moonbitstack8moonmail4crlfN6recordS3900);
        } else {
          _M0MPC16buffer6Buffer11write__byte(out, b);
        }
      }
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0MPC16buffer6Buffer9to__bytes(out);
}
function _M0FP212moonbitstack8moonmail4fits(data, eight) {
  let run = 0;
  const _bind = data.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const b = data[_];
      if (b === 10 || b === 13) {
        run = 0;
      } else {
        run = run + 1 | 0;
        if (run > 998 || (!eight && b >= 128 || b === 0)) {
          return false;
        }
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0FP212moonbitstack8moonmail4fold(name, value) {
  const line = `${name}: ${value}`;
  const chars = _M0MPC16string6String9to__array(line);
  if (chars.length <= 78) {
    return `${line}\r\n`;
  }
  const out = _M0MPB13StringBuilder21StringBuilder_2einner(8);
  let start = 0;
  while (true) {
    if ((chars.length - start | 0) > 78) {
      const floor = start === 0 ? name.length + 2 | 0 : start + 1 | 0;
      const ceiling = (start + 78 | 0) < (chars.length - 1 | 0) ? start + 78 | 0 : chars.length - 1 | 0;
      let cut = -1;
      let _tmp = floor;
      let _tmp$2 = floor <= ceiling;
      while (true) {
        const i = _tmp;
        const _more = _tmp$2;
        if (_more) {
          const _p = _M0MPC15array5Array2atGcE(chars, i);
          if (_p === 32 || _p === 9) {
            cut = i;
          }
          _tmp = i + 1 | 0;
          _tmp$2 = i < ceiling;
          continue;
        } else {
          break;
        }
      }
      if (cut < 0) {
        const _bind = ceiling + 1 | 0;
        const _bind$2 = chars.length;
        let _tmp$3 = _bind;
        while (true) {
          const i = _tmp$3;
          if (i < _bind$2) {
            const _p = _M0MPC15array5Array2atGcE(chars, i);
            if (_p === 32 || _p === 9) {
              cut = i;
              break;
            }
            _tmp$3 = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
      }
      if (cut <= start) {
        break;
      }
      _M0IPB13StringBuilderPB6Logger13write__string(out, _M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(chars, start, cut)));
      _M0IPB13StringBuilderPB6Logger13write__string(out, "\r\n");
      start = cut;
      continue;
    } else {
      break;
    }
  }
  _M0IPB13StringBuilderPB6Logger13write__string(out, _M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(chars, start, undefined)));
  _M0IPB13StringBuilderPB6Logger13write__string(out, "\r\n");
  return out.val;
}
function _M0FP212moonbitstack8moonmail6phrase(name, utf8) {
  const _p = _M0MPC16string6String4iter(name);
  let ascii;
  while (true) {
    const _p$2 = _M0MPB4Iter4nextGcE(_p);
    if (_p$2 === -1) {
      ascii = true;
      break;
    } else {
      const _p$3 = _p$2;
      const _p$4 = _p$3;
      if (_p$4 < 128) {
      } else {
        ascii = false;
        break;
      }
      continue;
    }
  }
  if (!ascii && !utf8) {
    let _tmp;
    let _try_err;
    _L: {
      _L$2: {
        const _bind = _M0FP212moonbitstack8moonmime13encode__words(new _M0TPC16string10StringView(name, 0, name.length), undefined, undefined, undefined, undefined, undefined);
        if (_bind.$tag === 1) {
          const _ok = _bind;
          _tmp = _ok._0;
        } else {
          const _err = _bind;
          _try_err = _err._0;
          break _L$2;
        }
        break _L;
      }
      _tmp = _M0FP212moonbitstack8moonmail5quote(name);
    }
    return _tmp;
  }
  const words = _M0MPB4Iter9to__arrayGRPC16string10StringViewE(_M0MPC16string6String5split(name, _M0FP212moonbitstack8moonmail6phraseN6recordS3932));
  const _p$2 = _M0MPC15array5Array4iterGUssEE(words);
  let _tmp;
  while (true) {
    const _p$3 = _M0MPB4Iter4nextGUssEE(_p$2);
    if (_p$3 === undefined) {
      _tmp = true;
      break;
    } else {
      const _p$4 = _p$3;
      const _p$5 = _p$4;
      let _tmp$2;
      if (!((_p$5.end - _p$5.start | 0) === 0)) {
        const _p$6 = _M0MPC16string10StringView4iter(_p$5);
        let _tmp$3;
        while (true) {
          const _p$7 = _M0MPB4Iter4nextGcE(_p$6);
          if (_p$7 === -1) {
            _tmp$3 = true;
            break;
          } else {
            const _p$8 = _p$7;
            const _p$9 = _p$8;
            if (_M0FP212moonbitstack8moonmail9is__atext(_p$9)) {
            } else {
              _tmp$3 = false;
              break;
            }
            continue;
          }
        }
        _tmp$2 = _tmp$3;
      } else {
        _tmp$2 = false;
      }
      if (_tmp$2) {
      } else {
        _tmp = false;
        break;
      }
      continue;
    }
  }
  if (_tmp) {
    return name;
  } else {
    return _M0FP212moonbitstack8moonmail5quote(name);
  }
}
function _M0MP212moonbitstack8moonmail7Mailbox14encode_2einner(self, utf8) {
  _L: {
    const _bind = self.name;
    if (_bind === undefined) {
      break _L;
    } else {
      const _Some = _bind;
      const _x = _Some;
      if (_x === "") {
        break _L;
      } else {
        return `${_M0FP212moonbitstack8moonmail6phrase(_x, utf8)} <${self.address}>`;
      }
    }
  }
  return self.address;
}
function _M0MP212moonbitstack8moonmail7Address14encode_2einner(self, utf8) {
  if (self.$tag === 0) {
    const _Mailbox = self;
    const _m = _Mailbox._0;
    return _M0MP212moonbitstack8moonmail7Mailbox14encode_2einner(_m, utf8);
  } else {
    const _Group = self;
    const _name = _Group._0;
    const _members = _Group._1;
    const _tmp = _M0FP212moonbitstack8moonmail6phrase(_name, utf8);
    const _tmp$2 = _members.length === 0 ? "" : " ";
    const _p = new Array(_members.length);
    const _p$2 = _members.length;
    let _tmp$3 = 0;
    while (true) {
      const _p$3 = _tmp$3;
      if (_p$3 < _p$2) {
        const _p$4 = _members[_p$3];
        _p[_p$3] = _M0MP212moonbitstack8moonmail7Mailbox14encode_2einner(_p$4, utf8);
        _tmp$3 = _p$3 + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return `${_tmp}:${_tmp$2}${_M0MPC15array5Array4joinGsE(_p, _M0MP212moonbitstack8moonmail7Address14encode_2einnerN6recordS3947)};`;
  }
}
function _M0FP212moonbitstack8moonmail25encode__addresses_2einner(addresses, utf8) {
  const _p = new Array(addresses.end - addresses.start | 0);
  const _p$2 = addresses.end - addresses.start | 0;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _p$4 = addresses.buf[addresses.start + _p$3 | 0];
      _p[_p$3] = _M0MP212moonbitstack8moonmail7Address14encode_2einner(_p$4, utf8);
      _tmp = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0MPC15array5Array4joinGsE(_p, _M0FP212moonbitstack8moonmail25encode__addresses_2einnerN6recordS3956);
}
function _M0FP212moonbitstack8moonmail12header__text(name, value, utf8) {
  let _tmp;
  if (utf8) {
    _tmp = true;
  } else {
    const _p = _M0MPC16string6String4iter(value);
    let _tmp$2;
    while (true) {
      const _p$2 = _M0MPB4Iter4nextGcE(_p);
      if (_p$2 === -1) {
        _tmp$2 = true;
        break;
      } else {
        const _p$3 = _p$2;
        const _p$4 = _p$3;
        if (_p$4 < 128) {
        } else {
          _tmp$2 = false;
          break;
        }
        continue;
      }
    }
    _tmp = _tmp$2;
  }
  if (_tmp) {
    return value;
  }
  const lower = _M0MPC16string6String9to__lower(name);
  let address_field;
  switch (lower) {
    case "from": {
      address_field = true;
      break;
    }
    case "to": {
      address_field = true;
      break;
    }
    case "cc": {
      address_field = true;
      break;
    }
    case "bcc": {
      address_field = true;
      break;
    }
    case "reply-to": {
      address_field = true;
      break;
    }
    case "sender": {
      address_field = true;
      break;
    }
    default: {
      address_field = _M0MPC16string6String11has__prefix(lower, _M0FP212moonbitstack8moonmail12header__textN6recordS3960);
    }
  }
  if (address_field) {
    let list;
    let _try_err;
    _L: {
      _L$2: {
        const _bind = _M0FP212moonbitstack8moonmail16parse__addresses(new _M0TPC16string10StringView(value, 0, value.length));
        if (_bind.$tag === 1) {
          const _ok = _bind;
          list = _ok._0;
        } else {
          const _err = _bind;
          _try_err = _err._0;
          break _L$2;
        }
        break _L;
      }
      list = [];
    }
    if (!(list.length === 0)) {
      return _M0FP212moonbitstack8moonmail25encode__addresses_2einner(new _M0TPB9ArrayViewGRP212moonbitstack8moonmail7AddressE(list, 0, list.length), false);
    }
  }
  let _try_err;
  _L: {
    const _bind = _M0FP212moonbitstack8moonmime13encode__words(new _M0TPC16string10StringView(value, 0, value.length), undefined, undefined, name.length + 2 | 0, undefined, undefined);
    if (_bind.$tag === 1) {
      const _ok = _bind;
      return _ok._0;
    } else {
      const _err = _bind;
      _try_err = _err._0;
      break _L;
    }
  }
  return value;
}
function _M0MP212moonbitstack8moonmail7Headers4iter(self) {
  return _M0MPC15array5Array4iterGUssEE(self.fields);
}
function _M0MP212moonbitstack8moonmail7Message14encode_2einner(self, utf8) {
  const out = _M0MPC16buffer6Buffer14Buffer_2einner(0);
  _M0FP212moonbitstack8moonmail5write(self, out, utf8);
  return _M0MPC16buffer6Buffer9to__bytes(out);
}
function _M0FP212moonbitstack8moonmail5write(message, out, utf8) {
  const overrides = [];
  const body = _M0MPC16buffer6Buffer14Buffer_2einner(0);
  const _bind = message.body;
  switch (_bind.$tag) {
    case 0: {
      const _Leaf = _bind;
      const _data = _Leaf._0;
      const text = _M0MP212moonbitstack8moonmime9MediaType6type__(_M0MP212moonbitstack8moonmail7Message13content__type(message)) === "text";
      let declared;
      _L: {
        _L$2: {
          const _bind$2 = _M0FP212moonbitstack8moonmail12encoding__of(message.headers);
          if (_bind$2 === undefined) {
            declared = _bind$2;
            break _L$2;
          } else {
            const _Some = _bind$2;
            const _x = _Some;
            switch (_x) {
              case "base64": {
                const _bind$3 = _M0FP212moonbitstack8moonmail13base64__lines(_data);
                _M0MPC16buffer6Buffer12write__bytes(body, new _M0TPC15bytes9BytesView(_bind$3, 0, _bind$3.length));
                break;
              }
              case "quoted-printable": {
                const _bind$4 = _M0FP312moonbitstack8moonmime2qp6encode(new _M0TPC15bytes9BytesView(_data, 0, _data.length));
                _M0MPC16buffer6Buffer12write__bytes(body, new _M0TPC15bytes9BytesView(_bind$4, 0, _bind$4.length));
                break;
              }
              case "binary": {
                _M0MPC16buffer6Buffer12write__bytes(body, new _M0TPC15bytes9BytesView(_data, 0, _data.length));
                break;
              }
              default: {
                declared = _bind$2;
                break _L$2;
              }
            }
          }
          break _L;
        }
        let _tmp;
        if (declared === undefined) {
          _tmp = false;
        } else {
          const _Some = declared;
          const _x = _Some;
          if (_x === "8bit") {
            _tmp = true;
          } else {
            _tmp = false;
          }
        }
        if (_M0FP212moonbitstack8moonmail4fits(_data, _tmp)) {
          const _bind$2 = _M0FP212moonbitstack8moonmail4crlf(_data);
          _M0MPC16buffer6Buffer12write__bytes(body, new _M0TPC15bytes9BytesView(_bind$2, 0, _bind$2.length));
        } else {
          if (text) {
            _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(overrides, _M0FP212moonbitstack8moonmail5writeN5tupleS3976);
            const _bind$2 = _M0FP312moonbitstack8moonmime2qp6encode(new _M0TPC15bytes9BytesView(_data, 0, _data.length));
            _M0MPC16buffer6Buffer12write__bytes(body, new _M0TPC15bytes9BytesView(_bind$2, 0, _bind$2.length));
          } else {
            _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(overrides, _M0FP212moonbitstack8moonmail5writeN5tupleS3977);
            const _bind$2 = _M0FP212moonbitstack8moonmail13base64__lines(_data);
            _M0MPC16buffer6Buffer12write__bytes(body, new _M0TPC15bytes9BytesView(_bind$2, 0, _bind$2.length));
          }
        }
      }
      break;
    }
    case 1: {
      const _Multipart = _bind;
      const _parts = _Multipart._0;
      const _p = new Array(_parts.length);
      const _p$2 = _parts.length;
      let _tmp = 0;
      while (true) {
        const _p$3 = _tmp;
        if (_p$3 < _p$2) {
          const _p$4 = _parts[_p$3];
          _p[_p$3] = _M0MP212moonbitstack8moonmail7Message14encode_2einner(_p$4, utf8);
          _tmp = _p$3 + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      const encoded = _p;
      const kind = _M0MP212moonbitstack8moonmail7Message13content__type(message);
      let boundary;
      _L$2: {
        _L$3: {
          const _bind$2 = _M0MP212moonbitstack8moonmime9MediaType5param(kind, _M0FP212moonbitstack8moonmail5writeN6recordS3978);
          if (_bind$2 === undefined) {
            break _L$3;
          } else {
            const _Some = _bind$2;
            const _b = _Some;
            if (_M0MP212moonbitstack8moonmime9MediaType6type__(kind) === "multipart" && !(_b === "")) {
              boundary = _b;
            } else {
              break _L$3;
            }
          }
          break _L$2;
        }
        const fresh = _M0FP212moonbitstack8moonmail12boundary__of(encoded);
        const essence = _M0MP212moonbitstack8moonmime9MediaType6type__(kind) === "multipart" ? kind.essence : "multipart/mixed";
        _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(overrides, { _0: "Content-Type", _1: `${essence}; boundary=\"${fresh}\"` });
        boundary = fresh;
      }
      const _bind$2 = encoded.length;
      let _tmp$2 = 0;
      while (true) {
        const _ = _tmp$2;
        if (_ < _bind$2) {
          const part = encoded[_];
          const _bind$3 = `--${boundary}\r\n`;
          const _bind$4 = _M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(_bind$3, 0, _bind$3.length), false);
          _M0MPC16buffer6Buffer12write__bytes(body, new _M0TPC15bytes9BytesView(_bind$4, 0, _bind$4.length));
          _M0MPC16buffer6Buffer12write__bytes(body, new _M0TPC15bytes9BytesView(part, 0, part.length));
          _M0MPC16buffer6Buffer12write__bytes(body, _M0FP212moonbitstack8moonmail5writeN6recordS3979);
          _tmp$2 = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      const _bind$3 = `--${boundary}--\r\n`;
      const _bind$4 = _M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(_bind$3, 0, _bind$3.length), false);
      _M0MPC16buffer6Buffer12write__bytes(body, new _M0TPC15bytes9BytesView(_bind$4, 0, _bind$4.length));
      break;
    }
    default: {
      const _Embedded = _bind;
      const _inner = _Embedded._0;
      const _bind$5 = _M0MP212moonbitstack8moonmail7Message14encode_2einner(_inner, utf8);
      _M0MPC16buffer6Buffer12write__bytes(body, new _M0TPC15bytes9BytesView(_bind$5, 0, _bind$5.length));
    }
  }
  const written = [];
  const _it = _M0MP212moonbitstack8moonmail7Headers4iter(message.headers);
  while (true) {
    const _bind$6 = _M0MPB4Iter4nextGUssEE(_it);
    if (_bind$6 === undefined) {
      break;
    } else {
      const _Some = _bind$6;
      const _field = _Some;
      const _name = _field._0;
      const _value = _field._1;
      const _p$3 = overrides.length;
      let _bind$7;
      let _tmp$3 = 0;
      while (true) {
        const _p$4 = _tmp$3;
        if (_p$4 < _p$3) {
          const _p$5 = overrides[_p$4];
          const _p$6 = _p$5._0;
          if (_M0FP212moonbitstack8moonmail4same(new _M0TPC16string10StringView(_p$6, 0, _p$6.length), new _M0TPC16string10StringView(_name, 0, _name.length))) {
            _bind$7 = _p$4;
            break;
          }
          _tmp$3 = _p$4 + 1 | 0;
          continue;
        } else {
          _bind$7 = undefined;
          break;
        }
      }
      let value;
      if (_bind$7 === undefined) {
        value = _value;
      } else {
        const _Some$2 = _bind$7;
        const _i = _Some$2;
        _M0MPC15array5Array4pushGiE(written, _i);
        value = _M0MPC15array5Array2atGUssEE(overrides, _i)._1;
      }
      const _bind$8 = _M0FP212moonbitstack8moonmail4fold(_name, _M0FP212moonbitstack8moonmail12header__text(_name, value, utf8));
      const _bind$9 = _M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(_bind$8, 0, _bind$8.length), false);
      _M0MPC16buffer6Buffer12write__bytes(out, new _M0TPC15bytes9BytesView(_bind$9, 0, _bind$9.length));
      continue;
    }
  }
  const _bind$6 = overrides.length;
  let _tmp$3 = 0;
  while (true) {
    const i = _tmp$3;
    if (i < _bind$6) {
      const field = overrides[i];
      if (!_M0MPC15array5Array8containsGiE(written, i)) {
        const _bind$7 = _M0FP212moonbitstack8moonmail4fold(field._0, field._1);
        const _bind$8 = _M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(_bind$7, 0, _bind$7.length), false);
        _M0MPC16buffer6Buffer12write__bytes(out, new _M0TPC15bytes9BytesView(_bind$8, 0, _bind$8.length));
      }
      _tmp$3 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC16buffer6Buffer12write__bytes(out, _M0FP212moonbitstack8moonmail5writeN6recordS3980);
  const _bind$7 = _M0MPC16buffer6Buffer9to__bytes(body);
  _M0MPC16buffer6Buffer12write__bytes(out, new _M0TPC15bytes9BytesView(_bind$7, 0, _bind$7.length));
}
function _M0MP212moonbitstack8moonmail7Headers3new() {
  return new _M0TP212moonbitstack8moonmail7Headers([]);
}
function _M0FP212moonbitstack8moonmail5check(name, value) {
  if (name === "") {
    return new _M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error42moonbitstack_2fmoonmail_2eRefused_2eHeader(0));
  }
  const _bind = _M0MPC16string6String9to__array(name);
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind$2) {
      const c = _bind[i];
      if (c < 33 || (c > 126 || c === 58)) {
        return new _M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error42moonbitstack_2fmoonmail_2eRefused_2eHeader(i));
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$3 = _M0MPC16string6String9to__array(value);
  const _bind$4 = _bind$3.length;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp$2;
    if (i < _bind$4) {
      const c = _bind$3[i];
      if (c === 13 || c === 10) {
        return new _M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error42moonbitstack_2fmoonmail_2eRefused_2eHeader(i));
      }
      _tmp$2 = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE2Ok(undefined);
}
function _M0MP212moonbitstack8moonmail7Headers3add(self, name, value) {
  const _bind = _M0FP212moonbitstack8moonmail5check(name, value);
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  return new _M0DTPC16result6ResultGuRP212moonbitstack8moonmail7RefusedE2Ok(_M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(self.fields, { _0: name, _1: value }));
}
function _M0FP212moonbitstack8moonmail12format__date(moment) {
  return _M0MP212moonbitstack8moondate6Moment8strftime(moment, _M0FP212moonbitstack8moonmail12format__dateN6recordS4063);
}
function _M0MP212moonbitstack8moonmail10Attachment11new_2einner(name, data, media_type, inline, id) {
  return new _M0TP212moonbitstack8moonmail10Attachment(name, _M0MPC16option6Option16unwrap__or__elseGsE(media_type, () => _M0FP212moonbitstack8moonmime11guess__type(new _M0TPC16string10StringView(name, 0, name.length))), data, inline, id);
}
function _M0FP212moonbitstack8moonmail17container_2einner(subtype, parts, extra) {
  const _p = new Array(parts.length);
  const _p$2 = parts.length;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _p$4 = parts[_p$3];
      _p[_p$3] = _M0MP212moonbitstack8moonmail7Message14encode_2einner(_p$4, true);
      _tmp = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const boundary = _M0FP212moonbitstack8moonmail12boundary__of(_p);
  const headers = _M0MP212moonbitstack8moonmail7Headers3new();
  const _bind = _M0MP212moonbitstack8moonmail7Headers3add(headers, "Content-Type", `multipart/${subtype}; boundary=\"${boundary}\"${extra}`);
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail7MessageRP212moonbitstack8moonmail7RefusedE2Ok(new _M0TP212moonbitstack8moonmail7Message(headers, new _M0DTP212moonbitstack8moonmail4Body9Multipart(parts)));
}
function _M0FP212moonbitstack8moonmail10leaf__file(file) {
  const headers = _M0MP212moonbitstack8moonmail7Headers3new();
  const _bind = _M0MP212moonbitstack8moonmail7Headers3add(headers, "Content-Type", file.media_type);
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = file.name;
  const _bind$3 = _M0MP212moonbitstack8moonmail7Headers3add(headers, "Content-Disposition", _M0FP212moonbitstack8moonmime28content__disposition_2einner(new _M0TPC16string10StringView(_bind$2, 0, _bind$2.length), file.inline));
  if (_bind$3.$tag === 1) {
    const _ok = _bind$3;
    _ok._0;
  } else {
    return _bind$3;
  }
  const _bind$4 = file.id;
  if (_bind$4 === undefined) {
  } else {
    const _Some = _bind$4;
    const _id = _Some;
    const _bind$5 = _M0MP212moonbitstack8moonmail7Headers3add(headers, "Content-ID", `<${_id}>`);
    if (_bind$5.$tag === 1) {
      const _ok = _bind$5;
      _ok._0;
    } else {
      return _bind$5;
    }
  }
  const _bind$5 = _M0MP212moonbitstack8moonmail7Headers3add(headers, "Content-Transfer-Encoding", "base64");
  if (_bind$5.$tag === 1) {
    const _ok = _bind$5;
    _ok._0;
  } else {
    return _bind$5;
  }
  return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail7MessageRP212moonbitstack8moonmail7RefusedE2Ok(new _M0TP212moonbitstack8moonmail7Message(headers, new _M0DTP212moonbitstack8moonmail4Body4Leaf(file.data)));
}
function _M0FP212moonbitstack8moonmail10leaf__text(subtype, text) {
  const data = _M0FP212moonbitstack8moonmail4crlf(_M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(text, 0, text.length), false));
  const headers = _M0MP212moonbitstack8moonmail7Headers3new();
  const _bind = _M0MP212moonbitstack8moonmail7Headers3add(headers, "Content-Type", `text/${subtype}; charset=\"utf-8\"`);
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0MP212moonbitstack8moonmail7Headers3add(headers, "Content-Transfer-Encoding", _M0FP212moonbitstack8moonmail4fits(data, false) ? "7bit" : "quoted-printable");
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _ok._0;
  } else {
    return _bind$2;
  }
  return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail7MessageRP212moonbitstack8moonmail7RefusedE2Ok(new _M0TP212moonbitstack8moonmail7Message(headers, new _M0DTP212moonbitstack8moonmail4Body4Leaf(data)));
}
function _M0MP212moonbitstack8moonmail7Message3new(from, to, subject, text, html, attachments, cc, date, message_id) {
  const attachments$2 = _M0MPC16option6Option10unwrap__orGRPB5ArrayGRP212moonbitstack8moonmail10AttachmentEE(attachments, []);
  let core;
  if (text === undefined) {
    if (html === undefined) {
      const _bind = _M0FP212moonbitstack8moonmail10leaf__text("plain", "");
      if (_bind.$tag === 1) {
        const _ok = _bind;
        core = _ok._0;
      } else {
        return _bind;
      }
    } else {
      const _Some = html;
      const _h = _Some;
      const _bind = _M0FP212moonbitstack8moonmail10leaf__text("html", _h);
      if (_bind.$tag === 1) {
        const _ok = _bind;
        core = _ok._0;
      } else {
        return _bind;
      }
    }
  } else {
    const _Some = text;
    const _t = _Some;
    if (html === undefined) {
      const _bind = _M0FP212moonbitstack8moonmail10leaf__text("plain", _t);
      if (_bind.$tag === 1) {
        const _ok = _bind;
        core = _ok._0;
      } else {
        return _bind;
      }
    } else {
      const _Some$2 = html;
      const _h = _Some$2;
      const _bind = _M0FP212moonbitstack8moonmail10leaf__text("plain", _t);
      let _tmp;
      if (_bind.$tag === 1) {
        const _ok = _bind;
        _tmp = _ok._0;
      } else {
        return _bind;
      }
      const _tmp$2 = _tmp;
      const _bind$2 = _M0FP212moonbitstack8moonmail10leaf__text("html", _h);
      let _tmp$3;
      if (_bind$2.$tag === 1) {
        const _ok = _bind$2;
        _tmp$3 = _ok._0;
      } else {
        return _bind$2;
      }
      const _bind$3 = _M0FP212moonbitstack8moonmail17container_2einner("alternative", [_tmp$2, _tmp$3], "");
      if (_bind$3.$tag === 1) {
        const _ok = _bind$3;
        core = _ok._0;
      } else {
        return _bind$3;
      }
    }
  }
  const inline = _M0MPC15array5Array6filterGRP212moonbitstack8moonmail10AttachmentE(attachments$2, (a) => {
    if (a.inline) {
      const _bind = a.id;
      return !(_bind === undefined);
    } else {
      return false;
    }
  });
  let related;
  if (inline.length === 0) {
    related = core;
  } else {
    const _tmp = [core];
    let _bind;
    let _p;
    _L: {
      _L$2: {
        const _p$2 = new Array(inline.length);
        const _p$3 = inline.length;
        let _tmp$2 = 0;
        while (true) {
          const _p$4 = _tmp$2;
          if (_p$4 < _p$3) {
            const _p$5 = inline[_p$4];
            const _bind$2 = _M0FP212moonbitstack8moonmail10leaf__file(_p$5);
            let _tmp$3;
            if (_bind$2.$tag === 1) {
              const _ok = _bind$2;
              _tmp$3 = _ok._0;
            } else {
              const _err = _bind$2;
              _p = _err._0;
              break _L$2;
            }
            _p$2[_p$4] = _tmp$3;
            _tmp$2 = _p$4 + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        _bind = new _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7MessageERP212moonbitstack8moonmail7RefusedE2Ok(_p$2);
        break _L;
      }
      _bind = new _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7MessageERP212moonbitstack8moonmail7RefusedE3Err(_p);
    }
    let _tmp$2;
    if (_bind.$tag === 1) {
      const _ok = _bind;
      _tmp$2 = _ok._0;
    } else {
      return _bind;
    }
    const _bind$2 = _M0FP212moonbitstack8moonmail17container_2einner("related", _M0IPC15array5ArrayPB3Add3addGsE(_tmp, _tmp$2), `; type=\"${_M0MP212moonbitstack8moonmail7Message13content__type(core).essence}\"`);
    if (_bind$2.$tag === 1) {
      const _ok = _bind$2;
      related = _ok._0;
    } else {
      return _bind$2;
    }
  }
  const attached = _M0MPC15array5Array6filterGRP212moonbitstack8moonmail10AttachmentE(attachments$2, (a) => {
    let _tmp;
    if (a.inline) {
      const _bind = a.id;
      _tmp = !(_bind === undefined);
    } else {
      _tmp = false;
    }
    return !_tmp;
  });
  let top;
  if (attached.length === 0) {
    top = related;
  } else {
    const _tmp = [related];
    let _bind;
    let _p;
    _L: {
      _L$2: {
        const _p$2 = new Array(attached.length);
        const _p$3 = attached.length;
        let _tmp$2 = 0;
        while (true) {
          const _p$4 = _tmp$2;
          if (_p$4 < _p$3) {
            const _p$5 = attached[_p$4];
            const _bind$2 = _M0FP212moonbitstack8moonmail10leaf__file(_p$5);
            let _tmp$3;
            if (_bind$2.$tag === 1) {
              const _ok = _bind$2;
              _tmp$3 = _ok._0;
            } else {
              const _err = _bind$2;
              _p = _err._0;
              break _L$2;
            }
            _p$2[_p$4] = _tmp$3;
            _tmp$2 = _p$4 + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        _bind = new _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7MessageERP212moonbitstack8moonmail7RefusedE2Ok(_p$2);
        break _L;
      }
      _bind = new _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7MessageERP212moonbitstack8moonmail7RefusedE3Err(_p);
    }
    let _tmp$2;
    if (_bind.$tag === 1) {
      const _ok = _bind;
      _tmp$2 = _ok._0;
    } else {
      return _bind;
    }
    const _bind$2 = _M0FP212moonbitstack8moonmail17container_2einner("mixed", _M0IPC15array5ArrayPB3Add3addGsE(_tmp, _tmp$2), "");
    if (_bind$2.$tag === 1) {
      const _ok = _bind$2;
      top = _ok._0;
    } else {
      return _bind$2;
    }
  }
  const headers = _M0MP212moonbitstack8moonmail7Headers3new();
  const _bind = _M0MP212moonbitstack8moonmail7Headers3add(headers, "From", _M0MP212moonbitstack8moonmail7Mailbox14encode_2einner(from, true));
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _ok._0;
  } else {
    return _bind;
  }
  if (!(to.length === 0)) {
    const _bind$2 = _M0MP212moonbitstack8moonmail7Headers3add(headers, "To", _M0FP212moonbitstack8moonmail25encode__addresses_2einner(new _M0TPB9ArrayViewGRP212moonbitstack8moonmail7AddressE(to, 0, to.length), true));
    if (_bind$2.$tag === 1) {
      const _ok = _bind$2;
      _ok._0;
    } else {
      return _bind$2;
    }
  }
  if (cc.$tag === 1) {
    const _Some = cc;
    const _list = _Some._0;
    if (!(_list.length === 0)) {
      const _bind$2 = _M0MP212moonbitstack8moonmail7Headers3add(headers, "Cc", _M0FP212moonbitstack8moonmail25encode__addresses_2einner(new _M0TPB9ArrayViewGRP212moonbitstack8moonmail7AddressE(_list, 0, _list.length), true));
      if (_bind$2.$tag === 1) {
        const _ok = _bind$2;
        _ok._0;
      } else {
        return _bind$2;
      }
    }
  }
  const _bind$2 = _M0MP212moonbitstack8moonmail7Headers3add(headers, "Subject", subject);
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _ok._0;
  } else {
    return _bind$2;
  }
  if (date === undefined) {
  } else {
    const _Some = date;
    const _moment = _Some;
    const _bind$3 = _M0MP212moonbitstack8moonmail7Headers3add(headers, "Date", _M0FP212moonbitstack8moonmail12format__date(_moment));
    if (_bind$3.$tag === 1) {
      const _ok = _bind$3;
      _ok._0;
    } else {
      return _bind$3;
    }
  }
  if (message_id === undefined) {
  } else {
    const _Some = message_id;
    const _id = _Some;
    const _bind$3 = _M0MP212moonbitstack8moonmail7Headers3add(headers, "Message-ID", _id);
    if (_bind$3.$tag === 1) {
      const _ok = _bind$3;
      _ok._0;
    } else {
      return _bind$3;
    }
  }
  const _bind$3 = _M0MP212moonbitstack8moonmail7Headers3add(headers, "MIME-Version", "1.0");
  if (_bind$3.$tag === 1) {
    const _ok = _bind$3;
    _ok._0;
  } else {
    return _bind$3;
  }
  const _it = _M0MP212moonbitstack8moonmail7Headers4iter(top.headers);
  while (true) {
    const _bind$4 = _M0MPB4Iter4nextGUssEE(_it);
    if (_bind$4 === undefined) {
      break;
    } else {
      const _Some = _bind$4;
      const _field = _Some;
      const _bind$5 = _M0MP212moonbitstack8moonmail7Headers3add(headers, _field._0, _field._1);
      if (_bind$5.$tag === 1) {
        const _ok = _bind$5;
        _ok._0;
      } else {
        return _bind$5;
      }
      continue;
    }
  }
  return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail7MessageRP212moonbitstack8moonmail7RefusedE2Ok(new _M0TP212moonbitstack8moonmail7Message(headers, top.body));
}
function _M0FP212moonbitstack8moonmail14parse__address(text) {
  const lex = _M0MP212moonbitstack8moonmail5Lexer3new(text);
  const _bind = _M0MP212moonbitstack8moonmail5Lexer7address(lex);
  let address;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    address = _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0MP212moonbitstack8moonmail5Lexer4cfws(lex);
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _ok._0;
  } else {
    return _bind$2;
  }
  if (!(lex.at >= lex.text.length)) {
    return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail7AddressRP212moonbitstack8moonmail7RefusedE3Err(new _M0DTPC15error5Error43moonbitstack_2fmoonmail_2eRefused_2eAddress(lex.at));
  }
  return new _M0DTPC16result6ResultGRP212moonbitstack8moonmail7AddressRP212moonbitstack8moonmail7RefusedE2Ok(address);
}
function _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__repr(_x_196) {
  switch (_x_196.$tag) {
    case 28: {
      const _Malformed = _x_196;
      const _$42$arg_197 = _Malformed._0;
      return _M0MPC15debug4Repr4ctor("Malformed", [{ _0: _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4126, _1: _M0IPC16string6StringPC15debug5Debug8to__repr(_$42$arg_197) }]);
    }
    case 27: {
      return _M0MPC15debug4Repr4ctor("NotAnObject", []);
    }
    case 26: {
      const _Missing = _x_196;
      const _$42$arg_198 = _Missing._0;
      return _M0MPC15debug4Repr4ctor("Missing", [{ _0: _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4127, _1: _M0IPC16string6StringPC15debug5Debug8to__repr(_$42$arg_198) }]);
    }
    case 25: {
      const _WrongType = _x_196;
      const _$42$arg_199 = _WrongType._0;
      return _M0MPC15debug4Repr4ctor("WrongType", [{ _0: _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4128, _1: _M0IPC16string6StringPC15debug5Debug8to__repr(_$42$arg_199) }]);
    }
    case 24: {
      const _BadUrl = _x_196;
      const _$42$arg_200 = _BadUrl._0;
      return _M0MPC15debug4Repr4ctor("BadUrl", [{ _0: _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4129, _1: _M0IPC16string6StringPC15debug5Debug8to__repr(_$42$arg_200) }]);
    }
    default: {
      const _Failed = _x_196;
      const _$42$arg_201 = _Failed._0;
      const _$42$arg_202 = _Failed._1;
      const _$42$arg_203 = _Failed._2;
      return _M0MPC15debug4Repr4ctor("Failed", [{ _0: _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4130, _1: _M0IPC16string6StringPC15debug5Debug8to__repr(_$42$arg_201) }, { _0: _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4131, _1: _M0IPC16string6StringPC15debug5Debug8to__repr(_$42$arg_202) }, { _0: _M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__reprN6constrS4132, _1: _M0IPC16string6StringPC15debug5Debug8to__repr(_$42$arg_203) }]);
    }
  }
}
function _M0FP312moonbitstack8moonmail4jmap8optional(json, name) {
  if (json.$tag === 6) {
    const _Object = json;
    const _map = _Object._0;
    return _M0MPB3Map3getGsRPB4JsonE(_map, name);
  } else {
    return undefined;
  }
}
function _M0FP312moonbitstack8moonmail4jmap9text__opt(json, name) {
  _L: {
    const _bind = _M0FP312moonbitstack8moonmail4jmap8optional(json, name);
    if (_bind === undefined) {
      break _L;
    } else {
      const _Some = _bind;
      const _x = _Some;
      if (_x.$tag === 4) {
        const _String = _x;
        const _value = _String._0;
        return _value;
      } else {
        break _L;
      }
    }
  }
  return undefined;
}
function _M0FP312moonbitstack8moonmail4jmap12one__address(json) {
  if (json.$tag === 5) {
    const _Array = json;
    const _entries = _Array._0;
    if (_entries.length === 0) {
      return undefined;
    } else {
      const first = _M0MPC15array5Array2atGUssEE(_entries, 0);
      const email = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(first, "email"), "");
      _L: {
        const _bind = _M0FP312moonbitstack8moonmail4jmap9text__opt(first, "name");
        if (_bind === undefined) {
          break _L;
        } else {
          const _Some = _bind;
          const _name = _Some;
          const _p = "";
          if (!(_name === _p)) {
            return `${_name} <${email}>`;
          } else {
            break _L;
          }
        }
      }
      return email === "" ? undefined : email;
    }
  } else {
    return undefined;
  }
}
function _M0FP312moonbitstack8moonmail4jmap12string__list(json, name) {
  const out = [];
  const _bind = _M0FP312moonbitstack8moonmail4jmap8optional(json, name);
  if (_bind === undefined) {
  } else {
    const _Some = _bind;
    const _x = _Some;
    if (_x.$tag === 5) {
      const _Array = _x;
      const _entries = _Array._0;
      const _bind$2 = _entries.length;
      let _tmp = 0;
      while (true) {
        const _ = _tmp;
        if (_ < _bind$2) {
          const entry = _entries[_];
          if (entry.$tag === 4) {
            const _String = entry;
            const _value = _String._0;
            _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, _value);
          }
          _tmp = _ + 1 | 0;
          continue;
        } else {
          break;
        }
      }
    }
  }
  return out;
}
function _M0FP312moonbitstack8moonmail4jmap3int(json, name) {
  const _bind = _M0FP312moonbitstack8moonmail4jmap8optional(json, name);
  if (_bind === undefined) {
    return 0;
  } else {
    const _Some = _bind;
    const _x = _Some;
    if (_x.$tag === 3) {
      const _Number = _x;
      const _value = _Number._0;
      return _M0MPC16double6Double7to__int(_value);
    } else {
      return 0;
    }
  }
}
function _M0FP312moonbitstack8moonmail4jmap10object__of(json) {
  if (json.$tag === 6) {
    const _Object = json;
    const _map = _Object._0;
    return new _M0DTPC16result6ResultGRPB3MapGsRPB4JsonERP312moonbitstack8moonmail4jmap7RefusedE2Ok(_map);
  } else {
    return new _M0DTPC16result6ResultGRPB3MapGsRPB4JsonERP312moonbitstack8moonmail4jmap7RefusedE3Err(_M0DTPC15error5Error54moonbitstack_2fmoonmail_2fjmap_2eRefused_2eNotAnObject__);
  }
}
function _M0FP312moonbitstack8moonmail4jmap5field(json, name) {
  const _bind = _M0FP312moonbitstack8moonmail4jmap10object__of(json);
  let map;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    map = _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0MPB3Map3getGsRPB4JsonE(map, name);
  if (_bind$2 === undefined) {
    return new _M0DTPC16result6ResultGRPB4JsonRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error50moonbitstack_2fmoonmail_2fjmap_2eRefused_2eMissing(name));
  } else {
    const _Some = _bind$2;
    const _value = _Some;
    return new _M0DTPC16result6ResultGRPB4JsonRP312moonbitstack8moonmail4jmap7RefusedE2Ok(_value);
  }
}
function _M0FP312moonbitstack8moonmail4jmap5items(json, name) {
  const _bind = _M0FP312moonbitstack8moonmail4jmap5field(json, name);
  let _bind$2;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _bind$2 = _ok._0;
  } else {
    return _bind;
  }
  if (_bind$2.$tag === 5) {
    const _Array = _bind$2;
    const _list = _Array._0;
    return new _M0DTPC16result6ResultGRPB5ArrayGRPB4JsonERP312moonbitstack8moonmail4jmap7RefusedE2Ok(_list);
  } else {
    return new _M0DTPC16result6ResultGRPB5ArrayGRPB4JsonERP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error52moonbitstack_2fmoonmail_2fjmap_2eRefused_2eWrongType(name));
  }
}
function _M0FP312moonbitstack8moonmail4jmap4text(json, name) {
  const _bind = _M0FP312moonbitstack8moonmail4jmap5field(json, name);
  let _bind$2;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    _bind$2 = _ok._0;
  } else {
    return _bind;
  }
  if (_bind$2.$tag === 4) {
    const _String = _bind$2;
    const _value = _String._0;
    return new _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE2Ok(_value);
  } else {
    return new _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error52moonbitstack_2fmoonmail_2fjmap_2eRefused_2eWrongType(name));
  }
}
function _M0MP312moonbitstack8moonmail4jmap8Response10invocation(self, tag) {
  const _bind = self.invocations;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const invocation = _bind[_];
      if (invocation.tag === tag) {
        return invocation;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0MP312moonbitstack8moonmail4jmap8Response6answer(self, tag) {
  const _bind = _M0MP312moonbitstack8moonmail4jmap8Response10invocation(self, tag);
  let invocation;
  if (_bind === undefined) {
    return new _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap10InvocationRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error50moonbitstack_2fmoonmail_2fjmap_2eRefused_2eMissing(tag));
  } else {
    const _Some = _bind;
    invocation = _Some;
  }
  if (invocation.name === "error") {
    return new _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap10InvocationRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error49moonbitstack_2fmoonmail_2fjmap_2eRefused_2eFailed(_M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(invocation.args, "description"), tag), _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(invocation.args, "type"), "unknown"), _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(invocation.args, "description"), "")));
  }
  return new _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap10InvocationRP312moonbitstack8moonmail4jmap7RefusedE2Ok(invocation);
}
function _M0FP312moonbitstack8moonmail4jmap9mailboxes(response, tag) {
  const _bind = _M0MP312moonbitstack8moonmail4jmap8Response6answer(response, tag);
  let answer;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    answer = _ok._0;
  } else {
    return _bind;
  }
  const out = [];
  const _bind$2 = _M0FP312moonbitstack8moonmail4jmap5items(answer.args, "list");
  let _bind$3;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _bind$3 = _ok._0;
  } else {
    return _bind$2;
  }
  const _bind$4 = _bind$3.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$4) {
      const entry = _bind$3[_];
      const _bind$5 = _M0FP312moonbitstack8moonmail4jmap4text(entry, "id");
      let _tmp$2;
      if (_bind$5.$tag === 1) {
        const _ok = _bind$5;
        _tmp$2 = _ok._0;
      } else {
        return _bind$5;
      }
      const _tmp$3 = _tmp$2;
      const _bind$6 = _M0FP312moonbitstack8moonmail4jmap4text(entry, "name");
      let _tmp$4;
      if (_bind$6.$tag === 1) {
        const _ok = _bind$6;
        _tmp$4 = _ok._0;
      } else {
        return _bind$6;
      }
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, new _M0TP312moonbitstack8moonmail4jmap7Mailbox(_tmp$3, _tmp$4, _M0FP312moonbitstack8moonmail4jmap9text__opt(entry, "role"), _M0FP312moonbitstack8moonmail4jmap9text__opt(entry, "parentId"), _M0FP312moonbitstack8moonmail4jmap3int(entry, "totalEmails"), _M0FP312moonbitstack8moonmail4jmap3int(entry, "unreadEmails")));
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap7MailboxERP312moonbitstack8moonmail4jmap7RefusedE2Ok(out);
}
function _M0FP312moonbitstack8moonmail4jmap10email__ids(response, tag) {
  const _bind = _M0MP312moonbitstack8moonmail4jmap8Response6answer(response, tag);
  let answer;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    answer = _ok._0;
  } else {
    return _bind;
  }
  return new _M0DTPC16result6ResultGRPB5ArrayGsERP312moonbitstack8moonmail4jmap7RefusedE2Ok(_M0FP312moonbitstack8moonmail4jmap12string__list(answer.args, "ids"));
}
function _M0FP312moonbitstack8moonmail4jmap15field__or__null(json, name) {
  const _bind = _M0FP312moonbitstack8moonmail4jmap8optional(json, name);
  if (_bind === undefined) {
    return _M0DTPB4Json4Null__;
  } else {
    const _Some = _bind;
    return _Some;
  }
}
function _M0FP312moonbitstack8moonmail4jmap6emails(response, tag) {
  const _bind = _M0MP312moonbitstack8moonmail4jmap8Response6answer(response, tag);
  let answer;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    answer = _ok._0;
  } else {
    return _bind;
  }
  const out = [];
  const _bind$2 = _M0FP312moonbitstack8moonmail4jmap5items(answer.args, "list");
  let _bind$3;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _bind$3 = _ok._0;
  } else {
    return _bind$2;
  }
  const _bind$4 = _bind$3.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$4) {
      const entry = _bind$3[_];
      let keywords;
      _L: {
        _L$2: {
          const _bind$5 = _M0FP312moonbitstack8moonmail4jmap8optional(entry, "keywords");
          if (_bind$5 === undefined) {
            break _L$2;
          } else {
            const _Some = _bind$5;
            const _x = _Some;
            if (_x.$tag === 6) {
              const _Object = _x;
              keywords = _Object._0;
            } else {
              break _L$2;
            }
          }
          break _L;
        }
        const _bind$5 = [];
        keywords = _M0MPB3Map3MapGsRPB4JsonE(new _M0TPB9ArrayViewGUsRPB4JsonEE(_bind$5, 0, 0), undefined);
      }
      const _bind$5 = _M0FP312moonbitstack8moonmail4jmap4text(entry, "id");
      let _tmp$2;
      if (_bind$5.$tag === 1) {
        const _ok = _bind$5;
        _tmp$2 = _ok._0;
      } else {
        return _bind$5;
      }
      const _tmp$3 = _tmp$2;
      const _tmp$4 = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(entry, "subject"), "(no subject)");
      const _tmp$5 = _M0FP312moonbitstack8moonmail4jmap12one__address(_M0FP312moonbitstack8moonmail4jmap15field__or__null(entry, "from"));
      const _tmp$6 = _M0FP312moonbitstack8moonmail4jmap9text__opt(entry, "receivedAt");
      const _tmp$7 = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(entry, "preview"), "");
      const _bind$6 = _M0MPB3Map3getGsRPB4JsonE(keywords, "$seen");
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, new _M0TP312moonbitstack8moonmail4jmap5Email(_tmp$3, _tmp$4, _tmp$5, _tmp$6, _tmp$7, _bind$6 === undefined));
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap5EmailERP312moonbitstack8moonmail4jmap7RefusedE2Ok(out);
}
function _M0FP312moonbitstack8moonmail4jmap10identities(response, tag) {
  const _bind = _M0MP312moonbitstack8moonmail4jmap8Response6answer(response, tag);
  let answer;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    answer = _ok._0;
  } else {
    return _bind;
  }
  const out = [];
  const _bind$2 = _M0FP312moonbitstack8moonmail4jmap5items(answer.args, "list");
  let _bind$3;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _bind$3 = _ok._0;
  } else {
    return _bind$2;
  }
  const _bind$4 = _bind$3.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$4) {
      const entry = _bind$3[_];
      const _bind$5 = _M0FP312moonbitstack8moonmail4jmap4text(entry, "id");
      let _tmp$2;
      if (_bind$5.$tag === 1) {
        const _ok = _bind$5;
        _tmp$2 = _ok._0;
      } else {
        return _bind$5;
      }
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, new _M0TP312moonbitstack8moonmail4jmap8Identity(_tmp$2, _M0FP312moonbitstack8moonmail4jmap9text__opt(entry, "name"), _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(entry, "email"), "")));
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGRPB5ArrayGRP312moonbitstack8moonmail4jmap8IdentityERP312moonbitstack8moonmail4jmap7RefusedE2Ok(out);
}
function _M0FP312moonbitstack8moonmail4jmap11created__id(response, tag, creation) {
  const _bind = _M0MP312moonbitstack8moonmail4jmap8Response6answer(response, tag);
  let answer;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    answer = _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0FP312moonbitstack8moonmail4jmap8optional(answer.args, "notCreated");
  if (_bind$2 === undefined) {
  } else {
    const _Some = _bind$2;
    const _x = _Some;
    if (_x.$tag === 6) {
      const _Object = _x;
      const _refused = _Object._0;
      const _bind$3 = _M0MPB3Map3getGsRPB4JsonE(_refused, creation);
      if (_bind$3 === undefined) {
      } else {
        const _Some$2 = _bind$3;
        const _failure = _Some$2;
        return new _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error49moonbitstack_2fmoonmail_2fjmap_2eRefused_2eFailed(answer.name, _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(_failure, "type"), "unknown"), _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(_failure, "description"), "")));
      }
    }
  }
  _L: {
    const _bind$3 = _M0FP312moonbitstack8moonmail4jmap8optional(answer.args, "created");
    if (_bind$3 === undefined) {
      break _L;
    } else {
      const _Some = _bind$3;
      const _x = _Some;
      if (_x.$tag === 6) {
        const _Object = _x;
        const _created = _Object._0;
        _L$2: {
          const _bind$4 = _M0MPB3Map3getGsRPB4JsonE(_created, creation);
          if (_bind$4 === undefined) {
            break _L$2;
          } else {
            const _Some$2 = _bind$4;
            const _x$2 = _Some$2;
            if (_x$2.$tag === 6) {
              const _Object$2 = _x$2;
              const _entry = _Object$2._0;
              return _M0FP312moonbitstack8moonmail4jmap4text(new _M0DTPB4Json6Object(_entry), "id");
            } else {
              break _L$2;
            }
          }
        }
        return new _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error50moonbitstack_2fmoonmail_2fjmap_2eRefused_2eMissing(creation));
      } else {
        break _L;
      }
    }
  }
  return new _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error50moonbitstack_2fmoonmail_2fjmap_2eRefused_2eMissing(creation));
}
function _M0FP312moonbitstack8moonmail4jmap11scheme__end(url) {
  return _M0MPC16string6String11has__prefix(url, _M0FP312moonbitstack8moonmail4jmap11scheme__endN6recordS4285) ? _M0FP312moonbitstack8moonmail4jmap11scheme__endN6constrS4286 : _M0MPC16string6String11has__prefix(url, _M0FP312moonbitstack8moonmail4jmap11scheme__endN6recordS4287) ? _M0FP312moonbitstack8moonmail4jmap11scheme__endN6constrS4288 : undefined;
}
function _M0FP312moonbitstack8moonmail4jmap10origin__of(url) {
  const _bind = _M0FP312moonbitstack8moonmail4jmap11scheme__end(url);
  if (_bind === undefined) {
    return undefined;
  } else {
    const _Some = _bind;
    const _start = _Some;
    const rest = _M0MPC16string6String21clamped__view_2einner(url, _start, undefined);
    const _bind$2 = _M0MPC16string10StringView4find(rest, _M0FP312moonbitstack8moonmail4jmap10origin__ofN6recordS4290);
    if (_bind$2 === undefined) {
      return url;
    } else {
      const _Some$2 = _bind$2;
      const _slash = _Some$2;
      return _M0MPC16string10StringView9to__owned(_M0MPC16string6String21clamped__view_2einner(url, 0, _start + _slash | 0));
    }
  }
}
function _M0FP312moonbitstack8moonmail4jmap11last__slash(text) {
  let i = text.length - 1 | 0;
  while (true) {
    if (i >= 0) {
      if (_M0IPC16option6OptionPB2Eq5equalGcE(_M0MPC16string6String9get__char(text, i), _M0FP312moonbitstack8moonmail4jmap11last__slashN6constrS4299)) {
        return i;
      }
      i = i - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FP312moonbitstack8moonmail4jmap7resolve(base, url) {
  if (url === "") {
    return new _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error49moonbitstack_2fmoonmail_2fjmap_2eRefused_2eBadUrl(url));
  }
  const _bind = _M0FP312moonbitstack8moonmail4jmap11scheme__end(url);
  if (_bind === undefined) {
  } else {
    return new _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE2Ok(url);
  }
  const _bind$2 = _M0FP312moonbitstack8moonmail4jmap10origin__of(base);
  let origin;
  if (_bind$2 === undefined) {
    return new _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error49moonbitstack_2fmoonmail_2fjmap_2eRefused_2eBadUrl(base));
  } else {
    const _Some = _bind$2;
    origin = _Some;
  }
  if (_M0MPC16string6String11has__prefix(url, _M0FP312moonbitstack8moonmail4jmap7resolveN6recordS4303)) {
    const _bind$3 = _M0FP312moonbitstack8moonmail4jmap11scheme__end(base);
    let scheme;
    if (_bind$3 === undefined) {
      scheme = "http:";
    } else {
      const _Some = _bind$3;
      const _x = _Some;
      if (_x === 8) {
        scheme = "https:";
      } else {
        scheme = "http:";
      }
    }
    return new _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE2Ok(`${scheme}${url}`);
  }
  if (_M0MPC16string6String11has__prefix(url, _M0FP312moonbitstack8moonmail4jmap7resolveN6recordS4304)) {
    return new _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE2Ok(`${origin}${url}`);
  }
  const _bind$3 = _M0MPC16string6String4find(base, _M0FP312moonbitstack8moonmail4jmap7resolveN6recordS4305);
  let document;
  if (_bind$3 === undefined) {
    document = base;
  } else {
    const _Some = _bind$3;
    const _at = _Some;
    document = _M0MPC16string10StringView9to__owned(_M0MPC16string6String21clamped__view_2einner(base, 0, _at));
  }
  const _bind$4 = _M0FP312moonbitstack8moonmail4jmap11last__slash(document);
  if (_bind$4 === undefined) {
    return new _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE2Ok(`${document}/${url}`);
  } else {
    const _Some = _bind$4;
    const _at = _Some;
    return new _M0DTPC16result6ResultGsRP312moonbitstack8moonmail4jmap7RefusedE2Ok(`${_M0MPC16string10StringView9to__owned(_M0MPC16string6String21clamped__view_2einner(document, 0, _at + 1 | 0))}${url}`);
  }
}
function _M0FP312moonbitstack8moonmail4jmap10first__key(map) {
  const _it = _M0MPB3Map5iter2GsRPB4JsonE(map);
  while (true) {
    const _bind = _M0MPB5Iter24nextGsRPB4JsonE(_it);
    if (_bind === undefined) {
      break;
    } else {
      const _Some = _bind;
      const _x = _Some;
      const _key = _x._0;
      return _key;
    }
  }
  return undefined;
}
function _M0FP312moonbitstack8moonmail4jmap5reads(body) {
  let _try_err;
  _L: {
    const _bind = _M0FPC14json13parse_2einner(new _M0TPC16string10StringView(body, 0, body.length), 1024, false, false);
    let _tmp;
    if (_bind.$tag === 1) {
      const _ok = _bind;
      _tmp = _ok._0;
    } else {
      const _err = _bind;
      _try_err = _err._0;
      break _L;
    }
    return new _M0DTPC16result6ResultGRPB4JsonRP312moonbitstack8moonmail4jmap7RefusedE2Ok(_tmp);
  }
  return new _M0DTPC16result6ResultGRPB4JsonRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error52moonbitstack_2fmoonmail_2fjmap_2eRefused_2eMalformed("document"));
}
function _M0MP312moonbitstack8moonmail4jmap7Session5parse(base, body) {
  const _bind = _M0FP312moonbitstack8moonmail4jmap5reads(body);
  let document;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    document = _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0FP312moonbitstack8moonmail4jmap4text(document, "apiUrl");
  let _tmp;
  if (_bind$2.$tag === 1) {
    const _ok = _bind$2;
    _tmp = _ok._0;
  } else {
    return _bind$2;
  }
  const _bind$3 = _M0FP312moonbitstack8moonmail4jmap7resolve(base, _tmp);
  let api_url;
  if (_bind$3.$tag === 1) {
    const _ok = _bind$3;
    api_url = _ok._0;
  } else {
    return _bind$3;
  }
  const _bind$4 = _M0FP312moonbitstack8moonmail4jmap5field(document, "accounts");
  let _tmp$2;
  if (_bind$4.$tag === 1) {
    const _ok = _bind$4;
    _tmp$2 = _ok._0;
  } else {
    return _bind$4;
  }
  const _bind$5 = _M0FP312moonbitstack8moonmail4jmap10object__of(_tmp$2);
  let accounts;
  if (_bind$5.$tag === 1) {
    const _ok = _bind$5;
    accounts = _ok._0;
  } else {
    return _bind$5;
  }
  let account_id;
  _L: {
    _L$2: {
      const _bind$6 = _M0FP312moonbitstack8moonmail4jmap8optional(document, "primaryAccounts");
      if (_bind$6 === undefined) {
        break _L$2;
      } else {
        const _Some = _bind$6;
        const _x = _Some;
        if (_x.$tag === 6) {
          const _Object = _x;
          const _primary = _Object._0;
          _L$3: {
            _L$4: {
              const _bind$7 = _M0MPB3Map3getGsRPB4JsonE(_primary, "urn:ietf:params:jmap:mail");
              if (_bind$7 === undefined) {
                break _L$4;
              } else {
                const _Some$2 = _bind$7;
                const _x$2 = _Some$2;
                if (_x$2.$tag === 4) {
                  const _String = _x$2;
                  account_id = _String._0;
                } else {
                  break _L$4;
                }
              }
              break _L$3;
            }
            const _bind$7 = _M0FP312moonbitstack8moonmail4jmap10first__key(accounts);
            if (_bind$7 === undefined) {
              return new _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap7SessionRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error50moonbitstack_2fmoonmail_2fjmap_2eRefused_2eMissing("accounts"));
            } else {
              const _Some$2 = _bind$7;
              account_id = _Some$2;
            }
          }
        } else {
          break _L$2;
        }
      }
      break _L;
    }
    const _bind$6 = _M0FP312moonbitstack8moonmail4jmap10first__key(accounts);
    if (_bind$6 === undefined) {
      return new _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap7SessionRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error50moonbitstack_2fmoonmail_2fjmap_2eRefused_2eMissing("accounts"));
    } else {
      const _Some = _bind$6;
      account_id = _Some;
    }
  }
  const _bind$6 = _M0FP312moonbitstack8moonmail4jmap9text__opt(document, "downloadUrl");
  let download_url;
  if (_bind$6 === undefined) {
    download_url = undefined;
  } else {
    const _Some = _bind$6;
    const _url = _Some;
    const _bind$7 = _M0FP312moonbitstack8moonmail4jmap7resolve(base, _url);
    if (_bind$7.$tag === 1) {
      const _ok = _bind$7;
      download_url = _ok._0;
    } else {
      return _bind$7;
    }
  }
  const _bind$7 = _M0FP312moonbitstack8moonmail4jmap9text__opt(document, "uploadUrl");
  let upload_url;
  if (_bind$7 === undefined) {
    upload_url = undefined;
  } else {
    const _Some = _bind$7;
    const _url = _Some;
    const _bind$8 = _M0FP312moonbitstack8moonmail4jmap7resolve(base, _url);
    if (_bind$8.$tag === 1) {
      const _ok = _bind$8;
      upload_url = _ok._0;
    } else {
      return _bind$8;
    }
  }
  const _bind$8 = _M0FP312moonbitstack8moonmail4jmap9text__opt(document, "eventSourceUrl");
  let event_source_url;
  if (_bind$8 === undefined) {
    event_source_url = undefined;
  } else {
    const _Some = _bind$8;
    const _url = _Some;
    const _bind$9 = _M0FP312moonbitstack8moonmail4jmap7resolve(base, _url);
    if (_bind$9.$tag === 1) {
      const _ok = _bind$9;
      event_source_url = _ok._0;
    } else {
      return _bind$9;
    }
  }
  return new _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap7SessionRP312moonbitstack8moonmail4jmap7RefusedE2Ok(new _M0TP312moonbitstack8moonmail4jmap7Session(_M0FP312moonbitstack8moonmail4jmap9text__opt(document, "username"), account_id, api_url, download_url, upload_url, event_source_url, _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(document, "state"), "")));
}
function _M0MP312moonbitstack8moonmail4jmap8Response5parse(body) {
  const _bind = _M0FP312moonbitstack8moonmail4jmap5reads(body);
  let document;
  if (_bind.$tag === 1) {
    const _ok = _bind;
    document = _ok._0;
  } else {
    return _bind;
  }
  const _bind$2 = _M0FP312moonbitstack8moonmail4jmap8optional(document, "methodResponses");
  if (_bind$2 === undefined) {
    return new _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap8ResponseRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error49moonbitstack_2fmoonmail_2fjmap_2eRefused_2eFailed("request", _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(document, "type"), "about:blank"), _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(document, "detail"), "the server sent no methodResponses")));
  }
  const invocations = [];
  const _bind$3 = _M0FP312moonbitstack8moonmail4jmap5items(document, "methodResponses");
  let _bind$4;
  if (_bind$3.$tag === 1) {
    const _ok = _bind$3;
    _bind$4 = _ok._0;
  } else {
    return _bind$3;
  }
  const _bind$5 = _bind$4.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$5) {
      const entry = _bind$4[_];
      let parts;
      if (entry.$tag === 5) {
        const _Array = entry;
        parts = _Array._0;
      } else {
        return new _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap8ResponseRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error52moonbitstack_2fmoonmail_2fjmap_2eRefused_2eWrongType("methodResponses"));
      }
      if (parts.length < 3) {
        return new _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap8ResponseRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error52moonbitstack_2fmoonmail_2fjmap_2eRefused_2eWrongType("methodResponses"));
      }
      const _bind$6 = _M0MPC15array5Array2atGUssEE(parts, 0);
      let name;
      if (_bind$6.$tag === 4) {
        const _String = _bind$6;
        name = _String._0;
      } else {
        return new _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap8ResponseRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error52moonbitstack_2fmoonmail_2fjmap_2eRefused_2eWrongType("methodName"));
      }
      const _bind$7 = _M0MPC15array5Array2atGUssEE(parts, 2);
      let tag;
      if (_bind$7.$tag === 4) {
        const _String = _bind$7;
        tag = _String._0;
      } else {
        return new _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap8ResponseRP312moonbitstack8moonmail4jmap7RefusedE3Err(new _M0DTPC15error5Error52moonbitstack_2fmoonmail_2fjmap_2eRefused_2eWrongType("methodTag"));
      }
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(invocations, new _M0TP312moonbitstack8moonmail4jmap10Invocation(name, _M0MPC15array5Array2atGUssEE(parts, 1), tag));
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGRP312moonbitstack8moonmail4jmap8ResponseRP312moonbitstack8moonmail4jmap7RefusedE2Ok(new _M0TP312moonbitstack8moonmail4jmap8Response(invocations, _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail4jmap9text__opt(document, "sessionState"), "")));
}
function _M0MP312moonbitstack8moonmail4jmap7Request3new() {
  return new _M0TP312moonbitstack8moonmail4jmap7Request(["urn:ietf:params:jmap:core", "urn:ietf:params:jmap:mail"], []);
}
function _M0MP312moonbitstack8moonmail4jmap7Request17using__capability(self, capability) {
  const _bind = self.capabilities;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const known = _bind[_];
      if (known === capability) {
        return undefined;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(self.capabilities, capability);
}
function _M0MP312moonbitstack8moonmail4jmap7Request4call(self, name, args) {
  const tag = `c${_M0MPC13int3Int18to__string_2einner(self.calls.length, 10)}`;
  _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(self.calls, new _M0TP312moonbitstack8moonmail4jmap4Call(name, args, tag));
  return tag;
}
function _M0FP312moonbitstack8moonmail4jmap6object(pairs) {
  const _bind = [];
  const map = _M0MPB3Map3MapGsRPB4JsonE(new _M0TPB9ArrayViewGUsRPB4JsonEE(_bind, 0, 0), undefined);
  const _bind$2 = pairs.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const pair = pairs[_];
      _M0MPB3Map3setGsRPB4JsonE(map, pair._0, pair._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPB4Json6Object(map);
}
function _M0FP312moonbitstack8moonmail4jmap7strings(values) {
  const _p = new Array(values.length);
  const _p$2 = values.length;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _p$4 = values[_p$3];
      _p[_p$3] = new _M0DTPB4Json6String(_p$4);
      _tmp = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$3 = _p;
  return new _M0DTPB4Json5Array(_p$3);
}
function _M0MP312moonbitstack8moonmail4jmap7Request8to__json(self) {
  const _p = self.calls;
  const _p$2 = new Array(_p.length);
  const _p$3 = _p.length;
  let _tmp = 0;
  while (true) {
    const _p$4 = _tmp;
    if (_p$4 < _p$3) {
      const _p$5 = _p[_p$4];
      const _p$6 = _p$5.name;
      const _tmp$2 = new _M0DTPB4Json6String(_p$6);
      const _tmp$3 = _p$5.args;
      const _p$7 = _p$5.tag;
      const _p$8 = [_tmp$2, _tmp$3, new _M0DTPB4Json6String(_p$7)];
      _p$2[_p$4] = new _M0DTPB4Json5Array(_p$8);
      _tmp = _p$4 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const calls = _p$2;
  return _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "using", _1: _M0FP312moonbitstack8moonmail4jmap7strings(self.capabilities) }, { _0: "methodCalls", _1: new _M0DTPB4Json5Array(calls) }]);
}
function _M0MP312moonbitstack8moonmail4jmap7Request10to__string(self) {
  return _M0MPC14json4Json17stringify_2einner(_M0MP312moonbitstack8moonmail4jmap7Request8to__json(self), false, 0, undefined);
}
function _M0MP312moonbitstack8moonmail4jmap7Request12mailbox__get(self, account) {
  return _M0MP312moonbitstack8moonmail4jmap7Request4call(self, "Mailbox/get", _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "accountId", _1: new _M0DTPB4Json6String(account) }, { _0: "properties", _1: _M0FP312moonbitstack8moonmail4jmap7strings(["id", "name", "role", "parentId", "totalEmails", "unreadEmails"]) }]));
}
function _M0MP312moonbitstack8moonmail4jmap7Request13identity__get(self, account) {
  return _M0MP312moonbitstack8moonmail4jmap7Request4call(self, "Identity/get", _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "accountId", _1: new _M0DTPB4Json6String(account) }]));
}
function _M0FP312moonbitstack8moonmail4jmap6number(value) {
  const _p = value + 0;
  const _p$2 = _M0MPC13int3Int18to__string_2einner(value, 10);
  return new _M0DTPB4Json6Number(_p, _p$2);
}
function _M0MP312moonbitstack8moonmail4jmap7Request12email__query(self, account, mailbox, limit) {
  const _tmp = { _0: "accountId", _1: new _M0DTPB4Json6String(account) };
  const _tmp$2 = { _0: "filter", _1: _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "inMailbox", _1: new _M0DTPB4Json6String(mailbox) }]) };
  const _p = "receivedAt";
  const _tmp$3 = { _0: "property", _1: new _M0DTPB4Json6String(_p) };
  const _p$2 = false;
  const _p$3 = [_M0FP312moonbitstack8moonmail4jmap6object([_tmp$3, { _0: "isAscending", _1: _p$2 ? _M0DTPB4Json4True__ : _M0DTPB4Json5False__ }])];
  return _M0MP312moonbitstack8moonmail4jmap7Request4call(self, "Email/query", _M0FP312moonbitstack8moonmail4jmap6object([_tmp, _tmp$2, { _0: "sort", _1: new _M0DTPB4Json5Array(_p$3) }, { _0: "limit", _1: _M0FP312moonbitstack8moonmail4jmap6number(limit) }]));
}
function _M0MP312moonbitstack8moonmail4jmap7Request10email__get(self, account, ids, properties) {
  return _M0MP312moonbitstack8moonmail4jmap7Request4call(self, "Email/get", _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "accountId", _1: new _M0DTPB4Json6String(account) }, { _0: "ids", _1: _M0FP312moonbitstack8moonmail4jmap7strings(ids) }, { _0: "properties", _1: _M0FP312moonbitstack8moonmail4jmap7strings(properties) }]));
}
function _M0MP312moonbitstack8moonmail4jmap5Draft3new(to, subject, text) {
  return new _M0TP312moonbitstack8moonmail4jmap5Draft(undefined, to, [], [], subject, text);
}
function _M0FP312moonbitstack8moonmail4jmap9addressed(value) {
  return _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "email", _1: new _M0DTPB4Json6String(value) }]);
}
function _M0FP312moonbitstack8moonmail4jmap13address__list(values) {
  const _p = new Array(values.length);
  const _p$2 = values.length;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _p$4 = values[_p$3];
      _p[_p$3] = _M0FP312moonbitstack8moonmail4jmap9addressed(_p$4);
      _tmp = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$3 = _p;
  return new _M0DTPB4Json5Array(_p$3);
}
function _M0MP312moonbitstack8moonmail4jmap7Request17email__set__draft(self, account, mailbox, draft) {
  const _p = true;
  const _tmp = { _0: "mailboxIds", _1: _M0FP312moonbitstack8moonmail4jmap6object([{ _0: mailbox, _1: _p ? _M0DTPB4Json4True__ : _M0DTPB4Json5False__ }]) };
  const _p$2 = true;
  const _tmp$2 = { _0: "keywords", _1: _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "$draft", _1: _p$2 ? _M0DTPB4Json4True__ : _M0DTPB4Json5False__ }]) };
  const _p$3 = draft.subject;
  const _tmp$3 = { _0: "subject", _1: new _M0DTPB4Json6String(_p$3) };
  const _p$4 = "body";
  const _tmp$4 = { _0: "partId", _1: new _M0DTPB4Json6String(_p$4) };
  const _p$5 = "text/plain";
  const _p$6 = [_M0FP312moonbitstack8moonmail4jmap6object([_tmp$4, { _0: "type", _1: new _M0DTPB4Json6String(_p$5) }])];
  const _tmp$5 = { _0: "textBody", _1: new _M0DTPB4Json5Array(_p$6) };
  const _p$7 = draft.text;
  const properties = [_tmp, _tmp$2, _tmp$3, _tmp$5, { _0: "bodyValues", _1: _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "body", _1: _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "value", _1: new _M0DTPB4Json6String(_p$7) }]) }]) }, { _0: "to", _1: _M0FP312moonbitstack8moonmail4jmap13address__list(draft.to) }];
  const _p$8 = draft.cc;
  if (!(_p$8.length === 0)) {
    _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(properties, { _0: "cc", _1: _M0FP312moonbitstack8moonmail4jmap13address__list(draft.cc) });
  }
  const _p$9 = draft.bcc;
  if (!(_p$9.length === 0)) {
    _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(properties, { _0: "bcc", _1: _M0FP312moonbitstack8moonmail4jmap13address__list(draft.bcc) });
  }
  const _bind = draft.from;
  if (_bind === undefined) {
  } else {
    const _Some = _bind;
    const _from = _Some;
    const _p$10 = [_M0FP312moonbitstack8moonmail4jmap9addressed(_from)];
    _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(properties, { _0: "from", _1: new _M0DTPB4Json5Array(_p$10) });
  }
  return _M0MP312moonbitstack8moonmail4jmap7Request4call(self, "Email/set", _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "accountId", _1: new _M0DTPB4Json6String(account) }, { _0: "create", _1: _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "draft", _1: _M0FP312moonbitstack8moonmail4jmap6object(properties) }]) }]));
}
function _M0MP312moonbitstack8moonmail4jmap7Request22email__submission__set(self, account, identity, email_id) {
  _M0MP312moonbitstack8moonmail4jmap7Request17using__capability(self, "urn:ietf:params:jmap:submission");
  return _M0MP312moonbitstack8moonmail4jmap7Request4call(self, "EmailSubmission/set", _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "accountId", _1: new _M0DTPB4Json6String(account) }, { _0: "create", _1: _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "submission", _1: _M0FP312moonbitstack8moonmail4jmap6object([{ _0: "identityId", _1: new _M0DTPB4Json6String(identity) }, { _0: "emailId", _1: new _M0DTPB4Json6String(email_id) }]) }]) }]));
}
function _M0FP312moonbitstack8moonmail6engine9addresses(values) {
  const out = [];
  const _bind = values.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const value = values[_];
      const _bind$2 = _M0FP212moonbitstack8moonmail14parse__address(new _M0TPC16string10StringView(value, 0, value.length));
      let _tmp$2;
      if (_bind$2.$tag === 1) {
        const _ok = _bind$2;
        _tmp$2 = _ok._0;
      } else {
        return _bind$2;
      }
      _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, _tmp$2);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPC16result6ResultGRPB5ArrayGRP212moonbitstack8moonmail7AddressERP212moonbitstack8moonmail7RefusedE2Ok(out);
}
function _M0FP312moonbitstack8moonmail6engine6object(pairs) {
  const _bind = [];
  const map = _M0MPB3Map3MapGsRPB4JsonE(new _M0TPB9ArrayViewGUsRPB4JsonEE(_bind, 0, 0), undefined);
  const _bind$2 = pairs.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const pair = pairs[_];
      _M0MPB3Map3setGsRPB4JsonE(map, pair._0, pair._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0DTPB4Json6Object(map);
}
function _M0FP312moonbitstack8moonmail6engine4fail(kind, message) {
  const _p = false;
  return _M0MPC14json4Json17stringify_2einner(_M0FP312moonbitstack8moonmail6engine6object([{ _0: "ok", _1: _p ? _M0DTPB4Json4True__ : _M0DTPB4Json5False__ }, { _0: "error", _1: _M0FP312moonbitstack8moonmail6engine6object([{ _0: "kind", _1: new _M0DTPB4Json6String(kind) }, { _0: "message", _1: new _M0DTPB4Json6String(message) }]) }]), false, 0, undefined);
}
function _M0FP312moonbitstack8moonmail6engine5field(input, name) {
  if (input.$tag === 6) {
    const _Object = input;
    const _map = _Object._0;
    return _M0MPB3Map3getGsRPB4JsonE(_map, name);
  } else {
    return undefined;
  }
}
function _M0FP312moonbitstack8moonmail6engine4flag(input, name) {
  if (input.$tag === 6) {
    const _Object = input;
    const _map = _Object._0;
    const _bind = _M0MPB3Map3getGsRPB4JsonE(_map, name);
    if (_bind === undefined) {
      return false;
    } else {
      const _Some = _bind;
      const _x = _Some;
      if (_x.$tag === 1) {
        return true;
      } else {
        return false;
      }
    }
  } else {
    return false;
  }
}
function _M0FP312moonbitstack8moonmail6engine4list(input, name) {
  const out = [];
  if (input.$tag === 6) {
    const _Object = input;
    const _map = _Object._0;
    const _bind = _M0MPB3Map3getGsRPB4JsonE(_map, name);
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _x = _Some;
      if (_x.$tag === 5) {
        const _Array = _x;
        const _values = _Array._0;
        const _bind$2 = _values.length;
        let _tmp = 0;
        while (true) {
          const _ = _tmp;
          if (_ < _bind$2) {
            const value = _values[_];
            if (value.$tag === 4) {
              const _String = value;
              const _item = _String._0;
              _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(out, _item);
            }
            _tmp = _ + 1 | 0;
            continue;
          } else {
            break;
          }
        }
      }
    }
  }
  return out;
}
function _M0FP312moonbitstack8moonmail6engine2ok(value) {
  const _p = true;
  return _M0MPC14json4Json17stringify_2einner(_M0FP312moonbitstack8moonmail6engine6object([{ _0: "ok", _1: _p ? _M0DTPB4Json4True__ : _M0DTPB4Json5False__ }, { _0: "value", _1: value }]), false, 0, undefined);
}
function _M0FP312moonbitstack8moonmail6engine4text(input, name) {
  if (input.$tag === 6) {
    const _Object = input;
    const _map = _Object._0;
    _L: {
      const _bind = _M0MPB3Map3getGsRPB4JsonE(_map, name);
      if (_bind === undefined) {
        break _L;
      } else {
        const _Some = _bind;
        const _x = _Some;
        if (_x.$tag === 4) {
          const _String = _x;
          const _value = _String._0;
          return _value;
        } else {
          break _L;
        }
      }
    }
    return undefined;
  } else {
    return undefined;
  }
}
function _M0FP312moonbitstack8moonmail6engine7compose(input) {
  const from = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "from"), "");
  if (from === "") {
    return _M0FP312moonbitstack8moonmail6engine4fail("compose", "a letter needs a From address");
  }
  let _try_err;
  _L: {
    const _bind = _M0FP212moonbitstack8moonmail14parse__address(new _M0TPC16string10StringView(from, 0, from.length));
    let sender;
    if (_bind.$tag === 1) {
      const _ok = _bind;
      sender = _ok._0;
    } else {
      const _err = _bind;
      _try_err = _err._0;
      break _L;
    }
    const body_text = _M0FP312moonbitstack8moonmail6engine4text(input, "text");
    const body_html = _M0FP312moonbitstack8moonmail6engine4text(input, "html");
    const attachments = [];
    const _bind$2 = _M0FP312moonbitstack8moonmail6engine5field(input, "image");
    if (_bind$2 === undefined) {
    } else {
      const _Some = _bind$2;
      const _image = _Some;
      let carried;
      let _try_err$2;
      _L$2: {
        _L$3: {
          const _bind$3 = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(_image, "data"), "");
          const _bind$4 = _M0FP312moonbitstack8moonbase6base646decode(new _M0TPC16string10StringView(_bind$3, 0, _bind$3.length), undefined, -1, -1);
          if (_bind$4.$tag === 1) {
            const _ok = _bind$4;
            carried = _ok._0;
          } else {
            const _err = _bind$4;
            _try_err$2 = _err._0;
            break _L$3;
          }
          break _L$2;
        }
        carried = undefined;
      }
      if (carried === undefined) {
      } else {
        const _Some$2 = carried;
        const _data = _Some$2;
        if (_data.length > 0) {
          _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(attachments, _M0MP212moonbitstack8moonmail10Attachment11new_2einner(_M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(_image, "name"), "card.jpg"), _data, _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(_image, "type"), "image/jpeg"), true, _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(_image, "cid"), "card")));
        }
      }
    }
    const _bind$3 = _M0FP312moonbitstack8moonmail6engine5field(input, "attachments");
    if (_bind$3 === undefined) {
    } else {
      const _Some = _bind$3;
      const _x = _Some;
      if (_x.$tag === 5) {
        const _Array = _x;
        const _items = _Array._0;
        const _bind$4 = _items.length;
        let _tmp = 0;
        while (true) {
          const _ = _tmp;
          if (_ < _bind$4) {
            const item = _items[_];
            let bytes;
            let _try_err$2;
            _L$2: {
              _L$3: {
                const _bind$5 = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(item, "data"), "");
                const _bind$6 = _M0FP312moonbitstack8moonbase6base646decode(new _M0TPC16string10StringView(_bind$5, 0, _bind$5.length), undefined, -1, -1);
                if (_bind$6.$tag === 1) {
                  const _ok = _bind$6;
                  bytes = _ok._0;
                } else {
                  const _err = _bind$6;
                  _try_err$2 = _err._0;
                  break _L$3;
                }
                break _L$2;
              }
              bytes = undefined;
            }
            if (bytes === undefined) {
            } else {
              const _Some$2 = bytes;
              const _data = _Some$2;
              if (_data.length > 0) {
                const name = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(item, "name"), "attachment");
                const kind = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(item, "type"), "application/octet-stream");
                const _bind$5 = _M0FP312moonbitstack8moonmail6engine4text(item, "cid");
                if (_bind$5 === undefined) {
                  _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(attachments, _M0MP212moonbitstack8moonmail10Attachment11new_2einner(name, _data, kind, _M0FP312moonbitstack8moonmail6engine4flag(item, "inline"), undefined));
                } else {
                  const _Some$3 = _bind$5;
                  const _cid = _Some$3;
                  _M0MPC15array5Array4pushGRP312moonbitstack8moonmail4jmap10InvocationE(attachments, _M0MP212moonbitstack8moonmail10Attachment11new_2einner(name, _data, kind, true, _cid));
                }
              }
            }
            _tmp = _ + 1 | 0;
            continue;
          } else {
            break;
          }
        }
      }
    }
    const carried = attachments.length === 0 ? _M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail10AttachmentEE4None__ : new _M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail10AttachmentEE4Some(attachments);
    const _tmp = _M0MPC15array5Array2atGUssEE(_M0MP212moonbitstack8moonmail7Address9mailboxes(sender), 0);
    const _bind$4 = _M0FP312moonbitstack8moonmail6engine9addresses(_M0FP312moonbitstack8moonmail6engine4list(input, "to"));
    let _tmp$2;
    if (_bind$4.$tag === 1) {
      const _ok = _bind$4;
      _tmp$2 = _ok._0;
    } else {
      const _err = _bind$4;
      _try_err = _err._0;
      break _L;
    }
    const _tmp$3 = _tmp$2;
    const _tmp$4 = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "subject"), "");
    const _bind$5 = _M0FP312moonbitstack8moonmail6engine9addresses(_M0FP312moonbitstack8moonmail6engine4list(input, "cc"));
    let _tmp$5;
    if (_bind$5.$tag === 1) {
      const _ok = _bind$5;
      _tmp$5 = _ok._0;
    } else {
      const _err = _bind$5;
      _try_err = _err._0;
      break _L;
    }
    const _bind$6 = _M0MP212moonbitstack8moonmail7Message3new(_tmp, _tmp$3, _tmp$4, body_text, body_html, carried, new _M0DTPC16option6OptionGRPB5ArrayGRP212moonbitstack8moonmail7AddressEE4Some(_tmp$5), undefined, undefined);
    let message;
    if (_bind$6.$tag === 1) {
      const _ok = _bind$6;
      message = _ok._0;
    } else {
      const _err = _bind$6;
      _try_err = _err._0;
      break _L;
    }
    const bytes = _M0MP212moonbitstack8moonmail7Message14encode_2einner(message, false);
    const _p = _M0FPC28encoding4utf821decode__lossy_2einner(new _M0TPC15bytes9BytesView(bytes, 0, bytes.length), false);
    const _tmp$6 = { _0: "message", _1: new _M0DTPB4Json6String(_p) };
    const _p$2 = bytes.length + 0;
    const _p$3 = undefined;
    return _M0FP312moonbitstack8moonmail6engine2ok(_M0FP312moonbitstack8moonmail6engine6object([_tmp$6, { _0: "bytes", _1: new _M0DTPB4Json6Number(_p$2, _p$3) }]));
  }
  return _M0FP312moonbitstack8moonmail6engine4fail("compose", _M0IP016_24default__implPB4Show10to__stringGRPC15debug4ReprE(_M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__repr(_try_err)));
}
function _M0FP312moonbitstack8moonmail6engine5parse(input) {
  const raw = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "raw"), "");
  if (raw === "") {
    return _M0FP312moonbitstack8moonmail6engine4fail("parse", "there is nothing to parse");
  }
  let _try_err;
  _L: {
    const _bind = _M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(raw, 0, raw.length), false);
    const _bind$2 = _M0MP212moonbitstack8moonmail7Message13parse_2einner(new _M0TPC15bytes9BytesView(_bind, 0, _bind.length), false);
    let message;
    if (_bind$2.$tag === 1) {
      const _ok = _bind$2;
      message = _ok._0;
    } else {
      const _err = _bind$2;
      _try_err = _err._0;
      break _L;
    }
    const subject = _M0MPC16option6Option10unwrap__orGsE(_M0MP212moonbitstack8moonmail7Message7subject(message), "");
    const _bind$3 = _M0MP212moonbitstack8moonmail7Message4text(message, undefined);
    let _bind$4;
    if (_bind$3.$tag === 1) {
      const _ok = _bind$3;
      _bind$4 = _ok._0;
    } else {
      const _err = _bind$3;
      _try_err = _err._0;
      break _L;
    }
    let text_body;
    if (_bind$4 === undefined) {
      text_body = "";
    } else {
      const _Some = _bind$4;
      text_body = _Some;
    }
    const _tmp = { _0: "subject", _1: new _M0DTPB4Json6String(subject) };
    const _tmp$2 = { _0: "text", _1: new _M0DTPB4Json6String(text_body) };
    const _p = _M0FPC28encoding4utf814encode_2einner(new _M0TPC16string10StringView(raw, 0, raw.length), false).length + 0;
    const _p$2 = undefined;
    return _M0FP312moonbitstack8moonmail6engine2ok(_M0FP312moonbitstack8moonmail6engine6object([_tmp, _tmp$2, { _0: "bytes", _1: new _M0DTPB4Json6Number(_p, _p$2) }]));
  }
  return _M0FP312moonbitstack8moonmail6engine4fail("parse", _M0IP016_24default__implPB4Show10to__stringGRPC15debug4ReprE(_M0IP212moonbitstack8moonmail7RefusedPC15debug5Debug8to__repr(_try_err)));
}
function _M0FP312moonbitstack8moonmail6engine4read(text) {
  let _try_err;
  _L: {
    const _bind = _M0FPC14json13parse_2einner(new _M0TPC16string10StringView(text, 0, text.length), 1024, false, false);
    if (_bind.$tag === 1) {
      const _ok = _bind;
      return _ok._0;
    } else {
      const _err = _bind;
      _try_err = _err._0;
      break _L;
    }
  }
  return undefined;
}
function _M0FP312moonbitstack8moonmail6engine7strings(values) {
  const _p = new Array(values.length);
  const _p$2 = values.length;
  let _tmp = 0;
  while (true) {
    const _p$3 = _tmp;
    if (_p$3 < _p$2) {
      const _p$4 = values[_p$3];
      _p[_p$3] = new _M0DTPB4Json6String(_p$4);
      _tmp = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$3 = _p;
  return new _M0DTPB4Json5Array(_p$3);
}
function _M0FP312moonbitstack8moonmail6engine14read__response(input) {
  const op = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "op"), "");
  const tag = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "tag"), "");
  const body = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "body"), "");
  let _try_err;
  _L: {
    const _bind = _M0MP312moonbitstack8moonmail4jmap8Response5parse(body);
    let response;
    if (_bind.$tag === 1) {
      const _ok = _bind;
      response = _ok._0;
    } else {
      const _err = _bind;
      _try_err = _err._0;
      break _L;
    }
    let value;
    switch (op) {
      case "mailboxes": {
        const _bind$2 = _M0FP312moonbitstack8moonmail4jmap9mailboxes(response, tag);
        let list;
        if (_bind$2.$tag === 1) {
          const _ok = _bind$2;
          list = _ok._0;
        } else {
          const _err = _bind$2;
          _try_err = _err._0;
          break _L;
        }
        const _p = new Array(list.length);
        const _p$2 = list.length;
        let _tmp = 0;
        while (true) {
          const _p$3 = _tmp;
          if (_p$3 < _p$2) {
            const _p$4 = list[_p$3];
            const _p$5 = _p$4.id;
            const _tmp$2 = { _0: "id", _1: new _M0DTPB4Json6String(_p$5) };
            const _p$6 = _p$4.name;
            const _tmp$3 = { _0: "name", _1: new _M0DTPB4Json6String(_p$6) };
            const _p$7 = _M0MPC16option6Option10unwrap__orGsE(_p$4.role, "");
            const _tmp$4 = { _0: "role", _1: new _M0DTPB4Json6String(_p$7) };
            const _p$8 = _p$4.total + 0;
            const _p$9 = undefined;
            const _tmp$5 = { _0: "total", _1: new _M0DTPB4Json6Number(_p$8, _p$9) };
            const _p$10 = _p$4.unread + 0;
            const _p$11 = undefined;
            _p[_p$3] = _M0FP312moonbitstack8moonmail6engine6object([_tmp$2, _tmp$3, _tmp$4, _tmp$5, { _0: "unread", _1: new _M0DTPB4Json6Number(_p$10, _p$11) }]);
            _tmp = _p$3 + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        const _p$3 = _p;
        value = new _M0DTPB4Json5Array(_p$3);
        break;
      }
      case "identities": {
        const _bind$3 = _M0FP312moonbitstack8moonmail4jmap10identities(response, tag);
        let list$2;
        if (_bind$3.$tag === 1) {
          const _ok = _bind$3;
          list$2 = _ok._0;
        } else {
          const _err = _bind$3;
          _try_err = _err._0;
          break _L;
        }
        const _p$4 = new Array(list$2.length);
        const _p$5 = list$2.length;
        let _tmp$2 = 0;
        while (true) {
          const _p$6 = _tmp$2;
          if (_p$6 < _p$5) {
            const _p$7 = list$2[_p$6];
            const _p$8 = _p$7.id;
            const _tmp$3 = { _0: "id", _1: new _M0DTPB4Json6String(_p$8) };
            const _p$9 = _M0MPC16option6Option10unwrap__orGsE(_p$7.name, "");
            const _tmp$4 = { _0: "name", _1: new _M0DTPB4Json6String(_p$9) };
            const _p$10 = _p$7.email;
            _p$4[_p$6] = _M0FP312moonbitstack8moonmail6engine6object([_tmp$3, _tmp$4, { _0: "email", _1: new _M0DTPB4Json6String(_p$10) }]);
            _tmp$2 = _p$6 + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        const _p$6 = _p$4;
        value = new _M0DTPB4Json5Array(_p$6);
        break;
      }
      case "query": {
        const _bind$4 = _M0FP312moonbitstack8moonmail4jmap10email__ids(response, tag);
        let _tmp$3;
        if (_bind$4.$tag === 1) {
          const _ok = _bind$4;
          _tmp$3 = _ok._0;
        } else {
          const _err = _bind$4;
          _try_err = _err._0;
          break _L;
        }
        value = _M0FP312moonbitstack8moonmail6engine7strings(_tmp$3);
        break;
      }
      case "get": {
        const _bind$5 = _M0FP312moonbitstack8moonmail4jmap6emails(response, tag);
        let list$3;
        if (_bind$5.$tag === 1) {
          const _ok = _bind$5;
          list$3 = _ok._0;
        } else {
          const _err = _bind$5;
          _try_err = _err._0;
          break _L;
        }
        const _p$7 = new Array(list$3.length);
        const _p$8 = list$3.length;
        let _tmp$4 = 0;
        while (true) {
          const _p$9 = _tmp$4;
          if (_p$9 < _p$8) {
            const _p$10 = list$3[_p$9];
            const _p$11 = _p$10.id;
            const _tmp$5 = { _0: "id", _1: new _M0DTPB4Json6String(_p$11) };
            const _p$12 = _p$10.subject;
            const _tmp$6 = { _0: "subject", _1: new _M0DTPB4Json6String(_p$12) };
            const _p$13 = _M0MPC16option6Option10unwrap__orGsE(_p$10.from, "");
            const _tmp$7 = { _0: "from", _1: new _M0DTPB4Json6String(_p$13) };
            const _p$14 = _M0MPC16option6Option10unwrap__orGsE(_p$10.received_at, "");
            const _tmp$8 = { _0: "receivedAt", _1: new _M0DTPB4Json6String(_p$14) };
            const _p$15 = _p$10.preview;
            const _tmp$9 = { _0: "preview", _1: new _M0DTPB4Json6String(_p$15) };
            const _p$16 = _p$10.unread;
            _p$7[_p$9] = _M0FP312moonbitstack8moonmail6engine6object([_tmp$5, _tmp$6, _tmp$7, _tmp$8, _tmp$9, { _0: "unread", _1: _p$16 ? _M0DTPB4Json4True__ : _M0DTPB4Json5False__ }]);
            _tmp$4 = _p$9 + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        const _p$9 = _p$7;
        value = new _M0DTPB4Json5Array(_p$9);
        break;
      }
      case "draft": {
        const _bind$6 = _M0FP312moonbitstack8moonmail4jmap11created__id(response, tag, "draft");
        let _p$10;
        if (_bind$6.$tag === 1) {
          const _ok = _bind$6;
          _p$10 = _ok._0;
        } else {
          const _err = _bind$6;
          _try_err = _err._0;
          break _L;
        }
        value = new _M0DTPB4Json6String(_p$10);
        break;
      }
      case "submit": {
        const _bind$7 = _M0FP312moonbitstack8moonmail4jmap11created__id(response, tag, "submission");
        let _p$11;
        if (_bind$7.$tag === 1) {
          const _ok = _bind$7;
          _p$11 = _ok._0;
        } else {
          const _err = _bind$7;
          _try_err = _err._0;
          break _L;
        }
        value = new _M0DTPB4Json6String(_p$11);
        break;
      }
      default: {
        value = _M0DTPB4Json4Null__;
      }
    }
    return _M0FP312moonbitstack8moonmail6engine2ok(value);
  }
  return _M0FP312moonbitstack8moonmail6engine4fail("jmap", _M0IP016_24default__implPB4Show10to__stringGRPC15debug4ReprE(_M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__repr(_try_err)));
}
function _M0FP312moonbitstack8moonmail6engine3int(input, name, fallback) {
  if (input.$tag === 6) {
    const _Object = input;
    const _map = _Object._0;
    _L: {
      const _bind = _M0MPB3Map3getGsRPB4JsonE(_map, name);
      if (_bind === undefined) {
        break _L;
      } else {
        const _Some = _bind;
        const _x = _Some;
        if (_x.$tag === 3) {
          const _Number = _x;
          const _value = _Number._0;
          return _M0MPC16double6Double7to__int(_value);
        } else {
          break _L;
        }
      }
    }
    return fallback;
  } else {
    return fallback;
  }
}
function _M0FP312moonbitstack8moonmail6engine7request(input) {
  const op = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "op"), "");
  const account = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "account"), "");
  if (account === "") {
    return _M0FP312moonbitstack8moonmail6engine4fail("account", "there is no account to call against");
  }
  const request = _M0MP312moonbitstack8moonmail4jmap7Request3new();
  let tag;
  switch (op) {
    case "mailboxes": {
      tag = _M0MP312moonbitstack8moonmail4jmap7Request12mailbox__get(request, account);
      break;
    }
    case "identities": {
      tag = _M0MP312moonbitstack8moonmail4jmap7Request13identity__get(request, account);
      break;
    }
    case "query": {
      tag = _M0MP312moonbitstack8moonmail4jmap7Request12email__query(request, account, _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "mailbox"), ""), _M0FP312moonbitstack8moonmail6engine3int(input, "limit", 20));
      break;
    }
    case "get": {
      tag = _M0MP312moonbitstack8moonmail4jmap7Request10email__get(request, account, _M0FP312moonbitstack8moonmail6engine4list(input, "ids"), ["id", "subject", "from", "receivedAt", "preview", "keywords"]);
      break;
    }
    case "draft": {
      const draft = _M0MP312moonbitstack8moonmail4jmap5Draft3new(_M0FP312moonbitstack8moonmail6engine4list(input, "to"), _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "subject"), ""), _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "text"), ""));
      tag = _M0MP312moonbitstack8moonmail4jmap7Request17email__set__draft(request, account, _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "mailbox"), ""), draft);
      break;
    }
    case "submit": {
      tag = _M0MP312moonbitstack8moonmail4jmap7Request22email__submission__set(request, account, _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "identity"), ""), _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "emailId"), ""));
      break;
    }
    default: {
      return _M0FP312moonbitstack8moonmail6engine4fail("op", `there is no JMAP operation called ${op}`);
    }
  }
  const _tmp = { _0: "tag", _1: new _M0DTPB4Json6String(tag) };
  const _p = _M0MP312moonbitstack8moonmail4jmap7Request10to__string(request);
  return _M0FP312moonbitstack8moonmail6engine2ok(_M0FP312moonbitstack8moonmail6engine6object([_tmp, { _0: "body", _1: new _M0DTPB4Json6String(_p) }]));
}
function _M0FP312moonbitstack8moonmail6engine7session(input) {
  const base = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "base"), "");
  const body = _M0MPC16option6Option10unwrap__orGsE(_M0FP312moonbitstack8moonmail6engine4text(input, "body"), "");
  let _try_err;
  _L: {
    const _bind = _M0MP312moonbitstack8moonmail4jmap7Session5parse(base, body);
    let found;
    if (_bind.$tag === 1) {
      const _ok = _bind;
      found = _ok._0;
    } else {
      const _err = _bind;
      _try_err = _err._0;
      break _L;
    }
    const _p = found.api_url;
    const _tmp = { _0: "apiUrl", _1: new _M0DTPB4Json6String(_p) };
    const _p$2 = found.account_id;
    const _tmp$2 = { _0: "accountId", _1: new _M0DTPB4Json6String(_p$2) };
    const _p$3 = _M0MPC16option6Option10unwrap__orGsE(found.username, "");
    const _tmp$3 = { _0: "username", _1: new _M0DTPB4Json6String(_p$3) };
    const _p$4 = found.state;
    return _M0FP312moonbitstack8moonmail6engine2ok(_M0FP312moonbitstack8moonmail6engine6object([_tmp, _tmp$2, _tmp$3, { _0: "state", _1: new _M0DTPB4Json6String(_p$4) }]));
  }
  return _M0FP312moonbitstack8moonmail6engine4fail("jmap", _M0IP016_24default__implPB4Show10to__stringGRPC15debug4ReprE(_M0IP312moonbitstack8moonmail4jmap7RefusedPC15debug5Debug8to__repr(_try_err)));
}
function _M0FP312moonbitstack8moonmail6engine12engine__call(op, args) {
  const _bind = _M0FP312moonbitstack8moonmail6engine4read(args);
  let input;
  if (_bind === undefined) {
    return _M0FP312moonbitstack8moonmail6engine4fail("args", "the arguments were not a JSON object");
  } else {
    const _Some = _bind;
    input = _Some;
  }
  switch (op) {
    case "compose": {
      return _M0FP312moonbitstack8moonmail6engine7compose(input);
    }
    case "parse": {
      return _M0FP312moonbitstack8moonmail6engine5parse(input);
    }
    case "jmap.session": {
      return _M0FP312moonbitstack8moonmail6engine7session(input);
    }
    case "jmap.request": {
      return _M0FP312moonbitstack8moonmail6engine7request(input);
    }
    case "jmap.read": {
      return _M0FP312moonbitstack8moonmail6engine14read__response(input);
    }
    default: {
      return _M0FP312moonbitstack8moonmail6engine4fail("op", `there is no operation called ${op}`);
    }
  }
}
(() => {
})();
export { _M0FP312moonbitstack8moonmail6engine12engine__call as engine_call }
