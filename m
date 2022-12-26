Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9789C3DA79
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Dec 2022 14:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiLZOWq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Dec 2022 09:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiLZOWK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Dec 2022 09:22:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718F0262D;
        Mon, 26 Dec 2022 06:22:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C31FB80D42;
        Mon, 26 Dec 2022 14:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EA4C433D2;
        Mon, 26 Dec 2022 14:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672064526;
        bh=ONMvtrjl0bWB4AJ/38sMd2FmiCDCBw+bnetddn3dC24=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BtF/0hhHi7VDPuh08/nofWycrKkja0tYnSt9ZU1A049aN/GJy21ObSnDwEwMD2iCM
         93ORyhD0HbbugTIyy62xetc+3pR6P9jADZXJKGu3XfBkY04qNSHxWLK+jEqO8dNax9
         kcBgBevZ7IoV1tmQIhSXsy+WTTFoKKE910vIxllHEulPCLiG+Cf2cjt1LXplFtfopP
         Rsml4vweLF5idhuSWLsluFqQA/8vPBuEH0TzTvghg4L3QEY28s5+x6zAqkiRMyLCJm
         LfHApyp/MSrXItoCw5ijEpjQayVrmZNJOT5lbYO5G7SWc2PDpzmaHtBCR6xjqdkF+U
         r58o+Uruxdt2Q==
Received: by pali.im (Postfix)
        id 63BF99D7; Mon, 26 Dec 2022 15:22:06 +0100 (CET)
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
Subject: [RFC PATCH v2 05/18] befs: Fix printing iocharset= mount option
Date:   Mon, 26 Dec 2022 15:21:37 +0100
Message-Id: <20221226142150.13324-6-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221226142150.13324-1-pali@kernel.org>
References: <20221226142150.13324-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Mount option is named iocharset= and not charset=

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/befs/linuxvfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 32749fcee090..f983852ba863 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -777,7 +777,7 @@ static int befs_show_options(struct seq_file *m, struct dentry *root)
 		seq_printf(m, ",gid=%u",
 			   from_kgid_munged(&init_user_ns, opts->gid));
 	if (opts->iocharset)
-		seq_printf(m, ",charset=%s", opts->iocharset);
+		seq_printf(m, ",iocharset=%s", opts->iocharset);
 	if (opts->debug)
 		seq_puts(m, ",debug");
 	return 0;
-- 
2.20.1

