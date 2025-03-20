Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F422633E1
	for <linux-cifs@vger.kernel.org>; Thu, 20 Mar 2025 04:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742445307; cv=none; b=Wsjgh8ApiwQhozv/2x9F6C4zMYi9Umnkr/+2J+p3ccPwSMajATT9odeYrUFg+YpDHjWVoIN8eFaOQsBQp+iEgzblJhOWwJeH56zoI/gRSOYXF5z/eSdepynI+SxSB7r0oMhR2EqqE6nFxwheyplQ5b/SoaYk8Ow1tnL44GZGhcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742445307; c=relaxed/simple;
	bh=bFrx9C0pWj4suhX/LoBj5NZf4or0vXbyaA2ACGGJ4KA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=oYfpVLHRmZoOXxVpmEnFldwNFxLhMeqW1U2if9erJ1kY3uwnTlfMwysjND4sy4TvVZltyVpmCTFUpM8qFWitOwzzMp6kLDCBZU3ZoGRFMqfoeYalpXBat03aUf1MIrckCqCtWdRCkO2N3UBns4W4ZYlOF2NKJfwc1sEpPW3XmqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WQhydY05; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WQhydY05"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5499659e669so458142e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 19 Mar 2025 21:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742445303; x=1743050103; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TRLo2kQ7lBNqSy492a0RQRsrMILV10zb/t6tp1TtokE=;
        b=WQhydY05i6hdtaxKq24kEwWiuhHYy78oBDAYnUXqLq0pEHQYQo/7HmPVeafSgUEaiw
         IKATQvM549QQVaEdtag3bGpWxFaAJ3+7i6fWdtQtI7XxDZAqB7dqn5timUqJvJtIM4UJ
         ojeEBI8XQviuTof6EmrENiZgDDzbq7aJAMZEcrI6ylDd9eG3LwvJwn9pqqKZMLFJj7Jy
         whAIYO1x1TINpg8DS4tQ48YUWzXeWOE+gdeYIOt4ZJ7kBEGln4MUe/B6A+3C6ooOgko8
         7/3qHR61adtfpXctkwwUI1Oot4I0/+T1A/0KMtm3Et57M5S2D2QxIEbHhZkCMNWv5YY0
         xNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742445303; x=1743050103;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TRLo2kQ7lBNqSy492a0RQRsrMILV10zb/t6tp1TtokE=;
        b=cYj8aUjrvXO+stJlmbGzvrem3cwn2G/ck7BuiUpva2R8nt189YJ8MSovyIQSKl3sOv
         MXg1cLRVAatMQuSNgvbhFZ9c3d4QSMgGeLGpdE1F+yNf0SwNt+jtOpdvdzA/1V/99YAJ
         hKuqvCBzK9b7DN/J2D3EulMmijRAGzcpOKL4yCxCu41d0it/QEXeE0MYzHK0YAfE2DGu
         SL1+65U4ZaMxh8pkyGHEAQcdlrJKRb6ACWiJ5ZCO1ZazZqKGD134wRn7Imy8AcjpvuK2
         sh8bBqDv9sCQNWTuzrwGHUmriVUibH/MwOSTGagfEuW4tqdW4NWSCNKHjUpl5afxm13b
         QKoA==
X-Forwarded-Encrypted: i=1; AJvYcCWFgMarj9cO6kHkvubNojUjJ0zfBhm3awuGdQb+Lmm1R7x9sq0GA5gt1V12yWdSW4U6SBa+5o/X8Hd+@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/uTMsh4f3GQ9feX0d22t+l1j31O0wvUEncYQf9vjzu63QAno3
	cwXXF3nUHNLhA+acKUsWI+F8qa6cdaKAPL2AoxnHVnZ7O7ShQa+uhCKSSBQ3KpFY+jHTmIl/S5m
	yiW1uwZB9PYs205Sn6qgzs9S4ggw=
