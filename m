Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C474C61DA4
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 13:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbjCONFy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjCONFu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 09:05:50 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36F9570B7
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 06:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=HOrFjIBcjzrBvM4R5nK6rRExlyCGPWQmiwJQgpg/Dfk=; b=R+DsTb1Dt98GFQ/9lZ0+i8gzlP
        B+08g/jqUhkr1Vx82e5xTJlWo81Pu+lpSLD2+jGfv+lSscczu5oVA47eWrORH0XEFpgq44cJUNB1m
        BfxrpgK5AVGa9ZlXclHancticzE2F1kfGOA6AoB+fln4NXb+rfLj8Ys4GtkZC+4dY9Am5LPG7ZakC
        SdTSRVicG/nZ/zcObuL66O2vKsy4UTxId7t3G3tYaieBZd5oE2x2iaCW/i06WYJfHwKjGdgP0v8u0
        8lxx+gdlETdwVqwvY+pPrHL2+YpSx2MC3Xy+8X97O/keqnDcCBWPEXDjZbj5LtTjRl+WnTFtbRUU8
        EO3KyvbH08hc+JZMnfTSgnc3IuLh5nnbOIOLLGXAzrrKEO4NIXBBoblhrsYArHLnH7UhQlQGfs7KT
        R0CeP5RpyrDOhuVgpjyFtOclJkqRsJl3m9bW6hnObjg/gnkU0FVkSIm9LRdleNM9bP+Qn4a/umt7o
        hDX+al7nhdYtNfDqak3c1DJx;
Received: from [2a01:4f8:252:410e::177:224] (port=40716 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pcQp6-003KNd-Mv; Wed, 15 Mar 2023 13:05:44 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 04/10] cifs: Slightly simplify cifs_readdir()
Date:   Wed, 15 Mar 2023 13:05:25 +0000
Message-Id: <e3e730c19615971f01ff11238e81721b102997eb.1678885349.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678885349.git.vl@samba.org>
References: <cover.1678885349.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use the fact that we use "goto" in the else-branch, this avoids an
indentation level for the success case.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/readdir.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 7dfa33b6954f..0bca6dc10093 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -1166,9 +1166,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		cifs_dbg(FYI, "fce error %d\n", rc);
 		goto rddir2_exit;
 	}
-	if (current_entry != NULL) {
-		cifs_dbg(FYI, "entry %lld found\n", ctx->pos);
-	} else {
+	if (current_entry == NULL) {
 		if (cfid) {
 			mutex_lock(&cfid->dirents.de_mutex);
 			finished_cached_dirents_count(&cfid->dirents, ctx);
@@ -1177,6 +1175,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		cifs_dbg(FYI, "Could not find entry\n");
 		goto rddir2_exit;
 	}
+	cifs_dbg(FYI, "entry %lld found\n", ctx->pos);
 	cifs_dbg(FYI, "loop through %d times filling dir for net buf %p\n",
 		 num_to_fill, cifsFile->srch_inf.ntwrk_buf_start);
 	max_len = tcon->ses->server->ops->calc_smb_size(
-- 
2.30.2

