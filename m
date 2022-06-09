Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FF4C43334
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 22:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344955AbiFIWoj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 18:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242329AbiFIWoi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 18:44:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F27E1B587B
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 15:44:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1745B220C7;
        Thu,  9 Jun 2022 22:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654814675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=F8vuIGPU/7MehW9wLqTE/QEmYFUjGTgkeNHWEPAgp1g=;
        b=PT82M6W0pStfllgRJv1wlLfNcMmHFe8AqSJOmTGhaUmkJxLPKybLesy8vgUttJMIGbg5W6
        9dJ9+HINRFnxpJPcPLVJRqUxtJ6+FZGA2d3KXegnqJ9PekiQGPAk8TNk/sy0qrZYBYmnGH
        DYbKpc0GS706wYv8kMntUogE0qyFQew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654814675;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=F8vuIGPU/7MehW9wLqTE/QEmYFUjGTgkeNHWEPAgp1g=;
        b=iV1c+uL/XdOjOl1PWMxPsZ9OkE4b76y7mUC4ckhyXliRKkfao7dElTA4ZSrAADTZDFVVTj
        4fDtGEK1e6hdQeCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 89F2313456;
        Thu,  9 Jun 2022 22:44:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RsXXEtJ3omLOHwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 09 Jun 2022 22:44:34 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] cifs: introduce dns_interval mount option
