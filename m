Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE23C433E0
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Mar 2021 02:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5DBA64FED
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Mar 2021 02:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCECYv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCECYv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Mar 2021 21:24:51 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8317C061574
        for <linux-cifs@vger.kernel.org>; Thu,  4 Mar 2021 18:24:50 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id p15so801230ljc.13
        for <linux-cifs@vger.kernel.org>; Thu, 04 Mar 2021 18:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=izqGTB5AQoglP4QvVy6KVIwtE++VulsPi9zMDQrAZXc=;
        b=DwdUfk6C978mzNJQSynA/LTfTsZC8WJFz72mL8nVsU3S1Mp48/Vkg6DphxWvrkgRxb
         sbB/qQU+139Xvgaw02vVFMrVyPoPbTr2pO53ZhItzHHOt3IHmd47ksgH70j42HF1x6zE
         /2blqPEJOSUNzJbtH+mlAWOhUMFEV97TccJTnVx+9zKUIKlMFQiKWN+QtO4pXBD+jZsq
         DdLMDgHsm4xiNIVfN7NbwRVIFKwUhty+5jBPv+38+Jy//MW2dwqKUEgjpLrKMHjHE98/
         /AsFHU0E8QARe+9yPWl5esMPPMjw/SxLzEJw/f5majykwjjiyEEFWeikSR6QK209GbAA
         pyFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=izqGTB5AQoglP4QvVy6KVIwtE++VulsPi9zMDQrAZXc=;
        b=f06vZj2KPHmk1yhEYVpkF/GXJRWa1zO7JLuOnbe1LZ53h8tyVfEDiMgyraazqJeCkr
         ygWWeE5Rnp5w1Q8FF20h2I3V9F3s8K1bA4KuYjIgPeRu37+rENNG9iDbV40wk+9PyJ9t
         j3rnKyus1Ro0MhhFpyd/37anKv4QqlHCEWeZI69T7XIQ0nw/VkvYsqY6SDoBCIhNETnv
         XU0TMdrQm9QsPv8YJlvZhuF3ZYap6aGRlsjiFrJjR+lnF/LJF2W6w8oT8k1mT9a5KgKT
         BWyZ83iZqsG5ncd45V6/asW4vG4KummuIVpDUgK0VP4IZJcMqvtzWecduU3KmeO3/CUj
         tSGg==
X-Gm-Message-State: AOAM5334vbovK9oPOb63cyzqpI9D4eD4QZS61d/i/IX0JQNJJWVBbTLr
        csgLl29XaozkhVrRsNgae46VsiwREzP7L2lYRVvchslG4mx8IQ==
X-Google-Smtp-Source: ABdhPJzWREoQY3UDh4QIIBj0YizdU9pTF8v4rZaYUl9l665cKp1soQK0vdF/CYPn8h2+FxAlPkwBn3LwexDQiUe+Cx8=
X-Received: by 2002:a19:3f04:: with SMTP id m4mr3898973lfa.395.1614911089227;
 Thu, 04 Mar 2021 18:24:49 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 4 Mar 2021 20:24:38 -0600
Message-ID: <CAH2r5ms1F5SVh72rKYiSr5TKgG4yv1Bmj6Azdki5BQohcJmhSw@mail.gmail.com>
Subject: [PATCH] cifs: ask for more credit on async read/write code paths
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: multipart/mixed; boundary="000000000000d150cd05bcc0c9b7"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000d150cd05bcc0c9b7
Content-Type: text/plain; charset="UTF-8"

When doing a large read or write workload we only
very gradually increase the number of credits
which can cause problems with parallelizing large i/o
(I/O ramps up more slowly than it should for large
read/write workloads) especially with multichannel
when the number of credits on the secondary channels
starts out low (e.g. less than about 130) or when
recovering after server throttled back the number
of credit.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2pdu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 4bbb6126b14d..2199a9bfae8f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4041,8 +4041,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
  if (rdata->credits.value > 0) {
  shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
  SMB2_MAX_BUFFER_SIZE));
- shdr->CreditRequest =
- cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 1);
+ shdr->CreditRequest = cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 8);

  rc = adjust_credits(server, &rdata->credits, rdata->bytes);
  if (rc)
@@ -4348,8 +4347,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
  if (wdata->credits.value > 0) {
  shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->bytes,
      SMB2_MAX_BUFFER_SIZE));
- shdr->CreditRequest =
- cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 1);
+ shdr->CreditRequest = cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 8);

  rc = adjust_credits(server, &wdata->credits, wdata->bytes);
  if (rc)

-- 
Thanks,

Steve

--000000000000d150cd05bcc0c9b7
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-ask-for-more-credit-on-async-read-write-code-pa.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-ask-for-more-credit-on-async-read-write-code-pa.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_klvoctzi0>
X-Attachment-Id: f_klvoctzi0

