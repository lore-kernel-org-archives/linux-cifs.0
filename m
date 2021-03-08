Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6916C432C3
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9B4C652AD
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhCHXI1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:08:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231126AbhCHXIG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 18:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615244885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=no5NsuOA8XUrKAX3gcb2zK9l8qYmpCZDnx9e6UlyZwY=;
        b=Bkcn+Q+c+ujrFVRhIpFjmBTMcxcPt7W27uC2a+6b+7ihpSCIFBJ5NEXG4ZiRGhUQPXpqhs
        EErUwU2cvNsaWkihhV9VtcrRBaJN7Zk4ZT6+tMilSHhdV+s+7/T8tHOSJ558SF15TKRAzK
        TYSgOM5SuRB9E/RuwD/9SnMZDBJ47aQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-oe6y8tVsONm8uSTQHHk8SA-1; Mon, 08 Mar 2021 18:08:01 -0500
X-MC-Unique: oe6y8tVsONm8uSTQHHk8SA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D444E801814;
        Mon,  8 Mar 2021 23:08:00 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CAAE1A8A6;
        Mon,  8 Mar 2021 23:08:00 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 4/9] cifs: store a pointer to the root dentry in cifs_sb_info once we have completed mounting the share
Date:   Tue,  9 Mar 2021 09:07:30 +1000
Message-Id: <20210308230735.337-5-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-1-lsahlber@redhat.com>
References: <20210308230735.337-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

And use this to only allow to take out a shared handle once the mount has completed and the
sb becomes available.
This will become important in follow up patches where we will start holding a reference to the
directory dentry for the shared handle during the lifetime of the handle.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifs_fs_sb.h | 4 ++++
 fs/cifs/cifsfs.c     | 9 +++++++++
 fs/cifs/smb2ops.c    | 5 ++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index aa77edc12212..2a5325a7ae49 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -81,5 +81,9 @@ struct cifs_sb_info {
 	 * (cifs_autodisable_serverino) in order to match new mounts.
 	 */
 	bool mnt_cifs_serverino_autodisabled;
+	/*
+	 * Available once the mount has completed.
+	 */
+	struct dentry *root;
 };
 #endif				/* _CIFS_FS_SB_H */
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 3b61f09f3e1b..c075ef1dd755 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -257,6 +257,12 @@ cifs_read_super(struct super_block *sb)
 static void cifs_kill_sb(struct super_block *sb)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+
+	if (cifs_sb->root) {
+		dput(cifs_sb->root);
+		cifs_sb->root = NULL;
+	}
+
 	kill_anon_super(sb);
 	cifs_umount(cifs_sb);
 }
@@ -886,6 +892,9 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
 	if (IS_ERR(root))
 		goto out_super;
 
+	if (cifs_sb)
+		cifs_sb->root = dget(root);
+
 	cifs_dbg(FYI, "dentry root is: %p\n", root);
 	return root;
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d2858c25ff17..7f4da573b9e8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -751,8 +751,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (tcon->nohandlecache)
 		return -ENOTSUPP;
 
+	if (cifs_sb->root == NULL)
+		return -ENOENT;
+
 	if (strlen(path))
-		return -ENOTSUPP;
+		return -ENOENT;
 
 	mutex_lock(&tcon->crfid.fid_mutex);
 	if (tcon->crfid.is_valid) {
-- 
2.13.6