Date:   Thu,  9 Jun 2022 19:43:42 -0300
Message-Id: <20220609224342.892-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch introduces a `dns_interval' mount option, used to configure
the interval that the DNS resolve worker should be run.

Enforces the minimum value SMB_DNS_RESOLVE_INTERVAL_MIN (currently 120s),
or uses the default SMB_DNS_RESOLVE_INTERVAL_DEFAULT (currently 600s).

Since this is a mount option, each derived connection from it, e.g. DFS
root targets, will share the same DNS interval from the primary server
since the TCP session options are passed down to them.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsfs.c     |  3 +++
 fs/cifs/cifsglob.h   |  1 +
 fs/cifs/connect.c    | 20 ++++++++++++++------
 fs/cifs/fs_context.c | 11 +++++++++++
 fs/cifs/fs_context.h |  2 ++
 fs/cifs/sess.c       |  1 +
 6 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 325423180fd2..ad980b235699 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -665,6 +665,9 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	if (tcon->ses->server->max_credits != SMB2_MAX_CREDITS_AVAILABLE)
 		seq_printf(s, ",max_credits=%u", tcon->ses->server->max_credits);
 
+	if (tcon->ses->server->dns_interval != SMB_DNS_RESOLVE_INTERVAL_DEFAULT)
+		seq_printf(s, ",dns_interval=%u", tcon->ses->server->dns_interval);
+
 	if (tcon->snapshot_time)
 		seq_printf(s, ",snapshot=%llu", tcon->snapshot_time);
 	if (tcon->handle_timeout)
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f873379066c7..e28a23b617ef 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -679,6 +679,7 @@ struct TCP_Server_Info {
 	struct smbd_connection *smbd_conn;
 	struct delayed_work	echo; /* echo ping workqueue job */
 	struct delayed_work	resolve; /* dns resolution workqueue job */
+	unsigned int dns_interval; /* interval for resolve worker */
 	char	*smallbuf;	/* pointer to current "small" buffer */
 	char	*bigbuf;	/* pointer to current "big" buffer */
 	/* Total size of this PDU. Only valid from cifs_demultiplex_thread */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 06bafba9c3ff..e6bedced576a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -92,7 +92,7 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 	int len;
 	char *unc, *ipaddr = NULL;
 	time64_t expiry, now;
-	unsigned long ttl = SMB_DNS_RESOLVE_INTERVAL_DEFAULT;
+	unsigned int ttl = server->dns_interval;
 
 	if (!server->hostname ||
 	    server->hostname[0] == '\0')
@@ -129,13 +129,15 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 			/*
 			 * To make sure we don't use the cached entry, retry 1s
 			 * after expiry.
+			 *
+			 * dns_interval is guaranteed to be >= SMB_DNS_RESOLVE_INTERVAL_MIN
 			 */
-			ttl = max_t(unsigned long, expiry - now, SMB_DNS_RESOLVE_INTERVAL_MIN) + 1;
+			ttl = max_t(unsigned long, expiry - now, server->dns_interval) + 1;
 	}
 	rc = !rc ? -1 : 0;
 
 requeue_resolve:
-	cifs_dbg(FYI, "%s: next dns resolution scheduled for %lu seconds in the future\n",
+	cifs_dbg(FYI, "%s: next dns resolution scheduled for %u seconds in the future\n",
 		 __func__, ttl);
 	mod_delayed_work(cifsiod_wq, &server->resolve, (ttl * HZ));
 
@@ -1608,6 +1610,12 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 		tcp_ses->echo_interval = ctx->echo_interval * HZ;
 	else
 		tcp_ses->echo_interval = SMB_ECHO_INTERVAL_DEFAULT * HZ;
+
+	if (ctx->dns_interval >= SMB_DNS_RESOLVE_INTERVAL_MIN)
+		tcp_ses->dns_interval = ctx->dns_interval;
+	else
+		tcp_ses->dns_interval = SMB_DNS_RESOLVE_INTERVAL_DEFAULT;
+
 	if (tcp_ses->rdma) {
 #ifndef CONFIG_CIFS_SMB_DIRECT
 		cifs_dbg(VFS, "CONFIG_CIFS_SMB_DIRECT is not enabled\n");
@@ -1670,10 +1678,10 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
 
 	/* queue dns resolution delayed work */
-	cifs_dbg(FYI, "%s: next dns resolution scheduled for %d seconds in the future\n",
-		 __func__, SMB_DNS_RESOLVE_INTERVAL_DEFAULT);
+	cifs_dbg(FYI, "%s: next dns resolution scheduled for %u seconds in the future\n",
+		 __func__, tcp_ses->dns_interval);
 
-	queue_delayed_work(cifsiod_wq, &tcp_ses->resolve, (SMB_DNS_RESOLVE_INTERVAL_DEFAULT * HZ));
+	queue_delayed_work(cifsiod_wq, &tcp_ses->resolve, (tcp_ses->dns_interval * HZ));
 
 	return tcp_ses;
 
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 8dc0d923ef6a..91b3424ba722 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -152,6 +152,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_u32("handletimeout", Opt_handletimeout),
 	fsparam_u64("snapshot", Opt_snapshot),
 	fsparam_u32("max_channels", Opt_max_channels),
+	fsparam_u32("dns_interval", Opt_dns_interval),
 
 	/* Mount options which take string value */
 	fsparam_string("source", Opt_source),
@@ -1099,6 +1100,14 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		if (result.uint_32 > 1)
 			ctx->multichannel = true;
 		break;
+	case Opt_dns_interval:
+		if (result.uint_32 < SMB_DNS_RESOLVE_INTERVAL_MIN) {
+			cifs_errorf(fc, "%s: Minimum value for dns_interval is %u\n",
+					__func__, SMB_DNS_RESOLVE_INTERVAL_MIN);
+			goto cifs_parse_mount_err;
+		}
+		ctx->dns_interval = result.uint_32;
+		break;
 	case Opt_handletimeout:
 		ctx->handle_timeout = result.uint_32;
 		if (ctx->handle_timeout > SMB3_MAX_HANDLE_TIMEOUT) {
@@ -1535,6 +1544,8 @@ int smb3_init_fs_context(struct fs_context *fc)
 	ctx->multichannel = false;
 	ctx->max_channels = 1;
 
+	ctx->dns_interval = SMB_DNS_RESOLVE_INTERVAL_DEFAULT;
+
 	ctx->backupuid_specified = false; /* no backup intent for a user */
 	ctx->backupgid_specified = false; /* no backup intent for a group */
 
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 5f093cb7e9b9..567a2dde6333 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -130,6 +130,7 @@ enum cifs_param {
 	Opt_snapshot,
 	Opt_max_channels,
 	Opt_handletimeout,
+	Opt_dns_interval,
 
 	/* Mount options which take string value */
 	Opt_source,
@@ -258,6 +259,7 @@ struct smb3_fs_context {
 	__u32 handle_timeout; /* persistent and durable handle timeout in ms */
 	unsigned int max_credits; /* smb3 max_credits 10 < credits < 60000 */
 	unsigned int max_channels;
+	unsigned int dns_interval; /* interval to resolve server hostname */
 	__u16 compression; /* compression algorithm 0xFFFF default 0=disabled */
 	bool rootfs:1; /* if it's a SMB root file system */
 	bool witness:1; /* use witness protocol */
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 0bece97547d4..d3dad612e2a4 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -325,6 +325,7 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	ctx.sockopt_tcp_nodelay = ses->server->tcp_nodelay;
 	ctx.echo_interval = ses->server->echo_interval / HZ;
 	ctx.max_credits = ses->server->max_credits;
+	ctx.dns_interval = ses->server->dns_interval;
 
 	/*
 	 * This will be used for encoding/decoding user/domain/pw
-- 
2.36.1

