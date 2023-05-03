Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40779C77B78
	for <linux-cifs@archiver.kernel.org>; Wed,  3 May 2023 22:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjECWVu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 May 2023 18:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjECWVt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 May 2023 18:21:49 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803BF86AF;
        Wed,  3 May 2023 15:21:46 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3g5IO8InvMRPr8FhO3Z+GAsFOn6xR+kM33bQtusDEGA=;
        b=XUnRbY/fejBRrAI+D9bVY5LjhQq4SESW9jNEj4FEYXdQU6LfZzVdBOSo8vyUr6ggMfym7D
        1rJZjHmtY2NDg33lZuoQTs01yHgIWWGDaD/FXmkpX5zA4NoE8NE8/Jrx1HEaV4kS+UG0Aq
        jezXKHSiEDo6mYt1tgjrfYa/JX3AtcuK0k7K4dsYJZJwLEusTebnTeD0JjVDDlYy+fZRhZ
        nPO/g0oHmLKiIPSIIsnNfZxjC958a+8L578l+Ui/Jtk9u8KAx3V7EkKDZ3Htv34QGa7tM8
        XEfPzmURoxtV+rzcGhAB+rC9Qc1QC4D7dFopbt1A0upPKTcxVZfjM1Q+jVR2Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3g5IO8InvMRPr8FhO3Z+GAsFOn6xR+kM33bQtusDEGA=;
        b=XUapIKSV1g7hpVaJTlfZZ1Tr+NaXYSqwG9wgZcFeCVxt6+O9zr8r593aD2k7q6t5JZ9/xm
        rEtqX+wl0M+j0RgQ5PMybaGypT2yQE4aTuTCaoHtFSA8EU/Y84Ii4vHBf1jF8UxVrIafNF
        IFa5H9XkS4m/v9/3z1F49+Gm73227orzDg30j9sEw6qbt+tE03j8dbvel2K7Dq+jW48TjB
        d15pvMCS3bCG197cplYXTKX24dhSBD+MHuTXrs7iOnModtHG2/3z0vAoygSKOTfYCFcOc8
        GO8RAZ6bC0aLNylkrwYQxC76ym57FZbcDUT/q79C7jtv+gcWfSaTzlI+j+E/1g==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1683152504; a=rsa-sha256;
        cv=none;
        b=HQSj3YemaLvGNBZ6h7JQX+7/2Ajkmml5OO5/quPlyBubnNvXOOvQhZhW3HsYOjpDU0HyGH
        rzl/E1rP1z1kv6esfgnyITpBMTv41XUadlHne5NcYLo/okzGM4ILwfjlJVeuEfIcEAtYJ2
        Kj2afI/y8Iygy1kCR5jrxNgKu5abCf5D1xJwpfGRbO0WGJ6I2h65qpMm02FGvMQ/WFPoXo
        fJcSms2+j2A9dJw1uNhdKspVYybtk9+/LQ29clySXhlbT6ySyniDikdIQmCdZbCTDTcHCw
        KYkDCWVnPiw8nHaBf8beCUW7KmtHj/TE8PrPOSeJ4k03IO+L0btNKCi9fd4whg==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/7] cifs: fix potential use-after-free bugs in TCP_Server_Info::hostname
Date:   Wed,  3 May 2023 19:21:12 -0300
Message-Id: <20230503222117.7609-3-pc@manguebit.com>
In-Reply-To: <20230503222117.7609-1-pc@manguebit.com>
References: <20230503222117.7609-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

TCP_Server_Info::hostname may be updated once or many times during
reconnect, so protect its access outside reconnect path as well and
then prevent any potential use-after-free bugs.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/cifs_debug.c |  7 ++++++-
 fs/cifs/cifs_debug.h | 12 ++++++------
 fs/cifs/connect.c    | 10 +++++++---
 fs/cifs/sess.c       |  7 ++++---
 4 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index e9c8c088d948..d4ed200a9471 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -280,8 +280,10 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "\n%d) ConnectionId: 0x%llx ",
 			c, server->conn_id);
 
+		spin_lock(&server->srv_lock);
 		if (server->hostname)
 			seq_printf(m, "Hostname: %s ", server->hostname);
+		spin_unlock(&server->srv_lock);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 		if (!server->rdma)
 			goto skip_rdma;
@@ -623,10 +625,13 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 				server->fastest_cmd[j],
 				server->slowest_cmd[j]);
 		for (j = 0; j < NUMBER_OF_SMB2_COMMANDS; j++)
