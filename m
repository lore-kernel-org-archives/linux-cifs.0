Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17376C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Apr 2022 00:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiDMAEs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Apr 2022 20:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiDMAEs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Apr 2022 20:04:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D16261EAFA
        for <linux-cifs@vger.kernel.org>; Tue, 12 Apr 2022 17:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649808147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ULpH2oF/6mWR35VWLLfN8DKD7Nj1Mn0kHrlcjeTwZ0g=;
        b=N3oaYLjwgp0KhJV/ieluEl3xiM/BrLuyGoUSlZWK+nySufA7ceE2tPA11RiQXfSE5fZCF/
        vidw2aOeOG7CJEcf8l0C/GBYMVi8fev7eDUkjAnQt/i7BNWj0E0TDUxVO6p0Zb4jyc8xW9
        TJDDAdTFpMRlA1Fashj4aebDjbZNayE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-HFw-yotLMJ6JpaJAV4BvNQ-1; Tue, 12 Apr 2022 20:02:24 -0400
X-MC-Unique: HFw-yotLMJ6JpaJAV4BvNQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6377F2999B39;
        Wed, 13 Apr 2022 00:02:24 +0000 (UTC)
Received: from thinkpad (vpn2-54-19.bne.redhat.com [10.64.54.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD6E3416140;
        Wed, 13 Apr 2022 00:02:23 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: verify that tcon is valid before dereference in cifs_kill_sb
Date:   Wed, 13 Apr 2022 10:02:17 +1000
Message-Id: <20220413000217.1609615-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On umount, cifs_sb->tlink_tree might contain entries that do not represent
a valid tcon.
Check the tcon for error before we dereference it.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index aba0783a8f09..25719b70564a 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -266,10 +266,11 @@ static void cifs_kill_sb(struct super_block *sb)
 	 * before we kill the sb.
 	 */
 	if (cifs_sb->root) {
-		node = rb_first(root);
-		while (node != NULL) {
+		for(node = rb_first(root); node; node = rb_next(node)) {
 			tlink = rb_entry(node, struct tcon_link, tl_rbnode);
 			tcon = tlink_tcon(tlink);
+			if (IS_ERR(tcon))
+				continue;
 			cfid = &tcon->crfid;
 			mutex_lock(&cfid->fid_mutex);
 			if (cfid->dentry) {
@@ -277,7 +278,6 @@ static void cifs_kill_sb(struct super_block *sb)
 				cfid->dentry = NULL;
 			}
 			mutex_unlock(&cfid->fid_mutex);
-			node = rb_next(node);
 		}
 
 		/* finally release root dentry */
-- 
2.30.2

