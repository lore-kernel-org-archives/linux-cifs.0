Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271ACC4361B
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E75FD23A21
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgLGXkw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:40:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbgLGXkw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:40:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=HSpR0N/a+IoMhIvg7PUDe4ierO8tdchPrciIFHcEp9w=;
        b=MLl+amRIXJiNwPMBsaEu/TR5YDq+31T+HgiaJAgC9fwv4G6emFHr9Gg1HMeegbPNIfud9h
        dT4IHKo8tAmJrl6fag6zXgreBGByJ7qeAUBnw2BGiTHoDEPuXNoHNEm06oxnFpwWvzp5/S
        EjFFVam4RMAnvAV/bi/5U3C/7DWFCiQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-j8wWvn2MMnWpJXhW80f4wA-1; Mon, 07 Dec 2020 18:39:23 -0500
X-MC-Unique: j8wWvn2MMnWpJXhW80f4wA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68DA9107ACE3;
        Mon,  7 Dec 2020 23:39:22 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 764C360C05;
        Mon,  7 Dec 2020 23:39:21 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 12/21] cifs: move [brw]size from cifs_sb to cifs_sb->ctx
Date:   Tue,  8 Dec 2020 09:36:37 +1000
Message-Id: <20201207233646.29823-12-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifs_fs_sb.h |  3 ---
 fs/cifs/cifsfs.c     | 11 +++++++----
 fs/cifs/connect.c    | 21 +++++++++------------
 fs/cifs/file.c       | 12 ++++++------
 fs/cifs/fs_context.c |  3 +++
 fs/cifs/fs_context.h |  3 +++
 fs/cifs/inode.c      |  2 +-
 fs/cifs/smb1ops.c    |  2 +-
 fs/cifs/smb2ops.c    |  2 +-
 9 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 69d26313d350..aa77edc12212 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -62,9 +62,6 @@ struct cifs_sb_info {
 	struct tcon_link *master_tlink;
 	struct nls_table *local_nls;
 	struct smb3_fs_context *ctx;
-	unsigned int bsize;
-	unsigned int rsize;
-	unsigned int wsize;
 	atomic_t active;
 	unsigned int mnt_cifs_flags;
 	struct delayed_work prune_tlinks;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 0288632233f6..80117e9d35f9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -215,7 +215,7 @@ cifs_read_super(struct super_block *sb)
 	if (rc)
 		goto out_no_root;
 	/* tune readahead according to rsize */
-	sb->s_bdi->ra_pages = cifs_sb->rsize / PAGE_SIZE;
+	sb->s_bdi->ra_pages = cifs_sb->ctx->rsize / PAGE_SIZE;
 
 	sb->s_blocksize = CIFS_MAX_MSGSIZE;
 	sb->s_blocksize_bits = 14;	/* default 2**14 = CIFS_MAX_MSGSIZE */
@@ -612,9 +612,12 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 			   from_kgid_munged(&init_user_ns,
 					    cifs_sb->ctx->backupgid));
 
-	seq_printf(s, ",rsize=%u", cifs_sb->rsize);
-	seq_printf(s, ",wsize=%u", cifs_sb->wsize);
-	seq_printf(s, ",bsize=%u", cifs_sb->bsize);
+	if (cifs_sb->ctx->got_rsize)
+		seq_printf(s, ",rsize=%u", cifs_sb->ctx->rsize);
+	if (cifs_sb->ctx->got_wsize)
+		seq_printf(s, ",wsize=%u", cifs_sb->ctx->wsize);
+	if (cifs_sb->ctx->got_bsize)
+		seq_printf(s, ",bsize=%u", cifs_sb->ctx->bsize);
 	if (tcon->ses->server->min_offload)
 		seq_printf(s, ",esize=%u", tcon->ses->server->min_offload);
 	seq_printf(s, ",echo_interval=%lu",
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 054cb09b8087..f28067696a2c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2219,10 +2219,10 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 	 * We want to share sb only if we don't specify an r/wsize or
 	 * specified r/wsize is greater than or equal to existing one.
 	 */
-	if (new->wsize && new->wsize < old->wsize)
+	if (new->ctx->wsize && new->ctx->wsize < old->ctx->wsize)
 		return 0;
 
-	if (new->rsize && new->rsize < old->rsize)
+	if (new->ctx->rsize && new->ctx->rsize < old->ctx->rsize)
 		return 0;
 
 	if (!uid_eq(old->ctx->linux_uid, new->ctx->linux_uid) ||
@@ -2671,14 +2671,6 @@ int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
 	spin_lock_init(&cifs_sb->tlink_tree_lock);
 	cifs_sb->tlink_tree = RB_ROOT;
 
-	cifs_sb->bsize = ctx->bsize;
-	/*
-	 * Temporarily set r/wsize for matching superblock. If we end up using
-	 * new sb then client will later negotiate it downward if needed.
-	 */
-	cifs_sb->rsize = ctx->rsize;
-	cifs_sb->wsize = ctx->wsize;
-
 	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
 		 cifs_sb->ctx->file_mode, cifs_sb->ctx->dir_mode);
 
@@ -2882,8 +2874,13 @@ static int mount_get_conns(struct smb3_fs_context *ctx, struct cifs_sb_info *cif
 		}
 	}
 
