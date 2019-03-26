Return-Path: <SRS0=KOHi=R5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE2EC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 16:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77DCF206DF
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 16:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbfCZQb6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Mar 2019 12:31:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:42904 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730451AbfCZQb6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Mar 2019 12:31:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AAAE3B121;
        Tue, 26 Mar 2019 16:31:57 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v1] CIFS: keep FileInfo handle around while writing pages
Date:   Tue, 26 Mar 2019 17:31:52 +0100
Message-Id: <20190326163152.27385-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <CAKywueSSULxWaFNb12EGJXmAr9k=hd6f3ND5f0AQhwho0PV6Tw@mail.gmail.com>
References: <CAKywueSSULxWaFNb12EGJXmAr9k=hd6f3ND5f0AQhwho0PV6Tw@mail.gmail.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In the oplock break handler, writing pending changes from pages puts
the FileInfo handle. If the refcount reaches zero it closes the handle
and waits for any oplock break handler to return, thus causing a deadlock.

To prevent it we keep an additionnal reference of the SMB FileInfo
handle while we write/read pages so that when writepages puts the
handle, it won't close it.

This was triggered by xfstest 464.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 89006e044973..a9a515ea2e14 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4579,12 +4579,15 @@ void cifs_oplock_break(struct work_struct *work)
 			break_lease(inode, O_RDONLY);
 		else
 			break_lease(inode, O_WRONLY);
+
+		cifsFileInfo_get(cfile);
 		rc = filemap_fdatawrite(inode->i_mapping);
 		if (!CIFS_CACHE_READ(cinode)) {
 			rc = filemap_fdatawait(inode->i_mapping);
 			mapping_set_error(inode->i_mapping, rc);
 			cifs_zap_mapping(inode);
 		}
+		cifsFileInfo_put(cfile);
 		cifs_dbg(FYI, "Oplock flush inode %p rc %d\n", inode, rc);
 	}
 
-- 
2.16.4

