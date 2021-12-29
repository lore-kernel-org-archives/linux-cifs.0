Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E729AC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Dec 2021 21:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhL2Vcg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Dec 2021 16:32:36 -0500
Received: from mail.astralinux.ru ([217.74.38.119]:41918 "EHLO
        mail.astralinux.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbhL2Vcg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Dec 2021 16:32:36 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Dec 2021 16:32:35 EST
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id C96052FA8066;
        Thu, 30 Dec 2021 00:32:34 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id VA3HS0ZxnR7w; Thu, 30 Dec 2021 00:32:34 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 466972FA8069;
        Thu, 30 Dec 2021 00:32:34 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JeSdrgKkN6fo; Thu, 30 Dec 2021 00:32:34 +0300 (MSK)
Received: from himera.home (37-145-209-165.broadband.corbina.ru [37.145.209.165])
        by mail.astralinux.ru (Postfix) with ESMTPSA id EFC212FA8066;
        Thu, 30 Dec 2021 00:32:33 +0300 (MSK)
Date:   Thu, 30 Dec 2021 00:32:32 +0300
From:   Eugene Korenevsky <ekorenevsky@astralinux.ru>
To:     linux-cifs@vger.kernel.org
Cc:     Steve French <sfrench@samba.org>
Subject: [PATCH] cifs: alloc_path_with_tree_prefix: do not append sep. if the
 path is empty
Message-ID: <YczT8K47eA6JqEIB@himera.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

alloc_path_with_tree_prefix() concatenates tree prefix and the path.
Windows CIFS client does not append separator after the tree prefix if
the path is empty. Let's do the same.

This fixes mounting DFS namespaces with names containing non-ASCII symbols.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215440
Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>
---
 fs/cifs/smb2pdu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8b3670388cda..88ea0163257c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2527,8 +2527,13 @@ alloc_path_with_tree_prefix(__le16 **out_path, int *out_size, int *out_len,
 
 	cp = load_nls_default();
 	cifs_strtoUTF16(*out_path, treename, treename_len, cp);
-	UniStrcat(*out_path, sep);
-	UniStrcat(*out_path, path);
+
+	/* Do not append the separator if the path is empty */
+	if (path[0] != cpu_to_le16(0x0000)) {
+		UniStrcat(*out_path, sep);
+		UniStrcat(*out_path, path);
+	}
+
 	unload_nls(cp);
 
 	return 0;
-- 
2.30.2
