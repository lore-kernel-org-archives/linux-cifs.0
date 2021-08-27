Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F7DC432BE
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Aug 2021 13:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43A5B60EE7
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Aug 2021 13:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245231AbhH0N2P (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Aug 2021 09:28:15 -0400
Received: from smtp2.axis.com ([195.60.68.18]:50423 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231964AbhH0N2O (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 27 Aug 2021 09:28:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1630070846;
  x=1661606846;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8jEUbn7ptnmVDyB/tf9F6ROul/ehBcpe2veqNqgzwu8=;
  b=i9Hgu7BTwB1a7u82oTUdwGPUcWbDWF51ZOcxM4/HNolMFZgLWMoLxdWK
   aPIq6VY9bJCknA1Hw47JUeMG2Xsg+ngl5i2u9824sUdZfs1tQ9pxsDji1
   Wx0ps6vmhiO0ULmHPN8cb32xggFkBasxxLY6k1T/4e6LPx2qk7HAD0NxE
   mi1YpK77fK9JS9Pwz9LI9s4yA+j0LTVJIB97DrjvAATqeBZvtX99GS1GU
   k5LKghDRTK3eL1F6oE+Naa1SmLS1Ayd1agn7452ADboMzkCBEyKCvFMH9
   6juc+5ZiW0agaZpD10bvIiUrygJyBgLa9lvO6Yhje7h+XKhLwCIlaAhyv
   g==;
Date:   Fri, 27 Aug 2021 15:27:24 +0200
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Hillf Danton <hdanton@sina.com>
CC:     Bruno Goncalves <bgoncalv@redhat.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiong Zhou <xzhou@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Steve French <stfrench@microsoft.com>, <aaptel@suse.com>
Subject: Re: possible circular locking dependency detected:
 compound_send_recv+0x189/0x910 [cifs] vm_mmap_pgoff+0x85/0x160
Message-ID: <20210827132724.GA30322@axis.com>
References: <CA+QYu4rS+UkLUS-BDwNAOaMW2nQ4JY3V0OqdnLe3=zNoTrDDYQ@mail.gmail.com>
 <20210827082746.2490-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210827082746.2490-1-hdanton@sina.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Aug 27, 2021 at 10:27:46AM +0200, Hillf Danton wrote:
> On Thu, 26 Aug 2021 14:05:32 +0200 Bruno Goncalves wrote:
> >[13107.832907] ======================================================
> >[13107.839805] WARNING: possible circular locking dependency detected
> >[13107.846702] 5.14.0-rc7 #1 Not tainted
> >[13107.850789] ------------------------------------------------------
> >[13107.857686] fio/1323391 is trying to acquire lock:
> >[13107.863025] ffff9cdf0cae72e0 (&tcp_ses->srv_mutex){+.+.}-{3:3}, at:
> >compound_send_recv+0x189/0x910 [cifs]
> >[13107.873786]
> >               but task is already holding lock:
> >[13107.880295] ffff9cdf07f9c8a8 (&mm->mmap_lock#2){++++}-{3:3}, at:
> >vm_mmap_pgoff+0x85/0x160
> >[13107.889425]
> >               which lock already depends on the new lock.
> >
> >[13107.898559]
> >               the existing dependency chain (in reverse order) is:
> >[13107.906910]
> >               -> #3 (&mm->mmap_lock#2){++++}-{3:3}:
> >[13107.913815]        down_write+0x3d/0x70
> >[13107.918105]        mpol_rebind_mm+0x27/0xe0
> >[13107.922784]        cpuset_attach+0x226/0x3e0
> >[13107.927566]        cgroup_migrate_execute+0x414/0x520
> >[13107.933206]        cgroup_update_dfl_csses+0x212/0x240
> >[13107.938943]        cgroup_subtree_control_write+0x352/0x430
> >[13107.945163]        kernfs_fop_write_iter+0x134/0x1d0
> >[13107.950710]        new_sync_write+0x10b/0x180
> >[13107.955575]        vfs_write+0x26a/0x380
> >[13107.959953]        ksys_write+0x58/0xd0
> >[13107.964226]        do_syscall_64+0x5c/0x80
> >[13107.968804]        entry_SYSCALL_64_after_hwframe+0x44/0xae
> >[13107.975030]
> >               -> #2 (&cpuset_rwsem){++++}-{0:0}:
> >[13107.981642]        cpuset_read_lock+0x3e/0xb0
> >[13107.986507]        __sched_setscheduler+0x420/0xa00
> >[13107.991956]        sched_setscheduler_nocheck+0x68/0x70
> >[13107.997788]        __kthread_create_on_node+0x12f/0x1a0
> >[13108.003627]        kthread_create_on_node+0x39/0x40
> >[13108.009072]        cryptomgr_notify+0x379/0x4d0
> >[13108.014127]        blocking_notifier_call_chain+0x63/0x90
> >[13108.020172]        crypto_probing_notify+0x20/0x50
> >[13108.025522]        crypto_wait_for_test+0x1a/0x70
> >[13108.030771]        crypto_register_alg+0x56/0x70
> >[13108.035921]        do_one_initcall+0x5b/0x2d0
> >[13108.040777]        kernel_init_freeable+0x284/0x2d0
> >[13108.046215]        kernel_init+0x16/0x120
> >[13108.050681]        ret_from_fork+0x22/0x30
> >[13108.055250]
> >               -> #1 ((crypto_chain).rwsem){++++}-{3:3}:
> >[13108.062538]        down_read+0x40/0x50
> >[13108.066720]        blocking_notifier_call_chain+0x2c/0x90
> >[13108.072745]        crypto_alg_mod_lookup+0x10b/0x220
> >[13108.078287]        crypto_alloc_tfm_node+0x4c/0xd0
> >[13108.083635]        cifs_alloc_hash+0x30/0xe0 [cifs]
> >[13108.089156]        smb311_crypto_shash_allocate+0x65/0xc0 [cifs]
> >[13108.095929]        smb311_update_preauth_hash+0x78/0x1c0 [cifs]
> >[13108.102584]        compound_send_recv+0x56f/0x910 [cifs]
> >[13108.108555]        cifs_send_recv+0x1f/0x30 [cifs]
> >[13108.113958]        SMB2_negotiate+0x3a8/0x1230 [cifs]
> >[13108.119660]        smb2_negotiate+0x4f/0x70 [cifs]
> >[13108.125052]        cifs_negotiate_protocol+0x6b/0xd0 [cifs]
> >[13108.131309]        cifs_get_smb_ses+0x2f6/0x1110 [cifs]
> >[13108.137177]        mount_get_conns+0x98/0x400 [cifs]
> >[13108.142755]        cifs_mount+0x89/0x780 [cifs]
> >[13108.147850]        cifs_smb3_do_mount+0x15d/0x6a0 [cifs]
> >[13108.153813]        smb3_get_tree+0xeb/0x1e0 [cifs]
> >[13108.159207]        vfs_get_tree+0x28/0xc0
> >[13108.163680]        path_mount+0x42f/0xb60
> >[13108.168154]        __x64_sys_mount+0xe3/0x120
> >[13108.173014]        do_syscall_64+0x5c/0x80
> >[13108.177586]        entry_SYSCALL_64_after_hwframe+0x44/0xae
> >[13108.183806]
> >               -> #0 (&tcp_ses->srv_mutex){+.+.}-{3:3}:
> >[13108.190993]        __lock_acquire+0x1158/0x1de0
> >[13108.196050]        lock_acquire+0xb5/0x2b0
> >[13108.200618]        __mutex_lock+0x8a/0x760
> >[13108.205187]        compound_send_recv+0x189/0x910 [cifs]
> >[13108.211158]        cifs_send_recv+0x1f/0x30 [cifs]
> >[13108.216547]        SMB2_write+0x192/0x4b0 [cifs]
> >[13108.221746]        cifs_write+0x181/0x600 [cifs]
> >[13108.226939]        cifs_writepage_locked+0x34c/0x670 [cifs]
> >[13108.233247]        cifs_launder_page+0xcf/0xe0 [cifs]
> >[13108.238925]        invalidate_inode_pages2_range+0x3c6/0x4d0
> >[13108.245264]        cifs_invalidate_mapping+0x35/0x60 [cifs]
> >[13108.251523]        cifs_revalidate_mapping+0x9c/0xb0 [cifs]
> >[13108.257787]        cifs_file_mmap+0x4b/0x3c0 [cifs]
> >[13108.263318]        mmap_region+0x415/0x690
> >[13108.267896]        do_mmap+0x362/0x560
> >[13108.272082]        vm_mmap_pgoff+0xb8/0x160
> >[13108.276758]        ksys_mmap_pgoff+0x1a1/0x200
> >[13108.281724]        do_syscall_64+0x5c/0x80
> >[13108.286302]        entry_SYSCALL_64_after_hwframe+0x44/0xae
> >[13108.292525]
> >               other info that might help us debug this:
> >
> >[13108.301457] Chain exists of:
> >                 &tcp_ses->srv_mutex --> &cpuset_rwsem --> &mm->mmap_lock#2
> >
> >[13108.313788]  Possible unsafe locking scenario:
> >
> >[13108.320395]        CPU0                    CPU1
> >[13108.325450]        ----                    ----
> >[13108.330503]   lock(&mm->mmap_lock#2);
> >[13108.334590]                                lock(&cpuset_rwsem);
> >[13108.341196]                                lock(&mm->mmap_lock#2);
> >[13108.348099]   lock(&tcp_ses->srv_mutex);
> >[13108.352478]
> >                *** DEADLOCK ***
> >
> >[1] https://gitlab.com/cki-project/kernel-tests/-/tree/main/filesystems/xfs/xfstests
> >[2] https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefix=datawarehouse-public/2021/08/24/358739877/build_x86_64_redhat%3A1530602378/tests/xfstests_cifsv3_11/
> 
> 
> Only if it is too difficult to fix 05946d4b7a73 ("cifs: Fix preauth hash
> corruption") within cifs then fix the deadlock by replacing kthread_run()
> with queue_work().

Perhaps I'm missing something, but would the lockdep complaint really go
away without 05946d4b7a73?  cifs_alloc_hash() is called under the
srv_mutex in other places (for example setup_ntlmv2_rsp()), so the

	&tcp_ses->srv_mutex --> &cpuset_rwsem --> &mm->mmap_lock

chain would still exist, and compound_send_recv() takes srv_mutex before
05946d4b7a73 too, so &mm->mmap_lock -> srv_mutex would exist too.

For cifs_alloc_hash() to be able to be called without the srv_mutex I
guess it would have to be done when the tcp_ses is allocated.  That
however would essentially be a revert of commit 95dc8dd14e2e84cc3ada
("Limit allocation of crypto mechanisms to dialect which requires").