X-Gm-Gg: ASbGncvGFuGq3rneFFVEtLRyC/OTBPPwm8ZsA3qI0bOmgt7OQZGi7qLoknp+ozreH4o
	qbOHJfeW2U1myWmPfeAKh6Z81CkjyOzo5/D9RS81RfFyjbmQ8a5ENTgruGxGUMQBlGK9Dvy1Nzf
	K3Cbn9e1XajfrIu/T+iPhRWDss4ntYZwGvfqrVGFnAy5gwtYuK0RJLWc94fgs7
X-Google-Smtp-Source: AGHT+IF4/KHlJ5XNxSHd1AP7rGeEPlQXriz/vtTY05pN4S6VofA/2AB0b6IX568MVot97BCWqqu6TrJRtniHnFdOX9U=
X-Received: by 2002:a05:6512:6ca:b0:549:8d2a:8820 with SMTP id
 2adb3069b0e04-54acb1bafb2mr1921762e87.17.1742445302643; Wed, 19 Mar 2025
 21:35:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250319090839.3631424-1-donghua.liu@windriver.com> <Z9uGCaxYJgs1gvwM@vaarsuvius.home.arpa>
In-Reply-To: <Z9uGCaxYJgs1gvwM@vaarsuvius.home.arpa>
From: Steve French <smfrench@gmail.com>
Date: Wed, 19 Mar 2025 23:34:51 -0500
X-Gm-Features: AQ5f1JqaliK6ClAtD88sfLvU1QoIGa5hdQY1cT-rkwq0dZLkVMASuioW8hJywvY
Message-ID: <CAH2r5muZmEZ4j3J1C3RVzRUQg3b=ihffmR18wBz1gm+wLB6=eQ@mail.gmail.com>
Subject: Re: [PATCH 6.1.y] smb: prevent use-after-free due to open_cached_dir
 error paths
To: Cliff Liu <donghua.liu@windriver.com>, pc@cjr.nz, sprasad@microsoft.com, 
	tom@talpey.com, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Zhe.He@windriver.com, ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Also would be good to see if we can isolate the umount race with
freeing cached dentries which I can occasionally reproduce to Windows
part way through a large XFS test (but never fails if directory leases
disabled)

