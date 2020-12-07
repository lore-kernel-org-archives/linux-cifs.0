Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEFAC4361B
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D3B923998
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgLGXjo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:39:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbgLGXjo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:39:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=FuiM3qOcXcyuoEQW3DewXIRv3zUPKL530abqvA+g5mI=;
        b=g73iq9WvDhJWiXkR0COp2qKZiJfP4iTeFEiyOQ9HfxWsMPdRi4m7ejmmsBFnc4UTxXkO9d
        GDWBBjiLIKl3nOCcSseHk5XXhoHhwW2A59b/Hxndh9FkaokJr23oXIG/QLbIpudn6Mi5Gi
        rED6ns46iqVeuyh4wBW5GZgCbIfgcXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-sqIM1MvaOomvJF57N6yNwQ-1; Mon, 07 Dec 2020 18:38:15 -0500
X-MC-Unique: sqIM1MvaOomvJF57N6yNwQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5344800D53;
        Mon,  7 Dec 2020 23:38:14 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC0665D9C6;
        Mon,  7 Dec 2020 23:38:13 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 15/21] cifs: simplify handling of cifs_sb/ctx->local_nls
Date:   Tue,  8 Dec 2020 09:36:40 +1000
Message-Id: <20201207233646.29823-15-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Only load/unload local_nls from cifs_sb and just make the ctx
contain a pointer to cifs_sb->ctx.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsproto.h  |  4 +---
 fs/cifs/connect.c    | 29 ++++++++++++++---------------
 fs/cifs/fs_context.c |  4 ----
 fs/cifs/fs_context.h |  2 +-
 fs/cifs/sess.c       | 23 +++++++++++------------
 5 files changed, 27 insertions(+), 35 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b04f7270e04a..2b5401e1ce20 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -598,9 +598,7 @@ extern void rqst_page_get_length(struct smb_rqst *rqst, unsigned int page,
 				unsigned int *len, unsigned int *offset);
 struct cifs_chan *
 cifs_ses_find_chan(struct cifs_ses *ses, struct TCP_Server_Info *server);
-int cifs_try_adding_channels(struct cifs_ses *ses);
-int cifs_ses_add_channel(struct cifs_ses *ses,
-				struct cifs_server_iface *iface);
+int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses);
 bool is_server_using_iface(struct TCP_Server_Info *server,
 			   struct cifs_server_iface *iface);
 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f28067696a2c..f2698090b39a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2674,7 +2674,19 @@ int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
 	cifs_dbg(FYI, "file mode: %04ho  dir mode: %04ho\n",
 		 cifs_sb->ctx->file_mode, cifs_sb->ctx->dir_mode);
 
-	cifs_sb->local_nls = ctx->local_nls;
+	/* this is needed for ASCII cp to Unicode converts */
+	if (ctx->iocharset == NULL) {
+		/* load_nls_default cannot return null */
+		cifs_sb->local_nls = load_nls_default();
+	} else {
+		cifs_sb->local_nls = load_nls(ctx->iocharset);
+		if (cifs_sb->local_nls == NULL) {
+			cifs_dbg(VFS, "CIFS mount error: iocharset %s not found\n",
+				 ctx->iocharset);
+			return -ELIBACC;
+		}
+	}
+	ctx->local_nls = cifs_sb->local_nls;
 
 	if (ctx->nodfs)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NO_DFS;
@@ -3145,19 +3157,6 @@ cifs_setup_volume_info(struct smb3_fs_context *ctx)
 		return -EINVAL;
 	}
 
-	/* this is needed for ASCII cp to Unicode converts */
-	if (ctx->iocharset == NULL) {
-		/* load_nls_default cannot return null */
-		ctx->local_nls = load_nls_default();
-	} else {
-		ctx->local_nls = load_nls(ctx->iocharset);
-		if (ctx->local_nls == NULL) {
-			cifs_dbg(VFS, "CIFS mount error: iocharset %s not found\n",
-				 ctx->iocharset);
-			return -ELIBACC;
-		}
-	}
-
 	return rc;
 }
 
@@ -3478,7 +3477,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 
 out:
 	free_xid(xid);
