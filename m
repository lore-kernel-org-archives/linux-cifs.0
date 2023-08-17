Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB49C3065C
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347286AbjHQPgO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352650AbjHQPfr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:47 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BBA30C5
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:46 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j2C3J9Tk0XRUlrb5yZy7WpiLI7CrUDLjmpi4rmr4xPI=;
        b=DJPvTKNwtno4B6i0+qgZvFwDmC/63tYPzPXyVX3xHB+cmpbZiYbtLP0+8twelxc4f4Ab1p
        +5zqeaqvlN2yf8mlt3VbmcJJkWEIQxoKdFERakstm56LcDqQl3Hkyx4D4p6J5uIrJfWsSr
        iiQv849wxh7ocTExscu4zUdAfSwQpJymWizB94HXQyPMVLH6zVVcIDuZ9CwpZnSWqDPCCM
        opor6+QrQ3ffnnC4mVM8h87OMzXVQll+opkwudL++usE/IaQWb88Y0Z/irC/tWMbgy+T46
        7C7dV0tGqrHFzg4VPMoabO0HbpPgB5nNo09hT1pALiZlalDgVZQCmJ0DbD8ICA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j2C3J9Tk0XRUlrb5yZy7WpiLI7CrUDLjmpi4rmr4xPI=;
        b=BOQKOaB0r8h3vF1fQhupDzdMI9dTAoecoycy+ntCLhcedmDtbfqMBp+gATeo1RKEQMEunp
        yCIH5lZougHo811Q+5s4aNkKOTAhn3Xc0mdJ1yj8qG0EFLpFsi/864L3ZSaXKMWnxVeqdb
        d+AqvrtoCc4Cr5UOA254icag8+AL6ok8ktkHsiWNiq9uHxQOMYt/Wz9hS3mCHoxvqfGNLY
        OO9FLMBmkMvDUYMJoz+/7yNOmIQ1gSKbhURgCIM5oxyumQQuGoR17sKEHKzZfpUyXZXnIz
        5FPU2blrWgocMtvhuNVOCtD+hmpBg09L50YlHxoeZm9lVRlekVPHjtu8mR0wUA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286544; a=rsa-sha256;
        cv=none;
        b=NIa1vJRTOn+sD2URC6aaccUsSlOCOWvxjvNVPKgnUxBLhJyYdelQRI4UrnxxK/v+5ff699
        AO2pTBKOXdQ/HOoP12t0d1glEmbuaEKM2nSZXxtUqtTyEUUOVFyrfc30bdP90hhfremdIo
        geWToSQEYxEowq4qJHTdBhXu6U6VzEf4zfPppXEAJ7/XkX/n7e9K1oTL02kRNIRzT0Y5U4
        6OdlaUfmrG7fsnMe0cbDBsDkHez1uPkR6RFUQpkkk/iOeZIbwqycHCodXLiJ65/TZ2rZ98
        4Z0KZUxc4QfmCPh6gSRUW9PPFwku2F3JcI92qZ58SH7mVLItzKyQS1bWq7SLVg==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 12/17] smb: client: reduce stack usage in cifs_try_adding_channels()
Date:   Thu, 17 Aug 2023 12:34:10 -0300
Message-ID: <20230817153416.28083-13-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Clang warns about exceeded stack frame size

  fs/smb/client/sess.c:160:5: warning: stack frame size (1368) exceeds
  limit (1024) in 'cifs_try_adding_channels' [-Wframe-larger-than]

It turns out that cifs_ses_add_channel() got inlined into
cifs_try_adding_channels() which had a stack-allocated variable @ctx
of 624 bytes in size.  Fix this by making it heap-allocated.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202307270640.5ODmPwDl-lkp@intel.com/
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/sess.c | 68 ++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index c57ca2050b73..5292216d9947 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -360,11 +360,11 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 {
 	struct TCP_Server_Info *chan_server;
 	struct cifs_chan *chan;
-	struct smb3_fs_context ctx = {NULL};
+	struct smb3_fs_context *ctx;
 	static const char unc_fmt[] = "\\%s\\foo";
-	char unc[sizeof(unc_fmt)+SERVER_NAME_LEN_WITH_NULL] = {0};
 	struct sockaddr_in *ipv4 = (struct sockaddr_in *)&iface->sockaddr;
 	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&iface->sockaddr;
+	size_t len;
 	int rc;
 	unsigned int xid = get_xid();
 
@@ -388,54 +388,64 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	 * the session and server without caring about memory
 	 * management.
 	 */
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		rc = -ENOMEM;
+		goto out_free_xid;
+	}
 
 	/* Always make new connection for now (TODO?) */
