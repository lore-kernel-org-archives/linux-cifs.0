Return-Path: <SRS0=8TPy=V5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70D6C19759
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 18:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EA312080C
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 18:05:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3BEhvXL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731751AbfHASFc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Aug 2019 14:05:32 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:45450 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731642AbfHASFb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Aug 2019 14:05:31 -0400
Received: by mail-pf1-f181.google.com with SMTP id r1so34508440pfq.12
        for <linux-cifs@vger.kernel.org>; Thu, 01 Aug 2019 11:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=8PVvDn0maAZc6h+BgmIISTOgbBMcqChs55h834excoc=;
        b=O3BEhvXLyy5WVCfweklv/hkcP+VfRHQ2aTnL84LS8KPfixInzoLpyTkiL1OT4T+eiA
         XN4ITeDWzp3bZE3OPXHChrCD48rtkdq55G8qCkgfNGeaktCbaAq2+TOt4S/lzLOtsX6+
         9rLVZ3Cd13nxkFTY84VuE65u50r3wbPsoUKW6NHWvz7UOwX4vGeHoIe+LaGHL+lPDPDZ
         WuYsdOnYklgC9olmY6fJedhjjcBmyA8qKeZrZ4T/TEI2nLm21s7OEaS91ojD24tSfAhI
         drhyd3Xj8CBQkmJNPaqI/BRmEBapze+z9VMGWFGKtv5U6wyJS2pv1H+gCcWi71PRNDRF
         9ZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8PVvDn0maAZc6h+BgmIISTOgbBMcqChs55h834excoc=;
        b=YwbnAoXLPcq7eV08IIWH5ImMCghmujYiM5lTONhs4zapBLMij0ASCMs2wrb1G5VuQW
         eMXUbAhQH76C2wDzmDzfpLVEGksWHKl4oJXCZ7mKrDmufYLubTMwdjIBH454dRD6Oxr9
         fH1fZO/rgeWMozKdqENw4JGx9kkUZYM3Nd4gR8IODxGzVaJHJHm44SIb0yzzAtklaiIG
         490OqsST4Y31OYJMBDpWHOy1teTAqKWEC0BJSDQo56OrqPCPwh/3ET9A0ZVnbsCU19w7
         1YPSQhHr9mrlU5UJeFvn16i8peQCOptR0mkg7L9Xl8AtVTRK9Ukla80mcK2l73fnEsie
         u3uw==
X-Gm-Message-State: APjAAAXKK/UYZPQVOC6YKIgnBJaM5N6tBfhFv4SM7RaMwYzejARsayw9
        UFvgZvaE5PMP9R5v2lo/QxBjdZJayaEXtA5dG6lX9lml
X-Google-Smtp-Source: APXvYqxAcFbVBakEmMCwnjhh9I2/CC4OG9QP9qQzFWB2RtzUMDR6T8jj8uFyeKv2FOrB8nLWBfWNixoQP4wzB/RNnNw=
X-Received: by 2002:a63:7245:: with SMTP id c5mr107264130pgn.11.1564682730715;
 Thu, 01 Aug 2019 11:05:30 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 1 Aug 2019 13:05:18 -0500
Message-ID: <CAH2r5mu-4wZ7p4NDyT9k=fdSHfD_fL0tYyNL5mZV2dugWZoXYg@mail.gmail.com>
Subject: [PATCH][WIP] do not ignore error on setinfo for chmod
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000059ecfb058f12166a"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000059ecfb058f12166a
Content-Type: text/plain; charset="UTF-8"

We were incorrectly skipping errors in some cases in cifs_settattr_nounix


-- 
Thanks,

Steve

--00000000000059ecfb058f12166a
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-error-handling-on-chmod.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-error-handling-on-chmod.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jyszoa0q0>
X-Attachment-Id: f_jyszoa0q0

