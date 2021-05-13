Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DC5C433ED
	for <linux-cifs@archiver.kernel.org>; Thu, 13 May 2021 16:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E4E5613CA
	for <linux-cifs@archiver.kernel.org>; Thu, 13 May 2021 16:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhEMQ4i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 May 2021 12:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhEMQ4h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 May 2021 12:56:37 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3738C061574
        for <linux-cifs@vger.kernel.org>; Thu, 13 May 2021 09:55:23 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id k10so6689470qtp.9
        for <linux-cifs@vger.kernel.org>; Thu, 13 May 2021 09:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gwmail.gwu.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A3RlebzumK4fwWT1g6X56MvDeVE+yh0/VbEO7iqxO7Y=;
        b=aM0eoV69VvprQUrTyUbnsyRwLhtc9v2X9TTz1Bh90nd46vAUrT+gV31TPjMejwxTOh
         CQm0ficz7+HsBbj3VlrSA2yvkkjcSAYzOAjF5nWlMbxEbnXXHRFwyacMQ8aS5fryRNxa
         oY7JbaFR2p2696Ai3bWtmhr4BEnyfFdooX8eZOp3kPyzppVHu3WB0NPhqNQn5AUOG819
         mq7M0qMuSQJCMQL99KoC8DMOoYssJiWLTuSqdbR0iXYCAh9DKI2wZso9f23vhMXYQwrG
         0FcddsgDsF1D1I9D1U16v+Vud12aHFpgS6UjrKBY0JccA+RltlHsbtEX7Z7p7auuGlbz
         JvqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=A3RlebzumK4fwWT1g6X56MvDeVE+yh0/VbEO7iqxO7Y=;
        b=Iqw0S0qm7DrCCthm2OMkTPymMqWkRmlXRjK6BpIQWIL5kfO4LkBExVdcZjulrbP0Ji
         zZWp7Cdvjcr7p43v4ev5a1YAJXCAM+kqpt3tlOBn4wRy5AGjhiPaFxZna9TvoVQZCJt3
         UHrHlIMmNkTMkkq1i+5o2KCKK65SknsT/swFsUrK//dtyiCa5dlvxPDZ/Lq7G4hczv09
         KMADthWhPPpSmDQvNmEip+m3pYlmVxm6YEtutxPEjQZ/Gxt5BOa7EeOKehcjMq7oC9LP
         4QRxhRLN9P8zdnlkK3AkMCYBfoDvR0l6RS76rIdvMFtUjGzcWo/EGss7A1KkiTAiUZaP
         SG4A==
X-Gm-Message-State: AOAM531Q+QZekXEw4INIQW5gVhz0I6K16cuhvmjorAMhKdArHOBpl5YY
        VcOZ+NezRTj0AtMi9lbJP988eQ==
X-Google-Smtp-Source: ABdhPJz9xooi0rxfZFpdaGUuPRq+I58reGjaeHKKrSFzRId6ykzgNlpy2+VVtXYndE/rFxu/go2OTQ==
X-Received: by 2002:a05:622a:289:: with SMTP id z9mr39845914qtw.325.1620924922983;
        Thu, 13 May 2021 09:55:22 -0700 (PDT)
Received: from bunsen3.telenet.unc.edu (bunsen3.telenet.unc.edu. [204.85.191.47])
        by smtp.googlemail.com with ESMTPSA id x28sm2941976qtm.71.2021.05.13.09.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 09:55:22 -0700 (PDT)
From:   wenhuizhang <wenhui@gwmail.gwu.edu>
Cc:     wenhuizhang <wenhui@gwmail.gwu.edu>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: remove deadstore in cifs_close_all_deferred_files()
Date:   Thu, 13 May 2021 12:55:16 -0400
Message-Id: <20210513165516.17723-1-wenhui@gwmail.gwu.edu>
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

cinode on filesystem should not be deleted when files are closed, 
they are representations of some data fields on a physical disk, 
thus no further action is required.
The virtual inode on vfs will be handled by vfs automatically, 
and the denotation is inode, which is different from the cinode.

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

