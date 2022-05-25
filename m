Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95081C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 25 May 2022 02:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242438AbiEYCsk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 May 2022 22:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiEYCsi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 May 2022 22:48:38 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B2E703C7
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 19:48:36 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id z6so19965837vsp.0
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 19:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=RRJ46JB/nYv8adFmsAtkD7ohsfbSmPHvi/tw0fAjKGQ=;
        b=WmUdQG7RE6hMImLSMVvYi0rtsNtn4db/pZWVcmT7rQTFtSbznc5Gaw0s5Yo2Jj+x6T
         LU8LQmj6lt8Vjo/ZtbDe/JwDYxHU5BsJbEn02fYNvrX4U8T0a33Jmq4W0VMy1eVO53dX
         R4UXCHsqfA8wnxAUDh6mge3jbZKwFoK5iYkxEYZZ9JD0Eq44QZ6TNiM4KsdGgQVX24Ny
         zQh0txsVw+TFGc+MEV6gYyCW71RLED57paCHuvXj4/NNlIzhxo/iBn6/30OFqLk6Mccp
         OtxbCpoOs5lWGanudX0R6nJL0h3AlC6AVORtnjHv0X8hzd+9A12uJVoxlr3x2cg6iaTc
         Ws6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=RRJ46JB/nYv8adFmsAtkD7ohsfbSmPHvi/tw0fAjKGQ=;
        b=jS1FeIUxnCjkigKswJswAvSzGwF2LOzq8tEFsW3eKTo8b7XkMvB0uswS745WWFMMLi
         LHvV5at+6VCJCAGg0dOtKeVLgJsA8lawYX1mFSb+scOFLC0f4YjYDWbKcSPdzcQqNh1V
         wZGsRQwfwAjGlSz+L+gJ9m5ziJCAifpT30IGZT0nwLexozuLeaLObwx12TrxCvhtLjbi
         roFMI7XVOg4c0wCNWvnC7GVR1WU3h/3XItF6ERHa5zlR7qOq8ExJOoPyHRMypyGtiLq6
         L9geQFmqp3st9pi2RjSlyn3862zBbDeFc+3OvJB2CQGXR9ArF4iVg+/Eu/2O5d+NffoI
         yPXw==
X-Gm-Message-State: AOAM533hhRTOUwp3MopE3htTYtKcqLvqrDiJqHny/gvvRPRCahox+FlD
        E1P4sbVbfycb2WKAdV7DBofmbt+ju/QcuPKD+1BWNGfVAuE=
X-Google-Smtp-Source: ABdhPJyqsJDkgQHgyjrp6G0heNpF8BvBY45auyaxem49WPFv7PxXIae7VhUiTI4uWz/cw2QTdHstJYx+amHiarZOilo=
X-Received: by 2002:a67:b607:0:b0:337:b5b7:adc9 with SMTP id
 d7-20020a67b607000000b00337b5b7adc9mr5396254vsm.17.1653446914833; Tue, 24 May
 2022 19:48:34 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 24 May 2022 21:48:23 -0500
Message-ID: <CAH2r5mvgC8cygWEAAXUhOZvM0RHZqg9cbG7TTijK0PRbaZCMPg@mail.gmail.com>
Subject: Should BUG() be removed or changed to WARN_ON in iov_iter changeset
To:     David Howells <dhowells@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000003957f05dfcd1cbc"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000003957f05dfcd1cbc
Content-Type: text/plain; charset="UTF-8"

-------------------------------------------------------------------------
/home/smfrench/dhowell/linux-fs/0003-cifs-Add-some-helper-functions.patch
-------------------------------------------------------------------------
WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code
rather than BUG() or BUG_ON()
#67: FILE: fs/cifs/cifssmb.c:1950:
+ BUG();

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code
rather than BUG() or BUG_ON()
#95: FILE: fs/cifs/cifssmb.c:1978:
+ BUG();

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code
rather than BUG() or BUG_ON()
#123: FILE: fs/cifs/cifssmb.c:2006:
+ BUG();

