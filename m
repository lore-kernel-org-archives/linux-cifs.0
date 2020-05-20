Return-Path: <SRS0=DK+6=7C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41579C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 20 May 2020 02:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBF09204EA
	for <linux-cifs@archiver.kernel.org>; Wed, 20 May 2020 02:20:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fB3OYMma"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgETCUP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 May 2020 22:20:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21162 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726348AbgETCUP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 May 2020 22:20:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589941212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=P9McWr6xo1K0kPuCO6A6LtMba/4mpGXmBbHC/6MaIaA=;
        b=fB3OYMma0NyXf9hBYWctw/qSVI7I1C8q7h3CrwkXm+MCEYKH6VU/VgueGrPcDXOeubg1YA
        uB8iNcPljIizXQCPecXTTWV0dF702wmonzuZPsz4F9Pa2FwDVNgrNp0LX6foqX79KjjFHP
        UIG6h1wHB/fZuGuobOPx/qEmu7KmXto=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-31EODUcrPJ21fPu8RoQj-w-1; Tue, 19 May 2020 22:20:11 -0400
X-MC-Unique: 31EODUcrPJ21fPu8RoQj-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 200CB1005512
        for <linux-cifs@vger.kernel.org>; Wed, 20 May 2020 02:20:09 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-214.bne.redhat.com [10.64.54.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 733918206F;
        Wed, 20 May 2020 02:20:07 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: reduce stack use in smb2_compound_op
Date:   Wed, 20 May 2020 12:19:59 +1000
Message-Id: <20200520021959.18126-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Move a lot of structures and arrays off the stack and into a dynamically
allocated structure instead.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2inode.c | 92 +++++++++++++++++++++++++++--------------------------
 1 file changed, 47 insertions(+), 45 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index a8c301ae00ed..19115a9088ea 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -47,6 +47,18 @@ free_set_inf_compound(struct smb_rqst *rqst)
 }
 
 
+struct cop_vars {
+	struct cifs_open_parms oparms;
+	struct kvec rsp_iov[3];
+	struct smb_rqst rqst[3];
+	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
+	struct kvec qi_iov[1];
+	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
+	struct kvec close_iov[1];
+	struct smb2_file_rename_info rename_info;
+	struct smb2_file_link_info link_info;
+};
+
 static int
 smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		 struct cifs_sb_info *cifs_sb, const char *full_path,
@@ -54,35 +66,33 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		 __u32 create_options, umode_t mode, void *ptr, int command,
 		 struct cifsFileInfo *cfile)
 {
+	struct cop_vars *vars = NULL;
+	struct kvec *rsp_iov;
+	struct smb_rqst *rqst;
 	int rc;
 	__le16 *utf16_path = NULL;
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
-	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 	struct cifs_ses *ses = tcon->ses;
 	int num_rqst = 0;
-	struct smb_rqst rqst[3];
 	int resp_buftype[3];
-	struct kvec rsp_iov[3];
-	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
-	struct kvec qi_iov[1];
-	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
-	struct kvec close_iov[1];
 	struct smb2_query_info_rsp *qi_rsp = NULL;
 	int flags = 0;
 	__u8 delete_pending[8] = {1, 0, 0, 0, 0, 0, 0, 0};
 	unsigned int size[2];
 	void *data[2];
-	struct smb2_file_rename_info rename_info;
-	struct smb2_file_link_info link_info;
 	int len;
 
+	vars = kzalloc(sizeof(*vars), GFP_ATOMIC);
+	if (vars == NULL)
+		return -ENOMEM;
+	rqst = &vars->rqst[0];
+	rsp_iov = &vars->rsp_iov[0];
+
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	memset(rqst, 0, sizeof(rqst));
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
-	memset(rsp_iov, 0, sizeof(rsp_iov));
 
 	/* We already have a handle so we can skip the open */
 	if (cfile)
@@ -95,19 +105,17 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		goto finished;
 	}
 
-	memset(&oparms, 0, sizeof(struct cifs_open_parms));
-	oparms.tcon = tcon;
-	oparms.desired_access = desired_access;
-	oparms.disposition = create_disposition;
-	oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
-	oparms.mode = mode;
-
-	memset(&open_iov, 0, sizeof(open_iov));
-	rqst[num_rqst].rq_iov = open_iov;
+	vars->oparms.tcon = tcon;
+	vars->oparms.desired_access = desired_access;
+	vars->oparms.disposition = create_disposition;
+	vars->oparms.create_options = cifs_create_options(cifs_sb, create_options);
+	vars->oparms.fid = &fid;
+	vars->oparms.reconnect = false;
+	vars->oparms.mode = mode;
+
+	rqst[num_rqst].rq_iov = &vars->open_iov[0];
 	rqst[num_rqst].rq_nvec = SMB2_CREATE_IOV_SIZE;
