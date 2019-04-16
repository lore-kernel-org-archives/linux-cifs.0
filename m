Return-Path: <SRS0=txT2=SS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC656C10F14
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 23:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 835DC217D4
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 23:01:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K3oG+VRb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbfDPXBr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Apr 2019 19:01:47 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:34827 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbfDPXBr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Apr 2019 19:01:47 -0400
Received: by mail-pf1-f169.google.com with SMTP id t21so11133405pfh.2
        for <linux-cifs@vger.kernel.org>; Tue, 16 Apr 2019 16:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=uZ16YEIkpmXuLIPN1iU9e901M3VpTZ5njZVDsAwL/DQ=;
        b=K3oG+VRbvTSd5S2/NvbcNVii9xHPq29OQQ2qAv7aXQlrwln2Jy2JkZx7X4ETfkq2Tv
         8GLGAWirJCidm/5gnunP8DNtn9uU93NUWBa0KZC0Kgo3zzK+w7r2GgCxLqoTzGcBlOzn
         54hwuRtMVCc+3LVMHWMvluDqRE3IvkR2usyeSvlCX0jxdesz3SwmpUhK9IeiVkbVr07r
         ntwQRkNWVXUhPg9cMO6r5gn7OInWbgwfMiXKoWvVw3JKtbgALFkWIDoda5+INUmQHFpA
         wPtolHZX+LMeA3f8TUFCe7sdkA0BrtOdNMtYBY5FkDrOicqRvFNLoYVRSSxEIAxUe7Lb
         6BjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=uZ16YEIkpmXuLIPN1iU9e901M3VpTZ5njZVDsAwL/DQ=;
        b=Xr138lBnVDkrxNkAB656lA7HUNwzCod9JIVRqSyliP9vthmcYF2blsmxRTHKkXzV8x
         bTejKS7kDmote1hCXEu3IYj0c3g/L3lCSiqdu9eDJDaCxJO66f0FiH79GH6zfTecSltK
         yO8KZyjLy29WYxa3ZMK3b4V5aDfRHtfYC3dlXPok0T/Fjd1Qw0sS0RdjWwiE6xHV+JBF
         dFtJtHXVeYQR0eaNV95axbLZCk/3j6DIpRZIzDMR5eoA4sQjf/fZqWK8nrsYRM1Om47D
         3x68chqVQ1obK3aSLgaQlWrHUWgibjcegyrSoRrfybYa5biR6E+61XHiOO57VqgLoMTg
         G1EQ==
X-Gm-Message-State: APjAAAWtNi9iKzCWf3pfoEwvps20ya3CJ4Slbhb9GwALtbhT9oBp8mt8
        S6SSTvE+99J28ikoaO4jhf1PvmsziCMjM2pWWUk=
X-Google-Smtp-Source: APXvYqyAsNjbfOONWRkPDAgGqOGnfeksmBrSmeGM67QEXnHQukFGyQUzqOKxgqUzNCa0DYv+einoDR/T8nfMZOK74X8=
X-Received: by 2002:aa7:8c13:: with SMTP id c19mr84832850pfd.225.1555455706283;
 Tue, 16 Apr 2019 16:01:46 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 16 Apr 2019 18:01:35 -0500
Message-ID: <CAH2r5muDm75fSmjG5-5YOKynJRVKKhkecdCLwq_rqgtjzSwCYQ@mail.gmail.com>
Subject: [PATCH] cifs: fix bi-directional fsctl passthrough calls
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d661f10586adc026"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d661f10586adc026
Content-Type: text/plain; charset="UTF-8"

Trivial fix up for compile/sparse warning



-- 
Thanks,

Steve

--000000000000d661f10586adc026
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-bi-directional-fsctl-passthrough-calls.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-bi-directional-fsctl-passthrough-calls.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_juke5oom0>
X-Attachment-Id: f_juke5oom0

