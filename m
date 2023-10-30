Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB37C4167D
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbjJ3LBE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbjJ3LBD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:01:03 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1355FB7
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:01:01 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1cc5b705769so1671425ad.0
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663660; x=1699268460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pp38NWtNMiYYx3sxCJ1Uwk6p3j55j/QF+jF5tL5bvhI=;
        b=IKqMPnsreB5GyA5HF1w0+koVDZzZNFpF/2EqpI4Bn4VSd7xH81LjaHDGi+Ydga80iA
         G+EfMm3ZRG09yGC8LnVWfJNut6EYWOBHuw3H9fD0FSvQxkdjGnLrsiJg5Qzx06rgBfaJ
         HGyZyLCK8iFL+EEBdEQ0jYSTMNFpTvqwOkR4oK4w5zTDieH+AwujF8ReRKzvP9g0kXBy
         n/yLM1Quo/rakcdahEPSojf+xTVzkusa1KKaG4/7UXzh87W5qH3PJ0r4aarStVzDN9mH
         m+LN7+J+L2+9CmMfjE0DR1qDKy1Lig++3ie+Ia3R2KefKtCCdHz8yeWrrFuLPJEYIcNY
         1Fdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663660; x=1699268460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pp38NWtNMiYYx3sxCJ1Uwk6p3j55j/QF+jF5tL5bvhI=;
        b=X0TwmupBBCn/+HIzPYdvfJnglix5pB25y+e9TpM4qXQKUurNKaBxOlpDbCLXdfymQ+
         OPinaWciJOkmggpcEVFXGo4SeB3sGYP4Wp3iU3/a21wz3hVQBWVoZ0LE7kEiMaO+1KYV
         0MM14ubFaocc/r3MlCIGhi5+mBtKZxFlhcy5SO584JSMERB8loFkQ44mFIPsd/JkCrTE
         Z5XfdxWLTRHr0HYjvS7PI9jH+ge1lNsNRYOFhn2b5YEiN+AyNDE+W4XQjf+4xq+MsDv8
         R5Tk3eycpe1y2RvtWt9OezpqFuG8+2JUIhrQpKp3DIUWFVfW32kH8K4jtNhzPmwSIt03
         LEFg==
X-Gm-Message-State: AOJu0YxoKuwhLCr+lkbSnO1WB7Xph2iL3SXcXxr7K6X4UBHiRoUahWQX
        G91GU1PFRLnoWXNnW9XI87RX36JYLIdSpw==
X-Google-Smtp-Source: AGHT+IFXkZK5qeRkAzaFzlwR266eHSnGBNgK8TYV2454qixzEyn/ONfts3GfxV/7ygjuDd8+7TFT9A==
X-Received: by 2002:a17:903:2292:b0:1cc:474a:ddeb with SMTP id b18-20020a170903229200b001cc474addebmr3715898plh.47.1698663660413;
        Mon, 30 Oct 2023 04:01:00 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:01:00 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 13/14] cifs: display the endpoint IP details in DebugData
Date:   Mon, 30 Oct 2023 11:00:19 +0000
Message-Id: <20231030110020.45627-13-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

With multichannel, it is useful to know the src port details
for each channel. This change will print the ip addr and
port details for both the socket dest and src endpoints.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifs_debug.c | 73 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index e23fcabb78d6..d8362e098310 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -13,6 +13,7 @@
 #include <linux/proc_fs.h>
 #include <linux/uaccess.h>
 #include <uapi/linux/ethtool.h>
+#include <net/inet_sock.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -158,11 +159,37 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
 		   in_flight(server),
 		   atomic_read(&server->in_send),
 		   atomic_read(&server->num_waiters));
