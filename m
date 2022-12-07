Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2DF8C3A5A7
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Dec 2022 02:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiLGChu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Dec 2022 21:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLGChs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Dec 2022 21:37:48 -0500
Received: from sender4-of-o56.zoho.com (sender4-of-o56.zoho.com [136.143.188.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999F131DC8
        for <linux-cifs@vger.kernel.org>; Tue,  6 Dec 2022 18:37:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1670380645; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=L9j17KXG4cG3x00+7tdpkBn4uobK+Ar+eNvhfVbbQmmC4EUw09iGMeprXPBbhXwNOIyX/mi/Ey92wbwVgV2MKBKPi4V8e0LXUf+MGl7Kr1qBrMAEvwZy+KabM/ImooUD6VzClyHxjibGxhO/MdNrUNJuyoyGsP3yclAEc/dvUXU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1670380645; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=7+mvPXky2Er9f/g8Bybx747sNW+22J409vWWiNW4Qko=; 
        b=oFBLcAzLVKeEBqNSuMneK+1fMX0T9ivNRKB94lesIzZTGne5ZYUCBuaCKCT/zD7g7RNfW9UYRYRH6qMnuDefrjZOdYAPPJ9Epn7df8RX/hCYE+a/ZB/MopUO1WSmAtTMB7DlE4dFrVRWijapdsqnSwlHraf84xaocNlpg6YAZKE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=business@elijahpepe.com;
        dmarc=pass header.from=<business@elijahpepe.com>
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1670380644666832.1688255015492; Tue, 6 Dec 2022 18:37:24 -0800 (PST)
Date:   Tue, 06 Dec 2022 18:37:24 -0800
From:   Elijah Conners <business@elijahpepe.com>
To:     "linux-cifs" <linux-cifs@vger.kernel.org>,
        "samba-technical" <samba-technical@lists.samba.org>
Cc:     "tom" <tom@talpey.com>, "pc" <pc@cjr.nz>,
        "sfrench" <sfrench@samba.org>, "lsahlber" <lsahlber@redhat.com>,
        "sprasad" <sprasad@microsoft.com>
Message-ID: <184ea71e92a.115993f353574592.7325889929528068981@elijahpepe.com>
In-Reply-To: 
Subject: [PATCH v4] cifs: add ipv6 parsing
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

CIFS currently lacks IPv6 parsing, presenting complications for CIFS
over IPv6.

To parse both IPv4 and IPv6 addresses, the parse_srvaddr() function
was altered; parse_srvaddr() now returns void. To retrieve the IP
address from parse_srvaddr(), the parameters *out6 and *out32, an
in6_addr and a __be32 respectively, are provided. The value of
root_server_addr is determined by if those parameters are set or not.

The parsing in parse_srvaddr() was updated slightly. The character addr
can hold up to 46 characters, the longest a possible IPv6 address can
be. In the while loop, isdigit() has been replaced with isxdigit() to
account for letters present in IPv6 addresses, and *start is also
checked for being a colon. Finally, the function uses inet_pton() to
determine if the address is an IPv6 address; if so, *out6 is equal to
in6, set by inet_pton, otherwise, *out32 is set to in_aton(addr).

Signed-off-by: Elijah Conners <business@elijahpepe.com>
---
 fs/cifs/cifsroot.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsroot.c b/fs/cifs/cifsroot.c
index 9e91a5a40aae..f776508d558b 100644
--- a/fs/cifs/cifsroot.c
+++ b/fs/cifs/cifsroot.c
@@ -14,6 +14,7 @@
 #include <linux/in.h>
 #include <linux/inet.h>
 #include <net/ipconfig.h>
+#include <arpa/inet.h>
 
 #define DEFAULT_MNT_OPTS \
 	"vers=1.0,cifsacl,mfsymlinks,rsize=1048576,wsize=65536,uid=0,gid=0," \
@@ -22,19 +23,24 @@
 static char root_dev[2048] __initdata = "";
 static char root_opts[1024] __initdata = DEFAULT_MNT_OPTS;
 
-static __be32 __init parse_srvaddr(char *start, char *end)
+static void __init parse_srvaddr(char *start, char *end, struct in6_addr *out6, __be32 *out32)
 {
-	/* TODO: ipv6 support */
-	char addr[sizeof("aaa.bbb.ccc.ddd")];
+	char addr[INET6_ADDRSTRLEN];
+	struct in6_addr in6;
 	int i = 0;
 
 	while (start < end && i < sizeof(addr) - 1) {
-		if (isdigit(*start) || *start == '.')
+		if (isxdigit(*start) || *start == '.' || *start == ':')
 			addr[i++] = *start;
 		start++;
 	}
 	addr[i] = '\0';
-	return in_aton(addr);
+
+	if (inet_pton(AF_INET6, addr, &in6) > 0) {
+		*out6 = in6;
+	} else {
+		*out32 = in_aton(addr);
+	}
 }
 
 /* cifsroot=//<server-ip>/<share>[,options] */
@@ -42,7 +48,8 @@ static int __init cifs_root_setup(char *line)
 {
 	char *s;
 	int len;
-	__be32 srvaddr = htonl(INADDR_NONE);
+	struct in6_addr addr6;
+	__be32 addr32;
 
 	ROOT_DEV = Root_CIFS;
 
@@ -60,7 +67,7 @@ static int __init cifs_root_setup(char *line)
 			return 1;
 		}
 		strlcpy(root_dev, line, len);
-		srvaddr = parse_srvaddr(&line[2], s);
+		parse_srvaddr(&line[2], s, &addr6, &addr32);
 		if (*s) {
 			int n = snprintf(root_opts,
 					 sizeof(root_opts), "%s,%s",
@@ -73,7 +80,11 @@ static int __init cifs_root_setup(char *line)
 		}
 	}
 
-	root_server_addr = srvaddr;
+	if (addr6.is_set) {
+		root_server_addr = addr6;
+	} else if (addr32.is_set) {
+		root_server_addr = addr32;
+	}
 
 	return 1;
 }
-- 
2.29.2.windows.2