-	ctx.nosharesock = true;
+	ctx->nosharesock = true;
 
 	/* Auth */
-	ctx.domainauto = ses->domainAuto;
-	ctx.domainname = ses->domainName;
+	ctx->domainauto = ses->domainAuto;
+	ctx->domainname = ses->domainName;
 
 	/* no hostname for extra channels */
-	ctx.server_hostname = "";
+	ctx->server_hostname = "";
 
-	ctx.username = ses->user_name;
-	ctx.password = ses->password;
-	ctx.sectype = ses->sectype;
-	ctx.sign = ses->sign;
+	ctx->username = ses->user_name;
+	ctx->password = ses->password;
+	ctx->sectype = ses->sectype;
+	ctx->sign = ses->sign;
 
 	/* UNC and paths */
 	/* XXX: Use ses->server->hostname? */
-	sprintf(unc, unc_fmt, ses->ip_addr);
-	ctx.UNC = unc;
-	ctx.prepath = "";
+	len = sizeof(unc_fmt) + SERVER_NAME_LEN_WITH_NULL;
+	ctx->UNC = kzalloc(len, GFP_KERNEL);
+	if (!ctx->UNC) {
+		rc = -ENOMEM;
+		goto out_free_ctx;
+	}
+	scnprintf(ctx->UNC, len, unc_fmt, ses->ip_addr);
+	ctx->prepath = "";
 
 	/* Reuse same version as master connection */
-	ctx.vals = ses->server->vals;
-	ctx.ops = ses->server->ops;
+	ctx->vals = ses->server->vals;
+	ctx->ops = ses->server->ops;
 
-	ctx.noblocksnd = ses->server->noblocksnd;
-	ctx.noautotune = ses->server->noautotune;
-	ctx.sockopt_tcp_nodelay = ses->server->tcp_nodelay;
-	ctx.echo_interval = ses->server->echo_interval / HZ;
-	ctx.max_credits = ses->server->max_credits;
+	ctx->noblocksnd = ses->server->noblocksnd;
+	ctx->noautotune = ses->server->noautotune;
+	ctx->sockopt_tcp_nodelay = ses->server->tcp_nodelay;
+	ctx->echo_interval = ses->server->echo_interval / HZ;
+	ctx->max_credits = ses->server->max_credits;
 
 	/*
 	 * This will be used for encoding/decoding user/domain/pw
 	 * during sess setup auth.
 	 */
-	ctx.local_nls = cifs_sb->local_nls;
+	ctx->local_nls = cifs_sb->local_nls;
 
 	/* Use RDMA if possible */
-	ctx.rdma = iface->rdma_capable;
-	memcpy(&ctx.dstaddr, &iface->sockaddr, sizeof(struct sockaddr_storage));
+	ctx->rdma = iface->rdma_capable;
+	memcpy(&ctx->dstaddr, &iface->sockaddr, sizeof(ctx->dstaddr));
 
 	/* reuse master con client guid */
-	memcpy(&ctx.client_guid, ses->server->client_guid,
-	       SMB2_CLIENT_GUID_SIZE);
-	ctx.use_client_guid = true;
+	memcpy(&ctx->client_guid, ses->server->client_guid,
+	       sizeof(ctx->client_guid));
+	ctx->use_client_guid = true;
 
-	chan_server = cifs_get_tcp_session(&ctx, ses->server);
+	chan_server = cifs_get_tcp_session(ctx, ses->server);
 
 	spin_lock(&ses->chan_lock);
 	chan = &ses->chans[ses->chan_count];
@@ -497,6 +507,10 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 		cifs_put_tcp_session(chan->server, 0);
 	}
 
+	kfree(ctx->UNC);
+out_free_ctx:
+	kfree(ctx);
+out_free_xid:
 	free_xid(xid);
 	return rc;
 }
-- 
2.41.0

