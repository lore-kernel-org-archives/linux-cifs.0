Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA6CC7EE29
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jun 2023 17:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjFIRry (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Jun 2023 13:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjFIRrx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Jun 2023 13:47:53 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D482737
        for <linux-cifs@vger.kernel.org>; Fri,  9 Jun 2023 10:47:52 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64d57cd373fso1499164b3a.1
        for <linux-cifs@vger.kernel.org>; Fri, 09 Jun 2023 10:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686332871; x=1688924871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wce3RZSFBAGDGOQ6rHhvRpjxgdV9x2dVLItk6MZgLMI=;
        b=N8wupbYCnkdd5IFxJav6Enidp8x/BvK4iCl5szNfxNaZCp4ZHwsfRiYXY1jKTc3UvP
         pD/ubYBtt/aDwO5XP9Xz7vbq4erz3W0nc5L+izZAGJERWzYP7O51TR7KQKcT1UnOFpzI
         FKOWGXrDRSwJoNulMW7mv8n484taoBQCiYWYrbzGcB4hsilkAHbWquIjnA9/2CYm42sB
         HhG74jG2vo6dDI4aUXMPIix4GEZTLKSpPQjDgQMqJMvsPOctm0etZy9xPNI+HToU2Ith
         fLE2D/a+zRN9FAewPuS05lO8b/EQzsGda1OJ4hxHOg7iKOhWj3es2PL0TQ0jZNpxjXqy
         Rkpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686332871; x=1688924871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wce3RZSFBAGDGOQ6rHhvRpjxgdV9x2dVLItk6MZgLMI=;
        b=EgX37W3eE8VDIJWOztoT0yok63kUu3bFeRh7zQ/fnfRLgjc+78aoqPoDEjQXHRNkUq
         kOqMW/REU/9iADCjd9wf+j2qW5rcn10Lkarpou6IeJRUP7Ni5S0SX5NgHoul4kjSOz0i
         KJw9CCgmwsNT7jTpSHXZdYVAVYt6vvS0y2uHnRppOqYLQOIp57PoL9H12T7s8LitEZ4Q
         KvjvJcGJE4JZLN2iB3HMJUqz5hMVSg8V/B+W2BAYYqgH0avAYONRtO6vFwPPguw7hkj4
         U4kAR98Cp8sL7AvV2Xyjgk/scYdFWBl19BFSACeUlYSf0ATLMPY/BKvJpG7x1i8yQ8qQ
         7P7g==
X-Gm-Message-State: AC+VfDzrUOYIsAmXFUUbC3JiFjFZRc4sfXJCXUtZK1SFBz6rGG4CIomD
        RfkEPw7WxxGD/1lzkMstmHi+luNRZv/82GaQ
X-Google-Smtp-Source: ACHHUZ48/OShmaIDkkSQ955eP9S11HqN5HOxUcQcEFuj3uwkSUNuH8BTYubUpa2jBC/uk8Z1P4Idng==
X-Received: by 2002:a17:903:2444:b0:1ac:a88a:70b6 with SMTP id l4-20020a170903244400b001aca88a70b6mr6917244pls.31.1686332871304;
        Fri, 09 Jun 2023 10:47:51 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id m4-20020a17090a71c400b0025671de4606sm5003064pjs.4.2023.06.09.10.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 10:47:50 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, tom@talpey.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
Date:   Fri,  9 Jun 2023 17:46:57 +0000
Message-Id: <20230609174659.60327-4-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609174659.60327-1-sprasad@microsoft.com>
References: <20230609174659.60327-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

With multichannel, it is useful to know the src port details
for each channel. This change will print the ip addr and
port details for both the socket dest and src endpoints.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifs_debug.c | 46 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 17c884724590..d5fd3681f56e 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/uaccess.h>
+#include <net/inet_sock.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -146,6 +147,30 @@ cifs_dump_channel(struct seq_file *m, int i, struct cifs_chan *chan)
 		   in_flight(server),
 		   atomic_read(&server->in_send),
 		   atomic_read(&server->num_waiters));
+
+#ifndef CONFIG_CIFS_SMB_DIRECT
+	if (server->ssocket) {
+		if (server->dstaddr.ss_family == AF_INET6) {
+			struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&server->dstaddr;
+			struct sock *sk = server->ssocket->sk;
+			struct inet_sock *inet = inet_sk(server->ssocket->sk);
+			seq_printf(m, "\n\t\tIPv6 Dest: [%pI6]:%d Src: [%pI6]:%d",
+				   &ipv6->sin6_addr,
+				   ntohs(ipv6->sin6_port),
+				   &sk->sk_v6_rcv_saddr.s6_addr32,
+				   ntohs(inet->inet_sport));
+		} else {
+			struct sockaddr_in *ipv4 = (struct sockaddr_in *)&server->dstaddr;
+			struct inet_sock *inet = inet_sk(server->ssocket->sk);
+			seq_printf(m, "\n\t\tIPv4 Dest: %pI4:%d Src: %pI4:%d",
+				   &ipv4->sin_addr,
+				   ntohs(ipv4->sin_port),
+				   &inet->inet_saddr,
+				   ntohs(inet->inet_sport));
+		}
+	}
+#endif
+
 }
 
 static void
@@ -351,6 +376,27 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			atomic_read(&server->smbd_conn->mr_ready_count),
 			atomic_read(&server->smbd_conn->mr_used_count));
 skip_rdma:
+#else
+		if (server->ssocket) {
+			if (server->dstaddr.ss_family == AF_INET6) {
+				struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&server->dstaddr;
+				struct sock *sk = server->ssocket->sk;
+				struct inet_sock *inet = inet_sk(server->ssocket->sk);
+				seq_printf(m, "\nIPv6 Dest: [%pI6]:%d Src: [%pI6]:%d",
+					   &ipv6->sin6_addr,
+					   ntohs(ipv6->sin6_port),
+					   &sk->sk_v6_rcv_saddr.s6_addr32,
+					   ntohs(inet->inet_sport));
+			} else {
+				struct sockaddr_in *ipv4 = (struct sockaddr_in *)&server->dstaddr;
+				struct inet_sock *inet = inet_sk(server->ssocket->sk);
+				seq_printf(m, "\nIPv4 Dest: %pI4:%d Src: %pI4:%d",
+					   &ipv4->sin_addr,
+					   ntohs(ipv4->sin_port),
+					   &inet->inet_saddr,
+					   ntohs(inet->inet_sport));
+			}
+		}
 #endif
 		seq_printf(m, "\nNumber of credits: %d,%d,%d Dialect 0x%x",
 			server->credits,
-- 
2.34.1

