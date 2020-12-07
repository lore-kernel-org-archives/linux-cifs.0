Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894DDC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A69C23998
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgLGXik (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:38:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49239 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbgLGXij (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:38:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=g0eUIybogY4b3kym9KpqfjhVZB4CgPmYav1ks7rECHU=;
        b=HNofzgcDUjL+72LtU/rHaSqHLkuimlZ/9Z5yIQ6P6bkWKC7fXGVS8ajeIkk7YO+S05++EI
        722mit2Mj9hVWM5z8hrBn0zqhlCkjPHE3gkzbGrP0xA4f5aRIIcnEqmP4qRYx2T1LPikPc
        OCU3XClvToLTuLiBFysJ8j9mTOv/5CA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-JNThvJORNSCJRfiIVu_pEg-1; Mon, 07 Dec 2020 18:37:10 -0500
X-MC-Unique: JNThvJORNSCJRfiIVu_pEg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DB0F1005504;
        Mon,  7 Dec 2020 23:37:09 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B28C19C59;
        Mon,  7 Dec 2020 23:37:08 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 20/21] cifs: move update of flags into a separate function
Date:   Tue,  8 Dec 2020 09:36:45 +1000
Message-Id: <20201207233646.29823-20-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This funciton will set/clear flags that can be changed during mount or remount

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c    |  74 +-----------------------
 fs/cifs/fs_context.c | 155 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/fs_context.h |   1 +
 3 files changed, 159 insertions(+), 71 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3775f049e3ba..d5798bb8028a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2684,61 +2684,10 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 	}
 	ctx->local_nls = cifs_sb->local_nls;
 
-	if (ctx->nodfs)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_DFS;
-	if (ctx->noperm)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_PERM;
-	if (ctx->setuids)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_SET_UID;
-	if (ctx->setuidfromacl)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_UID_FROM_ACL;
-	if (ctx->server_ino)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_SERVER_INUM;
-	if (ctx->remap)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MAP_SFM_CHR;
-	if (ctx->sfu_remap)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MAP_SPECIAL_CHR;
-	if (ctx->no_xattr)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_XATTR;
-	if (ctx->sfu_emul)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_UNX_EMUL;
-	if (ctx->nobrl)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_BRL;
-	if (ctx->nohandlecache)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_HANDLE_CACHE;
-	if (ctx->nostrictsync)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOSSYNC;
-	if (ctx->mand_lock)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOPOSIXBRL;
-	if (ctx->rwpidforward)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RWPIDFORWARD;
-	if (ctx->mode_ace)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MODE_FROM_SID;
-	if (ctx->cifs_acl)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_ACL;
-	if (ctx->backupuid_specified) {
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPUID;
-	}
-	if (ctx->backupgid_specified) {
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPGID;
-	}
-	if (ctx->override_uid)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_UID;
-	if (ctx->override_gid)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_GID;
-	if (ctx->dynperm)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DYNPERM;
-	if (ctx->fsc)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_FSCACHE;
-	if (ctx->multiuser)
-		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_MULTIUSER |
-					    CIFS_MOUNT_NO_PERM);
-	if (ctx->strict_io)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_STRICT_IO;
-	if (ctx->direct_io) {
+	smb3_update_mnt_flags(cifs_sb);
+
+	if (ctx->direct_io)
 		cifs_dbg(FYI, "mounting share using direct i/o\n");
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
-	}
 	if (ctx->cache_ro) {
 		cifs_dbg(VFS, "mounting share with read only caching. Ensure that the share will not be modified while in use.\n");
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RO_CACHE;
@@ -2747,23 +2696,6 @@ int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb)
 		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_RO_CACHE |
 					    CIFS_MOUNT_RW_CACHE);
 	}
-	if (ctx->mfsymlinks) {
-		if (ctx->sfu_emul) {
-			/*
-			 * Our SFU ("Services for Unix" emulation does not allow
-			 * creating symlinks but does allow reading existing SFU
-			 * symlinks (it does allow both creating and reading SFU
-			 * style mknod and FIFOs though). When "mfsymlinks" and
-			 * "sfu" are both enabled at the same time, it allows
-			 * reading both types of symlinks, but will only create
-			 * them with mfsymlinks format. This allows better
-			 * Apple compatibility (probably better for Samba too)
-			 * while still recognizing old Windows style symlinks.
-			 */
-			cifs_dbg(VFS, "mount options mfsymlinks and sfu both enabled\n");
-		}
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MF_SYMLINKS;
-	}
 
 	if ((ctx->cifs_acl) && (ctx->dynperm))
 		cifs_dbg(VFS, "mount option dynperm ignored if cifsacl mount option supported\n");
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index ee9c1fb666c7..bf5a25b930d5 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1352,3 +1352,158 @@ smb3_cleanup_fs_context(struct smb3_fs_context *ctx)
 	smb3_cleanup_fs_context_contents(ctx);
 	kfree(ctx);
 }
