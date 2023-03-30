Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BC4C6FD1D
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Mar 2023 12:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjC3MFC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Mar 2023 08:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjC3MFB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Mar 2023 08:05:01 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7976422C
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 05:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=deS2kLHw61a6ZEmvlUtUEoCBmDqXLszlmUTSWey+tns=; b=0g1VYFIKjDCDB2wMvRJNz/8Tbe
        x052l0vU+DAEN06sq4ktnFQR8m1wuAykEn6TwEceKvR+RPRk69EIaAiJ2ujLCMqY9jnFB2Dd3f1EX
        UnGx8zw3eMKRBTBPVWH8WbzRc9pyymb5NiwZY20KJd7+LC8BxggpQpNu4QzCB99eLz6J1bmptk3ap
        5El55oFpbMu1IOVI+xRe9U1DsUcQg8BWMAQ5UPxRAgj+unLvTboOz05+iDbyfo/A63ltfhnXFQ5ep
        +lV5Icf9RdFuTuGfp3myjuT1rHK6DRhFyR1GSJBRDU/Nle9x+0f2LWzohG++R32aPArMWuUojlely
        lK6mVaWTuQlSFAvZ1wzzgyGRXD9bro3vaowF440B4W+GP43Q/xpjhD3uVsGex1vGsyCfS7dw9A1Ec
        Z4ixaHendn3/rWxLW6klcoAlmy0JblbepvEmkPKmnURC/kBciBEBv0MEd86QUj5grlDE6uOh6vFUX
        C9YIax7SZPdrzXOrnWlgkxo4;
Received: from [2a01:4f8:252:410e::177:224] (port=52126 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1phr1W-006GnE-Sm; Thu, 30 Mar 2023 12:04:58 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 2/3] cifs: Simplify SMB2_open_init()
Date:   Thu, 30 Mar 2023 12:04:46 +0000
Message-Id: <12ae1d4e5bdecf8aec7240dda92c044aabbf9144.1680177540.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1680177540.git.vl@samba.org>
References: <cover.1680177540.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reduce code duplication by stitching together create contexts in one
place.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2pdu.c | 42 +++++++++---------------------------------
 1 file changed, 9 insertions(+), 33 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5c5a7c3f3064..9160f3a54805 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2815,14 +2815,6 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	}
 
 	if (*oplock == SMB2_OPLOCK_LEVEL_BATCH) {
-		/* need to set Next field of lease context if we request it */
-		if (server->capabilities & SMB2_GLOBAL_CAP_LEASING) {
-			struct create_context *ccontext =
-			    (struct create_context *)iov[n_iov-1].iov_base;
-			ccontext->Next =
-				cpu_to_le32(server->vals->create_lease_size);
-		}
-
 		rc = add_durable_context(iov, &n_iov, oparms,
 					tcon->use_persistent);
 		if (rc)
@@ -2830,13 +2822,6 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	}
 
 	if (tcon->posix_extensions) {
-		if (n_iov > 2) {
-			struct create_context *ccontext =
-			    (struct create_context *)iov[n_iov-1].iov_base;
-			ccontext->Next =
-				cpu_to_le32(iov[n_iov-1].iov_len);
-		}
-
 		rc = add_posix_context(iov, &n_iov, oparms->mode);
 		if (rc)
 			return rc;
@@ -2844,13 +2829,6 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 
 	if (tcon->snapshot_time) {
 		cifs_dbg(FYI, "adding snapshot context\n");
-		if (n_iov > 2) {
-			struct create_context *ccontext =
-			    (struct create_context *)iov[n_iov-1].iov_base;
-			ccontext->Next =
-				cpu_to_le32(iov[n_iov-1].iov_len);
-		}
-
 		rc = add_twarp_context(iov, &n_iov, tcon->snapshot_time);
 		if (rc)
 			return rc;
@@ -2874,12 +2852,6 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 			set_owner = false;
 
 		if (set_owner | set_mode) {
-			if (n_iov > 2) {
-				struct create_context *ccontext =
-				    (struct create_context *)iov[n_iov-1].iov_base;
-				ccontext->Next = cpu_to_le32(iov[n_iov-1].iov_len);
-			}
-
 			cifs_dbg(FYI, "add sd with mode 0x%x\n", oparms->mode);
 			rc = add_sd_context(iov, &n_iov, oparms->mode, set_owner);
 			if (rc)
@@ -2887,11 +2859,6 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		}
 	}
 
-	if (n_iov > 2) {
-		struct create_context *ccontext =
-			(struct create_context *)iov[n_iov-1].iov_base;
-		ccontext->Next = cpu_to_le32(iov[n_iov-1].iov_len);
-	}
 	add_query_id_context(iov, &n_iov);
 
 	if (n_iov > 2) {
@@ -2902,6 +2869,15 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		req->CreateContextsOffset = cpu_to_le32(
 			sizeof(struct smb2_create_req) +
 			iov[1].iov_len);
+
+		for (unsigned int i = 2; i < (n_iov-1); i++) {
+			struct kvec *v = &iov[i];
+			size_t len = v->iov_len;
+			struct create_context *cctx =
+				(struct create_context *)v->iov_base;
+
+			cctx->Next = cpu_to_le32(len);
+		}
 	}
 
 	rqst->rq_nvec = n_iov;
-- 
2.30.2

