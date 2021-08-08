Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D053C4320E
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Aug 2021 16:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB806113C
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Aug 2021 16:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhHHQZh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 8 Aug 2021 12:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231615AbhHHQZf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 8 Aug 2021 12:25:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD0C961055;
        Sun,  8 Aug 2021 16:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628439916;
        bh=zCoJxg1h9nD1iTSDYYND3mexw6H7t53eWmn6go64bfs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=KVfLZD0YZScrG/ph5XGKHZLExECypqZLKM1X3Bw6ZrhrZQssU6SEQkjZnYlMvXkaR
         COtwyTy7mTKO7xBlFz89XRFPDD3/+Gc/NKY/On3DOulLfdnvv4J4ScFRsiYpXhq0lv
         a1JrO2z7K9QSxZCgxGHHGfpft8Utwx1RcfBoBqKc0OtMRoDyc2i3Xxal88+5ThTkey
         lh0oX3MYKO47tjOVLtR5wqip+kkYfUu9ymvx4f8TR7H9x5HltpMczA5tuXcaVXTLjv
         3XFMnvmwrj3bSfjmXdyLALozpaAwdoYScSgqArTGD5aCFLyTXbzfoPfDqD+3usumC2
         j1EVIpi7ZXROw==
Received: by pali.im (Postfix)
        id 99F5713DC; Sun,  8 Aug 2021 18:25:15 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     linux-fsdevel@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, linux-cifs@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        Anton Altaparmakov <anton@tuxera.com>,
        Pavel Machek <pavel@ucw.cz>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Christoph Hellwig <hch@infradead.org>
Subject: [RFC PATCH 06/20] ntfs: Fix error processing when load_nls() fails
Date:   Sun,  8 Aug 2021 18:24:39 +0200
Message-Id: <20210808162453.1653-7-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210808162453.1653-1-pali@kernel.org>
References: <20210808162453.1653-1-pali@kernel.org>
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
 fs/ntfs/super.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 02de1aa05b7c..69c7871b742e 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -94,7 +94,7 @@ static bool parse_options(ntfs_volume *vol, char *opt)
 	umode_t fmask = (umode_t)-1, dmask = (umode_t)-1;
 	int mft_zone_multiplier = -1, on_errors = -1;
 	int show_sys_files = -1, case_sensitive = -1, disable_sparse = -1;
-	struct nls_table *nls_map = NULL, *old_nls;
+	struct nls_table *nls_map = NULL;
 
 	/* I am lazy... (-8 */
 #define NTFS_GETOPT_WITH_DEFAULT(option, variable, default_value)	\
@@ -195,20 +195,12 @@ static bool parse_options(ntfs_volume *vol, char *opt)
 			if (!v || !*v)
 				goto needs_arg;
 use_utf8:
-			old_nls = nls_map;
+			unload_nls(nls_map);
 			nls_map = load_nls(v);
 			if (!nls_map) {
-				if (!old_nls) {
-					ntfs_error(vol->sb, "NLS character set "
-							"%s not found.", v);
-					return false;
-				}
-				ntfs_error(vol->sb, "NLS character set %s not "
-						"found. Using previous one %s.",
-						v, old_nls->charset);
-				nls_map = old_nls;
-			} else /* nls_map */ {
-				unload_nls(old_nls);
+				ntfs_error(vol->sb, "NLS character set "
+					   "%s not found.", v);
+				return false;
 			}
 		} else if (!strcmp(p, "utf8")) {
 			bool val = false;
-- 
2.20.1

