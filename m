Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C04C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 12:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 505B1610A0
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 12:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240907AbhIWMEg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 08:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240818AbhIWMEf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 23 Sep 2021 08:04:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83E12610A0;
        Thu, 23 Sep 2021 12:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632398583;
        bh=FQz1Hx7dhy50S0arnFB4DGGwDM+1TkZS6vyl7K/j9/Y=;
        h=From:To:Cc:Subject:Date:From;
        b=hs1+TkK8I/R1af+reqmTAW3Gli8LvFquWqgZaZ3JksyPT2NxnwNiPBoKrbqRpyuZk
         bKTat78fBn7RhObGGEXx/F4LUl79rBKMBSOOiYMz7jikcyeBsSuTqO0/AJQogwNl5/
         kFtynJf/lURlSjVqUmx+rMOoWUVKVKKhdiiB95Y3YahYxK/qEh+DnhLoNzXjUUHs6P
         Zyl4zTU6KRGx7Fv/fl7p599SMWRB7eFuTuR8tOeh9p/Zj5rqc8JlhKH5mzeH+JrA/5
         /DzW/QhvLtAAElZPiUYLQxkwxUjRp5AjtygK9eJMIrad16ynvTFEqhBdAINJ0PtFIr
         uBv2i7EFwR0FQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] cifs: switch to noop_direct_IO
Date:   Thu, 23 Sep 2021 08:03:02 -0400
Message-Id: <20210923120302.20904-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The cifs one is identical to the noop one. Just use it instead.

Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/cifs/file.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d0216472f1c6..6dab76f3882c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4890,25 +4890,6 @@ void cifs_oplock_break(struct work_struct *work)
 	cifs_done_oplock_break(cinode);
 }
 
-/*
- * The presence of cifs_direct_io() in the address space ops vector
- * allowes open() O_DIRECT flags which would have failed otherwise.
- *
- * In the non-cached mode (mount with cache=none), we shunt off direct read and write requests
- * so this method should never be called.
- *
- * Direct IO is not yet supported in the cached mode. 
- */
-static ssize_t
-cifs_direct_io(struct kiocb *iocb, struct iov_iter *iter)
-{
-        /*
-         * FIXME
-         * Eventually need to support direct IO for non forcedirectio mounts
-         */
-        return -EINVAL;
-}
-
 static int cifs_swap_activate(struct swap_info_struct *sis,
 			      struct file *swap_file, sector_t *span)
 {
@@ -4973,7 +4954,7 @@ const struct address_space_operations cifs_addr_ops = {
 	.write_end = cifs_write_end,
 	.set_page_dirty = __set_page_dirty_nobuffers,
 	.releasepage = cifs_release_page,
-	.direct_IO = cifs_direct_io,
+	.direct_IO = noop_direct_IO,
 	.invalidatepage = cifs_invalidate_page,
 	.launder_page = cifs_launder_page,
 	/*
-- 
2.31.1

