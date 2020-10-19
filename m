Return-Path: <SRS0=xrBw=D2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A09CC433E7
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Oct 2020 23:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B18EC208B8
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Oct 2020 23:23:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ih6iVMdd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388927AbgJSXXz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Oct 2020 19:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbgJSXXz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Oct 2020 19:23:55 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C7FC0613CE
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2020 16:23:53 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 184so2113484lfd.6
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2020 16:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=a2vylIKuPHdrO9GEKfz/AuFuzvGr6eI7GS2n1PdgQ4U=;
        b=Ih6iVMddsC0JKWh2hsFUcdPs0NLKaE4Vcn430WMya1rvsdUNcrerkZxZk8RVc/e6vD
         nvraKDeKxF+MPTcUKoPxDbkmY/oHjgqAyNIlHYiqu97+lLYOOqR1LLPJNa88vqZDu+hE
         0lMxpHT2gchZlCeBIB/8YG+oTef1lFwS32necM8g8nU12GQ3WHAdNm0Hccg8vdUV2vIL
         dgqiHvgRCTk/z8yI13YGy3B+FdFYhDj8YW/Jn5nvmQ79LsK0GzLFpJoegFAs8tc/JLNG
         FMCke311U4nVAXlwAlvqYysAhMq3SivGEu/BSMzzkb/ZZIddF+/+9icjaIWsP8ySHCsD
         Y2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=a2vylIKuPHdrO9GEKfz/AuFuzvGr6eI7GS2n1PdgQ4U=;
        b=lzljxH3DCwg+LMf4oVgsoXgKSsD5SaHDXJYzLrI+CSgEVpCWxd0FOQRpaxiaJiuUw+
         UzmkgmPpHf5Hj/z02LdO7yNJ9cUA9lec5i6CqlJCcW+ZUQmOmDugOSBRYVQ7bnJOVMrs
         dQ91PeEFWQQM2Lj3dwpb34Gl7B308ytjPYtHNWsvaCunWFM2UZRc7TgOHQUS1C131RfB
         0LpIwko1nDdE2ywHE90+pHNojg3g8vV5cUzXYsN6bXQ/w9GcntrJsSldpBS0UL9tPw4t
         38vxJuAebuEKrGpjZxp9ebw6qYN+GHXDwbgcPs7dxf+mV6qN2zWgmy2qhybTCm8RZv51
         oyEw==
X-Gm-Message-State: AOAM531KH2wDlcYy9fjCLzD7HdASiA6zvC1CyBYvtLJRw25rq8oOcJYj
        06cSHlSDM0fDYWCbLCQUoW+J3yn0stOWdAXVTN8ULO3k9JIi1A==
X-Google-Smtp-Source: ABdhPJzQ9vuJszXEE/Q45SLAJ4de597VZx/JdIkzZPHc2h31T55zzIX6WVxBMXlh5df4yA0myoL2GfLvXk+4yIN1DZ8=
X-Received: by 2002:a19:241:: with SMTP id 62mr706912lfc.165.1603149831564;
 Mon, 19 Oct 2020 16:23:51 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 19 Oct 2020 18:23:40 -0500
Message-ID: <CAH2r5msrepnfx_wpi4uNp+OjcWz3qWTTBLBWb=T0E8i4E3Cffg@mail.gmail.com>
Subject: [SMB3][PATCH] add dynamic trace point to trace when credits obtained
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000003b8a2a05b20e6864"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003b8a2a05b20e6864
Content-Type: text/plain; charset="UTF-8"

Added dynamic trace point to trace getting credits. See attached
patch. Here is an example of what you see in mount

#           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
#              | |         |   ||||      |         |
           cifsd-9522    [010] ....  5995.187999: smb3_add_credits:
server=localhost current_mid=0x4 credits=193 credits_to_add=64
           cifsd-9522    [010] ....  5995.196028: smb3_add_credits:
server=localhost current_mid=0x5 credits=256 credits_to_add=64
           cifsd-9522    [010] ....  5995.197886: smb3_add_credits:
server=localhost current_mid=0x7 credits=274 credits_to_add=20
           cifsd-9522    [010] ....  5995.198111: smb3_add_credits:
server=localhost current_mid=0x8 credits=283 credits_to_add=10
           cifsd-9522    [010] ....  5995.198327: smb3_add_credits:
server=localhost current_mid=0x9 credits=292 credits_to_add=10
           cifsd-9522    [010] ....  5995.198533: smb3_add_credits:
server=localhost current_mid=0xa credits=301 credits_to_add=10
           cifsd-9522    [010] ....  5995.198744: smb3_add_credits:
