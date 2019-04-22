Return-Path: <SRS0=FjIb=SY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C44EC10F11
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Apr 2019 21:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D52E206BA
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Apr 2019 21:52:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mbyRb6kY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfDVVwZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Apr 2019 17:52:25 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:44193 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfDVVwZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Apr 2019 17:52:25 -0400
Received: by mail-pf1-f171.google.com with SMTP id y13so6328977pfm.11
        for <linux-cifs@vger.kernel.org>; Mon, 22 Apr 2019 14:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=qJriqYvsCdwDwz1J4BUmS0Fj8T3kgU0ZdQ54fDVKccg=;
        b=mbyRb6kYnWTr1CN5VQKz+c2zhquuRy7RThvtieJrTV1ZrEUb7zUg6MLZP8aHzoOQln
         hR2Tdiy2RaspZNmPpuoxIff2xwjFalaj4b1nFSriLBkyKRwmA/U4YIq+CYmZd3V9W6pj
         UzDRwRJfR97qpcM2Xaby+MQZaTHTr3SbltyyYStI+fv6NrEd/p0vP2nTV7D4f0Ezs/TA
         UiqzQoBpV5Hbj7E+VahqR7lnnFxWxFPAkwNVcMf7g2EoRE21bkLIzAk2q75mxe+S4Hm9
         X36j0s3QXsKuIuEHKr/o2dwhU82txtiLDgxS0TkqsySipMvDRqRJvK7ymmplNb/f8J/y
         VQqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=qJriqYvsCdwDwz1J4BUmS0Fj8T3kgU0ZdQ54fDVKccg=;
        b=HN15iQbbmeiS0GSy10KhViskIB2AiLGm6iiCVzX8zHfk9JGL7btHQFYqFz6zNhYAM6
         /sOdKdboe0Xn7G8UK6Bcw8oGhqFujur9IBRSKDtiZaWiIGyywfArZkxhXaZAo5jSD5JQ
         xpNViZ4KqiRCwqfyayHuw3nlnqne0qFcUv8klyuYnVgsF2L6nXLTxKLPKvz2cf+vLWTL
         kzvbwqU1FerL4wzzcIB7QpgcEbX32AK/7WMtKR4DDOfW1t0M1lS3BQusq6wV8MygG1WC
         XXmXqkA2Jb1ObDjQXqC4D9B4AbtkhK8TDAY7t5vwnsE4j9rZ78E/TNLS0xZO+IMAlta5
         EBpA==
X-Gm-Message-State: APjAAAXQUPksFTwxFkXk+ZBgt+5MBtx/Hj6jEM0I2Hxk933jvZzYLV91
        qorRDgAvYHvvnIgDwh7kytnZxHG+HLN8BNulkEbxLGMZ
X-Google-Smtp-Source: APXvYqzIHNdzw3+tvYCPa9LwY0JMgk05PrBrmUY0pmYJF9g/1dkdBAyw8GfYEV49y6wWFkMTHlJQLfIqF2ppfjwfcKI=
X-Received: by 2002:a63:570d:: with SMTP id l13mr21239024pgb.55.1555969944030;
 Mon, 22 Apr 2019 14:52:24 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 22 Apr 2019 16:52:11 -0500
Message-ID: <CAH2r5muC05zDdP7EsThSE9+xxPwrmFnzW7NqAtRQgoF3P3dk_Q@mail.gmail.com>
Subject: SMB3: allowing extending size if allocating on non-sparse file
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000cbc40b0587257b14"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000cbc40b0587257b14
Content-Type: text/plain; charset="UTF-8"

This is simply the same as changing the end of file.



-- 
Thanks,

Steve

--000000000000cbc40b0587257b14
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3-allowing-extending-size-if-allocating-on-non-sp.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3-allowing-extending-size-if-allocating-on-non-sp.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_juswbkw30>
X-Attachment-Id: f_juswbkw30

RnJvbSA4ZjY2NTE5OWZhNzAyOTg4YzYyNzY2MmY3NjczYTExZWY3ZTNjNzFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgMjIgQXByIDIwMTkgMTY6Mzc6NDIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBT
TUIzOiBhbGxvd2luZyBleHRlbmRpbmcgc2l6ZSBpZiBhbGxvY2F0aW5nIG9uIG5vbi1zcGFyc2UK
IGZpbGUKClRoaXMgaXMgc2ltcGx5IHRoZSBzYW1lIGFzIGNoYW5naW5nIHRoZSBlbmQgb2YgZmls
ZS4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
UmV2aWV3ZWQtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNvbT4KLS0tCiBm
cy9jaWZzL3NtYjJvcHMuYyB8IDkgKysrKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRp
b25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIv
ZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggYzM0ODBhOTc2NjYwLi5mOGNmY2JhNzk3ZjMgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC0yOTIw
LDkgKzI5MjAsMTIgQEAgc3RhdGljIGxvbmcgc21iM19zaW1wbGVfZmFsbG9jKHN0cnVjdCBmaWxl
ICpmaWxlLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQllbHNlIGlmIChpX3NpemVfcmVhZChp
bm9kZSkgPj0gb2ZmICsgbGVuKQogCQkJLyogbm90IGV4dGVuZGluZyBmaWxlIGFuZCBhbHJlYWR5
IG5vdCBzcGFyc2UgKi8KIAkJCXJjID0gMDsKLQkJLyogQkI6IGluIGZ1dHVyZSBhZGQgZWxzZSBj
bGF1c2UgdG8gZXh0ZW5kIGZpbGUgKi8KLQkJZWxzZQotCQkJcmMgPSAtRU9QTk9UU1VQUDsKKwkJ
ZWxzZSB7CisJCQlfX2xlNjQgbGVuZ3RoID0gY3B1X3RvX2xlNjQob2ZmK2xlbik7CisKKwkJCXJj
ID0gU01CMl9zZXRfZW9mKHhpZCwgdGNvbiwgY2ZpbGUtPmZpZC5wZXJzaXN0ZW50X2ZpZCwKKwkJ
CQljZmlsZS0+ZmlkLnZvbGF0aWxlX2ZpZCwgY2ZpbGUtPnBpZCwgJmxlbmd0aCk7CisJCX0KIAkJ
aWYgKHJjKQogCQkJdHJhY2Vfc21iM19mYWxsb2NfZXJyKHhpZCwgY2ZpbGUtPmZpZC5wZXJzaXN0
ZW50X2ZpZCwKIAkJCQl0Y29uLT50aWQsIHRjb24tPnNlcy0+U3VpZCwgb2ZmLCBsZW4sIHJjKTsK
LS0gCjIuMTcuMQoK
--000000000000cbc40b0587257b14--
