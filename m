Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24881C433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 22:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E04866191C
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 22:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhEKWfm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 18:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhEKWfl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 May 2021 18:35:41 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD37EC06174A
        for <linux-cifs@vger.kernel.org>; Tue, 11 May 2021 15:34:34 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id m13so666228qtk.13
        for <linux-cifs@vger.kernel.org>; Tue, 11 May 2021 15:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gwmail.gwu.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=42C6HOQrWTE0332FVLv9iuHqZnhb3K1H7/h3GIL4MSc=;
        b=R3jEIakaWLP5NOGisY4zhv2ai1fhVP4du3Af0XCzYkDEr7hC9neNDaWKQFaNRokVff
         g9ir6mrvxtoheB8wliCGGydK2tz2GMl/NxG8NOHpUVScs7tfT59egprnXznWQs6ENvcD
         AJ2kOYea2SEWt7YvaD21PciyAuRE1qrtteAul016yMMMQIxpoD3yhJrJTxq3yDS4iraZ
         nfGf9yBAF8jctw9Qo4GyZVxt3yBf90LThpHG8dEYMzywhTDKuywdgHrde7Z9H6eATbjR
         o391p+SDKEhSUh5yv28rcdE9TNz9BzR1bpIKY3ZzSkBIuYupdR6kPaG4iEKHHhbhFwT3
         1uCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=42C6HOQrWTE0332FVLv9iuHqZnhb3K1H7/h3GIL4MSc=;
        b=FhWTBVO4RTigruQxivksRF1hjqvAkwwCLmWJZ6a9ROZdP6unDE3NNlQQqxkZIdmzQM
         7DjJ9lglZ+FNSVYueg/3Ub99MUgHYj9zV2V0IQbYw1uK5di6AHT6UxjTiEz0MARk2/YV
         Ygnohjd+S7VqU8+6xO4ZszkGNyUaYeqGTgWyRMNf+OaIrrmT3BoUI2CYeIYSGDGTFYqn
         rk1BWsLhcpdfTlwtZMGfTpk5Ksd67kEZACHk9WF/5+iune2PNQxnUXUOcIyt7fzwU1xA
         xeN46PPTqm26vpr3ciWZM0uuTAkgj3qwW9GfSmzECOKiKgIHyqFwLJNrvn+rNsIgzT80
         zBIA==
X-Gm-Message-State: AOAM530gY57yFxrMLQnWyfA221WXScG19ozqFps/OOTnhdCEIpLcXQUK
        JD8jNGIhNiUwwabzOJiQw/Fx+w==
X-Google-Smtp-Source: ABdhPJxV96xnFvz7FJPLVu7Br1PXs3Jda9e433Lii337jAA4jXMN/PND2tj93cJuK4xl7CincupAVw==
X-Received: by 2002:a05:622a:d1:: with SMTP id p17mr30792975qtw.86.1620772474057;
        Tue, 11 May 2021 15:34:34 -0700 (PDT)
Received: from bunsen3.telenet.unc.edu (bunsen3.telenet.unc.edu. [204.85.191.47])
        by smtp.googlemail.com with ESMTPSA id b23sm9042761qtq.0.2021.05.11.15.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 15:34:33 -0700 (PDT)
From:   wenhuizhang <wenhui@gwmail.gwu.edu>
Cc:     wenhuizhang <wenhui@gwmail.gwu.edu>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Deadstore detected by Lukas Bulwahn's CodeChecker Tool (ELISA group)
Date:   Tue, 11 May 2021 18:34:25 -0400
Message-Id: <20210511223425.12863-1-wenhui@gwmail.gwu.edu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210509233327.22241-1-wenhui@gwmail.gwu.edu>
References: <20210509233327.22241-1-wenhui@gwmail.gwu.edu>
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Deadstore detected by Lukas Bulwahn's CodeChecker Tool (ELISA group).

line 741 struct cifsInodeInfo *cinode;
line 747 cinode = CIFS_I(d_inode(cfile->dentry));
could be deleted.

cinode on filesystem should not be deleted when files are closed, they are representations of some data fields on a physical disk, thus no further action is required.
The virtual inode on vfs will be handled by vfs automatically, and the denotation is inode, which is different from the cinode.

Signed-off-by: wenhuizhang <wenhui@gwmail.gwu.edu>

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

