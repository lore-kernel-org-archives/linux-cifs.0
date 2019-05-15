Return-Path: <SRS0=u+N2=TP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6878CC04E53
	for <linux-cifs@archiver.kernel.org>; Wed, 15 May 2019 21:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 416B02070D
	for <linux-cifs@archiver.kernel.org>; Wed, 15 May 2019 21:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfEOVJb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 May 2019 17:09:31 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58182 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbfEOVJb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 May 2019 17:09:31 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id D0F4320110AD; Wed, 15 May 2019 14:09:30 -0700 (PDT)
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH 2/2] cifs: Allocate memory for all iovs in smb2_ioctl
Date:   Wed, 15 May 2019 14:09:05 -0700
Message-Id: <1557954545-17831-2-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557954545-17831-1-git-send-email-longli@linuxonhyperv.com>
References: <1557954545-17831-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

An IOCTL uses up to 2 iovs. The 1st iov is the command itself, the 2nd iov is
optional data for that command. The 1st iov is always allocated on the heap
but the 2nd iov may point to a variable on the stack. This will trigger an
error when passing the 2nd iov for RDMA I/O.

Fix this by allocating a buffer for the 2nd iov.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2pdu.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 29f011d8d8e2..710ceb875161 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2538,11 +2538,25 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
 	struct kvec *iov = rqst->rq_iov;
 	unsigned int total_len;
 	int rc;
+	char *in_data_buf;
 
 	rc = smb2_plain_req_init(SMB2_IOCTL, tcon, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
+	if (indatalen) {
+		/*
+		 * indatalen is usually small at a couple of bytes max, so
+		 * just allocate through generic pool
+		 */
+		in_data_buf = kmalloc(indatalen, GFP_NOFS);
+		if (!in_data_buf) {
+			cifs_small_buf_release(req);
+			return -ENOMEM;
+		}
+		memcpy(in_data_buf, in_data, indatalen);
+	}
+
 	req->CtlCode = cpu_to_le32(opcode);
 	req->PersistentFileId = persistent_fid;
 	req->VolatileFileId = volatile_fid;
@@ -2563,7 +2577,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
 		       cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer));
 		rqst->rq_nvec = 2;
 		iov[0].iov_len = total_len - 1;
-		iov[1].iov_base = in_data;
+		iov[1].iov_base = in_data_buf;
 		iov[1].iov_len = indatalen;
 	} else {
 		rqst->rq_nvec = 1;
@@ -2605,8 +2619,11 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
 void
 SMB2_ioctl_free(struct smb_rqst *rqst)
 {
-	if (rqst && rqst->rq_iov)
+	if (rqst && rqst->rq_iov) {
 		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
+		if (rqst->rq_iov[1].iov_len)
+			kfree(rqst->rq_iov[1].iov_base);
+	}
 }
 
 
-- 
2.17.1

