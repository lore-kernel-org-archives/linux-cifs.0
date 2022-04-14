Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED81C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Apr 2022 00:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbiDNAup (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Apr 2022 20:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiDNAuo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Apr 2022 20:50:44 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B600733EA1
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 17:48:21 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id k29so3314989pgm.12
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 17:48:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YRtGYfiXPa5EhFn0E+uLlNVEB//crD9OeSiwfvqlwyg=;
        b=ANjCKCDB65L8M0pJsk4voxy96ExTeBj41ckOe0XV3KsOGi1keIf2s5b75UehGWbtqc
         Z8LpTvnDk5nZtUhgRITnPFpkPj/Rt44qO5ITqsZyCXMQfDZjWzzNoh9q61bO6/lHgxPo
         /kM5FHHVb282RHCPKpXcUV0P+Oq+gSXSQuxhxkrL8i7iazAiFzSDohTriA7QNWZnqasu
         GAEgc5+0fWTUxpXniN6UAHBAVe1fnbFyyQJWZ+86N2UkYeLmwv4+ZjfzAqbStLLgvVYJ
         VLAa59HZ4zrPxpDeFzhPPqi8m8zASV+zniXn/ZA+lRZqIzA6VCDIONvs4y786TJ/K/kP
         USGg==
X-Gm-Message-State: AOAM531ZsdzDhfb5M6wa2bWi1m2O6GTGd48M1xjFJTSdV78nRlrdUsct
        msGvTvE1aL+mCsXY1P1IhDRCtq67mRF9Ag==
X-Google-Smtp-Source: ABdhPJw2gPbK5n4EhTGRMpL0yTON5YQl9Nk3pqji4wKCiWMAq0DZkcvhSq5PfBA7zR5M6+8PiDSFaQ==
X-Received: by 2002:a63:5441:0:b0:39d:4310:3f0e with SMTP id e1-20020a635441000000b0039d43103f0emr212447pgm.586.1649897300906;
        Wed, 13 Apr 2022 17:48:20 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id 2-20020a17090a0f0200b001cb6621403csm4162831pjy.24.2022.04.13.17.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 17:48:20 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2] ksmbd: remove filename in ksmbd_file
Date:   Thu, 14 Apr 2022 09:48:03 +0900
Message-Id: <20220414004803.11555-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If the filename is change by underlying rename the server, fp->filename
and real filename can be different. This patch remove the uses of
fp->filename in ksmbd and replace it with d_path().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - use share->path_sz instead of strlen().
   - allocate nt_pathname with size +1 for null terminator space.

 fs/ksmbd/misc.c      | 40 +++++++++++++++++++++++++++++++---------
 fs/ksmbd/misc.h      |  3 ++-
 fs/ksmbd/oplock.c    | 30 ------------------------------
 fs/ksmbd/oplock.h    |  2 --
 fs/ksmbd/smb2pdu.c   | 21 +++++++--------------
 fs/ksmbd/vfs.c       |  6 ++----
 fs/ksmbd/vfs_cache.c |  1 -
 fs/ksmbd/vfs_cache.h |  1 -
 8 files changed, 42 insertions(+), 62 deletions(-)

diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
index 60e7ac62c917..20d4455a0a99 100644
--- a/fs/ksmbd/misc.c
+++ b/fs/ksmbd/misc.c
@@ -158,19 +158,41 @@ int parse_stream_name(char *filename, char **stream_name, int *s_type)
  * Return : windows path string or error
  */
 
-char *convert_to_nt_pathname(char *filename)
+char *convert_to_nt_pathname(struct ksmbd_share_config *share,
+			     struct path *path)
 {
-	char *ab_pathname;
+	char *pathname, *ab_pathname, *nt_pathname;
+	int share_path_len = share->path_sz;
 
-	if (strlen(filename) == 0)
-		filename = "\\";
+	pathname = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!pathname)
+		return ERR_PTR(-EACCES);
 
