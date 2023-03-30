Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2350C6FD1D
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Mar 2023 08:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjC3I4J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Mar 2023 04:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjC3I4H (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Mar 2023 04:56:07 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0496E65A6
        for <linux-cifs@vger.kernel.org>; Thu, 30 Mar 2023 01:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=KT9wjTik/dK43IxC+jZ3Utq0HrdVkC2ADH/FKHxU0MQ=; b=KRT774B8WR1ZavLeN+CcgGrtuY
        Yz2lGZe0Hhv+YoFSwq0ejKexzyqphSZVcVjFazm2eFL5kHFdP8rK3liYS0Lk1zsNJWxbLNpPSFQMT
        BWvdHzIxP1874QW0u/k2ChgVETSd0D+G/9ARrTVW+2HdNy/z4e0ODbrJrTPxwJA2jP+BZ5cgqtz04
        Nq15HgpEFV28XgapHpYLc2voyh010Je8YFuI/ftpULtQS2OS503tP4m3NwTPd5eCQmjtn/bxZTYrX
        ed4ar1+qpsuz2rvVFeVqn9qwqkSiRWwestqdOLGD+mBx5v3f52/59YU8atir912bjhm41yCTxDc8o
        40YGae2M4r593ojyAHROVbwePD4BvPkUUTcEpHKhV4qVb6Ikfoh11M6bRToVMIJ5SCmCa8zTuzVaN
        ExcQ22Jsr6yrGQqTJiOChwUIM8C36GmquwTM7n0rkGZagkpScGAgIw+onlShX3NDhDAfDEZj8Xmyv
        bhZioh+JHY7qlLzMC3kl32Kj;
Received: from [2a01:4f8:252:410e::177:224] (port=33758 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pho4e-006FVU-OT; Thu, 30 Mar 2023 08:56:00 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH] cifs: Remove "wait_oplock_handler" from cifs_close_deferred_file()
Date:   Thu, 30 Mar 2023 08:55:54 +0000
Message-Id: <1852a9472df889fa2a2d92f57c8d8d5d88f18252.1680166446.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Our only caller gave "false".

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/cifsproto.h | 3 +--
 fs/cifs/file.c      | 2 +-
 fs/cifs/misc.c      | 4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index d2819d449f05..e2eff66eefab 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -278,8 +278,7 @@ extern void cifs_add_deferred_close(struct cifsFileInfo *cfile,
 
 extern void cifs_del_deferred_close(struct cifsFileInfo *cfile);
 
-extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode,
-				     bool wait_oplock_handler);
+extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode);
 
 extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 47f61a51f552..a333e696e674 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4936,7 +4936,7 @@ void cifs_oplock_break(struct work_struct *work)
 			cfile->deferred_close_scheduled && delayed_work_pending(&cfile->deferred)) {
 		if (cancel_delayed_work(&cfile->deferred)) {
 			_cifsFileInfo_put(cfile, false, false);
-			cifs_close_deferred_file(cinode, false);
+			cifs_close_deferred_file(cinode);
 			goto oplock_break_done;
 		}
 	}
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index fe4bf1f9de91..6d56f070514a 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -735,7 +735,7 @@ cifs_del_deferred_close(struct cifsFileInfo *cfile)
 }
 
 void
-cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode, bool wait_oplock_handler)
+cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 {
 	struct cifsFileInfo *cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
@@ -762,7 +762,7 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode, bool wait_oplock_hand
 	spin_unlock(&cifs_inode->open_file_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		_cifsFileInfo_put(tmp_list->cfile, wait_oplock_handler, false);
+		_cifsFileInfo_put(tmp_list->cfile, false, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
-- 
2.30.2

