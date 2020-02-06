Return-Path: <SRS0=edh0=32=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C789C35247
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 00:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CB8A20730
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 00:29:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RSbD7cCx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgBFA3d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Feb 2020 19:29:33 -0500
Received: from mail-io1-f42.google.com ([209.85.166.42]:37753 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbgBFA3c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Feb 2020 19:29:32 -0500
Received: by mail-io1-f42.google.com with SMTP id k24so4355872ioc.4
        for <linux-cifs@vger.kernel.org>; Wed, 05 Feb 2020 16:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+CS6v5iToZXy4zWYyZFwCzTNvX8Kj+/mbyX5yoD4gWc=;
        b=RSbD7cCx4FYcz/REShLh8e7ILySaMHLSaBNvkOXRJEg+jRPLYI/5xQrgexhZSwYtDD
         9ta9zkUqtYoBHbEDWuuX1LllzYIJLBeJ2GZvnXpdSUX8hsOB9nURfVCGCZ0chce/23i8
         U+n+cGD83fGC7m+l4HT0yrQqkeWieSWKqx7ub1cFi56H6/69aFH0bQxeVwlZxKNexlHK
         Zx6//f7Hbp6tAQS7ICfESveZb2ONXnArQb+/PT3hEns5xKI/F167vogIfrM0E3D0krp8
         RdqkOBzYx6qYeMNjuyW+MZgW98UZqN5oZ6oJr6SptWtdq0kTAe2k1Vot+e6PN0NU+88t
         w00A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+CS6v5iToZXy4zWYyZFwCzTNvX8Kj+/mbyX5yoD4gWc=;
        b=gv1S9sEo/z/Z4nZgK3k8VRzZwEQi8t3a4Wcazqf3l1m9LzK0G9xW51UAPmY6PYL8M+
         QEjDUbiYsby/NC2l6k84Cg3cG6W2rOVkLWdEF4WocbZ2s0M8YYT5tu3x+J5mM2HKiuuf
         ih+LjKjT4lk/js89vlsGJeYZojnJlpovp0Z3+/ZCYkt/eQ4JWRn+OtK2+Q2ZxkA8wDFL
         lgGCCxPBeQdIS0OWtlyCrJrElQDwePKeFkoJ2IFI+v0DwPqD5zkvJ5rrrNyVS48g4pzi
         01HCK+7QkzohY9qGYE39SZpu4yX70D0JAZxPeIGFa/f7rLAPc0WqPn8eAdErKwzkmFCL
         CEFg==
X-Gm-Message-State: APjAAAX/6b6JeEdT50G6ejq0msKFF37M0OoTO1WgV/3rwq2iTpwJw7/y
        3mVNQa5dlP01tM8SnL4RRe1TjkTS4aXKRUDMXIl+koBRg7A=
X-Google-Smtp-Source: APXvYqwA2+P/hWTV+IOVp/wp6Byf2oFvvPwI4dzRWA1ksOYQY3kqdcer6qHMlMod59Y9HKPwzjIW4/mHtzpmNp5ABdY=
X-Received: by 2002:a02:c951:: with SMTP id u17mr32239627jao.27.1580948971851;
 Wed, 05 Feb 2020 16:29:31 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 5 Feb 2020 18:29:21 -0600
Message-ID: <CAH2r5mu985seFnTzTLM197oO1K012NjSwYY=ey=xc5PsWfCUsA@mail.gmail.com>
Subject: [CIFS][PATCH] Add dynamic trace points for flush and fsync
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Oleg Kravtsov <oleg@tuxera.com>
Content-Type: multipart/mixed; boundary="000000000000e03ab1059ddd5d9a"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e03ab1059ddd5d9a
Content-Type: text/plain; charset="UTF-8"

Makes it easier to debug errors on writeback that happen later,
and are being returned on flush or fsync

For example:
  writetest-17829 [002] .... 13583.407859: cifs_flush_err: ino=90 rc=-28


-- 
Thanks,

Steve

--000000000000e03ab1059ddd5d9a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Add-tracepoints-for-errors-on-flush-or-fsync.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Add-tracepoints-for-errors-on-flush-or-fsync.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k6a06v3w0>
X-Attachment-Id: f_k6a06v3w0

RnJvbSBmMmJmMDllOTdiNDdjN2IxM2U4YTkxOGY1NjBmNjA4MmU5YmM4ZjhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgNSBGZWIgMjAyMCAxODoyMjozNyAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IEFkZCB0cmFjZXBvaW50cyBmb3IgZXJyb3JzIG9uIGZsdXNoIG9yIGZzeW5jCgpNYWtlcyBp
dCBlYXNpZXIgdG8gZGVidWcgZXJyb3JzIG9uIHdyaXRlYmFjayB0aGF0IGhhcHBlbiBsYXRlciwK
YW5kIGFyZSBiZWluZyByZXR1cm5lZCBvbiBmbHVzaCBvciBmc3luYwoKRm9yIGV4YW1wbGU6CiAg
d3JpdGV0ZXN0LTE3ODI5IFswMDJdIC4uLi4gMTM1ODMuNDA3ODU5OiBjaWZzX2ZsdXNoX2Vycjog
aW5vPTkwIHJjPS0yOAoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNy
b3NvZnQuY29tPgotLS0KIGZzL2NpZnMvZmlsZS5jICB8ICA3ICsrKysrLS0KIGZzL2NpZnMvdHJh
Y2UuaCB8IDI3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAz
MiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZmls
ZS5jIGIvZnMvY2lmcy9maWxlLmMKaW5kZXggNzllNmY0ZjU1YjliLi45OWVhN2IyYTA2YTUgMTAw
NjQ0Ci0tLSBhL2ZzL2NpZnMvZmlsZS5jCisrKyBiL2ZzL2NpZnMvZmlsZS5jCkBAIC0yNjMyLDgg
KzI2MzIsMTAgQEAgaW50IGNpZnNfZnN5bmMoc3RydWN0IGZpbGUgKmZpbGUsIGxvZmZfdCBzdGFy
dCwgbG9mZl90IGVuZCwgaW50IGRhdGFzeW5jKQogCXN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNf
c2IgPSBDSUZTX0ZJTEVfU0IoZmlsZSk7CiAKIAlyYyA9IGZpbGVfd3JpdGVfYW5kX3dhaXRfcmFu
Z2UoZmlsZSwgc3RhcnQsIGVuZCk7Ci0JaWYgKHJjKQorCWlmIChyYykgeworCQl0cmFjZV9jaWZz
X2ZzeW5jX2VycihmaWxlX2lub2RlKGZpbGUpLT5pX2lubywgcmMpOwogCQlyZXR1cm4gcmM7CisJ
fQogCiAJeGlkID0gZ2V0X3hpZCgpOwogCkBAIC0yNjY2LDcgKzI2NjgsOCBAQCBpbnQgY2lmc19m
bHVzaChzdHJ1Y3QgZmlsZSAqZmlsZSwgZmxfb3duZXJfdCBpZCkKIAkJcmMgPSBmaWxlbWFwX3dy
aXRlX2FuZF93YWl0KGlub2RlLT5pX21hcHBpbmcpOwogCiAJY2lmc19kYmcoRllJLCAiRmx1c2gg
aW5vZGUgJXAgZmlsZSAlcCByYyAlZFxuIiwgaW5vZGUsIGZpbGUsIHJjKTsKLQorCWlmIChyYykK
KwkJdHJhY2VfY2lmc19mbHVzaF9lcnIoaW5vZGUtPmlfaW5vLCByYyk7CiAJcmV0dXJuIHJjOwog
fQogCmRpZmYgLS1naXQgYS9mcy9jaWZzL3RyYWNlLmggYi9mcy9jaWZzL3RyYWNlLmgKaW5kZXgg
ZTdlMzUwYjEzZDZhLi40Y2IwZDVmN2NlNDUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvdHJhY2UuaAor
KysgYi9mcy9jaWZzL3RyYWNlLmgKQEAgLTU0Nyw2ICs1NDcsMzMgQEAgREVGSU5FX0VWRU5UKHNt
YjNfZXhpdF9lcnJfY2xhc3MsIHNtYjNfIyNuYW1lLCAgICBcCiAKIERFRklORV9TTUIzX0VYSVRf
RVJSX0VWRU5UKGV4aXRfZXJyKTsKIAorCitERUNMQVJFX0VWRU5UX0NMQVNTKHNtYjNfc3luY19l
cnJfY2xhc3MsCisJVFBfUFJPVE8odW5zaWduZWQgbG9uZyBpbm8sCisJCWludAlyYyksCisJVFBf
QVJHUyhpbm8sIHJjKSwKKwlUUF9TVFJVQ1RfX2VudHJ5KAorCQlfX2ZpZWxkKHVuc2lnbmVkIGxv
bmcsIGlubykKKwkJX19maWVsZChpbnQsIHJjKQorCSksCisJVFBfZmFzdF9hc3NpZ24oCisJCV9f
ZW50cnktPmlubyA9IGlubzsKKwkJX19lbnRyeS0+cmMgPSByYzsKKwkpLAorCVRQX3ByaW50aygi
XHRpbm89JWx1IHJjPSVkIiwKKwkJX19lbnRyeS0+aW5vLCBfX2VudHJ5LT5yYykKKykKKworI2Rl
ZmluZSBERUZJTkVfU01CM19TWU5DX0VSUl9FVkVOVChuYW1lKSAgICAgICAgICBcCitERUZJTkVf
RVZFTlQoc21iM19zeW5jX2Vycl9jbGFzcywgY2lmc18jI25hbWUsICAgIFwKKwlUUF9QUk9UTyh1
bnNpZ25lZCBsb25nIGlubywJCVwKKwkJaW50CXJjKSwJCQlcCisJVFBfQVJHUyhpbm8sIHJjKSkK
KworREVGSU5FX1NNQjNfU1lOQ19FUlJfRVZFTlQoZnN5bmNfZXJyKTsKK0RFRklORV9TTUIzX1NZ
TkNfRVJSX0VWRU5UKGZsdXNoX2Vycik7CisKKwogREVDTEFSRV9FVkVOVF9DTEFTUyhzbWIzX2Vu
dGVyX2V4aXRfY2xhc3MsCiAJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwKIAkJY29uc3QgY2hh
ciAqZnVuY19uYW1lKSwKLS0gCjIuMjAuMQoK
--000000000000e03ab1059ddd5d9a--
