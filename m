Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08543C433B4
	for <linux-cifs@archiver.kernel.org>; Sun,  9 May 2021 23:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD81613D0
	for <linux-cifs@archiver.kernel.org>; Sun,  9 May 2021 23:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhEIXem (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 May 2021 19:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhEIXel (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 May 2021 19:34:41 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB0DC061574
        for <linux-cifs@vger.kernel.org>; Sun,  9 May 2021 16:33:35 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id 76so13789351qkn.13
        for <linux-cifs@vger.kernel.org>; Sun, 09 May 2021 16:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gwmail.gwu.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=YkDDytZNQxbBUAfAVAEk4fD9xRC/hQr+ckTlhR7Sl/U=;
        b=FG6PiqyE9rwCmLm9vyAou6ABFbikh0QGJVU0tj77mdedT8Gdo/QKRDk6Gkn50zGeLC
         Svv58IeJagoFS7uMs2L5zQi0Se21n5ap2lva5U9g3qMt/9IjtBYTGNfLb47dHk1LN92S
         iWClsRA7Mc1xYvmY1v5g2PEUNU+eSH9HgLTf3QLQ8Dnhqmsc3X/ix2mW6PHZbtTcXdz2
         5fI+JZAuWqEChaenVa3KD6cA2a0ZHFJfK/sDWYE+rPFlvkqOnLMkmVv54emtTkv+rfML
         6ZRnhHaVcyH7PqQ47CqDBIdP1GBmNeu+UP29Wu5JKza9mvY7yndPNUysZhJsf+CQz0Az
         rIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YkDDytZNQxbBUAfAVAEk4fD9xRC/hQr+ckTlhR7Sl/U=;
        b=b9JqiMEw/E/34a5PMB4aC9GGllrQ3/aKIuOl2YSCKG+dFcHieLUQZMUQX277rDqxdz
         X4V3izrxF1P2drjzEfu31v+N38KztTjPrFg5nnHJguxH3HH0Ht69rnZKC8qKiYPzmpy9
         ENQML+5Vzwe/EQ8xZdFndkgW8Y2YVanNqmbnVWNwJLvaBEHjBZGmpNvdOBoox9gYOoOl
         slhUtzw8bqrGqcTInnr9Azo+MPKEv/Yt14ddgBOCOr7y4S2+pvqD8UyiWKGsrpjYf4rX
         uLhLZZCQYCm4KqiVq9n03Pr+9aBWXJQy/wPbwupqoS3/3uJ/WKkb7gHvn1tKFALV6qQb
         fSmQ==
X-Gm-Message-State: AOAM530K7dl8JEhEhw4BjCCA4I9IBJyfFNJ+ua8n3JdeX/RDP3YTtQKy
        ibeLxg/rdwcox1lxnjLwRlCN6Q==
X-Google-Smtp-Source: ABdhPJx8IK1oBHvd+hmpLgGmiiozZrYWxFIVWOxr6sSYq+mtN0m69XKwqC5beCyk5AaJfI+3WS4Tvg==
X-Received: by 2002:a05:620a:c8f:: with SMTP id q15mr444683qki.400.1620603214599;
        Sun, 09 May 2021 16:33:34 -0700 (PDT)
Received: from bunsen3.telenet.unc.edu (bunsen3.telenet.unc.edu. [204.85.191.47])
        by smtp.googlemail.com with ESMTPSA id 7sm5789256qkd.20.2021.05.09.16.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 16:33:34 -0700 (PDT)
From:   wenhuizhang <wenhui@gwmail.gwu.edu>
Cc:     wenhui@gwmail.gwu.edu, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Signed-off-by: wenhuizhang <wenhui@gwmail.gwu.edu>
Date:   Sun,  9 May 2021 19:33:27 -0400
Message-Id: <20210509233327.22241-1-wenhui@gwmail.gwu.edu>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Deadstore detected by Lukas Bulwahn's CodeChecker Tool (ELISA group).

line 741 struct cifsInodeInfo *cinode;
line 747 cinode = CIFS_I(d_inode(cfile->dentry));
could be deleted.

Signed-off-by: wenhuizhang <wenhui@gwmail.gwu.edu>

cinode on filesystem should not be deleted when files are closed, they are representations of some data fields on a physical disk, thus no further action is required.
The virtual inode on vfs will be handled by vfs automatically, and the denotation is inode, which is different from the cinode.
---
 fs/cifs/misc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 524dbdfb7184..801a5300f765 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -738,13 +738,11 @@ void
 cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 {
 	struct cifsFileInfo *cfile;
-	struct cifsInodeInfo *cinode;
 	struct list_head *tmp;
 
 	spin_lock(&tcon->open_file_lock);
 	list_for_each(tmp, &tcon->openFileList) {
 		cfile = list_entry(tmp, struct cifsFileInfo, tlist);
-		cinode = CIFS_I(d_inode(cfile->dentry));
 		if (delayed_work_pending(&cfile->deferred))
 			mod_delayed_work(deferredclose_wq, &cfile->deferred, 0);
 	}
-- 
2.17.1

