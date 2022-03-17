Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AACBC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Mar 2022 14:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiCQOL0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Mar 2022 10:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiCQOL0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Mar 2022 10:11:26 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751B41FDFF1
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 07:10:09 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id c15so7353824ljr.9
        for <linux-cifs@vger.kernel.org>; Thu, 17 Mar 2022 07:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ri0ULwCodwvHfgsha0CVV6qpvmiC/8s+g1EVIFE6i9k=;
        b=NXUOdY419QEQQ+k/x+puwD3jAyCy7CJQ71mtz51C+qsw1BFGQUUMH2sGWbikHPaW1H
         NHnM0Q+WHpgKATTEQbM/7ezFZM29cLj5+R2Tk401Nt70KrpJPSsm5A1kFPBP6LbxcPrI
         FkckYuLSeLnlkFbV51Xk0i2LqQ4UBKL0jP83czVhTa7YymMSARnw+vzeAPnZe99z/AxG
         ePgTp/symLC3cuoGGVBr0NoxySyrQTvWApVPtwUxxFc4HRYitnQXAwtrRhqoChDCzKMJ
         RS8kJIGy1NVqcGIIL+U94fu8q8no7Ux4jf0zWrPC6OqE4rLr32eQESUtmk1j7dNI/n/L
         qWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ri0ULwCodwvHfgsha0CVV6qpvmiC/8s+g1EVIFE6i9k=;
        b=r6nybKTu308rGj7NPibJB3qrH2f8H5btiM2v2ib9rxbU22su8gVjktHJSlMpNHc+LS
         Oxt2CiZlZPFNXNPimESljuKPJye5ZkyCD/NrCrqk/2258rJL1yGtadhys5z9A98gqyr4
         OD14XeL3Q0mN7t1xtUHenSU4obucGEFl2fD1JPlBr+CciQGD3syVv8A35lfs2uUkAlKs
         Vysovf8NVTf+4aDM2+8P450Cgx7eOihjVYBwAbhoLGrK0WE4n18NMmOp9QAlsEZIo6QM
         PnTpSd9LNw98VakV5yEcTuNQ2Ko1Jl/4YUs794JVpk85eV9wm+sm7389QWRg4Lg51MM0
         Vv+w==
X-Gm-Message-State: AOAM532ruRzvEg4omlYChwVuhQNfeg0FCc3dy0wFzkAPkGMZD1Ex/hpM
        KjvswtT0yQciLb44OhjE61eRudAW7VIs2GGOBEuxiINF01s=
X-Google-Smtp-Source: ABdhPJy2dlSVFXJ+3ptgZwUboBYjGsSarTmOJzisuNnY7u9RsOcn5g7xWxUuVPdNGM/a9V1kEG6nyGwKXXwGi7WXmcY=
X-Received: by 2002:a05:651c:543:b0:247:e36d:72e7 with SMTP id
 q3-20020a05651c054300b00247e36d72e7mr3100715ljp.80.1647526207473; Thu, 17 Mar
 2022 07:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvrgzqncUVhDC1bwn8fkrJt7RFs+gTvgByGsDpwfr9eOg@mail.gmail.com>
 <CAFrh3J_jDg=2-6j6hpfae_i9f57YVE99tHNK7nE0sxfiHXO+JQ@mail.gmail.com>
 <CANT5p=pkepEPWAYfWSF8VKM0_nM4iAf4AOPYRqYraKyFWrhc5w@mail.gmail.com>
 <CAFrh3J_0ROfaHf-C4R8Jo-iSRGArKVXE4oFjezEp_MQs9k4XRg@mail.gmail.com> <CAN05THROpPTY0oBbGZyBypc9dYiBUHpO+5M+U41=v41_v_3JuA@mail.gmail.com>
In-Reply-To: <CAN05THROpPTY0oBbGZyBypc9dYiBUHpO+5M+U41=v41_v_3JuA@mail.gmail.com>
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Thu, 17 Mar 2022 10:09:55 -0400
Message-ID: <CAFrh3J-AfUQGOn-B1FChqeFGUVVbsm9f4tpMR-pjPnvtZwxGKw@mail.gmail.com>
Subject: Re: multiuser mount option regression
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Suspending, rebooting the server, and resuming reproduced the issue.

