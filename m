Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD12149DFF;
	Thu, 20 Mar 2025 03:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742440515; cv=none; b=o4LQ/mEOFTgGboTCWyzeIL0IMyRVbXMRNF8T/HbC/tBmXmndDlGlEOMP06jn/jD0YPeCzBn0wB4bz5J4ZpBN3uPwwZBjeyjX5IR2UKlLYwDnLkzIxsM/QRi0jQ29+4Ew4udLGKFuKtQeErohL4zdBEASU0paRfN/i450gKCy+ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742440515; c=relaxed/simple;
	bh=yewg5HkvsdyUnlB9lfKwgx278aL8ikfLs6sLa6hf+MM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIZD/pbFQMYV6nqbe5LgZT66K0Xlg3/DO2lTm1NMXfuMC8lKcOEXJICxh9yAOwQyiZgzqQlXa0IP92cAREatyXN6gJDBmsKv5I8ja0bzbp74lTbsP6c3wuSb/VqNVyqErsn59LAONXW9hDKVh2kx2vSwp+TRi5JNcsoHKokzMe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=igmVJ8fP; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=TxaKk4rm; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="igmVJ8fP";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="TxaKk4rm"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1742439946; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : in-reply-to : from;
 bh=RcdODk4dVl8NFMpBY+o248G8mPL+2nAl9dG24FV5U/0=;
 b=igmVJ8fPELk1Rbt5F1e2zIVgk9DdXVXLciVteuRCRCGpH6rgbPwZidzbSBnA73sYAP8+M
 Z4TbUeGlwVFqRz5Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1742439946; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : in-reply-to : from;
 bh=RcdODk4dVl8NFMpBY+o248G8mPL+2nAl9dG24FV5U/0=;
 b=TxaKk4rmQEUx5ne2SCeXv+sYF8cdTPEeBMrcpXjqEjByzVX/CSe/5Rnt2t2yUR6OKckH7
 RDG3TO0tqDwgx92wXTRvuiS+xEVKXcwQevVpYyrz8O+gyJ2HR11KKtD5Z/Sm/jThqIm7nNH
 /v2KkHnnXCp85hRi8HgA1putoirI/aCHnsnAWs+5oIuiLCiKRLWythMb5qqWZ1mMP/EgKot
 N3yFLKGJ10KQ3fN4ezI3k9pRewseOww/a1f9wENoUzjsNqMMYuhuodHB8g2FHK43NdHTkx3
 Yqu1vHqKPe7eGEtdrXJAOEN1ggdSWSLfZAjjxSmJ3afu1bSMgW6Bys+EAbqw==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature ED25519)
	(Client CN "otters", Issuer "otters" (not verified))
	by o-chul.darkrain42.org (Postfix) with ESMTPS id EB90984E6;
	Wed, 19 Mar 2025 20:05:45 -0700 (PDT)
Received: by vaarsuvius.home.arpa (Postfix, from userid 1000)
	id 7F9198C1E64; Wed, 19 Mar 2025 20:05:45 -0700 (PDT)
Date: Wed, 19 Mar 2025 20:05:45 -0700
From: Paul Aurich <paul@darkrain42.org>
To: Cliff Liu <donghua.liu@windriver.com>
Cc: stable@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
	lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, Zhe.He@windriver.com
Subject: Re: [PATCH 6.1.y] smb: prevent use-after-free due to open_cached_dir
 error paths
Message-ID: <Z9uGCaxYJgs1gvwM@vaarsuvius.home.arpa>
Mail-Followup-To: Cliff Liu <donghua.liu@windriver.com>,
	stable@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
	lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, Zhe.He@windriver.com
References: <20250319090839.3631424-1-donghua.liu@windriver.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250319090839.3631424-1-donghua.liu@windriver.com>

Thanks for backporting this!  I think you should pick up these patches as 
pre-requisites for the one here:

