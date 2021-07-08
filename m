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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1701DC07E95
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 02:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF92E61C42
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 02:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhGHCrE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 22:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhGHCrE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jul 2021 22:47:04 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00109C061574
        for <linux-cifs@vger.kernel.org>; Wed,  7 Jul 2021 19:44:21 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id p16so10357618lfc.5
        for <linux-cifs@vger.kernel.org>; Wed, 07 Jul 2021 19:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=jXs3aORg7rmthPi+5Yx1DZYrmJorNfyHJ6x1lEy1HOE=;
        b=uL7uftIPCr8i3Ahu9NkLZwTJ7c/Dk+HrSsbElqsyDWD2vpBFONtnvQYNcSf+d3JYOw
         7a1EmDFlpiem+1Em4GbtVlEUtotLEt1WUxDFmGZylP32FDuaXvD6QzUv6Sfth+UDtJn2
         KW36Waza3bENkEn4RcnpDjM0eWKvGBoSwF74srIV5SrM0NQfM8eTNj2RsK99ZQraY7s9
         uPM7HixmroEdfFAxBx9zHk3gLe+LxXMxxvIIT6eCqcmrh6eJItsC0Tz4q6OJDR/NpBIv
         Ze3KiNewcLMJUPEyhXDiBgZCqt3KSrQ/Nn8zrUPGb/s4z0/hVyIVk0PGt8g2m+ymSAxG
         Un+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=jXs3aORg7rmthPi+5Yx1DZYrmJorNfyHJ6x1lEy1HOE=;
        b=oCPsB03CLH0EbclPGLDlgKJFShrFwPSMj8dCSOcv5w/uMLVtdsKDzSiS9J2lPjr0PU
         ZytpblvxPHIguecYNH8Htcis6BPAdjouDkxI3KMZ95chBpt3bGIYDnYeEkfD49y6Iwyf
         +yQKx/U8EJ+65pSHik4OfzhrRlugkPNLwiOw3FDDOqBSEX8L6T0KSIqvz43aQUnhYe0V
         pzWGDeJo72QTYvfPyO6qhqLeKzXeVD5iBEWjmfVB6PDpgs7+xaBc2uR1yOxt0GxyxZcD
         gd/LMYi6gbAR5jLPI37vn1xyiFeBRFPm1OjiwP3E/4wjOB2mi3ne2ZA2Z1bYpNW7jdmu
         ZAGQ==
X-Gm-Message-State: AOAM533IJqiXEYCmV6Iza7WzUOMZkiMe0tWLhBzSv3/E/wG3ZYYkhXRG
        kdCMihrZT8vFq6ZTUZrN1+gDZ/dQ+XgykVT6ig/McjO67HM=
X-Google-Smtp-Source: ABdhPJxnfga2WmJsHnGr1N2YCO+o4gas6rkNHcy17fOaYUiizkcHS7lOV9JOWt4vXDZ86oCmMsJ4caN9c1pgAGJoZ5Q=
X-Received: by 2002:a19:5043:: with SMTP id z3mr20522212lfj.282.1625712259761;
 Wed, 07 Jul 2021 19:44:19 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 7 Jul 2021 21:44:06 -0500
Message-ID: <CAH2r5mvS6aHG8dXBre0RuGPzUb0g1hh-OPnhEup9PrX5z0zv5g@mail.gmail.com>
Subject: [PATCH][SMB3.1.1] add ability to send signing negotiate context
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000c01b6705c693a13d"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000c01b6705c693a13d
Content-Type: text/plain; charset="UTF-8"

Support for faster packet signing (using GMAC instead of CMAC) can
now be negotiated to some newer servers, including Windows.
See MS-SMB2 section 2.2.3.17.

This patch adds support for sending the new negotiate context
with the first of three supported signing algorithms (AES-CMAC)
and decoding the response.  A followon patch will add support
for sending the other two (including AES-GMAC, which is fastest)
and changing the signing algorithm used based on what was
negotiated.

To allow the client to request GMAC signing set module parameter
"enable_negotiate_signing" to 1.

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifsfs.c   |  4 +++
 fs/cifs/cifsglob.h |  3 ++
 fs/cifs/smb2pdu.c  | 83 ++++++++++++++++++++++++++++++++++++++++------
 fs/cifs/smb2pdu.h  |  5 ++-
 4 files changed, 84 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 9fb874dd8d24..476b07213fcd 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -65,6 +65,7 @@ bool lookupCacheEnabled = true;
 bool disable_legacy_dialects; /* false by default */
 bool enable_gcm_256 = true;
 bool require_gcm_256; /* false by default */
+bool enable_negotiate_signing; /* false by default */
 unsigned int global_secflags = CIFSSEC_DEF;
 /* unsigned int ntlmv2_support = 0; */
 unsigned int sign_CIFS_PDUs = 1;
