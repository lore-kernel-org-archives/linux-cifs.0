Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D68278157;
	Tue,  5 Aug 2025 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754411963; cv=none; b=O7mjBI0XyPy5HQwLPBFjY78V/43C76dNN8aVZa+Ph9ZV/naKIy84eVGTejWS1XPb1FJBjnfIu5knD+P0n2TlFg/Kosabfy5V405VqBONdujJOxffNqbf0QgU86YCgVd5t6MvibC3+jlZY3fTUs3TYKU2vA/znpmtIsyzIL6ame8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754411963; c=relaxed/simple;
	bh=b67hdpS+FPcvO12E1yOOXwD0RXnM686aAt72FMaBC9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vsvw978Msdhtj+TOkfFc4MOcFtGwfS7DmiwE6o7i01OV+XCnbpOojT2RVTrkxyFUBr6TxueKl+PvixkwjsmVFwkaLehTsDpWdWHlyTDfsxjQfGiTrvx1i2WGzsq92U5V1Zi2EG6wbPzL327fFC+7dD0CeNE3A4R2V2TFyhZ1QW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bqObdcsg; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bqObdcsg"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-70756dc2c00so65810866d6.1;
        Tue, 05 Aug 2025 09:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754411961; x=1755016761; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dI19Lv0BsqixSu6SrtKghDdwuIIizFdvm/SlRDEbwq4=;
        b=bqObdcsgQrdMGS6Mlre7sFq3J3AHAiPQ/2B+ZAJoT2hP07q+olsA7LKv8+F3n7m11e
         jm5ne0oR+QOr0mfMAtCR1N9fGHQvQ30ih6HSINmoKHmHupHaIzrwDZeSMwu6LL0fCIQ3
         NNMsIug3eJz6UryvQI0BgT4ZXvY7onUsGwmGHxEBHmEU8kD5Y0OXtfWiis49eBWO6UeR
         aYgsqapu6eB24Rgg1znkAySjdH3Whs/vXQvOG9Kagg81ycoea5nK2QZ6rEAMLaUamfwx
         38jsNC0lIHHvPfzt1BcTXXOOiqQraMvV232g8V2qMkcjvZWuYg2s8gFJpASJzA0qbR0D
         fAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754411961; x=1755016761;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dI19Lv0BsqixSu6SrtKghDdwuIIizFdvm/SlRDEbwq4=;
        b=Np3iRUDs1oO3iepV90ZFQnGL8UaurzFH8uvrPPh+TT62njPyCWL5qjV/rpoJcx3MGQ
         xGPM7Wpg2RxYcB6Z8G3YJV4oaAKBAhGIO2osqlpGgBRrpA4RiNZHUm7cHSgjc8AVbpBh
         228CdsgqucD868EjcK7IY7wKwJHGal6MonhLYXDzxmwownRqqeTjlSnaLthfHWcd9sgG
         iF/JLqKy2dSuT9UKFUIU1WA5PugUEIHJj7Kl4Zv8vRToCDBTZF0t9KEt1r8ocUl8GVP1
         os+sZ6DsfzqaUHiF1G//TZDvFXVFpERXMcwkxh2SIE+is2xdVa7ykNKj057V7Fw/oAwi
         zjCA==
X-Forwarded-Encrypted: i=1; AJvYcCUcJl4fKK6X3o6hUJKgvZkMQgR9tiCYJYU/+pAC20dfRbuGJe4atBwYy3KkIM8xhOAxImTM5KPmHb8diSPz@vger.kernel.org, AJvYcCXXhzhuOqGXddL5sF+ehAN2MBuTZJ7K8ikVaVp5l4UpaN822phUmSb4ztbVXAJsuwN0mgPbHgkoGftZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ6EWWPJebm/DzamRX5gRSdTy6LTfusClXTyTDQSBEeNwi332e
	i8oWvCZEzmUgkk57hY3HpHR6GUNKZzb0ZajwVzZquAU5a99e8IWo2jY4LgKSC3q3Bhgu6nXuJ7S
	39fwmneXaYUmfGeXCqFT5+r6+6SzUWew=
X-Gm-Gg: ASbGnct0ewW3ZVXxUhmirxNPJYhYdtarA5VvAoqSXPIIfe2oPDWl6+k489hj0rRLYj8
	mZGQtWaYH0GjwaqW1fjtP3J6jOIhc3Vyhw/lE5nOlawYMBqeDsic/m++i3FYOmluN7yv9GoKpcn
	rdKr2ohyzW/WfPo+rOkGzcE0oj7MdICbIpiF9Oig0TN2BMuzwS/+NN0sfiiOXLeZrSO9F0U00Ek
	+hI6PqDby7JxpXE5BB2gZ4dbQcf2UMUpAHU7QqE
