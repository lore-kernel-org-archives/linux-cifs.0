Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B9E1CA6A9
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 13:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371620; cv=pass; b=EXuXdlPuTL9ju3twW7tAnLlb+FpfAEop5DyXFukadGVGISL+vUdUAbGlZ5f09EUxY4wSE8/zyBhwt25T8m7SSw/m7uFveThhgmf2tA2/a5973K5oQ0So3HnsJZv74N2E+S3bv9axYocd1wQrHJ8Eoi1YetgMSNiP5XM+aII679s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371620; c=relaxed/simple;
	bh=fJ1QNGpTaLIP8SX8/AO5BE5SOiCbRVkJAOfCZ4vTod8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=My6s2+e0KvgXoDGrsILw8eYjwTjtAIV2HadR5/hH5J8LZuPZHBA5vxzNXup4zZ/UanLiT3qm1zCSKuRleaXrnYyHISqzNgcByhVg/JaUcBioMYw3U5YlIvV92GpgfoQAYxzE0n8ObXdxXgEaQajnmK8gWW/Jg+RphWQSIelTa1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=UgMgHT58; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="UgMgHT58"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1725371610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YtluGDrLppHf4XYTs9meyWwzY76AjPiLPjIW3UNHFv0=;
	b=UgMgHT58zWgVimJeTWlY5tyo8bXwr3a4b3R9peY9u6Tyx377fC3QKNg3F5qKaGPBexvpq5
	EbyJu0YRMVfyew/J/ImebCuLqRcHkNkeCLCvUI1VhkW+7MQWZKJJUgSCeYjxVI+CF8/lMU
	nsio9Dbn9Gq7Pm0DdmMLA3oOGExr47cpsMF3uOD0NW8ZXs9c7wVE5qCpvrPhb8KQQeukRj
	fuAzEw9J1cIUnrZ7tS5KESR/Qn+0UEEw2QOeLwmZ3omKMWiyQHQ1HFpfx57VQ4gDxVj+Pp
	N39GPJzEW9tRbICnLFPmU3AgpXv5Fm4BBOYqdIjoaZeH6bPwE5uvVmzaEHLWVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1725371610; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YtluGDrLppHf4XYTs9meyWwzY76AjPiLPjIW3UNHFv0=;
	b=It7qA162ePl0Ntoz+LQrPW3Ub+EzPRK+wRdt/FU5zc5vEHz67ArTWSORikmt42YibR8N/A
	8Q1mPPXkg0kG1HM9RFc+fHW1yXS6st1NtzZJL6pcXMDbJjzmeJpG14K7uaW+x2eRWkqdsL
	UZhWJYsaDtAQtlBCYxRu05xCViPQtsuHHAbYa+Fv0nmXDexTLxpUzNbCnnTgrU0KkjEc/+
	wJvtnju9hCLZd8q8nyMXYUVE+UqYPkgoQvx3AJ/x13Lj7taVCqmIjqIfSbBfVfriONOMp+
	zLO6BzQHuSz09hRzhUW9pBoU//5pALTsYOuGTdNef+VMMFc3Em+fYl804Q0Lqg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1725371610; a=rsa-sha256;
	cv=none;
	b=sKoFxHbZ5ZefrQQX9sFMn5UuEyyVRQfOOeaPULeLrvQyMO7k3SSmN8wzK4SrAU0SKIb8aG
	YCobMq07tp1NGjfUKcAEr97mQ5lkeyXECPb8UX8oRcTk7dQDvkIldvGtJAUjLm6mpnomvB
	OvU/5J6L0/ShuOQQO0Dkgh5UF4Wdj63Xye5fE9ONxi6aJ5PzEyF7nMOKqzK66qnv41XVrA
	7WcacrFUkt5FVgzf5hNxlXRQ06lHxYDq+Rdnp08JJB/sXGOQpE52lmLOGCvskUUE459MnF
	6Q532r/MyZv0SNvjaZIQlnMmUz6lJ/BKr70MKbuNEREVqL0IGp/MXZq92OZwYg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] smb: client: fix double put of @cfile in smb2_set_path_size()
Date: Tue,  3 Sep 2024 10:53:24 -0300
Message-ID: <20240903135324.887150-2-pc@manguebit.com>
In-Reply-To: <20240903135324.887150-1-pc@manguebit.com>
References: <20240903135324.887150-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If smb2_compound_op() is called with a valid @cfile and returned
-EINVAL, we need to call cifs_get_writable_path() before retrying it
as the reference of @cfile was already dropped by previous call.

