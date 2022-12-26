Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D3AC54EBF
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Dec 2022 14:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbiLZOWt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Dec 2022 09:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiLZOWK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Dec 2022 09:22:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A295FCB;
        Mon, 26 Dec 2022 06:22:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D3D560EB7;
        Mon, 26 Dec 2022 14:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEEEC433D2;
        Mon, 26 Dec 2022 14:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672064528;
        bh=n/8YydJ79H6S/fefunn6cS5wD6zvjrcaM37T3x4SMFw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ITEyGudTisy0cXAFBX6UA/0uO8IzKYmzwqZmTQfwsyU8qEjXxS8veri/7DHQtx2gE
         f/tC2MgveyNb4XnH2FXKEdpsxvf0aRkDnVAxTWvupN+x1TjHuDV6d0thwMxGap08hI
         mhkLBcN4s1dGvBHaM8AXziWJmTsKjlGE9eh2yuKx5056rBktL8OPI2ahK0J/RATzMy
         kGSGHNn/LeVBL6ZSVkSWPT2pK7fVoiDv9f6SIEyMjV31bk5PW1uuSNMvGFGOp5s8mK
         orIdD72HFP9XOkFHttlHqr+6DnRcNYGpQ207uuDc7fQtdj4tK2WM60BdcScb3TW3Bv
         Ne+0cPnSDicFQ==
Received: by pali.im (Postfix)
        id 7BAC69D7; Mon, 26 Dec 2022 15:22:08 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     linux-fsdevel@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, linux-cifs@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, "Theodore Y . Ts'o" <tytso@mit.edu>,
        Anton Altaparmakov <anton@tuxera.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, Dave Kleikamp <shaggy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Kari Argillander <kari.argillander@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>
Subject: [RFC PATCH v2 07/18] befs: Fix error processing when load_nls() fails
Date:   Mon, 26 Dec 2022 15:21:39 +0100
Message-Id: <20221226142150.13324-8-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221226142150.13324-1-pali@kernel.org>
References: <20221226142150.13324-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ensure that specified charset in iocharset= mount option is used. On error
correctly propagate error code back to the caller.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/befs/linuxvfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 5c66550f7933..8d2954e3afd6 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -913,10 +913,9 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 			   befs_sb->mount_opts.iocharset);
 		befs_sb->nls = load_nls(befs_sb->mount_opts.iocharset);
 		if (!befs_sb->nls) {
-			befs_warning(sb, "Cannot load nls %s"
-					" loading default nls",
+			befs_error(sb, "Cannot load nls %s",
 					befs_sb->mount_opts.iocharset);
-			befs_sb->nls = load_nls_default();
+			goto unacquire_priv_sbp;
 		}
 	/* load default nls if none is specified  in mount options */
 	} else {
-- 
2.20.1

