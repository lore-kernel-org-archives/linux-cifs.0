Return-Path: <SRS0=0xI7=SB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 055ACC4360F
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Mar 2019 01:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C05162064A
	for <linux-cifs@archiver.kernel.org>; Sat, 30 Mar 2019 01:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553908105;
	bh=nNt3A//oZ5zKvlSgWp5Dx8SjS1d3o64H9MxcVgNvjo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=aVE8bBCSij2GNFFLOkUKNHzdIj7C4fMAQYQeqTVuWg/wSla1zrLHy8yomtEvexT1h
	 BDnPmOfIj1rSRNb1NBTFQthwbmwB9GhfY5MO5uk1gR1v6aMqK8q+9k+g3rUkC2bTuY
	 Z0MxRmHyC0w86WdjfRbpybEPl9nIF6Uu/+XLkhGc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbfC3Awv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Mar 2019 20:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731127AbfC3Awv (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 29 Mar 2019 20:52:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF463218D3;
        Sat, 30 Mar 2019 00:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553907170;
        bh=nNt3A//oZ5zKvlSgWp5Dx8SjS1d3o64H9MxcVgNvjo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIRmEw9gzWUy3i1HCrR8IPoxqCfOlHichBg6A3JD1BoRv4/Sk4sQ5u2Qu71IReOht
         hcSWcpzgvrEl5w+oMb9Ob1GNLtjjn5z7/h3UUoIzWqvEZLpMW6GZzIyB3/lQHlHLOL
         Z5hPCcuzvaLi6ZJ0x3JUTT4GiK3sxTb+BjPh4tEo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoli Feng <fengxiaoli0714@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 63/67] cifs: fix that return -EINVAL when do dedupe operation
Date:   Fri, 29 Mar 2019 20:50:43 -0400
Message-Id: <20190330005047.25998-63-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190330005047.25998-1-sashal@kernel.org>
References: <20190330005047.25998-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Xiaoli Feng <fengxiaoli0714@gmail.com>

[ Upstream commit b073a08016a10f01dfb0d0b6c7fa89da0d544963 ]

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f2c0d863fb52..f192fcb09468 100644
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
2.19.1