server=localhost current_mid=0xb credits=310 credits_to_add=10
           cifsd-9522    [010] ....  5995.199056: smb3_add_credits:
server=localhost current_mid=0xc credits=319 credits_to_add=10
           cifsd-9522    [010] ....  5995.199436: smb3_add_credits:
server=localhost current_mid=0xd credits=328 credits_to_add=10
           cifsd-9522    [010] ....  5995.199872: smb3_add_credits:
server=localhost current_mid=0xe credits=337 credits_to_add=10
           cifsd-9522    [010] ....  5995.201286: smb3_add_credits:
server=localhost current_mid=0xf credits=346 credits_to_add=10
           cifsd-9522    [010] ....  5995.201500: smb3_add_credits:
server=localhost current_mid=0x10 credits=355 credits_to_add=10
           cifsd-9522    [010] ....  5995.202504: smb3_add_credits:
server=localhost current_mid=0x11 credits=364 credits_to_add=10
           cifsd-9522    [010] ....  5995.202712: smb3_add_credits:
server=localhost current_mid=0x12 credits=373 credits_to_add=10
           cifsd-9522    [010] ....  5995.204040: smb3_add_credits:
server=localhost current_mid=0x15 credits=400 credits_to_add=30

-- 
Thanks,

Steve

--0000000000003b8a2a05b20e6864
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0001-smb3-add-dynamic-trace-point-to-trace-when-credits-o.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-add-dynamic-trace-point-to-trace-when-credits-o.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kgh5zqgl0>
X-Attachment-Id: f_kgh5zqgl0

