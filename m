Return-Path: <SRS0=AEBP=RP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBDCC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Mar 2019 03:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A9B9214AE
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Mar 2019 03:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfCLD6k (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Mar 2019 23:58:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfCLD6k (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 11 Mar 2019 23:58:40 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 09220C05242A;
        Tue, 12 Mar 2019 03:58:40 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-95.bne.redhat.com [10.64.54.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 682EE19C71;
        Tue, 12 Mar 2019 03:58:39 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: cache FILE_ALL_INFO for the shared root handle
Date:   Tue, 12 Mar 2019 13:58:31 +1000
Message-Id: <20190312035831.2691-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 12 Mar 2019 03:58:40 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When we open the shared root handle also ask for FILE_ALL_INFORMATION since
we can do this at zero cost as part of a compound.
Cache this information as long as the lease is held and return and serve any
future requests from cache.

This allows us to serve "stat /<mountpoint>" directly from cache and avoid
a network roundtrip.  Since clients often want to do this quite a lot
this improve performance slightly.

As an example: xfstest generic/533 performs 43 stat operations on the root
of the share while it is run. Which are eliminated with this patch.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsglob.h  |   3 ++
 fs/cifs/smb2inode.c |  15 ++++---
 fs/cifs/smb2ops.c   | 113 +++++++++++++++++++++++++++++++++++++++++++---------
 fs/cifs/smb2pdu.c   |  12 +++---
 fs/cifs/smb2proto.h |   3 ++
 5 files changed, 118 insertions(+), 28 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f293e052e351..b8360ca221eb 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -962,11 +962,14 @@ cap_unix(struct cifs_ses *ses)
 
 struct cached_fid {
 	bool is_valid:1;	/* Do we have a useable root fid */
+	bool file_all_info_is_valid:1;
+
 	struct kref refcount;
 	struct cifs_fid *fid;
 	struct mutex fid_mutex;
 	struct cifs_tcon *tcon;
 	struct work_struct lease_break;
+	struct smb2_file_all_info file_all_info;
 };
 
 /*
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 01a76bccdb8d..b6e07e2eed10 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -309,12 +309,17 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		rc = open_shroot(xid, tcon, &fid);
 		if (rc)
 			goto out;
-		rc = SMB2_query_info(xid, tcon, fid.persistent_fid,
-				     fid.volatile_fid, smb2_data);
+
+		if (tcon->crfid.file_all_info_is_valid) {
+			move_smb2_info_to_cifs(data,
+					       &tcon->crfid.file_all_info);
+		} else {
+			rc = SMB2_query_info(xid, tcon, fid.persistent_fid,
+					     fid.volatile_fid, smb2_data);
+			if (!rc)
+				move_smb2_info_to_cifs(data, smb2_data);
+		}
 		close_shroot(&tcon->crfid);
-		if (rc)
-			goto out;
-		move_smb2_info_to_cifs(data, smb2_data);
 		goto out;
 	}
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 085e91436da7..5f2487e88c9d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -619,6 +619,7 @@ smb2_close_cached_fid(struct kref *ref)
 		SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
 			   cfid->fid->volatile_fid);
 		cfid->is_valid = false;
+		cfid->file_all_info_is_valid = false;
 	}
 }
 
@@ -643,9 +644,18 @@ smb2_cached_lease_break(struct work_struct *work)
  */
 int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 {
-	struct cifs_open_parms oparams;
-	int rc;
-	__le16 srch_path = 0; /* Null - since an open of top of share */
+	struct cifs_ses *ses = tcon->ses;
+	struct TCP_Server_Info *server = ses->server;
+	struct cifs_open_parms oparms;
+	struct smb2_create_rsp *o_rsp = NULL;
+	struct smb2_query_info_rsp *qi_rsp = NULL;
+	int resp_buftype[2];
+	struct smb_rqst rqst[2];
+	struct kvec rsp_iov[2];
+	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
+	struct kvec qi_iov[1];
+	int rc, flags = 0;
+	__le16 utf16_path = 0; /* Null - since an open of top of share */
 	u8 oplock = SMB2_OPLOCK_LEVEL_II;
 
 	mutex_lock(&tcon->crfid.fid_mutex);
@@ -657,22 +667,89 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
 		return 0;
 	}
 
-	oparams.tcon = tcon;
-	oparams.create_options = 0;
-	oparams.desired_access = FILE_READ_ATTRIBUTES;
-	oparams.disposition = FILE_OPEN;
-	oparams.fid = pfid;
-	oparams.reconnect = false;
-
-	rc = SMB2_open(xid, &oparams, &srch_path, &oplock, NULL, NULL, NULL);
-	if (rc == 0) {
-		memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
-		tcon->crfid.tcon = tcon;
-		tcon->crfid.is_valid = true;
-		kref_init(&tcon->crfid.refcount);
-		kref_get(&tcon->crfid.refcount);
-	}
+	if (smb3_encryption_required(tcon))
+		flags |= CIFS_TRANSFORM_REQ;
+
+	memset(rqst, 0, sizeof(rqst));
+	resp_buftype[0] = resp_buftype[1] = CIFS_NO_BUFFER;
+	memset(rsp_iov, 0, sizeof(rsp_iov));
+
+	/* Open */
+	memset(&open_iov, 0, sizeof(open_iov));
+	rqst[0].rq_iov = open_iov;
+	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
+
+	oparms.tcon = tcon;
+	oparms.create_options = 0;
+	oparms.desired_access = FILE_READ_ATTRIBUTES;
+	oparms.disposition = FILE_OPEN;
+	oparms.fid = pfid;
+	oparms.reconnect = false;
+
+	rc = SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, &utf16_path);
+	if (rc)
+		goto oshr_exit;
+	smb2_set_next_command(tcon, &rqst[0]);
+
+	memset(&qi_iov, 0, sizeof(qi_iov));
+	rqst[1].rq_iov = qi_iov;
+	rqst[1].rq_nvec = 1;
+
+	rc = SMB2_query_info_init(tcon, &rqst[1], COMPOUND_FID,
+				  COMPOUND_FID, FILE_ALL_INFORMATION,
+				  SMB2_O_INFO_FILE, 0,
+				  sizeof(struct smb2_file_all_info) +
+				  PATH_MAX * 2, 0, NULL);
+	if (rc)
+		goto oshr_exit;
+
+	smb2_set_related(&rqst[1]);
+
+	rc = compound_send_recv(xid, ses, flags, 2, rqst,
+				resp_buftype, rsp_iov);
+	if (rc)
+		goto oshr_exit;
+
+	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
+	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
+	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
+#ifdef CONFIG_CIFS_DEBUG2
+	oparms.fid->mid = le64_to_cpu(o_rsp->sync_hdr.MessageId);
+#endif /* CIFS_DEBUG2 */
+
+	if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE)
+		oplock = smb2_parse_lease_state(server, o_rsp,
+						&oparms.fid->epoch,
+						oparms.fid->lease_key);
+	else
+		goto oshr_exit;
+
+
+	memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
+	tcon->crfid.tcon = tcon;
+	tcon->crfid.is_valid = true;
+	kref_init(&tcon->crfid.refcount);
+	kref_get(&tcon->crfid.refcount);
+
+
+	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
+	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
+		goto oshr_exit;
+	rc = smb2_validate_and_copy_iov(
+				le16_to_cpu(qi_rsp->OutputBufferOffset),
+				sizeof(struct smb2_file_all_info),
+				&rsp_iov[1], sizeof(struct smb2_file_all_info),
+				(char *)&tcon->crfid.file_all_info);
+	if (rc)
+		goto oshr_exit;
+	tcon->crfid.file_all_info_is_valid = 1;
+
+ oshr_exit:
 	mutex_unlock(&tcon->crfid.fid_mutex);
+	SMB2_open_free(&rqst[0]);
+	SMB2_query_info_free(&rqst[1]);
+	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
+	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	return rc;
 }
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 60fbe306f604..cfe9fe41ccf5 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1797,9 +1797,10 @@ create_reconnect_durable_buf(struct cifs_fid *fid)
 	return buf;
 }
 
