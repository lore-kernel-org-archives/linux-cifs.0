Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76660C6FA99
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Mar 2023 15:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbjCJPpS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 10:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbjCJPoy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 10:44:54 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAAB4345B
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:25 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so10200052pjg.4
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678462405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sSqNTtmdDaJXLaSPQY1MYiqxFRrKDF/9afPRapSdy7o=;
        b=cEWykPoqM6i4u9YOniLc8nsUfEaU+l+ZQlrFfq3cPdziCg6+ilt3gSwHx6VNVnZbfZ
         19PmdiRPPekfcIgevv+zpw0sL5q4rma4BaiViLfSAkUKti42wCMNtnnDwDywZ0QEaPg7
         e2an8pW8LlcD4pLs8A83KEHvoGxKUPRoJr7RzZ0Fi98G+8JAI7lhwhRYEtAqEjtXrZuk
         s5CmxqeKrpx/71tfJeoz+UkXAPxpnTRknXjNu/ov12bj3/1Nzi+7FiQvo0Ep00wM5h8X
         OibthR2vtayno89aABZDJChHVtBZ/DGyWw8gayvtNyJb4P2tm7bJjXXkipEjYAwKYfJY
         /4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678462405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sSqNTtmdDaJXLaSPQY1MYiqxFRrKDF/9afPRapSdy7o=;
        b=Tt1bUfCm7Sv8wCP4wkSHACOrPenFx8kHgo/JuYsrLj+5tmzsimslMgjlkU35K1DA90
         8xFvsjGhRiKE9Ow4CIF3SUSYhP+6vwJYdwkjkGQZGxGDqG5ki4qIrEB9llqR1Op/BaOV
         Vu7o0KObRYac3TINixD7EMES+rfgG+AfH8bm2DVA/X4rYBmKkqE+TbdlYHOR5v0CJXJ2
         gLKyifISd5vf/BThscEelU2J58/5uHiRilqTybWg5kcS5RIcKL5McFogy2wIodFKAZl6
         O7xysXQ/NCfnT30ux8E1KPeBCjqM1jqXwaUUSci4+WCu1XOw1iUEdEWAvjubzLLlLg9I
         nzvQ==
X-Gm-Message-State: AO0yUKXFKtgcuBT6GXZHvXMExkYJSALZ3NnlIjpt9Pt2u5i4n14+zpHc
        342NDIxmrwl9nMZbl7Xa2d4utDXOrrTPY5w9z94=
X-Google-Smtp-Source: AK7set8YEaP9BL/MwYewiHkr+Da8SmmNeH93qgD6FwWJuxoc1C0Lv/LjM2vhMfv5rt49clmAlptJvw==
X-Received: by 2002:a17:90b:4f4a:b0:237:1f17:6842 with SMTP id pj10-20020a17090b4f4a00b002371f176842mr27320541pjb.10.1678462405218;
        Fri, 10 Mar 2023 07:33:25 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090a604700b00230b8402760sm71637pjm.38.2023.03.10.07.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:33:24 -0800 (PST)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz,
        tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 06/11] cifs: fix sockaddr comparison in iface_cmp
Date:   Fri, 10 Mar 2023 15:32:05 +0000
Message-Id: <20230310153211.10982-6-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310153211.10982-1-sprasad@microsoft.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

iface_cmp used to simply do a memcmp of the two
provided struct sockaddrs. The comparison needs to do more
based on the address family. Similar logic was already
present in cifs_match_ipaddr. Doing something similar now.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/cifsglob.h  | 37 ---------------------------------
 fs/cifs/cifsproto.h |  1 +
 fs/cifs/connect.c   | 50 +++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c   | 37 +++++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+), 37 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 81ff13e41f97..a11e7b10f607 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -965,43 +965,6 @@ release_iface(struct kref *ref)
 	kfree(iface);
 }
 
