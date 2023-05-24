Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5663BC7EE2C
	for <linux-cifs@archiver.kernel.org>; Wed, 24 May 2023 11:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbjEXLdn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 May 2023 07:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjEXLdn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 May 2023 07:33:43 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE23412E
        for <linux-cifs@vger.kernel.org>; Wed, 24 May 2023 04:33:40 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4f3b314b1d7so750903e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 24 May 2023 04:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684928019; x=1687520019;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OBwETrMCKkYvfDd02ku3RpH7J3UAUXzYVxMC4Ou1oII=;
        b=Qo/QPCcPfbwnTFahQdlzcErkOn3AaC3AGSbtgpcpfeJI2SSyGWRtYHb7vyMeF/7xnl
         BBLQs1u2EVnoZ9lOXw6Q3Pl+ItOyZ/0empT1uH8fwYYiBOrX0jQa55zZ2gT039tGdWFm
         RyR+FsYGyd2MbOF8Nicj2QppbPbAA8xBrM7eIQxCkJJ3ruSpGforQo3boAfiQ1yTz2xR
         mbjv1VoLY8Oz0Tw4syCF7Zyk38SP4QVfjwxi3MRfX+hzph49quwDC8ocZ8FWPpDwSRVS
         YpOhC4qmBbVFcGi/NvEWldm9QCy2ADQ1pc2N59YOMgqPMIWCuTg6Rs9c7Rj/agi9wbM1
         Hy+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684928019; x=1687520019;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OBwETrMCKkYvfDd02ku3RpH7J3UAUXzYVxMC4Ou1oII=;
        b=HjsA9PwfdVs4TCJLiHZlu4O6YxaXjXuNe1dCSSNIOnijLKEyuvku9kwrqG0eCDCGxh
         Kx16PvL8W2zSI0D8ZURpdIs+fMnX8wmgREV6NHKRPYSkb/JGWE+QJapOcigsyBXaVKyS
         Kk9C1sxY/SYHypZdGX3VUHIcs+7iUbEVAXhRFCWO2mD7Jz9pahyEmMiSSVnBddBfVCP+
         XQqPI5ySsQDAGCCGHemJbeNPk1sQZEMYqJaOlSLjAnVKlieYtKxF078ghSD5CxYBBKre
         qqn2kmodpyyA1ISX24dq6e/94ZH6RlmTSal6TGEHAhS90WbS6RAVCMPlx1cwvOi+iPrC
         2vpQ==
X-Gm-Message-State: AC+VfDxuddlaqvQ71hlDbPJD5d6Dy9KRdxtXL19MbrbRH9QulgfFN8I3
        RIx86D9nvZ3fKu8a7JflOR30Bl5MWcFVHuWGeSeVtjTOcVfTaRUt
X-Google-Smtp-Source: ACHHUZ5+4EFaZOlckC5S56LfWGrmulOEWnwM41WqQGu9USLVpE/0RueACR3YYBo/eLieLAVJfL5UO1I6HbHCAA6QrSQ=
X-Received: by 2002:a05:6512:489:b0:4f1:26da:54ab with SMTP id
 v9-20020a056512048900b004f126da54abmr5316728lfq.51.1684928018291; Wed, 24 May
 2023 04:33:38 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 24 May 2023 17:03:27 +0530
Message-ID: <CANT5p=p31khjC08_bvZqsMdqDi1g8G1F_7CZGXH0YU2FC6+GKA@mail.gmail.com>
Subject: KASAN use after free warning
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        Bharath SM <bharathsm.hsk@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

I'm seeing this use-after-free in the latest mainline kernel.
But I cannot make much sense out of it.
It complains that the buffer was freed before cifsd could finish. I
cannot see how that can happen.

Worried about this as we've been seeing some possible corruptions
during some internal stress testing in Microsoft. That's the reason I
was running a KASAN enabled kernel.

Any clues?

 ==================================================================
