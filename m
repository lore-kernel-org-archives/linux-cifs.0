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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8340CC433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 20:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44ED561007
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 20:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhDIUZi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbhDIUZi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 16:25:38 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16772C061762
        for <linux-cifs@vger.kernel.org>; Fri,  9 Apr 2021 13:25:25 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id b14so11626649lfv.8
        for <linux-cifs@vger.kernel.org>; Fri, 09 Apr 2021 13:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=0oxAVaozx2tGUwHaI5hqE6vleAmozCilns4C2fl8pp0=;
        b=TrsdTKkfJTt4pFC3lY6wnytAQR6U0eQIAhmAR7xqLXwQYHPns8LXfno6UGd1Hgb50U
         a4rn1qU7kByAWKqUBSm2Rfn910rQuMBAcH2BaYpS5l6JTWLO2PlNUdRY3TXME2IZhSPZ
         iG9/CksXLJVomjYKP1u+PWBe72udr8SUyR+Z/YrWs/gPhk/s+JUDSKNBLMH9QlVfG4Ch
         Kf7za/jHyTeuZWJjMG3PGVplNEfK9X9gUNCcOHp0cYc3V5upvMa8CdBbKnhDB46bcO1b
         caUp37tXXa6M/3lbPojtyeJf2Mx52xY55bFoGrmyMcXkMTemuGkvCG3phPTHI7wRxYyw
         fxYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=0oxAVaozx2tGUwHaI5hqE6vleAmozCilns4C2fl8pp0=;
        b=Of500QyiNKA9pTkatZsVKCXe/gacxZlS2A6biGmc/YTkJ7HyBPB9Eam0Iuq35X9fB6
         6tht+t4JcoPgNwQ6T9tq3Jhvvw1YtmHO5OYyGgkPf0peHPKl6Fg3eduM7ULdrPZ6QiZN
         pMB98yLBbAM6zmcFcU9TxDqVlD8/DJnbTdwpaZvEWMKKyDgsB/tNcOwFPSLgLmzD3N4Z
         JMI8V7nfnqFcpA615ys892Bmp5J1R7VtCX6iI1PY0auBwUpo2M4Z/Ah8p+WdD3h5e3fN
         DPY/UPtwvBOE7egcYY9pFZwMnWYmp2TlMTRRrM1HrjJ/rdhdoaTwNH26fCGMW2hl+x7d
         1q9g==
X-Gm-Message-State: AOAM530wU1SS3jARcaBpEvLBbrzVFdBPcsOX0B/98veoOU6ETciLaFhr
        WClJDhZY3r9vUQfaVI4m6dXdwKtngw/B1QwC0Hb0k9+RB5t8OQ==
X-Google-Smtp-Source: ABdhPJxVU0UuRd5AFC6Ofj+0WAsXT8kEYH6CC6JZvg2GWjS+v9PE9Tl/asarcVnyzhH1mP1M715DmgJ3fSxyLsKThWs=
X-Received: by 2002:a19:8c0a:: with SMTP id o10mr11314842lfd.175.1617999923362;
 Fri, 09 Apr 2021 13:25:23 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Apr 2021 15:25:12 -0500
Message-ID: <CAH2r5mvEZQQBdtbEeaDFq40iXEvpU+q7NGtLyioJkid_zwx9Yw@mail.gmail.com>
Subject: [PATCH][SMB3] smb3: update protocol header definitions based to
 include new flags
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-cifsd-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

[MS-SMB2] protocol specification was recently updated to include
new flags, new negotiate context and some minor changes to fields.
Update smb2pdu.h structure definitions to match the newest version
of the protocol specification.  Updates to the compression context
values will be in a followon patch.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/smb2pdu.h | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index a5a9e33c0d73..d6cd6e6ff14d 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -181,7 +181,11 @@ struct smb2_rdma_transform {
  __le32 Reserved2;
 } __packed;

-struct smb2_rdma_encryption_transform {
+/* TransformType */
+#define SMB2_RDMA_TRANSFORM_TYPE_ENCRYPTION 0x0001
+#define SMB2_RDMA_TRANSFORM_TYPE_SIGNING 0x0002
+
+struct smb2_rdma_crypto_transform {
  __le16 TransformType;
  __le16 SignatureLength;
  __le16 NonceLength;
@@ -409,13 +413,29 @@ struct smb2_netname_neg_context {
 } __packed;

 /*
- * For rdma transform capabilities context see MS-SMB2 2.2.3.1.6
+ * For smb2_transport_capabilities context see MS-SMB2 2.2.3.1.5
  * and 2.2.4.1.5
  */

+/* Flags */
+#define SMB2_ACCEPT_TRANSFORM_LEVEL_SECURITY 0x00000001
+
+struct smb2_transport_capabilities_context {
+ __le16 ContextType; /* 6 */
+ __le16  DataLength;
+ __u32 Reserved;
+ __le32 Flags;
+} __packed;
+
+/*
+ * For rdma transform capabilities context see MS-SMB2 2.2.3.1.6
+ * and 2.2.4.1.6
+ */
+
 /* RDMA Transform IDs */
 #define SMB2_RDMA_TRANSFORM_NONE 0x0000
 #define SMB2_RDMA_TRANSFORM_ENCRYPTION 0x0001
+#define SMB2_RDMA_TRANSFORM_SIGNING 0x0002

 struct smb2_rdma_transform_capabilities_context {
  __le16 ContextType; /* 7 */
@@ -427,6 +447,11 @@ struct smb2_rdma_transform_capabilities_context {
  __le16 RDMATransformIds[];
 } __packed;

+/*
+ * For signing capabilities context see MS-SMB2 2.2.3.1.7
+ * and 2.2.4.1.7
+ */
+
 /* Signing algorithms */
 #define SIGNING_ALG_HMAC_SHA256 0
 #define SIGNING_ALG_AES_CMAC 1
@@ -634,7 +659,8 @@ struct smb2_tree_connect_rsp {
 #define SHI1005_FLAGS_ENABLE_HASH_V2 0x00004000
 #define SHI1005_FLAGS_ENCRYPT_DATA 0x00008000
 #define SMB2_SHAREFLAG_IDENTITY_REMOTING 0x00040000 /* 3.1.1 */
-#define SHI1005_FLAGS_ALL 0x0004FF33
+#define SMB2_SHAREFLAG_COMPRESS_DATA 0x00100000 /* 3.1.1 */
+#define SHI1005_FLAGS_ALL 0x0014FF33

 /* Possible share capabilities */
 #define SMB2_SHARE_CAP_DFS cpu_to_le32(0x00000008) /* all dialects */
@@ -1390,7 +1416,11 @@ struct smb2_lock_req {
  struct smb2_sync_hdr sync_hdr;
  __le16 StructureSize; /* Must be 48 */
  __le16 LockCount;
- __le32 Reserved;
+ /*
+ * The least significant four bits are the index, the other 28 bits are
+ * the lock sequence number (0 to 64). See MS-SMB2 2.2.26
+ */
+ __le32 LockSequenceNumber;
  __u64  PersistentFileId; /* opaque endianness */
  __u64  VolatileFileId; /* opaque endianness */
  /* Followed by at least one */

-- 
Thanks,

Steve
