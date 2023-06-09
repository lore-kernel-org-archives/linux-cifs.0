Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AC5C7EE29
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jun 2023 17:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjFIRsA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Jun 2023 13:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjFIRr7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Jun 2023 13:47:59 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D757E47
        for <linux-cifs@vger.kernel.org>; Fri,  9 Jun 2023 10:47:58 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-2563ca70f64so788998a91.0
        for <linux-cifs@vger.kernel.org>; Fri, 09 Jun 2023 10:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686332877; x=1688924877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6/h0b9a5wSYNN4GJoMo2o4EWk5PesQOmKscL5La0xw=;
        b=f1FL/IRVr/VPLOAFTdCYP6e9xmwaXGAUtQLEW4Moeafk+gIBqk8aQzC5t6bNuMULhC
         lWwuNWfwiQN7jybMGVZdzJZqH+GZJRJm99DbK8G+4YkrSBdp3E+mBmRgxVK7jilAX4rM
         R8ek9XopiCtSWpBGNLrj5dySPE02+DOiu5VQAMrjN1LU8M+iQXwUawghQ0IPEeUQimYM
         ZPAoco/DI6cSZfffX3MyLEsUoy5VZZ/dzZX6mzKOp8bfyZjkwaCphFCScZO6KAQNFLcx
         E+0lASnL0GibuIVmIAi6z+0Df4fdv469D1Xi/Kikgq6+XqMD8D2aE6UqwsS7bhK/WNIU
         atvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686332877; x=1688924877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6/h0b9a5wSYNN4GJoMo2o4EWk5PesQOmKscL5La0xw=;
        b=DT1ola3Sa4CXhtzyPHz65OfSSwN5mYV9yqssgpJeP1by45Et2ea4cjmTcQzuiM5zY9
         Q7QDfeVTOpCEMBJYf5vDO7wMfOOSbHbQhvnAfortepUb6hxn9SsIL4oT+3Z75U4tgjuM
         BaMDllqNwqFikF3HE+X26S05B2IRZH7Xg48ChSExj+/hT8GYEjUDS8rr74/BmhsFBxDC
         SK8C6BldSuFCobg9ru/UJise9+bQJVqTjg84tqdO+5a8F+SVkBtiJNNTWoKDJVOhAndp
         4Jsvrrkujei8ezPnSbGdoWaLEqfueingUnqakJLtgPJ9jAK4okromyWOTfhXcWPO/igU
         vl5Q==
X-Gm-Message-State: AC+VfDw/UOasfjFbAE9NXVxLqAig5DpjPVyeomKHSbnQyAs0spN3z6yq
        cmc9gLBwMp6iySvGVGRKBSaN36U+eVAB2EFl
X-Google-Smtp-Source: ACHHUZ7INrmJcdyS7fD1UN9zXCcvvTwxJO1ieUTbOct1xJMpAqwTvfO9Sqj/ikTVKuiOoojwdjnaXQ==
X-Received: by 2002:a17:90a:199:b0:252:94b5:36f1 with SMTP id 25-20020a17090a019900b0025294b536f1mr1453283pjc.27.1686332877361;
        Fri, 09 Jun 2023 10:47:57 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id m4-20020a17090a71c400b0025671de4606sm5003064pjs.4.2023.06.09.10.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 10:47:57 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, tom@talpey.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH 6/6] cifs: fix sockaddr comparison in iface_cmp
Date:   Fri,  9 Jun 2023 17:46:59 +0000
Message-Id: <20230609174659.60327-6-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609174659.60327-1-sprasad@microsoft.com>
References: <20230609174659.60327-1-sprasad@microsoft.com>
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
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
---
 fs/smb/client/cifsglob.h  | 37 -----------------------------
 fs/smb/client/cifsproto.h |  1 +
 fs/smb/client/connect.c   | 50 +++++++++++++++++++++++++++++++++++++++
 fs/smb/client/smb2ops.c   | 37 +++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+), 37 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 0d84bb1a8cd9..b212a4e16b39 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -970,43 +970,6 @@ release_iface(struct kref *ref)
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
 	unsigned int in_reconnect : 1; /* if session setup in progress for this channel */
 	struct TCP_Server_Info *server;
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c1c704990b98..d127aded2f28 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -87,6 +87,7 @@ extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
 extern int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
 extern int smb3_parse_opt(const char *options, const char *key, char **val);
+extern int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
 extern bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
 extern int cifs_discard_remaining_data(struct TCP_Server_Info *server);
 extern int cifs_call_async(struct TCP_Server_Info *server,
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 1250d156619b..9d16626e7a66 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1288,6 +1288,56 @@ cifs_demultiplex_thread(void *p)
 	module_put_and_kthread_exit(0);
 }
 
+int
+cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs)
+{
+	struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
+	struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
+	struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
+	struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
+
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
+			return memcmp(saddr4, vaddr4,
+				      sizeof(struct sockaddr_in));
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
+			return memcmp(saddr6,
+				      vaddr6,
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
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 18faf267c54d..046341115add 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -513,6 +513,43 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
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

