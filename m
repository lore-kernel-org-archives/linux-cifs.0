Return-Path: <SRS0=9w6c=D5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A4AC4363A
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 09:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB73B2463D
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 09:20:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WuQsNI93"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505111AbgJVJU0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Oct 2020 05:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504822AbgJVJUZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Oct 2020 05:20:25 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11641C0613CE
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 02:20:24 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b1so1343490lfp.11
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 02:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=cW51ELFkmOfKkgqt00V48XzQV73NLjCLNzLHEvbdghk=;
        b=WuQsNI93SEU3jHHx9WqjmbyvMV3IpgwAK+A+h9T64T7uBz7LjGs0Jfz0xhzZkAfGMD
         rb2zGBXf+NAUCNgrFEYGgQZSdrHKdJ5oQraNgKX25WuereZfP1/4WVphflnyJThQxB2D
         q1iA9cG/Vw37aSGC9MmXwXRmh0vqd5Y9XYy53WNQ6rhv3pvBGV8ATDt4xqpibNDkU0wW
         ak7z4XzXQc/Gj5uOvLmX7nJyCUM3a3pmhAukUhKmnCT8dw+/sM+WfWvOKPtj4ydhwzBH
         8dwIel9BQRuJSp4YY5fF95E4tprQohiHTzy1UYn8+2abNDCKzBLHi373HKG19vRk+1U6
         RSzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cW51ELFkmOfKkgqt00V48XzQV73NLjCLNzLHEvbdghk=;
        b=CVrqdu7AvPZQOpKxL368ZrxnP2ym9tnf1pdR3VHjEf+RTlHo+ZOzs72qNjkHICz0Ok
         UdIQMEAPkPG4saeQUu2BFNWXi1Jp6zovwDwPkKNg38/toGW2dp3MUydyZnIreqgnPgFK
         AiLnZxZ+GGnBFGi81dJyMHXLHQn3V3INtQ6Xuahj4AH9bqmza/phrSoB/esDCfhRKTuD
         85ZPKfyulxoXp6hdjeh5m2SoJa3JLQd4o512pWCNWuzDhDlC6tDsr6/8AyURO2qKqjNA
         pZ+0jWp9w/DoXmpPnGAEBBFiJxFp9yhsjnPB7+qq63DPj3IJeQSE3qKbwu2tsLqV9jR5
         Hp4Q==
X-Gm-Message-State: AOAM530BBlcmlKVKJ8sam5ZLIZjyXaoYiboUs0IF/5/mUOu1oi7s5+UI
        FyfdhR0fU+k45rLBMsh1WeU6l8zRxjLaevg8zxeIfIFeMt8jGQ==
X-Google-Smtp-Source: ABdhPJwv5yFLwoFB4W1YGkS5xOjsNybmgTH4dHbNWAd3Z6mZgi05MAwOXxnvEZ4qXDuXfUcfyZcSijNy6sRWxw1WOb0=
X-Received: by 2002:a19:c381:: with SMTP id t123mr463102lff.499.1603358422226;
 Thu, 22 Oct 2020 02:20:22 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 22 Oct 2020 04:20:10 -0500
Message-ID: <CAH2r5mtmPxUKYYK-PbouTFpt9T8AU-41pRZu1CEO=+XLZZ+vSA@mail.gmail.com>
Subject: [PATCH][WIP] query smb3 reparse tags for special files
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="00000000000034908b05b23ef90b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000034908b05b23ef90b
Content-Type: text/plain; charset="UTF-8"

WSL defines special files with various reparse tags

smbfsctl.h:#define IO_REPARSE_TAG_LX_SYMLINK    0xA000001D
smbfsctl.h:#define IO_REPARSE_TAG_LX_FIFO            0x80000024
smbfsctl.h:#define IO_REPARSE_TAG_LX_CHR             0x80000025
smbfsctl.h:#define IO_REPARSE_TAG_LX_BLK             0x80000026

These also make sense for us to use more broadly because it simplifies readdir

but ... my first attempt at querying this using infolevel 33
FileReparsePointInformation (see MS-FSCC section 2.4.35) failed ...
with Windows 10 returning STATUS_NOT_SUPPORTED when querying various
reparse points (created by WSL indirectly) including fifos, symlinks
and char devices.