-	ab_pathname = kstrdup(filename, GFP_KERNEL);
-	if (!ab_pathname)
-		return NULL;
+	ab_pathname = d_path(path, pathname, PATH_MAX);
+	if (IS_ERR(ab_pathname)) {
+		nt_pathname = ERR_PTR(-EACCES);
+		goto free_pathname;
+	}
+
+	if (strncmp(ab_pathname, share->path, share_path_len)) {
+		nt_pathname = ERR_PTR(-EACCES);
+		goto free_pathname;
+	}
+
+	nt_pathname = kzalloc(strlen(&ab_pathname[share_path_len]) + 2, GFP_KERNEL);
+	if (!nt_pathname) {
+		nt_pathname = ERR_PTR(-ENOMEM);
+		goto free_pathname;
+	}
+	if (ab_pathname[share_path_len] == '\0')
+		strcpy(nt_pathname, "/");
+	strcat(nt_pathname, &ab_pathname[share_path_len]);
+
+	ksmbd_conv_path_to_windows(nt_pathname);
 
-	ksmbd_conv_path_to_windows(ab_pathname);
-	return ab_pathname;
+free_pathname:
+	kfree(pathname);
+	return nt_pathname;
 }
 
 int get_nlink(struct kstat *st)
diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
index 253366bd0951..aae2a252945f 100644
--- a/fs/ksmbd/misc.h
+++ b/fs/ksmbd/misc.h
@@ -14,7 +14,8 @@ struct ksmbd_file;
 int match_pattern(const char *str, size_t len, const char *pattern);
 int ksmbd_validate_filename(char *filename);
 int parse_stream_name(char *filename, char **stream_name, int *s_type);
-char *convert_to_nt_pathname(char *filename);
+char *convert_to_nt_pathname(struct ksmbd_share_config *share,
+			     struct path *path);
 int get_nlink(struct kstat *st);
 void ksmbd_conv_path_to_unix(char *path);
 void ksmbd_strip_last_slash(char *path);
diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 23871b18a429..8b5560574d4c 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1694,33 +1694,3 @@ struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 	read_unlock(&lease_list_lock);
 	return ret_op;
 }
-
-int smb2_check_durable_oplock(struct ksmbd_file *fp,
-			      struct lease_ctx_info *lctx, char *name)
-{
-	struct oplock_info *opinfo = opinfo_get(fp);
-	int ret = 0;
-
-	if (opinfo && opinfo->is_lease) {
-		if (!lctx) {
-			pr_err("open does not include lease\n");
-			ret = -EBADF;
-			goto out;
-		}
-		if (memcmp(opinfo->o_lease->lease_key, lctx->lease_key,
-			   SMB2_LEASE_KEY_SIZE)) {
-			pr_err("invalid lease key\n");
-			ret = -EBADF;
-			goto out;
-		}
-		if (name && strcmp(fp->filename, name)) {
-			pr_err("invalid name reconnect %s\n", name);
-			ret = -EINVAL;
-			goto out;
-		}
-	}
-out:
-	if (opinfo)
-		opinfo_put(opinfo);
-	return ret;
-}
diff --git a/fs/ksmbd/oplock.h b/fs/ksmbd/oplock.h
index 0cf7a2b5bbc0..09753448f779 100644
--- a/fs/ksmbd/oplock.h
+++ b/fs/ksmbd/oplock.h
@@ -124,6 +124,4 @@ struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx);
 void destroy_lease_table(struct ksmbd_conn *conn);
-int smb2_check_durable_oplock(struct ksmbd_file *fp,
-			      struct lease_ctx_info *lctx, char *name);
 #endif /* __KSMBD_OPLOCK_H */
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 3bf6c56c654c..e38fb68ded21 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2918,7 +2918,6 @@ int smb2_open(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	fp->filename = name;
 	fp->cdoption = req->CreateDisposition;
 	fp->daccess = daccess;
 	fp->saccess = req->ShareAccess;
@@ -3270,14 +3269,13 @@ int smb2_open(struct ksmbd_work *work)
 		if (!rsp->hdr.Status)
 			rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
 
-		if (!fp || !fp->filename)
-			kfree(name);
 		if (fp)
 			ksmbd_fd_put(work, fp);
 		smb2_set_err_rsp(work);
 		ksmbd_debug(SMB, "Error response: %x\n", rsp->hdr.Status);
 	}
 