RnJvbSAyZGNlMTA3M2EwMDA4ZTQ2NjczNjg0Y2M1OWI5OTA1MDRmYzY2MjM1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IE1vbiwgMTUgQXByIDIwMTkgMTI6MTM6NTIgKzEwMDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gY2lmczogZml4IGJpLWRpcmVjdGlvbmFsIGZzY3RsIHBhc3N0aHJvdWdoIGNhbGxzCgpTTUIy
IElvY3RsIHJlc3BvbnNlcyBmcm9tIHNlcnZlcnMgbWF5IHJlc3BvbmQgd2l0aCBib3RoIHRoZSBy
ZXF1ZXN0IGJsb2IgZnJvbQp0aGUgY2xpZW50IGZvbGxvd2VkIGJ5IHRoZSBhY3R1YWwgcmVwbHkg
YmxvYiBmb3IgaW9jdGxzIHRoYXQgYXJlIGJpLWRpcmVjdGlvbmFsLgoKSW4gdGhhdCBjYXNlIHdl
IGNhbiBub3QgYXNzdW1lIHRoYXQgdGhlIHJlcGx5IGJsb2IgY29tZXMgaW1tZWRpYXRlbHkgYWZ0
ZXIgdGhlCmlvY3RsIHJlc3BvbnNlIHN0cnVjdHVyZS4KClRoaXMgZml4ZXMgRlNDVExzIHN1Y2gg
YXMgU01CMjpGU0NUTF9RVUVSWV9BTExPQ0FURURfUkFOR0VTCgpTaWduZWQtb2ZmLWJ5OiBSb25u
aWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZy
ZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJvcHMuYyB8IDkg
KysrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
CgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRl
eCAwOGZmMDQ0ZmJiNGIuLjg0MWNlN2UxZmI3MiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3Bz
LmMKKysrIGIvZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTE0NjIsMTIgKzE0NjIsMTkgQEAgc21iMl9p
b2N0bF9xdWVyeV9pbmZvKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsCiAJCWlvX3JzcCA9IChzdHJ1
Y3Qgc21iMl9pb2N0bF9yc3AgKilyc3BfaW92WzFdLmlvdl9iYXNlOwogCQlpZiAobGUzMl90b19j
cHUoaW9fcnNwLT5PdXRwdXRDb3VudCkgPCBxaS5pbnB1dF9idWZmZXJfbGVuZ3RoKQogCQkJcWku
aW5wdXRfYnVmZmVyX2xlbmd0aCA9IGxlMzJfdG9fY3B1KGlvX3JzcC0+T3V0cHV0Q291bnQpOwor
CQlpZiAocWkuaW5wdXRfYnVmZmVyX2xlbmd0aCA+IDAgJiYKKwkJICAgIGxlMzJfdG9fY3B1KGlv
X3JzcC0+T3V0cHV0T2Zmc2V0KSArIHFpLmlucHV0X2J1ZmZlcl9sZW5ndGggPiByc3BfaW92WzFd
Lmlvdl9sZW4pIHsKKwkJCXJjID0gLUVGQVVMVDsKKwkJCWdvdG8gaXFpbmZfZXhpdDsKKwkJfQog
CQlpZiAoY29weV90b191c2VyKCZwcWktPmlucHV0X2J1ZmZlcl9sZW5ndGgsICZxaS5pbnB1dF9i
dWZmZXJfbGVuZ3RoLAogCQkJCSBzaXplb2YocWkuaW5wdXRfYnVmZmVyX2xlbmd0aCkpKSB7CiAJ
CQlyYyA9IC1FRkFVTFQ7CiAJCQlnb3RvIGlxaW5mX2V4aXQ7CiAJCX0KLQkJaWYgKGNvcHlfdG9f
dXNlcihwcWkgKyAxLCAmaW9fcnNwWzFdLCBxaS5pbnB1dF9idWZmZXJfbGVuZ3RoKSkgeworCQlp
ZiAoY29weV90b191c2VyKCh2b2lkIF9fdXNlciAqKXBxaSArIHNpemVvZihzdHJ1Y3Qgc21iX3F1
ZXJ5X2luZm8pLAorCQkJCSAoY29uc3Qgdm9pZCAqKWlvX3JzcCArIGxlMzJfdG9fY3B1KGlvX3Jz
cC0+T3V0cHV0T2Zmc2V0KSwKKwkJCQkgcWkuaW5wdXRfYnVmZmVyX2xlbmd0aCkpIHsKIAkJCXJj
ID0gLUVGQVVMVDsKIAkJCWdvdG8gaXFpbmZfZXhpdDsKIAkJfQotLSAKMi4xNy4xCgo=
--000000000000d661f10586adc026--
