Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AE5C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 04:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4BB122D75
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 04:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbgLJEZw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Dec 2020 23:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730690AbgLJEZw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Dec 2020 23:25:52 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED605C0613CF
        for <linux-cifs@vger.kernel.org>; Wed,  9 Dec 2020 20:25:11 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id e7so5149718ljg.10
        for <linux-cifs@vger.kernel.org>; Wed, 09 Dec 2020 20:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=EW3U4rPrzuQGPXivcqy8DGChmgwOBiRWZOVFUA5QpsE=;
        b=ABBJstYqecl5lal8BXiY0VOxDkOBA672+dUG/ni5Rfrn2MdCbHWjrHemmdFPUXE+7P
         NWVXzgkJRcK1NXax22t1Tl/pevQKOuqyvaJ+zgACouJ8slsXVlMOrsWkqNSnHZnoiHr+
         XV9d0d1faQeEwBHNsLb3EkOM6BnH8Vx6/lalSDqr/jIRJ6orypL9XDy2+Bz6CyZQ4XiA
         xffdLPRFVkmBtwexBlGp/zCz95WJs0GNTm+1MrdhC10vnZStM9lHssJw7ZB+tsxkUO6Q
         Q8L48/B+h1kRSePNktZ6U0KSEGPUpY9DsIx5vPseStya/kL5JPUxhbfFY3B3P1U+rOj6
         QB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=EW3U4rPrzuQGPXivcqy8DGChmgwOBiRWZOVFUA5QpsE=;
        b=R0JR/xu223edVL4xIvgGmDgIpWzAbLw1IRt1ej4RMvxaE0X1tMWC+vKCPYUP0ujBca
         6IGhMB8qiz38nAaHoYEF0uXwXbs+JJf0vM1TiwU54u7Ax72wLpVLaHGTf7l1DbxfqX0n
         xPZHQL4/NuFIwPe4Z8uW/NZLgT81DRlM79MJUHwKo6v/TFr/mhq/q4Vfqgi+AmZ9FDbJ
         hNEdxGUNBBjWMul5MuNrRqIR9INPAbg0u5ZkJOCGag366Fnxi4/ksncuKhJOCmQmpyxh
         cVBBb8nQJxjPXK5VAcofCMjSQJEnzObcgkUtj9+lyPx6OOZnUkYK25CIFyBCJVRtDgFG
         rqew==
X-Gm-Message-State: AOAM530EkkvRJtcNmEh4eiRe7HAidDFb2oaEKiGRduNqD/tyYN5Le/Jl
        45D5qhSm3vH/WNpa6hhZ5RDm5LhyYAI5WouwZ/UDiSNxP4P61A==
X-Google-Smtp-Source: ABdhPJy9iU4SL1btMnbKdkQQ3DJHpsf2PO2S26wKD9Xz38uBsDSjOsNMHNpZrsYfoOlLHnGKW45Gu1KmGsml3JQHfOk=
X-Received: by 2002:a2e:88c8:: with SMTP id a8mr2236648ljk.148.1607574309925;
 Wed, 09 Dec 2020 20:25:09 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 9 Dec 2020 22:24:58 -0600
Message-ID: <CAH2r5mvdtdzFBMTUCk6DwK1zHW-fP-G9k3DpchD2bqnboooq8g@mail.gmail.com>
Subject: [PATCH] SMB3.1.1: do not log warning message if server doesn't
 populate salt
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Tom Talpey <ttalpey@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000b18c9305b6148f1e"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000b18c9305b6148f1e
Content-Type: text/plain; charset="UTF-8"

In the negotiate protocol preauth context, the server is not required
to populate the salt (although it is recommended, and done by most
servers) so do not warn on mount if the salt is not 32 bytes, but
instead simply check that the preauth context is the minimum size
and that the salt would not overflow the buffer length.

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2pdu.c |  7 +++++--
 fs/cifs/smb2pdu.h | 14 +++++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index acb72705062d..8d572dcf330a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -427,8 +427,8 @@ build_preauth_ctxt(struct smb2_preauth_neg_context
*pneg_ctxt)
  pneg_ctxt->ContextType = SMB2_PREAUTH_INTEGRITY_CAPABILITIES;
  pneg_ctxt->DataLength = cpu_to_le16(38);
  pneg_ctxt->HashAlgorithmCount = cpu_to_le16(1);
