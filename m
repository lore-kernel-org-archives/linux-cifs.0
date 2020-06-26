Return-Path: <SRS0=5FUd=AH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D143BC433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C86E20720
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:06:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="RIARyi3z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgFZUG2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Jun 2020 16:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZUG1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Jun 2020 16:06:27 -0400
Received: from mail.darkrain42.org (o-chul.darkrain42.org [IPv6:2600:3c01::f03c:91ff:fe96:292c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF342C03E979
        for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2020 13:06:27 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by o-chul.darkrain42.org (Postfix) with ESMTPSA id 293C28106;
        Fri, 26 Jun 2020 12:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org; s=a;
        t=1593201518; bh=4XUOf+5g3ikrQNVCO8jlpGBNK7iGyBoM157TWLt6i90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIARyi3zfjrjIu6RqeKYkRwA27Z/1/tHByVKtXQX64ncSXc2eWqdKzdPyIUUkqFG6
         B0999MMA3iMGx/v64ilxWH+A5d6PccSFmi3+pFuDK+f4B9HVCp5eiRPu/TiEX6SKd5
         oWdWcOYnMGdbM5Y1IU2NbmtgnrLh0xKGBUwDhZQOunBMOlQ9Lk7zlL8HC0yASRnG5j
         EogbM5rqmKP8rnmukSv36bmrQew79I/CCJUyN+Bfwig51liDYL+J7w8tKFGmiDkNAW
         ooaTDHq9zXiyi8vwI5xwRaA6g98DYdQTK8IDpN6okqaqcbiZTglpxqaLFBDS2fkyLR
         qjFu0RUyo3NYg==
From:   Paul Aurich <paul@darkrain42.org>
To:     linux-cifs@vger.kernel.org, sfrench@samba.org
Cc:     paul@darkrain42.org
Subject: [PATCH 1/6] cifs: Display local UID details for SMB sessions in DebugData
Date:   Fri, 26 Jun 2020 12:58:04 -0700
Message-Id: <20200626195809.429507-2-paul@darkrain42.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200626195809.429507-1-paul@darkrain42.org>
References: <20200626195809.429507-1-paul@darkrain42.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is useful for distinguishing SMB sessions on a multiuser mount.

Signed-off-by: Paul Aurich <paul@darkrain42.org>
---
 fs/cifs/cifs_debug.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index fc98b97b396a..53588d7517b4 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -399,6 +399,10 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			if (ses->sign)
 				seq_puts(m, " signed");
 
+			seq_printf(m, "\n\tUser: %d Cred User: %d",
+				   from_kuid(&init_user_ns, ses->linux_uid),
+				   from_kuid(&init_user_ns, ses->cred_uid));
+
 			if (ses->chan_count > 1) {
 				seq_printf(m, "\n\n\tExtra Channels: %zu\n",
 					   ses->chan_count-1);
@@ -406,7 +410,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 					cifs_dump_channel(m, j, &ses->chans[j]);
 			}
 
-			seq_puts(m, "\n\tShares:");
+			seq_puts(m, "\n\n\tShares:");
 			j = 0;
 
 			seq_printf(m, "\n\t%d) IPC: ", j);
-- 
2.27.0

