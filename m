Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC3EC433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Apr 2021 07:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93F1961166
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Apr 2021 07:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238711AbhDPHlu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Apr 2021 03:41:50 -0400
Received: from mail.astralinux.ru ([217.74.38.119]:49066 "EHLO
        mail.astralinux.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbhDPHlu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Apr 2021 03:41:50 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Apr 2021 03:41:49 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id E703835E76A5;
        Fri, 16 Apr 2021 10:35:32 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id xDAy0NnRM9mc; Fri, 16 Apr 2021 10:35:32 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 3B62035E769F;
        Fri, 16 Apr 2021 10:35:32 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id C0i-Y4wx9fzO; Fri, 16 Apr 2021 10:35:32 +0300 (MSK)
Received: from himera.home (95-24-186-126.broadband.corbina.ru [95.24.186.126])
        by mail.astralinux.ru (Postfix) with ESMTPSA id 153D135E769B;
        Fri, 16 Apr 2021 10:35:32 +0300 (MSK)
Date:   Fri, 16 Apr 2021 10:35:30 +0300
From:   Eugene Korenevsky <ekorenevsky@astralinux.ru>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: [PATCH] cifs: fix out-of-bound memory access when calling
 smb3_notify() at mount point
Message-ID: <20210416073530.GA21974@himera.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If smb3_notify() is called at mount point of CIFS, build_path_from_dentry()
returns the pointer to kmalloc-ed memory with terminating zero (this is
empty FileName to be passed to SMB2 CREATE request). This pointer is assigned
to the `path` variable.
Then `path + 1` (to skip first backslash symbol) is passed to
cifs_convert_path_to_utf16(). This is incorrect for empty path and causes
out-of-bound memory access.

Get rid of this "increase by one". cifs_convert_path_to_utf16() already
contains the check for leading backslash in the path.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212693
Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index caa5432a5ed1..b13a8e3e1e24 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2264,7 +2264,7 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 		goto notify_exit;
 	}
 
-	utf16_path = cifs_convert_path_to_utf16(path + 1, cifs_sb);
+	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (utf16_path == NULL) {
 		rc = -ENOMEM;
 		goto notify_exit;
-- 
2.20.1

