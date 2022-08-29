Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB18ECAAD4
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Aug 2022 21:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiH2VeW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Aug 2022 17:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiH2VeU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 29 Aug 2022 17:34:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0206B205FB
        for <linux-cifs@vger.kernel.org>; Mon, 29 Aug 2022 14:34:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9D9D91F8C9;
        Mon, 29 Aug 2022 21:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661808858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ev67dvM7ilSFx9VYm0DLJ180uEZYnW0Yrvbi9fZGYc=;
        b=qevmdOLutYoKiFspXO6TWgSr37kfRQVq/OAjn4Ye1JWr7RZszotk5moUaVW7+6kNY/FyMv
        BJTFPZtDVFHARiAP1b+OPjcGjcL+gTPACYaVaPtGc1JVvqNzcQ/1Xr+2KrBWtf8611Nc9G
        s7kaDthiRMp6RsXseZnoMSzNbcB0YL4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661808858;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ev67dvM7ilSFx9VYm0DLJ180uEZYnW0Yrvbi9fZGYc=;
        b=Ue3knS0rQqzrkImN/knCruQ+5hF7BuCwTsxKdPMcGxLph/6CFMSFDmaiElu5kQYjLDspNx
        iTpU2v4A7j8P0PAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1BEBF133A6;
        Mon, 29 Aug 2022 21:34:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id t/ulM9kwDWNFCAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 29 Aug 2022 21:34:17 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH v2 3/3] cifs: show signing algorithm name in DebugData
Date:   Mon, 29 Aug 2022 18:33:54 -0300
Message-Id: <20220829213354.2714-4-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220829213354.2714-1-ematsumiya@suse.de>
References: <20220829213354.2714-1-ematsumiya@suse.de>
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