On Wed, Mar 19, 2025 at 10:16=E2=80=AFPM Paul Aurich <paul@darkrain42.org> =
wrote:
>
> Thanks for backporting this!  I think you should pick up these patches as
> pre-requisites for the one here:
>
> - 5c86919455c1 ("smb: client: fix use-after-free in
>    smb2_query_info_compound()")
> - 7afb86733685 ("smb: Don't leak cfid when reconnect races with
>    open_cached_dir")
>
> All three of these patches touch on how the cached directory handling of =
the
> 'has_lease' field works, and my work was built on top of those.
>
> On 2025-03-19 17:08:39 +0800, Cliff Liu wrote:
> >From: Paul Aurich <paul@darkrain42.org>
> >
> >If open_cached_dir() encounters an error parsing the lease from the
> >server, the error handling may race with receiving a lease break,
> >resulting in open_cached_dir() freeing the cfid while the queued work is
> >pending.
> >
> >Update open_cached_dir() to drop refs rather than directly freeing the
> >cfid.
> >
> >Have cached_dir_lease_break(), cfids_laundromat_worker(), and
> >invalidate_all_cached_dirs() clear has_lease immediately while still
> >holding cfids->cfid_list_lock, and then use this to also simplify the
> >reference counting in cfids_laundromat_worker() and
> >invalidate_all_cached_dirs().
> >
> >Fixes this KASAN splat (which manually injects an error and lease break
> >in open_cached_dir()):
> >
> >=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >BUG: KASAN: slab-use-after-free in smb2_cached_lease_break+0x27/0xb0
> >Read of size 8 at addr ffff88811cc24c10 by task kworker/3:1/65
> >
> >CPU: 3 UID: 0 PID: 65 Comm: kworker/3:1 Not tainted 6.12.0-rc6-g255cf264=
e6e5-dirty #87
> >Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Refere=
nce Platform, BIOS 6.00 11/12/2020
> >Workqueue: cifsiod smb2_cached_lease_break
> >Call Trace:
> > <TASK>
> > dump_stack_lvl+0x77/0xb0
> > print_report+0xce/0x660
> > kasan_report+0xd3/0x110
> > smb2_cached_lease_break+0x27/0xb0
> > process_one_work+0x50a/0xc50
> > worker_thread+0x2ba/0x530
> > kthread+0x17c/0x1c0
> > ret_from_fork+0x34/0x60
> > ret_from_fork_asm+0x1a/0x30
> > </TASK>
> >
> >Allocated by task 2464:
> > kasan_save_stack+0x33/0x60
> > kasan_save_track+0x14/0x30
> > __kasan_kmalloc+0xaa/0xb0
> > open_cached_dir+0xa7d/0x1fb0
> > smb2_query_path_info+0x43c/0x6e0
> > cifs_get_fattr+0x346/0xf10
> > cifs_get_inode_info+0x157/0x210
> > cifs_revalidate_dentry_attr+0x2d1/0x460
> > cifs_getattr+0x173/0x470
> > vfs_statx_path+0x10f/0x160
> > vfs_statx+0xe9/0x150
> > vfs_fstatat+0x5e/0xc0
> > __do_sys_newfstatat+0x91/0xf0
> > do_syscall_64+0x95/0x1a0
> > entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> >Freed by task 2464:
> > kasan_save_stack+0x33/0x60
> > kasan_save_track+0x14/0x30
> > kasan_save_free_info+0x3b/0x60
> > __kasan_slab_free+0x51/0x70
> > kfree+0x174/0x520
> > open_cached_dir+0x97f/0x1fb0
> > smb2_query_path_info+0x43c/0x6e0
> > cifs_get_fattr+0x346/0xf10
> > cifs_get_inode_info+0x157/0x210
> > cifs_revalidate_dentry_attr+0x2d1/0x460
> > cifs_getattr+0x173/0x470
> > vfs_statx_path+0x10f/0x160
> > vfs_statx+0xe9/0x150
> > vfs_fstatat+0x5e/0xc0
> > __do_sys_newfstatat+0x91/0xf0
> > do_syscall_64+0x95/0x1a0
> > entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> >Last potentially related work creation:
> > kasan_save_stack+0x33/0x60
> > __kasan_record_aux_stack+0xad/0xc0
> > insert_work+0x32/0x100
> > __queue_work+0x5c9/0x870
> > queue_work_on+0x82/0x90
> > open_cached_dir+0x1369/0x1fb0
> > smb2_query_path_info+0x43c/0x6e0
> > cifs_get_fattr+0x346/0xf10
> > cifs_get_inode_info+0x157/0x210
> > cifs_revalidate_dentry_attr+0x2d1/0x460
> > cifs_getattr+0x173/0x470
> > vfs_statx_path+0x10f/0x160
> > vfs_statx+0xe9/0x150
> > vfs_fstatat+0x5e/0xc0
> > __do_sys_newfstatat+0x91/0xf0
> > do_syscall_64+0x95/0x1a0
> > entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> >The buggy address belongs to the object at ffff88811cc24c00
> > which belongs to the cache kmalloc-1k of size 1024
> >The buggy address is located 16 bytes inside of
> > freed 1024-byte region [ffff88811cc24c00, ffff88811cc25000)
> >
> >Cc: stable@vger.kernel.org
> >Signed-off-by: Paul Aurich <paul@darkrain42.org>
> >Signed-off-by: Steve French <stfrench@microsoft.com>
> >[ Do not apply the change for cfids_laundromat_worker() since there is n=
o
> >  this function and related feature on 6.1.y. Update open_cached_dir()
> >  according to method of upstream patch. ]
> >Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
> >Signed-off-by: He Zhe <Zhe.He@windriver.com>
> >---
> >Verified the build test.
> >---
> > fs/smb/client/cached_dir.c | 39 ++++++++++++++++----------------------
> > 1 file changed, 16 insertions(+), 23 deletions(-)
> >
> >diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> >index d09226c1ac90..d65d5fe5b8fe 100644
> >--- a/fs/smb/client/cached_dir.c
> >+++ b/fs/smb/client/cached_dir.c
> >@@ -320,17 +320,13 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >               /*
> >                * We are guaranteed to have two references at this point=
.
> >                * One for the caller and one for a potential lease.
> >-               * Release the Lease-ref so that the directory will be cl=
osed
> >-               * when the caller closes the cached handle.
> >+               * Release one here, and the second below.
> >                */
> >               kref_put(&cfid->refcount, smb2_close_cached_fid);
> >       }
> >       if (rc) {
> >-              if (cfid->is_open)
> >-                      SMB2_close(0, cfid->tcon, cfid->fid.persistent_fi=
d,
> >-                                 cfid->fid.volatile_fid);
> >-              free_cached_dir(cfid);
> >-              cfid =3D NULL;
> >+              cfid->has_lease =3D false;
>
> This should be cleared while holding cfids->cfid_list_lock, which is what=
 the
> upstream version of this backport (a9685b409a0) does, because of how this
> error handling was adjusted in 5c86919455c1 ("smb: client: fix use-after-=
free
> in smb2_query_info_compound()")
>
> >+              kref_put(&cfid->refcount, smb2_close_cached_fid);
> >       }
> >
> >       if (rc =3D=3D 0) {
> >@@ -462,25 +458,24 @@ void invalidate_all_cached_dirs(struct cifs_tcon *=
tcon)
> >               cfids->num_entries--;
> >               cfid->is_open =3D false;
> >               cfid->on_list =3D false;
> >-              /* To prevent race with smb2_cached_lease_break() */
> >-              kref_get(&cfid->refcount);
> >+              if (cfid->has_lease) {
> >+                      /*
> >+                       * The lease was never cancelled from the server,
> >+                       * so steal that reference.
> >+                       */
> >+                      cfid->has_lease =3D false;
> >+              } else
> >+                      kref_get(&cfid->refcount);
> >       }
> >       spin_unlock(&cfids->cfid_list_lock);
> >
> >       list_for_each_entry_safe(cfid, q, &entry, entry) {
> >               list_del(&cfid->entry);
> >               cancel_work_sync(&cfid->lease_break);
> >-              if (cfid->has_lease) {
> >-                      /*
> >-                       * We lease was never cancelled from the server s=
o we
> >-                       * need to drop the reference.
> >-                       */
> >-                      spin_lock(&cfids->cfid_list_lock);
> >-                      cfid->has_lease =3D false;
> >-                      spin_unlock(&cfids->cfid_list_lock);
> >-                      kref_put(&cfid->refcount, smb2_close_cached_fid);
> >-              }
> >-              /* Drop the extra reference opened above*/
> >+              /*
> >+               * Drop the ref-count from above, either the lease-ref (i=
f there
> >+               * was one) or the extra one acquired.
> >+               */
> >               kref_put(&cfid->refcount, smb2_close_cached_fid);
> >       }
> > }
> >@@ -491,9 +486,6 @@ smb2_cached_lease_break(struct work_struct *work)
> >       struct cached_fid *cfid =3D container_of(work,
> >                               struct cached_fid, lease_break);
> >
> >-      spin_lock(&cfid->cfids->cfid_list_lock);
> >-      cfid->has_lease =3D false;
> >-      spin_unlock(&cfid->cfids->cfid_list_lock);
> >       kref_put(&cfid->refcount, smb2_close_cached_fid);
> > }
> >
> >@@ -511,6 +503,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, _=
_u8 lease_key[16])
> >                   !memcmp(lease_key,
> >                           cfid->fid.lease_key,
> >                           SMB2_LEASE_KEY_SIZE)) {
> >+                      cfid->has_lease =3D false;
> >                       cfid->time =3D 0;
> >                       /*
> >                        * We found a lease remove it from the list
> >--
> >2.43.0
> >
>
> ~Paul
>
>


--=20
Thanks,

Steve
