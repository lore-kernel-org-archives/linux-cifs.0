Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACEDC43460
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Apr 2021 17:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 482186140F
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Apr 2021 17:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243453AbhDWRbB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Apr 2021 13:31:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:43728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243429AbhDWRa7 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 23 Apr 2021 13:30:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5EAE9B1D6;
        Fri, 23 Apr 2021 17:30:19 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id C3FC11F2C54; Fri, 23 Apr 2021 19:30:18 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Ted Tso <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org
Subject: [PATCH 12/12] cifs: Fix race between hole punch and page fault
Date:   Fri, 23 Apr 2021 19:29:41 +0200
Message-Id: <20210423173018.23133-12-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210423171010.12-1-jack@suse.cz>
References: <20210423171010.12-1-jack@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Cifs has a following race between hole punching and page fault:

CPU1                                            CPU2
smb3_fallocate()
  smb3_punch_hole()
    truncate_pagecache_range()
                                                filemap_fault()
                                                  - loads old data into the
                                                    page cache
    SMB2_ioctl(..., FSCTL_SET_ZERO_DATA, ...)

And now we have stale data in the page cache. Fix the problem by locking
out faults (as well as reads) using mapping->invalidate_lock while hole
punch is running.

CC: Steve French <sfrench@samba.org>
CC: linux-cifs@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/cifs/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f703204fb185..18231f9bc336 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3543,6 +3543,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 		return rc;
 	}
 
+	down_write(&inode->i_mapping->invalidate_lock);
 	/*
 	 * We implement the punch hole through ioctl, so we need remove the page
 	 * caches first, otherwise the data may be inconsistent with the server.
@@ -3560,6 +3561,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			sizeof(struct file_zero_data_information),
 			CIFSMaxBufSize, NULL, NULL);
 	free_xid(xid);
+	up_write(&inode->i_mapping->invalidate_lock);
 	return rc;
 }
 
-- 
2.26.2

