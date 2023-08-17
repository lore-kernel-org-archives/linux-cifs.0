Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F98C3DA40
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352335AbjHQPgP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353230AbjHQPfw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:52 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024BA2D6D
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:50 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9COy4bKe5u3yeJNZvanWwWP4V9Cq4YKwxguzpNsinVg=;
        b=r3ofL8qlM2AndWZ1+V3ndeiFISIZPcnTNjQP5yZG5zU9nLZm0TFlx9+LS8Ei3KjEeU/VXo
        sHet6Uk/OTa7e5KDC09lRxtGvBISJ75TVWd5om/Wd2LIWEefSrm1cksIXCK9N2+qqcmwkm
        tRwjb9CauTkMkLQM4E+/3MrvURX3B50fnyViMcgcJ28cV4r215iAH2MkdNRDCuyYS13FbO
        G/kZ5accKCF67liQJGiX/0qnptmh+QNQoKL7p0rWde3SssF0nVwPfq2KsYG9x5hV5h2S7+
        DEdPx22imVAZqJX4p0azTnVJmGqdbOotctDKT4nmocxSM/uQgfWjCuviYwsLLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9COy4bKe5u3yeJNZvanWwWP4V9Cq4YKwxguzpNsinVg=;
        b=cfidRzRsWWTRWxKofRJQCG9yelewy1OOXd5tsg2Fq9NQVz84A2cpw0Ekgj32PKTadR15yu
        szL5Zmyd3gSQgFMy0J9767spxZFlhZV63htlidfCOmAS5zZh+AvCuxR+rQjJMVUYbkNEiQ
        u+ASB4Mnp6cVjsr3Ac2NvzCHQ+8Cpj7p4Y8EFhBRYDvKzdPa8fdVAKPobk5aNjyQUvo4/m
        JIjvrZ/02zIXnuAnW6dnV0RYvEqnuamSBm01T4l0G7qbF5cpOfHinoaLMOT3Ulz2/udD1j
        Zm1ykT7rRDjmzDPKI9HiuRpey2iSX1dtzfKt6nTRpyuhGwJ49CF32paRHAoZgA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286549; a=rsa-sha256;
        cv=none;
        b=Cr3AIrJ5hdiRfycAJ+6SgNPKOmxCij9DPPnvcCeOTerWGQDWrZoWm8/zxTepzo3fRKa8WT
        zk1fE6LvIZitRqc12w0u8Dlx9CRKEIpb7TS8qppVpqhjYdr1MFMEcVIgmEWaCYnSUaOeBp
        r4xCHBGvWq0sLJcViGLg3/dehwxoTuTYCePIOOkeAeo7E2Q4zWHBi6DZKtkPz6Yph4Zu5Q
        pae3O/XEtK9XUC3tFE2RTWen8x4oYQpM3R5c0eKOHZIR+0GGD0WA+Hq0OUC6/fbCBgz08a
        RJbkoM/rgm6l6QvfcEnyMoxLXCY3kmLAZXUaa62ANrMO9g3uU9MMZFshXNUIPw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 15/17] smb: client: reduce stack usage in smb2_set_ea()
Date:   Thu, 17 Aug 2023 12:34:13 -0300
Message-ID: <20230817153416.28083-16-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Clang warns about exceeded stack frame size

  fs/smb/client/smb2ops.c:1080:1: warning: stack frame size (1432)
  exceeds limit (1024) in 'smb2_set_ea' [-Wframe-larger-than]

Fix this by allocating a structure that will hold most of the large
variables.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h  | 13 ++++++++++
 fs/smb/client/smb2inode.c | 21 ++++------------
 fs/smb/client/smb2ops.c   | 50 ++++++++++++++++-----------------------
 3 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 6d5fa0351dce..1588f98660aa 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2214,4 +2214,17 @@ static inline void cifs_sg_set_buf(struct sg_table *sgtable,
 	}
 }
 
+struct smb2_compound_vars {
+	struct cifs_open_parms oparms;
+	struct kvec rsp_iov[3];
+	struct smb_rqst rqst[3];
+	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
+	struct kvec qi_iov;
+	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
+	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
+	struct kvec close_iov;
+	struct smb2_file_rename_info rename_info;
+	struct smb2_file_link_info link_info;
+};
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 0999383c0284..b41e2e872b22 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -35,19 +35,6 @@ free_set_inf_compound(struct smb_rqst *rqst)
 		SMB2_close_free(&rqst[2]);
 }
 
-
-struct cop_vars {
-	struct cifs_open_parms oparms;
-	struct kvec rsp_iov[3];
-	struct smb_rqst rqst[3];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
-	struct kvec qi_iov[1];
-	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
-	struct kvec close_iov[1];
-	struct smb2_file_rename_info rename_info;
-	struct smb2_file_link_info link_info;
-};
-
 /*
  * note: If cfile is passed, the reference to it is dropped here.
  * So make sure that you do not reuse cfile after return from this func.
@@ -63,7 +50,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			    __u8 **extbuf, size_t *extbuflen,
 			    struct kvec *out_iov, int *out_buftype)
 {
-	struct cop_vars *vars = NULL;
+	struct smb2_compound_vars *vars = NULL;
 	struct kvec *rsp_iov;
 	struct smb_rqst *rqst;
 	int rc;
@@ -134,7 +121,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	/* Operation */
 	switch (command) {
 	case SMB2_OP_QUERY_INFO:
-		rqst[num_rqst].rq_iov = &vars->qi_iov[0];
+		rqst[num_rqst].rq_iov = &vars->qi_iov;
 		rqst[num_rqst].rq_nvec = 1;
 
 		if (cfile)
@@ -168,7 +155,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 						     full_path);
 		break;
 	case SMB2_OP_POSIX_QUERY_INFO:
