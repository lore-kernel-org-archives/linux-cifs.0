Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99BCCDB47E
	for <linux-cifs@archiver.kernel.org>; Sat, 14 Oct 2023 00:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbjJNAAA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Oct 2023 20:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjJMX77 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Oct 2023 19:59:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D60FAD
        for <linux-cifs@vger.kernel.org>; Fri, 13 Oct 2023 16:59:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61E6C433C9
        for <linux-cifs@vger.kernel.org>; Fri, 13 Oct 2023 23:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697241597;
        bh=1RMd4p+C+RVwLWTlmJNFRrMCPKl6iHFNF1Ki/z9/M/g=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=E8Mj+1QmxkJBKLbMpg7xeiA9RLKhiOdcmwRYDx3H/HK9S76niU2QyELvlF+8sXuXk
         YHC8mHNblnH8lhYIcZLk9+co57WW1+mNgnxX3dVsjLe3RLftW6yhzN3t2je1fSOxfK
         jI1nQ3qksHktV+AGqmI5dJEZPFeO6FApw3uSm2MdixL/7oH1YNuGdJb+wyvnnLp1Po
         shtdOeeI0c5jpOwvbAEjEW7TWn6xeYJ30uk0hyqpLtDa8sNLUKWVN+iEdsgYQTbcuu
         IoiPYJ+o5RIi3RBPZKXp2L86JoC6aLdfNVPeGgBzJKW5JssaowurC0/ZEDlVjVPWy0
         7Eu/pk1LqBkyQ==
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5812eaed1eeso1413852eaf.0
        for <linux-cifs@vger.kernel.org>; Fri, 13 Oct 2023 16:59:57 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz/xV3gfCE/fr9x14tXbtqDs3NaP0v1uH3vpnk8K52V++Rwg70V
        vXjvH030BweDHqGm1jLbQ5i4aUWeI+/AviVMEvc=
X-Google-Smtp-Source: AGHT+IGcXWezvVodcat29WLdYOCEarxHzm0OJTuEsLG2ah5Vb0hzLLJp/aLgfxbXdNagzp0Z/x6ubrj4SGwhA+Z4uWc=
X-Received: by 2002:a4a:d28b:0:b0:57e:1c6a:d551 with SMTP id
 h11-20020a4ad28b000000b0057e1c6ad551mr28895496oos.3.1697241596945; Fri, 13
 Oct 2023 16:59:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:7a42:0:b0:4fa:bc5a:10a5 with HTTP; Fri, 13 Oct 2023
 16:59:55 -0700 (PDT)
