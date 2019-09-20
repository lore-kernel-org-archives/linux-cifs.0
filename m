Return-Path: <SRS0=I8uG=XP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB85C49ED7
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 07:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B751520820
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 07:07:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMZqqOKv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390684AbfITHHh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Sep 2019 03:07:37 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:39455 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390630AbfITHHh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Sep 2019 03:07:37 -0400
Received: by mail-io1-f50.google.com with SMTP id a1so13874077ioc.6
        for <linux-cifs@vger.kernel.org>; Fri, 20 Sep 2019 00:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=okJYcSdtFVyAVwO/GO4YqAqofHrbE1eBVlcWVEJegAw=;
        b=eMZqqOKv4wfevbxpa+sdw3ZObLugRtncz6gfUX81PAIpc7WyON0lSLVCtNmy8o69/P
         IYXLj/B8Cwv5GBRX6bE+1mdk6dPaOk3JE++PZKe9X5G0bbNTpMevBI6SGjiZ0f6gcWzZ
         UxWtnS4NsngQBScXyxb9Uh1FE3VkQj5tWNmo+77kLu4nYi9qzmZImnjzt3Z3dcHkiCkO
         aPt2sHZ5sHMJOztMzfmHsMVdREttI+XQ9z4mKTYiOfkB3AAwAUpu+Rv4NEJCET0kj6kN
         F+VBB6nPUb2wo82sFx+IiVoQhLSbO5K0ockxDARTciDkM3c4w06PuhvukgzdMiB+2GCc
         WTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=okJYcSdtFVyAVwO/GO4YqAqofHrbE1eBVlcWVEJegAw=;
        b=gYcAm4Wd/mocqcrCHVnz/aMcBMCJCHtvpM5Vhkk4SGmhuUBgRa1tWQJsBJNnwKggZ0
         FOCk5QJSQoOPdn7v1SFMiOK8vBYeM6iIC07uTwU6DIkWZerkEo7A0bZnPoQSYwiSaber
         78hsJloNq1shEmDDjfrN62X89QvUpQZiEOOATVKaLfBR5ELmUQmreaxQXgu5q6o/wXaX
         GQQOo/56BQGWHmELni6sHierAxwWWK4Xw+zzneEJ9MFqMAuy5ryggXXLHbdeIyZ6ZtOg
         XC/RSJgAt7Br7+TMUrCuUgOA/6J79s0wmrSC6upR13fllzfubS7E1AjwDDURGexne6OJ
         DM2A==
X-Gm-Message-State: APjAAAUOYL+cbYo0y+Eoea//PObzyNd+hhE+G0MuWDg+jj/oBFHQenxP
        4ouR/53KciWixssY6TyrlG/Izdh14jzRpTHJW1I=
X-Google-Smtp-Source: APXvYqwaWnUYhLz/O5M7qwUTJfuDLy/m+SCebXVVZJ5xZfcP7thnewkk9koxIOMwg0y+yEGYUW+gCWu8h+pJUBiCcjY=
X-Received: by 2002:a5d:8e0d:: with SMTP id e13mr5099659iod.3.1568963254367;
 Fri, 20 Sep 2019 00:07:34 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 20 Sep 2019 02:07:22 -0500
Message-ID: <CAH2r5mvcRuSihH58GgrzXTAHuXnQ9a0N-d8AkLLOigQrqincKg@mail.gmail.com>
Subject: [SMB3][PATCH] dump encryption keys to allow wireshark debugging of encrypted
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="00000000000071b6230592f6b96e"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000071b6230592f6b96e
Content-Type: text/plain; charset="UTF-8"

kernel patch updated to check if encryption is enabled

In order to debug certain problems it is important to be able
to decrypt network traces (e.g. wireshark) but to do this we
need to be able to dump out the encryption/decryption keys.
Dumping them to an ioctl is safer than dumping then to dmesg,
(and better than showing all keys in a pseudofile).

