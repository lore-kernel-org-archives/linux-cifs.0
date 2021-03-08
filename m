Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54135C4361B
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BBA864EEB
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhCHXI0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:08:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230343AbhCHXIA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 18:08:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615244880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=zna/7Vms2Vhrs3mK9TzMyvMz/ZPu5E5/6bUbYn0zO/U=;
        b=PZyeVmWjVbUw8b66/2g9ZDAd4J6/Ge1QK0pltagHr+lRmSK4oGKlKYuHpvhwJd4S9TUPdl
        5m6Gdg8JqwBvtKGr5UVlEMsrTGd6GqXBmytxsxg1GSHa4T1DUv2xws69wtufYmqh0gQSjl
        +b2Fnj9RCWOl7p2zc4Z6yqo2NZhUAG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-hBRWTDhtM4GAbPWP_CM2Fw-1; Mon, 08 Mar 2021 18:07:57 -0500
X-MC-Unique: hBRWTDhtM4GAbPWP_CM2Fw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D43FF1823E24;
        Mon,  8 Mar 2021 23:07:56 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FB846085A;
        Mon,  8 Mar 2021 23:07:56 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 5/9] cifs: Grab a reference for the dentry of the cached directory during the lifetime of the cache
Date:   Tue,  9 Mar 2021 09:07:31 +1000
Message-Id: <20210308230735.337-6-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-1-lsahlber@redhat.com>
References: <20210308230735.337-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We need to hold both a reference for the root/superblock as well as the directory that we
are caching. We need to drop these references before we call kill_anon_sb().

At this point, the root and the cached dentries are always the same but this will change
once we start caching other directories as well.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c   | 17 +++++++++++++++++
 fs/cifs/cifsglob.h |  1 +
 fs/cifs/smb2ops.c  |  9 +++++++++
 3 files changed, 27 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c075ef1dd755..154f1c94ea46 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -257,11 +257,28 @@ cifs_read_super(struct super_block *sb)
 static void cifs_kill_sb(struct super_block *sb)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifs_tcon *tcon;
+	struct cached_fid *cfid;
 
+	/*
+	 * We ned to release all dentries for the cached directories
+	 * before we kill the sb.
+	 */
 	if (cifs_sb->root) {
 		dput(cifs_sb->root);
 		cifs_sb->root = NULL;
 	}
+	tcon = cifs_sb_master_tcon(cifs_sb);
+	if (tcon) {
+		cfid = &tcon->crfid;
+		mutex_lock(&cfid->fid_mutex);
+		if (cfid->dentry) {
+
+			dput(cfid->dentry);
+			cfid->dentry = NULL;
+		}
+		mutex_unlock(&cfid->fid_mutex);
+	}
 
 	kill_anon_super(sb);
 	cifs_umount(cifs_sb);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3de3c5908a72..7d9b47f2f04f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -992,6 +992,7 @@ struct cached_fid {
 	struct cifs_fid *fid;
 	struct mutex fid_mutex;
 	struct cifs_tcon *tcon;
+	struct dentry *dentry;
 	struct work_struct lease_break;
 	struct smb2_file_all_info file_all_info;
 };
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 7f4da573b9e8..81eb7f10368b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -690,6 +690,10 @@ smb2_close_cached_fid(struct kref *ref)
 		cfid->is_valid = false;
 		cfid->file_all_info_is_valid = false;
 		cfid->has_lease = false;
+		if (cfid->dentry) {
+			dput(cfid->dentry);
+			cfid->dentry = NULL;
+		}
 	}
 }
 
@@ -747,6 +751,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	__le16 utf16_path = 0; /* Null - since an open of top of share */
 	u8 oplock = SMB2_OPLOCK_LEVEL_II;
 	struct cifs_fid *pfid;
+	struct dentry *dentry;
 
 	if (tcon->nohandlecache)
 		return -ENOTSUPP;
@@ -757,6 +762,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (strlen(path))
 		return -ENOENT;
 
+	dentry = cifs_sb->root;
+
 	mutex_lock(&tcon->crfid.fid_mutex);
 	if (tcon->crfid.is_valid) {
 		cifs_dbg(FYI, "found a cached root file handle\n");
@@ -881,6 +888,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
 	tcon->crfid.tcon = tcon;
 	tcon->crfid.is_valid = true;
+	tcon->crfid.dentry = dentry;
+	dget(dentry);
 	kref_init(&tcon->crfid.refcount);
 
 	/* BB TBD check to see if oplock level check can be removed below */
-- 
2.13.6