+	kfree(name);
 	kfree(lc);
 
 	return 0;
@@ -3895,8 +3893,6 @@ int smb2_query_dir(struct ksmbd_work *work)
 		ksmbd_debug(SMB, "Search pattern is %s\n", srch_ptr);
 	}
 
-	ksmbd_debug(SMB, "Directory name is %s\n", dir_fp->filename);
-
 	if (srch_flag & SMB2_REOPEN || srch_flag & SMB2_RESTART_SCANS) {
 		ksmbd_debug(SMB, "Restart directory scan\n");
 		generic_file_llseek(dir_fp->filp, 0, SEEK_SET);
@@ -4390,9 +4386,9 @@ static int get_file_all_info(struct ksmbd_work *work,
 		return -EACCES;
 	}
 
-	filename = convert_to_nt_pathname(fp->filename);
-	if (!filename)
-		return -ENOMEM;
+	filename = convert_to_nt_pathname(work->tcon->share_conf, &fp->filp->f_path);
+	if (IS_ERR(filename))
+		return PTR_ERR(filename);
 
 	inode = file_inode(fp->filp);
 	generic_fillattr(file_mnt_user_ns(fp->filp), inode, &stat);
@@ -5683,8 +5679,7 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 		size = i_size_read(inode);
 		rc = ksmbd_vfs_truncate(work, fp, alloc_blks * 512);
 		if (rc) {
-			pr_err("truncate failed! filename : %s, err %d\n",
-			       fp->filename, rc);
+			pr_err("truncate failed!, err %d\n", rc);
 			return rc;
 		}
 		if (size < alloc_blks * 512)
@@ -5714,12 +5709,10 @@ static int set_end_of_file_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	 * truncated range.
 	 */
 	if (inode->i_sb->s_magic != MSDOS_SUPER_MAGIC) {
-		ksmbd_debug(SMB, "filename : %s truncated to newsize %lld\n",
-			    fp->filename, newsize);
+		ksmbd_debug(SMB, "truncated to newsize %lld\n", newsize);
 		rc = ksmbd_vfs_truncate(work, fp, newsize);
 		if (rc) {
-			ksmbd_debug(SMB, "truncate failed! filename : %s err %d\n",
-				    fp->filename, rc);
+			ksmbd_debug(SMB, "truncate failed!, err %d\n", rc);
 			if (rc != -EAGAIN)
 				rc = -EBADF;
 			return rc;
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 9cebb6ba555b..dcdd07c6efff 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -398,8 +398,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 
 	nbytes = kernel_read(filp, rbuf, count, pos);
 	if (nbytes < 0) {
-		pr_err("smb read failed for (%s), err = %zd\n",
-		       fp->filename, nbytes);
+		pr_err("smb read failed, err = %zd\n", nbytes);
 		return nbytes;
 	}
 
@@ -875,8 +874,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work,
 
 	err = vfs_truncate(&filp->f_path, size);
 	if (err)
-		pr_err("truncate failed for filename : %s err %d\n",
-		       fp->filename, err);
+		pr_err("truncate failed, err %d\n", err);
 	return err;
 }
 
diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
index 29c1db66bd0f..0974d2e972b9 100644
--- a/fs/ksmbd/vfs_cache.c
+++ b/fs/ksmbd/vfs_cache.c
@@ -328,7 +328,6 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 		kfree(smb_lock);
 	}
 
-	kfree(fp->filename);
 	if (ksmbd_stream_fd(fp))
 		kfree(fp->stream.name);
 	kmem_cache_free(filp_cache, fp);
diff --git a/fs/ksmbd/vfs_cache.h b/fs/ksmbd/vfs_cache.h
index 36239ce31afd..fcb13413fa8d 100644
--- a/fs/ksmbd/vfs_cache.h
+++ b/fs/ksmbd/vfs_cache.h
@@ -62,7 +62,6 @@ struct ksmbd_inode {
 
 struct ksmbd_file {
 	struct file			*filp;
-	char				*filename;
 	u64				persistent_id;
 	u64				volatile_id;
 
-- 
2.25.1

