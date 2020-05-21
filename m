Return-Path: <SRS0=L/zo=7D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1E1C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 21 May 2020 05:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D04D12070A
	for <linux-cifs@archiver.kernel.org>; Thu, 21 May 2020 05:03:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UMKBcnS9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgEUFD3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 May 2020 01:03:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23010 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726799AbgEUFD3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 May 2020 01:03:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590037406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=1f9dSILdJWdUhZP0kJJTWCGTeuMmqIBiHRuAuukRNCk=;
        b=UMKBcnS93OfZbpW2ELW1h/1y/fUSISFcRig9B/fw9zNVQpjxkVeoZL87KtIWJUQuhhMYxs
        1SyjrmjpF8cgY6hpI29zU4sZY3HvBFX4PFlnyDnkDm7Ua6WsaJWPwc9FFhkB56diL1VnA7
        ODYIdNNn/x7ZNQYF8xcr5Hd6xbYgzlg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-lMbmxvmrOd2cmNWCh_w1Ow-1; Thu, 21 May 2020 01:03:25 -0400
X-MC-Unique: lMbmxvmrOd2cmNWCh_w1Ow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31A29461
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2020 05:03:24 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-230.bne.redhat.com [10.64.54.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 403626EA37;
        Thu, 21 May 2020 05:03:22 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: move some variables off the stack in smb2_ioctl_query_info
Date:   Thu, 21 May 2020 15:03:15 +1000
Message-Id: <20200521050315.6445-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Move some large data structures off the stack and into dynamically
allocated memory in the function smb2_ioctl_query_info

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 58 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f829f4165d38..fa5c79f64c0b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1452,6 +1452,16 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+struct iqi_vars {
+	struct smb_rqst rqst[3];
+	struct kvec rsp_iov[3];
+	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
+	struct kvec qi_iov[1];
+	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
+	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
+	struct kvec close_iov[1];
+};
+
 static int
 smb2_ioctl_query_info(const unsigned int xid,
 		      struct cifs_tcon *tcon,
@@ -1459,6 +1469,9 @@ smb2_ioctl_query_info(const unsigned int xid,
 		      __le16 *path, int is_dir,
 		      unsigned long p)
 {
+	struct iqi_vars *vars;
+	struct smb_rqst *rqst;
+	struct kvec *rsp_iov;
 	struct cifs_ses *ses = tcon->ses;
 	char __user *arg = (char __user *)p;
 	struct smb_query_info qi;
@@ -1468,45 +1481,47 @@ smb2_ioctl_query_info(const unsigned int xid,
 	struct smb2_query_info_rsp *qi_rsp = NULL;
 	struct smb2_ioctl_rsp *io_rsp = NULL;
 	void *buffer = NULL;
-	struct smb_rqst rqst[3];
 	int resp_buftype[3];
-	struct kvec rsp_iov[3];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
 	struct cifs_open_parms oparms;
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_fid fid;
-	struct kvec qi_iov[1];
-	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
-	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
-	struct kvec close_iov[1];
 	unsigned int size[2];
 	void *data[2];
 	int create_options = is_dir ? CREATE_NOT_FILE : CREATE_NOT_DIR;
 
-	memset(rqst, 0, sizeof(rqst));
+	vars = kzalloc(sizeof(*vars), GFP_ATOMIC);
+	if (vars == NULL)
+		return -ENOMEM;
+	rqst = &vars->rqst[0];
+	rsp_iov = &vars->rsp_iov[0];
+
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
-	memset(rsp_iov, 0, sizeof(rsp_iov));
 
 	if (copy_from_user(&qi, arg, sizeof(struct smb_query_info)))
-		return -EFAULT;
+		goto e_fault;
 
-	if (qi.output_buffer_length > 1024)
+	if (qi.output_buffer_length > 1024) {
+		kfree(vars);
 		return -EINVAL;
+	}
 
-	if (!ses || !(ses->server))
+	if (!ses || !(ses->server)) {
+		kfree(vars);
 		return -EIO;
+	}
 
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	buffer = memdup_user(arg + sizeof(struct smb_query_info),
 			     qi.output_buffer_length);
-	if (IS_ERR(buffer))
+	if (IS_ERR(buffer)) {
+		kfree(vars);
 		return PTR_ERR(buffer);
+	}
 
 	/* Open */
-	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
+	rqst[0].rq_iov = &vars->open_iov[0];
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
 	memset(&oparms, 0, sizeof(oparms));
@@ -1548,8 +1563,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 		if (!capable(CAP_SYS_ADMIN))
 			rc = -EPERM;
 		else  {
-			memset(&io_iov, 0, sizeof(io_iov));
-			rqst[1].rq_iov = io_iov;
+			rqst[1].rq_iov = &vars->io_iov[0];
 			rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
 
 			rc = SMB2_ioctl_init(tcon, &rqst[1],
@@ -1565,8 +1579,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 		if (!capable(CAP_SYS_ADMIN))
 			rc = -EPERM;
 		else  {
-			memset(&si_iov, 0, sizeof(si_iov));
-			rqst[1].rq_iov = si_iov;
+			rqst[1].rq_iov = &vars->si_iov[0];
 			rqst[1].rq_nvec = 1;
 
 			size[0] = 8;
@@ -1579,8 +1592,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 					SMB2_O_INFO_FILE, 0, data, size);
 		}
 	} else if (qi.flags == PASSTHRU_QUERY_INFO) {
-		memset(&qi_iov, 0, sizeof(qi_iov));
-		rqst[1].rq_iov = qi_iov;
+		rqst[1].rq_iov = &vars->qi_iov[0];
 		rqst[1].rq_nvec = 1;
 
 		rc = SMB2_query_info_init(tcon, &rqst[1], COMPOUND_FID,
@@ -1599,8 +1611,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 	smb2_set_related(&rqst[1]);
 
 	/* Close */
-	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov = close_iov;
+	rqst[2].rq_iov = &vars->close_iov[0];
 	rqst[2].rq_nvec = 1;
 
 	rc = SMB2_close_init(tcon, &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
@@ -1649,6 +1660,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 	}
 
  iqinf_exit:
+	kfree(vars);
 	kfree(buffer);
 	SMB2_open_free(&rqst[0]);
 	if (qi.flags & PASSTHRU_FSCTL)
-- 
2.13.6