X-Google-Smtp-Source: AGHT+IEPr5ndtPdPpUXnx5zwGznpK8z6iDPj5EqVyM7T/9JSorR39iJKz/Jzq1VsXQUtM3f6X6uRypCdwbq0aPfwBuI=
X-Received: by 2002:a05:6214:d88:b0:707:4cbc:34b3 with SMTP id
 6a1803df08f44-70936533a0amr197598916d6.15.1754411960431; Tue, 05 Aug 2025
 09:39:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250805064708.332465-1-wangzhaolong@huaweicloud.com>
In-Reply-To: <20250805064708.332465-1-wangzhaolong@huaweicloud.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 5 Aug 2025 11:39:09 -0500
X-Gm-Features: Ac12FXwjEx4rjYfEcUEBpFOQ0uUn-SEggosVc5-VGTnSkxLazyiklU23ZnXAI0M
Message-ID: <CAH2r5mssz19Qr+fmY62BnHOzwjQmWWU=wHXEVFkyTRGaWn-t0g@mail.gmail.com>
Subject: Re: [PATCH V2 0/4] Fix mid_q_entry memory leaks in SMB client
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: pshilov@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	chengzhihao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com, 
	Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The first three patches (cleanup) look fine and have added to
cifs-2.6.git for-next (also added Enzo Acked-by) but the fourth patch
("smb: client: fix mid_q_entry memleak leak with per-mid locking")
causes xfstest generic/001 to fail with signing enabled.  See
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/=
builds/58/steps/34/logs/stdio
and http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builder=
s/5/builds/59/steps/34/logs/stdio


