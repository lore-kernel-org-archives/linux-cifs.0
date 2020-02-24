Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7F4C11D30
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2225220838
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:16:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XWn/MOFA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgBXNQG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:16:06 -0500
Received: from hr2.samba.org ([144.76.82.148]:41990 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgBXNQG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:16:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=wz2i4n06xpk+qwPJN99A2IQ6KfMt9t/j6E6OSC5GUiE=; b=XWn/MOFAE806DfS0tLKXZtT3ez
        v4YgtdMWwLe6nu3acqmfv4eF4S+JykoHeiv9XyNoVYm4VnYMJes6yMBB9AwRLiLogbT0uaneKR6k9
        V3wkaiROzWd4HzTmwL/AqA4d2b3ZFwhLk0kV3yKfPixMCZeai6Kci1R45ICIr/YvPm22jHH2/kXu4
        MZA/c/qwDWwR0DeMLdz+gR/gB0vWOKf603OORsw9NJjZM9sZbMgM64c15wbWgK34xu82wUbAyKOfN
        uSa0po2y4zlFjKFiXCCqrcjeQK+CRgBhfUkmrrhucLZiXBqYlvoQauFQySWaMCY4EwyQu3d+/x7yI
        liDHngj36x1BeLoxVakydgmCOkVdtEbJQz5cW1BqWtp+wA55k1YHT6AY0dUTftBe/i6x/XcINTA0m
        vXd+HjO1zuOgIJ92wS7ZlxiJqGFUKMuGUZff/TKPq52NJ+IcFh/w3zYT0jN0SSBkA3cpovAjbNdHb
        6APyhD5jZTlbqxHQ/2/94JzC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaR-00061e-Gf; Mon, 24 Feb 2020 13:15:51 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 08/13] cifs: make cifs_tree_connect() static
Date:   Mon, 24 Feb 2020 14:15:05 +0100
Message-Id: <20200224131510.20608-9-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/cifsproto.h |  3 ---
 fs/cifs/connect.c   | 12 ++++++------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 64f13affdb15..a99e3977645f 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -263,9 +263,6 @@ extern void cifs_move_llist(struct list_head *source, struct list_head *dest);
 extern void cifs_free_llist(struct list_head *llist);
 extern void cifs_del_lock_waiters(struct cifsLockInfo *lock);
 
-extern int cifs_tree_connect(const unsigned int xid,
-			     struct cifs_tcon *tcon,
-			     const struct nls_table *nlsc);
 extern int cifs_connect_session_locked(const unsigned int xid,
 				       struct cifs_ses *ses,
 				       struct nls_table *nls_info,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e920335384d7..fc430ba99571 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5291,9 +5291,9 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 }
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
-int cifs_tree_connect(const unsigned int xid,
-		      struct cifs_tcon *tcon,
-		      const struct nls_table *nlsc)
+static int cifs_tree_connect(const unsigned int xid,
+			     struct cifs_tcon *tcon,
+			     const struct nls_table *nlsc)
 {
 	const struct smb_version_operations *ops = tcon->ses->server->ops;
 	int rc;
@@ -5365,9 +5365,9 @@ int cifs_tree_connect(const unsigned int xid,
 	return rc;
 }
 #else
-int cifs_tree_connect(const unsigned int xid,
-		      struct cifs_tcon *tcon,
-		      const struct nls_table *nlsc)
+static int cifs_tree_connect(const unsigned int xid,
+			     struct cifs_tcon *tcon,
+			     const struct nls_table *nlsc)
 {
 	const struct smb_version_operations *ops = tcon->ses->server->ops;
 	return ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, nlsc);
-- 
2.17.1