+
+void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb)
+{
+	struct smb3_fs_context *ctx = cifs_sb->ctx;
+
+	if (ctx->nodfs)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_DFS;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_DFS;
+
+	if (ctx->noperm)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_PERM;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_PERM;
+
+	if (ctx->setuids)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_SET_UID;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SET_UID;
+
+	if (ctx->setuidfromacl)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_UID_FROM_ACL;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_UID_FROM_ACL;
+
+	if (ctx->server_ino)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_SERVER_INUM;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
+
+	if (ctx->remap)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MAP_SFM_CHR;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MAP_SFM_CHR;
+
+	if (ctx->sfu_remap)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MAP_SPECIAL_CHR;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MAP_SPECIAL_CHR;
+
+	if (ctx->no_xattr)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_XATTR;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_XATTR;
+
+	if (ctx->sfu_emul)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_UNX_EMUL;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_UNX_EMUL;
+
+	if (ctx->nobrl)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_BRL;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_BRL;
+
+	if (ctx->nohandlecache)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_HANDLE_CACHE;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NO_HANDLE_CACHE;
+
+	if (ctx->nostrictsync)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOSSYNC;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NOSSYNC;
+
+	if (ctx->mand_lock)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOPOSIXBRL;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_NOPOSIXBRL;
+
+	if (ctx->rwpidforward)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RWPIDFORWARD;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_RWPIDFORWARD;
+
+	if (ctx->mode_ace)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MODE_FROM_SID;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MODE_FROM_SID;
+
+	if (ctx->cifs_acl)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_ACL;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_CIFS_ACL;
+
+	if (ctx->backupuid_specified)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPUID;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_CIFS_BACKUPUID;
+
+	if (ctx->backupgid_specified)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_BACKUPGID;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_CIFS_BACKUPGID;
+
+	if (ctx->override_uid)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_UID;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_OVERR_UID;
+
+	if (ctx->override_gid)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_GID;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_OVERR_GID;
+
+	if (ctx->dynperm)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DYNPERM;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_DYNPERM;
+
+	if (ctx->fsc)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_FSCACHE;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_FSCACHE;
+
+	if (ctx->multiuser)
+		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_MULTIUSER |
+					    CIFS_MOUNT_NO_PERM);
+	else
+		cifs_sb->mnt_cifs_flags &= ~(CIFS_MOUNT_MULTIUSER |
+					     CIFS_MOUNT_NO_PERM);
+
+	if (ctx->strict_io)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_STRICT_IO;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_STRICT_IO;
+
+	if (ctx->direct_io)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_DIRECT_IO;
+
+	if (ctx->mfsymlinks)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MF_SYMLINKS;
+	else
+		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_MF_SYMLINKS;
+	if (ctx->mfsymlinks) {
+		if (ctx->sfu_emul) {
+			/*
+			 * Our SFU ("Services for Unix" emulation does not allow
+			 * creating symlinks but does allow reading existing SFU
+			 * symlinks (it does allow both creating and reading SFU
+			 * style mknod and FIFOs though). When "mfsymlinks" and
+			 * "sfu" are both enabled at the same time, it allows
+			 * reading both types of symlinks, but will only create
+			 * them with mfsymlinks format. This allows better
+			 * Apple compatibility (probably better for Samba too)
+			 * while still recognizing old Windows style symlinks.
+			 */
+			cifs_dbg(VFS, "mount options mfsymlinks and sfu both enabled\n");
+		}
+	}
+
+	return;
+}
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index c2aadf3ad091..efc7ac2783fa 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -265,5 +265,6 @@ static inline struct smb3_fs_context *smb3_fc2context(const struct fs_context *f
 }
 
 extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx);
+extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
 
 #endif
-- 
2.13.6

