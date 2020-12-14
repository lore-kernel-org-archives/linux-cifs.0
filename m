Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23CEDC2BBCA
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E297F22583
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438788AbgLNGmV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 01:42:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40898 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438782AbgLNGmU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Dec 2020 01:42:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607928054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=6c1wZGRFleIGfB616jwlOkmmA1TncgI+I0JERE4mVTA=;
        b=OuFeHC91/8axkQoIN5OF/omZ5BwseYIoc5xFDDzGajQcEgLVLISD0kRJr6TDm1U7F0JeKT
        Bt465wA4uAzL7mfHX8WW7HJU4o0c3fV9Dpl4/BRAH/5I/7PJMFk4jgN4DAI0lunKiBIYYB
        x59hVX3KlpVFnTvvhTIgl3enVa7MLxQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-PfCu4FyMNZCtSekST6Y98A-1; Mon, 14 Dec 2020 01:40:50 -0500
X-MC-Unique: PfCu4FyMNZCtSekST6Y98A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36A7359;
        Mon, 14 Dec 2020 06:40:49 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F72B10023AD;
        Mon, 14 Dec 2020 06:40:48 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 07/12] cifs: uncomplicate printing the iocharset parameter
Date:   Mon, 14 Dec 2020 16:40:22 +1000
Message-Id: <20201214064027.2885-7-lsahlber@redhat.com>
In-Reply-To: <20201214064027.2885-1-lsahlber@redhat.com>
References: <20201214064027.2885-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There is no need to load the default nls to check if the iocharset argument
was specified or not since we have it in cifs_sb->ctx

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 276b0659c238..229e5cbcaf18 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -462,18 +462,6 @@ cifs_show_cache_flavor(struct seq_file *s, struct cifs_sb_info *cifs_sb)
 		seq_puts(s, "loose");
 }
 
-static void
-cifs_show_nls(struct seq_file *s, struct nls_table *cur)
-{
-	struct nls_table *def;
-
-	/* Display iocharset= option if it's not default charset */
-	def = load_nls_default();
-	if (def != cur)
-		seq_printf(s, ",iocharset=%s", cur->charset);
-	unload_nls(def);
-}
-
 /*
  * cifs_show_options() is for displaying mount options in /proc/mounts.
  * Not all settable options are displayed but most of the important
@@ -537,9 +525,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",file_mode=0%ho,dir_mode=0%ho",
 					   cifs_sb->ctx->file_mode,
 					   cifs_sb->ctx->dir_mode);
-
-	cifs_show_nls(s, cifs_sb->local_nls);
-
+	if (cifs_sb->ctx->iocharset)
+		seq_printf(s, ",iocharset=%s", cifs_sb->ctx->iocharset);
 	if (tcon->seal)
 		seq_puts(s, ",seal");
 	else if (tcon->ses->server->ignore_signature)
-- 
2.13.6