@@ -104,6 +105,9 @@ MODULE_PARM_DESC(enable_gcm_256, "Enable
requesting strongest (256 bit) GCM encr
 module_param(require_gcm_256, bool, 0644);
 MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM
encryption. Default: n/N/0");

+module_param(enable_negotiate_signing, bool, 0644);
+MODULE_PARM_DESC(enable_GMAC_signing, "Enable requesting faster
(GMAC) packet signing. Default: n/N/0");
+
 module_param(disable_legacy_dialects, bool, 0644);
 MODULE_PARM_DESC(disable_legacy_dialects, "To improve security it may be "
    "helpful to restrict the ability to "
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 921680fb7931..3c2e117bb926 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -667,9 +667,11 @@ struct TCP_Server_Info {
  unsigned int max_write;
  unsigned int min_offload;
  __le16 compress_algorithm;
+ __u16 signing_algorithm;
  __le16 cipher_type;
  /* save initital negprot hash */
  __u8 preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
+ bool signing_negotiated; /* true if valid signing context rcvd from server */
  bool posix_ext_supported;
  struct delayed_work reconnect; /* reconnect workqueue job */
  struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
@@ -1869,6 +1871,7 @@ extern unsigned int global_secflags; /* if on,
session setup sent
 extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
 extern bool enable_gcm_256; /* allow optional negotiate of strongest
signing (aes-gcm-256) */
 extern bool require_gcm_256; /* require use of strongest signing
(aes-gcm-256) */
+extern bool enable_negotiate_signing; /* request use of faster (GMAC)
signing if available */
 extern bool linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
 extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
 extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 962826dc3316..757f145e70e5 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -433,6 +433,23 @@ build_compression_ctxt(struct
smb2_compression_capabilities_context *pneg_ctxt)
  pneg_ctxt->CompressionAlgorithms[2] = SMB3_COMPRESS_LZNT1;
 }

+static void
+build_signing_ctxt(struct smb2_signing_capabilities *pneg_ctxt)
+{
+ pneg_ctxt->ContextType = SMB2_SIGNING_CAPABILITIES;
+ /*
+ * Data length must be increased here if more than 3 signing algorithms
+ * sent but currently only 3 are defined. And context Data length must
+ * be rounded to multiple of 8 for some servers.
+ */
+ pneg_ctxt->DataLength =
+ cpu_to_le16(DIV_ROUND_UP(sizeof(struct smb2_signing_capabilities) -
+ sizeof(struct smb2_neg_context), 8) * 8);
+ pneg_ctxt->SigningAlgorithmCount = cpu_to_le16(1);
+ pneg_ctxt->SigningAlgorithms[0] = cpu_to_le16(SIGNING_ALG_AES_CMAC);
+ /* TBD add SIGNING_ALG_AES_GMAC and/or SIGNING_ALG_HMAC_SHA256 */
+}
+
 static void
 build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
 {
@@ -498,7 +515,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
        struct TCP_Server_Info *server, unsigned int *total_len)
 {
  char *pneg_ctxt;
- unsigned int ctxt_len;
+ unsigned int ctxt_len, neg_context_count;

  if (*total_len > 200) {
  /* In case length corrupted don't want to overrun smb buffer */
@@ -525,6 +542,17 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
  *total_len += ctxt_len;
  pneg_ctxt += ctxt_len;

+ ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
+ server->hostname);
+ *total_len += ctxt_len;
+ pneg_ctxt += ctxt_len;
+
+ build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
+ *total_len += sizeof(struct smb2_posix_neg_context);
+ pneg_ctxt += sizeof(struct smb2_posix_neg_context);
+
+ neg_context_count = 4;
+
  if (server->compress_algorithm) {
  build_compression_ctxt((struct smb2_compression_capabilities_context *)
  pneg_ctxt);
@@ -533,17 +561,24 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
  8) * 8;
  *total_len += ctxt_len;
  pneg_ctxt += ctxt_len;
- req->NegotiateContextCount = cpu_to_le16(5);
- } else
- req->NegotiateContextCount = cpu_to_le16(4);
+ neg_context_count++;
+ }

- ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
- server->hostname);
- *total_len += ctxt_len;
- pneg_ctxt += ctxt_len;
+ if (enable_negotiate_signing) {
+ pr_warn_once("requesting GMAC signing is experimental\n");
+ build_signing_ctxt((struct smb2_signing_capabilities *)
+ pneg_ctxt);
+ ctxt_len = DIV_ROUND_UP(
+ sizeof(struct smb2_signing_capabilities),
+ 8) * 8;
+ *total_len += ctxt_len;
+ pneg_ctxt += ctxt_len;
+ neg_context_count++;
+ }
+
+ /* check for and add transport_capabilities and signing capabilities */
+ req->NegotiateContextCount = cpu_to_le16(neg_context_count);

- build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
- *total_len += sizeof(struct smb2_posix_neg_context);
 }

 static void decode_preauth_context(struct smb2_preauth_neg_context *ctxt)
@@ -632,6 +667,31 @@ static int decode_encrypt_ctx(struct
TCP_Server_Info *server,
  return 0;
 }

