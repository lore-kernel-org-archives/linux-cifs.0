Return-Path: <SRS0=fS5U=R6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D889DC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Mar 2019 18:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E139204FD
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Mar 2019 18:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553711533;
	bh=N2/r+LM+NJ1f3JmOsTRyGvXbjDxj+ST7Ee+qWE0CXik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ErhLRLDlWvhLiUlujdKan7Q/l1H2+AZawwHaIbT04Hn2nGdMQ/o1/iRSq1QzMgqhB
	 Upu+Z1P0voh97Tlv6UxmM/AQ8xeu5etiBagibby6OR8NoackbA/B5c0GNuKG4OfVmA
	 IEK/ARQ5nYKfCFgKk9KWEiLG+3MjvZt4v924aTIc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391709AbfC0ScJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391620AbfC0SZj (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 27 Mar 2019 14:25:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 733912184C;
        Wed, 27 Mar 2019 18:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553711139;
        bh=N2/r+LM+NJ1f3JmOsTRyGvXbjDxj+ST7Ee+qWE0CXik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWqlv516Irpij6xASr4a2D6rZBF2Dla6drjYRvPUm+WrKUW18FS1wg+9exmwbiaL6
         XhIwK/TOx1nNdQ7RH03b4Dgc2DlhiH9rG3RPYhgriVjEgVueke+hsdDuj/xBYsDk1u
         pnmnnueL37/TKQfKmxjkVSapyOqXoHUTBrnGspAA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yao Liu <yotta.liu@ucloud.cn>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 3.18 10/41] cifs: Fix NULL pointer dereference of devname
Date:   Wed, 27 Mar 2019 14:24:47 -0400
Message-Id: <20190327182518.19394-10-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327182518.19394-1-sashal@kernel.org>
References: <20190327182518.19394-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Yao Liu <yotta.liu@ucloud.cn>

[ Upstream commit 68e2672f8fbd1e04982b8d2798dd318bf2515dd2 ]

There is a NULL pointer dereference of devname in strspn()

The oops looks something like:

  CIFS: Attempting to mount (null)
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
  ...
  RIP: 0010:strspn+0x0/0x50
  ...
  Call Trace:
   ? cifs_parse_mount_options+0x222/0x1710 [cifs]
   ? cifs_get_volume_info+0x2f/0x80 [cifs]
   cifs_setup_volume_info+0x20/0x190 [cifs]
   cifs_get_volume_info+0x50/0x80 [cifs]
   cifs_smb3_do_mount+0x59/0x630 [cifs]
   ? ida_alloc_range+0x34b/0x3d0
   cifs_do_mount+0x11/0x20 [cifs]
   mount_fs+0x52/0x170
   vfs_kern_mount+0x6b/0x170
   do_mount+0x216/0xdc0
   ksys_mount+0x83/0xd0
   __x64_sys_mount+0x25/0x30
   do_syscall_64+0x65/0x220
   entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fix this by adding a NULL check on devname in cifs_parse_devname()

Signed-off-by: Yao Liu <yotta.liu@ucloud.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7d4c2bf2fea2..f5f5aab3457f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1186,6 +1186,11 @@ cifs_parse_devname(const char *devname, struct smb_vol *vol)
 	const char *delims = "/\\";
 	size_t len;
 
+	if (unlikely(!devname || !*devname)) {
+		cifs_dbg(VFS, "Device name not specified.\n");
+		return -EINVAL;
+	}
+
 	/* make sure we have a valid UNC double delimiter prefix */
 	len = strspn(devname, delims);
 	if (len != 2)
-- 
2.19.1

