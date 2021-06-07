Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6749CC48BCD
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Jun 2021 09:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A46461159
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Jun 2021 09:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhFGJd2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Jun 2021 05:33:28 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:53694 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhFGJd1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Jun 2021 05:33:27 -0400
Received: from relay2.suse.de (unknown [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0FDDD21A82;
        Mon,  7 Jun 2021 09:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623058296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=K8czBL2wzdToEj6Y23/15vfT7f41eICXUYjgoTQ3DMo=;
        b=O2vWaKAm0r/7WnkbgBWwq/g7nRgKc/mm0hzwPfFvCZa3VHhV4J4RboUx1Jwe55X1Ehk1Vg
        XZd846qbWQYsLZWrmTpJBgeoFbOoL0a1nX7AWwk5p68wUwtN3Y1oHViL2qh/hPGLfeqk4B
        qVun+gKkJ7pFBaVJvSeh9WEOtGj2KuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623058296;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=K8czBL2wzdToEj6Y23/15vfT7f41eICXUYjgoTQ3DMo=;
        b=sXCDTXySeXmlUHPwskff+3cbjM+LU+a/AzpfI97//cQ6Af5ZLKqk/unTyMWPOXGW5LVnNd
        6XL7+aEb7HygOTDw==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        by relay2.suse.de (Postfix) with ESMTP id EE09FA3B83;
        Mon,  7 Jun 2021 09:31:35 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Steve French <sfrench@samba.org>,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH linux-next] cifs: fix type of chans_need_reconnect on 32bit
Date:   Mon,  7 Jun 2021 11:31:25 +0200
Message-Id: <20210607093125.3459-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

commit 69f98828728f ("cifs: get rid of binding_chan and use
chans_need_reconnect instead") uses chans_need_reconnect with test_bit
which expects volatile unsigned long but the field is size_t.

There are only 16 channels and the variable is assiggned into unsigned
long and plain int locals so there is clearly no need for the 64bit
precision. Also it could fail quite badly on 32bit bigendian.

Fixes: 69f98828728f ("cifs: get rid of binding_chan and use chans_need_reconnect instead")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 fs/cifs/cifs_debug.c | 2 +-
 fs/cifs/cifsfs.c     | 2 +-
 fs/cifs/cifsglob.h   | 6 +++---
 fs/cifs/sess.c       | 6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 15635b45af59..9b0f35b7746c 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -425,7 +425,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				   from_kuid(&init_user_ns, ses->cred_uid));
 
 			if (ses->chan_count > 1) {
-				seq_printf(m, "\n\n\tExtra Channels: %zu ",
+				seq_printf(m, "\n\n\tExtra Channels: %lu ",
 					   ses->chan_count-1);
 				for (j = 1; j < ses->chan_count; j++)
 					cifs_dump_channel(m, j, &ses->chans[j]);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 2ffcb29d5c8f..c4baccc14fde 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -684,7 +684,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	}
 
 	if (tcon->ses->chan_max > 1)
-		seq_printf(s, ",multichannel,max_channels=%zu",
+		seq_printf(s, ",multichannel,max_channels=%lu",
 			   tcon->ses->chan_max);
 
 	if (tcon->use_witness)
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8fea2ddd2bd7..96499fc70c82 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -955,8 +955,8 @@ struct cifs_ses {
 	test_bit((index), &(ses)->chans_need_reconnect)
 
 	struct cifs_chan chans[CIFS_MAX_CHANNELS];
-	size_t chan_count;
-	size_t chan_max;
+	unsigned long chan_count;
+	unsigned long chan_max;
 	atomic_t chan_seq; /* round robin state */
 	/*
 	 * chans_need_reconnect is a bitmap indicating which of the channels
@@ -968,7 +968,7 @@ struct cifs_ses {
 	 * enable the sessions on top to continue to live till any
 	 * of the channels below are active.
 	 */
-	size_t chans_need_reconnect;
+	unsigned long chans_need_reconnect;
 };
 
 static inline bool
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 1721a3b24694..9eded8151ae7 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -94,7 +94,7 @@ void
 cifs_chan_set_need_reconnect(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server)
 {
-	size_t chan_index = cifs_ses_get_chan_index(ses, server);
+	unsigned long chan_index = cifs_ses_get_chan_index(ses, server);
 	set_bit(chan_index, &ses->chans_need_reconnect);
 	cifs_dbg(FYI, "Set reconnect bitmask for chan %lu; now 0x%lx\n",
 		 chan_index, ses->chans_need_reconnect);
@@ -104,7 +104,7 @@ void
 cifs_chan_clear_need_reconnect(struct cifs_ses *ses,
 			       struct TCP_Server_Info *server)
 {
-	size_t chan_index = cifs_ses_get_chan_index(ses, server);
+	unsigned long chan_index = cifs_ses_get_chan_index(ses, server);
 	clear_bit(chan_index, &ses->chans_need_reconnect);
 	cifs_dbg(FYI, "Cleared reconnect bitmask for chan %lu; now 0x%lx\n",
 		 chan_index, ses->chans_need_reconnect);
@@ -131,7 +131,7 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 
 	if (left <= 0) {
 		cifs_dbg(FYI,
-			 "ses already at max_channels (%zu), nothing to open\n",
+			 "ses already at max_channels (%lu), nothing to open\n",
 			 ses->chan_max);
 		return 0;
 	}
-- 
2.26.2