RnJvbSA2MDM5NmVjY2MwNGJiZWNmYzg1NDA0Y2UxMDkwMzYxMGUwODI1MTdkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMTkgT2N0IDIwMjAgMTg6MTg6MTUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhZGQgZHluYW1pYyB0cmFjZSBwb2ludCB0byB0cmFjZSB3aGVuIGNyZWRpdHMgb2J0YWlu
ZWQKTUlNRS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PVVU
Ri04CkNvbnRlbnQtVHJhbnNmZXItRW5jb2Rpbmc6IDhiaXQKClNNQjMgY3JlZGl0aW5nIGlzIHVz
ZWQgZm9yIGZsb3cgY29udHJvbCwgYW5kIGl0IGNhbiBiZSB1c2VmdWwgdG8KdHJhY2UgZm9yIHBy
b2JsZW0gZGV0ZXJtaW5hdGlvbiBob3cgbWFueSBjcmVkaXRzIHdlcmUgYWNxdWlyZWQKYW5kIGZv
ciB3aGljaCBvcGVyYXRpb24uCgpIZXJlIGlzIGFuIGV4YW1wbGUgKCJ0cmFjZS1jbWQgcmVjb3Jk
IC1lICphZGRfY3JlZGl0cyIpOgpjaWZzZC05NTIyIMKgIMKgWzAxMF0gLi4uLiDCoDU5OTUuMjAy
NzEyOiBzbWIzX2FkZF9jcmVkaXRzOgoJc2VydmVyPWxvY2FsaG9zdCBjdXJyZW50X21pZD0weDEy
IGNyZWRpdHM9MzczIGNyZWRpdHNfdG9fYWRkPTEwCmNpZnNkLTk1MjIgwqAgwqBbMDEwXSAuLi4u
IMKgNTk5NS4yMDQwNDA6IHNtYjNfYWRkX2NyZWRpdHM6CglzZXJ2ZXI9bG9jYWxob3N0IGN1cnJl
bnRfbWlkPTB4MTUgY3JlZGl0cz00MDAgY3JlZGl0c190b19hZGQ9MzAKClNpZ25lZC1vZmYtYnk6
IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJv
cHMuYyAgIHwgIDQgKysrLQogZnMvY2lmcy90cmFjZS5oICAgICB8IDE4ICsrKysrKysrKysrKy0t
LS0tLQogZnMvY2lmcy90cmFuc3BvcnQuYyB8ICA1ICsrKy0tCiAzIGZpbGVzIGNoYW5nZWQsIDE4
IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIy
b3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCAwZGZhODMyYTNkZTAuLmYwODVmZTMyYzM0
MiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMK
QEAgLTcyLDcgKzcyLDcgQEAgc21iMl9hZGRfY3JlZGl0cyhzdHJ1Y3QgVENQX1NlcnZlcl9JbmZv
ICpzZXJ2ZXIsCiAJLyogZWcgZm91bmQgY2FzZSB3aGVyZSB3cml0ZSBvdmVybGFwcGluZyByZWNv
bm5lY3QgbWVzc2VkIHVwIGNyZWRpdHMgKi8KIAlpZiAoKChvcHR5cGUgJiBDSUZTX09QX01BU0sp
ID09IENJRlNfTkVHX09QKSAmJiAoKnZhbCAhPSAwKSkKIAkJdHJhY2Vfc21iM19yZWNvbm5lY3Rf
d2l0aF9pbnZhbGlkX2NyZWRpdHMoc2VydmVyLT5DdXJyZW50TWlkLAotCQkJc2VydmVyLT5ob3N0
bmFtZSwgKnZhbCk7CisJCQlzZXJ2ZXItPmhvc3RuYW1lLCAqdmFsLCBhZGQpOwogCWlmICgoaW5z
dGFuY2UgPT0gMCkgfHwgKGluc3RhbmNlID09IHNlcnZlci0+cmVjb25uZWN0X2luc3RhbmNlKSkK
IAkJKnZhbCArPSBhZGQ7CiAJZWxzZQpAQCAtMTIxLDYgKzEyMSw4IEBAIHNtYjJfYWRkX2NyZWRp
dHMoc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2VydmVyLAogCQljaWZzX2RiZyhGWUksICJkaXNh
Ymxpbmcgb3Bsb2Nrc1xuIik7CiAJCWJyZWFrOwogCWRlZmF1bHQ6CisJCXRyYWNlX3NtYjNfYWRk
X2NyZWRpdHMoc2VydmVyLT5DdXJyZW50TWlkLAorCQkJc2VydmVyLT5ob3N0bmFtZSwgcmMsIGFk
ZCk7CiAJCWNpZnNfZGJnKEZZSSwgImFkZCAldSBjcmVkaXRzIHRvdGFsPSVkXG4iLCBhZGQsIHJj
KTsKIAl9CiB9CmRpZmYgLS1naXQgYS9mcy9jaWZzL3RyYWNlLmggYi9mcy9jaWZzL3RyYWNlLmgK
aW5kZXggZWVmNGIwOGM3MjA4Li45MGUwZmFiNjliYjggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvdHJh
Y2UuaAorKysgYi9mcy9jaWZzL3RyYWNlLmgKQEAgLTg3OCwzMyArODc4LDM5IEBAIERFRklORV9T
TUIzX1JFQ09OTkVDVF9FVkVOVChwYXJ0aWFsX3NlbmRfcmVjb25uZWN0KTsKIERFQ0xBUkVfRVZF
TlRfQ0xBU1Moc21iM19jcmVkaXRfY2xhc3MsCiAJVFBfUFJPVE8oX191NjQJY3Vycm1pZCwKIAkJ
Y2hhciAqaG9zdG5hbWUsCi0JCWludCBjcmVkaXRzKSwKLQlUUF9BUkdTKGN1cnJtaWQsIGhvc3Ru
YW1lLCBjcmVkaXRzKSwKKwkJaW50IGNyZWRpdHMsCisJCWludCBjcmVkaXRzX3RvX2FkZCksCisJ
VFBfQVJHUyhjdXJybWlkLCBob3N0bmFtZSwgY3JlZGl0cywgY3JlZGl0c190b19hZGQpLAogCVRQ
X1NUUlVDVF9fZW50cnkoCiAJCV9fZmllbGQoX191NjQsIGN1cnJtaWQpCiAJCV9fZmllbGQoY2hh
ciAqLCBob3N0bmFtZSkKIAkJX19maWVsZChpbnQsIGNyZWRpdHMpCisJCV9fZmllbGQoaW50LCBj
cmVkaXRzX3RvX2FkZCkKIAkpLAogCVRQX2Zhc3RfYXNzaWduKAogCQlfX2VudHJ5LT5jdXJybWlk
ID0gY3Vycm1pZDsKIAkJX19lbnRyeS0+aG9zdG5hbWUgPSBob3N0bmFtZTsKIAkJX19lbnRyeS0+
Y3JlZGl0cyA9IGNyZWRpdHM7CisJCV9fZW50cnktPmNyZWRpdHNfdG9fYWRkID0gY3JlZGl0c190
b19hZGQ7CiAJKSwKLQlUUF9wcmludGsoInNlcnZlcj0lcyBjdXJyZW50X21pZD0weCVsbHggY3Jl
ZGl0cz0lZCIsCisJVFBfcHJpbnRrKCJzZXJ2ZXI9JXMgY3VycmVudF9taWQ9MHglbGx4IGNyZWRp
dHM9JWQgY3JlZGl0c190b19hZGQ9JWQiLAogCQlfX2VudHJ5LT5ob3N0bmFtZSwKIAkJX19lbnRy
eS0+Y3Vycm1pZCwKLQkJX19lbnRyeS0+Y3JlZGl0cykKKwkJX19lbnRyeS0+Y3JlZGl0cywKKwkJ
X19lbnRyeS0+Y3JlZGl0c190b19hZGQpCiApCiAKICNkZWZpbmUgREVGSU5FX1NNQjNfQ1JFRElU
X0VWRU5UKG5hbWUpICAgICAgICBcCiBERUZJTkVfRVZFTlQoc21iM19jcmVkaXRfY2xhc3MsIHNt
YjNfIyNuYW1lLCAgXAogCVRQX1BST1RPKF9fdTY0CWN1cnJtaWQsCQlcCiAJCWNoYXIgKmhvc3Ru
YW1lLAkJCVwKLQkJaW50ICBjcmVkaXRzKSwJCQlcCi0JVFBfQVJHUyhjdXJybWlkLCBob3N0bmFt
ZSwgY3JlZGl0cykpCisJCWludCAgY3JlZGl0cywJCQlcCisJCWludCAgY3JlZGl0c190b19hZGQp
LAkJXAorCVRQX0FSR1MoY3Vycm1pZCwgaG9zdG5hbWUsIGNyZWRpdHMsIGNyZWRpdHNfdG9fYWRk
KSkKIAogREVGSU5FX1NNQjNfQ1JFRElUX0VWRU5UKHJlY29ubmVjdF93aXRoX2ludmFsaWRfY3Jl
ZGl0cyk7CiBERUZJTkVfU01CM19DUkVESVRfRVZFTlQoY3JlZGl0X3RpbWVvdXQpOworREVGSU5F
X1NNQjNfQ1JFRElUX0VWRU5UKGFkZF9jcmVkaXRzKTsKIAogI2VuZGlmIC8qIF9DSUZTX1RSQUNF
X0ggKi8KIApkaWZmIC0tZ2l0IGEvZnMvY2lmcy90cmFuc3BvcnQuYyBiL2ZzL2NpZnMvdHJhbnNw
b3J0LmMKaW5kZXggYWM3NjMyNDgyNzM2Li5lMjdlMjU1ZDQwZGQgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvdHJhbnNwb3J0LmMKKysrIGIvZnMvY2lmcy90cmFuc3BvcnQuYwpAQCAtNTYzLDcgKzU2Myw3
IEBAIHdhaXRfZm9yX2ZyZWVfY3JlZGl0cyhzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIs
IGNvbnN0IGludCBudW1fY3JlZGl0cywKIAkJCWNpZnNfbnVtX3dhaXRlcnNfZGVjKHNlcnZlcik7
CiAJCQlpZiAoIXJjKSB7CiAJCQkJdHJhY2Vfc21iM19jcmVkaXRfdGltZW91dChzZXJ2ZXItPkN1
cnJlbnRNaWQsCi0JCQkJCXNlcnZlci0+aG9zdG5hbWUsIG51bV9jcmVkaXRzKTsKKwkJCQkJc2Vy
dmVyLT5ob3N0bmFtZSwgbnVtX2NyZWRpdHMsIDApOwogCQkJCWNpZnNfc2VydmVyX2RiZyhWRlMs
ICJ3YWl0IHRpbWVkIG91dCBhZnRlciAlZCBtc1xuIiwKIAkJCQkJIHRpbWVvdXQpOwogCQkJCXJl
dHVybiAtRU5PVFNVUFA7CkBAIC02MDQsNyArNjA0LDggQEAgd2FpdF9mb3JfZnJlZV9jcmVkaXRz
KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwgY29uc3QgaW50IG51bV9jcmVkaXRzLAog
CQkJCWlmICghcmMpIHsKIAkJCQkJdHJhY2Vfc21iM19jcmVkaXRfdGltZW91dCgKIAkJCQkJCXNl
cnZlci0+Q3VycmVudE1pZCwKLQkJCQkJCXNlcnZlci0+aG9zdG5hbWUsIG51bV9jcmVkaXRzKTsK
KwkJCQkJCXNlcnZlci0+aG9zdG5hbWUsIG51bV9jcmVkaXRzLAorCQkJCQkJMCk7CiAJCQkJCWNp
ZnNfc2VydmVyX2RiZyhWRlMsICJ3YWl0IHRpbWVkIG91dCBhZnRlciAlZCBtc1xuIiwKIAkJCQkJ
CSB0aW1lb3V0KTsKIAkJCQkJcmV0dXJuIC1FTk9UU1VQUDsKLS0gCjIuMjUuMQoK
--0000000000003b8a2a05b20e6864--
