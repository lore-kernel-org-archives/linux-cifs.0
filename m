Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E887C3DA6B
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 13:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiHaNqT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 09:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiHaNqO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 09:46:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489F8402CF
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 06:45:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 01685220FF;
        Wed, 31 Aug 2022 13:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661953516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rqVW6VD8NZE3V2y/9pOVQx8Xe0pwwcMCvWaxEGmbIuM=;
        b=Sz9mH03aHNwajN1drsvgxLmpKZUU7KKCyRzuY06NvIl25DLAnGFPAKsj17AfhBDULO+AQa
        IoGOG+tr4c5X7PHDb6J7fyFoKg3JCOBgL5/OuTNCj+RCQjtSl0SccUFndAG3/ZtJBm0rkE
        pJQQUdzvkFZvztEzTNOp/yQct822ODM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661953516;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rqVW6VD8NZE3V2y/9pOVQx8Xe0pwwcMCvWaxEGmbIuM=;
        b=T1M55BFa7fy16JyzLm878HxKqx2FEP2uSgR7/nbjk8+pfZp0fxSOsOBb5/BJpHZeEZvbMw
        cgbmOgfpJVfYdRCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 765491332D;
        Wed, 31 Aug 2022 13:45:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qs1YDutlD2P/PgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 31 Aug 2022 13:45:15 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, dan.carpenter@oracle.com
Subject: [PATCH v2 2/3] cifs: deprecate 'enable_negotiate_signing' module param
Date:   Wed, 31 Aug 2022 10:44:43 -0300
Message-Id: <20220831134444.26252-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220831134444.26252-1-ematsumiya@suse.de>
References: <20220831134444.26252-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We can blindly send a negotiate signing context on every negotiate call,
as it doesn't affect the current behaviour; even though we set AES-GMAC
as the first signing algorithm (i.e. our preferred algorithm), it will
use AES-CMAC if:

a) the server doesn't respond to signing negotiations
b) the server responds that it only supports AES-GMAC

So this is a safe change.

Throw a warning if 'enable_negotiate_signing=0' was explicitly set, but
ignore it and set it back to true.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsfs.c   |  8 ++++++--
 fs/cifs/cifsglob.h |  3 ++-
 fs/cifs/smb2pdu.c  | 21 ++++++++++++---------
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e9fb338b8e7e..40dcb0b73bea 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -65,7 +65,7 @@ bool lookupCacheEnabled = true;
 bool disable_legacy_dialects; /* false by default */
 bool enable_gcm_256 = true;
 bool require_gcm_256; /* false by default */
-bool enable_negotiate_signing; /* false by default */
+bool enable_negotiate_signing = true; /* deprecated -- always true now */
 unsigned int global_secflags = CIFSSEC_DEF;
 /* unsigned int ntlmv2_support = 0; */
 unsigned int sign_CIFS_PDUs = 1;
@@ -133,8 +133,12 @@ MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encr
 module_param(require_gcm_256, bool, 0644);
 MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. Default: n/N/0");
 
+/* XXX: remove this at some point */
 module_param(enable_negotiate_signing, bool, 0644);
-MODULE_PARM_DESC(enable_negotiate_signing, "Enable negotiating packet signing algorithm with server. Default: n/N/0");
+MODULE_PARM_DESC(enable_negotiate_signing,
+		 "(deprecated) Enable negotiating packet signing algorithm with the server. "
+		 "Default: always y/Y/1. Changing this setting no longer has any effect, cifs.ko "
+		 "will always try to negotiate the signing algorithm on SMB 3.1.1 mounts.");
 
 module_param(disable_legacy_dialects, bool, 0644);
 MODULE_PARM_DESC(disable_legacy_dialects, "To improve security it may be "
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0ce2ceaf039e..c1524e0ddad6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2015,7 +2015,8 @@ extern unsigned int global_secflags;	/* if on, session setup sent
 extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
 extern bool enable_gcm_256; /* allow optional negotiate of strongest signing (aes-gcm-256) */
 extern bool require_gcm_256; /* require use of strongest signing (aes-gcm-256) */
-extern bool enable_negotiate_signing; /* request use of faster (GMAC) signing if available */
+/* XXX: remove enable_negotiate_signing at some point */
+extern bool enable_negotiate_signing; /* (deprecated) request to use AES-GMAC signing if supported */
 extern bool linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
 extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
 extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 45215e4e6f37..d51dfe3bb163 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -614,14 +614,18 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 		neg_context_count++;
 	}
 
-	if (enable_negotiate_signing) {
-		ctxt_len = build_signing_ctxt((struct smb2_signing_capabilities *)
-				pneg_ctxt);
-		*total_len += ctxt_len;
-		pneg_ctxt += ctxt_len;
-		neg_context_count++;
+	if (!enable_negotiate_signing) {
+		pr_warn("cifs.ko loaded with param 'enable_negotiate_signing=0', but this parameter "
+			"is deprecated. Trying to negotiate signing capabilities anyway...");
+		enable_negotiate_signing = true;
 	}
 
+	ctxt_len = build_signing_ctxt((struct smb2_signing_capabilities *)
+			pneg_ctxt);
+	*total_len += ctxt_len;
+	pneg_ctxt += ctxt_len;
+	neg_context_count++;
+
 	/* check for and add transport_capabilities and signing capabilities */
 	req->NegotiateContextCount = cpu_to_le16(neg_context_count);
 }
@@ -818,8 +822,7 @@ static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
 	}
 
 	/*
-	 * Throw a warning if user requested signing to be negotiated, but it
-	 * wasn't.
+	 * Throw a warning if signing context was not negotiated.
 	 *
 	 * Some servers will not send a SMB2_SIGNING_CAPABILITIES context (*),
 	 * so we use AES-CMAC (default in smb311 ops) as it is expected to be
@@ -827,7 +830,7 @@ static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
 	 *
 	 * (*) see note "<125> Section 3.2.4.2.2.2" in MS-SMB2
 	 */
-	if (!server->signing_negotiated && enable_negotiate_signing)
+	if (!server->signing_negotiated)
 		cifs_dbg(VFS, "signing capabilities were not negotiated, using "
 			 "AES-CMAC for message signing\n");
 
-- 
2.35.3

