Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CF4C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 18:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiCGSri (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Mar 2022 13:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239372AbiCGSri (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Mar 2022 13:47:38 -0500
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ED889CCB
        for <linux-cifs@vger.kernel.org>; Mon,  7 Mar 2022 10:46:43 -0800 (PST)
Received: by mail-vk1-xa30.google.com with SMTP id i133so6291499vki.8
        for <linux-cifs@vger.kernel.org>; Mon, 07 Mar 2022 10:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=oiIlOSxumK8Z0CK1H+iGcsGWQviefMTcQ5QUmwgYVCk=;
        b=ZBzXbIFSejwVRdFzVQHwNmcwUBAe6PNpNwX+KY6FWrd8vJIEYWxhsb/L+sdSGbluwD
         7TxE6rWOcq0wTisNUlRU4QhZKPkg9eJvTGics0jitNI2jGbjwTD8Cs8TbLd67InSi4YJ
         c+uh4P6MzqRZuMV7DFk+gzVS2tR6NeL+WCSeNNixELI6K7rmmGyMrZbs4LymjHWuj9Il
         5VZo30r7DvJralMBuHjh+zzhROAXl864CNZBe1kFK7j/eSyvPi1es3oIiwWf2p2IlW5v
         ZZzyzzlIlWlH7C4aX4p0XcsMFqZyheobRE0sMEzwjFbjRVu4NVoaTr/GxShAugoDoA0p
         wwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=oiIlOSxumK8Z0CK1H+iGcsGWQviefMTcQ5QUmwgYVCk=;
        b=8D+pAyKQYWQl+uenLRAQYbMp4WyVhUFOm26Eo+MNlCQkKMeKsVCZQ6wS0ARElX0Yut
         N/tU66Ff7p//pl5SDUtw3LjEWklZ1E510EwJk4IqxcRYuCOqG9XMLw9XJmOUg7HRESpo
         o0aENASf4sfSNRhxFxShNsyz5sdr5shYJgm1axYFauQ5gQU+O01uFIkDy+GsYQdtUI6g
         un9z54skNn5ko33Q9vHSIWkce/EZSYQehfxUVEoMrwUzwxQDw1W/Ty0Ncf4Jgad5BjiI
         YeN2SJtCD9xJpq4EAxt5eBi+KV64YdK35tmbAmkL00DqI7C+AV6OaBZ88tWnv3/tYwB+
         zFBQ==
X-Gm-Message-State: AOAM5337t+K+RoJ6RGf/YHHw6Hp65Y4lfO+3C8e7lo1o+Wy7jKj46qIt
        YmO7ij2tfJqo8qq0MpUUXPKmWTt1sDK+kgy6Yy2sSycPh1g=
X-Google-Smtp-Source: ABdhPJyvrMLxl35waNf8Bx+tCazypdZqSEqFpWWgoNgDGPArapPbhCwmJXlCb9vq6HWKHFdXtDmyAh8wq+xwcFvQqZc=
X-Received: by 2002:a05:6122:d07:b0:331:1c65:33c2 with SMTP id
 az7-20020a0561220d0700b003311c6533c2mr4594961vkb.41.1646678802687; Mon, 07
 Mar 2022 10:46:42 -0800 (PST)
MIME-Version: 1.0
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Tue, 8 Mar 2022 00:16:31 +0530
Message-ID: <CACdtm0ad+byeGwcpAmLCJWoyyXjJeu=6ZX=QODa0fgxs4X-iyA@mail.gmail.com>
Subject: [PATCH][SMB3]Adjust cifssb maximum read size
To:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: multipart/mixed; boundary="00000000000018831905d9a5494b"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000018831905d9a5494b
Content-Type: text/plain; charset="UTF-8"

Hi All,

When session gets reconnected during mount then read size in super
block fs context gets set to zero and after negotiate, rsize is not
modified which results in incorrect read with requested bytes as zero.

Attaching 2 patches, one for releases before 5.17 and other for latest.
Please take a look.

Regards,
Rohith

--00000000000018831905d9a5494b
Content-Type: application/octet-stream; 
	name="SMB3-After-5.17-Adjust-cifssb-maximum-read-size.patch"
Content-Disposition: attachment; 
	filename="SMB3-After-5.17-Adjust-cifssb-maximum-read-size.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l0h214rf0>
X-Attachment-Id: f_l0h214rf0

RnJvbSA5NDA1OTI3MTkzMTk4Y2MwM2E2Y2VlYWUxYTE5ZmE5ZGFlMjVhNmNjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogTW9uLCA3IE1hciAyMDIyIDE4OjM3OjIyICswMDAwClN1YmplY3Q6IFtQQVRD
SF0gW1NNQjNdW0FmdGVyIDUuMTddQWRqdXN0IGNpZnNzYiBtYXhpbXVtIHJlYWQgc2l6ZQoKV2hl
biBzZXNzaW9uIGdldHMgcmVjb25uZWN0ZWQgZHVyaW5nIG1vdW50IHRoZW4gcmVhZCBzaXplIGlu
IHN1cGVyIGJsb2NrIGZzIGNvbnRleHQKZ2V0cyBzZXQgdG8gemVybyBhbmQgYWZ0ZXIgbmVnb3Rp
YXRlLCByc2l6ZSBpcyBub3QgbW9kaWZpZWQgd2hpY2ggcmVzdWx0cyBpbiBpbmNvcnJlY3QKcmVh
ZCB3aXRoIHJlcXVlc3RlZCBieXRlcyBhcyB6ZXJvLgoKU2lnbmVkLW9mZi1ieTogUm9oaXRoIFN1
cmFiYXR0dWxhIDxyb2hpdGhzQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzZnMuYyB8
IDIgKysKIGZzL2NpZnMvZmlsZS5jICAgfCA2ICsrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCA4IGlu
c2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZz
ZnMuYwppbmRleCAwODJjMjE0Nzg2ODYuLmRmY2VmNzEyNzhhMSAxMDA2NDQKLS0tIGEvZnMvY2lm
cy9jaWZzZnMuYworKysgYi9mcy9jaWZzL2NpZnNmcy5jCkBAIC0yMTAsNiArMjEwLDggQEAgY2lm
c19yZWFkX3N1cGVyKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpCiAJaWYgKHJjKQogCQlnb3RvIG91
dF9ub19yb290OwogCS8qIHR1bmUgcmVhZGFoZWFkIGFjY29yZGluZyB0byByc2l6ZSBpZiByZWFk
YWhlYWQgc2l6ZSBub3Qgc2V0IG9uIG1vdW50ICovCisJaWYgKGNpZnNfc2ItPmN0eC0+cnNpemUg
PT0gMCkKKwkJY2lmc19zYi0+Y3R4LT5yc2l6ZSA9IHRjb24tPnNlcy0+c2VydmVyLT5vcHMtPm5l
Z290aWF0ZV9yc2l6ZSh0Y29uLCBjaWZzX3NiLT5jdHgpOwogCWlmIChjaWZzX3NiLT5jdHgtPnJh
c2l6ZSkKIAkJc2ItPnNfYmRpLT5yYV9wYWdlcyA9IGNpZnNfc2ItPmN0eC0+cmFzaXplIC8gUEFH
RV9TSVpFOwogCWVsc2UKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZmlsZS5jIGIvZnMvY2lmcy9maWxl
LmMKaW5kZXggZTdhZjgwMmRjZmE2Li5jOWY0ZmE0MWYxYzMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
ZmlsZS5jCisrKyBiL2ZzL2NpZnMvZmlsZS5jCkBAIC0zNzQwLDYgKzM3NDAsOSBAQCBjaWZzX3Nl
bmRfYXN5bmNfcmVhZChsb2ZmX3Qgb2Zmc2V0LCBzaXplX3QgbGVuLCBzdHJ1Y3QgY2lmc0ZpbGVJ
bmZvICpvcGVuX2ZpbGUsCiAJCQkJYnJlYWs7CiAJCX0KIAorCQlpZiAoY2lmc19zYi0+Y3R4LT5y
c2l6ZSA9PSAwKQorCQkJY2lmc19zYi0+Y3R4LT5yc2l6ZSA9IHNlcnZlci0+b3BzLT5uZWdvdGlh
dGVfcnNpemUodGxpbmtfdGNvbihvcGVuX2ZpbGUtPnRsaW5rKSwgY2lmc19zYi0+Y3R4KTsKKwog
CQlyYyA9IHNlcnZlci0+b3BzLT53YWl0X210dV9jcmVkaXRzKHNlcnZlciwgY2lmc19zYi0+Y3R4
LT5yc2l6ZSwKIAkJCQkJCSAgICZyc2l6ZSwgY3JlZGl0cyk7CiAJCWlmIChyYykKQEAgLTQ0NzQs
NiArNDQ3Nyw5IEBAIHN0YXRpYyB2b2lkIGNpZnNfcmVhZGFoZWFkKHN0cnVjdCByZWFkYWhlYWRf
Y29udHJvbCAqcmFjdGwpCiAJCQl9CiAJCX0KIAorCQlpZiAoY2lmc19zYi0+Y3R4LT5yc2l6ZSA9
PSAwKQorCQkJY2lmc19zYi0+Y3R4LT5yc2l6ZSA9IHNlcnZlci0+b3BzLT5uZWdvdGlhdGVfcnNp
emUodGxpbmtfdGNvbihvcGVuX2ZpbGUtPnRsaW5rKSwgY2lmc19zYi0+Y3R4KTsKKwogCQlyYyA9
IHNlcnZlci0+b3BzLT53YWl0X210dV9jcmVkaXRzKHNlcnZlciwgY2lmc19zYi0+Y3R4LT5yc2l6
ZSwKIAkJCQkJCSAgICZyc2l6ZSwgY3JlZGl0cyk7CiAJCWlmIChyYykKLS0gCjIuMzIuMAoK
--00000000000018831905d9a5494b
Content-Type: application/octet-stream; 
	name="SMB3-Before-5.17-Adjust-cifssb-maximum-read-size.patch"
Content-Disposition: attachment; 
	filename="SMB3-Before-5.17-Adjust-cifssb-maximum-read-size.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l0h214sd1>
X-Attachment-Id: f_l0h214sd1

RnJvbSBhYTEyODQxZDU5ZGM0YjUyZDQwMzU2NzZlOTVjZTlkMDUxZmUzMGQxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogTW9uLCA3IE1hciAyMDIyIDE3OjMwOjI2ICswMDAwClN1YmplY3Q6IFtQQVRD
SF0gW1NNQjNdW0JlZm9yZSA1LjE3XUFkanVzdCBjaWZzc2IgbWF4aW11bSByZWFkIHNpemUKCldo
ZW4gc2Vzc2lvbiBnZXRzIHJlY29ubmVjdGVkIGR1cmluZyBtb3VudCB0aGVuIHJlYWQgc2l6ZSBp
biBzdXBlciBibG9jayBmcyBjb250ZXh0CmdldHMgc2V0IHRvIHplcm8gYW5kIGFmdGVyIG5lZ290
aWF0ZSwgcnNpemUgaXMgbm90IG1vZGlmaWVkIHdoaWNoIHJlc3VsdHMgaW4gaW5jb3JyZWN0CnJl
YWQgd2l0aCByZXF1ZXN0ZWQgYnl0ZXMgYXMgemVyby4KClNpZ25lZC1vZmYtYnk6IFJvaGl0aCBT
dXJhYmF0dHVsYSA8cm9oaXRoc0BtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc2ZzLmMg
fCAyICsrCiBmcy9jaWZzL2ZpbGUuYyAgIHwgNiArKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgOCBp
bnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzZnMuYyBiL2ZzL2NpZnMvY2lm
c2ZzLmMKaW5kZXggMmZmY2IyOWQ1YzhmLi4yOWY0ZjQxOWQ1ZmEgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvY2lmc2ZzLmMKKysrIGIvZnMvY2lmcy9jaWZzZnMuYwpAQCAtMjE5LDYgKzIxOSw4IEBAIGNp
ZnNfcmVhZF9zdXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQogCWlmIChyYykKIAkJZ290byBv
dXRfbm9fcm9vdDsKIAkvKiB0dW5lIHJlYWRhaGVhZCBhY2NvcmRpbmcgdG8gcnNpemUgaWYgcmVh
ZGFoZWFkIHNpemUgbm90IHNldCBvbiBtb3VudCAqLworCWlmIChjaWZzX3NiLT5jdHgtPnJzaXpl
ID09IDApCisJCWNpZnNfc2ItPmN0eC0+cnNpemUgPSB0Y29uLT5zZXMtPnNlcnZlci0+b3BzLT5u
ZWdvdGlhdGVfcnNpemUodGNvbiwgY2lmc19zYi0+Y3R4KTsKIAlpZiAoY2lmc19zYi0+Y3R4LT5y
YXNpemUpCiAJCXNiLT5zX2JkaS0+cmFfcGFnZXMgPSBjaWZzX3NiLT5jdHgtPnJhc2l6ZSAvIFBB
R0VfU0laRTsKIAllbHNlCmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZpbGUuYyBiL2ZzL2NpZnMvZmls
ZS5jCmluZGV4IDBjYzA1YmY4MTE4OS4uMDBiYTBmNDZjNWRiIDEwMDY0NAotLS0gYS9mcy9jaWZz
L2ZpbGUuYworKysgYi9mcy9jaWZzL2ZpbGUuYwpAQCAtMzcyMCw2ICszNzIwLDkgQEAgY2lmc19z
ZW5kX2FzeW5jX3JlYWQobG9mZl90IG9mZnNldCwgc2l6ZV90IGxlbiwgc3RydWN0IGNpZnNGaWxl
SW5mbyAqb3Blbl9maWxlLAogCQkJCWJyZWFrOwogCQl9CiAKKwkJaWYgKGNpZnNfc2ItPmN0eC0+
cnNpemUgPT0gMCkKKwkJCWNpZnNfc2ItPmN0eC0+cnNpemUgPSBzZXJ2ZXItPm9wcy0+bmVnb3Rp
YXRlX3JzaXplKHRsaW5rX3Rjb24ob3Blbl9maWxlLT50bGluayksIGNpZnNfc2ItPmN0eCk7CisK
IAkJcmMgPSBzZXJ2ZXItPm9wcy0+d2FpdF9tdHVfY3JlZGl0cyhzZXJ2ZXIsIGNpZnNfc2ItPmN0
eC0+cnNpemUsCiAJCQkJCQkgICAmcnNpemUsIGNyZWRpdHMpOwogCQlpZiAocmMpCkBAIC00NDkx
LDYgKzQ0OTQsOSBAQCBzdGF0aWMgaW50IGNpZnNfcmVhZHBhZ2VzKHN0cnVjdCBmaWxlICpmaWxl
LCBzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywKIAkJCQlicmVhazsKIAkJfQogCisJCWlm
IChjaWZzX3NiLT5jdHgtPnJzaXplID09IDApCisJCQljaWZzX3NiLT5jdHgtPnJzaXplID0gc2Vy
dmVyLT5vcHMtPm5lZ290aWF0ZV9yc2l6ZSh0bGlua190Y29uKG9wZW5fZmlsZS0+dGxpbmspLCBj
aWZzX3NiLT5jdHgpOworCiAJCXJjID0gc2VydmVyLT5vcHMtPndhaXRfbXR1X2NyZWRpdHMoc2Vy
dmVyLCBjaWZzX3NiLT5jdHgtPnJzaXplLAogCQkJCQkJICAgJnJzaXplLCBjcmVkaXRzKTsKIAkJ
aWYgKHJjKQotLSAKMi4zMi4wCgo=
--00000000000018831905d9a5494b--
