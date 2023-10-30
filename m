Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B208C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 20:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjJ3UUQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 16:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjJ3UUP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 16:20:15 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D950DF
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 13:20:12 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698697211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vWN/cZPo1MpY75LHtWVz+rQTpsWFBWw6HEjK8xnBPXU=;
        b=VUMtRufpeY/VJshEYqkH7iCpRyXQoe3mnSb/mHUWBI0qYn4WnwtSCIrGVh3GGjlkanCul+
        n/PFrx+ORYlvOeMrewZxGvrbNnqSBDafPUFm2Fq/RS5oGFWRJYegrFjYj51YjAi0+H0tfX
        FfLlTXSyrx5U0U8BVmCJqyfH/mSx0ws9iHWSCYrMerJPumAr58RPkgOHIhkucX50xmBObU
        Mclfc6ePREdF02Pq909aeogZW+mUoJQLWiUcHuWPE/ZYQNXtuOj+5xufVQGiauavo/iR5T
        Vp8BGh8GXihuiO0W7sW7Iw8lrBu4Vk9PUxnXz1sv9fLPwUJ+QGGm8tJa9wVy6w==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1698697211; a=rsa-sha256;
        cv=none;
        b=EfAD6Mv/ajStG6YxOofP1QLn7zAK3MQMSNZezuuzPWCHOctxh2+l5tv4zGbZ0qJBjA3qmZ
        Rf6BFYYg3c4idUULdzcKOlQFHI67JZR3eeyoh1zizHU1s4ReA0E9o/BQg6nDrMMBPswpq/
        NIqPutMKidDZQ0MDr+wFsbVVnsgOr1ji5IOCwxpMqrhBWQF7cJhTEPkSDIpoCBBHyB3vDY
        mRTYGkcJg+w0tgePG44xFWNo0Da0OkzHWZeFTu35ogkcgzxzTcrNXgLhTpzp6r3IqrLvo9
        nZ9qi/MM1FaeGqMZe4m3dRK+DgWOqreaImyIz+SCConSizc2c4UBy7FX5t9W3Q==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698697211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vWN/cZPo1MpY75LHtWVz+rQTpsWFBWw6HEjK8xnBPXU=;
        b=TpBqHObcEunH6012bt15D6svXFI0R87qyZZudIQe1dfWbqvF536wQa8j3XwECrPmPZJoDC
        XooAqIEnc3Rd/V92yroNiQWyTcPyp+H0PAEP8T2J24s82Iu9u/W2gkp3T7ny543kvZyPsX
        c0D1yK6M2b7tzGvcy0jz0eT29fz5L+TKwXkE2d/NF/HBS1B0boUdvh46B8xZ3ySwTa9GC3
        LFINwalRY7x+eG5bxVbuWVYuFpTsOKH/MntfhNryAeQ+NdKHyp9PCNVPjWGVHwQsjTfb5J
        8xGjE2Y8DAFZxOMaZl4pEOjYFxvRlBSrLloUF6IIgV1afIF6vLsv/zLqHR3sWQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 4/4] smb: client: fix use-after-free in smb2_query_info_compound()