+
 #ifdef CONFIG_NET_NS
 	if (server->net)
 		seq_printf(m, " Net namespace: %u ", server->net->ns.inum);
 #endif /* NET_NS */
 
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	if (!server->rdma)
+		goto skip_rdma;
+
+	if (server->smbd_conn && server->smbd_conn->id) {
+		struct rdma_addr *addr =
+			&server->smbd_conn->id->route.addr;
+		seq_printf(m, "\n\t\tIP addr: dst: %pISpc, src: %pISpc",
+			   &addr->dst_addr, &addr->src_addr);
+	}
+
+skip_rdma:
+#endif
+	if (server->ssocket) {
+		struct sockaddr src;
+		int addrlen;
+
+		addrlen = kernel_getsockname(server->ssocket, &src);
+		if (addrlen != sizeof(struct sockaddr_in) &&
+		    addrlen != sizeof(struct sockaddr_in6))
+			return;
+
+		seq_printf(m, "\n\t\tIP addr: dst: %pISpc, src: %pISpc",
+			   &server->dstaddr, &src);
+	}
 }
 
 static inline const char *smb_speed_to_str(size_t bps)
@@ -279,7 +306,7 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 {
 	struct mid_q_entry *mid_entry;
-	struct TCP_Server_Info *server;
+	struct TCP_Server_Info *server, *nserver;
 	struct TCP_Server_Info *chan_server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -336,7 +363,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 	c = 0;
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+	list_for_each_entry_safe(server, nserver, &cifs_tcp_ses_list, tcp_ses_list) {
 		/* channel info will be printed as a part of sessions below */
 		if (SERVER_IS_CHAN(server))
 			continue;
@@ -414,8 +441,39 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "\nMR mr_ready_count: %x mr_used_count: %x",
 			atomic_read(&server->smbd_conn->mr_ready_count),
 			atomic_read(&server->smbd_conn->mr_used_count));
+		if (server->smbd_conn->id) {
+			struct rdma_addr *addr =
+				&server->smbd_conn->id->route.addr;
+			seq_printf(m, "\nIP addr: dst: %pISpc, src: %pISpc",
+				   &addr->dst_addr, &addr->src_addr);
+		}
 skip_rdma:
 #endif
+		if (server->ssocket) {
+			struct sockaddr src;
+			int addrlen;
+
+			/* kernel_getsockname can block. so drop the lock first */
+			server->srv_count++;
+			spin_unlock(&cifs_tcp_ses_lock);
+
+			addrlen = kernel_getsockname(server->ssocket, &src);
+			if (addrlen != sizeof(struct sockaddr_in) &&
+			    addrlen != sizeof(struct sockaddr_in6)) {
+				cifs_put_tcp_session(server, 0);
+				spin_lock(&cifs_tcp_ses_lock);
+
+				goto skip_addr_details;
+			}
+
+			seq_printf(m, "\nIP addr: dst: %pISpc, src: %pISpc",
+				   &server->dstaddr, &src);
+
+			cifs_put_tcp_session(server, 0);
+			spin_lock(&cifs_tcp_ses_lock);
+		}
+
+skip_addr_details:
 		seq_printf(m, "\nNumber of credits: %d,%d,%d Dialect 0x%x",
 			server->credits,
 			server->echo_credits,
@@ -515,7 +573,18 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				seq_printf(m, "\n\n\tExtra Channels: %zu ",
 					   ses->chan_count-1);
 				for (j = 1; j < ses->chan_count; j++) {
+					/*
+					 * kernel_getsockname can block inside
+					 * cifs_dump_channel. so drop the lock first
+					 */
+					server->srv_count++;
+					spin_unlock(&cifs_tcp_ses_lock);
+
 					cifs_dump_channel(m, j, &ses->chans[j]);
+
+					cifs_put_tcp_session(server, 0);
+					spin_lock(&cifs_tcp_ses_lock);
+
 					if (CIFS_CHAN_NEEDS_RECONNECT(ses, j))
 						seq_puts(m, "\tDISCONNECTED ");
 					if (CIFS_CHAN_IN_RECONNECT(ses, j))
-- 
2.34.1

