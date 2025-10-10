Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0343D246BD5;
	Fri, 10 Oct 2025 03:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760065647; cv=none; b=OYiZGmKPmV9WnW4PY5cc5cub8aJyFXuCzEfO3gnFQJRBGHrEM7RQz7Edu6VuOHXSqcu5gNWbGUu/TrKCJ8TEOUs7vbYOwllVW9dXPaN3eHfFjDcj+PD+mG5AiqhujrgdbpMPo2rC+uFOzCPbkWjcRSJRY9s/xRMz6aGFNr5gr50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760065647; c=relaxed/simple;
	bh=X94e31DK5GglJvnSzcTtcjLzBOuyWyYnOB9QCXb6N6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlU5gI8tkITz7KhCP0g+4zduCUxBtGAlpHhlQch/p+8xgPRB+qvfdoFdU9qhEwV8afoMfLtY+DkYrBfnUtXQAgT+V7rQwIZ3qrERBrrnxIMzryU+4PGguS4XiOPZ4ChS14EbIoOIeRBtsMPm5pEyIHmc4Jce46narDMIhcFoUQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=BsRc6WQr; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=LInobg+F; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="BsRc6WQr";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="LInobg+F"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1760065234; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : in-reply-to : from;
 bh=2MlfTdL7VOS2ZqeiFcTckOlK9rkkqh8RGEd6yNe/N04=;
 b=BsRc6WQr3jBH15GHysImyx3624H6H+lsTazWaCN0fPrkvgdvqQBeDUuH8QX1+/DRkLL6i
 HYu9HHSqszwuztZAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1760065234; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : in-reply-to : from;
 bh=2MlfTdL7VOS2ZqeiFcTckOlK9rkkqh8RGEd6yNe/N04=;
 b=LInobg+FMJd4iN8XTvCSuFiuD8J/ufM+cnh5YNyEP2tgca5CnLXfOpyqFpk1QpXFeWAQ/
 BWpdjyjCNgDlVeLUgV95Z5zFzMdw5+sAMrO4wqHLxCL0VvqLISiJ6Kf106qvhSVGddsHu1R
 5fUJU9WDKwr/fxKKP7pBH7YDMJRFvi3OiDNj+MjET6qdj7FeATkJyBdyGkxGtmp8jmP34+a
 7CkuyV/oNaO+YQYwlNs19VJ3E1RUA2v8qFmrj4k1QXqaGjzA1OxIuHtS8yIuY+Ljzn+pW+o
 jW9WgUy8UiVUIrKoh7BC/5aAX00BUqaIrY/cs/fuky35sGaRSV95+8uR0siQ==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256
	 client-signature ED25519)
	(Client CN "otters", Issuer "otters" (not verified))
	by o-chul.darkrain42.org (Postfix) with ESMTPS id 782B18222;
	Thu,  9 Oct 2025 20:00:34 -0700 (PDT)
Received: by vaarsuvius.home.arpa (Postfix, from userid 1000)
	id 631F38C179E; Thu, 09 Oct 2025 20:00:33 -0700 (PDT)
Date: Thu, 9 Oct 2025 20:00:33 -0700
From: Paul Aurich <paul@darkrain42.org>
To: Shivani Agarwal <shivani.agarwal@broadcom.com>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org,
	bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com,
	tapas.kundu@broadcom.com, sfrench@samba.org, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: Re: [PATCH v6.1] smb: prevent use-after-free due to open_cached_dir
 error paths
Message-ID: <aOh20TkmJDG5Bomt@vaarsuvius.home.arpa>
Mail-Followup-To: Shivani Agarwal <shivani.agarwal@broadcom.com>,
	stable@vger.kernel.org, gregkh@linuxfoundation.org,
	bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com,
	tapas.kundu@broadcom.com, sfrench@samba.org, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
References: <20251009060846.351250-1-shivani.agarwal@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251009060846.351250-1-shivani.agarwal@broadcom.com>

Thanks for proposing this!  I think this backport has the problem I was 
concerned with when Cliff Liu proposed a backport in March [1].

The handling of the 'has_lease' field in this patch depends on work done by 
two other patches, and those should be backported before this one:

- 5c86919455c1 ("smb: client: fix use-after-free in 
    smb2_query_info_compound()")
- 7afb86733685 ("smb: Don't leak cfid when reconnect races with 
    open_cached_dir")

I have (somewhere...) a backport of all three of these patches three patches 
to linux-6.1.y, but it was a while ago and I never found the time to _test_ 
the backports.

[1] https://lore.kernel.org/linux-cifs/Z9uGCaxYJgs1gvwM@vaarsuvius.home.arpa/

On 2025-10-08 23:08:46 -0700, Shivani Agarwal wrote:
>From: Paul Aurich <paul@darkrain42.org>
>
>commit a9685b409a03b73d2980bbfa53eb47555802d0a9 upstream.
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
>[Shivani: Modified to apply on 6.1.y]
>Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
>---
> fs/smb/client/cached_dir.c | 39 ++++++++++++++++----------------------
> 1 file changed, 16 insertions(+), 23 deletions(-)
>
>diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>index 3d028b6a2..23a57a0c8 100644
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

cfid->has_lease needs to be cleared while holding cfids->cfid_list_lock.  (See 
my feedback to the stable backport in March)

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
>2.40.4
>

~Paul

