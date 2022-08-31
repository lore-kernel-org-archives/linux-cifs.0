Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3D7ECAAD1
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 13:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiHaNqT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 09:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbiHaNqO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 09:46:14 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B0B45067
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 06:45:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 560C31F893;
        Wed, 31 Aug 2022 13:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661953519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ev67dvM7ilSFx9VYm0DLJ180uEZYnW0Yrvbi9fZGYc=;
        b=Wg5uULSKNmhsC1llm7bPCLzBIKe4av0l/TzHmTuIsdIKGekUZZBV2EUPHrGnTLhvHdXA2u
        ce+QUFsou8GQIBWdmtz3Hv1jx9y6vrZDKZPWoKm+ftQpR28EQECf92pbYAPE/3YsJ6gDk1
        47CDoVc/ZpU/shQAqsFqVp+daJP0QXE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661953519;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ev67dvM7ilSFx9VYm0DLJ180uEZYnW0Yrvbi9fZGYc=;
        b=DSXDZnx3ipuULCFP2VYqw9mRzyFHKMELWJUyLWByLxgYi1EEos2eQF3wfoMYfWKeXslpEZ
        P8IvCxSdIGOFlLCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C347A1332D;
        Wed, 31 Aug 2022 13:45:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eG71Ie5lD2MHPwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 31 Aug 2022 13:45:18 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, dan.carpenter@oracle.com
Subject: [PATCH v2 3/3] cifs: show signing algorithm name in DebugData
Date:   Wed, 31 Aug 2022 10:44:44 -0300
Message-Id: <20220831134444.26252-4-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220831134444.26252-1-ematsumiya@suse.de>
References: <20220831134444.26252-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

- Move smb3_signing_algo_str() to smb2glob.h
- Rename it to smb2_signing_algo_str()
- Add a case for HMAC-SHA256
- Show the algorithm name in DebugData, when signing is enabled

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c |  7 +++++--
 fs/cifs/smb2glob.h   | 10 ++++++++++
 fs/cifs/smb2pdu.c    | 13 +------------
 3 files changed, 16 insertions(+), 14 deletions(-)

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
index d51dfe3bb163..11d1cb7d7ff6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -716,17 +716,6 @@ static int decode_encrypt_ctx(struct TCP_Server_Info *server,
 	return 0;
 }
 
-/* XXX: maybe move this somewhere else? */
-static const char *smb3_signing_algo_str(u16 algo)
-{
-	switch (algo) {
-	case SIGNING_ALG_AES_CMAC: return "AES-CMAC";
-	case SIGNING_ALG_AES_GMAC: return "AES-GMAC";
-	/* HMAC-SHA256 is unused in SMB3+ context */
-	default: return "unknown";
-	}
-}
-
 static void decode_signing_ctx(struct TCP_Server_Info *server,
 			       struct smb2_signing_capabilities *pctxt)
 {
@@ -757,7 +746,7 @@ static void decode_signing_ctx(struct TCP_Server_Info *server,
 	/* AES-CMAC is already the default, in case AES-GMAC wasn't negotiated */
 
 	cifs_dbg(FYI, "negotiated signing algorithm '%s'\n",
-		 smb3_signing_algo_str(server->signing_algorithm));
+		 smb2_signing_algo_str(server->signing_algorithm));
 }
 
 static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
-- 
2.35.3