- pneg_ctxt->SaltLength = cpu_to_le16(SMB311_SALT_SIZE);
- get_random_bytes(pneg_ctxt->Salt, SMB311_SALT_SIZE);
+ pneg_ctxt->SaltLength = cpu_to_le16(SMB311_CLIENT_SALT_SIZE);
+ get_random_bytes(pneg_ctxt->Salt, SMB311_CLIENT_SALT_SIZE);
  pneg_ctxt->HashAlgorithms = SMB2_PREAUTH_INTEGRITY_SHA512;
 }

@@ -566,6 +566,9 @@ static void decode_preauth_context(struct
smb2_preauth_neg_context *ctxt)
  if (len < MIN_PREAUTH_CTXT_DATA_LEN) {
  pr_warn_once("server sent bad preauth context\n");
  return;
+ } else if (len < MIN_PREAUTH_CTXT_DATA_LEN + le16_to_cpu(ctxt->SaltLength)) {
+ pr_warn_once("server sent invalid SaltLength\n");
+ return;
  }
  if (le16_to_cpu(ctxt->HashAlgorithmCount) != 1)
  pr_warn_once("Invalid SMB3 hash algorithm count\n");
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index fa57b03ca98c..de3127a6fc34 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -333,12 +333,20 @@ struct smb2_neg_context {
  /* Followed by array of data */
 } __packed;

-#define SMB311_SALT_SIZE 32
+#define SMB311_CLIENT_SALT_SIZE 32
 /* Hash Algorithm Types */
 #define SMB2_PREAUTH_INTEGRITY_SHA512 cpu_to_le16(0x0001)
 #define SMB2_PREAUTH_HASH_SIZE 64

