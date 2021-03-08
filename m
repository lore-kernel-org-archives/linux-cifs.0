Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32417C4361A
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C329652A4
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCHXI0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:08:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230460AbhCHXIB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 18:08:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615244881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=fD3+k/MsaAqe7vanPt2856Nv40cCFrPvn/hwPBMOt+8=;
        b=Di/1lTBUuw4VoLxw1LrOFUGlQe+ODLJeytB2XM25L9OloyYuXaqIgqMlwgj+F5RnbHZ2mN
        zDcEhUAapzXL/aC7GTb0ADE0Mh7/B6oBBp3DV97s+OZZgakItR3YnR8A4XBmPk1/1vBVt0
        JNGdEnHSFy2EaMnDIDO2xGwNmXHLJyc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-i-YmUoa5MyeC3-DTxbQHZA-1; Mon, 08 Mar 2021 18:07:59 -0500
X-MC-Unique: i-YmUoa5MyeC3-DTxbQHZA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BD92814314;
        Mon,  8 Mar 2021 23:07:58 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07B246085A;
        Mon,  8 Mar 2021 23:07:57 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 1/9] cifs: move the check for nohandlecache into open_shroot
Date:   Tue,  9 Mar 2021 09:07:27 +1000
Message-Id: <20210308230735.337-2-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-1-lsahlber@redhat.com>
References: <20210308230735.337-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

instead of doing it in the callsites for open_shroot.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2inode.c | 24 +++++++++++-------------
 fs/cifs/smb2ops.c   | 16 ++++++++--------
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 1f900b81c34a..3d59614cbe8f 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -511,7 +511,6 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	struct smb2_file_all_info *smb2_data;
 	__u32 create_options = 0;
-	bool no_cached_open = tcon->nohandlecache;
 	struct cifsFileInfo *cfile;
 	struct cached_fid *cfid = NULL;
 
@@ -524,23 +523,22 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOMEM;
 
 	/* If it is a root and its handle is cached then use it */
-	if (!strlen(full_path) && !no_cached_open) {
+	if (!strlen(full_path)) {
 		rc = open_shroot(xid, tcon, cifs_sb, &cfid);
-		if (rc)
-			goto out;
-
-		if (tcon->crfid.file_all_info_is_valid) {
-			move_smb2_info_to_cifs(data,
+		if (!rc) {
+			if (tcon->crfid.file_all_info_is_valid) {
+				move_smb2_info_to_cifs(data,
 					       &tcon->crfid.file_all_info);
-		} else {
-			rc = SMB2_query_info(xid, tcon,
+			} else {
+				rc = SMB2_query_info(xid, tcon,
 					     cfid->fid->persistent_fid,
 					     cfid->fid->volatile_fid, smb2_data);
-			if (!rc)
-				move_smb2_info_to_cifs(data, smb2_data);
+				if (!rc)
+					move_smb2_info_to_cifs(data, smb2_data);
+			}
+			close_shroot(cfid);
+			goto out;
 		}
-		close_shroot(cfid);
-		goto out;
 	}
 
 	cifs_get_readable_path(tcon, full_path, &cfile);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f5087295424c..7ee6926153b8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -746,6 +746,9 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
 	u8 oplock = SMB2_OPLOCK_LEVEL_II;
 	struct cifs_fid *pfid;
 
+	if (tcon->nohandlecache)
+		return -ENOTSUPP;
+
 	mutex_lock(&tcon->crfid.fid_mutex);
 	if (tcon->crfid.is_valid) {
 		cifs_dbg(FYI, "found a cached root file handle\n");
@@ -914,7 +917,6 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
-	bool no_cached_open = tcon->nohandlecache;
 	struct cached_fid *cfid = NULL;
 
 	oparms.tcon = tcon;
@@ -924,14 +926,12 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid = &fid;
 	oparms.reconnect = false;
 
-	if (no_cached_open) {
+	rc = open_shroot(xid, tcon, cifs_sb, &cfid);
+	if (rc == 0)
+		memcpy(&fid, cfid->fid, sizeof(struct cifs_fid));
+	else
 		rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
 			       NULL, NULL);
-	} else {
-		rc = open_shroot(xid, tcon, cifs_sb, &cfid);
-		if (rc == 0)
-			memcpy(&fid, cfid->fid, sizeof(struct cifs_fid));
-	}
 	if (rc)
 		return;
 
@@ -945,7 +945,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 			FS_VOLUME_INFORMATION);
 	SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
 			FS_SECTOR_SIZE_INFORMATION); /* SMB3 specific */
-	if (no_cached_open)
+	if (cfid == NULL)
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	else
 		close_shroot(cfid);
-- 
2.13.6