-			if (atomic_read(&server->smb2slowcmd[j]))
+			if (atomic_read(&server->smb2slowcmd[j])) {
+				spin_lock(&server->srv_lock);
 				seq_printf(m, "  %d slow responses from %s for command %d\n",
 					atomic_read(&server->smb2slowcmd[j]),
 					server->hostname, j);
+				spin_unlock(&server->srv_lock);
+			}
 #endif /* STATS2 */
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index d44808263cfb..ce5cfd236fdb 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -81,19 +81,19 @@ do {									\
 
 #define cifs_server_dbg_func(ratefunc, type, fmt, ...)			\
 do {									\
-	const char *sn = "";						\
-	if (server && server->hostname)					\
-		sn = server->hostname;					\
+	spin_lock(&server->srv_lock);					\
 	if ((type) & FYI && cifsFYI & CIFS_INFO) {			\
 		pr_debug_ ## ratefunc("%s: \\\\%s " fmt,		\
-				      __FILE__, sn, ##__VA_ARGS__);	\
+				      __FILE__, server->hostname,	\
+				      ##__VA_ARGS__);			\
 	} else if ((type) & VFS) {					\
 		pr_err_ ## ratefunc("VFS: \\\\%s " fmt,			\
-				    sn, ##__VA_ARGS__);			\
+				    server->hostname, ##__VA_ARGS__);	\
 	} else if ((type) & NOISY && (NOISY != 0)) {			\
 		pr_debug_ ## ratefunc("\\\\%s " fmt,			\
-				      sn, ##__VA_ARGS__);		\
+				      server->hostname, ##__VA_ARGS__);	\
 	}								\
+	spin_unlock(&server->srv_lock);					\
 } while (0)
 
 #define cifs_server_dbg(type, fmt, ...)					\
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1cbb90587995..eee8b31c1eaf 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -403,8 +403,10 @@ static int __reconnect_target_unlocked(struct TCP_Server_Info *server, const cha
 		if (server->hostname != target) {
 			hostname = extract_hostname(target);
 			if (!IS_ERR(hostname)) {
+				spin_lock(&server->srv_lock);
 				kfree(server->hostname);
 				server->hostname = hostname;
+				spin_unlock(&server->srv_lock);
 			} else {
 				cifs_dbg(FYI, "%s: couldn't extract hostname or address from dfs target: %ld\n",
 					 __func__, PTR_ERR(hostname));
@@ -561,9 +563,7 @@ cifs_echo_request(struct work_struct *work)
 		goto requeue_echo;
 
 	rc = server->ops->echo ? server->ops->echo(server) : -ENOSYS;
-	if (rc)
-		cifs_dbg(FYI, "Unable to send echo request to server: %s\n",
-			 server->hostname);
+	cifs_server_dbg(FYI, "send echo request: rc = %d\n", rc);
 
 	/* Check witness registrations */
 	cifs_swn_check();
@@ -1404,6 +1404,8 @@ static int match_server(struct TCP_Server_Info *server, struct smb3_fs_context *
 {
 	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
 
+	lockdep_assert_held(&server->srv_lock);
+
 	if (ctx->nosharesock)
 		return 0;
 
@@ -1810,7 +1812,9 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	if (tcon == NULL)
 		return -ENOMEM;
 
+	spin_lock(&server->srv_lock);
 	scnprintf(unc, sizeof(unc), "\\\\%s\\IPC$", server->hostname);
+	spin_unlock(&server->srv_lock);
 
 	xid = get_xid();
 	tcon->ses = ses;
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index d2cbae4b5d21..335c078c42fb 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -159,6 +159,7 @@ cifs_chan_is_iface_active(struct cifs_ses *ses,
 /* returns number of channels added */
 int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 {
+	struct TCP_Server_Info *server = ses->server;
 	int old_chan_count, new_chan_count;
 	int left;
 	int rc = 0;
@@ -178,16 +179,16 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 		return 0;
 	}
 
-	if (ses->server->dialect < SMB30_PROT_ID) {
+	if (server->dialect < SMB30_PROT_ID) {
 		spin_unlock(&ses->chan_lock);
 		cifs_dbg(VFS, "multichannel is not supported on this protocol version, use 3.0 or above\n");
 		return 0;
 	}
 
-	if (!(ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+	if (!(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
 		ses->chan_max = 1;
 		spin_unlock(&ses->chan_lock);
-		cifs_dbg(VFS, "server %s does not support multichannel\n", ses->server->hostname);
+		cifs_server_dbg(VFS, "no multichannel support\n");
 		return 0;
 	}
 	spin_unlock(&ses->chan_lock);
-- 
2.40.1

