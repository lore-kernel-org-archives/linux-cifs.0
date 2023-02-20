Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8E2C6379F
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Feb 2023 19:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbjBTThU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Feb 2023 14:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjBTThU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Feb 2023 14:37:20 -0500
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3DC18147
        for <linux-cifs@vger.kernel.org>; Mon, 20 Feb 2023 11:37:18 -0800 (PST)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1676921835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FJW/v45QOHnqoJiMU0v/bgvyvM0ggN9HCtbufXqV4/0=;
        b=NtD8fG5BsyfDbekuAZGlg6PXZSBoRgSWx4PHYab1e9Vp7FMjdTxYIj5rZEHohEdRd1HOrF
        e97vRU0zi6Ef2JkPW7FJSxIyaKSNsuirVh7CySMYqSsDBWG7C0rQMtZPbP0SUjMCnORYBD
        WVfJ6CsPFj7oWNygNaQ2fqT1x+oxMmLoMN/G5XjP8ggct38air5X8FqmMyIl4lpakP+lac
        jAAQPZaX77aq5x9AhjYPfFZtR9emYjag6jWJ2v5zu6di/bSzuRImG+Me6+f6HB52nY8pbP
        gWKdvn747k1KdUkpiL+7gxUYdN1Jllb+XtxHcmxZZOHSOnGKxb9Gwnk3Z1jrfA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1676921835; a=rsa-sha256;
        cv=none;
        b=nqhfFhQ1BuCBGdJe0c7bU6wtNCMEbi1hlzLJejzHAxnLy4SXURzIQqh2c7DBqKQVFiSgML
        3BDifAe7nyuY2XPWUN7KhUpCpfc8t8axRWu2xd2gDIir6aPHDL+u77ssNeBUxT2yTwTdp2
        TN+Fc1UFAM2gvlUAbYuieaohV8q9iUPNwK9cCIJXMpjG+KDrX/+D5RV4cRKatirvgltVbU
        R+x72T9e940KBY8TDlmmgc0N4gYkCtBN9hOFJBS98O5kt2axK3kKdZ4OIX2WdOoGuW+2u9
        /n0MXVNTUK9WzL6LAXew0o9uVzAqvfBFQucXqTCWbYg65H2QtSAAhtIUYwRioA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1676921835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FJW/v45QOHnqoJiMU0v/bgvyvM0ggN9HCtbufXqV4/0=;
        b=DiWXSFGhL2LzzuRVRnoW84xvdLsjUK0UDPIdd0oQOArm1CHb/M+pxzZ42sprcLGXQ06qbk
        79jY4bjEhXPLmzBTLneRrPAU0sJgTzQ0F2JG4h8DZ45DUjRYynkEOpinTUiVCnfZhhOzoQ
        PNHPZPDGu6W9lN7Ld+rVa8ZbPwAXxEVUk6WrRCQsTyi4p/ea1cbAmff3Br3UEff7auZ1Az
        dIEc79p6XReHaqpi9G/++p+vXMsU6t3ZwjUFvW0zmzLNfhbwOt1Z/x1QUAN3bbONxMrZLk
        +zC2QWiB092GkkTKG69tz7KCtgBofQg4abfpgt9I0JxnSCm/AX0pWATzwDGPIw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] cifs: get rid of dns resolve worker
Date:   Mon, 20 Feb 2023 16:36:54 -0300
Message-Id: <20230220193654@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We already upcall to resolve hostnames during reconnect by calling
reconn_set_ipaddr_from_hostname(), so there is no point in having a
worker to periodically call it.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/cifs/cifsglob.h |  5 -----
 fs/cifs/connect.c  | 53 ++++++----------------------------------------
 fs/cifs/sess.c     |  1 -
 3 files changed, 6 insertions(+), 53 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 893c2e21eb8e..b1db5dbae31a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -77,10 +77,6 @@
 #define SMB_ECHO_INTERVAL_MAX 600
 #define SMB_ECHO_INTERVAL_DEFAULT 60
 
-/* dns resolution intervals in seconds */
-#define SMB_DNS_RESOLVE_INTERVAL_MIN     120
-#define SMB_DNS_RESOLVE_INTERVAL_DEFAULT 600
-
 /* smb multichannel query server interfaces interval in seconds */
 #define SMB_INTERFACE_POLL_INTERVAL	600
 