+static void decode_signing_ctx(struct TCP_Server_Info *server,
+        struct smb2_signing_capabilities *pctxt)
+{
+ unsigned int len = le16_to_cpu(pctxt->DataLength);
+
+ if ((len < 4) || (len > 16)) {
+ pr_warn_once("server sent bad signing negcontext\n");
+ return;
+ }
+ if (le16_to_cpu(pctxt->SigningAlgorithmCount) != 1) {
+ pr_warn_once("Invalid signing algorithm count\n");
+ return;
+ }
+ if (le16_to_cpu(pctxt->SigningAlgorithms[0]) > 2) {
+ pr_warn_once("unknown signing algorithm\n");
+ return;
+ }
+
+ server->signing_negotiated = true;
+ server->signing_algorithm = le16_to_cpu(pctxt->SigningAlgorithms[0]);
+ cifs_dbg(FYI, "signing algorithm %d chosen\n",
+      server->signing_algorithm);
+}
+
+
 static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
       struct TCP_Server_Info *server,
       unsigned int len_of_smb)
@@ -675,6 +735,9 @@ static int smb311_decode_neg_context(struct
smb2_negotiate_rsp *rsp,
  (struct smb2_compression_capabilities_context *)pctx);
  else if (pctx->ContextType == SMB2_POSIX_EXTENSIONS_AVAILABLE)
  server->posix_ext_supported = true;
+ else if (pctx->ContextType == SMB2_SIGNING_CAPABILITIES)
+ decode_signing_ctx(server,
+ (struct smb2_signing_capabilities *)pctx);
  else
  cifs_server_dbg(VFS, "unknown negcontext of type %d ignored\n",
  le16_to_cpu(pctx->ContextType));
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index ba75e65924ac..4b27cb9105fd 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -329,7 +329,7 @@ struct smb2_neg_context {
  __le16 ContextType;
  __le16 DataLength;
  __le32 Reserved;
- /* Followed by array of data */
+ /* Followed by array of data. NOTE: some servers require padding to
8 byte boundary */
 } __packed;

 #define SMB311_LINUX_CLIENT_SALT_SIZE 32
@@ -394,6 +394,7 @@ struct smb2_compression_capabilities_context {
  __u16 Padding;
  __u32 Flags;
  __le16 CompressionAlgorithms[3];
+ /* Check if pad needed */
 } __packed;

 /*
@@ -420,6 +421,7 @@ struct smb2_transport_capabilities_context {
  __le16  DataLength;
  __u32 Reserved;
  __le32 Flags;
+ __u32 Pad;
 } __packed;

 /*
@@ -458,6 +460,7 @@ struct smb2_signing_capabilities {
  __u32 Reserved;
  __le16 SigningAlgorithmCount;
  __le16 SigningAlgorithms[];
+ /*  Followed by padding to 8 byte boundary (required by some servers) */
 } __packed;

 #define POSIX_CTXT_DATA_LEN 16

-- 
Thanks,

Steve

--000000000000c01b6705c693a13d
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SMB3.1.1-Add-support-for-negotiating-signing-algorit.patch"
Content-Disposition: attachment; 
	filename="0001-SMB3.1.1-Add-support-for-negotiating-signing-algorit.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kqub2f020>
X-Attachment-Id: f_kqub2f020

