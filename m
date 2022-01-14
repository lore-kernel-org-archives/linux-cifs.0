Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1113C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jan 2022 19:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiANTxE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jan 2022 14:53:04 -0500
Received: from mail.astralinux.ru ([217.74.38.119]:45486 "EHLO
        mail.astralinux.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiANTxE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jan 2022 14:53:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 51CAA30637FA;
        Fri, 14 Jan 2022 22:53:02 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id F6nfRJuoy1wj; Fri, 14 Jan 2022 22:53:01 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id D2CD630637FB;
        Fri, 14 Jan 2022 22:53:01 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LJH32jIfEpYP; Fri, 14 Jan 2022 22:53:01 +0300 (MSK)
Received: from himera.home (37-145-209-165.broadband.corbina.ru [37.145.209.165])
        by mail.astralinux.ru (Postfix) with ESMTPSA id 96D1C30637F6;
        Fri, 14 Jan 2022 22:53:01 +0300 (MSK)
Date:   Fri, 14 Jan 2022 22:53:00 +0300
From:   Eugene Korenevsky <ekorenevsky@astralinux.ru>
To:     linux-cifs@vger.kernel.org
Cc:     Steve French <sfrench@samba.org>
Subject: [PATCH v2 1/2] cifs: alloc_path_with_tree_prefix: do not append sep.
 if the path is empty
Message-ID: <YeHUnI1nTkThNMqv@himera.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

alloc_path_with_tree_prefix() concatenates tree prefix and the path.
Windows CIFS client does not add separator after the tree prefix if the path
is empty. Let's do the same.

This fixes mounting DFS namespaces with names containing non-ASCII symbols.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215440
Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>
---
v2: The patch is included in the patchset for #215440 fix

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