-	rc = SMB2_open_init(tcon, &rqst[num_rqst], &oplock, &oparms,
+	rc = SMB2_open_init(tcon, &rqst[num_rqst], &oplock, &vars->oparms,
 			    utf16_path);
 	kfree(utf16_path);
 	if (rc)
@@ -121,8 +129,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	/* Operation */
 	switch (command) {
 	case SMB2_OP_QUERY_INFO:
-		memset(&qi_iov, 0, sizeof(qi_iov));
-		rqst[num_rqst].rq_iov = qi_iov;
+		rqst[num_rqst].rq_iov = &vars->qi_iov[0];
 		rqst[num_rqst].rq_nvec = 1;
 
 		if (cfile)
@@ -164,8 +171,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		trace_smb3_mkdir_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_RMDIR:
-		memset(&si_iov, 0, sizeof(si_iov));
-		rqst[num_rqst].rq_iov = si_iov;
+		rqst[num_rqst].rq_iov = &vars->si_iov[0];
 		rqst[num_rqst].rq_nvec = 1;
 
 		size[0] = 1; /* sizeof __u8 See MS-FSCC section 2.4.11 */
@@ -182,8 +188,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		trace_smb3_rmdir_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_SET_EOF:
-		memset(&si_iov, 0, sizeof(si_iov));
-		rqst[num_rqst].rq_iov = si_iov;
+		rqst[num_rqst].rq_iov = &vars->si_iov[0];
 		rqst[num_rqst].rq_nvec = 1;
 
 		size[0] = 8; /* sizeof __le64 */
@@ -200,8 +205,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_SET_INFO:
-		memset(&si_iov, 0, sizeof(si_iov));
-		rqst[num_rqst].rq_iov = si_iov;
+		rqst[num_rqst].rq_iov = &vars->si_iov[0];
 		rqst[num_rqst].rq_nvec = 1;
 
 
@@ -233,18 +237,17 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 						   full_path);
 		break;
 	case SMB2_OP_RENAME:
-		memset(&si_iov, 0, sizeof(si_iov));
-		rqst[num_rqst].rq_iov = si_iov;
+		rqst[num_rqst].rq_iov = &vars->si_iov[0];
 		rqst[num_rqst].rq_nvec = 2;
 
 		len = (2 * UniStrnlen((wchar_t *)ptr, PATH_MAX));
 
-		rename_info.ReplaceIfExists = 1;
-		rename_info.RootDirectory = 0;
-		rename_info.FileNameLength = cpu_to_le32(len);
+		vars->rename_info.ReplaceIfExists = 1;
+		vars->rename_info.RootDirectory = 0;
+		vars->rename_info.FileNameLength = cpu_to_le32(len);
 
 		size[0] = sizeof(struct smb2_file_rename_info);
-		data[0] = &rename_info;
+		data[0] = &vars->rename_info;
 
 		size[1] = len + 2 /* null */;
 		data[1] = (__le16 *)ptr;
@@ -271,18 +274,17 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		trace_smb3_rename_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_HARDLINK:
-		memset(&si_iov, 0, sizeof(si_iov));
-		rqst[num_rqst].rq_iov = si_iov;
+		rqst[num_rqst].rq_iov = &vars->si_iov[0];
 		rqst[num_rqst].rq_nvec = 2;
 
 		len = (2 * UniStrnlen((wchar_t *)ptr, PATH_MAX));
 
-		link_info.ReplaceIfExists = 0;
-		link_info.RootDirectory = 0;
-		link_info.FileNameLength = cpu_to_le32(len);
+		vars->link_info.ReplaceIfExists = 0;
+		vars->link_info.RootDirectory = 0;
+		vars->link_info.FileNameLength = cpu_to_le32(len);
 
 		size[0] = sizeof(struct smb2_file_link_info);
-		data[0] = &link_info;
+		data[0] = &vars->link_info;
 
 		size[1] = len + 2 /* null */;
 		data[1] = (__le16 *)ptr;
@@ -308,8 +310,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	if (cfile)
 		goto after_close;
 	/* Close */
-	memset(&close_iov, 0, sizeof(close_iov));
-	rqst[num_rqst].rq_iov = close_iov;
+	rqst[num_rqst].rq_iov = &vars->close_iov[0];
 	rqst[num_rqst].rq_nvec = 1;
 	rc = SMB2_close_init(tcon, &rqst[num_rqst], COMPOUND_FID,
 			     COMPOUND_FID, false);
@@ -420,6 +421,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
+	kfree(vars);
 	return rc;
 }
 
-- 
2.13.6

