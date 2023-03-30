Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F127FC761AF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Mar 2023 12:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjC3MFD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Mar 2023 08:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjC3MFB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Mar 2023 08:05:01 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE73F420B
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 05:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=pIDAdTinNCg9b6xzvp/5PJcnEwG9KmyRNxX9esNeAQ0=; b=i09ts02uWSfeY9IjjmtoIuX9/d
        DctMR8T2CqsCXY/wWP1FN3ZZ+07YrdkhV0nLd8uI25S4COmhtg3fg7BCY9QMSqa7x54JEvgKyJ53H
        4YlLQ6F9Z1qlWY0q85PwguJexCU82wP1hMb9twL06x5vG92NrMMQkrz4/21Cygh/mYMOB2C1lsRST
        QElmfPOfDmJyrgN2/UdvfXadAf7IsWVbkmlYASVwQUrSJACo3tzL8Fv6zWEXsEPa0jaKdNx5nklmT
        VqQxMulOaZZ8moPwtrgYO9qZNainhNlTNjQG8AdOi85LnVg+M/5qM2U9FrswdHECo8o3+gSII/ExJ
        qbGBi1YzlUJPAMWv0M4Q2wRYDW9SFBf+qXKGzaa/MTZsGUuebnDD7sNN/Sydf6uUOT/VgWGH/eaGS
        iYAEg+napjEcf9rHwGZOcgJuXQqav/zp8N09qR5KmZlE++X13qhrF7tt6dCLWyq6svundKT5yoQhl
        k+1xaupVqPeAjbW1W7P1tGLo;
Received: from [2a01:4f8:252:410e::177:224] (port=52126 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1phr1W-006GnE-MI; Thu, 30 Mar 2023 12:04:58 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 1/3] cifs: Simplify SMB2_open_init()
Date:   Thu, 30 Mar 2023 12:04:45 +0000
Message-Id: <f5a9bc4ec1f6f1f952a1f8d32b9ca0c9c313e78c.1680177540.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1680177540.git.vl@samba.org>
References: <cover.1680177540.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We can point to the create contexts in just one place, we don't have
to do this in every add_*_context routine.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2pdu.c | 45 +++++++++++++--------------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6bd2aa6af18f..5c5a7c3f3064 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -810,10 +810,6 @@ add_posix_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode)
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct create_posix);
-	if (!req->CreateContextsOffset)
-		req->CreateContextsOffset = cpu_to_le32(
-				sizeof(struct smb2_create_req) +
-				iov[num - 1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_posix));
 	*num_iovec = num + 1;
 	return 0;
@@ -2163,10 +2159,6 @@ add_lease_context(struct TCP_Server_Info *server, struct kvec *iov,
 		return -ENOMEM;
 	iov[num].iov_len = server->vals->create_lease_size;
 	req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_LEASE;
-	if (!req->CreateContextsOffset)
-		req->CreateContextsOffset = cpu_to_le32(
-				sizeof(struct smb2_create_req) +
-				iov[num - 1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength,
 		     server->vals->create_lease_size);
 	*num_iovec = num + 1;
@@ -2254,10 +2246,6 @@ add_durable_v2_context(struct kvec *iov, unsigned int *num_iovec,
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct create_durable_v2);
-	if (!req->CreateContextsOffset)
-		req->CreateContextsOffset =
-			cpu_to_le32(sizeof(struct smb2_create_req) +
-								iov[1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_durable_v2));
 	*num_iovec = num + 1;
 	return 0;
@@ -2277,10 +2265,6 @@ add_durable_reconnect_v2_context(struct kvec *iov, unsigned int *num_iovec,
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct create_durable_handle_reconnect_v2);
-	if (!req->CreateContextsOffset)
-		req->CreateContextsOffset =
-			cpu_to_le32(sizeof(struct smb2_create_req) +
-								iov[1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength,
 			sizeof(struct create_durable_handle_reconnect_v2));
 	*num_iovec = num + 1;
@@ -2311,10 +2295,6 @@ add_durable_context(struct kvec *iov, unsigned int *num_iovec,
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct create_durable);
-	if (!req->CreateContextsOffset)
-		req->CreateContextsOffset =
-			cpu_to_le32(sizeof(struct smb2_create_req) +
-								iov[1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_durable));
 	*num_iovec = num + 1;
 	return 0;
@@ -2356,10 +2336,6 @@ add_twarp_context(struct kvec *iov, unsigned int *num_iovec, __u64 timewarp)
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct crt_twarp_ctxt);
-	if (!req->CreateContextsOffset)
-		req->CreateContextsOffset = cpu_to_le32(
-				sizeof(struct smb2_create_req) +
-				iov[num - 1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength, sizeof(struct crt_twarp_ctxt));
 	*num_iovec = num + 1;
 	return 0;
@@ -2491,10 +2467,6 @@ add_sd_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode, bool set
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = len;
-	if (!req->CreateContextsOffset)
-		req->CreateContextsOffset = cpu_to_le32(
-				sizeof(struct smb2_create_req) +
-				iov[num - 1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength, len);
 	*num_iovec = num + 1;
 	return 0;
@@ -2533,10 +2505,6 @@ add_query_id_context(struct kvec *iov, unsigned int *num_iovec)
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct crt_query_id_ctxt);
-	if (!req->CreateContextsOffset)
-		req->CreateContextsOffset = cpu_to_le32(
-				sizeof(struct smb2_create_req) +
-				iov[num - 1].iov_len);
 	le32_add_cpu(&req->CreateContextsLength, sizeof(struct crt_query_id_ctxt));
 	*num_iovec = num + 1;
 	return 0;
@@ -2700,6 +2668,9 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 		rc = add_posix_context(iov, &n_iov, mode);
 		if (rc)
 			goto err_free_req;
+		req->CreateContextsOffset = cpu_to_le32(
+			sizeof(struct smb2_create_req) +
+			iov[1].iov_len);
 		pc_buf = iov[n_iov-1].iov_base;
 	}
 
@@ -2923,6 +2894,16 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	}
 	add_query_id_context(iov, &n_iov);
 
+	if (n_iov > 2) {
+		/*
+		 * We have create contexts behind iov[1] (the file
+		 * name), point at them from the main create request
+		 */
+		req->CreateContextsOffset = cpu_to_le32(
+			sizeof(struct smb2_create_req) +
+			iov[1].iov_len);
+	}
+
 	rqst->rq_nvec = n_iov;
 	return 0;
 }
-- 
2.30.2

