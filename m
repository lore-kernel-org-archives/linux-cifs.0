Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457E4C433B4
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Apr 2021 15:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A8260FEF
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Apr 2021 15:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhDEPdh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Apr 2021 11:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238291AbhDEPde (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Apr 2021 11:33:34 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDD6C061756
        for <linux-cifs@vger.kernel.org>; Mon,  5 Apr 2021 08:33:26 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 82so2313166yby.7
        for <linux-cifs@vger.kernel.org>; Mon, 05 Apr 2021 08:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=f6dy3Ip3DaXRrhKvJCfr4jBUh7QAlRrG6iSAD5A3T6Y=;
        b=l/8Ifw8JVQOrwDzlF0j4t7QDzLyu4FtdGjV1G3C3wXTV05WqR4G//mJ969SFy1TJuw
         aV2P6h4PNX2FKcSIkS49KeWgzqlbgFK3kTEjdpqyCo56+FZ+ahqO3iLGdJG//WtRaxzl
         7B0yaefw09aoif18wsus0e7RvZcNZ/ti7fuhBTXDDhipH59/OGOTwYbwyNuLM5O6g6C5
         M6mib4Rbt0vbLkna79ljc5xa/k1/qUHth+/N1dty7xFIScCBU4KivPwxLPvC0R0NkUOX
         pCgmyinLL6s+w3flO1CLv7Zv78Cpm/eAgDHdIDAftMqVfMJ4gFcQv3A4b0i8s1loLw04
         WD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=f6dy3Ip3DaXRrhKvJCfr4jBUh7QAlRrG6iSAD5A3T6Y=;
        b=FrsUAP6q1WymKtSBzSU6x1mGMnN9NKg5csjumbh7q40MBS7IsBAgdBBfBVwXL6EejP
         28gMeGmbysWbtANF+x8x580Hr3hFaPa77IJrIZbPC2rkRhKm6H/7RGxAN5w4LXPzWShg
         ugHfLw03fkbGQBZY+z8TDYeijfRobCTVI/mHYbF03OgPU4ZTFUuwYLyrAnVaIcno5HTU
         yYYLATU4PvEGUtqHq0Oi+A2J/dItj9bM/8W2hkZuG6ztsVMel3vw8Vrdlxwwps9iArAT
         5hcDA24nRwO1eofqPs8ViqfWyAupDhXN+NqtofzjsBtJMbmI3aCYzsUotmboxSvGrhgg
         Pc/g==
X-Gm-Message-State: AOAM531zXP1nEzqyaEJbStkLb8ePK7QJdhcPZ4bkNOEqJ+EzHhnj/J6I
        fz8DXW/bPGEHG6kRmbHZl9iXbwaDS4T77eFT3bA=
X-Google-Smtp-Source: ABdhPJzlRV77yDbRaiKgY7vl9XxIJzDbo45c/xZZ8RGydjxRmLUfam/9d3P7a2DT8ytJ69GnrXCKionm/ipS3JxU/R8=
X-Received: by 2002:a25:3b4d:: with SMTP id i74mr36213618yba.3.1617636805688;
 Mon, 05 Apr 2021 08:33:25 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 5 Apr 2021 21:03:14 +0530
Message-ID: <CANT5p=qWyYCD_gSw-AzvxOgzTzWkBK1uUz-16YougX5No8jjgQ@mail.gmail.com>
Subject: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
To:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002de70705bf3b6bf3"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000002de70705bf3b6bf3
Content-Type: text/plain; charset="UTF-8"

Hi Steve,

Please consider the attached patch for performing the DNS query again
on reconnect.
This is important when connecting to Azure file shares. The UNC
generally contains the server name as a FQDN, and the IP address which
the name resolves to can change over time.

After our last conversation about this, I discovered that for the
non-DFS scenario, we never do DNS resolutions in cifs.ko, since
mount.cifs already resolves the name and passes the "addr=" arg during
mount.

Hi Paulo,

I noticed that you had a patch for this long back. But I don't see
that call happening in the latest code. Any idea why that was done?

========================
commit 28eb24ff75c5ac130eb326b3b4d0dcecfc0f427d
Author: Paulo Alcantara <paulo@paulo.ac>
Date:   Tue Nov 20 15:16:36 2018 -0200

    cifs: Always resolve hostname before reconnecting

    In case a hostname resolves to a different IP address (e.g. long
    running mounts), make sure to resolve it every time prior to calling
    generic_ip_connect() in reconnect.

    Suggested-by: Steve French <stfrench@microsoft.com>
    Signed-off-by: Paulo Alcantara <palcantara@suse.de>
    Signed-off-by: Steve French <stfrench@microsoft.com>
=========================

-- 
Regards,
Shyam

--0000000000002de70705bf3b6bf3
Content-Type: application/octet-stream; 
	name="0001-cifs-On-cifs_reconnect-resolve-the-hostname-again.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-On-cifs_reconnect-resolve-the-hostname-again.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kn4qvu6q0>
X-Attachment-Id: f_kn4qvu6q0

RnJvbSAyODlmN2YwZmEyMjllYTE4MTA5NDgyMWMzMDlhMmJhOTM1ODc5MWEzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaHlhbSBQcmFzYWQgTiA8c3ByYXNhZEBtaWNyb3NvZnQuY29t
PgpEYXRlOiBXZWQsIDMxIE1hciAyMDIxIDE0OjM1OjI0ICswMDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogT24gY2lmc19yZWNvbm5lY3QsIHJlc29sdmUgdGhlIGhvc3RuYW1lIGFnYWluLgoKT24g
Y2lmc19yZWNvbm5lY3QsIG1ha2Ugc3VyZSB0aGF0IEROUyByZXNvbHV0aW9uIGhhcHBlbnMgYWdh
aW4uCkl0IGNvdWxkIGJlIHRoZSBjYXVzZSBvZiBjb25uZWN0aW9uIHRvIGdvIGRlYWQgaW4gdGhl
IGZpcnN0IHBsYWNlLgoKU2lnbmVkLW9mZi1ieTogU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWlj
cm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8IDE1ICsrKysrKysrKysrKysrKwog
MSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Nv
bm5lY3QuYyBiL2ZzL2NpZnMvY29ubmVjdC5jCmluZGV4IGVlYzhhMjA1MmRhMi4uM2RiMzAwNmJi
YjQ3IDEwMDY0NAotLS0gYS9mcy9jaWZzL2Nvbm5lY3QuYworKysgYi9mcy9jaWZzL2Nvbm5lY3Qu
YwpAQCAtMzIxLDE0ICszMjEsMjkgQEAgY2lmc19yZWNvbm5lY3Qoc3RydWN0IFRDUF9TZXJ2ZXJf
SW5mbyAqc2VydmVyKQogI2VuZGlmCiAKICNpZmRlZiBDT05GSUdfQ0lGU19ERlNfVVBDQUxMCisJ
CWlmIChjaWZzX3NiICYmIGNpZnNfc2ItPm9yaWdpbl9mdWxscGF0aCkKIAkJCS8qCiAJCQkgKiBT
ZXQgdXAgbmV4dCBERlMgdGFyZ2V0IHNlcnZlciAoaWYgYW55KSBmb3IgcmVjb25uZWN0LiBJZiBE
RlMKIAkJCSAqIGZlYXR1cmUgaXMgZGlzYWJsZWQsIHRoZW4gd2Ugd2lsbCByZXRyeSBsYXN0IHNl
cnZlciB3ZQogCQkJICogY29ubmVjdGVkIHRvIGJlZm9yZS4KIAkJCSAqLwogCQkJcmVjb25uX3Nl
dF9uZXh0X2Rmc190YXJnZXQoc2VydmVyLCBjaWZzX3NiLCAmdGd0X2xpc3QsICZ0Z3RfaXQpOwor
CQllbHNlIHsKKyNlbmRpZgorCQkJLyoKKwkJCSAqIFJlc29sdmUgdGhlIGhvc3RuYW1lIGFnYWlu
IHRvIG1ha2Ugc3VyZSB0aGF0IElQIGFkZHJlc3MgaXMgdXAtdG8tZGF0ZS4KKwkJCSAqLworCQkJ
cmMgPSByZWNvbm5fc2V0X2lwYWRkcl9mcm9tX2hvc3RuYW1lKHNlcnZlcik7CisJCQlpZiAocmMp
IHsKKwkJCQljaWZzX2RiZyhGWUksICIlczogZmFpbGVkIHRvIHJlc29sdmUgaG9zdG5hbWU6ICVk
XG4iLAorCQkJCQkJX19mdW5jX18sIHJjKTsKKwkJCX0KKworI2lmZGVmIENPTkZJR19DSUZTX0RG
U19VUENBTEwKKwkJfQogI2VuZGlmCiAKKwogI2lmZGVmIENPTkZJR19DSUZTX1NXTl9VUENBTEwK
IAkJfQogI2VuZGlmCi0tIAoyLjI1LjEKCg==
--0000000000002de70705bf3b6bf3--