[Tue Aug 5 11:03:32 2025] run fstests generic/001 at 2025-08-05 11:03:32
[Tue Aug 5 11:03:33 2025] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[Tue Aug 5 11:03:33 2025] [ BUG: Invalid wait context ]
[Tue Aug 5 11:03:33 2025] 6.16.0 #1 Tainted: G E
[Tue Aug 5 11:03:33 2025] -----------------------------
[Tue Aug 5 11:03:33 2025] cifsd/24912 is trying to lock:
[Tue Aug 5 11:03:33 2025] ffffffffafc14630
(crypto_alg_sem){++++}-{4:4}, at: crypto_alg_lookup+0x40/0x120
[Tue Aug 5 11:03:33 2025] other info that might help us debug this:
[Tue Aug 5 11:03:33 2025] context-{5:5}
[Tue Aug 5 11:03:33 2025] 1 lock held by cifsd/24912:
[Tue Aug 5 11:03:33 2025] #0: ff11000134c25870
(&temp->mid_lock){+.+.}-{3:3}, at: mid_execute_callback+0x19/0x40
[cifs]
[Tue Aug 5 11:03:33 2025] stack backtrace:
[Tue Aug 5 11:03:33 2025] CPU: 1 UID: 0 PID: 24912 Comm: cifsd
Tainted: G E 6.16.0 #1 PREEMPT(voluntary)
[Tue Aug 5 11:03:33 2025] Tainted: [E]=3DUNSIGNED_MODULE
[Tue Aug 5 11:03:33 2025] Hardware name: Red Hat KVM, BIOS
1.16.3-4.el9 04/01/2014
[Tue Aug 5 11:03:33 2025] Call Trace:
[Tue Aug 5 11:03:33 2025] <TASK>
[Tue Aug 5 11:03:33 2025] dump_stack_lvl+0x79/0xb0
[Tue Aug 5 11:03:33 2025] __lock_acquire+0xace/0x21c0
[Tue Aug 5 11:03:33 2025] ? check_irq_usage+0xa4/0xa80
[Tue Aug 5 11:03:33 2025] lock_acquire+0x143/0x2d0
[Tue Aug 5 11:03:33 2025] ? crypto_alg_lookup+0x40/0x120
[Tue Aug 5 11:03:33 2025] ? check_noncircular+0x71/0x120
[Tue Aug 5 11:03:33 2025] down_read+0x7c/0x2e0
[Tue Aug 5 11:03:33 2025] ? crypto_alg_lookup+0x40/0x120
[Tue Aug 5 11:03:33 2025] ? __pfx_down_read+0x10/0x10
[Tue Aug 5 11:03:33 2025] ? lockdep_unlock+0x51/0xc0
[Tue Aug 5 11:03:33 2025] ? __lock_acquire+0x11ee/0x21c0
[Tue Aug 5 11:03:33 2025] crypto_alg_lookup+0x40/0x120
[Tue Aug 5 11:03:33 2025] crypto_alg_mod_lookup+0x53/0x2b0
[Tue Aug 5 11:03:33 2025] crypto_alloc_tfm_node+0x76/0x130
[Tue Aug 5 11:03:33 2025] cifs_alloc_hash+0x44/0x130 [cifs]
[Tue Aug 5 11:03:33 2025] smb3_calc_signature+0x4f0/0x7b0 [cifs]
[Tue Aug 5 11:03:33 2025] ? __pfx_smb3_calc_signature+0x10/0x10 [cifs]
[Tue Aug 5 11:03:33 2025] ? find_held_lock+0x2b/0x80
[Tue Aug 5 11:03:33 2025] ? tcp_recvmsg+0xc9/0x2d0
[Tue Aug 5 11:03:33 2025] ? rcu_is_watching+0x20/0x50
[Tue Aug 5 11:03:33 2025] ? trace_irq_enable.constprop.0+0xac/0xe0
[Tue Aug 5 11:03:33 2025] ? tcp_recvmsg+0xc9/0x2d0
[Tue Aug 5 11:03:33 2025] ? __local_bh_enable_ip+0x90/0xf0
[Tue Aug 5 11:03:33 2025] ? sock_has_perm+0x97/0x1a0
[Tue Aug 5 11:03:33 2025] smb2_verify_signature+0x178/0x290 [cifs]
[Tue Aug 5 11:03:33 2025] ? __pfx_smb2_verify_signature+0x10/0x10 [cifs]
[Tue Aug 5 11:03:33 2025] ? look_up_lock_class+0x5d/0x140
[Tue Aug 5 11:03:33 2025] smb2_check_receive+0x154/0x1c0 [cifs]
[Tue Aug 5 11:03:33 2025] ? __pfx_smb2_check_receive+0x10/0x10 [cifs]
[Tue Aug 5 11:03:33 2025] ? __lock_acquire+0x3f1/0x21c0
[Tue Aug 5 11:03:33 2025] ? __lock_acquire+0x3f1/0x21c0
[Tue Aug 5 11:03:33 2025] smb2_writev_callback+0x1f2/0x870 [cifs]
[Tue Aug 5 11:03:33 2025] ? lock_acquire+0x143/0x2d0
[Tue Aug 5 11:03:33 2025] ? mid_execute_callback+0x19/0x40 [cifs]
[Tue Aug 5 11:03:33 2025] ? __pfx_smb2_writev_callback+0x10/0x10 [cifs]
[Tue Aug 5 11:03:33 2025] ? do_raw_spin_lock+0x10c/0x190
[Tue Aug 5 11:03:33 2025] ? __pfx_do_raw_spin_lock+0x10/0x10
[Tue Aug 5 11:03:33 2025] ? _raw_spin_unlock+0x23/0x40
[Tue Aug 5 11:03:33 2025] mid_execute_callback+0x33/0x40 [cifs]
[Tue Aug 5 11:03:33 2025] cifs_demultiplex_thread+0xc95/0x15e0 [cifs]
[Tue Aug 5 11:03:33 2025] ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
[Tue Aug 5 11:03:33 2025] ? find_held_lock+0x2b/0x80
[Tue Aug 5 11:03:33 2025] ? __kthread_parkme+0x4b/0xd0
[Tue Aug 5 11:03:33 2025] ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
[Tue Aug 5 11:03:33 2025] kthread+0x216/0x3e0
[Tue Aug 5 11:03:33 2025] ? __pfx_kthread+0x10/0x10
[Tue Aug 5 11:03:33 2025] ? __pfx_kthread+0x10/0x10
[Tue Aug 5 11:03:33 2025] ? lock_release+0xc4/0x270
[Tue Aug 5 11:03:33 2025] ? rcu_is_watching+0x20/0x50
[Tue Aug 5 11:03:33 2025] ? __pfx_kthread+0x10/0x10
[Tue Aug 5 11:03:33 2025] ret_from_fork+0x23a/0x2e0
[Tue Aug 5 11:03:33 2025] ? __pfx_kthread+0x10/0x10
[Tue Aug 5 11:03:33 2025] ret_from_fork_asm+0x1a/0x30
[Tue Aug 5 11:03:33 2025] </TASK>

(it worked without the patch see e.g.
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/5/=
builds/60
and http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builder=
s/5/builds/56)