In-Reply-To: <20231012174349.462290-1-mmakassikis@freebox.fr>
References: <20231012174349.462290-1-mmakassikis@freebox.fr>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 14 Oct 2023 08:59:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ApYG=edN7ocheLtTe3R_+pz-TitCNX7XoBi0fK3709A@mail.gmail.com>
Message-ID: <CAKYAXd-ApYG=edN7ocheLtTe3R_+pz-TitCNX7XoBi0fK3709A@mail.gmail.com>
Subject: Re: [PATCH] fs/smb: server: fix recursive locking in vfs helpers
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-10-13 2:43 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> Running smb2.rename test from Samba smbtorture suite against a kernel built
> with lockdep triggers a "possible recursive locking detected" warning.
>
> This is because mnt_want_write() is called twice with no mnt_drop_write()
> in between:
>   -> ksmbd_vfs_mkdir()
>     -> ksmbd_vfs_kern_path_create()
>        -> kern_path_create()
>           -> filename_create()
>             -> mnt_want_write()
>        -> mnt_want_write()
>
> Fix this by removing the mnt_want_write/mnt_drop_write calls from vfs
> helpers that call kern_path_create().
>
> Full lockdep trace below:
>
> ============================================
> WARNING: possible recursive locking detected
> 6.6.0-rc5 #775 Not tainted
> --------------------------------------------
> kworker/1:1/32 is trying to acquire lock:
> ffff888005ac83f8 (sb_writers#5){.+.+}-{0:0}, at: ksmbd_vfs_mkdir+0xe1/0x410
>
> but task is already holding lock:
> ffff888005ac83f8 (sb_writers#5){.+.+}-{0:0}, at: filename_create+0xb6/0x260
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(sb_writers#5);
>   lock(sb_writers#5);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 4 locks held by kworker/1:1/32:
>  #0: ffff8880064e4138 ((wq_completion)ksmbd-io){+.+.}-{0:0}, at:
> process_one_work+0x40e/0x980
>  #1: ffff888005b0fdd0 ((work_completion)(&work->work)){+.+.}-{0:0}, at:
> process_one_work+0x40e/0x980
>  #2: ffff888005ac83f8 (sb_writers#5){.+.+}-{0:0}, at:
> filename_create+0xb6/0x260
>  #3: ffff8880057ce760 (&type->i_mutex_dir_key#3/1){+.+.}-{3:3}, at:
> filename_create+0x123/0x260
>
> stack backtrace:
> CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 6.6.0-rc5 #775
> Workqueue: ksmbd-io handle_ksmbd_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x4f/0x90
>  dump_stack+0x14/0x20
>  print_deadlock_bug+0x2f0/0x410
>  check_deadlock+0x26b/0x3b0
>  __lock_acquire+0xce2/0x1060
>  ? mark_lock.part.0+0xff/0x720
>  ? __pfx___lock_acquire+0x10/0x10
>  ? mark_held_locks+0x6b/0x90
>  lock_acquire.part.0+0x125/0x2d0
>  ? ksmbd_vfs_mkdir+0xe1/0x410
>  ? __pfx_lock_acquire.part.0+0x10/0x10
>  ? __kmem_cache_free+0x179/0x280
>  ? ____kasan_slab_free+0x15b/0x1d0
>  ? __kasan_slab_free+0x16/0x20
>  ? slab_free_freelist_hook+0xbc/0x180
>  lock_acquire+0x93/0x160
>  ? ksmbd_vfs_mkdir+0xe1/0x410
>  mnt_want_write+0x49/0x220
>  ? ksmbd_vfs_mkdir+0xe1/0x410
>  ksmbd_vfs_mkdir+0xe1/0x410
>  ? __pfx__printk+0x10/0x10
>  ? __pfx_ksmbd_vfs_mkdir+0x10/0x10
>  smb2_open+0x1064/0x38b0
>  ? __pfx___lock_acquire+0x10/0x10
>  ? __pfx_smb2_open+0x10/0x10
>  ? __lock_release+0x13f/0x290
>  ? smb2_validate_credit_charge+0x25d/0x360
>  ? __pfx___lock_release+0x10/0x10
>  ? do_raw_spin_lock+0x127/0x1c0
>  ? __pfx_do_raw_spin_lock+0x10/0x10
>  ? do_raw_spin_unlock+0xac/0x110
>  ? _raw_spin_unlock+0x22/0x50
>  ? smb2_validate_credit_charge+0x25d/0x360
>  ? ksmbd_smb2_check_message+0x3be/0x400
>  ? __pfx_ksmbd_smb2_check_message+0x10/0x10
>  __process_request+0x151/0x310
>  __handle_ksmbd_work+0x33c/0x520
>  ? __pfx___handle_ksmbd_work+0x10/0x10
>  handle_ksmbd_work+0x4a/0xd0
>  process_one_work+0x4a7/0x980
>  ? __pfx_process_one_work+0x10/0x10
>  ? assign_work+0xe1/0x120
>  worker_thread+0x365/0x570
>  ? __pfx_worker_thread+0x10/0x10
>  kthread+0x18d/0x1d0
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x38/0x70
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1b/0x30
>  </TASK>
>
> Fixes: 40b268d384a2 ("ksmbd: add mnt_want_write to ksmbd vfs functions")
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  fs/smb/server/vfs.c | 17 -----------------
>  1 file changed, 17 deletions(-)
>
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index b5a5e50fc9ca..ac49e295d4c3 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -173,10 +173,6 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const
> char *name, umode_t mode)
>  		return err;
>  	}
>
> -	err = mnt_want_write(path.mnt);
> -	if (err)
> -		goto out_err;
> -
>  	mode |= S_IFREG;
>  	err = vfs_create(mnt_idmap(path.mnt), d_inode(path.dentry),
>  			 dentry, mode, true);
> @@ -186,9 +182,7 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const char
> *name, umode_t mode)
>  	} else {
>  		pr_err("File(%s): creation failed (err:%d)\n", name, err);
>  	}
> -	mnt_drop_write(path.mnt);
>
> -out_err:
>  	done_path_create(&path, dentry);
>  	return err;
>  }
> @@ -219,10 +213,6 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char
> *name, umode_t mode)
>  		return err;
>  	}
>
> -	err = mnt_want_write(path.mnt);
> -	if (err)
> -		goto out_err2;
> -
>  	idmap = mnt_idmap(path.mnt);
>  	mode |= S_IFDIR;
>  	err = vfs_mkdir(idmap, d_inode(path.dentry), dentry, mode);
> @@ -246,8 +236,6 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char
> *name, umode_t mode)
>  	}
>
>  out_err1:
minor nit: we can change it with our_err if removing out_err2.
> -	mnt_drop_write(path.mnt);
> -out_err2:
>  	done_path_create(&path, dentry);
>  	if (err)
>  		pr_err("mkdir(%s): creation failed (err:%d)\n", name, err);
> @@ -665,16 +653,11 @@ int ksmbd_vfs_link(struct ksmbd_work *work, const char
> *oldname,
>  		goto out3;
>  	}
>
> -	err = mnt_want_write(newpath.mnt);
> -	if (err)
> -		goto out3;
> -
>  	err = vfs_link(oldpath.dentry, mnt_idmap(newpath.mnt),
>  		       d_inode(newpath.dentry),
>  		       dentry, NULL);
>  	if (err)
>  		ksmbd_debug(VFS, "vfs_link failed err %d\n", err);
> -	mnt_drop_write(newpath.mnt);
>
>  out3:
>  	done_path_create(&newpath, dentry);
> --
> 2.34.1
>
>