-	cifs_try_adding_channels(ses);
+	cifs_try_adding_channels(cifs_sb, ses);
 	return mount_setup_tlink(cifs_sb, ses, tcon);
 
 error:
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 542fa75b74aa..00bb11939837 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -302,7 +302,6 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct smb3_fs_context *ctx
 	memcpy(new_ctx, ctx, sizeof(*ctx));
 	new_ctx->prepath = NULL;
 	new_ctx->mount_options = NULL;
-	new_ctx->local_nls = NULL;
 	new_ctx->nodename = NULL;
 	new_ctx->username = NULL;
 	new_ctx->password = NULL;
@@ -1339,9 +1338,6 @@ smb3_cleanup_fs_context_contents(struct smb3_fs_context *ctx)
 	ctx->iocharset = NULL;
 	kfree(ctx->prepath);
 	ctx->prepath = NULL;
-
-	unload_nls(ctx->local_nls);
-	ctx->local_nls = NULL;
 }
 
 void
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 62f5a8d98df6..c2aadf3ad091 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -236,7 +236,7 @@ struct smb3_fs_context {
 	char *prepath;
 	struct sockaddr_storage dstaddr; /* destination address */
 	struct sockaddr_storage srcaddr; /* allow binding to a local IP */
-	struct nls_table *local_nls;
+	struct nls_table *local_nls; /* This is a copy of the pointer in cifs_sb */
 	unsigned int echo_interval; /* echo interval in secs */
 	__u64 snapshot_time; /* needed for timewarp tokens */
 	__u32 handle_timeout; /* persistent and durable handle timeout in ms */
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index b0e4bf2cd473..98feccdb1599 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -34,6 +34,10 @@
 #include "smb2proto.h"
 #include "fs_context.h"
 
+static int
+cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
+		     struct cifs_server_iface *iface);
+
 bool
 is_server_using_iface(struct TCP_Server_Info *server,
 		      struct cifs_server_iface *iface)
@@ -71,7 +75,7 @@ bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface)
 }
 
 /* returns number of channels added */
-int cifs_try_adding_channels(struct cifs_ses *ses)
+int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 {
 	int old_chan_count = ses->chan_count;
 	int left = ses->chan_max - ses->chan_count;
@@ -134,7 +138,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 			continue;
 		}
 
-		rc = cifs_ses_add_channel(ses, iface);
+		rc = cifs_ses_add_channel(cifs_sb, ses, iface);
 		if (rc) {
 			cifs_dbg(FYI, "failed to open extra channel on iface#%d rc=%d\n",
 				 i, rc);
@@ -167,8 +171,9 @@ cifs_ses_find_chan(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	return NULL;
 }
 
-int
-cifs_ses_add_channel(struct cifs_ses *ses, struct cifs_server_iface *iface)
+static int
+cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
+		     struct cifs_server_iface *iface)
 {
 	struct cifs_chan *chan;
 	struct smb3_fs_context ctx = {NULL};
@@ -229,13 +234,8 @@ cifs_ses_add_channel(struct cifs_ses *ses, struct cifs_server_iface *iface)
 	/*
 	 * This will be used for encoding/decoding user/domain/pw
 	 * during sess setup auth.
-	 *
-	 * XXX: We use the default for simplicity but the proper way
-	 * would be to use the one that ses used, which is not
-	 * stored. This might break when dealing with non-ascii
-	 * strings.
 	 */
-	ctx.local_nls = load_nls_default();
+	ctx.local_nls = cifs_sb->local_nls;
 
 	/* Use RDMA if possible */
 	ctx.rdma = iface->rdma_capable;
@@ -275,7 +275,7 @@ cifs_ses_add_channel(struct cifs_ses *ses, struct cifs_server_iface *iface)
 	if (rc)
 		goto out;
 
-	rc = cifs_setup_session(xid, ses, ctx.local_nls);
+	rc = cifs_setup_session(xid, ses, cifs_sb->local_nls);
 	if (rc)
 		goto out;
 
@@ -298,7 +298,6 @@ cifs_ses_add_channel(struct cifs_ses *ses, struct cifs_server_iface *iface)
 
 	if (rc && chan->server)
 		cifs_put_tcp_session(chan->server, 0);
-	unload_nls(ctx.local_nls);
 
 	return rc;
 }
-- 
2.13.6

