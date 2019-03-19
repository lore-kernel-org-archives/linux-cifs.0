Return-Path: <SRS0=4GOt=RW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38F8C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 01:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74FDA20835
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 01:09:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZMOHQvy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfCSBJz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Mar 2019 21:09:55 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45220 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfCSBJy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Mar 2019 21:09:54 -0400
Received: by mail-qt1-f194.google.com with SMTP id v20so20303451qtv.12
        for <linux-cifs@vger.kernel.org>; Mon, 18 Mar 2019 18:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q1yRjcu2DnJTe5gC21V7FOTanYk468kn1XvJL8Ns3IA=;
        b=EZMOHQvybGUJ7oHY5GUWMmeOdlq/f/hncaH9hfdG1sHmPbXjTqQco65y5EotGJmdmQ
         tqOCFzCkaLcZ1V8ZcWBRKPHPJIwFxJqifF1CKoDSlNRZ659AFvPb/ok82Rq06pZpRhkU
         JpIcZA2fkClaG5SMjQ0aglt1JRDw/wKJEotnmaKdcbS/iw1KC3p/ucXu9qskWKBdrpUn
         PboEGO2E79MjMbYZnsHxS0rB181co8YOq/ef9gP+8FUUyHrGpZIMZelOK+bYxdr3r54x
         BhiE5Y5z0e494AGpPestwH4aj7VjbmvsUc4E7b6zJSnfqcnHvYHlzkPg9ga1JimLcYsS
         Os4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q1yRjcu2DnJTe5gC21V7FOTanYk468kn1XvJL8Ns3IA=;
        b=RRMu+D5ys4Lu24MHJJ9d64I6cvIqcqjcirF7De2UZImp2+v8fWfMDHIZQ8IVte27DF
         840g55tW9O3zLatv4o5LnLVMTOmXCqK468fFpbDypDBzr5cBCdPQRHyN2oBmaRYprD/o
         0QH3Xg4Ync6ZSJnOv+V0ycIrE5je505F2WK0KmPBgq0RjOvXCnj+yJ9Olh3mg5Nh0B52
         zW5jCao1TDFqvx2wMjIij2Vjwk2VPR+I15JTWESOQgN2Ecb6i3dZ+v8v95RGgNC4AaQH
         geb6cb3Cy4AcEz5oFgyexawU++t3bjjFFIoDrZfMEIag62qoabSBd7N+gMfguP1WvoDJ
         ECVQ==
X-Gm-Message-State: APjAAAX4HF/prW3Mui5CpBMUnekB5PWM1HmrheQ66NIx6xfxyB5yXdjq
        GpxCa71FIh71iXEp5E3YL7GOMvcoMjN2m90xazAeOQ==
X-Google-Smtp-Source: APXvYqzoEF6Hra3/ysF/6Mfwjji+9MBUWzSOBGO1iX08o9LXY7BZLhH7REQ8c8DvIrDVUs4wQmQitsGMi9Q3JKAqMIM=
X-Received: by 2002:a0c:9ac1:: with SMTP id k1mr9376423qvf.36.1552957793436;
 Mon, 18 Mar 2019 18:09:53 -0700 (PDT)
MIME-Version: 1.0
References: <CADJHv_sGr3Oz7zTW5KQMgg93+Fgkaw1NVrEMEKmnCTCcHPHveg@mail.gmail.com>
In-Reply-To: <CADJHv_sGr3Oz7zTW5KQMgg93+Fgkaw1NVrEMEKmnCTCcHPHveg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 19 Mar 2019 11:09:42 +1000
Message-ID: <CAN05THRDtr1WQqSwqNG7azy+Qst5H1+8XGrZNGNocr_O_jf7LA@mail.gmail.com>
Subject: Re: [5.1-rc1 CIFS regression] detected buffer overflow in strcat in
 smb21_set_oplock_level (xfstests generic/446)
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

I tested generic/446 on both my machine as well as our buildbot using
Steves current for-next branch and it passes without crashing.
I have added this test to our buildbot so we will continue to run it
for every patch moving forward.

Can you test if you still get crashes if you use Steve's for-next branch ?

