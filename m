Return-Path: <SRS0=6i8E=DL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97539C4363C
	for <linux-cifs@archiver.kernel.org>; Sun,  4 Oct 2020 23:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60807206B6
	for <linux-cifs@archiver.kernel.org>; Sun,  4 Oct 2020 23:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ONdmO5FI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgJDXh2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 4 Oct 2020 19:37:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgJDXh2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 4 Oct 2020 19:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601854646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=UkqRAdB0wpUIuXLers+tFvBNSTD/ZxG1lUcX/i6DpM8=;
        b=ONdmO5FIIJNfSAT9VazAiBQalQczfv7x0IJ3JgnmaRfYq/w5+TA2c1Ri88pBIY8Mq7jEiZ
        Z8SJm+lwOU5Sl5KrxUTOiCNKz2DVl1F0G3/hQMeeWMR7hibGtXbFgp+vKmNjKQPIwXlCVa
        gcTShqKqlo6+T8pLYSFMJbRKSAMB+Ms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-bTq4k30BOpa6qLBoFJbtGQ-1; Sun, 04 Oct 2020 19:37:24 -0400
X-MC-Unique: bTq4k30BOpa6qLBoFJbtGQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88D1D1074668;
        Sun,  4 Oct 2020 23:37:23 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-124.bne.redhat.com [10.64.54.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1CE55C1BD;
        Sun,  4 Oct 2020 23:37:22 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 1/3] cifs: return cached_fid from open_shroot
Date:   Mon,  5 Oct 2020 09:37:03 +1000
Message-Id: <20201004233705.31436-2-lsahlber@redhat.com>
In-Reply-To: <20201004233705.31436-1-lsahlber@redhat.com>
References: <20201004233705.31436-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2inode.c | 11 ++++++-----
 fs/cifs/smb2ops.c   | 22 +++++++++++++++-------
 fs/cifs/smb2proto.h |  3 ++-
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index eba01d0908dd..df6212e55e10 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -511,9 +511,9 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	struct smb2_file_all_info *smb2_data;
 	__u32 create_options = 0;
-	struct cifs_fid fid;
 	bool no_cached_open = tcon->nohandlecache;
 	struct cifsFileInfo *cfile;
+	struct cached_fid *cfid = NULL;
 
 	*adjust_tz = false;
 	*symlink = false;
@@ -525,7 +525,7 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* If it is a root and its handle is cached then use it */
 	if (!strlen(full_path) && !no_cached_open) {
-		rc = open_shroot(xid, tcon, cifs_sb, &fid);
+		rc = open_shroot(xid, tcon, cifs_sb, &cfid);
 		if (rc)
 			goto out;
 
@@ -533,12 +533,13 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 			move_smb2_info_to_cifs(data,
 					       &tcon->crfid.file_all_info);
 		} else {
-			rc = SMB2_query_info(xid, tcon, fid.persistent_fid,
-					     fid.volatile_fid, smb2_data);
+			rc = SMB2_query_info(xid, tcon,
+					     cfid->fid->persistent_fid,
+					     cfid->fid->volatile_fid, smb2_data);
 			if (!rc)
 				move_smb2_info_to_cifs(data, smb2_data);
 		}
-		close_shroot(&tcon->crfid);
+		close_shroot(cfid);
 		goto out;
 	}
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 32f90dc82c84..fd6c136066df 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -651,7 +651,8 @@ smb2_cached_lease_break(struct work_struct *work)
  * Open the directory at the root of a share
  */
 int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
-		struct cifs_sb_info *cifs_sb, struct cifs_fid *pfid)
+		struct cifs_sb_info *cifs_sb,
+		struct cached_fid **cfid)
 {
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server = ses->server;
@@ -666,11 +667,12 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
 	int rc, flags = 0;
 	__le16 utf16_path = 0; /* Null - since an open of top of share */
 	u8 oplock = SMB2_OPLOCK_LEVEL_II;
+	struct cifs_fid *pfid;
 
 	mutex_lock(&tcon->crfid.fid_mutex);
 	if (tcon->crfid.is_valid) {
 		cifs_dbg(FYI, "found a cached root file handle\n");
-		memcpy(pfid, tcon->crfid.fid, sizeof(struct cifs_fid));
+		*cfid = &tcon->crfid;
 		kref_get(&tcon->crfid.refcount);
 		mutex_unlock(&tcon->crfid.fid_mutex);
 		return 0;
@@ -691,6 +693,7 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
 	if (!server->ops->new_lease_key)
 		return -EIO;
 
+	pfid = tcon->crfid.fid;
 	server->ops->new_lease_key(pfid);
 
 	memset(rqst, 0, sizeof(rqst));
@@ -820,6 +823,8 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
 	SMB2_query_info_free(&rqst[1]);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
+	if (rc == 0)
+		*cfid = &tcon->crfid;
 	return rc;
 }
 
@@ -833,6 +838,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 	bool no_cached_open = tcon->nohandlecache;
+	struct cached_fid *cfid = NULL;
 
 	oparms.tcon = tcon;
 	oparms.desired_access = FILE_READ_ATTRIBUTES;
@@ -841,12 +847,14 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	if (no_cached_open)
+	if (no_cached_open) {
 		rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
 			       NULL, NULL);
-	else
-		rc = open_shroot(xid, tcon, cifs_sb, &fid);
-
+	} else {
+		rc = open_shroot(xid, tcon, cifs_sb, &cfid);
+		if (rc == 0)
+			memcpy(&fid, cfid->fid, sizeof(struct cifs_fid));
+	}
 	if (rc)
 		return;
 
@@ -863,7 +871,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	if (no_cached_open)
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	else
-		close_shroot(&tcon->crfid);
+		close_shroot(cfid);
 }
 
 static void
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 2f8ecbf54214..67c50d78caa1 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -70,7 +70,8 @@ extern int smb3_handle_read_data(struct TCP_Server_Info *server,
 				 struct mid_q_entry *mid);
 
 extern int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
-		       struct cifs_sb_info *cifs_sb, struct cifs_fid *pfid);
+		       struct cifs_sb_info *cifs_sb,
+		       struct cached_fid **cfid);
 extern void close_shroot(struct cached_fid *cfid);
 extern void close_shroot_lease(struct cached_fid *cfid);
 extern void close_shroot_lease_locked(struct cached_fid *cfid);
-- 
2.13.6

