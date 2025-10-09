Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAF91FFC48
	for <linux-cifs@vger.kernel.org>; Thu,  9 Oct 2025 06:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759991114; cv=none; b=eb2V0mWfUasV9WDk1BqOkQQtNDhIHaTIO5XOdRCcSu1SuuV9Wz4aCu1jlNVWcjc0mtT72RTTKUbqHI2LSQh3Ewb274eiusUJbZmMa8BCEmRP6Xw4BjcmqJeFDMzyXdWrHiPHNnSNr88uwKRvbqpcQCOiydcIU5Qn41U9q2YZgps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759991114; c=relaxed/simple;
	bh=+J+9CQSJvXmIuePph7LZKBSTQUJaQDgSX95H7QjCjvA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pdttX/MkWgbD6YLbhKK7lcXiIQqw1yOrlr5c9jlWZJODqoo4+ySZLR7IYDOf+GNv31kLAlnHRiGorcIQAgAddola9XmSI9giqOch7bwUIPcm+Zz7xVXFBumu3rlNoDKnxnBA1KhTxSd3dDRWxDcXkDto8oCxrjlM1OGcDi8uLRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=B09IWro2; arc=none smtp.client-ip=209.85.219.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="B09IWro2"
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-78f58f4230cso5087686d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 08 Oct 2025 23:25:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759991111; x=1760595911;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bS+vJs2offx96KKff6hwDdiXDpHtb7AICfG+1qxivmI=;
        b=gNZwTezvHhquYYVA0lBtCx5Dpwpo0flCxcmtNEHUOxUjtNbSU31xG9Ow9QbRkrKONz
         T2rlEDQjeHk5TBeXmoMVYf3YrEKGsR1mBKJqBGAGWVqjCJbmrkxPTjNPICOTHLdKE3a0
         HJnnHX4325tQdDbT9P9bv2km43DmfC8e5Atz/TG9EcSefTSYWYSSrRlteZf+e1308PfP
         pBGXwdmHzA3yIb3BEMoWjlQvseShrvGjIqJiXZ4GfdGWhplDyuCGFdWtAyi/zeN8N1Zx
         7+zb5kYoCxpCDOLyHxE49XsuGP6zVOEkQN5ecIiSNF716SjVsZ4F3EIaFElJ472/B4J6
         MjyQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4Zc6ay+PxHvX8/Fgec+x3VHSl8TQZJhaJsxAGFG+RYuN+VK2GJB9n1Xfym3BRssylkA/MmE4Lllv3@vger.kernel.org
X-Gm-Message-State: AOJu0YxTBWglXDtnZDnpfBXue9fVQLGUVLf50E9r13mMnX3otBu8l7sP
	HuLXFrDm5OEy1inFA0uXJ4ECJmoZrkDnZz5GINQemv0hKmYUDUfC+n9/7RYX7GrRUhnwC5SJL5k
	OZz9L2RA4GW7q7YIs6cHbrYWWvOu8hDPIHY2Zg3eT6yt+y0jvTBR0nFBGUCw5gc59RpIhU7nKzN
	6kXYuTKHNWQBStYA+5+qKewWXqpdk3c1PivuLuRmsaIovGZYlClvDwfPPR9ECdIJhh+ETTgyF21
	dyaDWZ6Bk5nqEYPN5vb0ho=
X-Gm-Gg: ASbGncvoygJ+cAY/vH8bfSHXbOk6d8wGgHtli9oDhQECOUgd4Ki4q+EHOdmjkgfv0ev
	+yBfP2hjV5+mVvef1FiayIxaCR6oxFKQqPzzveMHMNpsqz2WUsH687Gz6PViKBDWFGq4GX+6pVX
	f7fmdR7GMmwmX2tCVvShDCrgvT/s95cJgUUeoFGq1JH1q94BLwNMov5lSUx6yIzBBIACK9svABU
	95zY8YRJh9/CbbmRPuW9V+Momc/+NkgJQTEzH6xu4szBmQ9UXR9SWq3ZOFK4779G5yRvS19Afl1
	uf0vNuEfMRlvDM3emmTtBMx8CzDuDW9hmsIJTBdCxz4BRO68Cs7RhjAQsIBJX3E1Vv/hcY7k0KP
	OEvXEF4cuu7F4nt7XyXfvek9fSR6eOLiu4CSFDm/sXpqmA8rhBH9Ndvu5iPPtQVw+BfOTxZJEms
	R0S2mCrjbed4Q=
