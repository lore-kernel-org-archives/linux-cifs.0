Return-Path: <SRS0=lfmE=3C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CC2C33CA9
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jan 2020 20:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1542D2468C
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jan 2020 20:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="zJ/uzOHS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgAMUrK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Jan 2020 15:47:10 -0500
Received: from mx.cjr.nz ([51.158.111.142]:32316 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgAMUrK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 13 Jan 2020 15:47:10 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 76C30808CA;
        Mon, 13 Jan 2020 20:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1578948428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nBCkQC1Co6EA8my316IDvPxNc3sIYRQZLFnLaaaH2Ls=;
        b=zJ/uzOHS8TaJGUlznrzRL6e+RYggqmJZpqksJLxy8k0mGaezIrzdM57hrNEVPm7iIGcZGm
        qohtX7ifQ/Z5DLII0p3AXE+9KH2ZB0I/6MZWZPAmf2QX5ALRGexAJGh8ykyN1kGSfLt5aU
        hg9v6x0olFqfGZl1UbW+lweLFWNN2CVJ3WdiCwEqZxLeqW1gx7xnlTf1lBWGfWhVCh+yvg
        4umvZNQHc2UrA5PNcJJXrfUegKYN0BQAsv7nq8Dd/XUPux8v98vg/bDBJK4DbI3o/jxGup
        9wbkvCmaO+AxmPPyKnwop9nRcSzu1gcIopEnAYaIFxnx380sCLxRPdCSSK/CLg==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH] cifs: Fix memory allocation in __smb2_handle_cancelled_cmd()
Date:   Mon, 13 Jan 2020 17:46:59 -0300
Message-Id: <20200113204659.4867-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

__smb2_handle_cancelled_cmd() is called under a spin lock held in
cifs_mid_q_entry_release(), so make its memory allocation GFP_ATOMIC.

This issue was observed when running xfstests generic/028:

[ 1722.589204] CIFS VFS: \\192.168.30.26 Cancelling wait for mid 72064 cmd: 5
[ 1722.590687] CIFS VFS: \\192.168.30.26 Cancelling wait for mid 72065 cmd: 17
[ 1722.593529] CIFS VFS: \\192.168.30.26 Cancelling wait for mid 72066 cmd: 6
[ 1723.039014] BUG: sleeping function called from invalid context at mm/slab.h:565
[ 1723.040710] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 30877, name: cifsd
[ 1723.045098] CPU: 3 PID: 30877 Comm: cifsd Not tainted 5.5.0-rc4+ #313
[ 1723.046256] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba527-rebuilt.opensuse.org 04/01/2014
[ 1723.048221] Call Trace:
[ 1723.048689]  dump_stack+0x97/0xe0
[ 1723.049268]  ___might_sleep.cold+0xd1/0xe1
[ 1723.050069]  kmem_cache_alloc_trace+0x204/0x2b0
[ 1723.051051]  __smb2_handle_cancelled_cmd+0x40/0x140 [cifs]
[ 1723.052137]  smb2_handle_cancelled_mid+0xf6/0x120 [cifs]
[ 1723.053247]  cifs_mid_q_entry_release+0x44d/0x630 [cifs]
[ 1723.054351]  ? cifs_reconnect+0x26a/0x1620 [cifs]
[ 1723.055325]  cifs_demultiplex_thread+0xad4/0x14a0 [cifs]
[ 1723.056458]  ? cifs_handle_standard+0x2c0/0x2c0 [cifs]
[ 1723.057365]  ? kvm_sched_clock_read+0x14/0x30
[ 1723.058197]  ? sched_clock+0x5/0x10
[ 1723.058838]  ? sched_clock_cpu+0x18/0x110
[ 1723.059629]  ? lockdep_hardirqs_on+0x17d/0x250
[ 1723.060456]  kthread+0x1ab/0x200
[ 1723.061149]  ? cifs_handle_standard+0x2c0/0x2c0 [cifs]
[ 1723.062078]  ? kthread_create_on_node+0xd0/0xd0
[ 1723.062897]  ret_from_fork+0x3a/0x50

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Fixes: 9150c3adbf24 ("CIFS: Close open handle after interrupted close")
---
 fs/cifs/smb2misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 0516fc482d43..0511aaf451d4 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -743,7 +743,7 @@ __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
 {
 	struct close_cancelled_open *cancelled;
 
-	cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
+	cancelled = kzalloc(sizeof(*cancelled), GFP_ATOMIC);
 	if (!cancelled)
 		return -ENOMEM;
 
-- 
2.24.1

