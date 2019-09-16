Return-Path: <SRS0=fTzl=XL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9526C4CEC7
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Sep 2019 02:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E02221479
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Sep 2019 02:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbfIPC27 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 Sep 2019 22:28:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:40256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727873AbfIPC27 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 15 Sep 2019 22:28:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 71E89AE91;
        Mon, 16 Sep 2019 02:28:57 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 2/2] cifs: modefromsid: write mode ACE with DENY first
Date:   Mon, 16 Sep 2019 04:28:37 +0200
Message-Id: <20190916022837.32418-2-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190916022837.32418-1-aaptel@suse.com>
References: <20190916022837.32418-1-aaptel@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

DACL should start with denying ACE first but we are putting it at the
end. reorder them to put it first.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifsacl.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 3e0c5ed9ca20..28b56cb19d60 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -809,17 +809,11 @@ static int set_chmod_dacl(struct cifs_acl *pndacl, struct cifs_sid *pownersid,
 			struct cifs_sid *pgrpsid, __u64 nmode, bool modefromsid)
 {
 	u16 size = 0;
+	u32 num_aces = 0;
 	struct cifs_acl *pnndacl;
 
 	pnndacl = (struct cifs_acl *)((char *)pndacl + sizeof(struct cifs_acl));
 
-	size += fill_ace_for_sid((struct cifs_ace *) ((char *)pnndacl + size),
-					pownersid, nmode, S_IRWXU);
-	size += fill_ace_for_sid((struct cifs_ace *)((char *)pnndacl + size),
-					pgrpsid, nmode, S_IRWXG);
-	size += fill_ace_for_sid((struct cifs_ace *)((char *)pnndacl + size),
-					 &sid_everyone, nmode, S_IRWXO);
-
 	/* TBD: Move this ACE to the top of ACE list instead of bottom */
 	if (modefromsid) {
 		struct cifs_ace *pntace =
@@ -840,12 +834,22 @@ static int set_chmod_dacl(struct cifs_acl *pndacl, struct cifs_sid *pownersid,
 		pntace->sid.sub_auth[1] = sid_unix_NFS_mode.sub_auth[1];
 		pntace->sid.sub_auth[2] = cpu_to_le32(nmode & 07777);
 
-		pndacl->num_aces = cpu_to_le32(4);
 		size += fill_ace_for_sid((struct cifs_ace *)((char *)pnndacl + size),
 					 &sid_unix_NFS_mode, nmode, S_IRWXO);
-	} else
-		pndacl->num_aces = cpu_to_le32(3);
+		num_aces++;
+	}
+
+	size += fill_ace_for_sid((struct cifs_ace *) ((char *)pnndacl + size),
+					pownersid, nmode, S_IRWXU);
+	num_aces++;
+	size += fill_ace_for_sid((struct cifs_ace *)((char *)pnndacl + size),
+					pgrpsid, nmode, S_IRWXG);
+	num_aces++;
+	size += fill_ace_for_sid((struct cifs_ace *)((char *)pnndacl + size),
+					 &sid_everyone, nmode, S_IRWXO);
+	num_aces++;
 
+	pndacl->num_aces = cpu_to_le32(num_aces);
 	pndacl->size = cpu_to_le16(size + sizeof(struct cifs_acl));
 
 	return 0;
-- 
2.16.4