Date:   Mon, 30 Oct 2023 17:19:56 -0300
Message-ID: <20231030201956.2660-4-pc@manguebit.com>
In-Reply-To: <20231030201956.2660-1-pc@manguebit.com>
References: <20231030201956.2660-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The following UAF was triggered when running fstests generic/072 with
KASAN enabled against Windows Server 2022 and mount options
'multichannel,max_channels=2,vers=3.1.1,mfsymlinks,noperm'

  BUG: KASAN: slab-use-after-free in smb2_query_info_compound+0x423/0x6d0 [cifs]
  Read of size 8 at addr ffff888014941048 by task xfs_io/27534

  CPU: 0 PID: 27534 Comm: xfs_io Not tainted 6.6.0-rc7 #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
  rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
  Call Trace:
   dump_stack_lvl+0x4a/0x80
   print_report+0xcf/0x650
   ? srso_alias_return_thunk+0x5/0x7f
   ? srso_alias_return_thunk+0x5/0x7f
   ? __phys_addr+0x46/0x90
   kasan_report+0xda/0x110
   ? smb2_query_info_compound+0x423/0x6d0 [cifs]
   ? smb2_query_info_compound+0x423/0x6d0 [cifs]
   smb2_query_info_compound+0x423/0x6d0 [cifs]
   ? __pfx_smb2_query_info_compound+0x10/0x10 [cifs]
   ? srso_alias_return_thunk+0x5/0x7f
   ? __stack_depot_save+0x39/0x480
   ? kasan_save_stack+0x33/0x60
   ? kasan_set_track+0x25/0x30
   ? ____kasan_slab_free+0x126/0x170
   smb2_queryfs+0xc2/0x2c0 [cifs]
   ? __pfx_smb2_queryfs+0x10/0x10 [cifs]
   ? __pfx___lock_acquire+0x10/0x10
   smb311_queryfs+0x210/0x220 [cifs]
   ? __pfx_smb311_queryfs+0x10/0x10 [cifs]
   ? srso_alias_return_thunk+0x5/0x7f
   ? __lock_acquire+0x480/0x26c0
   ? lock_release+0x1ed/0x640
   ? srso_alias_return_thunk+0x5/0x7f
   ? do_raw_spin_unlock+0x9b/0x100
   cifs_statfs+0x18c/0x4b0 [cifs]
   statfs_by_dentry+0x9b/0xf0
   fd_statfs+0x4e/0xb0
   __do_sys_fstatfs+0x7f/0xe0
   ? __pfx___do_sys_fstatfs+0x10/0x10
   ? srso_alias_return_thunk+0x5/0x7f
   ? lockdep_hardirqs_on_prepare+0x136/0x200
   ? srso_alias_return_thunk+0x5/0x7f
   do_syscall_64+0x3f/0x90
   entry_SYSCALL_64_after_hwframe+0x6e/0xd8

  Allocated by task 27534:
   kasan_save_stack+0x33/0x60
   kasan_set_track+0x25/0x30
   __kasan_kmalloc+0x8f/0xa0
   open_cached_dir+0x71b/0x1240 [cifs]
   smb2_query_info_compound+0x5c3/0x6d0 [cifs]
   smb2_queryfs+0xc2/0x2c0 [cifs]
   smb311_queryfs+0x210/0x220 [cifs]
   cifs_statfs+0x18c/0x4b0 [cifs]
   statfs_by_dentry+0x9b/0xf0
   fd_statfs+0x4e/0xb0
   __do_sys_fstatfs+0x7f/0xe0
   do_syscall_64+0x3f/0x90
   entry_SYSCALL_64_after_hwframe+0x6e/0xd8

  Freed by task 27534:
   kasan_save_stack+0x33/0x60
   kasan_set_track+0x25/0x30
   kasan_save_free_info+0x2b/0x50
   ____kasan_slab_free+0x126/0x170
   slab_free_freelist_hook+0xd0/0x1e0
   __kmem_cache_free+0x9d/0x1b0
   open_cached_dir+0xff5/0x1240 [cifs]
   smb2_query_info_compound+0x5c3/0x6d0 [cifs]
   smb2_queryfs+0xc2/0x2c0 [cifs]

This is a race between open_cached_dir() and cached_dir_lease_break()
where the cache entry for the open directory handle receives a lease
break while creating it.  And before returning from open_cached_dir(),
we put the last reference of the new @cfid because of
!@cfid->has_lease.

Besides the UAF, while running xfstests a lot of missed lease breaks
have been noticed in tests that run several concurrent statfs(2) calls
on those cached fids

  CIFS: VFS: \\w22-root1.gandalf.test No task to wake, unknown frame...
  CIFS: VFS: \\w22-root1.gandalf.test Cmd: 18 Err: 0x0 Flags: 0x1...
  CIFS: VFS: \\w22-root1.gandalf.test smb buf 00000000715bfe83 len 108
  CIFS: VFS: Dump pending requests:
  CIFS: VFS: \\w22-root1.gandalf.test No task to wake, unknown frame...
  CIFS: VFS: \\w22-root1.gandalf.test Cmd: 18 Err: 0x0 Flags: 0x1...
  CIFS: VFS: \\w22-root1.gandalf.test smb buf 000000005aa7316e len 108
  ...

To fix both, in open_cached_dir() ensure that @cfid->has_lease is set
right before sending out compounded request so that any potential
lease break will be get processed by demultiplex thread while we're
still caching @cfid.  And, if open failed for some reason, re-check
@cfid->has_lease to decide whether or not put lease reference.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cached_dir.c | 84 ++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 35 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index fe1bf5b6e0cb..59f6b8e32cc9 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -32,7 +32,7 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 			 * fully cached or it may be in the process of
 			 * being deleted due to a lease break.
 			 */
