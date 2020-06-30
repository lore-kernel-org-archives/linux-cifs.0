Return-Path: <SRS0=S3IA=AL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A546C433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Jun 2020 03:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215EF206A5
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Jun 2020 03:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgF3Dex (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Jun 2020 23:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgF3Dex (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 29 Jun 2020 23:34:53 -0400
Received: from mail.darkrain42.org (o-chul.darkrain42.org [IPv6:2600:3c01::f03c:91ff:fe96:292c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA09C061755
        for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2020 20:34:53 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature ED25519)
        (Client CN "otters", Issuer "otters" (not verified))
        by o-chul.darkrain42.org (Postfix) with ESMTPS id 575318106
        for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2020 20:34:53 -0700 (PDT)
Received: by haley.home.arpa (Postfix, from userid 1000)
        id ECA5E35AFA; Mon, 29 Jun 2020 20:34:52 -0700 (PDT)
Date:   Mon, 29 Jun 2020 20:34:52 -0700
From:   Paul Aurich <paul@darkrain42.org>
To:     CIFS <linux-cifs@vger.kernel.org>
Subject: memory leak of auth_key.response in multichannel establishment
Message-ID: <20200630033452.GA1859435@haley.home.arpa>
Mail-Followup-To: CIFS <linux-cifs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Mounting an SMB share with multichannel enabled appears to leak all but one
allocations of ses->auth_key.response, at least with ntlmssp auth. This was on
(roughly) bf1028a41ea:

unreferenced object 0xffff88802cefc500 (size 256):
   comm "mount.cifs", pid 680, jiffies 4294907522 (age 381.360s)
   hex dump (first 32 bytes):
     19 68 bf 70 7b a3 b8 00 43 63 8c fa e1 00 90 fb  .h.p{...Cc......
     1d d8 39 3c 25 d1 d3 f0 a2 4e e4 99 4f 35 9b 2e  ..9<%....N..O5..
   backtrace:
     [<000000006c8d6e81>] setup_ntlmv2_rsp+0x2f4/0x2190
     [<000000006cf0d77f>] build_ntlmssp_auth_blob+0x2b/0x10d0
     [<00000000300414f8>] SMB2_sess_auth_rawntlmssp_authenticate+0x316/0x7c0
     [<000000002ee76096>] SMB2_sess_setup+0x377/0x7b0
     [<0000000076fded43>] cifs_setup_session+0x359/0x770
     [<00000000f6a70b79>] cifs_get_smb_ses+0xfe1/0x2ae0
     [<0000000030763a8d>] mount_get_conns+0x20d/0xec0
     [<000000003deb8295>] cifs_mount+0xbe/0x1d00
     [<00000000d18bac6c>] cifs_smb3_do_mount+0x26e/0x1330
     [<000000000952c786>] legacy_get_tree+0x101/0x1f0
     [<00000000f07e0c29>] vfs_get_tree+0x8a/0x2d0
     [<00000000edbc514a>] do_mount+0xed7/0x16f0
     [<00000000ee452092>] __x64_sys_mount+0x12c/0x1a0
     [<00000000a6ccd160>] do_syscall_64+0x56/0xa0
     [<000000003143088f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
unreferenced object 0xffff88802a33e500 (size 256):
   comm "mount.cifs", pid 680, jiffies 4294907547 (age 381.260s)
   hex dump (first 32 bytes):
     5f ff 39 9f c0 e9 1e 3b 0a f1 06 9d c7 53 c2 74  _.9....;.....S.t
     03 7e 5f 2f 27 f7 a8 84 70 e8 58 e3 91 f6 76 d6  .~_/'...p.X...v.
   backtrace:
     [<000000006c8d6e81>] setup_ntlmv2_rsp+0x2f4/0x2190
     [<000000006cf0d77f>] build_ntlmssp_auth_blob+0x2b/0x10d0
     [<00000000300414f8>] SMB2_sess_auth_rawntlmssp_authenticate+0x316/0x7c0
     [<000000002ee76096>] SMB2_sess_setup+0x377/0x7b0
     [<0000000076fded43>] cifs_setup_session+0x359/0x770
     [<000000006bb9ce4c>] cifs_ses_add_channel+0x9bc/0x10a0
     [<000000004034ab3b>] cifs_try_adding_channels+0x1f0/0x580
     [<000000009ac39b0b>] cifs_mount+0xed1/0x1d00
     [<00000000d18bac6c>] cifs_smb3_do_mount+0x26e/0x1330
     [<000000000952c786>] legacy_get_tree+0x101/0x1f0
     [<00000000f07e0c29>] vfs_get_tree+0x8a/0x2d0
     [<00000000edbc514a>] do_mount+0xed7/0x16f0
     [<00000000ee452092>] __x64_sys_mount+0x12c/0x1a0
     [<00000000a6ccd160>] do_syscall_64+0x56/0xa0
     [<000000003143088f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Regards,
~Paul

