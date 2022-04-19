Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC4CC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Apr 2022 18:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356784AbiDSSWV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356773AbiDSSWC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Apr 2022 14:22:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59753D1C0;
        Tue, 19 Apr 2022 11:14:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85E6DB81866;
        Tue, 19 Apr 2022 18:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CBEC385AC;
        Tue, 19 Apr 2022 18:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392052;
        bh=o/R0aJ4jPfYY10v7Gc2Gjzn6zzboIP/onUXcr2KTwLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWoKpjmMmLS7Q/mbt7ZoDrDirHhrOnf8RUIjt5IhP1qD8jaItI8nqreov7k6VT0i9
         Xe0ms+4vWf9UpRVpYKWQsFsAyGfCVuAk0+X+4zBH0gS2fDaWG36o+hoQA4LQXiNU2g
         ABP0FpyMxBEAtE9SBL9VefhonqXTmWI6PpiNEd0uTVQIj7oPvYEgzB1gMmVCBLzOHG
         L44leqguB3eKiOeftW08pHcHyphhv4Y7mtqFslklRBnRoqp4DEmPLkuYSMH5mYkp2Q
         VfM+vaCguTbGCWREH3nSroM/C9ooNFgttAklOaRqicbzGHjPSV4ob76u9FVYz2y0en
         paM7A5eqn13qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.10 07/18] cifs: Check the IOCB_DIRECT flag, not O_DIRECT
Date:   Tue, 19 Apr 2022 14:13:41 -0400
Message-Id: <20220419181353.485719-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181353.485719-1-sashal@kernel.org>
References: <20220419181353.485719-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 994fd530a512597ffcd713b0f6d5bc916c5698f0 ]

Use the IOCB_DIRECT indicator flag on the I/O context rather than checking to
see if the file was opened O_DIRECT.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index aa5a4d759ca2..370188b2a55d 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -898,7 +898,7 @@ cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t rc;
 	struct inode *inode = file_inode(iocb->ki_filp);
 
-	if (iocb->ki_filp->f_flags & O_DIRECT)
+	if (iocb->ki_flags & IOCB_DIRECT)
 		return cifs_user_readv(iocb, iter);
 
 	rc = cifs_revalidate_mapping(inode);
-- 
2.35.1

