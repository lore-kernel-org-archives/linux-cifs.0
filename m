Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 008A7C04A95
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 01:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiI2B5b (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 21:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbiI2B5a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 21:57:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948A912260C
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 18:57:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D0D2A21C9D;
        Thu, 29 Sep 2022 01:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664416645; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nVDsibW8VmfTm+d7goUctiKFujbn4aZ/0nacUTXaEeA=;
        b=rBXPrroxyJl8LEqimpcjN5Dl6dnyd61cIR8iIrIdocE0+V+ASFQRwNE50xOJ0/x4KgNnnu
        c7jGfNALy4hHe0riiH+PlObnJM6gdDvSE9u3QJJny+yOyjNJ3SguUSdU8gcATuW0eLegEg
        uf2cgU57sgBtbiv39PiArXvlAJV59Mw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664416645;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nVDsibW8VmfTm+d7goUctiKFujbn4aZ/0nacUTXaEeA=;
        b=EhXqQG1NQb1Ws3n92Gs5yD6NUvvz2BrlWejB63eYb6AGhQwe3YJo7Y8HHAvkr0ODFKnCYC
        53ipVj1Jd1wtulBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2C9E1139B3;
        Thu, 29 Sep 2022 01:57:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BRLxM4T7NGOheQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 01:57:24 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: [PATCH v3 7/8] cifs: show signing algorithm name in DebugData
Date:   Wed, 28 Sep 2022 22:56:36 -0300
Message-Id: <20220929015637.14400-8-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220929015637.14400-1-ematsumiya@suse.de>
References: <20220929015637.14400-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add smb2_signing_algo_str() helper in smb2glob.h
Show the algorithm name in DebugData, when signing is enabled.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c |  7 +++++--
 fs/cifs/smb2glob.h   | 10 ++++++++++
 fs/cifs/smb2pdu.c    |  4 ++--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index c05477e28cff..86a5fb93f07f 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -13,6 +13,7 @@
 #include <linux/uaccess.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
+#include "smb2glob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifsfs.h"
@@ -354,7 +355,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		else if (server->compress_algorithm == SMB3_COMPRESS_LZ77_HUFF)
 			seq_printf(m, " COMPRESS_LZ77_HUFF");
 		if (server->sign)
-			seq_printf(m, " signed");
+			seq_printf(m, " signed (%s)",
+				   smb2_signing_algo_str(server->signing_algorithm));
 		if (server->posix_ext_supported)
 			seq_printf(m, " posix");
 		if (server->nosharesock)
@@ -405,7 +407,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
 				seq_puts(m, " encrypted");
 			if (ses->sign)
-				seq_puts(m, " signed");
+				seq_printf(m, " signed (%s)",
+				   smb2_signing_algo_str(server->signing_algorithm));
 
 			seq_printf(m, "\n\tUser: %d Cred User: %d",
 				   from_kuid(&init_user_ns, ses->linux_uid),
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 82e916ad167c..3a3e81b1b8cb 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -41,4 +41,14 @@
 #define END_OF_CHAIN 4
 #define RELATED_REQUEST 8
 
+static inline const char *smb2_signing_algo_str(u16 algo)
+{
+	switch (algo) {
+	case SIGNING_ALG_HMAC_SHA256: return "HMAC-SHA256";
+	case SIGNING_ALG_AES_CMAC: return "AES-CMAC";
+	case SIGNING_ALG_AES_GMAC: return "AES-GMAC";
+	default: return "unknown algorithm";
+	}
+}
+
 #endif	/* _SMB2_GLOB_H */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6c1d58492b18..6c22ead51feb 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -725,8 +725,8 @@ static void decode_signing_ctx(struct TCP_Server_Info *server,
 
 	server->signing_negotiated = true;
 	server->signing_algorithm = le16_to_cpu(pctxt->SigningAlgorithms[0]);
-	cifs_dbg(FYI, "signing algorithm %d chosen\n",
-		     server->signing_algorithm);
+	cifs_dbg(FYI, "negotiated signing algorithm '%s'\n",
+		 smb2_signing_algo_str(server->signing_algorithm));
 }
 
 
-- 
2.35.3