May 24 10:58:11 xrqubcgiz kernel: [ 2976.847655] BUG: KASAN:
slab-use-after-free in smb2_is_network_name_deleted+0x2a/0x180 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2976.859483] Read of size 4 at
addr ffff888111638008 by task cifsd/563833
May 24 10:58:11 xrqubcgiz kernel: [ 2976.865664]
May 24 10:58:11 xrqubcgiz kernel: [ 2976.868354] CPU: 0 PID: 563833
Comm: cifsd Not tainted 6.4.0-rc3-wkasan #5
May 24 10:58:11 xrqubcgiz kernel: [ 2976.877390] Hardware name:
Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090008
12/07/2018
May 24 10:58:11 xrqubcgiz kernel: [ 2976.885226] Call Trace:
May 24 10:58:11 xrqubcgiz kernel: [ 2976.888530]  <TASK>
May 24 10:58:11 xrqubcgiz kernel: [ 2976.896455]  dump_stack_lvl+0x48/0x70
May 24 10:58:11 xrqubcgiz kernel: [ 2976.903888]  print_report+0xcf/0x630
May 24 10:58:11 xrqubcgiz kernel: [ 2976.908427]  ?
kasan_complete_mode_report_info+0x8a/0x220
May 24 10:58:11 xrqubcgiz kernel: [ 2976.915694]  ?
smb2_is_network_name_deleted+0x2a/0x180 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2976.923587]  kasan_report+0xbb/0x100
May 24 10:58:11 xrqubcgiz kernel: [ 2976.927889]  ?
smb2_is_network_name_deleted+0x2a/0x180 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2976.937541]  kasan_check_range+0x3a/0x220
May 24 10:58:11 xrqubcgiz kernel: [ 2976.942920]  __asan_loadN+0xf/0x20
May 24 10:58:11 xrqubcgiz kernel: [ 2976.946734]
smb2_is_network_name_deleted+0x2a/0x180 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2976.956230]
cifs_demultiplex_thread+0xcfc/0x17a0 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2976.963011]  ?
__pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2976.971733]  ? __pfx___schedule+0x10/0x10
May 24 10:58:11 xrqubcgiz kernel: [ 2976.975674]  ? try_to_wake_up+0x370/0xc70
May 24 10:58:11 xrqubcgiz kernel: [ 2976.982190]  ?
_raw_spin_lock_irqsave+0x96/0x110
May 24 10:58:11 xrqubcgiz kernel: [ 2976.990334]  ?
__pfx__raw_spin_lock_irqsave+0x10/0x10
May 24 10:58:11 xrqubcgiz kernel: [ 2976.995407]  ? __kasan_check_read+0x11/0x20
May 24 10:58:11 xrqubcgiz kernel: [ 2977.001204]  ?
__pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.010165]  kthread+0x188/0x1d0
May 24 10:58:11 xrqubcgiz kernel: [ 2977.014228]  ? __pfx_kthread+0x10/0x10
May 24 10:58:11 xrqubcgiz kernel: [ 2977.020605]  ret_from_fork+0x2c/0x50
May 24 10:58:11 xrqubcgiz kernel: [ 2977.024091]  </TASK>
May 24 10:58:11 xrqubcgiz kernel: [ 2977.030697]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.033211] Allocated by task 563833:
May 24 10:58:11 xrqubcgiz kernel: [ 2977.041106]  kasan_save_stack+0x26/0x60
May 24 10:58:11 xrqubcgiz kernel: [ 2977.041120]  kasan_set_track+0x25/0x40
May 24 10:58:11 xrqubcgiz kernel: [ 2977.041126]
kasan_save_alloc_info+0x1e/0x40
May 24 10:58:11 xrqubcgiz kernel: [ 2977.041133]  __kasan_slab_alloc+0x9d/0xa0
May 24 10:58:11 xrqubcgiz kernel: [ 2977.041140]  kmem_cache_alloc+0x176/0x3a0
May 24 10:58:11 xrqubcgiz kernel: [ 2977.041146]  mempool_alloc_slab+0x17/0x30
May 24 10:58:11 xrqubcgiz kernel: [ 2977.041153]  mempool_alloc+0xf0/0x290
May 24 10:58:11 xrqubcgiz kernel: [ 2977.041159]  cifs_buf_get+0x28/0x70 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.041421]
smb3_receive_transform+0x2dc/0xcd0 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.041913]
cifs_demultiplex_thread+0xba7/0x17a0 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.042163]  kthread+0x188/0x1d0
May 24 10:58:11 xrqubcgiz kernel: [ 2977.042171]  ret_from_fork+0x2c/0x50
May 24 10:58:11 xrqubcgiz kernel: [ 2977.042177]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.049147] Freed by task 1300137:
May 24 10:58:11 xrqubcgiz kernel: [ 2977.052171]  kasan_save_stack+0x26/0x60
May 24 10:58:11 xrqubcgiz kernel: [ 2977.052181]  kasan_set_track+0x25/0x40
May 24 10:58:11 xrqubcgiz kernel: [ 2977.052188]  kasan_save_free_info+0x2e/0x60
May 24 10:58:11 xrqubcgiz kernel: [ 2977.052194]
____kasan_slab_free+0x17f/0x200
May 24 10:58:11 xrqubcgiz kernel: [ 2977.052200]  __kasan_slab_free+0x12/0x30
May 24 10:58:11 xrqubcgiz kernel: [ 2977.052207]
slab_free_freelist_hook+0xd0/0x1a0
May 24 10:58:11 xrqubcgiz kernel: [ 2977.052213]  kmem_cache_free+0x1a9/0x340
May 24 10:58:11 xrqubcgiz kernel: [ 2977.052219]  mempool_free_slab+0x17/0x30
May 24 10:58:11 xrqubcgiz kernel: [ 2977.052226]  mempool_free+0x66/0x190
May 24 10:58:11 xrqubcgiz kernel: [ 2977.052231]  free_rsp_buf+0x60/0x90 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.052487]
smb2_compound_op+0xbe3/0x2c00 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.052756]
smb2_query_path_info+0x1e8/0x530 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.053024]
cifs_get_inode_info+0x661/0x1170 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.053274]  cifs_lookup+0x2bb/0xbf0 [cifs]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.058107]  __lookup_slow+0x116/0x220
May 24 10:58:11 xrqubcgiz kernel: [ 2977.058117]  walk_component+0x193/0x240
May 24 10:58:11 xrqubcgiz kernel: [ 2977.058124]  path_lookupat+0xb2/0x2f0
May 24 10:58:11 xrqubcgiz kernel: [ 2977.058130]  filename_lookup+0x16f/0x340
May 24 10:58:11 xrqubcgiz kernel: [ 2977.058138]  vfs_statx+0xf4/0x260
May 24 10:58:11 xrqubcgiz kernel: [ 2977.058144]  vfs_fstatat+0x59/0x80
May 24 10:58:11 xrqubcgiz kernel: [ 2977.058150]  __do_sys_newlstat+0x86/0xf0
May 24 10:58:11 xrqubcgiz kernel: [ 2977.058156]  __x64_sys_newlstat+0x31/0x40
May 24 10:58:11 xrqubcgiz kernel: [ 2977.058162]  do_syscall_64+0x5c/0x90
May 24 10:58:11 xrqubcgiz kernel: [ 2977.058172]
entry_SYSCALL_64_after_hwframe+0x72/0xdc
May 24 10:58:11 xrqubcgiz kernel: [ 2977.058182]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.060882] The buggy address
belongs to the object at ffff888111638000
May 24 10:58:11 xrqubcgiz kernel: [ 2977.060882]  which belongs to the
cache cifs_request of size 16588
May 24 10:58:11 xrqubcgiz kernel: [ 2977.070701] The buggy address is
located 8 bytes inside of
May 24 10:58:11 xrqubcgiz kernel: [ 2977.070701]  freed 16588-byte
region [ffff888111638000, ffff88811163c0cc)
May 24 10:58:11 xrqubcgiz kernel: [ 2977.087315]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.090437] The buggy address
belongs to the physical page:
May 24 10:58:11 xrqubcgiz kernel: [ 2977.097263] page:000000004133fcae
refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x111638
May 24 10:58:11 xrqubcgiz kernel: [ 2977.097274] head:000000004133fcae
order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
May 24 10:58:11 xrqubcgiz kernel: [ 2977.097280] anon flags:
0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
May 24 10:58:11 xrqubcgiz kernel: [ 2977.097288] page_type: 0xffffffff()
May 24 10:58:11 xrqubcgiz kernel: [ 2977.097295] raw: 0017ffffc0010200
ffff88811245d900 ffffea0004ba7a00 dead000000000005
May 24 10:58:11 xrqubcgiz kernel: [ 2977.097301] raw: 0000000000000000
0000000000010001 00000001ffffffff 0000000000000000
May 24 10:58:11 xrqubcgiz kernel: [ 2977.097305] page dumped because:
kasan: bad access detected
May 24 10:58:11 xrqubcgiz kernel: [ 2977.097309]
May 24 10:58:11 xrqubcgiz kernel: [ 2977.099757] Memory state around
the buggy address:
May 24 10:58:11 xrqubcgiz kernel: [ 2977.107368]  ffff888111637f00: fc
fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
May 24 10:58:11 xrqubcgiz kernel: [ 2977.115239]  ffff888111637f80: fc
fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
May 24 10:58:11 xrqubcgiz kernel: [ 2977.122563] >ffff888111638000: fa
fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
May 24 10:58:11 xrqubcgiz kernel: [ 2977.128714]                       ^
May 24 10:58:11 xrqubcgiz kernel: [ 2977.135152]  ffff888111638080: fb
fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
May 24 10:58:11 xrqubcgiz kernel: [ 2977.142552]  ffff888111638100: fb
fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
May 24 10:58:11 xrqubcgiz kernel: [ 2977.148569]
==================================================================


-- 
Regards,
Shyam