-		rqst[num_rqst].rq_iov = &vars->qi_iov[0];
+		rqst[num_rqst].rq_iov = &vars->qi_iov;
 		rqst[num_rqst].rq_nvec = 1;
 
 		if (cfile)
@@ -376,7 +363,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		goto after_close;
 	/* Close */
 	flags |= CIFS_CP_CREATE_CLOSE_OP;
-	rqst[num_rqst].rq_iov = &vars->close_iov[0];
+	rqst[num_rqst].rq_iov = &vars->close_iov;
 	rqst[num_rqst].rq_nvec = 1;
 	rc = SMB2_close_init(tcon, server,
 			     &rqst[num_rqst], COMPOUND_FID,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 91c7b7e52a72..d31ea7e7fd84 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1075,31 +1075,28 @@ smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-
 static int
 smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	    const char *path, const char *ea_name, const void *ea_value,
 	    const __u16 ea_value_len, const struct nls_table *nls_codepage,
 	    struct cifs_sb_info *cifs_sb)
 {
+	struct smb2_compound_vars *vars;
 	struct cifs_ses *ses = tcon->ses;
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
 	struct smb2_query_info_rsp *rsp;
 	int rc, used_len = 0;
 
@@ -1113,9 +1110,14 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	if (!utf16_path)
 		return -ENOMEM;
 
-	memset(rqst, 0, sizeof(rqst));
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
-	memset(rsp_iov, 0, sizeof(rsp_iov));
+	vars = kzalloc(sizeof(*vars), GFP_KERNEL);
+	if (!vars) {
+		rc = -ENOMEM;
+		goto out_free_path;
+	}
+	rqst = vars->rqst;
+	rsp_iov = vars->rsp_iov;
 
 	if (ses->server->ops->query_all_EAs) {
 		if (!ea_value) {
@@ -1160,8 +1162,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	/* Open */
-	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[0].rq_iov = open_iov;
+	rqst[0].rq_iov = vars->open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
 	oparms = (struct cifs_open_parms) {
@@ -1181,8 +1182,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 
 	/* Set Info */
-	memset(&si_iov, 0, sizeof(si_iov));
-	rqst[1].rq_iov = si_iov;
+	rqst[1].rq_iov = vars->si_iov;
 	rqst[1].rq_nvec = 1;
 
 	len = sizeof(*ea) + ea_name_len + ea_value_len + 1;
@@ -1210,10 +1210,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	smb2_set_next_command(tcon, &rqst[1]);
 	smb2_set_related(&rqst[1]);
 
-
 	/* Close */
-	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[2].rq_iov = close_iov;
+	rqst[2].rq_iov = &vars->close_iov;
 	rqst[2].rq_nvec = 1;
 	rc = SMB2_close_init(tcon, server,
 			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
@@ -1228,13 +1226,15 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
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
@@ -1445,16 +1445,6 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-struct iqi_vars {
-	struct smb_rqst rqst[3];
-	struct kvec rsp_iov[3];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
-	struct kvec qi_iov[1];
-	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
-	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
-	struct kvec close_iov[1];
-};
-
 static int
 smb2_ioctl_query_info(const unsigned int xid,
 		      struct cifs_tcon *tcon,
@@ -1462,7 +1452,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 		      __le16 *path, int is_dir,
 		      unsigned long p)
 {
-	struct iqi_vars *vars;
+	struct smb2_compound_vars *vars;
 	struct smb_rqst *rqst;
 	struct kvec *rsp_iov;
 	struct cifs_ses *ses = tcon->ses;
@@ -1580,7 +1570,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 			rc = -EINVAL;
 			goto free_open_req;
 		}
-		rqst[1].rq_iov = &vars->si_iov[0];
+		rqst[1].rq_iov = vars->si_iov;
 		rqst[1].rq_nvec = 1;
 
 		/* MS-FSCC 2.4.13 FileEndOfFileInformation */
@@ -1592,7 +1582,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 					SMB2_O_INFO_FILE, 0, data, size);
 		free_req1_func = SMB2_set_info_free;
 	} else if (qi.flags == PASSTHRU_QUERY_INFO) {
-		rqst[1].rq_iov = &vars->qi_iov[0];
+		rqst[1].rq_iov = &vars->qi_iov;
 		rqst[1].rq_nvec = 1;
 
 		rc = SMB2_query_info_init(tcon, server,
@@ -1614,7 +1604,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 	smb2_set_related(&rqst[1]);
 
 	/* Close */
-	rqst[2].rq_iov = &vars->close_iov[0];
+	rqst[2].rq_iov = &vars->close_iov;
 	rqst[2].rq_nvec = 1;
 
 	rc = SMB2_close_init(tcon, server,
-- 
2.41.0