This fixes the following KASAN splat when running fstests generic/013
against Windows Server 2022:

  CIFS: Attempting to mount //w22-fs0/scratch
  run fstests generic/013 at 2024-09-02 19:48:59
  ==================================================================
  BUG: KASAN: slab-use-after-free in detach_if_pending+0xab/0x200
  Write of size 8 at addr ffff88811f1a3730 by task kworker/3:2/176

  CPU: 3 UID: 0 PID: 176 Comm: kworker/3:2 Not tainted 6.11.0-rc6 #2
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40
  04/01/2014
  Workqueue: cifsoplockd cifs_oplock_break [cifs]
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   ? detach_if_pending+0xab/0x200
   print_report+0x156/0x4d9
   ? detach_if_pending+0xab/0x200
   ? __virt_addr_valid+0x145/0x300
   ? __phys_addr+0x46/0x90
   ? detach_if_pending+0xab/0x200
   kasan_report+0xda/0x110
   ? detach_if_pending+0xab/0x200
   detach_if_pending+0xab/0x200
   timer_delete+0x96/0xe0
   ? __pfx_timer_delete+0x10/0x10
   ? rcu_is_watching+0x20/0x50
   try_to_grab_pending+0x46/0x3b0
   __cancel_work+0x89/0x1b0
   ? __pfx___cancel_work+0x10/0x10
   ? kasan_save_track+0x14/0x30
   cifs_close_deferred_file+0x110/0x2c0 [cifs]
   ? __pfx_cifs_close_deferred_file+0x10/0x10 [cifs]
   ? __pfx_down_read+0x10/0x10
   cifs_oplock_break+0x4c1/0xa50 [cifs]
   ? __pfx_cifs_oplock_break+0x10/0x10 [cifs]
   ? lock_is_held_type+0x85/0xf0
   ? mark_held_locks+0x1a/0x90
   process_one_work+0x4c6/0x9f0
   ? find_held_lock+0x8a/0xa0
   ? __pfx_process_one_work+0x10/0x10
   ? lock_acquired+0x220/0x550
   ? __list_add_valid_or_report+0x37/0x100
   worker_thread+0x2e4/0x570
   ? __kthread_parkme+0xd1/0xf0
   ? __pfx_worker_thread+0x10/0x10
   kthread+0x17f/0x1c0
   ? kthread+0xda/0x1c0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x31/0x60
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

  Allocated by task 1118:
   kasan_save_stack+0x30/0x50
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0xaa/0xb0
   cifs_new_fileinfo+0xc8/0x9d0 [cifs]
   cifs_atomic_open+0x467/0x770 [cifs]
   lookup_open.isra.0+0x665/0x8b0
   path_openat+0x4c3/0x1380
   do_filp_open+0x167/0x270
   do_sys_openat2+0x129/0x160
   __x64_sys_creat+0xad/0xe0
   do_syscall_64+0xbb/0x1d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  Freed by task 83:
   kasan_save_stack+0x30/0x50
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x70
   poison_slab_object+0xe9/0x160
   __kasan_slab_free+0x32/0x50
   kfree+0xf2/0x300
   process_one_work+0x4c6/0x9f0
   worker_thread+0x2e4/0x570
   kthread+0x17f/0x1c0
   ret_from_fork+0x31/0x60
   ret_from_fork_asm+0x1a/0x30

  Last potentially related work creation:
   kasan_save_stack+0x30/0x50
   __kasan_record_aux_stack+0xad/0xc0
   insert_work+0x29/0xe0
   __queue_work+0x5ea/0x760
   queue_work_on+0x6d/0x90
   _cifsFileInfo_put+0x3f6/0x770 [cifs]
   smb2_compound_op+0x911/0x3940 [cifs]
   smb2_set_path_size+0x228/0x270 [cifs]
   cifs_set_file_size+0x197/0x460 [cifs]
   cifs_setattr+0xd9c/0x14b0 [cifs]
   notify_change+0x4e3/0x740
   do_truncate+0xfa/0x180
   vfs_truncate+0x195/0x200
   __x64_sys_truncate+0x109/0x150
   do_syscall_64+0xbb/0x1d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 71f15c90e785 ("smb: client: retry compound request without reusing lease")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Cc: David Howells <dhowells@redhat.com>
---
 fs/smb/client/smb2inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index e3117f3fb5b2..11a1c53c64e0 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1151,6 +1151,7 @@ smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
 			      cfile, NULL, NULL, dentry);
 	if (rc == -EINVAL) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease");
+		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb,
 				      full_path, &oparms, &in_iov,
 				      &(int){SMB2_OP_SET_EOF}, 1,
-- 
2.46.0

