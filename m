Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F05C761A6
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Mar 2023 12:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjC3MFD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Mar 2023 08:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbjC3MFC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Mar 2023 08:05:02 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C564699
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 05:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=pRafTm0npApAj9WnFbNbWPlxnCVrSS1Dxche9YyA1fc=; b=uszHbd+zT+z/CENZsq6BXqJP3Z
        O9GuQ1HQ7hCclbJqc5BjxKkvcVuNWlEd9tPJ5Oz3MtWQg3Uw1UkpjTy/z48/v+7sTZEJHHZNWwX5A
        NMhr1WRN4NmvOCGp2IWaCsoJ9BTjnn0fQS3Qb59Rkvm7rub8eHLSa8YUMaeo4RA43ijgj7tFFXyBS
        z8RuPppgkUUrPuSHRlQC+iLrJT5fEEHq5rzOVrFNlECopOj0b5GzqBLQJ8cMM8ZH65SMyE3vRa81i
        dy8EKd+RUUbcJnb33gw6F9zGk2OuSIGyjZRLBPBKbWLoVYTfniQp7q6Q7kt9Kl0+QmjR+SEqC/RUC
        XHKlwwa+2s4pLLViiWOJalyA00AqzkanOeBGs4d81V0LC4jMGufRI3azPvgUv1/10i5qZLbIUoaQw
        VKEH/XQEao8HP1otWJZUf8gULC4eZZ26uizZaRiwt9/OLGErwB5u2VFbcjwHQmIF+CpVSqrWKCZMH
        LoXOwNMi7KHlPb3CIUEb0yWA;
Received: from [2a01:4f8:252:410e::177:224] (port=52126 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1phr1X-006GnE-1l; Thu, 30 Mar 2023 12:04:59 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 3/3] cifs: Simplify SMB2_open_init()
Date:   Thu, 30 Mar 2023 12:04:47 +0000
Message-Id: <4b3f3603f90dd153e3a9e729c59f7f799286638a.1680177540.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1680177540.git.vl@samba.org>
References: <cover.1680177540.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reduce code duplication by calculating req->CreateContextsLength in
one place.

This is the last reference to "req" in the add_*_context functions,
remove that parameter.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2pdu.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 9160f3a54805..bd511286536b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -801,7 +801,6 @@ create_posix_buf(umode_t mode)
 static int
 add_posix_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
 	iov[num].iov_base = create_posix_buf(mode);
@@ -810,7 +809,6 @@ add_posix_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode)
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct create_posix);
-	le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_posix));
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -2159,8 +2157,6 @@ add_lease_context(struct TCP_Server_Info *server, struct kvec *iov,
 		return -ENOMEM;
 	iov[num].iov_len = server->vals->create_lease_size;
 	req->RequestedOplockLevel = SMB2_OPLOCK_LEVEL_LEASE;
-	le32_add_cpu(&req->CreateContextsLength,
-		     server->vals->create_lease_size);
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -2239,14 +2235,12 @@ static int
 add_durable_v2_context(struct kvec *iov, unsigned int *num_iovec,
 		    struct cifs_open_parms *oparms)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
 	iov[num].iov_base = create_durable_v2_buf(oparms);
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct create_durable_v2);
-	le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_durable_v2));
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -2255,7 +2249,6 @@ static int
 add_durable_reconnect_v2_context(struct kvec *iov, unsigned int *num_iovec,
 		    struct cifs_open_parms *oparms)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
 	/* indicate that we don't need to relock the file */
@@ -2265,8 +2258,6 @@ add_durable_reconnect_v2_context(struct kvec *iov, unsigned int *num_iovec,
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct create_durable_handle_reconnect_v2);
-	le32_add_cpu(&req->CreateContextsLength,
-			sizeof(struct create_durable_handle_reconnect_v2));
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -2275,7 +2266,6 @@ static int
 add_durable_context(struct kvec *iov, unsigned int *num_iovec,
 		    struct cifs_open_parms *oparms, bool use_persistent)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
 	if (use_persistent) {
@@ -2295,7 +2285,6 @@ add_durable_context(struct kvec *iov, unsigned int *num_iovec,
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct create_durable);
-	le32_add_cpu(&req->CreateContextsLength, sizeof(struct create_durable));
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -2329,14 +2318,12 @@ create_twarp_buf(__u64 timewarp)
 static int
 add_twarp_context(struct kvec *iov, unsigned int *num_iovec, __u64 timewarp)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
 	iov[num].iov_base = create_twarp_buf(timewarp);
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct crt_twarp_ctxt);
-	le32_add_cpu(&req->CreateContextsLength, sizeof(struct crt_twarp_ctxt));
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -2459,7 +2446,6 @@ create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
 static int
 add_sd_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode, bool set_owner)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 	unsigned int len = 0;
 
@@ -2467,7 +2453,6 @@ add_sd_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode, bool set
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = len;
-	le32_add_cpu(&req->CreateContextsLength, len);
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -2498,14 +2483,12 @@ create_query_id_buf(void)
 static int
 add_query_id_context(struct kvec *iov, unsigned int *num_iovec)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
 	iov[num].iov_base = create_query_id_buf();
 	if (iov[num].iov_base == NULL)
 		return -ENOMEM;
 	iov[num].iov_len = sizeof(struct crt_query_id_ctxt);
-	le32_add_cpu(&req->CreateContextsLength, sizeof(struct crt_query_id_ctxt));
 	*num_iovec = num + 1;
 	return 0;
 }
@@ -2869,6 +2852,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		req->CreateContextsOffset = cpu_to_le32(
 			sizeof(struct smb2_create_req) +
 			iov[1].iov_len);
+		req->CreateContextsLength = 0;
 
 		for (unsigned int i = 2; i < (n_iov-1); i++) {
 			struct kvec *v = &iov[i];
@@ -2877,7 +2861,10 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 				(struct create_context *)v->iov_base;
 
 			cctx->Next = cpu_to_le32(len);
+			le32_add_cpu(&req->CreateContextsLength, len);
 		}
+		le32_add_cpu(&req->CreateContextsLength,
+			     iov[n_iov-1].iov_len);
 	}
 
 	rqst->rq_nvec = n_iov;
-- 
2.30.2

