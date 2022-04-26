Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DBBC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Apr 2022 08:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345774AbiDZIrq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Apr 2022 04:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346669AbiDZIpR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Apr 2022 04:45:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65985659C;
        Tue, 26 Apr 2022 01:35:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AC1EB81D09;
        Tue, 26 Apr 2022 08:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948C6C385A4;
        Tue, 26 Apr 2022 08:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962115;
        bh=o/R0aJ4jPfYY10v7Gc2Gjzn6zzboIP/onUXcr2KTwLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPkyHwPJ75Y/d/EVJsy0pRzAzxJATuAAsKJoRUF4ZsPNWIGptgiMNZ+Mf1MwqlUEu
         mfnoxoydeccwVp5YAGsID8EFc5ZKlIiRET82fy8u6sE+JgDNXthItOQTz9wvsyVEZH
         l5V0eCyeGXzzAl7UCZNExq55Qp4G5ouR7iK/PpDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/86] cifs: Check the IOCB_DIRECT flag, not O_DIRECT
Date:   Tue, 26 Apr 2022 10:21:08 +0200
Message-Id: <20220426081742.362639259@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