Restrict this to root (CAP_SYS_ADMIN), and only for a mount
that this admin has access to.

Sample smbinfo output:
SMB3.0 encryption
Session Id:   0x82d2ec52
Session Key:  a5 6d 81 d0 e c1 ca e1 d8 13 aa 20 e8 f2 cc 71
Server Encryption Key:  1a c3 be ba 3d fc dc 3c e bc 93 9e 50 9e 19 c1
Server Decryption Key:  e0 d4 d9 43 1b a2 1b e3 d8 76 77 49 56 f7 20 88


-- 
Thanks,

Steve

--00000000000071b6230592f6b96e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-allow-decryption-keys-to-be-dumped-by-admin-for.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-allow-decryption-keys-to-be-dumped-by-admin-for.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k0rs6l1l0>
X-Attachment-Id: f_k0rs6l1l0

RnJvbSAzY2VlMmVlYzljMjg0OWJmMTE0OGI1ZDUxYjVlNzE0N2U5N2IwYjU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTkgU2VwIDIwMTkgMDQ6MDA6NTUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBhbGxvdyBkZWNyeXB0aW9uIGtleXMgdG8gYmUgZHVtcGVkIGJ5IGFkbWluIGZvcgogZGVi
dWdnaW5nCgpJbiBvcmRlciB0byBkZWJ1ZyBjZXJ0YWluIHByb2JsZW1zIGl0IGlzIGltcG9ydGFu
dCB0byBiZSBhYmxlCnRvIGRlY3J5cHQgbmV0d29yayB0cmFjZXMgKGUuZy4gd2lyZXNoYXJrKSBi
dXQgdG8gZG8gdGhpcyB3ZQpuZWVkIHRvIGJlIGFibGUgdG8gZHVtcCBvdXQgdGhlIGVuY3J5cHRp
b24vZGVjcnlwdGlvbiBrZXlzLgpEdW1waW5nIHRoZW0gdG8gYW4gaW9jdGwgaXMgc2FmZXIgdGhh
biBkdW1waW5nIHRoZW4gdG8gZG1lc2csCihhbmQgYmV0dGVyIHRoYW4gc2hvd2luZyBhbGwga2V5
cyBpbiBhIHBzZXVkb2ZpbGUpLgoKUmVzdHJpY3QgdGhpcyB0byByb290IChDQVBfU1lTX0FETUlO
KSwgYW5kIG9ubHkgZm9yIGEgbW91bnQKdGhhdCB0aGlzIGFkbWluIGhhcyBhY2Nlc3MgdG8uCgpT
YW1wbGUgc21iaW5mbyBvdXRwdXQ6ClNNQjMuMCBlbmNyeXB0aW9uClNlc3Npb24gSWQ6ICAgMHg4
MmQyZWM1MgpTZXNzaW9uIEtleTogIGE1IDZkIDgxIGQwIGUgYzEgY2EgZTEgZDggMTMgYWEgMjAg
ZTggZjIgY2MgNzEKU2VydmVyIEVuY3J5cHRpb24gS2V5OiAgMWEgYzMgYmUgYmEgM2QgZmMgZGMg
M2MgZSBiYyA5MyA5ZSA1MCA5ZSAxOSBjMQpTZXJ2ZXIgRGVjcnlwdGlvbiBLZXk6ICBlMCBkNCBk
OSA0MyAxYiBhMiAxYiBlMyBkOCA3NiA3NyA0OSA1NiBmNyAyMCA4OAoKUmV2aWV3ZWQtYnk6IEF1
cmVsaWVuIEFwdGVsIDxhYXB0ZWxAc3VzZS5jb20+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5j
aCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNfaW9jdGwuaCB8ICA5
ICsrKysrKysrKwogZnMvY2lmcy9pb2N0bC5jICAgICAgfCAyOSArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9jaWZzX2lvY3RsLmggYi9mcy9jaWZzL2NpZnNfaW9jdGwuaAppbmRleCA2YzNi
ZDA3ODY4ZDcuLjBmMGRjMWMxZmU0MSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzX2lvY3RsLmgK
KysrIGIvZnMvY2lmcy9jaWZzX2lvY3RsLmgKQEAgLTU3LDkgKzU3LDE4IEBAIHN0cnVjdCBzbWJf
cXVlcnlfaW5mbyB7CiAJLyogY2hhciBidWZmZXJbXTsgKi8KIH0gX19wYWNrZWQ7CiAKK3N0cnVj
dCBzbWIzX2tleV9kZWJ1Z19pbmZvIHsKKwlfX3U2NAlTdWlkOworCV9fdTE2CWNpcGhlcl90eXBl
OworCV9fdTgJYXV0aF9rZXlbMTZdOyAvKiBTTUIyX05UTE1WMl9TRVNTS0VZX1NJWkUgKi8KKwlf
X3U4CXNtYjNlbmNyeXB0aW9ua2V5W1NNQjNfU0lHTl9LRVlfU0laRV07CisJX191OAlzbWIzZGVj
cnlwdGlvbmtleVtTTUIzX1NJR05fS0VZX1NJWkVdOworfSBfX3BhY2tlZDsKKwogI2RlZmluZSBD
SUZTX0lPQ1RMX01BR0lDCTB4Q0YKICNkZWZpbmUgQ0lGU19JT0NfQ09QWUNIVU5LX0ZJTEUJX0lP
VyhDSUZTX0lPQ1RMX01BR0lDLCAzLCBpbnQpCiAjZGVmaW5lIENJRlNfSU9DX1NFVF9JTlRFR1JJ
VFkgIF9JTyhDSUZTX0lPQ1RMX01BR0lDLCA0KQogI2RlZmluZSBDSUZTX0lPQ19HRVRfTU5UX0lO
Rk8gX0lPUihDSUZTX0lPQ1RMX01BR0lDLCA1LCBzdHJ1Y3Qgc21iX21udF9mc19pbmZvKQogI2Rl
ZmluZSBDSUZTX0VOVU1FUkFURV9TTkFQU0hPVFMgX0lPUihDSUZTX0lPQ1RMX01BR0lDLCA2LCBz
dHJ1Y3Qgc21iX3NuYXBzaG90X2FycmF5KQogI2RlZmluZSBDSUZTX1FVRVJZX0lORk8gX0lPV1Io
Q0lGU19JT0NUTF9NQUdJQywgNywgc3RydWN0IHNtYl9xdWVyeV9pbmZvKQorI2RlZmluZSBDSUZT
X0RVTVBfS0VZIF9JT1dSKENJRlNfSU9DVExfTUFHSUMsIDgsIHN0cnVjdCBzbWIzX2tleV9kZWJ1
Z19pbmZvKQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9pb2N0bC5jIGIvZnMvY2lmcy9pb2N0bC5jCmlu
ZGV4IDc2ZGRkOThiNjI5OC4uNDhjMjM5MjkzNTBjIDEwMDY0NAotLS0gYS9mcy9jaWZzL2lvY3Rs
LmMKKysrIGIvZnMvY2lmcy9pb2N0bC5jCkBAIC0xNjQsNiArMTY0LDcgQEAgc3RhdGljIGxvbmcg
c21iX21udF9nZXRfZnNpbmZvKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRj
b24sCiBsb25nIGNpZnNfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGVwLCB1bnNpZ25lZCBpbnQgY29t
bWFuZCwgdW5zaWduZWQgbG9uZyBhcmcpCiB7CiAJc3RydWN0IGlub2RlICppbm9kZSA9IGZpbGVf
aW5vZGUoZmlsZXApOworCXN0cnVjdCBzbWIzX2tleV9kZWJ1Z19pbmZvIHBrZXlfaW5mOwogCWlu
dCByYyA9IC1FTk9UVFk7IC8qIHN0cmFuZ2UgZXJyb3IgLSBidXQgdGhlIHByZWNlZGVudCAqLwog
CXVuc2lnbmVkIGludCB4aWQ7CiAJc3RydWN0IGNpZnNGaWxlSW5mbyAqcFNNQkZpbGUgPSBmaWxl
cC0+cHJpdmF0ZV9kYXRhOwpAQCAtMjcwLDYgKzI3MSwzNCBAQCBsb25nIGNpZnNfaW9jdGwoc3Ry
dWN0IGZpbGUgKmZpbGVwLCB1bnNpZ25lZCBpbnQgY29tbWFuZCwgdW5zaWduZWQgbG9uZyBhcmcp
CiAJCQllbHNlCiAJCQkJcmMgPSAtRU9QTk9UU1VQUDsKIAkJCWJyZWFrOworCQljYXNlIENJRlNf
RFVNUF9LRVk6CisJCQljaWZzX2RiZyhWRlMsICJpb2N0bCBkdW1wa2V5XG4iKTsgLyogQkIgUkVN
T1ZFTUUgKi8KKwkJCWlmIChwU01CRmlsZSA9PSBOVUxMKQorCQkJCWJyZWFrOworCQkJaWYgKCFj
YXBhYmxlKENBUF9TWVNfQURNSU4pKSB7CisJCQkJcmMgPSAtRUFDQ0VTOworCQkJCWJyZWFrOwor
CQkJfQorCQkJdGNvbiA9IHRsaW5rX3Rjb24ocFNNQkZpbGUtPnRsaW5rKTsKKwkJCWlmICghc21i
M19lbmNyeXB0aW9uX3JlcXVpcmVkKHRjb24pKSB7CisJCQkJcmMgPSAtRU9QTk9UU1VQUDsKKwkJ
CQlicmVhazsKKwkJCX0KKwkJCXBrZXlfaW5mLmNpcGhlcl90eXBlID0KKwkJCQlsZTE2X3RvX2Nw
dSh0Y29uLT5zZXMtPnNlcnZlci0+Y2lwaGVyX3R5cGUpOworCQkJcGtleV9pbmYuU3VpZCA9IHRj
b24tPnNlcy0+U3VpZDsKKwkJCW1lbWNweShwa2V5X2luZi5hdXRoX2tleSwgdGNvbi0+c2VzLT5h
dXRoX2tleS5yZXNwb25zZSwKKwkJCQkJMTYgLyogU01CMl9OVExNVjJfU0VTU0tFWV9TSVpFICov
KTsKKwkJCW1lbWNweShwa2V5X2luZi5zbWIzZGVjcnlwdGlvbmtleSwKKwkJCSAgICAgIHRjb24t
PnNlcy0+c21iM2RlY3J5cHRpb25rZXksIFNNQjNfU0lHTl9LRVlfU0laRSk7CisJCQltZW1jcHko
cGtleV9pbmYuc21iM2VuY3J5cHRpb25rZXksCisJCQkgICAgICB0Y29uLT5zZXMtPnNtYjNlbmNy
eXB0aW9ua2V5LCBTTUIzX1NJR05fS0VZX1NJWkUpOworCQkJaWYgKGNvcHlfdG9fdXNlcigodm9p
ZCBfX3VzZXIgKilhcmcsICZwa2V5X2luZiwKKwkJCQkJc2l6ZW9mKHN0cnVjdCBzbWIzX2tleV9k
ZWJ1Z19pbmZvKSkpCisJCQkJcmMgPSAtRUZBVUxUOworCQkJZWxzZQorCQkJCXJjID0gMDsKKwkJ
CWJyZWFrOwogCQlkZWZhdWx0OgogCQkJY2lmc19kYmcoRllJLCAidW5zdXBwb3J0ZWQgaW9jdGxc
biIpOwogCQkJYnJlYWs7Ci0tIAoyLjIwLjEKCg==
--00000000000071b6230592f6b96e--