I can switch approaches and try to do the smb3 fsctl to query reparse
info instead but was hoping that query info would work.  Any idea if
there is another info level that would allow me to query the tag?

In any case, here is the WIP first stage of the patch - I have to add
a second patch to add the fsctl query




-- 
Thanks,

Steve

--00000000000034908b05b23ef90b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="work-in-progress-query-wsl-reparse-tags.patch"
Content-Disposition: attachment; 
	filename="work-in-progress-query-wsl-reparse-tags.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgkm64gk0>
X-Attachment-Id: f_kgkm64gk0

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRl
eCBiNjkyNWFlZWI2MjEuLjQ4NGVjMmQ4YzVjOSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xv
Yi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMjk4LDYgKzI5OCwxMCBAQCBzdHJ1Y3Qg
c21iX3ZlcnNpb25fb3BlcmF0aW9ucyB7CiAJLyogcXVlcnkgZmlsZSBkYXRhIGZyb20gdGhlIHNl
cnZlciAqLwogCWludCAoKnF1ZXJ5X2ZpbGVfaW5mbykoY29uc3QgdW5zaWduZWQgaW50LCBzdHJ1
Y3QgY2lmc190Y29uICosCiAJCQkgICAgICAgc3RydWN0IGNpZnNfZmlkICosIEZJTEVfQUxMX0lO
Rk8gKik7CisJLyogcXVlcnkgcmVwYXJzZSB0YWcgZnJvbSBzcnYgdG8gZGV0ZXJtaW5lIHdoaWNo
IHR5cGUgb2Ygc3BlY2lhbCBmaWxlICovCisJaW50ICgqcXVlcnlfcmVwYXJzZV90YWcpKGNvbnN0
IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCisJCQkJc3RydWN0IGNp
ZnNfc2JfaW5mbyAqY2lmc19zYiwgY29uc3QgY2hhciAqcGF0aCwKKwkJCQlfX3UzMiAqcmVwYXJz
ZV90YWcpOwogCS8qIGdldCBzZXJ2ZXIgaW5kZXggbnVtYmVyICovCiAJaW50ICgqZ2V0X3Nydl9p
bnVtKShjb25zdCB1bnNpZ25lZCBpbnQsIHN0cnVjdCBjaWZzX3Rjb24gKiwKIAkJCSAgICBzdHJ1
Y3QgY2lmc19zYl9pbmZvICosIGNvbnN0IGNoYXIgKiwKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvaW5v
ZGUuYyBiL2ZzL2NpZnMvaW5vZGUuYwppbmRleCBkYWVjMzFiZTg1NzEuLmZlMjA2NDM0NTBhMSAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9pbm9kZS5jCisrKyBiL2ZzL2NpZnMvaW5vZGUuYwpAQCAtOTE2
LDYgKzkxNiw3IEBAIGNpZnNfZ2V0X2lub2RlX2luZm8oc3RydWN0IGlub2RlICoqaW5vZGUsCiAJ
dm9pZCAqc21iMV9iYWNrdXBfcnNwX2J1ZiA9IE5VTEw7CiAJaW50IHJjID0gMDsKIAlpbnQgdG1w
cmMgPSAwOworCV9fdTMyIHJlcGFyc2VfdGFnID0gMDsKIAogCXRsaW5rID0gY2lmc19zYl90bGlu
ayhjaWZzX3NiKTsKIAlpZiAoSVNfRVJSKHRsaW5rKSkKQEAgLTk0MSw2ICs5NDIsMTYgQEAgY2lm
c19nZXRfaW5vZGVfaW5mbyhzdHJ1Y3QgaW5vZGUgKippbm9kZSwKIAkJCQkJCSAgZnVsbF9wYXRo
LCB0bXBfZGF0YSwKIAkJCQkJCSAgJmFkanVzdF90eiwgJnN5bWxpbmspOwogCQlkYXRhID0gdG1w
X2RhdGE7CisKKwkJLyoKKwkJICogSWYgdGhlIGZpbGUgaXMgYSByZXBhcnNlIHBvaW50LCBpdCBp
cyBtb3JlIGNvbXBsaWNhdGVkCisJCSAqIHNpbmNlIHdlIGhhdmUgdG8gY2hlY2sgaWYgaXRzIHJl
cGFyc2UgdGFnIG1hdGNoZXMgYSBrbm93bgorCQkgKiBzcGVjaWFsIGZpbGUgdHlwZSBlLmcuIHN5
bWxpbmsgb3IgZmlmbyBvciBjaGFyIGV0Yy4KKwkJICovCisJCWlmICgobGUzMl90b19jcHUoZGF0
YS0+QXR0cmlidXRlcykgJiBBVFRSX1JFUEFSU0UpICYmCisJCSAgICAoc2VydmVyLT5vcHMtPnF1
ZXJ5X3JlcGFyc2VfdGFnKSkKKwkJCXJjID0gc2VydmVyLT5vcHMtPnF1ZXJ5X3JlcGFyc2VfdGFn
KHhpZCwgdGNvbiwgY2lmc19zYiwKKwkJCQkJCWZ1bGxfcGF0aCwgJnJlcGFyc2VfdGFnKTsKIAl9
CiAKIAkvKgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyaW5vZGUuYyBiL2ZzL2NpZnMvc21iMmlu
b2RlLmMKaW5kZXggZGY2MjEyZTU1ZTEwLi4xMDllYzE2NmFhNmEgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvc21iMmlub2RlLmMKKysrIGIvZnMvY2lmcy9zbWIyaW5vZGUuYwpAQCAtNTAzLDEwICs1MDMs
MjYgQEAgbW92ZV9zbWIyX2luZm9fdG9fY2lmcyhGSUxFX0FMTF9JTkZPICpkc3QsIHN0cnVjdCBz
bWIyX2ZpbGVfYWxsX2luZm8gKnNyYykKIAlkc3QtPkluZGV4TnVtYmVyMSA9IDA7IC8qIHdlIGRv
bid0IHVzZSBpdCAqLwogfQogCisvKiBxdWVyeSByZXBhcnNlIHRhZyBmcm9tIHNydiB0byBkZXRl
cm1pbmUgd2hpY2ggdHlwZSBvZiBzcGVjaWFsIGZpbGUgKi8KK2ludCBzbWIyX3F1ZXJ5X3JlcGFy
c2VfdGFnKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCisJ
CXN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIGNvbnN0IGNoYXIgKnBhdGgsIF9fdTMyICp0
YWcpCit7CisJaW50IHJjID0gMDsKKwlfX3UzMiBjcmVhdGVfb3B0aW9ucyA9IE9QRU5fUkVQQVJT
RV9QT0lOVDsKKwlzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZTsKKworCWNpZnNfZ2V0X3JlYWRh
YmxlX3BhdGgodGNvbiwgcGF0aCwgJmNmaWxlKTsKKworCQkvKiBUT0RPIHVwZGF0ZSBiZWxvdyAq
LworCS8qIHJjID0gc21iMl9mc2N0bF9nZXRfdGFnKHhpZCwgdGNvbiwgY2lmc19zYiwgcGF0aCwu
Li4gKi8KKworCXJldHVybiByYzsKK30KKwogaW50CiBzbWIyX3F1ZXJ5X3BhdGhfaW5mbyhjb25z
dCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkgICAgIHN0cnVj
dCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsIGNvbnN0IGNoYXIgKmZ1bGxfcGF0aCwKLQkJICAgICBG
SUxFX0FMTF9JTkZPICpkYXRhLCBib29sICphZGp1c3RfdHosIGJvb2wgKnN5bWxpbmspCisJCSAg
ICAgRklMRV9BTExfSU5GTyAqZGF0YSwgYm9vbCAqYWRqdXN0X3R6LCBib29sICpyZXBhcnNlKQog
ewogCWludCByYzsKIAlzdHJ1Y3Qgc21iMl9maWxlX2FsbF9pbmZvICpzbWIyX2RhdGE7CkBAIC01
MTYsNyArNTMyLDcgQEAgc21iMl9xdWVyeV9wYXRoX2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhp
ZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAlzdHJ1Y3QgY2FjaGVkX2ZpZCAqY2ZpZCA9IE5V
TEw7CiAKIAkqYWRqdXN0X3R6ID0gZmFsc2U7Ci0JKnN5bWxpbmsgPSBmYWxzZTsKKwkqcmVwYXJz
ZSA9IGZhbHNlOwogCiAJc21iMl9kYXRhID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IHNtYjJfZmls
ZV9hbGxfaW5mbykgKyBQQVRIX01BWCAqIDIsCiAJCQkgICAgR0ZQX0tFUk5FTCk7CkBAIC01NDgs
NyArNTY0LDcgQEAgc21iMl9xdWVyeV9wYXRoX2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwg
c3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCSAgICAgIEZJTEVfUkVBRF9BVFRSSUJVVEVTLCBG
SUxFX09QRU4sIGNyZWF0ZV9vcHRpb25zLAogCQkJICAgICAgQUNMX05PX01PREUsIHNtYjJfZGF0
YSwgU01CMl9PUF9RVUVSWV9JTkZPLCBjZmlsZSk7CiAJaWYgKHJjID09IC1FT1BOT1RTVVBQKSB7
Ci0JCSpzeW1saW5rID0gdHJ1ZTsKKwkJKnJlcGFyc2UgPSB0cnVlOwogCQljcmVhdGVfb3B0aW9u
cyB8PSBPUEVOX1JFUEFSU0VfUE9JTlQ7CiAKIAkJLyogRmFpbGVkIG9uIGEgc3ltYm9saWMgbGlu
ayAtIHF1ZXJ5IGEgcmVwYXJzZSBwb2ludCBpbmZvICovCkBAIC01NzAsNyArNTg2LDcgQEAgc21i
Ml9xdWVyeV9wYXRoX2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNv
biAqdGNvbiwKIGludAogc21iMzExX3Bvc2l4X3F1ZXJ5X3BhdGhfaW5mbyhjb25zdCB1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkgICAgIHN0cnVjdCBjaWZzX3Ni
X2luZm8gKmNpZnNfc2IsIGNvbnN0IGNoYXIgKmZ1bGxfcGF0aCwKLQkJICAgICBzdHJ1Y3Qgc21i
MzExX3Bvc2l4X3FpbmZvICpkYXRhLCBib29sICphZGp1c3RfdHosIGJvb2wgKnN5bWxpbmspCisJ
CSAgICAgc3RydWN0IHNtYjMxMV9wb3NpeF9xaW5mbyAqZGF0YSwgYm9vbCAqYWRqdXN0X3R6LCBi
b29sICpyZXBhcnNlKQogewogCWludCByYzsKIAlfX3UzMiBjcmVhdGVfb3B0aW9ucyA9IDA7CkBA
IC01NzgsNyArNTk0LDcgQEAgc21iMzExX3Bvc2l4X3F1ZXJ5X3BhdGhfaW5mbyhjb25zdCB1bnNp
Z25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCXN0cnVjdCBzbWIzMTFfcG9z
aXhfcWluZm8gKnNtYjJfZGF0YTsKIAogCSphZGp1c3RfdHogPSBmYWxzZTsKLQkqc3ltbGluayA9
IGZhbHNlOworCSpyZXBhcnNlID0gZmFsc2U7CiAKIAkvKiBCQiBUT0RPOiBNYWtlIHN0cnVjdCBs
YXJnZXIgd2hlbiBhZGQgc3VwcG9ydCBmb3IgcGFyc2luZyBvd25lciBTSURzICovCiAJc21iMl9k
YXRhID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IHNtYjMxMV9wb3NpeF9xaW5mbyksCkBAIC01OTks
NyArNjE1LDcgQEAgc21iMzExX3Bvc2l4X3F1ZXJ5X3BhdGhfaW5mbyhjb25zdCB1bnNpZ25lZCBp
bnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJICAgICAgQUNMX05PX01PREUsIHNt
YjJfZGF0YSwgU01CMl9PUF9QT1NJWF9RVUVSWV9JTkZPLCBjZmlsZSk7CiAJaWYgKHJjID09IC1F
T1BOT1RTVVBQKSB7CiAJCS8qIEJCIFRPRE86IFdoZW4gc3VwcG9ydCBmb3Igc3BlY2lhbCBmaWxl
cyBhZGRlZCB0byBTYW1iYSByZS12ZXJpZnkgdGhpcyBwYXRoICovCi0JCSpzeW1saW5rID0gdHJ1
ZTsKKwkJKnJlcGFyc2UgPSB0cnVlOwogCQljcmVhdGVfb3B0aW9ucyB8PSBPUEVOX1JFUEFSU0Vf
UE9JTlQ7CiAKIAkJLyogRmFpbGVkIG9uIGEgc3ltYm9saWMgbGluayAtIHF1ZXJ5IGEgcmVwYXJz
ZSBwb2ludCBpbmZvICovCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMv
c21iMnBkdS5oCmluZGV4IDE3MWY1NDk2NTcwMy4uMTQyNDRkMjg4YjgwIDEwMDY0NAotLS0gYS9m
cy9jaWZzL3NtYjJwZHUuaAorKysgYi9mcy9jaWZzL3NtYjJwZHUuaApAQCAtMTY5MSw2ICsxNjkx
LDExIEBAIHN0cnVjdCBzbWIyX2ZpbGVfZW9mX2luZm8geyAvKiBlbmNvZGluZyBvZiByZXF1ZXN0
IGZvciBsZXZlbCAxMCAqLwogCV9fbGU2NCBFbmRPZkZpbGU7IC8qIG5ldyBlbmQgb2YgZmlsZSB2
YWx1ZSAqLwogfSBfX3BhY2tlZDsgLyogbGV2ZWwgMjAgU2V0ICovCiAKK3N0cnVjdCBzbWIyX2Zp
bGVfcmVwYXJzZV9wb2ludF9pbmZvIHsKKwlfX2xlNjQgSW5kZXhOdW1iZXI7CisJX19sZTMyIFRh
ZzsKK30gX19wYWNrZWQ7CisKIHN0cnVjdCBzbWIyX2ZpbGVfbmV0d29ya19vcGVuX2luZm8gewog
CV9fbGU2NCBDcmVhdGlvblRpbWU7CiAJX19sZTY0IExhc3RBY2Nlc3NUaW1lOwpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9zbWIycHJvdG8uaCBiL2ZzL2NpZnMvc21iMnByb3RvLmgKaW5kZXggNjdjNTBk
NzhjYWExLi5kNDExMDQ0N2VlM2EgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnByb3RvLmgKKysr
IGIvZnMvY2lmcy9zbWIycHJvdG8uaApAQCAtNzcsNiArNzcsOSBAQCBleHRlcm4gdm9pZCBjbG9z
ZV9zaHJvb3RfbGVhc2Uoc3RydWN0IGNhY2hlZF9maWQgKmNmaWQpOwogZXh0ZXJuIHZvaWQgY2xv
c2Vfc2hyb290X2xlYXNlX2xvY2tlZChzdHJ1Y3QgY2FjaGVkX2ZpZCAqY2ZpZCk7CiBleHRlcm4g
dm9pZCBtb3ZlX3NtYjJfaW5mb190b19jaWZzKEZJTEVfQUxMX0lORk8gKmRzdCwKIAkJCQkgICBz
dHJ1Y3Qgc21iMl9maWxlX2FsbF9pbmZvICpzcmMpOworZXh0ZXJuIGludCBzbWIyX3F1ZXJ5X3Jl
cGFyc2VfdGFnKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24s
CisJCQkJc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgY29uc3QgY2hhciAqcGF0aCwKKwkJ
CQlfX3UzMiAqcmVwYXJzZV90YWcpOwogZXh0ZXJuIGludCBzbWIyX3F1ZXJ5X3BhdGhfaW5mbyhj
b25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJCXN0cnVj
dCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsCiAJCQkJY29uc3QgY2hhciAqZnVsbF9wYXRoLCBGSUxF
X0FMTF9JTkZPICpkYXRhLAo=
--00000000000034908b05b23ef90b--