RnJvbSBkODQyMzM4OGUwN2IxNmRjNTA4ZWQ0NTM2Mzc4NzlmNDdiZWJkMWIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMSBBdWcgMjAxOSAxMjoyMToxNCAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIGNp
ZnM6IGZpeCBlcnJvciBoYW5kbGluZyBvbiBjaG1vZAoKV2Ugd2VyZSBpZ25vcmluZyBlcnJvcnMg
b24gY2htb2QgZHVlIHRvIGluY29ycmVjdCBjaGVjayBvZgp3aGljaCBhdHRyaWJ1dGVzIHdlcmUg
YmVpbmcgY2hhbmdlZCAoY2VydGFpbiB0aW1lc3RhbXAgc2V0dGluZwplcnJvcnMgY2FuIGJlIHNh
ZmVseSBpZ25vcmVkIGJ1dCBub3QgY2htb2QpLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNo
IDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvaW5vZGUuYyB8IDE0ICsrKysr
KysrLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvaW5vZGUuYyBiL2ZzL2NpZnMvaW5vZGUuYwppbmRleCAy
NmNkZmJmMWUxNjQuLjI1YTVhZWRkYzA5YSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9pbm9kZS5jCisr
KyBiL2ZzL2NpZnMvaW5vZGUuYwpAQCAtMjU1OSwxMiArMjU1OSwxNCBAQCBjaWZzX3NldGF0dHJf
bm91bml4KHN0cnVjdCBkZW50cnkgKmRpcmVudHJ5LCBzdHJ1Y3QgaWF0dHIgKmF0dHJzKQogCQkv
KiBCQjogY2hlY2sgZm9yIHJjID0gLUVPUE5PVFNVUFAgYW5kIHN3aXRjaCB0byBsZWdhY3kgbW9k
ZSAqLwogCiAJCS8qIEV2ZW4gaWYgZXJyb3Igb24gdGltZSBzZXQsIG5vIHNlbnNlIGZhaWxpbmcg
dGhlIGNhbGwgaWYKLQkJdGhlIHNlcnZlciB3b3VsZCBzZXQgdGhlIHRpbWUgdG8gYSByZWFzb25h
YmxlIHZhbHVlIGFueXdheSwKLQkJYW5kIHRoaXMgY2hlY2sgZW5zdXJlcyB0aGF0IHdlIGFyZSBu
b3QgYmVpbmcgY2FsbGVkIGZyb20KLQkJc3lzX3V0aW1lcyBpbiB3aGljaCBjYXNlIHdlIG91Z2h0
IHRvIGZhaWwgdGhlIGNhbGwgYmFjayB0bwotCQl0aGUgdXNlciB3aGVuIHRoZSBzZXJ2ZXIgcmVq
ZWN0cyB0aGUgY2FsbCAqLwotCQlpZiAoKHJjKSAmJiAoYXR0cnMtPmlhX3ZhbGlkICYKLQkJCQko
QVRUUl9NT0RFIHwgQVRUUl9HSUQgfCBBVFRSX1VJRCB8IEFUVFJfU0laRSkpKQorCQkgKiB0aGUg
c2VydmVyIHdvdWxkIHNldCB0aGUgdGltZSB0byBhIHJlYXNvbmFibGUgdmFsdWUgYW55d2F5Lgor
CQkgKiBUT0RPIGNoZWNrIGlmIGNoZWNrIHRvIGVuc3VyZSB0aGF0IGFyZSBub3QgYmVpbmcgY2Fs
bGVkIGZyb20KKwkJICogc3lzX3V0aW1lcyAoaW4gd2hpY2ggY2FzZSB3ZSBvdWdodCB0byBmYWls
IHRoZSBjYWxsIHdoZW4gdGhlCisJCSAqIHNlcnZlciByZWplY3RzIHRoZSBjYWxsKSBpcyBjb3Jy
ZWN0LiBXZSBkbyB3YW50CisJICAgICAgICAgKiB0byByZXR1cm4gYW4gcmMgaWYgZXJyb3Igc2V0
dGluZyBtb2RlIG9yIG93bmVyIG9yIHNpemUKKwkJICovCisJCWlmIChyYyAmJiAoKGF0dHJzLT5p
YV92YWxpZCAmCisJCSAgICAgIChBVFRSX01PREUgfCBBVFRSX0dJRCB8IEFUVFJfVUlEIHwgQVRU
Ul9TSVpFKSkgPT0gMCkpCiAJCQlyYyA9IDA7CiAJfQogCi0tIAoyLjIwLjEKCg==
--00000000000059ecfb058f12166a--
