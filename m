Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 118A3C4361B
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEAC722583
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438795AbgLNGm3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 01:42:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55315 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438787AbgLNGm3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Dec 2020 01:42:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607928063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=9Na4ezo+0yInqb6WnNQqxr1kCibF77BUZS3DKApPnBw=;
        b=FQSe/asUUL9zHyG7IgCitObzFb5MTOTZUrbfb+LHqkDJBuAr15NqYsT/R9s+XKZOW2jYG7
        68OagyYENS8Qgjz0F5vXaFjzF7iOyRxwYIgloapPPEfoW9Pg9C3AuzHemp4j5FZFO3tuSj
        gu4O09aqfgjPGgRkMr4CH3L7FQZvSfo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-qj9LNeIGOj26n21j-gIUVA-1; Mon, 14 Dec 2020 01:41:01 -0500
X-MC-Unique: qj9LNeIGOj26n21j-gIUVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59B72809DC3;
        Mon, 14 Dec 2020 06:41:00 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF7D65D9D0;
        Mon, 14 Dec 2020 06:40:59 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 06/12] cifs: don't create a temp nls in cifs_setup_ipc
Date:   Mon, 14 Dec 2020 16:40:21 +1000
Message-Id: <20201214064027.2885-6-lsahlber@redhat.com>
In-Reply-To: <20201214064027.2885-1-lsahlber@redhat.com>
References: <20201214064027.2885-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

just use the one that is already available in ctx

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 62daed702e51..926a8b310366 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1464,7 +1464,6 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
 	int rc = 0, xid;
 	struct cifs_tcon *tcon;
-	struct nls_table *nls_codepage;
 	char unc[SERVER_NAME_LENGTH + sizeof("//x/IPC$")] = {0};
 	bool seal = false;
 	struct TCP_Server_Info *server = ses->server;
@@ -1489,14 +1488,11 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 
 	scnprintf(unc, sizeof(unc), "\\\\%s\\IPC$", server->hostname);
 
-	/* cannot fail */
-	nls_codepage = load_nls_default();
-
 	xid = get_xid();
 	tcon->ses = ses;
 	tcon->ipc = true;
 	tcon->seal = seal;
-	rc = server->ops->tree_connect(xid, ses, unc, tcon, nls_codepage);
+	rc = server->ops->tree_connect(xid, ses, unc, tcon, ctx->local_nls);
 	free_xid(xid);
 
 	if (rc) {
@@ -1509,7 +1505,6 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 
 	ses->tcon_ipc = tcon;
 out:
-	unload_nls(nls_codepage);
 	return rc;
 }
 
-- 
2.13.6