X-Google-Smtp-Source: AGHT+IFoM7NVGnEEJayQrm7QosJ7F2GW4LPqVq8cG3qxTB7TbtmbXSnv+EiSn2HrLlIZmaHdB0fD/fTwISC4
X-Received: by 2002:a05:6214:76d:b0:81c:6455:ec77 with SMTP id 6a1803df08f44-87b2efb9b08mr75244796d6.40.1759991111535;
        Wed, 08 Oct 2025 23:25:11 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-118.dlp.protect.broadcom.com. [144.49.247.118])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-878be04c74asm18067566d6.28.2025.10.08.23.25.11
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Oct 2025 23:25:11 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-828bd08624aso219102985a.1
        for <linux-cifs@vger.kernel.org>; Wed, 08 Oct 2025 23:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1759991110; x=1760595910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bS+vJs2offx96KKff6hwDdiXDpHtb7AICfG+1qxivmI=;
        b=B09IWro2M/rBm7Kwi5qYHfrmWk+uPl145ZU15FFVpV5lZorusB8IZ3i56ogn/o70Z7
         vMU7bP+fK5cZzWNkSk89OrnVIdXHioA5S6wHIFwTDQR11/OCPxXR6htXoQDZcFHm+qeG
         WVS/K+lyvI2RHdIA109z4saWl2YezCf8mTFlM=
X-Forwarded-Encrypted: i=1; AJvYcCWab16f2ryTmuhWlySCl8sPvAJWSJK+AhYBs6hpY3E8rYNhXxhhdzMHZu7WBhF/Pz0kk4OJBjFI240q@vger.kernel.org
X-Received: by 2002:a05:620a:4016:b0:862:75e0:76e8 with SMTP id af79cd13be357-883535590bdmr909461185a.42.1759991110351;
        Wed, 08 Oct 2025 23:25:10 -0700 (PDT)
X-Received: by 2002:a05:620a:4016:b0:862:75e0:76e8 with SMTP id af79cd13be357-883535590bdmr909458885a.42.1759991109866;
        Wed, 08 Oct 2025 23:25:09 -0700 (PDT)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a274d0fcsm136973085a.55.2025.10.08.23.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 23:25:08 -0700 (PDT)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	tapas.kundu@broadcom.com,
	sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Paul Aurich <paul@darkrain42.org>,
	Steve French <stfrench@microsoft.com>,
	Cliff Liu <donghua.liu@windriver.com>,
	He Zhe <Zhe.He@windriver.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH v6.1] smb: prevent use-after-free due to open_cached_dir error paths
Date: Wed,  8 Oct 2025 23:08:46 -0700
Message-Id: <20251009060846.351250-1-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Paul Aurich <paul@darkrain42.org>

commit a9685b409a03b73d2980bbfa53eb47555802d0a9 upstream.

If open_cached_dir() encounters an error parsing the lease from the
server, the error handling may race with receiving a lease break,
resulting in open_cached_dir() freeing the cfid while the queued work is
pending.

Update open_cached_dir() to drop refs rather than directly freeing the
cfid.

Have cached_dir_lease_break(), cfids_laundromat_worker(), and
invalidate_all_cached_dirs() clear has_lease immediately while still
holding cfids->cfid_list_lock, and then use this to also simplify the
reference counting in cfids_laundromat_worker() and
invalidate_all_cached_dirs().

Fixes this KASAN splat (which manually injects an error and lease break
in open_cached_dir()):

==================================================================
BUG: KASAN: slab-use-after-free in smb2_cached_lease_break+0x27/0xb0
Read of size 8 at addr ffff88811cc24c10 by task kworker/3:1/65