On Tue, Aug 5, 2025 at 1:54=E2=80=AFAM Wang Zhaolong
<wangzhaolong@huaweicloud.com> wrote:
>
> I've been investigating a pretty nasty memory leak in the SMB client. Whe=
n
> compound requests get interrupted by signals, we end up with mid_q_entry
> structures and server buffers that never get freed[1].
>
> User foreground process                    cifsd
> cifs_readdir
>  open_cached_dir
>   cifs_send_recv
>    compound_send_recv
>     smb2_setup_request
>      smb2_mid_entry_alloc
>       smb2_get_mid_entry
>        smb2_mid_entry_alloc
>         mempool_alloc // alloc mid
>         kref_init(&temp->refcount); // refcount =3D 1
>      mid[0]->callback =3D cifs_compound_callback;
>      mid[1]->callback =3D cifs_compound_last_callback;
>      smb_send_rqst
>      rc =3D wait_for_response
>       wait_event_state TASK_KILLABLE
>                                   cifs_demultiplex_thread
>                                     allocate_buffers
>                                       server->bigbuf =3D cifs_buf_get()
>                                     standard_receive3
>                                       ->find_mid()
>                                         smb2_find_mid
>                                           __smb2_find_mid
>                                            kref_get(&mid->refcount) // +1
>                                       cifs_handle_standard
>                                         handle_mid
>                                          /* bigbuf will also leak */
>                                          mid->resp_buf =3D server->bigbuf
>                                          server->bigbuf =3D NULL;
>                                          dequeue_mid
>                                      /* in for loop */
>                                     mids[0]->callback
>                                       cifs_compound_callback
>     /* Signal interrupts wait: rc =3D -ERESTARTSYS */
>     /* if (... || midQ[i]->mid_state =3D=3D MID_RESPONSE_RECEIVED) *?
>     midQ[0]->callback =3D cifs_cancelled_callback;
>     cancelled_mid[i] =3D true;
>                                        /* The change comes too late */
>                                        mid->mid_state =3D MID_RESPONSE_RE=
ADY
>                                     release_mid  // -1
>     /* cancelled_mid[i] =3D=3D true causes mid won't be released
>        in compound_send_recv cleanup */
>     /* cifs_cancelled_callback won't executed to release mid */
>
> The core issue is a race condition where cifs_cancelled_callback never
> gets a chance to run, so cleanup never happens. I've spent quite a bit
> of time trying to understand how to fix this safely.
>
> Honestly, my first instinct was to just patch the callback assignment
> logic directly. But the more I dug into it, the more I realized that
> the current locking scheme makes this really tricky to do safely. We
> have one big lock protecting multiple different things, and trying to
> fix the race condition directly felt like playing with fire.
>
> I kept running into scenarios where a "simple" fix could introduce
> deadlocks or new race conditions. After looking at this from different
> angles, I came to the conclusion that I needed to refactor the locking
> first to create a safe foundation for the actual fix.
>
> Patches 1-3 are foundational refactoring. These three patches rename
> locks for clarity, separate counter protection from queue operations,
> and replace the confusing mid_flags bitmask with explicit boolean
> fields. Basically, they untangle the current locking mess so I can
> implement the real fix without breaking anything.
>
> The 4th patch in the series is where the real fix happens. With
> the previous refactoring in place, I could safely add a lock to each
> mid_q_entry and implement atomic callback execution. This eliminates
> the race condition that was causing the leaks.
>
> In summary, my approach to the fix is to use smaller-grained locking to
> avoid race conditions. However, during the implementation process,
> this approach involves more changes than I initially hoped for. If
> there's a simpler or more elegant way to fix this race condition that
> I've missed, I'd love to hear about it. I've tried to be thorough in
> my analysis, but I know there are folks with more experience in this
> codebase who might see a better path.
>
> V1 -> V2:
>   - Inline the mid_execute_callback() in the smb2ops.c to eliminate
>     the sparse warning.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D220404 [1]
>
> Wang Zhaolong (4):
>   smb: client: rename server mid_lock to mid_queue_lock
>   smb: client: add mid_counter_lock to protect the mid counter counter
>   smb: client: smb: client: eliminate mid_flags field
>   smb: client: fix mid_q_entry memleak leak with per-mid locking
>
>  fs/smb/client/cifs_debug.c    | 12 ++++--
>  fs/smb/client/cifsglob.h      | 22 ++++++-----
>  fs/smb/client/connect.c       | 57 +++++++++++++++++----------
>  fs/smb/client/smb1ops.c       | 23 +++++++----
>  fs/smb/client/smb2ops.c       | 72 +++++++++++++++++++----------------
>  fs/smb/client/smb2transport.c |  5 ++-
>  fs/smb/client/transport.c     | 71 ++++++++++++++++++----------------
>  7 files changed, 152 insertions(+), 110 deletions(-)
>
> --
> 2.39.2
>
>


--=20
Thanks,

Steve
