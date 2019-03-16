Return-Path: <SRS0=lfdc=RT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DA5C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 04:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5055C218E0
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 04:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfCPEMA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Mar 2019 00:12:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfCPEMA (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 16 Mar 2019 00:12:00 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 53DDD31688E1;
        Sat, 16 Mar 2019 04:12:00 +0000 (UTC)
Received: from dhcp-12-126.nay.redhat.com (dhcp-12-126.nay.redhat.com [10.66.12.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09D2E60BE6;
        Sat, 16 Mar 2019 04:11:58 +0000 (UTC)
From:   XiaoLi Feng <xifeng@redhat.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     Xiaoli Feng <fengxiaoli0714@gmail.com>
Subject: [PATCH v2] cifs: fix that return -EINVAL when do dedupe operation
Date:   Sat, 16 Mar 2019 12:11:54 +0800
Message-Id: <20190316041154.27619-1-xifeng@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Sat, 16 Mar 2019 04:12:00 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Xiaoli Feng <fengxiaoli0714@gmail.com>

dedupe_file_range operations is combiled into remap_file_range.
But it's always skipped for dedupe operations in function
cifs_remap_file_range.

Example to test:
Before this patch:
  # dd if=/dev/zero of=cifs/file bs=1M count=1
  # xfs_io -c "dedupe cifs/file 4k 64k 4k" cifs/file
  XFS_IOC_FILE_EXTENT_SAME: Invalid argument

After this patch:
  # dd if=/dev/zero of=cifs/file bs=1M count=1
  # xfs_io -c "dedupe cifs/file 4k 64k 4k" cifs/file
  XFS_IOC_FILE_EXTENT_SAME: Operation not supported

Influence for xfstests:
generic/091
generic/112
generic/127
generic/263
These tests report this error "do_copy_range:: Invalid
argument" instead of "FIDEDUPERANGE: Invalid argument".
Because there are still two bugs cause these test failed.
https://bugzilla.kernel.org/show_bug.cgi?id=202935
https://bugzilla.kernel.org/show_bug.cgi?id=202785

Signed-off-by: Xiaoli Feng <fengxiaoli0714@gmail.com>
---

Sorry, there are some missing in commit log of last patch. Because they
are beginning with the world '#". The git will ignores these lines.
And add influence for xfstests.

 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 217276b8b942..f9b71c12cc9f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1008,7 +1008,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	unsigned int xid;
 	int rc;
 
-	if (remap_flags & ~REMAP_FILE_ADVISORY)
+	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
 		return -EINVAL;
 
 	cifs_dbg(FYI, "clone range\n");
-- 
2.18.1