CPU: 3 UID: 0 PID: 65 Comm: kworker/3:1 Not tainted 6.12.0-rc6-g255cf264e6e5-dirty #87
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
Workqueue: cifsiod smb2_cached_lease_break
Call Trace:
 <TASK>
 dump_stack_lvl+0x77/0xb0
 print_report+0xce/0x660
 kasan_report+0xd3/0x110
 smb2_cached_lease_break+0x27/0xb0
 process_one_work+0x50a/0xc50
 worker_thread+0x2ba/0x530
 kthread+0x17c/0x1c0
 ret_from_fork+0x34/0x60
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Allocated by task 2464:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0xaa/0xb0
 open_cached_dir+0xa7d/0x1fb0
 smb2_query_path_info+0x43c/0x6e0
 cifs_get_fattr+0x346/0xf10
 cifs_get_inode_info+0x157/0x210
 cifs_revalidate_dentry_attr+0x2d1/0x460
 cifs_getattr+0x173/0x470
 vfs_statx_path+0x10f/0x160
 vfs_statx+0xe9/0x150
 vfs_fstatat+0x5e/0xc0
 __do_sys_newfstatat+0x91/0xf0
 do_syscall_64+0x95/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Freed by task 2464:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x60
 __kasan_slab_free+0x51/0x70
 kfree+0x174/0x520
 open_cached_dir+0x97f/0x1fb0
 smb2_query_path_info+0x43c/0x6e0
 cifs_get_fattr+0x346/0xf10
 cifs_get_inode_info+0x157/0x210
 cifs_revalidate_dentry_attr+0x2d1/0x460
 cifs_getattr+0x173/0x470
 vfs_statx_path+0x10f/0x160
 vfs_statx+0xe9/0x150
 vfs_fstatat+0x5e/0xc0
 __do_sys_newfstatat+0x91/0xf0
 do_syscall_64+0x95/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Last potentially related work creation:
 kasan_save_stack+0x33/0x60
 __kasan_record_aux_stack+0xad/0xc0
 insert_work+0x32/0x100
 __queue_work+0x5c9/0x870
 queue_work_on+0x82/0x90
 open_cached_dir+0x1369/0x1fb0
 smb2_query_path_info+0x43c/0x6e0
 cifs_get_fattr+0x346/0xf10
 cifs_get_inode_info+0x157/0x210
 cifs_revalidate_dentry_attr+0x2d1/0x460
 cifs_getattr+0x173/0x470
 vfs_statx_path+0x10f/0x160
 vfs_statx+0xe9/0x150
 vfs_fstatat+0x5e/0xc0
 __do_sys_newfstatat+0x91/0xf0
 do_syscall_64+0x95/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

The buggy address belongs to the object at ffff88811cc24c00
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 16 bytes inside of
 freed 1024-byte region [ffff88811cc24c00, ffff88811cc25000)

Cc: stable@vger.kernel.org
Signed-off-by: Paul Aurich <paul@darkrain42.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Do not apply the change for cfids_laundromat_worker() since there is no
  this function and related feature on 6.1.y. Update open_cached_dir()
  according to method of upstream patch. ]
Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
[Shivani: Modified to apply on 6.1.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 fs/smb/client/cached_dir.c | 39 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 3d028b6a2..23a57a0c8 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -320,17 +320,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		/*
 		 * We are guaranteed to have two references at this point.
 		 * One for the caller and one for a potential lease.
-		 * Release the Lease-ref so that the directory will be closed
-		 * when the caller closes the cached handle.
+		 * Release one here, and the second below.
 		 */
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
 	if (rc) {
-		if (cfid->is_open)
-			SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
-				   cfid->fid.volatile_fid);
-		free_cached_dir(cfid);
-		cfid = NULL;
+		cfid->has_lease = false;
+		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
 
 	if (rc == 0) {
@@ -462,25 +458,24 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 		cfids->num_entries--;
 		cfid->is_open = false;
 		cfid->on_list = false;
-		/* To prevent race with smb2_cached_lease_break() */
-		kref_get(&cfid->refcount);
+		if (cfid->has_lease) {
+			/*
+			 * The lease was never cancelled from the server,
+			 * so steal that reference.
+			 */
+			cfid->has_lease = false;
+		} else
+			kref_get(&cfid->refcount);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
 		cancel_work_sync(&cfid->lease_break);
-		if (cfid->has_lease) {
-			/*
-			 * We lease was never cancelled from the server so we
-			 * need to drop the reference.
-			 */
-			spin_lock(&cfids->cfid_list_lock);
-			cfid->has_lease = false;
-			spin_unlock(&cfids->cfid_list_lock);
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
-		}
-		/* Drop the extra reference opened above*/
+		/*
+		 * Drop the ref-count from above, either the lease-ref (if there
+		 * was one) or the extra one acquired.
+		 */
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
 }
@@ -491,9 +486,6 @@ smb2_cached_lease_break(struct work_struct *work)
 	struct cached_fid *cfid = container_of(work,
 				struct cached_fid, lease_break);
 
-	spin_lock(&cfid->cfids->cfid_list_lock);
-	cfid->has_lease = false;
-	spin_unlock(&cfid->cfids->cfid_list_lock);
 	kref_put(&cfid->refcount, smb2_close_cached_fid);
 }
 
@@ -511,6 +503,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 		    !memcmp(lease_key,
 			    cfid->fid.lease_key,
 			    SMB2_LEASE_KEY_SIZE)) {
+			cfid->has_lease = false;
 			cfid->time = 0;
 			/*
 			 * We found a lease remove it from the list
-- 
2.40.4