RnJvbSA4YjU1YTAwNjM2YmE3ZTFiZThjMTY1OWRmOTM5YjZlM2NiNTNhYmUyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IE1vbiwgNSBKdWwgMjAyMSAxNTowNTozOSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFNN
QjMuMS4xOiBBZGQgc3VwcG9ydCBmb3IgbmVnb3RpYXRpbmcgc2lnbmluZyBhbGdvcml0aG0KClN1
cHBvcnQgZm9yIGZhc3RlciBwYWNrZXQgc2lnbmluZyAodXNpbmcgR01BQyBpbnN0ZWFkIG9mIENN
QUMpIGNhbgpub3cgYmUgbmVnb3RpYXRlZCB0byBzb21lIG5ld2VyIHNlcnZlcnMsIGluY2x1ZGlu
ZyBXaW5kb3dzLgpTZWUgTVMtU01CMiBzZWN0aW9uIDIuMi4zLjE3LgoKVGhpcyBwYXRjaCBhZGRz
IHN1cHBvcnQgZm9yIHNlbmRpbmcgdGhlIG5ldyBuZWdvdGlhdGUgY29udGV4dAp3aXRoIHRoZSBm
aXJzdCBvZiB0aHJlZSBzdXBwb3J0ZWQgc2lnbmluZyBhbGdvcml0aG1zIChBRVMtQ01BQykKYW5k
IGRlY29kaW5nIHRoZSByZXNwb25zZS4gIEEgZm9sbG93b24gcGF0Y2ggd2lsbCBhZGQgc3VwcG9y
dApmb3Igc2VuZGluZyB0aGUgb3RoZXIgdHdvIChpbmNsdWRpbmcgQUVTLUdNQUMsIHdoaWNoIGlz
IGZhc3Rlc3QpCmFuZCBjaGFuZ2luZyB0aGUgc2lnbmluZyBhbGdvcml0aG0gdXNlZCBiYXNlZCBv
biB3aGF0IHdhcwpuZWdvdGlhdGVkLgoKVG8gYWxsb3cgdGhlIGNsaWVudCB0byByZXF1ZXN0IEdN
QUMgc2lnbmluZyBzZXQgbW9kdWxlIHBhcmFtZXRlcgoiZW5hYmxlX25lZ290aWF0ZV9zaWduaW5n
IiB0byAxLgoKUmV2aWV3ZWQtYnk6IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNv
bT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNyb3NvZnQuY29tPgot
LS0KIGZzL2NpZnMvY2lmc2ZzLmMgICB8ICA0ICsrKwogZnMvY2lmcy9jaWZzZ2xvYi5oIHwgIDMg
KysKIGZzL2NpZnMvc21iMnBkdS5jICB8IDgzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKystLS0tLS0KIGZzL2NpZnMvc21iMnBkdS5oICB8ICA1ICsrLQogNCBmaWxlcyBj
aGFuZ2VkLCA4NCBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9m
cy9jaWZzL2NpZnNmcy5jIGIvZnMvY2lmcy9jaWZzZnMuYwppbmRleCA5ZmI4NzRkZDhkMjQuLjQ3
NmIwNzIxM2ZjZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZnMuYworKysgYi9mcy9jaWZzL2Np
ZnNmcy5jCkBAIC02NSw2ICs2NSw3IEBAIGJvb2wgbG9va3VwQ2FjaGVFbmFibGVkID0gdHJ1ZTsK
IGJvb2wgZGlzYWJsZV9sZWdhY3lfZGlhbGVjdHM7IC8qIGZhbHNlIGJ5IGRlZmF1bHQgKi8KIGJv
b2wgZW5hYmxlX2djbV8yNTYgPSB0cnVlOwogYm9vbCByZXF1aXJlX2djbV8yNTY7IC8qIGZhbHNl
IGJ5IGRlZmF1bHQgKi8KK2Jvb2wgZW5hYmxlX25lZ290aWF0ZV9zaWduaW5nOyAvKiBmYWxzZSBi
eSBkZWZhdWx0ICovCiB1bnNpZ25lZCBpbnQgZ2xvYmFsX3NlY2ZsYWdzID0gQ0lGU1NFQ19ERUY7
CiAvKiB1bnNpZ25lZCBpbnQgbnRsbXYyX3N1cHBvcnQgPSAwOyAqLwogdW5zaWduZWQgaW50IHNp
Z25fQ0lGU19QRFVzID0gMTsKQEAgLTEwNCw2ICsxMDUsOSBAQCBNT0RVTEVfUEFSTV9ERVNDKGVu
YWJsZV9nY21fMjU2LCAiRW5hYmxlIHJlcXVlc3Rpbmcgc3Ryb25nZXN0ICgyNTYgYml0KSBHQ00g
ZW5jcgogbW9kdWxlX3BhcmFtKHJlcXVpcmVfZ2NtXzI1NiwgYm9vbCwgMDY0NCk7CiBNT0RVTEVf
UEFSTV9ERVNDKHJlcXVpcmVfZ2NtXzI1NiwgIlJlcXVpcmUgc3Ryb25nZXN0ICgyNTYgYml0KSBH
Q00gZW5jcnlwdGlvbi4gRGVmYXVsdDogbi9OLzAiKTsKIAorbW9kdWxlX3BhcmFtKGVuYWJsZV9u
ZWdvdGlhdGVfc2lnbmluZywgYm9vbCwgMDY0NCk7CitNT0RVTEVfUEFSTV9ERVNDKGVuYWJsZV9H
TUFDX3NpZ25pbmcsICJFbmFibGUgcmVxdWVzdGluZyBmYXN0ZXIgKEdNQUMpIHBhY2tldCBzaWdu
aW5nLiBEZWZhdWx0OiBuL04vMCIpOworCiBtb2R1bGVfcGFyYW0oZGlzYWJsZV9sZWdhY3lfZGlh
bGVjdHMsIGJvb2wsIDA2NDQpOwogTU9EVUxFX1BBUk1fREVTQyhkaXNhYmxlX2xlZ2FjeV9kaWFs
ZWN0cywgIlRvIGltcHJvdmUgc2VjdXJpdHkgaXQgbWF5IGJlICIKIAkJCQkgICJoZWxwZnVsIHRv
IHJlc3RyaWN0IHRoZSBhYmlsaXR5IHRvICIKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2Iu
aCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCA5MjE2ODBmYjc5MzEuLjNjMmUxMTdiYjkyNiAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApA
QCAtNjY3LDkgKzY2NywxMSBAQCBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvIHsKIAl1bnNpZ25lZCBp
bnQJbWF4X3dyaXRlOwogCXVuc2lnbmVkIGludAltaW5fb2ZmbG9hZDsKIAlfX2xlMTYJY29tcHJl
c3NfYWxnb3JpdGhtOworCV9fdTE2CXNpZ25pbmdfYWxnb3JpdGhtOwogCV9fbGUxNgljaXBoZXJf
dHlwZTsKIAkgLyogc2F2ZSBpbml0aXRhbCBuZWdwcm90IGhhc2ggKi8KIAlfX3U4CXByZWF1dGhf
c2hhX2hhc2hbU01CMl9QUkVBVVRIX0hBU0hfU0laRV07CisJYm9vbAlzaWduaW5nX25lZ290aWF0
ZWQ7IC8qIHRydWUgaWYgdmFsaWQgc2lnbmluZyBjb250ZXh0IHJjdmQgZnJvbSBzZXJ2ZXIgKi8K
IAlib29sCXBvc2l4X2V4dF9zdXBwb3J0ZWQ7CiAJc3RydWN0IGRlbGF5ZWRfd29yayByZWNvbm5l
Y3Q7IC8qIHJlY29ubmVjdCB3b3JrcXVldWUgam9iICovCiAJc3RydWN0IG11dGV4IHJlY29ubmVj
dF9tdXRleDsgLyogcHJldmVudCBzaW11bHRhbmVvdXMgcmVjb25uZWN0cyAqLwpAQCAtMTg2OSw2
ICsxODcxLDcgQEAgZXh0ZXJuIHVuc2lnbmVkIGludCBnbG9iYWxfc2VjZmxhZ3M7CS8qIGlmIG9u
LCBzZXNzaW9uIHNldHVwIHNlbnQKIGV4dGVybiB1bnNpZ25lZCBpbnQgc2lnbl9DSUZTX1BEVXM7
ICAvKiBlbmFibGUgc21iIHBhY2tldCBzaWduaW5nICovCiBleHRlcm4gYm9vbCBlbmFibGVfZ2Nt
XzI1NjsgLyogYWxsb3cgb3B0aW9uYWwgbmVnb3RpYXRlIG9mIHN0cm9uZ2VzdCBzaWduaW5nIChh
ZXMtZ2NtLTI1NikgKi8KIGV4dGVybiBib29sIHJlcXVpcmVfZ2NtXzI1NjsgLyogcmVxdWlyZSB1
c2Ugb2Ygc3Ryb25nZXN0IHNpZ25pbmcgKGFlcy1nY20tMjU2KSAqLworZXh0ZXJuIGJvb2wgZW5h
YmxlX25lZ290aWF0ZV9zaWduaW5nOyAvKiByZXF1ZXN0IHVzZSBvZiBmYXN0ZXIgKEdNQUMpIHNp
Z25pbmcgaWYgYXZhaWxhYmxlICovCiBleHRlcm4gYm9vbCBsaW51eEV4dEVuYWJsZWQ7LyplbmFi
bGUgTGludXgvVW5peCBDSUZTIGV4dGVuc2lvbnMqLwogZXh0ZXJuIHVuc2lnbmVkIGludCBDSUZT
TWF4QnVmU2l6ZTsgIC8qIG1heCBzaXplIG5vdCBpbmNsdWRpbmcgaGRyICovCiBleHRlcm4gdW5z
aWduZWQgaW50IGNpZnNfbWluX3JjdjsgICAgLyogbWluIHNpemUgb2YgYmlnIG50d3JrIGJ1ZiBw
b29sICovCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5j
CmluZGV4IDk2MjgyNmRjMzMxNi4uNzU3ZjE0NWU3MGU1IDEwMDY0NAotLS0gYS9mcy9jaWZzL3Nt
YjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtNDMzLDYgKzQzMywyMyBAQCBidWls
ZF9jb21wcmVzc2lvbl9jdHh0KHN0cnVjdCBzbWIyX2NvbXByZXNzaW9uX2NhcGFiaWxpdGllc19j
b250ZXh0ICpwbmVnX2N0eHQpCiAJcG5lZ19jdHh0LT5Db21wcmVzc2lvbkFsZ29yaXRobXNbMl0g
PSBTTUIzX0NPTVBSRVNTX0xaTlQxOwogfQogCitzdGF0aWMgdm9pZAorYnVpbGRfc2lnbmluZ19j
dHh0KHN0cnVjdCBzbWIyX3NpZ25pbmdfY2FwYWJpbGl0aWVzICpwbmVnX2N0eHQpCit7CisJcG5l
Z19jdHh0LT5Db250ZXh0VHlwZSA9IFNNQjJfU0lHTklOR19DQVBBQklMSVRJRVM7CisJLyoKKwkg
KiBEYXRhIGxlbmd0aCBtdXN0IGJlIGluY3JlYXNlZCBoZXJlIGlmIG1vcmUgdGhhbiAzIHNpZ25p
bmcgYWxnb3JpdGhtcworCSAqIHNlbnQgYnV0IGN1cnJlbnRseSBvbmx5IDMgYXJlIGRlZmluZWQu
IEFuZCBjb250ZXh0IERhdGEgbGVuZ3RoIG11c3QKKwkgKiBiZSByb3VuZGVkIHRvIG11bHRpcGxl
IG9mIDggZm9yIHNvbWUgc2VydmVycy4KKwkgKi8KKwlwbmVnX2N0eHQtPkRhdGFMZW5ndGggPQor
CQljcHVfdG9fbGUxNihESVZfUk9VTkRfVVAoc2l6ZW9mKHN0cnVjdCBzbWIyX3NpZ25pbmdfY2Fw
YWJpbGl0aWVzKSAtCisJCQkJCXNpemVvZihzdHJ1Y3Qgc21iMl9uZWdfY29udGV4dCksIDgpICog
OCk7CisJcG5lZ19jdHh0LT5TaWduaW5nQWxnb3JpdGhtQ291bnQgPSBjcHVfdG9fbGUxNigxKTsK
KwlwbmVnX2N0eHQtPlNpZ25pbmdBbGdvcml0aG1zWzBdID0gY3B1X3RvX2xlMTYoU0lHTklOR19B
TEdfQUVTX0NNQUMpOworCS8qIFRCRCBhZGQgU0lHTklOR19BTEdfQUVTX0dNQUMgYW5kL29yIFNJ
R05JTkdfQUxHX0hNQUNfU0hBMjU2ICovCit9CisKIHN0YXRpYyB2b2lkCiBidWlsZF9lbmNyeXB0
X2N0eHQoc3RydWN0IHNtYjJfZW5jcnlwdGlvbl9uZWdfY29udGV4dCAqcG5lZ19jdHh0KQogewpA
QCAtNDk4LDcgKzUxNSw3IEBAIGFzc2VtYmxlX25lZ19jb250ZXh0cyhzdHJ1Y3Qgc21iMl9uZWdv
dGlhdGVfcmVxICpyZXEsCiAJCSAgICAgIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwg
dW5zaWduZWQgaW50ICp0b3RhbF9sZW4pCiB7CiAJY2hhciAqcG5lZ19jdHh0OwotCXVuc2lnbmVk
IGludCBjdHh0X2xlbjsKKwl1bnNpZ25lZCBpbnQgY3R4dF9sZW4sIG5lZ19jb250ZXh0X2NvdW50
OwogCiAJaWYgKCp0b3RhbF9sZW4gPiAyMDApIHsKIAkJLyogSW4gY2FzZSBsZW5ndGggY29ycnVw
dGVkIGRvbid0IHdhbnQgdG8gb3ZlcnJ1biBzbWIgYnVmZmVyICovCkBAIC01MjUsNiArNTQyLDE3
IEBAIGFzc2VtYmxlX25lZ19jb250ZXh0cyhzdHJ1Y3Qgc21iMl9uZWdvdGlhdGVfcmVxICpyZXEs
CiAJKnRvdGFsX2xlbiArPSBjdHh0X2xlbjsKIAlwbmVnX2N0eHQgKz0gY3R4dF9sZW47CiAKKwlj
dHh0X2xlbiA9IGJ1aWxkX25ldG5hbWVfY3R4dCgoc3RydWN0IHNtYjJfbmV0bmFtZV9uZWdfY29u
dGV4dCAqKXBuZWdfY3R4dCwKKwkJCQkJc2VydmVyLT5ob3N0bmFtZSk7CisJKnRvdGFsX2xlbiAr
PSBjdHh0X2xlbjsKKwlwbmVnX2N0eHQgKz0gY3R4dF9sZW47CisKKwlidWlsZF9wb3NpeF9jdHh0
KChzdHJ1Y3Qgc21iMl9wb3NpeF9uZWdfY29udGV4dCAqKXBuZWdfY3R4dCk7CisJKnRvdGFsX2xl
biArPSBzaXplb2Yoc3RydWN0IHNtYjJfcG9zaXhfbmVnX2NvbnRleHQpOworCXBuZWdfY3R4dCAr
PSBzaXplb2Yoc3RydWN0IHNtYjJfcG9zaXhfbmVnX2NvbnRleHQpOworCisJbmVnX2NvbnRleHRf
Y291bnQgPSA0OworCiAJaWYgKHNlcnZlci0+Y29tcHJlc3NfYWxnb3JpdGhtKSB7CiAJCWJ1aWxk
X2NvbXByZXNzaW9uX2N0eHQoKHN0cnVjdCBzbWIyX2NvbXByZXNzaW9uX2NhcGFiaWxpdGllc19j
b250ZXh0ICopCiAJCQkJcG5lZ19jdHh0KTsKQEAgLTUzMywxNyArNTYxLDI0IEBAIGFzc2VtYmxl
X25lZ19jb250ZXh0cyhzdHJ1Y3Qgc21iMl9uZWdvdGlhdGVfcmVxICpyZXEsCiAJCQkJOCkgKiA4
OwogCQkqdG90YWxfbGVuICs9IGN0eHRfbGVuOwogCQlwbmVnX2N0eHQgKz0gY3R4dF9sZW47Ci0J
CXJlcS0+TmVnb3RpYXRlQ29udGV4dENvdW50ID0gY3B1X3RvX2xlMTYoNSk7Ci0JfSBlbHNlCi0J
CXJlcS0+TmVnb3RpYXRlQ29udGV4dENvdW50ID0gY3B1X3RvX2xlMTYoNCk7CisJCW5lZ19jb250
ZXh0X2NvdW50Kys7CisJfQogCi0JY3R4dF9sZW4gPSBidWlsZF9uZXRuYW1lX2N0eHQoKHN0cnVj
dCBzbWIyX25ldG5hbWVfbmVnX2NvbnRleHQgKilwbmVnX2N0eHQsCi0JCQkJCXNlcnZlci0+aG9z
dG5hbWUpOwotCSp0b3RhbF9sZW4gKz0gY3R4dF9sZW47Ci0JcG5lZ19jdHh0ICs9IGN0eHRfbGVu
OworCWlmIChlbmFibGVfbmVnb3RpYXRlX3NpZ25pbmcpIHsKKwkJcHJfd2Fybl9vbmNlKCJyZXF1
ZXN0aW5nIEdNQUMgc2lnbmluZyBpcyBleHBlcmltZW50YWxcbiIpOworCQlidWlsZF9zaWduaW5n
X2N0eHQoKHN0cnVjdCBzbWIyX3NpZ25pbmdfY2FwYWJpbGl0aWVzICopCisJCQkJcG5lZ19jdHh0
KTsKKwkJY3R4dF9sZW4gPSBESVZfUk9VTkRfVVAoCisJCQlzaXplb2Yoc3RydWN0IHNtYjJfc2ln
bmluZ19jYXBhYmlsaXRpZXMpLAorCQkJCTgpICogODsKKwkJKnRvdGFsX2xlbiArPSBjdHh0X2xl
bjsKKwkJcG5lZ19jdHh0ICs9IGN0eHRfbGVuOworCQluZWdfY29udGV4dF9jb3VudCsrOworCX0K
KworCS8qIGNoZWNrIGZvciBhbmQgYWRkIHRyYW5zcG9ydF9jYXBhYmlsaXRpZXMgYW5kIHNpZ25p
bmcgY2FwYWJpbGl0aWVzICovCisJcmVxLT5OZWdvdGlhdGVDb250ZXh0Q291bnQgPSBjcHVfdG9f
bGUxNihuZWdfY29udGV4dF9jb3VudCk7CiAKLQlidWlsZF9wb3NpeF9jdHh0KChzdHJ1Y3Qgc21i
Ml9wb3NpeF9uZWdfY29udGV4dCAqKXBuZWdfY3R4dCk7Ci0JKnRvdGFsX2xlbiArPSBzaXplb2Yo
c3RydWN0IHNtYjJfcG9zaXhfbmVnX2NvbnRleHQpOwogfQogCiBzdGF0aWMgdm9pZCBkZWNvZGVf
cHJlYXV0aF9jb250ZXh0KHN0cnVjdCBzbWIyX3ByZWF1dGhfbmVnX2NvbnRleHQgKmN0eHQpCkBA
IC02MzIsNiArNjY3LDMxIEBAIHN0YXRpYyBpbnQgZGVjb2RlX2VuY3J5cHRfY3R4KHN0cnVjdCBU
Q1BfU2VydmVyX0luZm8gKnNlcnZlciwKIAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIHZvaWQgZGVj
b2RlX3NpZ25pbmdfY3R4KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlciwKKwkJCSAgICAg
ICBzdHJ1Y3Qgc21iMl9zaWduaW5nX2NhcGFiaWxpdGllcyAqcGN0eHQpCit7CisJdW5zaWduZWQg
aW50IGxlbiA9IGxlMTZfdG9fY3B1KHBjdHh0LT5EYXRhTGVuZ3RoKTsKKworCWlmICgobGVuIDwg
NCkgfHwgKGxlbiA+IDE2KSkgeworCQlwcl93YXJuX29uY2UoInNlcnZlciBzZW50IGJhZCBzaWdu
aW5nIG5lZ2NvbnRleHRcbiIpOworCQlyZXR1cm47CisJfQorCWlmIChsZTE2X3RvX2NwdShwY3R4
dC0+U2lnbmluZ0FsZ29yaXRobUNvdW50KSAhPSAxKSB7CisJCXByX3dhcm5fb25jZSgiSW52YWxp
ZCBzaWduaW5nIGFsZ29yaXRobSBjb3VudFxuIik7CisJCXJldHVybjsKKwl9CisJaWYgKGxlMTZf
dG9fY3B1KHBjdHh0LT5TaWduaW5nQWxnb3JpdGhtc1swXSkgPiAyKSB7CisJCXByX3dhcm5fb25j
ZSgidW5rbm93biBzaWduaW5nIGFsZ29yaXRobVxuIik7CisJCXJldHVybjsKKwl9CisKKwlzZXJ2
ZXItPnNpZ25pbmdfbmVnb3RpYXRlZCA9IHRydWU7CisJc2VydmVyLT5zaWduaW5nX2FsZ29yaXRo
bSA9IGxlMTZfdG9fY3B1KHBjdHh0LT5TaWduaW5nQWxnb3JpdGhtc1swXSk7CisJY2lmc19kYmco
RllJLCAic2lnbmluZyBhbGdvcml0aG0gJWQgY2hvc2VuXG4iLAorCQkgICAgIHNlcnZlci0+c2ln
bmluZ19hbGdvcml0aG0pOworfQorCisKIHN0YXRpYyBpbnQgc21iMzExX2RlY29kZV9uZWdfY29u
dGV4dChzdHJ1Y3Qgc21iMl9uZWdvdGlhdGVfcnNwICpyc3AsCiAJCQkJICAgICBzdHJ1Y3QgVENQ
X1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiAJCQkJICAgICB1bnNpZ25lZCBpbnQgbGVuX29mX3NtYikK
QEAgLTY3NSw2ICs3MzUsOSBAQCBzdGF0aWMgaW50IHNtYjMxMV9kZWNvZGVfbmVnX2NvbnRleHQo
c3RydWN0IHNtYjJfbmVnb3RpYXRlX3JzcCAqcnNwLAogCQkJCShzdHJ1Y3Qgc21iMl9jb21wcmVz
c2lvbl9jYXBhYmlsaXRpZXNfY29udGV4dCAqKXBjdHgpOwogCQllbHNlIGlmIChwY3R4LT5Db250
ZXh0VHlwZSA9PSBTTUIyX1BPU0lYX0VYVEVOU0lPTlNfQVZBSUxBQkxFKQogCQkJc2VydmVyLT5w
b3NpeF9leHRfc3VwcG9ydGVkID0gdHJ1ZTsKKwkJZWxzZSBpZiAocGN0eC0+Q29udGV4dFR5cGUg
PT0gU01CMl9TSUdOSU5HX0NBUEFCSUxJVElFUykKKwkJCWRlY29kZV9zaWduaW5nX2N0eChzZXJ2
ZXIsCisJCQkJKHN0cnVjdCBzbWIyX3NpZ25pbmdfY2FwYWJpbGl0aWVzICopcGN0eCk7CiAJCWVs
c2UKIAkJCWNpZnNfc2VydmVyX2RiZyhWRlMsICJ1bmtub3duIG5lZ2NvbnRleHQgb2YgdHlwZSAl
ZCBpZ25vcmVkXG4iLAogCQkJCWxlMTZfdG9fY3B1KHBjdHgtPkNvbnRleHRUeXBlKSk7CmRpZmYg
LS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBkdS5oCmluZGV4IGJhNzVl
NjU5MjRhYy4uNGIyN2NiOTEwNWZkIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuaAorKysg
Yi9mcy9jaWZzL3NtYjJwZHUuaApAQCAtMzI5LDcgKzMyOSw3IEBAIHN0cnVjdCBzbWIyX25lZ19j
b250ZXh0IHsKIAlfX2xlMTYJQ29udGV4dFR5cGU7CiAJX19sZTE2CURhdGFMZW5ndGg7CiAJX19s
ZTMyCVJlc2VydmVkOwotCS8qIEZvbGxvd2VkIGJ5IGFycmF5IG9mIGRhdGEgKi8KKwkvKiBGb2xs
b3dlZCBieSBhcnJheSBvZiBkYXRhLiBOT1RFOiBzb21lIHNlcnZlcnMgcmVxdWlyZSBwYWRkaW5n
IHRvIDggYnl0ZSBib3VuZGFyeSAqLwogfSBfX3BhY2tlZDsKIAogI2RlZmluZSBTTUIzMTFfTElO
VVhfQ0xJRU5UX1NBTFRfU0laRQkJCTMyCkBAIC0zOTQsNiArMzk0LDcgQEAgc3RydWN0IHNtYjJf
Y29tcHJlc3Npb25fY2FwYWJpbGl0aWVzX2NvbnRleHQgewogCV9fdTE2CVBhZGRpbmc7CiAJX191
MzIJRmxhZ3M7CiAJX19sZTE2CUNvbXByZXNzaW9uQWxnb3JpdGhtc1szXTsKKwkvKiBDaGVjayBp
ZiBwYWQgbmVlZGVkICovCiB9IF9fcGFja2VkOwogCiAvKgpAQCAtNDIwLDYgKzQyMSw3IEBAIHN0
cnVjdCBzbWIyX3RyYW5zcG9ydF9jYXBhYmlsaXRpZXNfY29udGV4dCB7CiAJX19sZTE2ICBEYXRh
TGVuZ3RoOwogCV9fdTMyCVJlc2VydmVkOwogCV9fbGUzMglGbGFnczsKKwlfX3UzMglQYWQ7CiB9
IF9fcGFja2VkOwogCiAvKgpAQCAtNDU4LDYgKzQ2MCw3IEBAIHN0cnVjdCBzbWIyX3NpZ25pbmdf
Y2FwYWJpbGl0aWVzIHsKIAlfX3UzMglSZXNlcnZlZDsKIAlfX2xlMTYJU2lnbmluZ0FsZ29yaXRo
bUNvdW50OwogCV9fbGUxNglTaWduaW5nQWxnb3JpdGhtc1tdOworCS8qICBGb2xsb3dlZCBieSBw
YWRkaW5nIHRvIDggYnl0ZSBib3VuZGFyeSAocmVxdWlyZWQgYnkgc29tZSBzZXJ2ZXJzKSAqLwog
fSBfX3BhY2tlZDsKIAogI2RlZmluZSBQT1NJWF9DVFhUX0RBVEFfTEVOCTE2Ci0tIAoyLjMwLjIK
Cg==
--000000000000c01b6705c693a13d--