total: 0 errors, 3 warnings, 106 lines checked


-- 
Thanks,

Steve

--00000000000003957f05dfcd1cbc
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0003-cifs-Add-some-helper-functions.patch"
Content-Disposition: attachment; 
	filename="0003-cifs-Add-some-helper-functions.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l3kzlf0p0>
X-Attachment-Id: f_l3kzlf0p0

RnJvbSA5OWIzMzY2ZTQwYzYxNjQyZWZiZDk1MzAyMmFlYzc2Y2Y3OTFlY2E5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQuY29tPgpE
YXRlOiBXZWQsIDYgQXByIDIwMjIgMTk6NDE6MjggKzAxMDAKU3ViamVjdDogW1BBVENIIDMvN10g
Y2lmczogQWRkIHNvbWUgaGVscGVyIGZ1bmN0aW9ucwoKQWRkIHNvbWUgaGVscGVyIGZ1bmN0aW9u
cyB0byBtYW5pcHVsYXRlIHRoZSBmb2xpbyBtYXJrcyBieSBpdGVyYXRpbmcKdGhyb3VnaCBhIGxp
c3Qgb2YgZm9saW9zIGhlbGQgaW4gYW4geGFycmF5IHJhdGhlciB0aGFuIHVzaW5nIGEgcGFnZSBs
aXN0LgoKU2lnbmVkLW9mZi1ieTogRGF2aWQgSG93ZWxscyA8ZGhvd2VsbHNAcmVkaGF0LmNvbT4K
Y2M6IFN0ZXZlIEZyZW5jaCA8c2ZyZW5jaEBzYW1iYS5vcmc+CmNjOiBTaHlhbSBQcmFzYWQgTiA8
bnNwbWFuZ2Fsb3JlQGdtYWlsLmNvbT4KY2M6IFJvaGl0aCBTdXJhYmF0dHVsYSA8cm9oaXRocy5t
c2Z0QGdtYWlsLmNvbT4KY2M6IGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnCi0tLQogZnMvY2lm
cy9jaWZzZnMuaCAgfCAgMyArKwogZnMvY2lmcy9jaWZzc21iLmMgfCA4NSArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCA4OCBp
bnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZnMuaCBiL2ZzL2NpZnMvY2lm
c2ZzLmgKaW5kZXggYzA1NDJiZGNkMDZiLi4zNGFkOTY1Y2RlMjEgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvY2lmc2ZzLmgKKysrIGIvZnMvY2lmcy9jaWZzZnMuaApAQCAtMTEwLDYgKzExMCw5IEBAIGV4
dGVybiBpbnQgY2lmc19maWxlX3N0cmljdF9tbWFwKHN0cnVjdCBmaWxlICogLCBzdHJ1Y3Qgdm1f
YXJlYV9zdHJ1Y3QgKik7CiBleHRlcm4gY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyBjaWZz
X2Rpcl9vcHM7CiBleHRlcm4gaW50IGNpZnNfZGlyX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwg
c3RydWN0IGZpbGUgKmZpbGUpOwogZXh0ZXJuIGludCBjaWZzX3JlYWRkaXIoc3RydWN0IGZpbGUg
KmZpbGUsIHN0cnVjdCBkaXJfY29udGV4dCAqY3R4KTsKK2V4dGVybiB2b2lkIGNpZnNfcGFnZXNf
d3JpdHRlbl9iYWNrKHN0cnVjdCBpbm9kZSAqaW5vZGUsIGxvZmZfdCBzdGFydCwgdW5zaWduZWQg
aW50IGxlbik7CitleHRlcm4gdm9pZCBjaWZzX3BhZ2VzX3dyaXRlX2ZhaWxlZChzdHJ1Y3QgaW5v
ZGUgKmlub2RlLCBsb2ZmX3Qgc3RhcnQsIHVuc2lnbmVkIGludCBsZW4pOworZXh0ZXJuIHZvaWQg
Y2lmc19wYWdlc193cml0ZV9yZWRpcnR5KHN0cnVjdCBpbm9kZSAqaW5vZGUsIGxvZmZfdCBzdGFy
dCwgdW5zaWduZWQgaW50IGxlbik7CiAKIC8qIEZ1bmN0aW9ucyByZWxhdGVkIHRvIGRpciBlbnRy
aWVzICovCiBleHRlcm4gY29uc3Qgc3RydWN0IGRlbnRyeV9vcGVyYXRpb25zIGNpZnNfZGVudHJ5
X29wczsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3NtYi5jIGIvZnMvY2lmcy9jaWZzc21iLmMK
aW5kZXggNDdlOTI3YzRmZjhkLi44OGUyZGU3NGY3NGYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lm
c3NtYi5jCisrKyBiL2ZzL2NpZnMvY2lmc3NtYi5jCkBAIC0yNyw2ICsyNyw3IEBACiAjaW5jbHVk
ZSAiY2lmc2dsb2IuaCIKICNpbmNsdWRlICJjaWZzYWNsLmgiCiAjaW5jbHVkZSAiY2lmc3Byb3Rv
LmgiCisjaW5jbHVkZSAiY2lmc2ZzLmgiCiAjaW5jbHVkZSAiY2lmc191bmljb2RlLmgiCiAjaW5j
bHVkZSAiY2lmc19kZWJ1Zy5oIgogI2luY2x1ZGUgInNtYjJwcm90by5oIgpAQCAtMTkyOCw2ICsx
OTI5LDkwIEBAIGNpZnNfd3JpdGVkYXRhX3JlbGVhc2Uoc3RydWN0IGtyZWYgKnJlZmNvdW50KQog
CWtmcmVlKHdkYXRhKTsKIH0KIAorLyoKKyAqIENvbXBsZXRpb24gb2Ygd3JpdGUgdG8gc2VydmVy
LgorICovCit2b2lkIGNpZnNfcGFnZXNfd3JpdHRlbl9iYWNrKHN0cnVjdCBpbm9kZSAqaW5vZGUs
IGxvZmZfdCBzdGFydCwgdW5zaWduZWQgaW50IGxlbikKK3sKKwlzdHJ1Y3QgYWRkcmVzc19zcGFj
ZSAqbWFwcGluZyA9IGlub2RlLT5pX21hcHBpbmc7CisJc3RydWN0IGZvbGlvICpmb2xpbzsKKwlw
Z29mZl90IGVuZDsKKworCVhBX1NUQVRFKHhhcywgJm1hcHBpbmctPmlfcGFnZXMsIHN0YXJ0IC8g
UEFHRV9TSVpFKTsKKworCXJjdV9yZWFkX2xvY2soKTsKKworCWVuZCA9IChzdGFydCArIGxlbiAt
IDEpIC8gUEFHRV9TSVpFOworCXhhc19mb3JfZWFjaCgmeGFzLCBmb2xpbywgZW5kKSB7CisJCWlm
ICghZm9saW9fdGVzdF93cml0ZWJhY2soZm9saW8pKSB7CisJCQlwcl9lcnIoImJhZCAleCBAJWxs
eCBwYWdlICVseCAlbHhcbiIsCisJCQkgICAgICAgbGVuLCBzdGFydCwgZm9saW9faW5kZXgoZm9s
aW8pLCBlbmQpOworCQkJQlVHKCk7CisJCX0KKworCQlmb2xpb19kZXRhY2hfcHJpdmF0ZShmb2xp
byk7CisJCWZvbGlvX2VuZF93cml0ZWJhY2soZm9saW8pOworCX0KKworCXJjdV9yZWFkX3VubG9j
aygpOworfQorCisvKgorICogRmFpbHVyZSBvZiB3cml0ZSB0byBzZXJ2ZXIuCisgKi8KK3ZvaWQg
Y2lmc19wYWdlc193cml0ZV9mYWlsZWQoc3RydWN0IGlub2RlICppbm9kZSwgbG9mZl90IHN0YXJ0
LCB1bnNpZ25lZCBpbnQgbGVuKQoreworCXN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nID0g
aW5vZGUtPmlfbWFwcGluZzsKKwlzdHJ1Y3QgZm9saW8gKmZvbGlvOworCXBnb2ZmX3QgZW5kOwor
CisJWEFfU1RBVEUoeGFzLCAmbWFwcGluZy0+aV9wYWdlcywgc3RhcnQgLyBQQUdFX1NJWkUpOwor
CisJcmN1X3JlYWRfbG9jaygpOworCisJZW5kID0gKHN0YXJ0ICsgbGVuIC0gMSkgLyBQQUdFX1NJ
WkU7CisJeGFzX2Zvcl9lYWNoKCZ4YXMsIGZvbGlvLCBlbmQpIHsKKwkJaWYgKCFmb2xpb190ZXN0
X3dyaXRlYmFjayhmb2xpbykpIHsKKwkJCXByX2VycigiYmFkICV4IEAlbGx4IHBhZ2UgJWx4ICVs
eFxuIiwKKwkJCSAgICAgICBsZW4sIHN0YXJ0LCBmb2xpb19pbmRleChmb2xpbyksIGVuZCk7CisJ
CQlCVUcoKTsKKwkJfQorCisJCWZvbGlvX3NldF9lcnJvcihmb2xpbyk7CisJCWZvbGlvX2VuZF93
cml0ZWJhY2soZm9saW8pOworCX0KKworCXJjdV9yZWFkX3VubG9jaygpOworfQorCisvKgorICog
UmVkaXJ0eSBwYWdlcyBhZnRlciBhIHRlbXBvcmFyeSBmYWlsdXJlLgorICovCit2b2lkIGNpZnNf
cGFnZXNfd3JpdGVfcmVkaXJ0eShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBsb2ZmX3Qgc3RhcnQsIHVu
c2lnbmVkIGludCBsZW4pCit7CisJc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcgPSBpbm9k
ZS0+aV9tYXBwaW5nOworCXN0cnVjdCBmb2xpbyAqZm9saW87CisJcGdvZmZfdCBlbmQ7CisKKwlY
QV9TVEFURSh4YXMsICZtYXBwaW5nLT5pX3BhZ2VzLCBzdGFydCAvIFBBR0VfU0laRSk7CisKKwly
Y3VfcmVhZF9sb2NrKCk7CisKKwllbmQgPSAoc3RhcnQgKyBsZW4gLSAxKSAvIFBBR0VfU0laRTsK
Kwl4YXNfZm9yX2VhY2goJnhhcywgZm9saW8sIGVuZCkgeworCQlpZiAoIWZvbGlvX3Rlc3Rfd3Jp
dGViYWNrKGZvbGlvKSkgeworCQkJcHJfZXJyKCJiYWQgJXggQCVsbHggcGFnZSAlbHggJWx4XG4i
LAorCQkJICAgICAgIGxlbiwgc3RhcnQsIGZvbGlvX2luZGV4KGZvbGlvKSwgZW5kKTsKKwkJCUJV
RygpOworCQl9CisKKwkJZmlsZW1hcF9kaXJ0eV9mb2xpbyhmb2xpby0+bWFwcGluZywgZm9saW8p
OworCQlmb2xpb19lbmRfd3JpdGViYWNrKGZvbGlvKTsKKwl9CisKKwlyY3VfcmVhZF91bmxvY2so
KTsKK30KKwogLyoKICAqIFdyaXRlIGZhaWxlZCB3aXRoIGEgcmV0cnlhYmxlIGVycm9yLiBSZXNl
bmQgdGhlIHdyaXRlIHJlcXVlc3QuIEl0J3MgYWxzbwogICogcG9zc2libGUgdGhhdCB0aGUgcGFn
ZSB3YXMgcmVkaXJ0aWVkIHNvIHJlLWNsZWFuIHRoZSBwYWdlLgotLSAKMi4zNC4xCgo=
--00000000000003957f05dfcd1cbc--