-			if (!cfid->has_lease) {
+			if (!cfid->time || !cfid->has_lease) {
 				spin_unlock(&cfids->cfid_list_lock);
 				return NULL;
 			}
@@ -193,10 +193,20 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	npath = path_no_prefix(cifs_sb, path);
 	if (IS_ERR(npath)) {
 		rc = PTR_ERR(npath);
-		kfree(utf16_path);
-		return rc;
+		goto out;
 	}
 
+	if (!npath[0]) {
+		dentry = dget(cifs_sb->root);
+	} else {
+		dentry = path_to_dentry(cifs_sb, npath);
+		if (IS_ERR(dentry)) {
+			rc = -ENOENT;
+			goto out;
+		}
+	}
+	cfid->dentry = dentry;
+
 	/*
 	 * We do not hold the lock for the open because in case
 	 * SMB2_open needs to reconnect.
@@ -249,6 +259,15 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 	smb2_set_related(&rqst[1]);
 
+	/*
+	 * Set @cfid->has_lease to true before sending out compounded request so
+	 * its lease reference can be put in cached_dir_lease_break() due to a
+	 * potential lease break right after the request is sent or while @cfid
+	 * is still being cached.  Concurrent processes won't be to use it yet
+	 * due to @cfid->time being zero.
+	 */
+	cfid->has_lease = true;
+
 	rc = compound_send_recv(xid, ses, server,
 				flags, 2, rqst,
 				resp_buftype, rsp_iov);
@@ -263,6 +282,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	cfid->tcon = tcon;
 	cfid->is_open = true;
 
+	spin_lock(&cfids->cfid_list_lock);
+
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
 	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
@@ -270,18 +291,25 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
-	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
+	rc = -EINVAL;
+	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
+		spin_unlock(&cfids->cfid_list_lock);
 		goto oshr_free;
+	}
 
 	smb2_parse_contexts(server, o_rsp,
 			    &oparms.fid->epoch,
 			    oparms.fid->lease_key, &oplock,
 			    NULL, NULL);
-	if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
+	if (!(oplock & SMB2_LEASE_READ_CACHING_HE)) {
+		spin_unlock(&cfids->cfid_list_lock);
 		goto oshr_free;
+	}
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
-	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
+	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info)) {
+		spin_unlock(&cfids->cfid_list_lock);
 		goto oshr_free;
+	}
 	if (!smb2_validate_and_copy_iov(
 				le16_to_cpu(qi_rsp->OutputBufferOffset),
 				sizeof(struct smb2_file_all_info),
@@ -289,37 +317,24 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				(char *)&cfid->file_all_info))
 		cfid->file_all_info_is_valid = true;
 
-	if (!npath[0])
-		dentry = dget(cifs_sb->root);
-	else {
-		dentry = path_to_dentry(cifs_sb, npath);
-		if (IS_ERR(dentry)) {
-			rc = -ENOENT;
-			goto oshr_free;
-		}
-	}
-	spin_lock(&cfids->cfid_list_lock);
-	cfid->dentry = dentry;
 	cfid->time = jiffies;
-	cfid->has_lease = true;
 	spin_unlock(&cfids->cfid_list_lock);
+	/* At this point the directory handle is fully cached */
+	rc = 0;
 
 oshr_free:
-	kfree(utf16_path);
 	SMB2_open_free(&rqst[0]);
 	SMB2_query_info_free(&rqst[1]);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
-	spin_lock(&cfids->cfid_list_lock);
-	if (!cfid->has_lease) {
-		if (rc) {
-			if (cfid->on_list) {
-				list_del(&cfid->entry);
-				cfid->on_list = false;
-				cfids->num_entries--;
-			}
-			rc = -ENOENT;
-		} else {
+	if (rc) {
+		spin_lock(&cfids->cfid_list_lock);
+		if (cfid->on_list) {
+			list_del(&cfid->entry);
+			cfid->on_list = false;
+			cfids->num_entries--;
+		}
+		if (cfid->has_lease) {
 			/*
 			 * We are guaranteed to have two references at this
 			 * point. One for the caller and one for a potential
@@ -327,25 +342,24 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			 * will be closed when the caller closes the cached
 			 * handle.
 			 */
+			cfid->has_lease = false;
 			spin_unlock(&cfids->cfid_list_lock);
 			kref_put(&cfid->refcount, smb2_close_cached_fid);
 			goto out;
 		}
+		spin_unlock(&cfids->cfid_list_lock);
 	}
-	spin_unlock(&cfids->cfid_list_lock);
+out:
 	if (rc) {
 		if (cfid->is_open)
 			SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
 				   cfid->fid.volatile_fid);
 		free_cached_dir(cfid);
-		cfid = NULL;
-	}
-out:
-	if (rc == 0) {
+	} else {
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
 	}
-
+	kfree(utf16_path);
 	return rc;
 }
 
-- 
2.42.0

