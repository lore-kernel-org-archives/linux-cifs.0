Return-Path: <SRS0=EeRJ=6F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B07C38A30
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 02:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F136120781
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 02:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="sCW72eAj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgDUCpA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Apr 2020 22:45:00 -0400
Received: from mx.cjr.nz ([51.158.111.142]:24964 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDUCpA (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Apr 2020 22:45:00 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id E9A64804DB;
        Tue, 21 Apr 2020 02:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1587437097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PB4D2YZUXg6bRWALe1gIDQEGUUUlWY4mOm1By1qVI3U=;
        b=sCW72eAj9X+vgmhOfwqOkWMNl1zQ64GHHX9+jq1uPp8aCi91zFN77mMIeM+0Mn5CPnHFbR
        6WNZIK0hdjF+ApjewlxxYgtq+Drgrca0O+HpM8XYpMfmJfprKlGHS8/CuvruyDfb627l3Y
        jHb5Dimpjt4MGVYvZqIyIf+BdNV83JVb5o9OY9iLo8+ogGyPSPZSQ5sMGKwMXsSnek+2k/
        /Uxhtra7lWfqe7Mfm4nQo0XAGSX+ea3U+cHWfTTILCxwHoLcYIT6O1C3YhoB5yF8Yl3+L/
        +bz0501ZpzqDb3yBdpYLLLEURl2ClaSADenMkc4f+xcvMrIEjXxV7SxmxT2wGA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        samba-technical@lists.samba.org
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 2/3] cifs: ensure correct super block for DFS reconnect
Date:   Mon, 20 Apr 2020 23:44:23 -0300
Message-Id: <20200421024424.3112-2-pc@cjr.nz>
In-Reply-To: <20200421024424.3112-1-pc@cjr.nz>
References: <20200421024424.3112-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We could not rely on TCP server pointer to determine which super block
to update the prefix path when reconnecting tcons since it might map
to different tcons that share same TCP connection.

Instead, walk through all cifs super blocks and compare their DFS full
paths with the tcon being updated to.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/misc.c | 71 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 54 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index a456febd4109..2d111b5a670c 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1025,51 +1025,88 @@ int copy_path_name(char *dst, const char *src)
 }
 
 struct super_cb_data {
-	struct TCP_Server_Info *server;
+	void *data;
 	struct super_block *sb;
 };
 
-static void super_cb(struct super_block *sb, void *arg)
+static void tcp_super_cb(struct super_block *sb, void *arg)
 {
-	struct super_cb_data *d = arg;
+	struct super_cb_data *sd = arg;
+	struct TCP_Server_Info *server = sd->data;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
 
-	if (d->sb)
+	if (sd->sb)
 		return;
 
 	cifs_sb = CIFS_SB(sb);
 	tcon = cifs_sb_master_tcon(cifs_sb);
-	if (tcon->ses->server == d->server)
-		d->sb = sb;
+	if (tcon->ses->server == server)
+		sd->sb = sb;
 }
 
-struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server)
+static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void *),
+					    void *data)
 {
-	struct super_cb_data d = {
-		.server = server,
+	struct super_cb_data sd = {
+		.data = data,
 		.sb = NULL,
 	};
 
-	iterate_supers_type(&cifs_fs_type, super_cb, &d);
+	iterate_supers_type(&cifs_fs_type, f, &sd);
 
-	if (unlikely(!d.sb))
-		return ERR_PTR(-ENOENT);
+	if (!sd.sb)
+		return ERR_PTR(-EINVAL);
 	/*
 	 * Grab an active reference in order to prevent automounts (DFS links)
 	 * of expiring and then freeing up our cifs superblock pointer while
 	 * we're doing failover.
 	 */
-	cifs_sb_active(d.sb);
-	return d.sb;
+	cifs_sb_active(sd.sb);
+	return sd.sb;
 }
 
-void cifs_put_tcp_super(struct super_block *sb)
+static void __cifs_put_super(struct super_block *sb)
 {
 	if (!IS_ERR_OR_NULL(sb))
 		cifs_sb_deactive(sb);
 }
 
+struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server)
+{
+	return __cifs_get_super(tcp_super_cb, server);
+}
+
+void cifs_put_tcp_super(struct super_block *sb)
+{
+	__cifs_put_super(sb);
+}
+
+static void tcon_super_cb(struct super_block *sb, void *arg)
+{
+	struct super_cb_data *sd = arg;
+	struct cifs_tcon *tcon = sd->data;
+	struct cifs_sb_info *cifs_sb;
+
+	if (sd->sb)
+		return;
+
+	cifs_sb = CIFS_SB(sb);
+	if (tcon->dfs_path && cifs_sb->origin_fullpath &&
+	    !strcasecmp(tcon->dfs_path, cifs_sb->origin_fullpath))
+		sd->sb = sb;
+}
+
+static inline struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon)
+{
+	return __cifs_get_super(tcon_super_cb, tcon);
+}
+
+static inline void cifs_put_tcon_super(struct super_block *sb)
+{
+	__cifs_put_super(sb);
+}
+
 int update_super_prepath(struct cifs_tcon *tcon, const char *prefix,
 			 size_t prefix_len)
 {
@@ -1077,7 +1114,7 @@ int update_super_prepath(struct cifs_tcon *tcon, const char *prefix,
 	struct cifs_sb_info *cifs_sb;
 	int rc = 0;
 
-	sb = cifs_get_tcp_super(tcon->ses->server);
+	sb = cifs_get_tcon_super(tcon);
 	if (IS_ERR(sb))
 		return PTR_ERR(sb);
 
@@ -1099,6 +1136,6 @@ int update_super_prepath(struct cifs_tcon *tcon, const char *prefix,
 	cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 
 out:
-	cifs_put_tcp_super(sb);
+	cifs_put_tcon_super(sb);
 	return rc;
 }
-- 
2.26.0

