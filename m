Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F256C432BE
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B82613CD
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Aug 2021 15:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhHWPPy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Aug 2021 11:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230354AbhHWPPx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Aug 2021 11:15:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04BEE613D0;
        Mon, 23 Aug 2021 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629731711;
        bh=ydK+EunvjzwlNsNkLHX/09K1jjfEE8zxCAbPujulFjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZpOBq99+HJFIOgIU9HrNdm+RgRgll3/lR8J+/KYtBreNjU6LFUSPqm/6fSIgJAw9
         cyAVk3wAwYsHU1ZHajcgTJyH2VXh3UD8WhWx6vKAEBsFnP52Au3dr/pvt+NxOlWlvI
         P3OaLlq/KUdQgEPjkKa/A9p0aI7t7LmTGUtX/QrA+oiz09P085RgIzr3KBsB0N6ns0
         e346PCl7N47gyAaeVBgcxnnKjd7IMeNYTVrKnXX7CHZ5RBtY9fUm04dELwyMwwLTkR
         te6ful/xIqIkeAkA2hlmIz0e0Yb8w+dX0D5zs70hPUFithisWbKcg2J1YdtH1uwFMD
         hcoQ5tigjjSKA==
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <stfrench@microsoft.com>,
        Christoph Hellwig <hch@infradead.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 03/11] ksmbd: fix translation in create_posix_rsp_buf()
Date:   Mon, 23 Aug 2021 17:13:49 +0200
Message-Id: <20210823151357.471691-4-brauner@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823151357.471691-1-brauner@kernel.org>
References: <20210823025816.7496-1-namjae.jeon@samsung.com>
 <20210823151357.471691-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1870; h=from:subject; bh=CI5yHbH4G/IhC2J6Wf4BDvxbndFm4SNorR/0uG4QMxo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQq7zb8MuH9fPdqz9Psfl0my6NuXW4XnLL6veiSmrYOeemz chNCOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZyJpKRoW9KWrJb0tG09CXurdvnfL mS+24349Y3L3x2mfLIftq/goXhv9/T7tOxX699/zoz2mudYNTGFxuXBis5fmzv4lmcM3n7Hj4A
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

When transfering ownership information to the client the k*ids are
translated into raw *ids before they are sent over the wire. The
function currently erroneously translates the k*ids according to the
mount's idmapping. Instead, reporting the owning *ids to userspace the
underlying k*ids need to be mapped up in the caller's user namespace.
This is how stat() works.
The caller in this instance is ksmbd itself and ksmbd always runs in the
initial user namespace. Translate according to that taking any potential
idmapped mounts into account.

Switch to from_k*id_munged() which ensures that the overflow*id is
returned instead of the (*id_t)-1 when the k*id can't be translated.

Cc: Steve French <stfrench@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ksmbd/oplock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 6ace6c2f22dc..16b6236d1bd2 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1614,9 +1614,11 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
 	buf->nlink = cpu_to_le32(inode->i_nlink);
 	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
 	buf->mode = cpu_to_le32(inode->i_mode);
-	id_to_sid(from_kuid(user_ns, inode->i_uid),
+	id_to_sid(from_kuid_munged(&init_user_ns,
+				   i_uid_into_mnt(user_ns, inode)),
 		  SIDNFS_USER, (struct smb_sid *)&buf->SidBuffer[0]);
-	id_to_sid(from_kgid(user_ns, inode->i_gid),
+	id_to_sid(from_kgid_munged(&init_user_ns,
+				   i_gid_into_mnt(user_ns, inode)),
 		  SIDNFS_GROUP, (struct smb_sid *)&buf->SidBuffer[20]);
 }
 
-- 
2.30.2