- 5c86919455c1 ("smb: client: fix use-after-free in 
   smb2_query_info_compound()")
- 7afb86733685 ("smb: Don't leak cfid when reconnect races with 
   open_cached_dir")

All three of these patches touch on how the cached directory handling of the 
'has_lease' field works, and my work was built on top of those.

On 2025-03-19 17:08:39 +0800, Cliff Liu wrote:
>From: Paul Aurich <paul@darkrain42.org>
>
>If open_cached_dir() encounters an error parsing the lease from the
>server, the error handling may race with receiving a lease break,
>resulting in open_cached_dir() freeing the cfid while the queued work is
>pending.
>
>Update open_cached_dir() to drop refs rather than directly freeing the
>cfid.
>
>Have cached_dir_lease_break(), cfids_laundromat_worker(), and
>invalidate_all_cached_dirs() clear has_lease immediately while still
>holding cfids->cfid_list_lock, and then use this to also simplify the
>reference counting in cfids_laundromat_worker() and
>invalidate_all_cached_dirs().
>
>Fixes this KASAN splat (which manually injects an error and lease break
>in open_cached_dir()):
>
>==================================================================
>BUG: KASAN: slab-use-after-free in smb2_cached_lease_break+0x27/0xb0
>Read of size 8 at addr ffff88811cc24c10 by task kworker/3:1/65
>
>CPU: 3 UID: 0 PID: 65 Comm: kworker/3:1 Not tainted 6.12.0-rc6-g255cf264e6e5-dirty #87
>Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
>Workqueue: cifsiod smb2_cached_lease_break
>Call Trace:
> <TASK>
> dump_stack_lvl+0x77/0xb0
> print_report+0xce/0x660
> kasan_report+0xd3/0x110
> smb2_cached_lease_break+0x27/0xb0
> process_one_work+0x50a/0xc50
> worker_thread+0x2ba/0x530
> kthread+0x17c/0x1c0
> ret_from_fork+0x34/0x60
> ret_from_fork_asm+0x1a/0x30
> </TASK>
>
>Allocated by task 2464:
> kasan_save_stack+0x33/0x60
> kasan_save_track+0x14/0x30
> __kasan_kmalloc+0xaa/0xb0
> open_cached_dir+0xa7d/0x1fb0
> smb2_query_path_info+0x43c/0x6e0
> cifs_get_fattr+0x346/0xf10
> cifs_get_inode_info+0x157/0x210
> cifs_revalidate_dentry_attr+0x2d1/0x460
> cifs_getattr+0x173/0x470
> vfs_statx_path+0x10f/0x160
> vfs_statx+0xe9/0x150
> vfs_fstatat+0x5e/0xc0
> __do_sys_newfstatat+0x91/0xf0
> do_syscall_64+0x95/0x1a0
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>Freed by task 2464:
> kasan_save_stack+0x33/0x60
> kasan_save_track+0x14/0x30
> kasan_save_free_info+0x3b/0x60
> __kasan_slab_free+0x51/0x70
> kfree+0x174/0x520
> open_cached_dir+0x97f/0x1fb0
> smb2_query_path_info+0x43c/0x6e0
> cifs_get_fattr+0x346/0xf10
> cifs_get_inode_info+0x157/0x210
> cifs_revalidate_dentry_attr+0x2d1/0x460
> cifs_getattr+0x173/0x470
> vfs_statx_path+0x10f/0x160
> vfs_statx+0xe9/0x150
> vfs_fstatat+0x5e/0xc0
> __do_sys_newfstatat+0x91/0xf0
> do_syscall_64+0x95/0x1a0
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>Last potentially related work creation:
> kasan_save_stack+0x33/0x60
> __kasan_record_aux_stack+0xad/0xc0
> insert_work+0x32/0x100
> __queue_work+0x5c9/0x870
> queue_work_on+0x82/0x90
> open_cached_dir+0x1369/0x1fb0
> smb2_query_path_info+0x43c/0x6e0
> cifs_get_fattr+0x346/0xf10
> cifs_get_inode_info+0x157/0x210
> cifs_revalidate_dentry_attr+0x2d1/0x460
> cifs_getattr+0x173/0x470
> vfs_statx_path+0x10f/0x160
> vfs_statx+0xe9/0x150
> vfs_fstatat+0x5e/0xc0
> __do_sys_newfstatat+0x91/0xf0
> do_syscall_64+0x95/0x1a0
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>The buggy address belongs to the object at ffff88811cc24c00
> which belongs to the cache kmalloc-1k of size 1024
>The buggy address is located 16 bytes inside of
> freed 1024-byte region [ffff88811cc24c00, ffff88811cc25000)
>
>Cc: stable@vger.kernel.org
>Signed-off-by: Paul Aurich <paul@darkrain42.org>
>Signed-off-by: Steve French <stfrench@microsoft.com>
>[ Do not apply the change for cfids_laundromat_worker() since there is no
>  this function and related feature on 6.1.y. Update open_cached_dir()
>  according to method of upstream patch. ]
>Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
>Signed-off-by: He Zhe <Zhe.He@windriver.com>
>---
>Verified the build test.
>---
> fs/smb/client/cached_dir.c | 39 ++++++++++++++++----------------------
> 1 file changed, 16 insertions(+), 23 deletions(-)
>
>diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>index d09226c1ac90..d65d5fe5b8fe 100644
>--- a/fs/smb/client/cached_dir.c
>+++ b/fs/smb/client/cached_dir.c
>@@ -320,17 +320,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 		/*
> 		 * We are guaranteed to have two references at this point.
> 		 * One for the caller and one for a potential lease.
>-		 * Release the Lease-ref so that the directory will be closed
>-		 * when the caller closes the cached handle.
>+		 * Release one here, and the second below.
> 		 */
> 		kref_put(&cfid->refcount, smb2_close_cached_fid);
> 	}
> 	if (rc) {
>-		if (cfid->is_open)
>-			SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
>-				   cfid->fid.volatile_fid);
>-		free_cached_dir(cfid);
>-		cfid = NULL;
>+		cfid->has_lease = false;

This should be cleared while holding cfids->cfid_list_lock, which is what the 
upstream version of this backport (a9685b409a0) does, because of how this 
error handling was adjusted in 5c86919455c1 ("smb: client: fix use-after-free 
in smb2_query_info_compound()")

>+		kref_put(&cfid->refcount, smb2_close_cached_fid);
> 	}
>
> 	if (rc == 0) {
>@@ -462,25 +458,24 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
> 		cfids->num_entries--;
> 		cfid->is_open = false;
> 		cfid->on_list = false;
>-		/* To prevent race with smb2_cached_lease_break() */
>-		kref_get(&cfid->refcount);
>+		if (cfid->has_lease) {
>+			/*
>+			 * The lease was never cancelled from the server,
>+			 * so steal that reference.
>+			 */
>+			cfid->has_lease = false;
>+		} else
>+			kref_get(&cfid->refcount);
> 	}
> 	spin_unlock(&cfids->cfid_list_lock);
>
> 	list_for_each_entry_safe(cfid, q, &entry, entry) {
> 		list_del(&cfid->entry);
> 		cancel_work_sync(&cfid->lease_break);
>-		if (cfid->has_lease) {
>-			/*
>-			 * We lease was never cancelled from the server so we
>-			 * need to drop the reference.
>-			 */
>-			spin_lock(&cfids->cfid_list_lock);
>-			cfid->has_lease = false;
>-			spin_unlock(&cfids->cfid_list_lock);
>-			kref_put(&cfid->refcount, smb2_close_cached_fid);
>-		}
>-		/* Drop the extra reference opened above*/
>+		/*
>+		 * Drop the ref-count from above, either the lease-ref (if there
>+		 * was one) or the extra one acquired.
>+		 */
> 		kref_put(&cfid->refcount, smb2_close_cached_fid);
> 	}
> }
>@@ -491,9 +486,6 @@ smb2_cached_lease_break(struct work_struct *work)
> 	struct cached_fid *cfid = container_of(work,
> 				struct cached_fid, lease_break);
>
>-	spin_lock(&cfid->cfids->cfid_list_lock);
>-	cfid->has_lease = false;
>-	spin_unlock(&cfid->cfids->cfid_list_lock);
> 	kref_put(&cfid->refcount, smb2_close_cached_fid);
> }
>
>@@ -511,6 +503,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
> 		    !memcmp(lease_key,
> 			    cfid->fid.lease_key,
> 			    SMB2_LEASE_KEY_SIZE)) {
>+			cfid->has_lease = false;
> 			cfid->time = 0;
> 			/*
> 			 * We found a lease remove it from the list
>-- 
>2.43.0
>

~Paul

