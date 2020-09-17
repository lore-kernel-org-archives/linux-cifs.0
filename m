Return-Path: <SRS0=/4jl=C2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1FEC433E2
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 15:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 203F022228
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 15:13:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GPkxwUMd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgIQPNA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Sep 2020 11:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbgIQPLm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Sep 2020 11:11:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A60C06121D;
        Thu, 17 Sep 2020 08:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=lu11y1IB6qPsE9QG9F+oQMlPRPTZIY05Da6y3WAX60M=; b=GPkxwUMdgSb1OJ4/VmsY06Tw3d
        wGaBexmE5C59ZCk9mEQrvh9oEg9vXINOmQweMRoeaKlDN+2g7USOiJ7p9L6bGvMTgyOEzZOtR669A
        jIht28BCCCPOx7e6FE0aFJU+a0OyffBNocDLpE1149X17KE2LrFn/XIZhTexixrbCr/7fuXh5bEIC
        5+5CsSw56eGm4LgIdvEOovoEjzYZrFmqYQ0NKJCGq7JspTlxSRfyl5i2MbjOV1DdvtIMrAzZjoYaL
        ynre9v/sxNEHLDS79EF6RrWV5KTmLFDCVpjgtJr0LUrFEcYXA87AZmSArmQz3cvHn2mHKHdPH2VNi
        a4wd79ow==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIvYi-0001PE-2q; Thu, 17 Sep 2020 15:10:52 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        ecryptfs@vger.kernel.org, linux-um@lists.infradead.org,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 00/13] Allow readpage to return a locked page
Date:   Thu, 17 Sep 2020 16:10:37 +0100
Message-Id: <20200917151050.5363-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Linus recently made the page lock more fair.  That means that the old
pattern where we returned from ->readpage with the page unlocked and
then attempted to re-lock it will send us to the back of the queue for
this page's lock.

Ideally all filesystems would return from ->readpage with the
page Uptodate and Locked, but it's a bit painful to convert all the
asynchronous readpage implementations to synchronous.  These ones are
already synchronous, so convert them while I work on iomap.

A further benefit is that a synchronous readpage implementation allows
us to return an error to someone who might actually care about it.
There's no need to SetPageError, but I don't want to learn about how
a dozen filesystems handle I/O errors (hint: they're all different),
so I have not attempted to change that.

Please review your filesystem carefully.  I've tried to catch all the
places where a filesystem calls its own internal readpage implementation
without going through ->readpage, but I may have missed some.

Matthew Wilcox (Oracle) (13):
  mm: Add AOP_UPDATED_PAGE return value
  9p: Tell the VFS that readpage was synchronous
  afs: Tell the VFS that readpage was synchronous
  ceph: Tell the VFS that readpage was synchronous
  cifs: Tell the VFS that readpage was synchronous
  cramfs: Tell the VFS that readpage was synchronous
  ecryptfs: Tell the VFS that readpage was synchronous
  fuse: Tell the VFS that readpage was synchronous
  hostfs: Tell the VFS that readpage was synchronous
  jffs2: Tell the VFS that readpage was synchronous
  ubifs: Tell the VFS that readpage was synchronous
  udf: Tell the VFS that readpage was synchronous
  vboxsf: Tell the VFS that readpage was synchronous

 Documentation/filesystems/locking.rst |  7 ++++---
 Documentation/filesystems/vfs.rst     | 21 ++++++++++++++-------
 fs/9p/vfs_addr.c                      |  6 +++++-
 fs/afs/file.c                         |  3 ++-
 fs/ceph/addr.c                        |  9 +++++----
 fs/cifs/file.c                        |  8 ++++++--
 fs/cramfs/inode.c                     |  5 ++---
 fs/ecryptfs/mmap.c                    | 11 ++++++-----
 fs/fuse/file.c                        |  2 ++
 fs/hostfs/hostfs_kern.c               |  2 ++
 fs/jffs2/file.c                       |  6 ++++--
 fs/ubifs/file.c                       | 16 ++++++++++------
 fs/udf/file.c                         |  3 +--
 fs/vboxsf/file.c                      |  2 ++
 include/linux/fs.h                    |  5 +++++
 mm/filemap.c                          | 12 ++++++++++--
 16 files changed, 80 insertions(+), 38 deletions(-)

-- 
2.28.0

