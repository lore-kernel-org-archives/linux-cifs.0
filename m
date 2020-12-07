Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37C5C433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 727C923A31
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgLGXlH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:41:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbgLGXlH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:41:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=o68Ji6IHDk7qd5dmVNZISyxgP5ecsMzTMXsRnJTHmXs=;
        b=YdbRXYkjkpb7cXL9ibB51sK9Od2W2fCJuszkE1bebyB6o1/Eny5EaBQkmCemwC8klj7yqM
        giH54jM0bTiIsLxh8L/skSHJCv1B0SerJh4FNjUkq1pZrIR7uj8wJVJr5NXgGalXB1o9PS
        PyJ5fIVydkp5t4BeayA7MKxrXG7Ja+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-tgUCgmOPMiKDhPf8UuGURg-1; Mon, 07 Dec 2020 18:39:39 -0500
X-MC-Unique: tgUCgmOPMiKDhPf8UuGURg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72028427C7;
        Mon,  7 Dec 2020 23:39:38 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6ACD5C1A1;
        Mon,  7 Dec 2020 23:39:37 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 17/21] cifs: uncomplicate printing the iocharset parameter
Date:   Tue,  8 Dec 2020 09:36:42 +1000
Message-Id: <20201207233646.29823-17-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index 13d7f4a3c836..57c61a2bcf73 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -459,18 +459,6 @@ cifs_show_cache_flavor(struct seq_file *s, struct cifs_sb_info *cifs_sb)
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
@@ -534,9 +522,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
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

