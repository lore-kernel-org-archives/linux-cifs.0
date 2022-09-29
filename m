Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C39C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 17:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbiI2R5V (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 13:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbiI2R5S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 13:57:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DCCF50B5
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 10:57:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 15DD01F8E0;
        Thu, 29 Sep 2022 17:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664474236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pyYFV0GURIhmZ2KViTBUZMXRtS4strsrdpTJyfb+JE0=;
        b=G44p40algeW7mU067J5nLKy9yDmD4hQ6YEmxRJWMVGGEZyBRMGMnYi7o01sBuGtNQ/SPuW
        fibZp3W2wa34djezQABNtu+pPrcLDPlaYZTlToCQT2I2XJhYeevTqktSTVZaPhAkf/eaLB
        llu6FD/voob6Gu5OYqwjI0J/lTjqLRI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664474236;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pyYFV0GURIhmZ2KViTBUZMXRtS4strsrdpTJyfb+JE0=;
        b=EPapUyrxoDM9Y7TD4CuuIHs1OjrE6T2It8C2Fjf7CchgVM6yRdp5ULymPzpZeCUo4bQYHo
        cDQFT3n/TXxjKUCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 83A161348E;
        Thu, 29 Sep 2022 17:57:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RazGEHvcNWPqFQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 17:57:15 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: [PATCH v4 6/8] cifs: deprecate 'enable_negotiate_signing' module param
Date:   Thu, 29 Sep 2022 14:56:54 -0300
Message-Id: <20220929175655.6906-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220929175655.6906-1-ematsumiya@suse.de>
References: <20220929175655.6906-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Deprecate enable_negotiate_signing module parameter as it's irrelevant
since the requested dialect and server support will dictate which
algorithm will actually be used.

Send a negotiate signing context on every SMB 3.1.1 negotiation now.
AES-CMAC will still be used instead, iff, SMB 3.0.x negotiated or
SMB 3.1.1 negotiated, but server doesn't support AES-GMAC.

Warn the user if, for whatever reason, the module was loaded with
'enable_negotiate_signing=0'.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v4: fix checkpatch errors (thanks to Steve)

 fs/cifs/cifsfs.c   | 14 +++++++++++---
 fs/cifs/cifsglob.h |  5 ++++-
 fs/cifs/smb2pdu.c  | 11 ++++-------
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8042d7280dec..c46dc9edf6ec 100644
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
 
-module_param(enable_negotiate_signing, bool, 0644);
-MODULE_PARM_DESC(enable_negotiate_signing, "Enable negotiating packet signing algorithm with server. Default: n/N/0");
+/* XXX: remove this at some point */
+module_param(enable_negotiate_signing, bool, 0);
+MODULE_PARM_DESC(enable_negotiate_signing,
+		 "(deprecated) Enable negotiating packet signing algorithm with the server. "
+		 "This parameter is ignored as cifs.ko will always try to negotiate the signing "
+		 "algorithm on SMB 3.1.1 mounts.");
 
 module_param(disable_legacy_dialects, bool, 0644);
 MODULE_PARM_DESC(disable_legacy_dialects, "To improve security it may be "
@@ -1712,6 +1716,10 @@ init_cifs(void)
 		goto out_init_cifs_idmap;
 	}
 
+	if (!enable_negotiate_signing)
+		pr_warn_once("ignoring deprecated module parameter 'enable_negotiate_signing=0', "
+			     "will try to negotiate signing capabilities anyway...\n");
+
 	return 0;
 
 out_init_cifs_idmap:
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 81a8eff06467..49561e325412 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2031,7 +2031,10 @@ extern unsigned int global_secflags;	/* if on, session setup sent
 extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
 extern bool enable_gcm_256; /* allow optional negotiate of strongest signing (aes-gcm-256) */
 extern bool require_gcm_256; /* require use of strongest signing (aes-gcm-256) */
-extern bool enable_negotiate_signing; /* request use of faster (GMAC) signing if available */
+extern bool enable_negotiate_signing; /*
+				       * request use of faster (GMAC) signing if available
+				       * XXX: deprecated, remove it at some point
+				       */
 extern bool linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
 extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
 extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index d7d6cbe6ba3b..785465873422 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -609,13 +609,10 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 		neg_context_count++;
 	}
 
-	if (enable_negotiate_signing) {
-		ctxt_len = build_signing_ctxt((struct smb2_signing_capabilities *)
-				pneg_ctxt);
-		*total_len += ctxt_len;
-		pneg_ctxt += ctxt_len;
-		neg_context_count++;
-	}
+	ctxt_len = build_signing_ctxt((struct smb2_signing_capabilities *)pneg_ctxt);
+	*total_len += ctxt_len;
+	pneg_ctxt += ctxt_len;
+	neg_context_count++;
 
 	/* check for and add transport_capabilities and signing capabilities */
 	req->NegotiateContextCount = cpu_to_le16(neg_context_count);
-- 
2.35.3

