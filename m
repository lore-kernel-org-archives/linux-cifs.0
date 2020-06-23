Return-Path: <SRS0=n4et=AE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818FBC433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Jun 2020 11:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62C3B206C3
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Jun 2020 11:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbgFWLai (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Jun 2020 07:30:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:60558 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732245AbgFWLai (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 23 Jun 2020 07:30:38 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B1447355288895BF26D8;
        Tue, 23 Jun 2020 19:30:35 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 23 Jun 2020 19:30:25 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <zhangxiaoxu5@huawei.com>, <sfrench@samba.org>,
        <piastryyy@gmail.com>
CC:     <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>
Subject: [PATCH v2 2/2] cifs/smb3: Fix data inconsistent when zero file range
Date:   Tue, 23 Jun 2020 07:31:54 -0400
Message-ID: <20200623113154.2629513-3-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200623113154.2629513-1-zhangxiaoxu5@huawei.com>
References: <20200623113154.2629513-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

CIFS implements the fallocate(FALLOC_FL_ZERO_RANGE) with send SMB
ioctl(FSCTL_SET_ZERO_DATA) to server. It just set the range of the
remote file to zero, but local page cache not update, then the data
inconsistent with server, which leads the xfstest generic/008 failed.

So we need to remove the local page caches before send SMB
ioctl(FSCTL_SET_ZERO_DATA) to server. After next read, it will
re-cache it.

Fixes: 30175628bf7f5 ("[SMB3] Enable fallocate -z support for SMB3 mounts")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: stable@vger.kernel.org # v3.17
---
 fs/cifs/smb2ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 02fe77b2f517..478178468d52 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3187,6 +3187,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 			      ses->Suid, offset, len);
 
+	/*
+	 * We zero the range through ioctl, so we need remove the page caches
+	 * first, otherwise the data may be inconsistent with the server.
+	 */
+	truncate_pagecache_range(inode, offset, offset + len - 1);
 
 	/* if file not oplocked can't be sure whether asking to extend size */
 	if (!CIFS_CACHE_READ(cifsi))
-- 
2.25.4

