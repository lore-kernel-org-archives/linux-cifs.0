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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4167DC433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 06:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE26864DA3
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 06:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhBBGQU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Feb 2021 01:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbhBBGQT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Feb 2021 01:16:19 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A2DC061573
        for <linux-cifs@vger.kernel.org>; Mon,  1 Feb 2021 22:15:39 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id v15so19621600ljk.13
        for <linux-cifs@vger.kernel.org>; Mon, 01 Feb 2021 22:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=BTE1iqfSPceS+T0i+0NmWJq2vzQT5uns+yuR1Nzh6SQ=;
        b=Ju5sYp3YeHe5SQNr4FWRLGFSQc2+uy9ohFDYhSemt4I5O6gPZ4zX1xXBMg/PcR+elT
         NImctbpNLLylgD8YKjfkNyecxJcUAW7+aI68Cze5DECZfsi7KERc+2pEcCNKi8dduh1q
         MiEdiUsBWECT0XcLYadxW2w7EHGWXY8PKiLi/p+IgegjklgppxQAT4F60ukKgX329xpL
         9Vne8VMeHjTTznNOq5ICB4dpetVLnRsv+1rtHYBAWjYuZ7i0BH/vZOSNn6a8jpbT//0b
         SjHeiZQom6JoLgwj8NL9uGxbEwwuKlTukZ+Jy1TIuzKoaw6rE9aqaO4ekjbkNWLruSge
         opkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=BTE1iqfSPceS+T0i+0NmWJq2vzQT5uns+yuR1Nzh6SQ=;
        b=gJ/a2kUiOCW1TAwLdpQtsg/kPiMg9BM0/J94MB4FoEJqHth6RrPMTJglNVhAz7Lqa7
         2fkVCVhoQ11NNY9LE46dNszaAD5hzv7yJbcjkDUnMHagsh/+pILAHyg2K6uG6OL1sunx
         LKmJb6Vxb/5mSW6tZF3gZrUaU/2jHwKC9c37TWu93VzBhq4ZXHt/6HvA5Ox4+eFhMGDz
         LyMRfmbxrsWb88ymgBCuHqPUTIp/RT+ZVWbkCm2wdgurLrCveL7bL7ItsalS3EKEXYzD
         fosLS9aknFezeUweEi/WzpKLIkEPPtFGtNkefGCAVhEYku9baYOizDQ4ezIy4Po40Nzx
         +5zg==
X-Gm-Message-State: AOAM533faBluSfdTOC8F3B1HSg0sYKIX0/UiB3S8QyKCPOYkDzakOjY0
        ib7IoQeX57TXdOhJlci9R9WawrHeSCmiHOy/XaYuBLOcfwio0A==
X-Google-Smtp-Source: ABdhPJzMATBFRaKWZIo/xOi0PQfC3P8bS0u9fP29n0ae+m+abdN7qbdNBe+Cld1ak63iERN5dFcyKXpU6HaCkpEycCI=
X-Received: by 2002:a05:651c:14a:: with SMTP id c10mr12212809ljd.272.1612246537251;
 Mon, 01 Feb 2021 22:15:37 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 2 Feb 2021 00:15:26 -0600
Message-ID: <CAH2r5mt7Z2wJTLFp1T0qtsrJb95FPKoffBN9WBM=JAi=HcyiOg@mail.gmail.com>
Subject: PATCH] smb3: include current dialect (SMB3.1.1) when version 3 or
 greater requested on mount
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000024c97405ba546660"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--00000000000024c97405ba546660
Content-Type: text/plain; charset="UTF-8"

SMB3.1.1 is the newest, and preferred dialect, and is included in
the requested dialect list by default (ie if no vers= is specified
on mount) but it should also be requested if SMB3 or later is requested
(vers=3 instead of a specific dialect: vers=2.1, vers=3.02 or vers=3.0).

Currently specifying "vers=3" only requests smb3.0 and smb3.02 but this
patch fixes it to also request smb3.1.1 dialect, as it is the newest
and most secure dialect and is a "version 3 or later" dialect (the intent
of "vers=3").