@@ -689,7 +685,6 @@ struct TCP_Server_Info {
 	/* point to the SMBD connection if RDMA is used instead of socket */
 	struct smbd_connection *smbd_conn;
 	struct delayed_work	echo; /* echo ping workqueue job */
-	struct delayed_work	resolve; /* dns resolution workqueue job */
 	char	*smallbuf;	/* pointer to current "small" buffer */
 	char	*bigbuf;	/* pointer to current "big" buffer */
 	/* Total size of this PDU. Only valid from cifs_demultiplex_thread */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c65b06855e5f..6831eb8cea7c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -79,8 +79,6 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 	int len;
 	char *unc;
 	struct sockaddr_storage ss;
-	time64_t expiry, now;
-	unsigned long ttl = SMB_DNS_RESOLVE_INTERVAL_DEFAULT;
 
 	if (!server->hostname)
 		return -EINVAL;
@@ -102,29 +100,19 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 	ss = server->dstaddr;
 	spin_unlock(&server->srv_lock);
 
-	rc = dns_resolve_server_name_to_ip(unc, (struct sockaddr *)&ss, &expiry);
+	rc = dns_resolve_server_name_to_ip(unc, (struct sockaddr *)&ss, NULL);
 	kfree(unc);
 
 	if (rc < 0) {
 		cifs_dbg(FYI, "%s: failed to resolve server part of %s to IP: %d\n",
 			 __func__, server->hostname, rc);
-		goto requeue_resolve;
+	} else {
+		spin_lock(&server->srv_lock);
+		memcpy(&server->dstaddr, &ss, sizeof(server->dstaddr));
+		spin_unlock(&server->srv_lock);
+		rc = 0;
 	}
 
-	spin_lock(&server->srv_lock);
-	memcpy(&server->dstaddr, &ss, sizeof(server->dstaddr));
-	spin_unlock(&server->srv_lock);
-
-	now = ktime_get_real_seconds();
-	if (expiry && expiry > now)
-		/* To make sure we don't use the cached entry, retry 1s */
-		ttl = max_t(unsigned long, expiry - now, SMB_DNS_RESOLVE_INTERVAL_MIN) + 1;
-
-requeue_resolve:
-	cifs_dbg(FYI, "%s: next dns resolution scheduled for %lu seconds in the future\n",
-		 __func__, ttl);
-	mod_delayed_work(cifsiod_wq, &server->resolve, (ttl * HZ));
-
 	return rc;
 }
 
@@ -148,26 +136,6 @@ static void smb2_query_server_interfaces(struct work_struct *work)
 			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
 }
 
-static void cifs_resolve_server(struct work_struct *work)
-{
-	int rc;
-	struct TCP_Server_Info *server = container_of(work,
-					struct TCP_Server_Info, resolve.work);
-
-	cifs_server_lock(server);
-
-	/*
-	 * Resolve the hostname again to make sure that IP address is up-to-date.
-	 */
-	rc = reconn_set_ipaddr_from_hostname(server);
-	if (rc) {
-		cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
-				__func__, rc);
-	}
-
-	cifs_server_unlock(server);
-}
-
 /*
  * Update the tcpStatus for the server.
  * This is used to signal the cifsd thread to call cifs_reconnect
@@ -939,7 +907,6 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	spin_unlock(&server->srv_lock);
 
 	cancel_delayed_work_sync(&server->echo);
-	cancel_delayed_work_sync(&server->resolve);
 
 	spin_lock(&server->srv_lock);
 	server->tcpStatus = CifsExiting;
@@ -1563,7 +1530,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 		cifs_put_tcp_session(server->primary_server, from_reconnect);
 
 	cancel_delayed_work_sync(&server->echo);
-	cancel_delayed_work_sync(&server->resolve);
 
 	if (from_reconnect)
 		/*
@@ -1669,7 +1635,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
-	INIT_DELAYED_WORK(&tcp_ses->resolve, cifs_resolve_server);
 	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
 	mutex_init(&tcp_ses->reconnect_mutex);
 #ifdef CONFIG_CIFS_DFS_UPCALL
@@ -1758,12 +1723,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	/* queue echo request delayed work */
 	queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
 
-	/* queue dns resolution delayed work */
-	cifs_dbg(FYI, "%s: next dns resolution scheduled for %d seconds in the future\n",
-		 __func__, SMB_DNS_RESOLVE_INTERVAL_DEFAULT);
-
-	queue_delayed_work(cifsiod_wq, &tcp_ses->resolve, (SMB_DNS_RESOLVE_INTERVAL_DEFAULT * HZ));
-
 	return tcp_ses;
 
 out_err_crypto_release:
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 07822f2a5b7c..13e36ee967a6 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -541,7 +541,6 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 		 * remove this channel
 		 */
 		cancel_delayed_work_sync(&chan->server->echo);
-		cancel_delayed_work_sync(&chan->server->resolve);
 		cancel_delayed_work_sync(&chan->server->reconnect);
 
 		spin_lock(&ses->chan_lock);
-- 
2.39.2

