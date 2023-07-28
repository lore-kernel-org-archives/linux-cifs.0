Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BE0C001DF
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 19:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbjG1Tub (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbjG1Tu1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 15:50:27 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4A43C1D
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 12:50:26 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=quyNTta0OH8gvGxTmj2vFTWhk4xQU5x4/edbZ94u9Fc=;
        b=h5m47/cxk1yiGOvYLSqsVNy3DgkNUf6TuAMqZ0KLi+AMyJ/uD6kmAk4423OaZ11LnIpxfX
        1aaRC5A0ufLLjyrCpjQx7YoicU5QV3dWaOuOx6bFQhX38btn6DbyroOpwnbHZtWrCd079z
        11SeOqBKLBvWyJk+QnyRVFtzQ5TX6u2l82ubF94S9ENQk8SqfEmSfpBmEIteeGhGzi+544
        NYAF9+eMqcDZVcElY0GeT6pCisLpO86gfrP3pC2nb8fR6XYP4JB3TPCupcTM+lijBDsOQD
        FKm8rEUxJSNC/Pu941E/dOSJSAiIJbc6Dai9WVE+ZStmauI1yEVau1RHMtXMRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=quyNTta0OH8gvGxTmj2vFTWhk4xQU5x4/edbZ94u9Fc=;
        b=ikW26s2PChTT31pVuMmAZ94yuuWY3DskGl5U4t3EEHKn6kqIgMIH2IB2BtpVBgM2SbxFyp
        66VzM2yABeigCRpm0OUluDEPH2gTlw6XCvsRV0aeoH0aLCCYIh+1T+WfTt44VDoJm3/Kh7
        qAeve6Tn+L496nI3jytZ5PuI0VR3/EXFqoYBzfvWVCSgK99g+KPxGk/UqTcsM8hrci9OG2
        Zng8WSS+eraH1px5JiXhnBGAtbik5+ZoXtF+xOSoCd5sRenHfS5QoeCO+DSytGCzu7dLv0
        djmrn6PDm3n8yyBhumEa+tU/pP1saXnH0iK9Uvz1nTHOK8wFLSYNzm1P41A0iQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1690573825; a=rsa-sha256;
        cv=none;
        b=fRHXcU2lHDNNxvy/2dJ8SSiwe9OfG4tDleLvsxo0ePt70uJu3JCEy8d5kThoQ7Pq5IX7/i
        DQrpPCWLGl3l5k5iiqYtIuV+Ex70vAJ3p8M9AIDZhZtiUy4jZNdHqeT1uwGCKI9HW6sPBg
        qcUtLKzyFvaBzE3pRYqXfFqCegWUvA8RIBmKUu7vNSpKp0JP6CrAitaPxJy3L7/fHQWXcL
        fkKHGvErDp2tYuZO1FbFsEiASyVfCWoPTn9hK0dD5MiCGKOTRM1qhUw+ilKVjqtugN9/AV
        kIWxaZjXDORMiVLypj6n+i8k0JbRoCp50pvRxVi4+Otl7VulNdpAkoLdaaSfNQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 4/8] smb: client: reduce stack usage in smb2_set_ea()
Date:   Fri, 28 Jul 2023 16:50:06 -0300
Message-ID: <20230728195010.19122-4-pc@manguebit.com>
In-Reply-To: <20230728195010.19122-1-pc@manguebit.com>
References: <20230728195010.19122-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Clang warns about exceeded stack frame size

  fs/smb/client/smb2ops.c:1080:1: warning: stack frame size (1432)
  exceeds limit (1024) in 'smb2_set_ea' [-Wframe-larger-than]

Fix this by allocating a set_ea_vars structure that will hold most of
the large structures.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 0f62bc373ad0..5c8bcaf41556 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1075,6 +1075,13 @@ smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+struct set_ea_vars {
+	struct smb_rqst rqst[3];
+	struct kvec rsp_iov[3];
+	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
+	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
+	struct kvec close_iov;
+};
 
 static int
 smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
@@ -1082,25 +1089,23 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	    const __u16 ea_value_len, const struct nls_table *nls_codepage,
 	    struct cifs_sb_info *cifs_sb)
 {
+	struct smb2_query_info_rsp *rsp;
 	struct cifs_ses *ses = tcon->ses;
+	struct set_ea_vars *vars;
 	struct TCP_Server_Info *server = cifs_pick_channel(ses);
+	struct smb_rqst *rqst;
+	struct kvec *rsp_iov;
 	__le16 *utf16_path = NULL;
 	int ea_name_len = strlen(ea_name);
 	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	int len;
-	struct smb_rqst rqst[3];
 	int resp_buftype[3];
-	struct kvec rsp_iov[3];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
 	struct cifs_open_parms oparms;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_fid fid;
-	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
 	unsigned int size[1];
 	void *data[1];
 	struct smb2_file_full_ea_info *ea = NULL;
-	struct kvec close_iov[1];
-	struct smb2_query_info_rsp *rsp;
 	int rc, used_len = 0;
 
 	if (smb3_encryption_required(tcon))
@@ -1113,9 +1118,15 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	if (!utf16_path)
 		return -ENOMEM;
 
-	memset(rqst, 0, sizeof(rqst));
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
-	memset(rsp_iov, 0, sizeof(rsp_iov));
+
+	vars = kzalloc(sizeof(*vars), GFP_KERNEL);
+	if (!vars) {
+		rc = -ENOMEM;
+		goto out_free_path;
+	}
+	rqst = vars->rqst;
+	rsp_iov = vars->rsp_iov;
 
 	if (ses->server->ops->query_all_EAs) {
 		if (!ea_value) {
@@ -1160,8 +1171,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	/* Open */
-	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
+	rqst[0].rq_iov = vars->open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
 	oparms = (struct cifs_open_parms) {
@@ -1181,8 +1191,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 
 	/* Set Info */
-	memset(&si_iov, 0, sizeof(si_iov));
-	rqst[1].rq_iov = si_iov;
+	rqst[1].rq_iov = vars->si_iov;
 	rqst[1].rq_nvec = 1;
 
 	len = sizeof(*ea) + ea_name_len + ea_value_len + 1;
@@ -1212,8 +1221,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 
 	/* Close */
-	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov = close_iov;
+	rqst[2].rq_iov = &vars->close_iov;
 	rqst[2].rq_nvec = 1;
 	rc = SMB2_close_init(tcon, server,
 			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
@@ -1228,13 +1236,15 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
  sea_exit:
 	kfree(ea);
-	kfree(utf16_path);
 	SMB2_open_free(&rqst[0]);
 	SMB2_set_info_free(&rqst[1]);
 	SMB2_close_free(&rqst[2]);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
+	kfree(vars);
+out_free_path:
+	kfree(utf16_path);
 	return rc;
 }
 #endif
-- 
2.41.0