-#define MIN_PREAUTH_CTXT_DATA_LEN (SMB311_SALT_SIZE + 6)
+/*
+ * SaltLength that the server send can be zero, so the only three required
+ * fields (all __le16) end up six bytes total, so the minimum context data len
+ * in the response is six.
+ * The three required are: HashAlgorithmCount, SaltLength, and 1 HashAlgorithm
+ * Although most servers send a SaltLength of 32 bytes, technically it is
+ * optional.
+ */
+#define MIN_PREAUTH_CTXT_DATA_LEN 6
 struct smb2_preauth_neg_context {
  __le16 ContextType; /* 1 */
  __le16 DataLength;
@@ -346,7 +354,7 @@ struct smb2_preauth_neg_context {
  __le16 HashAlgorithmCount; /* 1 */
  __le16 SaltLength;
  __le16 HashAlgorithms; /* HashAlgorithms[0] since only one defined */
- __u8 Salt[SMB311_SALT_SIZE];
+ __u8 Salt[SMB311_CLIENT_SALT_SIZE];
 } __packed;

 /* Encryption Algorithms Ciphers */


-- 
Thanks,

Steve

--000000000000b18c9305b6148f1e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3.1.1-do-not-log-warning-message-if-server-doesn-.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3.1.1-do-not-log-warning-message-if-server-doesn-.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kiic88260>
X-Attachment-Id: f_kiic88260

RnJvbSA2N2E4NmY4ZDIwYTBiZGI4YTM4MzJhZmY3OTEzN2NiZDI5ZjM5OGU3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgOSBEZWMgMjAyMCAyMjoxOTowMCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjMuMS4xOiBkbyBub3QgbG9nIHdhcm5pbmcgbWVzc2FnZSBpZiBzZXJ2ZXIgZG9lc24ndAogcG9w
dWxhdGUgc2FsdAoKSW4gdGhlIG5lZ290aWF0ZSBwcm90b2NvbCBwcmVhdXRoIGNvbnRleHQsIHRo
ZSBzZXJ2ZXIgaXMgbm90IHJlcXVpcmVkCnRvIHBvcHVsYXRlIHRoZSBzYWx0IChhbHRob3VnaCBp
dCBpcyByZWNvbW1lbmRlZCwgYW5kIGRvbmUgYnkgbW9zdApzZXJ2ZXJzKSBzbyBkbyBub3Qgd2Fy
biBvbiBtb3VudCBpZiB0aGUgc2FsdCBpcyBub3QgMzIgYnl0ZXMsIGJ1dAppbnN0ZWFkIHNpbXBs
eSBjaGVjayB0aGF0IHRoZSBwcmVhdXRoIGNvbnRleHQgaXMgdGhlIG1pbmltdW0gc2l6ZQphbmQg
dGhhdCB0aGUgc2FsdCB3b3VsZCBub3Qgb3ZlcmZsb3cgdGhlIGJ1ZmZlciBsZW5ndGguCgpDQzog
U3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVu
Y2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9zbWIycGR1LmMgfCAgNyAr
KysrKy0tCiBmcy9jaWZzL3NtYjJwZHUuaCB8IDE0ICsrKysrKysrKysrLS0tCiAyIGZpbGVzIGNo
YW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMv
Y2lmcy9zbWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCBhY2I3MjcwNTA2MmQuLjhk
NTcyZGNmMzMwYSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lmcy9z
bWIycGR1LmMKQEAgLTQyNyw4ICs0MjcsOCBAQCBidWlsZF9wcmVhdXRoX2N0eHQoc3RydWN0IHNt
YjJfcHJlYXV0aF9uZWdfY29udGV4dCAqcG5lZ19jdHh0KQogCXBuZWdfY3R4dC0+Q29udGV4dFR5
cGUgPSBTTUIyX1BSRUFVVEhfSU5URUdSSVRZX0NBUEFCSUxJVElFUzsKIAlwbmVnX2N0eHQtPkRh
dGFMZW5ndGggPSBjcHVfdG9fbGUxNigzOCk7CiAJcG5lZ19jdHh0LT5IYXNoQWxnb3JpdGhtQ291
bnQgPSBjcHVfdG9fbGUxNigxKTsKLQlwbmVnX2N0eHQtPlNhbHRMZW5ndGggPSBjcHVfdG9fbGUx
NihTTUIzMTFfU0FMVF9TSVpFKTsKLQlnZXRfcmFuZG9tX2J5dGVzKHBuZWdfY3R4dC0+U2FsdCwg
U01CMzExX1NBTFRfU0laRSk7CisJcG5lZ19jdHh0LT5TYWx0TGVuZ3RoID0gY3B1X3RvX2xlMTYo
U01CMzExX0NMSUVOVF9TQUxUX1NJWkUpOworCWdldF9yYW5kb21fYnl0ZXMocG5lZ19jdHh0LT5T
YWx0LCBTTUIzMTFfQ0xJRU5UX1NBTFRfU0laRSk7CiAJcG5lZ19jdHh0LT5IYXNoQWxnb3JpdGht
cyA9IFNNQjJfUFJFQVVUSF9JTlRFR1JJVFlfU0hBNTEyOwogfQogCkBAIC01NjYsNiArNTY2LDkg
QEAgc3RhdGljIHZvaWQgZGVjb2RlX3ByZWF1dGhfY29udGV4dChzdHJ1Y3Qgc21iMl9wcmVhdXRo
X25lZ19jb250ZXh0ICpjdHh0KQogCWlmIChsZW4gPCBNSU5fUFJFQVVUSF9DVFhUX0RBVEFfTEVO
KSB7CiAJCXByX3dhcm5fb25jZSgic2VydmVyIHNlbnQgYmFkIHByZWF1dGggY29udGV4dFxuIik7
CiAJCXJldHVybjsKKwl9IGVsc2UgaWYgKGxlbiA8IE1JTl9QUkVBVVRIX0NUWFRfREFUQV9MRU4g
KyBsZTE2X3RvX2NwdShjdHh0LT5TYWx0TGVuZ3RoKSkgeworCQlwcl93YXJuX29uY2UoInNlcnZl
ciBzZW50IGludmFsaWQgU2FsdExlbmd0aFxuIik7CisJCXJldHVybjsKIAl9CiAJaWYgKGxlMTZf
dG9fY3B1KGN0eHQtPkhhc2hBbGdvcml0aG1Db3VudCkgIT0gMSkKIAkJcHJfd2Fybl9vbmNlKCJJ
bnZhbGlkIFNNQjMgaGFzaCBhbGdvcml0aG0gY291bnRcbiIpOwpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9zbWIycGR1LmggYi9mcy9jaWZzL3NtYjJwZHUuaAppbmRleCBmYTU3YjAzY2E5OGMuLmRlMzEy
N2E2ZmMzNCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmgKKysrIGIvZnMvY2lmcy9zbWIy
cGR1LmgKQEAgLTMzMywxMiArMzMzLDIwIEBAIHN0cnVjdCBzbWIyX25lZ19jb250ZXh0IHsKIAkv
KiBGb2xsb3dlZCBieSBhcnJheSBvZiBkYXRhICovCiB9IF9fcGFja2VkOwogCi0jZGVmaW5lIFNN
QjMxMV9TQUxUX1NJWkUJCQkzMgorI2RlZmluZSBTTUIzMTFfQ0xJRU5UX1NBTFRfU0laRQkJCTMy
CiAvKiBIYXNoIEFsZ29yaXRobSBUeXBlcyAqLwogI2RlZmluZSBTTUIyX1BSRUFVVEhfSU5URUdS
SVRZX1NIQTUxMgljcHVfdG9fbGUxNigweDAwMDEpCiAjZGVmaW5lIFNNQjJfUFJFQVVUSF9IQVNI
X1NJWkUgNjQKIAotI2RlZmluZSBNSU5fUFJFQVVUSF9DVFhUX0RBVEFfTEVOCShTTUIzMTFfU0FM
VF9TSVpFICsgNikKKy8qCisgKiBTYWx0TGVuZ3RoIHRoYXQgdGhlIHNlcnZlciBzZW5kIGNhbiBi
ZSB6ZXJvLCBzbyB0aGUgb25seSB0aHJlZSByZXF1aXJlZAorICogZmllbGRzIChhbGwgX19sZTE2
KSBlbmQgdXAgc2l4IGJ5dGVzIHRvdGFsLCBzbyB0aGUgbWluaW11bSBjb250ZXh0IGRhdGEgbGVu
CisgKiBpbiB0aGUgcmVzcG9uc2UgaXMgc2l4LgorICogVGhlIHRocmVlIHJlcXVpcmVkIGFyZTog
SGFzaEFsZ29yaXRobUNvdW50LCBTYWx0TGVuZ3RoLCBhbmQgMSBIYXNoQWxnb3JpdGhtCisgKiBB
bHRob3VnaCBtb3N0IHNlcnZlcnMgc2VuZCBhIFNhbHRMZW5ndGggb2YgMzIgYnl0ZXMsIHRlY2hu
aWNhbGx5IGl0IGlzCisgKiBvcHRpb25hbC4KKyAqLworI2RlZmluZSBNSU5fUFJFQVVUSF9DVFhU
X0RBVEFfTEVOIDYKIHN0cnVjdCBzbWIyX3ByZWF1dGhfbmVnX2NvbnRleHQgewogCV9fbGUxNglD
b250ZXh0VHlwZTsgLyogMSAqLwogCV9fbGUxNglEYXRhTGVuZ3RoOwpAQCAtMzQ2LDcgKzM1NCw3
IEBAIHN0cnVjdCBzbWIyX3ByZWF1dGhfbmVnX2NvbnRleHQgewogCV9fbGUxNglIYXNoQWxnb3Jp
dGhtQ291bnQ7IC8qIDEgKi8KIAlfX2xlMTYJU2FsdExlbmd0aDsKIAlfX2xlMTYJSGFzaEFsZ29y
aXRobXM7IC8qIEhhc2hBbGdvcml0aG1zWzBdIHNpbmNlIG9ubHkgb25lIGRlZmluZWQgKi8KLQlf
X3U4CVNhbHRbU01CMzExX1NBTFRfU0laRV07CisJX191OAlTYWx0W1NNQjMxMV9DTElFTlRfU0FM
VF9TSVpFXTsKIH0gX19wYWNrZWQ7CiAKIC8qIEVuY3J5cHRpb24gQWxnb3JpdGhtcyBDaXBoZXJz
ICovCi0tIAoyLjI3LjAKCg==
--000000000000b18c9305b6148f1e--