RnJvbSA5MDg0ZWY4ZmY5ZmEyNDAyOWY0OGE5NDlmZjE3M2ZmMGI3NDc5MTEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBdXJlbGllbiBBcHRlbCA8YWFwdGVsQHN1c2UuY29tPgpEYXRl
OiBUaHUsIDQgTWFyIDIwMjEgMTc6NTE6NDggKzAwMDAKU3ViamVjdDogW1BBVENIXSBjaWZzOiBh
c2sgZm9yIG1vcmUgY3JlZGl0IG9uIGFzeW5jIHJlYWQvd3JpdGUgY29kZSBwYXRocwoKV2hlbiBk
b2luZyBhIGxhcmdlIHJlYWQgb3Igd3JpdGUgd29ya2xvYWQgd2Ugb25seQp2ZXJ5IGdyYWR1YWxs
eSBpbmNyZWFzZSB0aGUgbnVtYmVyIG9mIGNyZWRpdHMKd2hpY2ggY2FuIGNhdXNlIHByb2JsZW1z
IHdpdGggcGFyYWxsZWxpemluZyBsYXJnZSBpL28KKEkvTyByYW1wcyB1cCBtb3JlIHNsb3dseSB0
aGFuIGl0IHNob3VsZCBmb3IgbGFyZ2UKcmVhZC93cml0ZSB3b3JrbG9hZHMpIGVzcGVjaWFsbHkg
d2l0aCBtdWx0aWNoYW5uZWwKd2hlbiB0aGUgbnVtYmVyIG9mIGNyZWRpdHMgb24gdGhlIHNlY29u
ZGFyeSBjaGFubmVscwpzdGFydHMgb3V0IGxvdyAoZS5nLiBsZXNzIHRoYW4gYWJvdXQgMTMwKSBv
ciB3aGVuCnJlY292ZXJpbmcgYWZ0ZXIgc2VydmVyIHRocm90dGxlZCBiYWNrIHRoZSBudW1iZXIK
b2YgY3JlZGl0LgoKU2lnbmVkLW9mZi1ieTogQXVyZWxpZW4gQXB0ZWwgPGFhcHRlbEBzdXNlLmNv
bT4KUmV2aWV3ZWQtYnk6IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jvc29mdC5jb20+ClNp
Z25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBm
cy9jaWZzL3NtYjJwZHUuYyB8IDYgKystLS0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMv
Y2lmcy9zbWIycGR1LmMKaW5kZXggNGJiYjYxMjZiMTRkLi4yMTk5YTliZmFlOGYgMTAwNjQ0Ci0t
LSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC00MDQxLDgg
KzQwNDEsNyBAQCBzbWIyX2FzeW5jX3JlYWR2KHN0cnVjdCBjaWZzX3JlYWRkYXRhICpyZGF0YSkK
IAlpZiAocmRhdGEtPmNyZWRpdHMudmFsdWUgPiAwKSB7CiAJCXNoZHItPkNyZWRpdENoYXJnZSA9
IGNwdV90b19sZTE2KERJVl9ST1VORF9VUChyZGF0YS0+Ynl0ZXMsCiAJCQkJCQlTTUIyX01BWF9C
VUZGRVJfU0laRSkpOwotCQlzaGRyLT5DcmVkaXRSZXF1ZXN0ID0KLQkJCWNwdV90b19sZTE2KGxl
MTZfdG9fY3B1KHNoZHItPkNyZWRpdENoYXJnZSkgKyAxKTsKKwkJc2hkci0+Q3JlZGl0UmVxdWVz
dCA9IGNwdV90b19sZTE2KGxlMTZfdG9fY3B1KHNoZHItPkNyZWRpdENoYXJnZSkgKyA4KTsKIAog
CQlyYyA9IGFkanVzdF9jcmVkaXRzKHNlcnZlciwgJnJkYXRhLT5jcmVkaXRzLCByZGF0YS0+Ynl0
ZXMpOwogCQlpZiAocmMpCkBAIC00MzQ4LDggKzQzNDcsNyBAQCBzbWIyX2FzeW5jX3dyaXRldihz
dHJ1Y3QgY2lmc193cml0ZWRhdGEgKndkYXRhLAogCWlmICh3ZGF0YS0+Y3JlZGl0cy52YWx1ZSA+
IDApIHsKIAkJc2hkci0+Q3JlZGl0Q2hhcmdlID0gY3B1X3RvX2xlMTYoRElWX1JPVU5EX1VQKHdk
YXRhLT5ieXRlcywKIAkJCQkJCSAgICBTTUIyX01BWF9CVUZGRVJfU0laRSkpOwotCQlzaGRyLT5D
cmVkaXRSZXF1ZXN0ID0KLQkJCWNwdV90b19sZTE2KGxlMTZfdG9fY3B1KHNoZHItPkNyZWRpdENo
YXJnZSkgKyAxKTsKKwkJc2hkci0+Q3JlZGl0UmVxdWVzdCA9IGNwdV90b19sZTE2KGxlMTZfdG9f
Y3B1KHNoZHItPkNyZWRpdENoYXJnZSkgKyA4KTsKIAogCQlyYyA9IGFkanVzdF9jcmVkaXRzKHNl
cnZlciwgJndkYXRhLT5jcmVkaXRzLCB3ZGF0YS0+Ynl0ZXMpOwogCQlpZiAocmMpCi0tIAoyLjI3
LjAKCg==
--000000000000d150cd05bcc0c9b7--