Signed-off-by: Steve French <stfrench@microsoft.com>
Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/fs_context.c |  2 +-
 fs/cifs/smb2pdu.c    | 19 +++++++++++++------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 5111aadfdb6b..479c24695281 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -391,7 +391,7 @@ cifs_parse_smb_version(char *value, struct
smb3_fs_context *ctx, bool is_smb3)
  ctx->vals = &smb3any_values;
  break;
  case Smb_default:
- ctx->ops = &smb30_operations; /* currently identical with 3.0 */
+ ctx->ops = &smb30_operations;
  ctx->vals = &smbdefault_values;
  break;
  default:
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 794fc3b68b4f..52625549c3b5 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -814,8 +814,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
     SMB3ANY_VERSION_STRING) == 0) {
  req->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
  req->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
- req->DialectCount = cpu_to_le16(2);
- total_len += 4;
+ req->Dialects[2] = cpu_to_le16(SMB311_PROT_ID);
+ req->DialectCount = cpu_to_le16(3);
+ total_len += 6;
  } else if (strcmp(server->vals->version_string,
     SMBDEFAULT_VERSION_STRING) == 0) {
  req->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
@@ -848,6 +849,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
  memcpy(req->ClientGUID, server->client_guid,
  SMB2_CLIENT_GUID_SIZE);
  if ((server->vals->protocol_id == SMB311_PROT_ID) ||
+     (strcmp(server->vals->version_string,
+      SMB3ANY_VERSION_STRING) == 0) ||
      (strcmp(server->vals->version_string,
       SMBDEFAULT_VERSION_STRING) == 0))
  assemble_neg_contexts(req, server, &total_len);
@@ -883,6 +886,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
  cifs_server_dbg(VFS,
  "SMB2.1 dialect returned but not requested\n");
  return -EIO;
+ } else if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID)) {
+ server->ops = &smb311_operations;
+ server->vals = &smb311_values;
  }
  } else if (strcmp(server->vals->version_string,
     SMBDEFAULT_VERSION_STRING) == 0) {
@@ -1042,10 +1048,11 @@ int smb3_validate_negotiate(const unsigned int
xid, struct cifs_tcon *tcon)
  SMB3ANY_VERSION_STRING) == 0) {
  pneg_inbuf->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
  pneg_inbuf->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
- pneg_inbuf->DialectCount = cpu_to_le16(2);
- /* structure is big enough for 3 dialects, sending only 2 */
+ pneg_inbuf->Dialects[2] = cpu_to_le16(SMB311_PROT_ID);
+ pneg_inbuf->DialectCount = cpu_to_le16(3);
+ /* SMB 2.1 not included so subtract one dialect from len */
  inbuflen = sizeof(*pneg_inbuf) -
- (2 * sizeof(pneg_inbuf->Dialects[0]));
+ (sizeof(pneg_inbuf->Dialects[0]));
  } else if (strcmp(server->vals->version_string,
  SMBDEFAULT_VERSION_STRING) == 0) {
  pneg_inbuf->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
@@ -1053,7 +1060,7 @@ int smb3_validate_negotiate(const unsigned int
xid, struct cifs_tcon *tcon)
  pneg_inbuf->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
  pneg_inbuf->Dialects[3] = cpu_to_le16(SMB311_PROT_ID);
  pneg_inbuf->DialectCount = cpu_to_le16(4);
- /* structure is big enough for 3 dialects */
+ /* structure is big enough for 4 dialects */
  inbuflen = sizeof(*pneg_inbuf);
  } else {
  /* otherwise specific dialect was requested */

-- 
Thanks,

Steve

--00000000000024c97405ba546660
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-smb3-negotiate-current-dialect-SMB3.1.1-when-version.patch"
Content-Disposition: attachment; 
	filename="0001-smb3-negotiate-current-dialect-SMB3.1.1-when-version.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kknlxjp90>
X-Attachment-Id: f_kknlxjp90

RnJvbSBlNzA1NWNkY2EwM2VhNTUyMjk5MjM0NWM5MjQ4Y2RiZmVkNWM5ZDZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFR1ZSwgMiBGZWIgMjAyMSAwMDowMzo1OCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIHNt
YjM6IG5lZ290aWF0ZSBjdXJyZW50IGRpYWxlY3QgKFNNQjMuMS4xKSB3aGVuIHZlcnNpb24gMyBv
cgogZ3JlYXRlciByZXF1ZXN0ZWQKClNNQjMuMS4xIGlzIHRoZSBuZXdlc3QsIGFuZCBwcmVmZXJy
ZWQgZGlhbGVjdCwgYW5kIGlzIGluY2x1ZGVkIGluCnRoZSByZXF1ZXN0ZWQgZGlhbGVjdCBsaXN0
IGJ5IGRlZmF1bHQgKGllIGlmIG5vIHZlcnM9IGlzIHNwZWNpZmllZApvbiBtb3VudCkgYnV0IGl0
IHNob3VsZCBhbHNvIGJlIHJlcXVlc3RlZCBpZiBTTUIzIG9yIGxhdGVyIGlzIHJlcXVlc3RlZAoo
dmVycz0zIGluc3RlYWQgb2YgYSBzcGVjaWZpYyBkaWFsZWN0OiB2ZXJzPTIuMSwgdmVycz0zLjAy
IG9yIHZlcnM9My4wKS4KCkN1cnJlbnRseSBzcGVjaWZ5aW5nICJ2ZXJzPTMiIG9ubHkgcmVxdWVz
dHMgc21iMy4wIGFuZCBzbWIzLjAyIGJ1dCB0aGlzCnBhdGNoIGZpeGVzIGl0IHRvIGFsc28gcmVx
dWVzdCBzbWIzLjEuMSBkaWFsZWN0LCBhcyBpdCBpcyB0aGUgbmV3ZXN0CmFuZCBtb3N0IHNlY3Vy
ZSBkaWFsZWN0IGFuZCBpcyBhICJ2ZXJzaW9uIDMgb3IgbGF0ZXIiIGRpYWxlY3QgKHRoZSBpbnRl
bnQKb2YgInZlcnM9MyIgZGlhbGVjdCkuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0
ZnJlbmNoQG1pY3Jvc29mdC5jb20+ClN1Z2dlc3RlZC1ieTogUGF2ZWwgU2hpbG92c2t5IDxwc2hp
bG92QG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9mc19jb250ZXh0LmMgfCAgMiArLQogZnMv
Y2lmcy9zbWIycGR1LmMgICAgfCAxOSArKysrKysrKysrKysrLS0tLS0tCiAyIGZpbGVzIGNoYW5n
ZWQsIDE0IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9mc19jb250ZXh0LmMgYi9mcy9jaWZzL2ZzX2NvbnRleHQuYwppbmRleCA1MTExYWFkZmRiNmIu
LjQ3OWMyNDY5NTI4MSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9mc19jb250ZXh0LmMKKysrIGIvZnMv
Y2lmcy9mc19jb250ZXh0LmMKQEAgLTM5MSw3ICszOTEsNyBAQCBjaWZzX3BhcnNlX3NtYl92ZXJz
aW9uKGNoYXIgKnZhbHVlLCBzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgsIGJvb2wgaXNfc21i
MykKIAkJY3R4LT52YWxzID0gJnNtYjNhbnlfdmFsdWVzOwogCQlicmVhazsKIAljYXNlIFNtYl9k
ZWZhdWx0OgotCQljdHgtPm9wcyA9ICZzbWIzMF9vcGVyYXRpb25zOyAvKiBjdXJyZW50bHkgaWRl
bnRpY2FsIHdpdGggMy4wICovCisJCWN0eC0+b3BzID0gJnNtYjMwX29wZXJhdGlvbnM7CiAJCWN0
eC0+dmFscyA9ICZzbWJkZWZhdWx0X3ZhbHVlczsKIAkJYnJlYWs7CiAJZGVmYXVsdDoKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggNzk0ZmMz
YjY4YjRmLi41MjYyNTU0OWMzYjUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBi
L2ZzL2NpZnMvc21iMnBkdS5jCkBAIC04MTQsOCArODE0LDkgQEAgU01CMl9uZWdvdGlhdGUoY29u
c3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpzZXMpCiAJCSAgIFNNQjNBTllf
VkVSU0lPTl9TVFJJTkcpID09IDApIHsKIAkJcmVxLT5EaWFsZWN0c1swXSA9IGNwdV90b19sZTE2
KFNNQjMwX1BST1RfSUQpOwogCQlyZXEtPkRpYWxlY3RzWzFdID0gY3B1X3RvX2xlMTYoU01CMzAy
X1BST1RfSUQpOwotCQlyZXEtPkRpYWxlY3RDb3VudCA9IGNwdV90b19sZTE2KDIpOwotCQl0b3Rh
bF9sZW4gKz0gNDsKKwkJcmVxLT5EaWFsZWN0c1syXSA9IGNwdV90b19sZTE2KFNNQjMxMV9QUk9U
X0lEKTsKKwkJcmVxLT5EaWFsZWN0Q291bnQgPSBjcHVfdG9fbGUxNigzKTsKKwkJdG90YWxfbGVu
ICs9IDY7CiAJfSBlbHNlIGlmIChzdHJjbXAoc2VydmVyLT52YWxzLT52ZXJzaW9uX3N0cmluZywK
IAkJICAgU01CREVGQVVMVF9WRVJTSU9OX1NUUklORykgPT0gMCkgewogCQlyZXEtPkRpYWxlY3Rz
WzBdID0gY3B1X3RvX2xlMTYoU01CMjFfUFJPVF9JRCk7CkBAIC04NDgsNiArODQ5LDggQEAgU01C
Ml9uZWdvdGlhdGUoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpzZXMp
CiAJCW1lbWNweShyZXEtPkNsaWVudEdVSUQsIHNlcnZlci0+Y2xpZW50X2d1aWQsCiAJCQlTTUIy
X0NMSUVOVF9HVUlEX1NJWkUpOwogCQlpZiAoKHNlcnZlci0+dmFscy0+cHJvdG9jb2xfaWQgPT0g
U01CMzExX1BST1RfSUQpIHx8CisJCSAgICAoc3RyY21wKHNlcnZlci0+dmFscy0+dmVyc2lvbl9z
dHJpbmcsCisJCSAgICAgU01CM0FOWV9WRVJTSU9OX1NUUklORykgPT0gMCkgfHwKIAkJICAgIChz
dHJjbXAoc2VydmVyLT52YWxzLT52ZXJzaW9uX3N0cmluZywKIAkJICAgICBTTUJERUZBVUxUX1ZF
UlNJT05fU1RSSU5HKSA9PSAwKSkKIAkJCWFzc2VtYmxlX25lZ19jb250ZXh0cyhyZXEsIHNlcnZl
ciwgJnRvdGFsX2xlbik7CkBAIC04ODMsNiArODg2LDkgQEAgU01CMl9uZWdvdGlhdGUoY29uc3Qg
dW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpzZXMpCiAJCQljaWZzX3NlcnZlcl9k
YmcoVkZTLAogCQkJCSJTTUIyLjEgZGlhbGVjdCByZXR1cm5lZCBidXQgbm90IHJlcXVlc3RlZFxu
Iik7CiAJCQlyZXR1cm4gLUVJTzsKKwkJfSBlbHNlIGlmIChyc3AtPkRpYWxlY3RSZXZpc2lvbiA9
PSBjcHVfdG9fbGUxNihTTUIzMTFfUFJPVF9JRCkpIHsKKwkJCXNlcnZlci0+b3BzID0gJnNtYjMx
MV9vcGVyYXRpb25zOworCQkJc2VydmVyLT52YWxzID0gJnNtYjMxMV92YWx1ZXM7CiAJCX0KIAl9
IGVsc2UgaWYgKHN0cmNtcChzZXJ2ZXItPnZhbHMtPnZlcnNpb25fc3RyaW5nLAogCQkgICBTTUJE
RUZBVUxUX1ZFUlNJT05fU1RSSU5HKSA9PSAwKSB7CkBAIC0xMDQyLDEwICsxMDQ4LDExIEBAIGlu
dCBzbWIzX3ZhbGlkYXRlX25lZ290aWF0ZShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uKQogCQlTTUIzQU5ZX1ZFUlNJT05fU1RSSU5HKSA9PSAwKSB7CiAJCXBu
ZWdfaW5idWYtPkRpYWxlY3RzWzBdID0gY3B1X3RvX2xlMTYoU01CMzBfUFJPVF9JRCk7CiAJCXBu
ZWdfaW5idWYtPkRpYWxlY3RzWzFdID0gY3B1X3RvX2xlMTYoU01CMzAyX1BST1RfSUQpOwotCQlw
bmVnX2luYnVmLT5EaWFsZWN0Q291bnQgPSBjcHVfdG9fbGUxNigyKTsKLQkJLyogc3RydWN0dXJl
IGlzIGJpZyBlbm91Z2ggZm9yIDMgZGlhbGVjdHMsIHNlbmRpbmcgb25seSAyICovCisJCXBuZWdf
aW5idWYtPkRpYWxlY3RzWzJdID0gY3B1X3RvX2xlMTYoU01CMzExX1BST1RfSUQpOworCQlwbmVn
X2luYnVmLT5EaWFsZWN0Q291bnQgPSBjcHVfdG9fbGUxNigzKTsKKwkJLyogU01CIDIuMSBub3Qg
aW5jbHVkZWQgc28gc3VidHJhY3Qgb25lIGRpYWxlY3QgZnJvbSBsZW4gKi8KIAkJaW5idWZsZW4g
PSBzaXplb2YoKnBuZWdfaW5idWYpIC0KLQkJCQkoMiAqIHNpemVvZihwbmVnX2luYnVmLT5EaWFs
ZWN0c1swXSkpOworCQkJCShzaXplb2YocG5lZ19pbmJ1Zi0+RGlhbGVjdHNbMF0pKTsKIAl9IGVs
c2UgaWYgKHN0cmNtcChzZXJ2ZXItPnZhbHMtPnZlcnNpb25fc3RyaW5nLAogCQlTTUJERUZBVUxU
X1ZFUlNJT05fU1RSSU5HKSA9PSAwKSB7CiAJCXBuZWdfaW5idWYtPkRpYWxlY3RzWzBdID0gY3B1
X3RvX2xlMTYoU01CMjFfUFJPVF9JRCk7CkBAIC0xMDUzLDcgKzEwNjAsNyBAQCBpbnQgc21iM192
YWxpZGF0ZV9uZWdvdGlhdGUoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNv
biAqdGNvbikKIAkJcG5lZ19pbmJ1Zi0+RGlhbGVjdHNbMl0gPSBjcHVfdG9fbGUxNihTTUIzMDJf
UFJPVF9JRCk7CiAJCXBuZWdfaW5idWYtPkRpYWxlY3RzWzNdID0gY3B1X3RvX2xlMTYoU01CMzEx
X1BST1RfSUQpOwogCQlwbmVnX2luYnVmLT5EaWFsZWN0Q291bnQgPSBjcHVfdG9fbGUxNig0KTsK
LQkJLyogc3RydWN0dXJlIGlzIGJpZyBlbm91Z2ggZm9yIDMgZGlhbGVjdHMgKi8KKwkJLyogc3Ry
dWN0dXJlIGlzIGJpZyBlbm91Z2ggZm9yIDQgZGlhbGVjdHMgKi8KIAkJaW5idWZsZW4gPSBzaXpl
b2YoKnBuZWdfaW5idWYpOwogCX0gZWxzZSB7CiAJCS8qIG90aGVyd2lzZSBzcGVjaWZpYyBkaWFs
ZWN0IHdhcyByZXF1ZXN0ZWQgKi8KLS0gCjIuMjcuMAoK
--00000000000024c97405ba546660--
