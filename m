Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D23DC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 23 May 2022 12:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbiEWMid (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 08:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235562AbiEWMiG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 08:38:06 -0400
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9004CD68
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 05:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1653309485;
  x=1684845485;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QPKgmtpPaeFAur9eeIUpWRFa61NcsUjXuXl7iMDl1Ck=;
  b=DfY1ihzzNNq4lqCuGz1SnCdhkDLnyWRro23q7GNESxxPrD0YEBkr2N8Q
   h4IdJL2NcoaSrcmAVKKgUv861s1KiduqgB9T69mXPSd3LzpNG4vXEQ6LB
   /y9LEcY8qVE9V4L5d9IvD3fzbUyAqiOzUFqDzFUkLBCkkoICmVeygJKhO
   fpTHbMCX+CcM4eyo7x5dUEtxUA24+e1s/cSXXlQqsvaaUOM66bh44Rvgz
   CdZGxTz3lxiTQ+pgwSNrOqUa8ZHzaHEv4LFoYpWElg4oXK+FrtRDwDW/x
   UCoSl6QcaTvKKYw6VEq8SX8grlV+lptjgoa+B+ie2K6iEh3JkPJS0ZlZ8
   g==;
Date:   Mon, 23 May 2022 14:38:02 +0200
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
CC:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: lockdep deadlock warning
Message-ID: <20220523123755.GA13668@axis.com>
References: <CANT5p=rqcYfYMVHirqvdnnca4Mo+JQSw5Qu12v=kPfpk5yhhmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANT5p=rqcYfYMVHirqvdnnca4Mo+JQSw5Qu12v=kPfpk5yhhmg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Feb 14, 2022 at 10:19:30PM +0530, Shyam Prasad N wrote:
> I was trying some experiments on 5.17-rc4 with lockdep enabled.
> And I noticed this deadlock warning.

This is trivially reproducible by triggering reclaim (eg. by having a
process allocate a lot of memory) while someone is wring to a CIFS
mount.

> [Mon Feb 14 16:31:14 2022] ======================================================
> [Mon Feb 14 16:31:14 2022] WARNING: possible circular locking dependency detected
> [Mon Feb 14 16:31:14 2022] 5.17.0-rc3+ #4 Tainted: G           OE
> [Mon Feb 14 16:31:14 2022] ------------------------------------------------------
> [Mon Feb 14 16:31:14 2022] kswapd0/48 is trying to acquire lock:
> [Mon Feb 14 16:31:14 2022] ffff888113aca2e0 (&tcp_ses->srv_mutex){+.+.}-{3:3}, at: compound_send_recv+0x2e8/0x12c0 [cifs]
> [Mon Feb 14 16:31:14 2022]
>                            but task is already holding lock:
> [Mon Feb 14 16:31:14 2022] ffffffffae4162a0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0xa36/0xb20
> [Mon Feb 14 16:31:14 2022]
>                            which lock already depends on the new lock.
> 
> [Mon Feb 14 16:31:14 2022]
>                            the existing dependency chain (in reverse order) is:
> [Mon Feb 14 16:31:14 2022]
>                            -> #1 (fs_reclaim){+.+.}-{0:0}:
> [Mon Feb 14 16:31:14 2022]        fs_reclaim_acquire+0xc2/0xf0
> [Mon Feb 14 16:31:14 2022]        __kmalloc_node+0x61/0x4a0
> [Mon Feb 14 16:31:14 2022]        crypto_create_tfm_node+0x53/0x180
> [Mon Feb 14 16:31:14 2022]        crypto_alloc_tfm_node+0x98/0x130
> [Mon Feb 14 16:31:14 2022]        crypto_alloc_shash+0x1f/0x30
> [Mon Feb 14 16:31:14 2022]        cifs_alloc_hash+0x46/0x140 [cifs]
> [Mon Feb 14 16:31:14 2022]        smb311_crypto_shash_allocate+0x39/0xc0 [cifs]
> [Mon Feb 14 16:31:14 2022]        smb311_update_preauth_hash+0xb5/0x240 [cifs]
> [Mon Feb 14 16:31:14 2022]        compound_send_recv+0xdc2/0x12c0 [cifs]
> [Mon Feb 14 16:31:14 2022]        cifs_send_recv+0x22/0x30 [cifs]
> [Mon Feb 14 16:31:14 2022]        SMB2_negotiate+0x56d/0x1a40 [cifs]
> [Mon Feb 14 16:31:14 2022]        smb2_negotiate+0x57/0x70 [cifs]
> [Mon Feb 14 16:31:14 2022]        cifs_negotiate_protocol+0x10b/0x180 [cifs]
> [Mon Feb 14 16:31:14 2022]        cifs_get_smb_ses+0x627/0x10d0 [cifs]
> [Mon Feb 14 16:31:14 2022]        mount_get_conns+0x8c/0x660 [cifs]
> [Mon Feb 14 16:31:14 2022]        cifs_mount+0xf8/0xe20 [cifs]
> [Mon Feb 14 16:31:14 2022]        cifs_smb3_do_mount+0x1dd/0xbe0 [cifs]
> [Mon Feb 14 16:31:14 2022]        smb3_get_tree+0x1a0/0x2e0 [cifs]
> [Mon Feb 14 16:31:14 2022]        vfs_get_tree+0x52/0x140
> [Mon Feb 14 16:31:14 2022]        path_mount+0x635/0x10c0
> [Mon Feb 14 16:31:14 2022]        __x64_sys_mount+0x1bf/0x210
> [Mon Feb 14 16:31:14 2022]        do_syscall_64+0x5c/0xc0
> [Mon Feb 14 16:31:14 2022]        entry_SYSCALL_64_after_hwframe+0x44/0xae
> [Mon Feb 14 16:31:14 2022]
>                            -> #0 (&tcp_ses->srv_mutex){+.+.}-{3:3}:
> [Mon Feb 14 16:31:14 2022]        __lock_acquire+0x1c7a/0x30a0
> [Mon Feb 14 16:31:14 2022]        lock_acquire+0x18c/0x430
> [Mon Feb 14 16:31:14 2022]        __mutex_lock+0x11f/0xc70
> [Mon Feb 14 16:31:14 2022]        mutex_lock_nested+0x1b/0x20
> [Mon Feb 14 16:31:14 2022]        compound_send_recv+0x2e8/0x12c0 [cifs]
> [Mon Feb 14 16:31:14 2022]        cifs_send_recv+0x22/0x30 [cifs]
> [Mon Feb 14 16:31:14 2022]        SMB2_write+0x45f/0x6e0 [cifs]
> [Mon Feb 14 16:31:14 2022]        smb2_sync_write+0x7e/0x90 [cifs]
> [Mon Feb 14 16:31:14 2022]        cifs_write+0x2cf/0x7b0 [cifs]
> [Mon Feb 14 16:31:14 2022]        cifs_writepage_locked+0x59c/0x730 [cifs]
> [Mon Feb 14 16:31:14 2022]        cifs_writepage+0x15/0x30 [cifs]
> [Mon Feb 14 16:31:14 2022]        pageout+0x23b/0x650
> [Mon Feb 14 16:31:14 2022]        shrink_page_list+0x152d/0x19f0
> [Mon Feb 14 16:31:14 2022]        shrink_lruvec+0xa89/0x14d0
> [Mon Feb 14 16:31:14 2022]        shrink_node+0x518/0xd40
> [Mon Feb 14 16:31:14 2022]        balance_pgdat+0x58c/0xb20
> [Mon Feb 14 16:31:14 2022]        kswapd+0x40f/0x7b0
> [Mon Feb 14 16:31:14 2022]        kthread+0x174/0x1b0
> [Mon Feb 14 16:31:14 2022]        ret_from_fork+0x22/0x30
> [Mon Feb 14 16:31:14 2022]
>                            other info that might help us debug this:
> 
> [Mon Feb 14 16:31:14 2022]  Possible unsafe locking scenario:
> 
> [Mon Feb 14 16:31:14 2022]        CPU0                    CPU1
> [Mon Feb 14 16:31:14 2022]        ----                    ----
> [Mon Feb 14 16:31:14 2022]   lock(fs_reclaim);
> [Mon Feb 14 16:31:14 2022]                                lock(&tcp_ses->srv_mutex);
> [Mon Feb 14 16:31:14 2022]                                lock(fs_reclaim);
> [Mon Feb 14 16:31:14 2022]   lock(&tcp_ses->srv_mutex);
> [Mon Feb 14 16:31:14 2022]
>                             *** DEADLOCK ***

> It's about a circular dependency locking fs_reclaim lock with srv_mutex held.
> Does someone here understand this dependency?

The crypto shash allocation does allocations with GFP_KERNEL (i.e.,
GFP_NOFS is not set and so fs reclaim can be triggered) and this is
called under the CIFS srv_mutex.  However, the CIFS srv_mutex is also
used in the reclaim path as the splat shows.  This is the dependency
which lockdep is complaining about.

A way to remove this particular dependency is to make CIFS do a
memalloc_nofs_save/restore() around the places it takes the srv_mutex.
However, doing this does not solve the lockdep splats completely since
there is another dependency via some internal locks in crypto, see the
log below.

The only solution I see (short of changing all GFP_KERNEL to GFP_NOFS in
crypto) is to not perform crypto shash allocations under the srv_mutex.
That was how the code was before 95dc8dd14e2e84cc3ada ("Limit allocation
of crypto mechanisms to dialect which requires"), and that would likely
solve other lockdep splats in CIFS too as noted earlier:

 https://lore.kernel.org/linux-cifs/20210908142729.GA6873@axis.com/

[   64.988063] ======================================================
[   64.988640] WARNING: possible circular locking dependency detected
[   64.989202] 5.18.0+ #49 Not tainted
[   64.989534] ------------------------------------------------------
[   64.990103] kswapd0/49 is trying to acquire lock:
[   64.990541] ffff888005d282e0 (&tcp_ses->_srv_mutex){+.+.}-{3:3}, at: compound_send_recv+0x308/0x12e0 [cifs]
[   64.991547] 
[   64.991547] but task is already holding lock:
[   64.992068] ffffffffa8ce6d40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x811/0x8a0
[   64.992779] 
[   64.992779] which lock already depends on the new lock.
[   64.992779] 
[   64.993520] 
[   64.993520] the existing dependency chain (in reverse order) is:
[   64.994174] 
[   64.994174] -> #2 (fs_reclaim){+.+.}-{0:0}:
[   64.994692]        fs_reclaim_acquire+0x7a/0xb0
[   64.995089]        kmem_cache_alloc_trace+0x33/0x220
[   64.995520]        crypto_larval_alloc+0x35/0xf0
[   64.995953]        __crypto_register_alg+0x115/0x250
[   64.996417]        crypto_register_alg+0x44/0xb0
[   64.996852]        rsa_init+0x15/0x50
[   64.997189]        do_one_initcall+0xbb/0x3d0
[   64.997581]        kernel_init_freeable+0x335/0x38e
[   64.998039]        kernel_init+0x19/0x140
[   64.998399]        ret_from_fork+0x22/0x30
[   64.998764] 
[   64.998764] -> #1 (crypto_alg_sem){++++}-{3:3}:
[   64.999307]        down_read+0x9c/0x300
[   64.999643]        crypto_alg_lookup+0x40/0x120
[   65.000038]        crypto_alg_mod_lookup+0x41/0x250
[   65.000460]        crypto_alloc_tfm_node+0x73/0x120
[   65.000901]        cifs_alloc_hash+0x3f/0x140 [cifs]
[   65.001490]        smb311_crypto_shash_allocate+0x34/0xc0 [cifs]
[   65.002155]        smb311_update_preauth_hash+0xaa/0x230 [cifs]
[   65.002812]        compound_send_recv+0xd5e/0x12e0 [cifs]
[   65.003407]        cifs_send_recv+0x1f/0x30 [cifs]
[   65.003962]        SMB2_negotiate+0x4ec/0x1c10 [cifs]
[   65.004559]        smb2_negotiate+0x50/0x70 [cifs]
[   65.005132]        cifs_negotiate_protocol+0xfe/0x170 [cifs]
[   65.005779]        cifs_get_smb_ses+0x612/0x1010 [cifs]
[   65.006389]        cifs_mount+0x70/0xc80 [cifs]
[   65.006939]        cifs_smb3_do_mount+0x1dd/0xcc0 [cifs]
[   65.007536]        smb3_get_tree+0x18f/0x2c0 [cifs]
[   65.008115]        vfs_get_tree+0x4c/0x140
[   65.008499]        path_mount+0x3a9/0xfb0
[   65.008869]        __x64_sys_mount+0x190/0x1d0
[   65.009289]        do_syscall_64+0x3b/0x90
[   65.009650]        entry_SYSCALL_64_after_hwframe+0x44/0xae
[   65.010161] 
[   65.010161] -> #0 (&tcp_ses->_srv_mutex){+.+.}-{3:3}:
[   65.010733]        __lock_acquire+0x1bc5/0x3460
[   65.011139]        lock_acquire+0x165/0x3f0
[   65.011874]        __mutex_lock+0x10d/0xcd0
[   65.012318]        compound_send_recv+0x308/0x12e0 [cifs]
[   65.013060]        cifs_send_recv+0x1f/0x30 [cifs]
[   65.013646]        SMB2_write+0x3e2/0x910 [cifs]
[   65.014370]        cifs_write+0x2cc/0x790 [cifs]
[   65.014907]        cifs_writepage_locked+0x502/0x890 [cifs]
[   65.015553]        cifs_writepage+0x10/0x30 [cifs]
[   65.016159]        shrink_page_list+0x1695/0x25e0
[   65.016568]        shrink_lruvec+0x7b1/0xe50
[   65.016943]        shrink_node+0x335/0x810
[   65.017326]        balance_pgdat+0x3e4/0x8a0
[   65.017719]        kswapd+0x3ac/0x720
[   65.018059]        kthread+0x17d/0x1b0
[   65.018389]        ret_from_fork+0x22/0x30
[   65.018747] 
[   65.018747] other info that might help us debug this:
[   65.018747] 
[   65.019434] Chain exists of:
[   65.019434]   &tcp_ses->_srv_mutex --> crypto_alg_sem --> fs_reclaim
[   65.019434] 
[   65.020410]  Possible unsafe locking scenario:
[   65.020410] 
[   65.020955]        CPU0                    CPU1
[   65.021384]        ----                    ----
[   65.021803]   lock(fs_reclaim);
[   65.022102]                                lock(crypto_alg_sem);
[   65.022658]                                lock(fs_reclaim);
[   65.023320]   lock(&tcp_ses->_srv_mutex);
[   65.023873] 
[   65.023873]  *** DEADLOCK ***
[   65.023873] 
[   65.024388] 1 lock held by kswapd0/49:
[   65.024858]  #0: ffffffffa8ce6d40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x811/0x8a0
[   65.025606] 
[   65.025606] stack backtrace:
[   65.026010] CPU: 2 PID: 49 Comm: kswapd0 Not tainted 5.18.0+ #49
[   65.026751] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[   65.027499] Call Trace:
[   65.027729]  <TASK>
[   65.027934]  dump_stack_lvl+0x45/0x59
[   65.028307]  check_noncircular+0x1d6/0x200
[   65.028703]  ? print_circular_bug+0x220/0x220
[   65.029114]  ? __orc_find+0x68/0xc0
[   65.029454]  ? lock_chain_count+0x20/0x20
[   65.029834]  ? __orc_find+0x68/0xc0
[   65.030168]  ? add_chain_block+0x1f3/0x2b0
[   65.030535]  __lock_acquire+0x1bc5/0x3460
[   65.030988]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[   65.031559]  ? __orc_find+0x68/0xc0
[   65.031999]  ? preempt_count_sub+0x14/0xc0
[   65.032507]  lock_acquire+0x165/0x3f0
[   65.032855]  ? compound_send_recv+0x308/0x12e0 [cifs]
[   65.033452]  ? lock_release+0x430/0x430
[   65.033793]  ? wait_for_free_credits+0x6bd/0xc40 [cifs]
[   65.034412]  ? lock_downgrade+0x3b0/0x3b0
[   65.035101]  ? lock_is_held_type+0xd7/0x130
[   65.035525]  __mutex_lock+0x10d/0xcd0
[   65.035979]  ? compound_send_recv+0x308/0x12e0 [cifs]
[   65.036555]  ? compound_send_recv+0x308/0x12e0 [cifs]
[   65.037131]  ? mutex_lock_io_nested+0xbd0/0xbd0
[   65.037648]  ? trace_smb3_credit_timeout+0x170/0x170 [cifs]
[   65.038553]  ? lock_downgrade+0x3b0/0x3b0
[   65.038915]  ? do_raw_spin_lock+0x119/0x1b0
[   65.039375]  ? rwlock_bug.part.0+0x60/0x60
[   65.039791]  compound_send_recv+0x308/0x12e0 [cifs]
[   65.040351]  ? cifs_pick_channel+0x90/0x90 [cifs]
[   65.041000]  ? lock_is_held_type+0xd7/0x130
[   65.041402]  ? find_held_lock+0x85/0xa0
[   65.041757]  ? lock_release+0x241/0x430
[   65.042109]  ? __smb2_plain_req_init+0x12d/0x400 [cifs]
[   65.042878]  ? lock_downgrade+0x3b0/0x3b0
[   65.043263]  ? do_raw_spin_lock+0x119/0x1b0
[   65.043649]  ? do_raw_spin_unlock+0x93/0xf0
[   65.044045]  cifs_send_recv+0x1f/0x30 [cifs]
[   65.044571]  SMB2_write+0x3e2/0x910 [cifs]
[   65.045394]  ? lock_is_held_type+0xd7/0x130
[   65.045859]  ? smb2_async_writev+0x890/0x890 [cifs]
[   65.046417]  ? lock_downgrade+0x3b0/0x3b0
[   65.046882]  ? do_raw_spin_lock+0x119/0x1b0
[   65.047250]  ? lock_is_held_type+0xd7/0x130
[   65.047639]  ? smb2_sync_write+0x56/0x80 [cifs]
[   65.048207]  cifs_write+0x2cc/0x790 [cifs]
[   65.048879]  ? __cifs_writev+0x630/0x630 [cifs]
[   65.049510]  ? do_raw_spin_lock+0x119/0x1b0
[   65.049882]  ? rwlock_bug.part.0+0x60/0x60
[   65.050244]  ? do_raw_spin_unlock+0x93/0xf0
[   65.050628]  ? preempt_count_sub+0x14/0xc0
[   65.051347]  cifs_writepage_locked+0x502/0x890 [cifs]
[   65.051942]  ? cifs_writepages+0x1560/0x1560 [cifs]
[   65.052567]  ? __page_set_anon_rmap+0x150/0x150
[   65.052983]  ? invalid_folio_referenced_vma+0x10/0x10
[   65.053463]  ? preempt_count_sub+0x14/0xc0
[   65.053839]  ? percpu_counter_add_batch+0x66/0xe0
[   65.054258]  cifs_writepage+0x10/0x30 [cifs]
[   65.054782]  shrink_page_list+0x1695/0x25e0
[   65.055182]  ? shrink_active_list+0xa40/0xa40
[   65.055600]  ? lock_is_held_type+0xd7/0x130
[   65.056236]  ? find_held_lock+0x85/0xa0
[   65.056656]  ? shrink_lruvec+0x771/0xe50
[   65.057018]  ? mark_held_locks+0x65/0x90
[   65.057389]  ? lockdep_hardirqs_on_prepare+0x124/0x220
[   65.057952]  shrink_lruvec+0x7b1/0xe50
[   65.058315]  ? reclaim_throttle+0x540/0x540
[   65.058779]  ? mark_lock.part.0+0xfa/0x1a00
[   65.059170]  ? lockdep_hardirqs_on_prepare+0x220/0x220
[   65.059654]  ? __up_read+0x15d/0x450
[   65.059994]  ? __lock_acquire+0x850/0x3460
[   65.060389]  ? find_held_lock+0x85/0xa0
[   65.060923]  ? shrink_node+0x18c/0x810
[   65.061283]  ? lock_is_held_type+0xd7/0x130
[   65.061684]  shrink_node+0x335/0x810
[   65.062175]  balance_pgdat+0x3e4/0x8a0
[   65.062522]  ? __node_reclaim+0x530/0x530
[   65.062880]  ? lock_is_held_type+0xd7/0x130
[   65.063447]  ? _raw_spin_lock_irqsave+0x53/0x60
[   65.063948]  ? lock_is_held_type+0xd7/0x130
[   65.064386]  ? lock_is_held_type+0xd7/0x130
[   65.064875]  kswapd+0x3ac/0x720
[   65.065222]  ? balance_pgdat+0x8a0/0x8a0
[   65.065573]  ? mark_held_locks+0x24/0x90
[   65.065931]  ? destroy_sched_domains_rcu+0x30/0x30
[   65.066648]  ? _raw_spin_unlock_irqrestore+0x2d/0x50
[   65.067141]  ? lockdep_hardirqs_on+0x79/0x100
[   65.067539]  ? preempt_count_sub+0x14/0xc0
[   65.068037]  ? balance_pgdat+0x8a0/0x8a0
[   65.068408]  kthread+0x17d/0x1b0
[   65.068716]  ? kthread_complete_and_exit+0x20/0x20
[   65.069314]  ret_from_fork+0x22/0x30
[   65.069753]  </TASK>
