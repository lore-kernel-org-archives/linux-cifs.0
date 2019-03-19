Return-Path: <SRS0=4GOt=RW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87772C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 12:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EDD720854
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 12:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfCSMBa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Mar 2019 08:01:30 -0400
Received: from isilmar-4.linta.de ([136.243.71.142]:35832 "EHLO
        isilmar-4.linta.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfCSMBa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Mar 2019 08:01:30 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Mar 2019 08:01:30 EDT
Received: from light.dominikbrodowski.net (isilmar.linta [10.0.0.1])
        by isilmar-4.linta.de (Postfix) with ESMTPS id 43D822009BB;
        Tue, 19 Mar 2019 11:52:05 +0000 (UTC)
Received: by light.dominikbrodowski.net (Postfix, from userid 1000)
        id 749B020172; Tue, 19 Mar 2019 12:51:51 +0100 (CET)
Date:   Tue, 19 Mar 2019 12:51:51 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org
Subject: v5.1-rc1 cifs bug: underflow; use-after-free.
Message-ID: <20190319115151.GA2092@light.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,

when mounting a cifs (vers=2.0, unfortunately...) volume on v5.1-rc1, I get
the following warning (slightly edited to avoid information leaks):

[  118.326535] CIFS: Attempting to mount //some/what
[  118.667347] ------------[ cut here ]------------
[  118.667367] refcount_t: underflow; use-after-free.
[  118.667384] WARNING: CPU: 1 PID: 1966 at lib/refcount.c:190 refcount_sub_and_test_checked+0x5c/0x70
[  118.667387] Modules linked in:
[  118.667392] CPU: 1 PID: 1966 Comm: mount.cifs Tainted: G                T 5.1.0-rc1 #1
[  118.667395] Hardware name: Dell Inc. XPS 13 9343/0TM99H, BIOS A11 12/08/2016
[  118.667400] RIP: 0010:refcount_sub_and_test_checked+0x5c/0x70
[  118.667432] Call Trace:
[  118.667439]  close_shroot+0x21/0xa0
[  118.667444]  smb2_query_path_info+0x16b/0x1f0
[  118.667454]  cifs_get_inode_info+0x2b3/0x860
[  118.667467]  cifs_root_iget+0x12c/0x670
[  118.667473]  cifs_smb3_do_mount+0x4f7/0x680
[  118.667479]  ? rcu_read_lock_sched_held+0x74/0x80
[  118.667483]  ? kfree+0x248/0x290
[  118.667490]  legacy_get_tree+0x24/0x40
[  118.667494]  vfs_get_tree+0x3d/0x110
[  118.667500]  do_mount+0x30a/0xef0
[  118.667504]  ? rcu_read_lock_sched_held+0x74/0x80
[  118.667512]  ksys_mount+0xbd/0xe0
[  118.667517]  __x64_sys_mount+0x22/0x30
[  118.667522]  do_syscall_64+0x50/0x160
[  118.667527]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  118.667531] RIP: 0033:0x754fd3d1d68e

Thanks,
	Dominik
