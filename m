Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B53C433FE
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Oct 2022 20:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiJNUOM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Oct 2022 16:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiJNUOL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Oct 2022 16:14:11 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B036B871
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 13:14:10 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 1810480514;
        Fri, 14 Oct 2022 20:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1665778447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+JA3/cPY5qFrCi7LXNrELYi/4ReAp4tLxczJMBJ8LuM=;
        b=ggrdtL46mzVZJdvcpALAz44DfTPaS7xAo56rWXYE7oCkkUZdvOjkEzAb6jO75YMFXK3dUs
        B4OKTUWO6GJubeqjl3fs6jMGLrGEh/dg+sn+F91BpVKjlz3uL6IIxlHu/3UqRqh9I5/+Nn
        l/oMKagc/fijhTVV+SnoEYboWBKQSV7qtikYngWkpZvOOeqS9aeap9AIySQkTcvQjdDwpp
        1x+tbkhVrwv5unl9iWbM0AdDbiOqMaXwvEXXKy+OaWZcILVt/z3XGZtm3tqtXqj/c9baPO
        zLXkl7sX9D2Njz2Y4u7Jvpw6Mhwe4K2vh32NUjGJuVWG7WCdeaNIbkN63QH4iw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, ematsumiya@suse.de,
        Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: fix double-fault crash during ntlmssp
Date:   Fri, 14 Oct 2022 17:14:54 -0300
Message-Id: <20221014201454.4456-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The crash occurred because we were calling memzero_explicit() on an
already freed sess_data::iov[1] (ntlmsspblob) in sess_free_buffer().

Fix this by not calling memzero_explicit() on sess_data::iov[1] as
it's already by handled by callers.

Fixes: d867d4ae29c7 ("cifs: replace kfree() with kfree_sensitive() for sensitive data")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/sess.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index f1c3c6d9146c..d33a27c1af4e 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1213,16 +1213,18 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 static void
 sess_free_buffer(struct sess_data *sess_data)
 {
-	int i;
+	struct kvec *iov = sess_data->iov;
 
-	/* zero the session data before freeing, as it might contain sensitive info (keys, etc) */
-	for (i = 0; i < 3; i++)
-		if (sess_data->iov[i].iov_base)
-			memzero_explicit(sess_data->iov[i].iov_base, sess_data->iov[i].iov_len);
+	/*
+	 * Zero the session data before freeing, as it might contain sensitive info (keys, etc).
+	 * Note that iov[1] is already freed by caller.
+	 */
+	if (sess_data->buf0_type != CIFS_NO_BUFFER && iov[0].iov_base)
+		memzero_explicit(iov[0].iov_base, iov[0].iov_len);
 
-	free_rsp_buf(sess_data->buf0_type, sess_data->iov[0].iov_base);
+	free_rsp_buf(sess_data->buf0_type, iov[0].iov_base);
 	sess_data->buf0_type = CIFS_NO_BUFFER;
-	kfree(sess_data->iov[2].iov_base);
+	kfree_sensitive(iov[2].iov_base);
 }
 
 static int
-- 
2.37.3

