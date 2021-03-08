Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2EAC433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EBE16529C
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhCHXHx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:07:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhCHXHu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 18:07:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615244870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=vPScEQVToWeWYSQZ6qRplx5pZyMNo8DfrEbKPjr7sps=;
        b=VGG/GFna6Ewr+rI43BIdyu2+9azoLyN0z1jz46Zev7TpdtX7U5GEQ1SoHuPicwByacwo9Q
        ngY9TSdQ9QxKiUzf5vlYGRuyVQWwAr5MndDzZJXydvhrouO43DmZbwBau/uZC2uYDWBrr8
        dfLBq4ViVJgybylBfxS865VsGkAXz00=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-B6ha9cDuP1Sw1elI9rFLUg-1; Mon, 08 Mar 2021 18:07:48 -0500
X-MC-Unique: B6ha9cDuP1Sw1elI9rFLUg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77BCF1823E37;
        Mon,  8 Mar 2021 23:07:47 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8D675C5E1;
        Mon,  8 Mar 2021 23:07:46 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 3/9] cifs: rename the *_shroot* functions to *_cached_dir*
Date:   Tue,  9 Mar 2021 09:07:29 +1000
Message-Id: <20210308230735.337-4-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-1-lsahlber@redhat.com>
References: <20210308230735.337-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

These functions will eventually be used to cache any directory, not just the root
so change the names.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifssmb.c   |  2 +-
 fs/cifs/smb2inode.c |  4 ++--
 fs/cifs/smb2ops.c   | 19 ++++++++++---------
 fs/cifs/smb2pdu.c   |  2 +-
 fs/cifs/smb2proto.h | 14 +++++++-------
 5 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 0496934feecb..3419289b7663 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -114,7 +114,7 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	mutex_lock(&tcon->crfid.fid_mutex);
 	tcon->crfid.is_valid = false;
 	/* cached handle is not valid, so SMB2_CLOSE won't be sent below */
-	close_shroot_lease_locked(&tcon->crfid);
+	close_cached_dir_lease_locked(&tcon->crfid);
 	memset(tcon->crfid.fid, 0, sizeof(struct cifs_fid));
 	mutex_unlock(&tcon->crfid.fid_mutex);
 
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 67f80c9561fc..0d0bc0b878be 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -523,7 +523,7 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOMEM;
 
 	/* If it is a root and its handle is cached then use it */
-	rc = open_shroot(xid, tcon, full_path, cifs_sb, &cfid);
+	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
 	if (!rc) {
 		if (tcon->crfid.file_all_info_is_valid) {
 			move_smb2_info_to_cifs(data,
@@ -535,7 +535,7 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 			if (!rc)
 				move_smb2_info_to_cifs(data, smb2_data);
 		}
-		close_shroot(cfid);
+		close_cached_dir(cfid);
 		goto out;
 	}
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 96ff946674e6..d2858c25ff17 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -693,14 +693,14 @@ smb2_close_cached_fid(struct kref *ref)
 	}
 }
 
-void close_shroot(struct cached_fid *cfid)
+void close_cached_dir(struct cached_fid *cfid)
 {
 	mutex_lock(&cfid->fid_mutex);
 	kref_put(&cfid->refcount, smb2_close_cached_fid);
 	mutex_unlock(&cfid->fid_mutex);
 }
 
-void close_shroot_lease_locked(struct cached_fid *cfid)
+void close_cached_dir_lease_locked(struct cached_fid *cfid)
 {
 	if (cfid->has_lease) {
 		cfid->has_lease = false;
@@ -708,10 +708,10 @@ void close_shroot_lease_locked(struct cached_fid *cfid)
 	}
 }
 
-void close_shroot_lease(struct cached_fid *cfid)
+void close_cached_dir_lease(struct cached_fid *cfid)
 {
 	mutex_lock(&cfid->fid_mutex);
-	close_shroot_lease_locked(cfid);
+	close_cached_dir_lease_locked(cfid);
 	mutex_unlock(&cfid->fid_mutex);
 }
 
@@ -721,13 +721,14 @@ smb2_cached_lease_break(struct work_struct *work)
 	struct cached_fid *cfid = container_of(work,
 				struct cached_fid, lease_break);
 
-	close_shroot_lease(cfid);
+	close_cached_dir_lease(cfid);
 }
 
 /*
- * Open the directory at the root of a share
+ * Open the and cache a directory handle.
+ * Only supported for the root handle.
  */
-int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
+int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		const char *path,
 		struct cifs_sb_info *cifs_sb,
 		struct cached_fid **cfid)
@@ -930,7 +931,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	rc = open_shroot(xid, tcon, "", cifs_sb, &cfid);
+	rc = open_cached_dir(xid, tcon, "", cifs_sb, &cfid);
 	if (rc == 0)
 		memcpy(&fid, cfid->fid, sizeof(struct cifs_fid));
 	else
@@ -952,7 +953,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	if (cfid == NULL)
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	else
-		close_shroot(cfid);
+		close_cached_dir(cfid);
 }
 
 static void
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 4bbb6126b14d..0a03f8d88173 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1857,7 +1857,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	if ((tcon->need_reconnect) || (tcon->ses->need_reconnect))
 		return 0;
 
-	close_shroot_lease(&tcon->crfid);
+	close_cached_dir_lease(&tcon->crfid);
 
 	rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, ses->server,
 				 (void **) &req,
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 7e4fc69c8b01..ddbdf9923625 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -69,13 +69,13 @@ extern struct cifs_ses *smb2_find_smb_ses(struct TCP_Server_Info *server,
 extern int smb3_handle_read_data(struct TCP_Server_Info *server,
 				 struct mid_q_entry *mid);
 
-extern int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
-		       const char *path,
-		       struct cifs_sb_info *cifs_sb,
-		       struct cached_fid **cfid);
-extern void close_shroot(struct cached_fid *cfid);
-extern void close_shroot_lease(struct cached_fid *cfid);
-extern void close_shroot_lease_locked(struct cached_fid *cfid);
+extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
+			   const char *path,
+			   struct cifs_sb_info *cifs_sb,
+			   struct cached_fid **cfid);
+extern void close_cached_dir(struct cached_fid *cfid);
+extern void close_cached_dir_lease(struct cached_fid *cfid);
+extern void close_cached_dir_lease_locked(struct cached_fid *cfid);
 extern void move_smb2_info_to_cifs(FILE_ALL_INFO *dst,
 				   struct smb2_file_all_info *src);
 extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
-- 
2.13.6

