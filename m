Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389D3ECAAA1
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Sep 2022 05:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiILFge (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Sep 2022 01:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiILFge (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Sep 2022 01:36:34 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D6F1AD84
        for <linux-cifs@vger.kernel.org>; Sun, 11 Sep 2022 22:36:32 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id g185so3654182vkb.13
        for <linux-cifs@vger.kernel.org>; Sun, 11 Sep 2022 22:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=a4HITrssL9lZzOzrCQRucdis7ZBIvQg9YWyrnqcN5vQ=;
        b=hCjl4J0E5bHi6xZpeMSIw3rLqUTnOhwHIsxQIhHPFi/HCFUJYJnC33eu+bV0gSGilj
         d3E2cD4un3gFj78Fu1ggymQyjp/OgXAA/ygFXZx4q2w80pGLogaeymSWYH2xq7mlqTXd
         w+Gs41O2v3qtrN7eKQ6IFwgr6jpxali4ay/oBIhxnYoYkqdFm6LNOaQvZproCsnD5u2S
         AAhiK5qDu34FYsSlq4IzqZHM2+ICCi/S4FQqAWB7Hepd+YrYjwuIJ/a4njUqebnuXxIj
         AOeD65+CGniIXwB9+uwU5oFNdUBrK0SSxZ+xQ7X58aqEzxVEFGtJVL1T60hREN+tuvNq
         pFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=a4HITrssL9lZzOzrCQRucdis7ZBIvQg9YWyrnqcN5vQ=;
        b=yL9UuBY3ybdwk0aIds0j1IWPY5fG1clIX3699qC9OpGlcQk/ACSyw3srohNI88LLrE
         /wyuzxjCOmZmcqyZ9sxSXgPkO02palaLYLf2xcjh4TS8KlElx3mJIxOSGojUbo2miFjW
         osC7882b+kgdp/GTBpgMZRagu1AAHjshLtw0J+pUcAtmLB38xSWP3WafGOy8mJs2wKiA
         9f0sPB7IVm17UwhwL8ZxbnJZb+59SYYKNCx+yDDxuFTGK1EQh7qQOOIPiME/cf2egEXg
         uBSPIGBAleg/h6wtqtEiCUWCMW1tgdAbGyVz32IoAEdIn1AXvD7Bx7endzRpPgmYb80z
         jPBQ==
X-Gm-Message-State: ACgBeo19PVueCYjvzC2d4KbW2awyu+sHdWroOvtG5vG72rC1StiFxBAP
        5uyVucomljXsV94s5xhTKaCkXs1O71/2TMCQ5PFO2cZETPw=
X-Google-Smtp-Source: AA6agR7/Jh1/FGcgHek5mUy5wZbYIUdspD8MZ2KULLT9rMElUd3UnSKyt54ebSYcOBBQjBp/SBYI625PDaAE5YNEmvE=
X-Received: by 2002:a1f:918d:0:b0:3a1:e376:7463 with SMTP id
 t135-20020a1f918d000000b003a1e3767463mr4874860vkd.38.1662960991032; Sun, 11
 Sep 2022 22:36:31 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 12 Sep 2022 00:36:20 -0500
Message-ID: <CAH2r5mvC5sqwuLyLt=3PXYvPegOm-8rqSMYcCpjM3+T64fv2sg@mail.gmail.com>
Subject: [PATCH][SMB3.1.1 client] fallback to query fs all info if posix query
 fs not supported
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="0000000000002581cd05e87447e3"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002581cd05e87447e3
Content-Type: text/plain; charset="UTF-8"

A version of Samba that I was testing, supported POSIX extensions, but
not the query fs info
level.  Fall back to query fs all info if POSIX query fs info not
supported.

Also fixes the problem that compounding wasn't being used for posix
qfs info in this path (statfs) but was being used in others, so
improves performance of posix query fs info.

-- 
Thanks,

Steve

--0000000000002581cd05e87447e3
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb311-fallback-to-query-fs-all-info-if-posix-query-.patch"
Content-Disposition: attachment; 
	filename="0001-smb311-fallback-to-query-fs-all-info-if-posix-query-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l7ybw61y0>
X-Attachment-Id: f_l7ybw61y0

RnJvbSAyZWY3ODUzMDExMWUwZGRiNTViMzI1ODVjOWRmNGNmZTY2NmZiODkxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMTEgU2VwIDIwMjIgMTk6NDk6MDQgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzMTE6IGZhbGxiYWNrIHRvIHF1ZXJ5IGZzIGFsbCBpbmZvIGlmIHBvc2l4IHF1ZXJ5IGZzIG5v
dAogc3VwcG9ydGVkCgpBIHZlcnNpb24gb2YgU2FtYmEsIHN1cHBvcnRlZCBQT1NJWCBleHRlbnNp
b25zLCBidXQgbm90IHRoZSBxdWVyeSBmcyBpbmZvCmxldmVsLiAgRmFsbCBiYWNrIHRvIHF1ZXJ5
IGZzIGFsbCBpbmZvIGlmIFBPU0lYIHF1ZXJ5IGZzIGluZm8gbm90CnN1cHBvcnRlZC4KCkFsc28g
Zml4ZXMgdGhlIHByb2JsZW0gdGhhdCBjb21wb3VuZGluZyB3YXNuJ3QgYmVpbmcgdXNlZCBmb3Ig
cG9zaXgKcWZzIGluZm8gaW4gdGhpcyBwYXRoIChzdGF0ZnMpIGJ1dCB3YXMgYmVpbmcgdXNlZCBp
biBvdGhlcnMsIHNvCmltcHJvdmVzIHBlcmZvcm1hbmNlIG9mIHBvc2l4IHF1ZXJ5IGZzIGluZm8u
CgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0t
LQogZnMvY2lmcy9zbWIyb3BzLmMgICB8IDQ0ICsrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0tLS0tLS0tLS0tCiBmcy9jaWZzL3NtYjJwZHUuYyAgIHwgIDIgKy0KIGZzL2NpZnMvc21i
MnByb3RvLmggfCAgMiArKwogMyBmaWxlcyBjaGFuZ2VkLCAyOSBpbnNlcnRpb25zKCspLCAxOSBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21i
Mm9wcy5jCmluZGV4IDQyMWJlNDNhZjQyNS4uNTQwMDJkMWVmNWMzIDEwMDY0NAotLS0gYS9mcy9j
aWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMjU1NywzMSArMjU1Nywz
OSBAQCBzdGF0aWMgaW50CiBzbWIzMTFfcXVlcnlmcyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBz
dHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCSAgICAgICBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZz
X3NiLCBzdHJ1Y3Qga3N0YXRmcyAqYnVmKQogeworCXN0cnVjdCBzbWIyX3F1ZXJ5X2luZm9fcnNw
ICpyc3A7CisJc3RydWN0IGt2ZWMgcnNwX2lvdiA9IHtOVUxMLCAwfTsKKwlGSUxFX1NZU1RFTV9Q
T1NJWF9JTkZPICppbmZvID0gTlVMTDsKKwlpbnQgYnVmdHlwZSA9IENJRlNfTk9fQlVGRkVSOwog
CWludCByYzsKLQlfX2xlMTYgc3JjaF9wYXRoID0gMDsgLyogTnVsbCAtIG9wZW4gcm9vdCBvZiBz
aGFyZSAqLwotCXU4IG9wbG9jayA9IFNNQjJfT1BMT0NLX0xFVkVMX05PTkU7Ci0Jc3RydWN0IGNp
ZnNfb3Blbl9wYXJtcyBvcGFybXM7Ci0Jc3RydWN0IGNpZnNfZmlkIGZpZDsKIAogCWlmICghdGNv
bi0+cG9zaXhfZXh0ZW5zaW9ucykKIAkJcmV0dXJuIHNtYjJfcXVlcnlmcyh4aWQsIHRjb24sIGNp
ZnNfc2IsIGJ1Zik7CiAKLQlvcGFybXMudGNvbiA9IHRjb247Ci0Jb3Bhcm1zLmRlc2lyZWRfYWNj
ZXNzID0gRklMRV9SRUFEX0FUVFJJQlVURVM7Ci0Jb3Bhcm1zLmRpc3Bvc2l0aW9uID0gRklMRV9P
UEVOOwotCW9wYXJtcy5jcmVhdGVfb3B0aW9ucyA9IGNpZnNfY3JlYXRlX29wdGlvbnMoY2lmc19z
YiwgMCk7Ci0Jb3Bhcm1zLmZpZCA9ICZmaWQ7Ci0Jb3Bhcm1zLnJlY29ubmVjdCA9IGZhbHNlOwot
Ci0JcmMgPSBTTUIyX29wZW4oeGlkLCAmb3Bhcm1zLCAmc3JjaF9wYXRoLCAmb3Bsb2NrLCBOVUxM
LCBOVUxMLAotCQkgICAgICAgTlVMTCwgTlVMTCk7Ci0JaWYgKHJjKQotCQlyZXR1cm4gcmM7CisJ
cmMgPSBzbWIyX3F1ZXJ5X2luZm9fY29tcG91bmQoeGlkLCB0Y29uLCAiIiwKKwkJCQkgICAgICBG
SUxFX1JFQURfQVRUUklCVVRFUywKKwkJCQkgICAgICBGU19QT1NJWF9JTkZPUk1BVElPTiwKKwkJ
CQkgICAgICBTTUIyX09fSU5GT19GSUxFU1lTVEVNLAorCQkJCSAgICAgIHNpemVvZihGSUxFX1NZ
U1RFTV9QT1NJWF9JTkZPKSwKKwkJCQkgICAgICAmcnNwX2lvdiwgJmJ1ZnR5cGUsIGNpZnNfc2Ip
OworCWlmIChyYyA9PSAtRUlPKSAvKiBzb21lIHBvc2l4IHNlcnZlcnMgZGlkbid0IHN1cHBvcnQg
dGhpcyBpbmZvIGxldmVsICovCisJCXJldHVybiBzbWIyX3F1ZXJ5ZnMoeGlkLCB0Y29uLCBjaWZz
X3NiLCBidWYpOworCWVsc2UgaWYgKHJjKQorCQlnb3RvIHBxZnNfZXhpdDsKIAotCXJjID0gU01C
MzExX3Bvc2l4X3Fmc19pbmZvKHhpZCwgdGNvbiwgZmlkLnBlcnNpc3RlbnRfZmlkLAotCQkJCSAg
IGZpZC52b2xhdGlsZV9maWQsIGJ1Zik7CisJcnNwID0gKHN0cnVjdCBzbWIyX3F1ZXJ5X2luZm9f
cnNwICopcnNwX2lvdi5pb3ZfYmFzZTsKIAlidWYtPmZfdHlwZSA9IFNNQjJfU1VQRVJfTUFHSUM7
Ci0JU01CMl9jbG9zZSh4aWQsIHRjb24sIGZpZC5wZXJzaXN0ZW50X2ZpZCwgZmlkLnZvbGF0aWxl
X2ZpZCk7CisJaW5mbyA9IChGSUxFX1NZU1RFTV9QT1NJWF9JTkZPICopKAorCQlsZTE2X3RvX2Nw
dShyc3AtPk91dHB1dEJ1ZmZlck9mZnNldCkgKyAoY2hhciAqKXJzcCk7CisJcmMgPSBzbWIyX3Zh
bGlkYXRlX2lvdihsZTE2X3RvX2NwdShyc3AtPk91dHB1dEJ1ZmZlck9mZnNldCksCisJCQkgICAg
ICAgbGUzMl90b19jcHUocnNwLT5PdXRwdXRCdWZmZXJMZW5ndGgpLAorCQkJICAgICAgICZyc3Bf
aW92LAorCQkJICAgICAgIHNpemVvZihGSUxFX1NZU1RFTV9QT1NJWF9JTkZPKSk7CisJaWYgKCFy
YykKKwkJY29weV9wb3NpeF9mc19pbmZvX3RvX2tzdGF0ZnMoaW5mbywgYnVmKTsKKworcHFmc19l
eGl0OgorCWZyZWVfcnNwX2J1ZihidWZ0eXBlLCByc3BfaW92Lmlvdl9iYXNlKTsKIAlyZXR1cm4g
cmM7CiB9CiAKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1
LmMKaW5kZXggNjM1MmFiMzJjN2U3Li4wMWYwY2MxNjIwYmQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
c21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC01MjUxLDcgKzUyNTEsNyBAQCBz
bWIyX2NvcHlfZnNfaW5mb190b19rc3RhdGZzKHN0cnVjdCBzbWIyX2ZzX2Z1bGxfc2l6ZV9pbmZv
ICpwZnNfaW5mLAogCXJldHVybjsKIH0KIAotc3RhdGljIHZvaWQKK3ZvaWQKIGNvcHlfcG9zaXhf
ZnNfaW5mb190b19rc3RhdGZzKEZJTEVfU1lTVEVNX1BPU0lYX0lORk8gKnJlc3BvbnNlX2RhdGEs
CiAJCQlzdHJ1Y3Qga3N0YXRmcyAqa3N0KQogewpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycHJv
dG8uaCBiL2ZzL2NpZnMvc21iMnByb3RvLmgKaW5kZXggM2Y3NDBmMjRiOTZhLi5jOTZjNmNhZDkw
YTQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnByb3RvLmgKKysrIGIvZnMvY2lmcy9zbWIycHJv
dG8uaApAQCAtMjY3LDYgKzI2Nyw4IEBAIGV4dGVybiBpbnQgc21iMl92YWxpZGF0ZV9hbmRfY29w
eV9pb3YodW5zaWduZWQgaW50IG9mZnNldCwKIGV4dGVybiB2b2lkIHNtYjJfY29weV9mc19pbmZv
X3RvX2tzdGF0ZnMoCiAJIHN0cnVjdCBzbWIyX2ZzX2Z1bGxfc2l6ZV9pbmZvICpwZnNfaW5mLAog
CSBzdHJ1Y3Qga3N0YXRmcyAqa3N0KTsKK2V4dGVybiB2b2lkIGNvcHlfcG9zaXhfZnNfaW5mb190
b19rc3RhdGZzKEZJTEVfU1lTVEVNX1BPU0lYX0lORk8gKnJlc3BvbnNlX2RhdGEsCisJCQkJCSAg
c3RydWN0IGtzdGF0ZnMgKmtzdCk7CiBleHRlcm4gaW50IHNtYjMxMV9jcnlwdG9fc2hhc2hfYWxs
b2NhdGUoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyKTsKIGV4dGVybiBpbnQgc21iMzEx
X3VwZGF0ZV9wcmVhdXRoX2hhc2goc3RydWN0IGNpZnNfc2VzICpzZXMsCiAJCQkJICAgICAgc3Ry
dWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLAotLSAKMi4zNC4xCgo=
--0000000000002581cd05e87447e3--
