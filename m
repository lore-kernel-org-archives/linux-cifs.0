Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22560C43381
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE82A652B7
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhCHXI0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:08:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56164 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230457AbhCHXH6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 18:07:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615244878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=AVxGdr7lDl56PxhdLiS/DNr7Pme1x2/5gez8xA/7O4E=;
        b=asaQt/u/VSjpau/6cthT6WpbSR7s9poj1rXc4Rl7UijY9dZZb5P47B/mPEp0mxqjtrthVR
        JqVQBgW4dPF30poTlmyWdRWaXCBQ+T3LWy5hZdVCNlG6uXa9QGFwgQ4pLXoS4Ap42taD83
        KqoZgCBBfczscHbknfaPucHkNHb1/No=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-vcw2LaBYOQab_Nlkfsp5_Q-1; Mon, 08 Mar 2021 18:07:56 -0500
X-MC-Unique: vcw2LaBYOQab_Nlkfsp5_Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 185C21823E44;
        Mon,  8 Mar 2021 23:07:55 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 787321A8A3;
        Mon,  8 Mar 2021 23:07:54 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 2/9] cifs: pass a path to open_shroot and check if it is the root or not
Date:   Tue,  9 Mar 2021 09:07:28 +1000
Message-Id: <20210308230735.337-3-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-1-lsahlber@redhat.com>
References: <20210308230735.337-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Move the check for the directory path into the open_shroot() function
but still fail for any non-root directories.
This is preparation for later when we will start using the cache also
for other directories than the root.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2inode.c | 22 ++++++++++------------
 fs/cifs/smb2ops.c   |  6 +++++-
 fs/cifs/smb2proto.h |  1 +
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 3d59614cbe8f..67f80c9561fc 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -523,22 +523,20 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOMEM;
 
 	/* If it is a root and its handle is cached then use it */
-	if (!strlen(full_path)) {
-		rc = open_shroot(xid, tcon, cifs_sb, &cfid);
-		if (!rc) {
-			if (tcon->crfid.file_all_info_is_valid) {
-				move_smb2_info_to_cifs(data,
+	rc = open_shroot(xid, tcon, full_path, cifs_sb, &cfid);
+	if (!rc) {
+		if (tcon->crfid.file_all_info_is_valid) {
+			move_smb2_info_to_cifs(data,
 					       &tcon->crfid.file_all_info);
-			} else {
-				rc = SMB2_query_info(xid, tcon,
+		} else {
+			rc = SMB2_query_info(xid, tcon,
 					     cfid->fid->persistent_fid,
 					     cfid->fid->volatile_fid, smb2_data);
-				if (!rc)
-					move_smb2_info_to_cifs(data, smb2_data);
-			}
-			close_shroot(cfid);
-			goto out;
+			if (!rc)
+				move_smb2_info_to_cifs(data, smb2_data);
 		}
+		close_shroot(cfid);
+		goto out;
 	}
 
 	cifs_get_readable_path(tcon, full_path, &cfile);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 7ee6926153b8..96ff946674e6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -728,6 +728,7 @@ smb2_cached_lease_break(struct work_struct *work)
  * Open the directory at the root of a share
  */
 int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
+		const char *path,
 		struct cifs_sb_info *cifs_sb,
 		struct cached_fid **cfid)
 {
@@ -749,6 +750,9 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
 	if (tcon->nohandlecache)
 		return -ENOTSUPP;
 
+	if (strlen(path))
+		return -ENOTSUPP;
+
 	mutex_lock(&tcon->crfid.fid_mutex);
 	if (tcon->crfid.is_valid) {
 		cifs_dbg(FYI, "found a cached root file handle\n");
@@ -926,7 +930,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	rc = open_shroot(xid, tcon, cifs_sb, &cfid);
+	rc = open_shroot(xid, tcon, "", cifs_sb, &cfid);
 	if (rc == 0)
 		memcpy(&fid, cfid->fid, sizeof(struct cifs_fid));
 	else
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 9565e27681a5..7e4fc69c8b01 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -70,6 +70,7 @@ extern int smb3_handle_read_data(struct TCP_Server_Info *server,
 				 struct mid_q_entry *mid);
 
 extern int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
+		       const char *path,
 		       struct cifs_sb_info *cifs_sb,
 		       struct cached_fid **cfid);
 extern void close_shroot(struct cached_fid *cfid);
-- 
2.13.6