-	cifs_sb->wsize = server->ops->negotiate_wsize(tcon, ctx);
-	cifs_sb->rsize = server->ops->negotiate_rsize(tcon, ctx);
+	/*
+	 * Clamp the rsize/wsize mount arguments if they are too big for the server
+	 */
+	if (cifs_sb->ctx->wsize > server->ops->negotiate_wsize(tcon, ctx))
+		cifs_sb->ctx->wsize = server->ops->negotiate_wsize(tcon, ctx);
+	if (cifs_sb->ctx->rsize > server->ops->negotiate_rsize(tcon, ctx))
+		cifs_sb->ctx->rsize = server->ops->negotiate_rsize(tcon, ctx);
 
 	return 0;
 }
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 3ee510d3dab8..2bcbb142ffbd 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2331,7 +2331,7 @@ static int cifs_writepages(struct address_space *mapping,
 	 * If wsize is smaller than the page cache size, default to writing
 	 * one page at a time via cifs_writepage
 	 */
-	if (cifs_sb->wsize < PAGE_SIZE)
+	if (cifs_sb->ctx->wsize < PAGE_SIZE)
 		return generic_writepages(mapping, wbc);
 
 	xid = get_xid();
@@ -2364,7 +2364,7 @@ static int cifs_writepages(struct address_space *mapping,
 		if (rc)
 			get_file_rc = rc;
 
-		rc = server->ops->wait_mtu_credits(server, cifs_sb->wsize,
+		rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->wsize,
 						   &wsize, credits);
 		if (rc != 0) {
 			done = true;
@@ -2906,7 +2906,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 				break;
 		}
 
-		rc = server->ops->wait_mtu_credits(server, cifs_sb->wsize,
+		rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->wsize,
 						   &wsize, credits);
 		if (rc)
 			break;
@@ -3637,7 +3637,7 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 				break;
 		}
 
-		rc = server->ops->wait_mtu_credits(server, cifs_sb->rsize,
+		rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
 						   &rsize, credits);
 		if (rc)
 			break;
@@ -4023,7 +4023,7 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
 	cifs_sb = CIFS_FILE_SB(file);
 
 	/* FIXME: set up handlers for larger reads and/or convert to async */
-	rsize = min_t(unsigned int, cifs_sb->rsize, CIFSMaxBufSize);
+	rsize = min_t(unsigned int, cifs_sb->ctx->rsize, CIFSMaxBufSize);
 
 	if (file->private_data == NULL) {
 		rc = -EBADF;
@@ -4408,7 +4408,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 				break;
 		}
 
-		rc = server->ops->wait_mtu_credits(server, cifs_sb->rsize,
+		rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
 						   &rsize, credits);
 		if (rc)
 			break;
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 8b74b87d7af7..752b7da43f4c 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -781,12 +781,15 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			goto cifs_parse_mount_err;
 		}
 		ctx->bsize = result.uint_32;
+		ctx->got_bsize = true;
 		break;
 	case Opt_rsize:
 		ctx->rsize = result.uint_32;
+		ctx->got_rsize = true;
 		break;
 	case Opt_wsize:
 		ctx->wsize = result.uint_32;
+		ctx->got_wsize = true;
 		break;
 	case Opt_actimeo:
 		ctx->actimeo = HZ * result.uint_32;
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index bb3fdce6d7f2..aa1d952fd5ce 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -151,6 +151,9 @@ struct smb3_fs_context {
 	char *nodename;
 	bool got_ip;
 	bool got_version;
+	bool got_rsize;
+	bool got_wsize;
+	bool got_bsize;
 	unsigned short port;
 
 	char *username;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index fb07e0828958..7e07a0aaaade 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2374,7 +2374,7 @@ int cifs_getattr(const struct path *path, struct kstat *stat,
 	}
 
 	generic_fillattr(inode, stat);
-	stat->blksize = cifs_sb->bsize;
+	stat->blksize = cifs_sb->ctx->bsize;
 	stat->ino = CIFS_I(inode)->uniqueid;
 
 	/* old CIFS Unix Extensions doesn't return create time */
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 359a0ef796de..e31b939e628c 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -1006,7 +1006,7 @@ cifs_is_read_op(__u32 oplock)
 static unsigned int
 cifs_wp_retry_size(struct inode *inode)
 {
-	return CIFS_SB(inode->i_sb)->wsize;
+	return CIFS_SB(inode->i_sb)->ctx->wsize;
 }
 
 static bool
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f60240bbaa81..7040805adfdc 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3802,7 +3802,7 @@ smb3_parse_lease_buf(void *buf, unsigned int *epoch, char *lease_key)
 static unsigned int
 smb2_wp_retry_size(struct inode *inode)
 {
-	return min_t(unsigned int, CIFS_SB(inode->i_sb)->wsize,
+	return min_t(unsigned int, CIFS_SB(inode->i_sb)->ctx->wsize,
 		     SMB2_MAX_BUFFER_SIZE);
 }
 
-- 
2.13.6