-static __u8
-parse_lease_state(struct TCP_Server_Info *server, struct smb2_create_rsp *rsp,
-		  unsigned int *epoch, char *lease_key)
+__u8
+smb2_parse_lease_state(struct TCP_Server_Info *server,
+		       struct smb2_create_rsp *rsp,
+		       unsigned int *epoch, char *lease_key)
 {
 	char *data_offset;
 	struct create_context *cc;
@@ -2456,8 +2457,9 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	}
 
 	if (rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE)
-		*oplock = parse_lease_state(server, rsp, &oparms->fid->epoch,
-					    oparms->fid->lease_key);
+		*oplock = smb2_parse_lease_state(server, rsp,
+						 &oparms->fid->epoch,
+						 oparms->fid->lease_key);
 	else
 		*oplock = rsp->OplockLevel;
 creat_exit:
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 87733b27a65f..72cc563c32fe 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -223,6 +223,9 @@ extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);
 
 extern enum securityEnum smb2_select_sectype(struct TCP_Server_Info *,
 					enum securityEnum);
+extern __u8 smb2_parse_lease_state(struct TCP_Server_Info *server,
+				   struct smb2_create_rsp *rsp,
+				   unsigned int *epoch, char *lease_key);
 extern int smb3_encryption_required(const struct cifs_tcon *tcon);
 extern int smb2_validate_iov(unsigned int offset, unsigned int buffer_length,
 			     struct kvec *iov, unsigned int min_buf_size);
-- 
2.13.6