On Thu, Mar 17, 2022 at 9:15 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Thu, Mar 17, 2022 at 11:04 PM Satadru Pramanik <satadru@gmail.com> wrote:
> >
> > I have one of those set already:
> >
> > grep "UBSAN\|KASAN" /boot/config-5.17.0-051700rc8-generic
> > CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
> > CONFIG_UBSAN=y
> > # CONFIG_UBSAN_TRAP is not set
> > CONFIG_CC_HAS_UBSAN_BOUNDS=y
> > CONFIG_UBSAN_BOUNDS=y
> > CONFIG_UBSAN_ONLY_BOUNDS=y
> > CONFIG_UBSAN_SHIFT=y
> > # CONFIG_UBSAN_DIV_ZERO is not set
> > CONFIG_UBSAN_BOOL=y
> > CONFIG_UBSAN_ENUM=y
> > # CONFIG_UBSAN_ALIGNMENT is not set
> > CONFIG_UBSAN_SANITIZE_ALL=y
> > # CONFIG_TEST_UBSAN is not set
> > CONFIG_HAVE_ARCH_KASAN=y
> > CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
> > CONFIG_CC_HAS_KASAN_GENERIC=y
> > # CONFIG_KASAN is not set
> >
> >
> > What is weird is that this issue is only arising after suspending for
> > several hours now.  I can shut my screen, and come back in a few
> > minutes and reopen the screen and watch the machine come out of
> > suspend now, and the mount still work.
>
> Can you try to suspend, then reboot the server, then resume and see if
> that makes any difference?
> And if it reproduces the issue without having to wait several hours?
> I want to rule out if "some setting might make tcp sessions take
> several hours to time out".
>
>
> >
> > I come back after several hours after closing the screen, and that's
> > when the mount is broken.
> >
> > I think that shows up in the following dmesg. The first several lines
> > are from waking up this morning after the machine has been asleep for
> > many hours. Then I manually unmount an remount the cifs mount, and
> > then sleep/resume work.
> > Is there a deeper sleep state after several hours which is able to trigger this?
> >
> > [ 3130.975013] CIFS: VFS: cifs_tree_connect: could not find superblock: -22
> > [ 3132.991105] CIFS: VFS: cifs_tree_connect: could not find superblock: -22
> > [ 3135.007102] CIFS: VFS: cifs_tree_connect: could not find superblock: -22
> > [ 3136.296846] CIFS: VFS: cifs_tree_connect: could not find superblock: -22
> > [ 3139.363995] CIFS: Attempting to mount \\cheekon\localnet
> > [ 3397.489607] PM: suspend entry (deep)
> > [ 3400.856311] Filesystems sync: 3.366 seconds
> > [ 3400.856559] Freezing user space processes ... (elapsed 0.002 seconds) done.
> > [ 3400.858844] OOM killer disabled.
> > [ 3400.858845] Freezing remaining freezable tasks ... (elapsed 0.325
> > seconds) done.
> > [ 3401.184895] printk: Suspending console(s) (use no_console_suspend to debug)
> > [ 3401.707091] ACPI: EC: interrupt blocked
> > [ 3402.658748] ACPI: PM: Preparing to enter system sleep state S3
> > [ 3402.659592] ACPI: EC: event blocked
> > [ 3402.659593] ACPI: EC: EC stopped
> > [ 3402.659594] ACPI: PM: Saving platform NVS memory
> > [ 3402.659622] Disabling non-boot CPUs ...
> > [ 3402.661485] smpboot: CPU 1 is now offline
> > [ 3402.671576] smpboot: CPU 2 is now offline
> > [ 3402.689819] smpboot: CPU 3 is now offline
> > [ 3402.700758] smpboot: CPU 4 is now offline
> > [ 3402.703343] smpboot: CPU 5 is now offline
> > [ 3402.705884] smpboot: CPU 6 is now offline
> > [ 3402.708564] smpboot: CPU 7 is now offline
> > [ 3402.710867] ACPI: PM: Low-level resume complete
> > [ 3402.710901] ACPI: EC: EC started
> > [ 3402.710903] ACPI: PM: Restoring platform NVS memory
> > [ 3402.711337] Enabling non-boot CPUs ...
> > [ 3402.711422] x86: Booting SMP configuration:
> > [ 3402.711424] smpboot: Booting Node 0 Processor 1 APIC 0x2
> > [ 3403.034812] CPU1 is up
> > [ 3403.046711] smpboot: Booting Node 0 Processor 2 APIC 0x4
> > [ 3403.402877] CPU2 is up
> > [ 3403.414254] smpboot: Booting Node 0 Processor 3 APIC 0x6
> > [ 3403.770377] CPU3 is up
> > [ 3403.780699] smpboot: Booting Node 0 Processor 4 APIC 0x1
> > [ 3403.795814] CPU4 is up
> > [ 3403.795848] smpboot: Booting Node 0 Processor 5 APIC 0x3
> > [ 3404.207469] CPU5 is up
> > [ 3404.216103] smpboot: Booting Node 0 Processor 6 APIC 0x5
> > [ 3404.735629] CPU6 is up
> > [ 3404.744063] smpboot: Booting Node 0 Processor 7 APIC 0x7
> > [ 3405.351922] CPU7 is up
> > [ 3405.358923] ACPI: PM: Waking up from system sleep state S3
> > [ 3405.360630] ACPI: EC: interrupt unblocked
> > [ 3405.360798] pcieport 0000:00:1c.0: Enabling MPC IRBNCE
> > [ 3405.360802] pcieport 0000:00:1c.0: Intel PCH root port ACS workaround enabled
> > [ 3405.361022] pcieport 0000:00:1c.2: Enabling MPC IRBNCE
> > [ 3405.361025] pcieport 0000:00:1c.2: Intel PCH root port ACS workaround enabled
> > [ 3405.380367] pcieport 0000:00:1c.3: Enabling MPC IRBNCE
> > [ 3405.380371] pcieport 0000:00:1c.3: Intel PCH root port ACS workaround enabled
> > [ 3405.440455] pcieport 0000:00:1c.4: Enabling MPC IRBNCE
> > [ 3405.440459] pcieport 0000:00:1c.4: Intel PCH root port ACS workaround enabled
> > [ 3405.464845] ACPI: EC: event unblocked
> > [ 3405.466699] pcieport 0000:00:1c.0: pciehp: Slot(0): Card present
> > [ 3405.742733] nouveau 0000:01:00.0: devinit: 0x000066e5[0]: script
> > needs OR link
> > [ 3406.016118] nvme nvme0: 8/0/0 default/read/poll queues
> > [ 3406.117380] OOM killer enabled.
> > [ 3406.117382] Restarting tasks ... done.
> > [ 3406.147389] DMAR: DRHD: handling fault status reg 2
> > [ 3406.147408] DMAR: [DMA Write NO_PASID] Request device [00:02.0]
> > fault addr 0xfed69000 [fault reason 0x05] PTE Write access is not set
> > [ 3406.202211] DMAR: DRHD: handling fault status reg 2
> > [ 3406.202219] DMAR: [DMA Write NO_PASID] Request device [00:02.0]
> > fault addr 0x3dffc000 [fault reason 0x05] PTE Write access is not set
> > [ 3407.536312] pcieport 0000:00:1c.0: pciehp: Slot(0): No link
> > [ 3408.144356] PM: suspend exit
> > [ 3412.177126] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0: link becomes ready
> >
> > On Thu, Mar 17, 2022 at 8:50 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >
> > > On Thu, Mar 17, 2022 at 11:53 AM Satadru Pramanik <satadru@gmail.com> wrote:
> > > >
> > > > I am testing Ronnie's patch from earlier today now, and will see if
> > > > the mount has broken later this morning, as I'm putting the machine to
> > > > sleep now.
> > > >
> > > > I tried just reverting 73f9bfbe3d818bb52266d5c9f3ba57d97842ffe7 in
> > > > 5.17-rc8, but it broke cifs mounting entirely with the error I
> > > > mentioned earlier today:
> > > >
> > > > [  242.560881] INFO: task mount.smb3:3219 blocked for more than 120 seconds.
> > > > [  242.560901]       Tainted: P           OE
> > > > 5.17.0-051700rc8-generic #202203132130
> > > > [  242.560904] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > > > disables this message.
> > > > [  242.560907] task:mount.smb3      state:D stack:    0 pid: 3219
> > > > ppid:     1 flags:0x00004006
> > > > [  242.560914] Call Trace:
> > > > [  242.560918]  <TASK>
> > > > [  242.560927]  __schedule+0x240/0x5a0
> > > > [  242.560939]  schedule+0x55/0xd0
> > > > [  242.560941]  schedule_preempt_disabled+0x15/0x20
> > > > [  242.560944]  __mutex_lock.constprop.0+0x2e0/0x4b0
> > > > [  242.560949]  __mutex_lock_slowpath+0x13/0x20
> > > > [  242.560953]  mutex_lock+0x34/0x40
> > > > [  242.560958]  cifs_get_smb_ses+0x367/0xab0 [cifs]
> > > > [  242.561108]  ? __queue_delayed_work+0x5c/0x90
> > > > [  242.561120]  mount_get_conns+0x63/0x430 [cifs]
> > > > [  242.561182]  cifs_mount+0x86/0x420 [cifs]
> > > > [  242.561222]  cifs_smb3_do_mount+0x10d/0x320 [cifs]
> > > > [  242.561252]  ? cifs_smb3_do_mount+0x10d/0x320 [cifs]
> > > > [  242.561283]  ? vfs_parse_fs_string+0x7f/0xb0
> > > > [  242.561290]  smb3_get_tree+0x3e/0x70 [cifs]
> > > > [  242.561337]  vfs_get_tree+0x27/0xc0
> > > > [  242.561343]  do_new_mount+0x14b/0x1a0
> > > > [  242.561348]  path_mount+0x1d4/0x530
> > > > [  242.561350]  ? putname+0x55/0x60
> > > > [  242.561357]  __x64_sys_mount+0x108/0x140
> > > > [  242.561360]  do_syscall_64+0x59/0xc0
> > > > [  242.561368]  ? do_syscall_64+0x69/0xc0
> > > > [  242.561372]  ? handle_mm_fault+0xba/0x290
> > > > [  242.561376]  ? do_user_addr_fault+0x1dd/0x670
> > > > [  242.561382]  ? syscall_exit_to_user_mode+0x27/0x50
> > > > [  242.561385]  ? exit_to_user_mode_prepare+0x37/0xb0
> > > > [  242.561392]  ? irqentry_exit_to_user_mode+0x9/0x20
> > > > [  242.561394]  ? irqentry_exit+0x33/0x40
> > > > [  242.561397]  ? exc_page_fault+0x89/0x180
> > > > [  242.561399]  ? asm_exc_page_fault+0x8/0x30
> > > > [  242.561405]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > > [  242.561409] RIP: 0033:0x7f42af11ceae
> > > > [  242.561414] RSP: 002b:00007fff6af66c48 EFLAGS: 00000206 ORIG_RAX:
> > > > 00000000000000a5
> > > > [  242.561418] RAX: ffffffffffffffda RBX: 000055dcbe40beb0 RCX: 00007f42af11ceae
> > > > [  242.561420] RDX: 000055dcbe1a447e RSI: 000055dcbe1a44da RDI: 00007fff6af67ea6
> > > > [  242.561421] RBP: 0000000000000000 R08: 000055dcbe40beb0 R09: 000055dcbe40cf40
> > > > [  242.561423] R10: 0000000000000000 R11: 0000000000000206 R12: 00007fff6af67e9b
> > > > [  242.561424] R13: 00007f42af237000 R14: 00007f42af23990f R15: 000055dcbe40cf40
> > > > [  242.561427]  </TASK>
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > On Thu, Mar 17, 2022 at 2:03 AM Steve French <smfrench@gmail.com> wrote:
> > > > >
> > > > > I narrowed the regression for multiuser mounts down (which Ronnie had
> > > > > mentioned) to this patch (one of the first applied to 5.17 merge
> > > > > window for cifs.ko).   I am curious whether this is also related to
> > > > > the hard to reproduce reconnect issue that the regression tracker was
> > > > > monitoring
> > > > >
> > > > > commit 73f9bfbe3d818bb52266d5c9f3ba57d97842ffe7 (HEAD -> tmp)
> > > > > Author: Shyam Prasad N <sprasad@microsoft.com>
> > > > > Date:   Mon Jul 19 17:37:52 2021 +0000
> > > > >
> > > > >     cifs: maintain a state machine for tcp/smb/tcon sessions
> > > > >
> > > > >     If functions like cifs_negotiate_protocol, cifs_setup_session,
> > > > >     cifs_tree_connect are called in parallel on different channels,
> > > > >     each of these will be execute the requests. This maybe unnecessary
> > > > >     in some cases, and only the first caller may need to do the work.
> > > > >
> > > > >     This is achieved by having more states for the tcp/smb/tcon session
> > > > >     status fields. And tracking the state of reconnection based on the
> > > > >     state machine.
> > > > >
> > > > >     For example:
> > > > >     for tcp connections:
> > > > >     CifsNew/CifsNeedReconnect ->
> > > > >       CifsNeedNegotiate ->
> > > > >         CifsInNegotiate ->
> > > > >           CifsNeedSessSetup ->
> > > > >             CifsInSessSetup ->
> > > > >               CifsGood
> > > > >
> > > > >     for smb sessions:
> > > > >     CifsNew/CifsNeedReconnect ->
> > > > >       CifsGood
> > > > >
> > > > >      CifsNew/CifsNeedReconnect ->
> > > > >       CifsInFilesInvalidate ->
> > > > >         CifsNeedTcon ->
> > > > >           CifsInTcon ->
> > > > >             CifsGood
> > > > >
> > > > >     If any channel reconnect sees that it's in the middle of
> > > > >     transition to CifsGood, then they can skip the function.
> > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
> > >
> > > Hi Satadru,
> > >
> > > If you are able to build the kernel yourself, can you try building
> > > with a couple of these extra config options?
> > > CONFIG_KASAN=y
> > > CONFIG_UBSAN=y
> > >
> > > I tried these two tests a few times on my VM:
> > > 1. suspend/resume of the VM while share is mounted
> > > 2. restart smbd when share is mounted.
> > >
> > > In both cases, I'm unable to repro this.
> > > The above config options may slow down your system, since it enables
> > > memory sanitization. You may use this customized kernel just for the
> > > repro.
> > >
> > > --
> > > Regards,
> > > Shyam