-/*
- * compare two interfaces a and b
- * return 0 if everything matches.
- * return 1 if a has higher link speed, or rdma capable, or rss capable
- * return -1 otherwise.
- */
-static inline int
-iface_cmp(struct cifs_server_iface *a, struct cifs_server_iface *b)
-{
-	int cmp_ret = 0;
-
-	WARN_ON(!a || !b);
-	if (a->speed == b->speed) {
-		if (a->rdma_capable == b->rdma_capable) {
-			if (a->rss_capable == b->rss_capable) {
-				cmp_ret = memcmp(&a->sockaddr, &b->sockaddr,
-						 sizeof(a->sockaddr));
-				if (!cmp_ret)
-					return 0;
-				else if (cmp_ret > 0)
-					return 1;
-				else
-					return -1;
-			} else if (a->rss_capable > b->rss_capable)
-				return 1;
-			else
-				return -1;
-		} else if (a->rdma_capable > b->rdma_capable)
-			return 1;
-		else
-			return -1;
-	} else if (a->speed > b->speed)
-		return 1;
-	else
-		return -1;
-}
-
 struct cifs_chan {
 	struct TCP_Server_Info *server;
 	struct cifs_server_iface *iface; /* interface in use */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e2eff66eefab..30fd81268eb7 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -86,6 +86,7 @@ extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
 extern int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
 extern int smb3_parse_opt(const char *options, const char *key, char **val);
+extern int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
 extern bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
 extern int cifs_discard_remaining_data(struct TCP_Server_Info *server);
 extern int cifs_call_async(struct TCP_Server_Info *server,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fb9d9994df09..b9af60417194 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1289,6 +1289,56 @@ cifs_demultiplex_thread(void *p)
 	module_put_and_kthread_exit(0);
 }
 
+int
+cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs)
+{
+	switch (srcaddr->sa_family) {
+	case AF_UNSPEC:
+		switch (rhs->sa_family) {
+		case AF_UNSPEC:
+			return 0;
+		case AF_INET:
+		case AF_INET6:
+			return 1;
+		default:
+			return -1;
+		}
+	case AF_INET: {
+		switch (rhs->sa_family) {
+		case AF_UNSPEC:
+			return -1;
+		case AF_INET:
+			struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
+			struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
+			return memcmp(&saddr4->sin_addr.s_addr,
+			       &vaddr4->sin_addr.s_addr,
+			       sizeof(struct sockaddr_in));
+		case AF_INET6:
+			return 1;
+		default:
+			return -1;
+		}
+	}
+	case AF_INET6: {
+		switch (rhs->sa_family) {
+		case AF_UNSPEC:
+		case AF_INET:
+			return -1;
+		case AF_INET6:
+			struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
+			struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
+			return memcmp(&saddr6->sin6_addr,
+				      &vaddr6->sin6_addr,
+				      sizeof(struct sockaddr_in6));
+		default:
+			return -1;
+		}
+	}
+	default:
+		return -1; /* don't expect to be here */
+	}
+}
+
 /*
  * Returns true if srcaddr isn't specified and rhs isn't specified, or
  * if srcaddr is specified and matches the IP address of the rhs argument
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6dfb865ee9d7..0627d5e38236 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -510,6 +510,43 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	return rsize;
 }
 
+/*
+ * compare two interfaces a and b
+ * return 0 if everything matches.
+ * return 1 if a is rdma capable, or rss capable, or has higher link speed
+ * return -1 otherwise.
+ */
+static int
+iface_cmp(struct cifs_server_iface *a, struct cifs_server_iface *b)
+{
+	int cmp_ret = 0;
+
+	WARN_ON(!a || !b);
+	if (a->rdma_capable == b->rdma_capable) {
+		if (a->rss_capable == b->rss_capable) {
+			if (a->speed == b->speed) {
+				cmp_ret = cifs_ipaddr_cmp((struct sockaddr *) &a->sockaddr,
+							  (struct sockaddr *) &b->sockaddr);
+				if (!cmp_ret)
+					return 0;
+				else if (cmp_ret > 0)
+					return 1;
+				else
+					return -1;
+			} else if (a->speed > b->speed)
+				return 1;
+			else
+				return -1;
+		} else if (a->rss_capable > b->rss_capable)
+			return 1;
+		else
+			return -1;
+	} else if (a->rdma_capable > b->rdma_capable)
+		return 1;
+	else
+		return -1;
+}
+
 static int
 parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			size_t buf_len, struct cifs_ses *ses, bool in_mount)
-- 
2.34.1