On Mon, Mar 18, 2019 at 4:20 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> Hi,
>
> My mail account got stuck for a few days and I missed you guys' reply
> about generic/013 hang.
>
> The commits Ronnie mentioned have been merged into Linus tress, and
> tests passed. Thanks!
>
> The commit Pavel talked about is not merged yet. I'll test after it
> hit Linus tree or any -for-next branch.
>
> The setup I'm using is:
> ----------------------------------------------
> # cat /etc/samba/smb.conf
> [test]
>     path = /export/cifstest
>     writeable = yes
> [scratch]
>     path = /export/cifsscratch
>     writeable = yes
> # cat xfstests-dev/local.config
> TEST_DEV=//localhost/test
> TEST_DIR=/cifsmnt
> SCRATCH_DEV=//localhost/scratch
> SCRATCH_MNT=/cifssch
> FSTYP=cifs
> MOUNT_OPTIONS="-o vers=3.0,username=root,password=redhat,sfu,mfsymlinks"
> TEST_FS_MOUNT_OPTS="-o vers=3.0,username=root,password=redhat,sfu,mfsymlinks"
> MKFS_OPTIONS=""
> --------------------------------------------------------
>
>
> Now with kernel updated to 5.1-rc1,  generic/446 starts to panic. It's
> easy to reproduce. I'm going to bisect this issue, just sending this
> email to give you guys a update and heads up. :)
>
> [ 4991.913298] detected buffer overflow in strcat
> [ 4991.918273] ------------[ cut here ]------------
> [ 4991.923422] kernel BUG at lib/string.c:1053!
> [ 4991.928190] invalid opcode: 0000 [#1] SMP PTI
> [ 4991.933048] CPU: 0 PID: 860 Comm: kworker/0:1 Not tainted 5.0.0+ #1
> [ 4991.940037] Hardware name: IBM IBM System X3250 M4
> -[2583AC1]-/00D3729, BIOS -[JQE164AUS-1.07]- 12/09/2013
> [ 4991.950832] Workqueue: cifsoplockd cifs_oplock_break [cifs]
> [ 4991.957049] RIP: 0010:fortify_panic+0xf/0x1a
> [ 4991.961811] Code: 48 89 cf 48 0f 42 e8 48 89 ea e8 86 94 00 00 c6
> 04 28 00 48 89 d8 5b 5d c3 0f 0b 48 89 fe 48 c7 c7 d8 a6 b3 bc e8 09
> 46 8c ff <0f> 0b 90 90 90 90 90 90 90 90 90 55 48 89 fa 48 89 fd 31 c9
> 53 48
> [ 4991.982764] RSP: 0018:ffff98d689897e00 EFLAGS: 00010246
> [ 4991.988591] RAX: 0000000000000022 RBX: 0000000000000000 RCX: 0000000000000000
> [ 4991.996551] RDX: 0000000000000000 RSI: ffff8b53f7a15a98 RDI: ffff8b53f7a15a98
> [ 4992.004512] RBP: ffff8b53ee63bd08 R08: 0000000000000f89 R09: 0000000000000000
> [ 4992.012471] R10: 0000000000000000 R11: ffff98d689897cb0 R12: 0000000000000000
> [ 4992.020432] R13: 0000000000000003 R14: ffff8b53f5bb1800 R15: ffff8b53f5bb7000
> [ 4992.028393] FS:  0000000000000000(0000) GS:ffff8b53f7a00000(0000)
> knlGS:0000000000000000
> [ 4992.037420] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 4992.043830] CR2: 000000000062aa28 CR3: 0000000102c0e002 CR4: 00000000001606f0
> [ 4992.051789] Call Trace:
> [ 4992.054537]  smb21_set_oplock_level.cold.39+0xc/0xc [cifs]
> [ 4992.060673]  smb3_set_oplock_level+0x1d/0x80 [cifs]
> [ 4992.066125]  cifs_oplock_break+0x89/0x400 [cifs]
> [ 4992.071276]  process_one_work+0x1a1/0x3a0
> [ 4992.075746]  worker_thread+0x30/0x380
> [ 4992.079828]  ? mod_delayed_work_on+0x90/0x90
> [ 4992.084588]  kthread+0x112/0x130
> [ 4992.088185]  ? __kthread_parkme+0x70/0x70
> [ 4992.092655]  ret_from_fork+0x35/0x40
> [ 4992.096640] Modules linked in: loop dm_mod arc4 md4 sha512_ssse3
> sha512_generic cmac nls_utf8 cifs ccm dns_resolver sunrpc intel_rapl
> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
> crct10dif_pclmul crc32_pclmul ext4 iTCO_wdt cdc_ether
> ghash_clmulni_intel usbnet ipmi_ssif iTCO_vendor_support mii
> intel_cstate gpio_ich sg intel_uncore ipmi_devintf intel_rapl_perf
> mbcache pcspkr i2c_i801 jbd2 ipmi_msghandler lpc_ich ie31200_edac xfs
> libcrc32c sr_mod sd_mod cdrom ata_generic mgag200 i2c_algo_bit
> drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm
> ata_piix libata crc32c_intel e1000e wmi
> [ 4992.158052] ---[ end trace 5d01c28800220e20 ]---
> [ 4992.163209] RIP: 0010:fortify_panic+0xf/0x1a
> [ 4992.167973] Code: 48 89 cf 48 0f 42 e8 48 89 ea e8 86 94 00 00 c6
> 04 28 00 48 89 d8 5b 5d c3 0f 0b 48 89 fe 48 c7 c7 d8 a6 b3 bc e8 09
> 46 8c ff <0f> 0b 90 90 90 90 90 90 90 90 90 55 48 89 fa 48 89 fd 31 c9
> 53 48
> [ 4992.188930] RSP: 0018:ffff98d689897e00 EFLAGS: 00010246
> [ 4992.194761] RAX: 0000000000000022 RBX: 0000000000000000 RCX: 0000000000000000
> [ 4992.202725] RDX: 0000000000000000 RSI: ffff8b53f7a15a98 RDI: ffff8b53f7a15a98
> [ 4992.210686] RBP: ffff8b53ee63bd08 R08: 0000000000000f89 R09: 0000000000000000
> [ 4992.218650] R10: 0000000000000000 R11: ffff98d689897cb0 R12: 0000000000000000
> [ 4992.226613] R13: 0000000000000003 R14: ffff8b53f5bb1800 R15: ffff8b53f5bb7000
> [ 4992.234576] FS:  0000000000000000(0000) GS:ffff8b53f7a00000(0000)
> knlGS:0000000000000000
> [ 4992.243606] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 4992.250017] CR2: 000000000062aa28 CR3: 0000000102c0e002 CR4: 00000000001606f0
> [ 4992.257979] Kernel panic - not syncing: Fatal exception
> [ 4992.263838] Kernel Offset: 0x3aa00000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [ 4992.275862] ---[ end Kernel panic - not syncing: Fatal exception ]---
>
> Thanks,
> M
