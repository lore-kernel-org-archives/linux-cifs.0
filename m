Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62E1C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 17:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiI2R50 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 13:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbiI2R5W (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 13:57:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456631E05E0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 10:57:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 85D5821BBD;
        Thu, 29 Sep 2022 17:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664474239; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l36NagjY4i3eUkSR7rZMTVuIGsNsf+5xjTAjof7bQ5M=;
        b=pFsgjFsrj5y7Yj21Cn5VGMrEC6HH/BaHij/YYTfGBhgHOsMQ+it5wKoL6d2s5lw5mWCJgg
        /HNl3iXUNn8FaNY62lAR0skdcdaKtrfYh5h6jVqa9BqBmr/AlNFxrnlxBIFkt+4I9hHDx8
        X370/NVZyYpoYW2ASP8Q3dtiMCfCj/4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664474239;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l36NagjY4i3eUkSR7rZMTVuIGsNsf+5xjTAjof7bQ5M=;
        b=vyn+aFq2OhDTtr0Y4tbljPvVZFYoDxGOulJAaiVPbzr7t4uGIwwOqdQI7aoMUAw1oo32Ga
        exatH8gG323NuXAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A58B1348E;
        Thu, 29 Sep 2022 17:57:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id gj/QL37cNWP0FQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 17:57:18 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: [PATCH v4 8/8] cifs: use MAX_CIFS_SMALL_BUFFER_SIZE-8 as padding buffer
Date:   Thu, 29 Sep 2022 14:56:55 -0300
Message-Id: <20220929175655.6906-4-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220929175655.6906-1-ematsumiya@suse.de>
References: <20220929175655.6906-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

AES-GMAC is more picky about buffers locality, alignment, and size, so
we can't use a stack-allocated buffer as padding (smb2_padding).

This commit drops smb2_padding and "reserves" the 8 last bytes of each
small buffer, which are slab-allocated, as the padding buffer space.

Introduce SMB2_PADDING_BUF(buf) macro to easily grab the padding buffer.
For now, only used by smb2_set_next_command().

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v4:
  - move SMB2_PADDING_BUF to smb2glob.h
  - check if iov is SMB2_PADDING_BUF in the free functions where
    smb2_padding was previously used (pointed out by metze)

 fs/cifs/smb2glob.h | 5 +++++
 fs/cifs/smb2ops.c  | 4 +---
 fs/cifs/smb2pdu.c  | 9 +++++++--
 fs/cifs/smb2pdu.h  | 2 --
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 3a3e81b1b8cb..f3dd39c9be97 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -41,6 +41,11 @@
 #define END_OF_CHAIN 4
 #define RELATED_REQUEST 8
 
+/*
+ * Use the last 8 bytes of the small buf as the padding buffer, when necessary
+ */
+#define SMB2_PADDING_BUF(buf) (buf + MAX_CIFS_SMALL_BUFFER_SIZE - 8)
+
 static inline const char *smb2_signing_algo_str(u16 algo)
 {
 	switch (algo) {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e08065103b61..571961ca61ff 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2323,8 +2323,6 @@ smb2_set_related(struct smb_rqst *rqst)
 	shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
 }
 
-char smb2_padding[7] = {0, 0, 0, 0, 0, 0, 0};
-
 void
 smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 {
@@ -2352,7 +2350,7 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 		 * If we do not have encryption then we can just add an extra
 		 * iov for the padding.
 		 */
-		rqst->rq_iov[rqst->rq_nvec].iov_base = smb2_padding;
+		rqst->rq_iov[rqst->rq_nvec].iov_base = SMB2_PADDING_BUF(rqst->rq_iov[0].iov_base);
 		rqst->rq_iov[rqst->rq_nvec].iov_len = num_padding;
 		rqst->rq_nvec++;
 		len += num_padding;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 97dac970cd52..a4da04472377 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -362,6 +362,9 @@ fill_small_buf(__le16 smb2_command, struct cifs_tcon *tcon,
 	/*
 	 * smaller than SMALL_BUFFER_SIZE but bigger than fixed area of
 	 * largest operations (Create)
+	 *
+	 * Note that the last 8 bytes of the small buffer are reserved for padding when required
+	 * (see SMB2_PADDING_BUF in smb2ops.c)
 	 */
 	memset(buf, 0, 256);
 
@@ -2992,7 +2995,8 @@ SMB2_open_free(struct smb_rqst *rqst)
 	if (rqst && rqst->rq_iov) {
 		cifs_small_buf_release(rqst->rq_iov[0].iov_base);
 		for (i = 1; i < rqst->rq_nvec; i++)
-			if (rqst->rq_iov[i].iov_base != smb2_padding)
+			if (rqst->rq_iov[i].iov_base !=
+			    SMB2_PADDING_BUF(rqst->rq_iov[0].iov_base))
 				kfree(rqst->rq_iov[i].iov_base);
 	}
 }
@@ -3186,7 +3190,8 @@ SMB2_ioctl_free(struct smb_rqst *rqst)
 	if (rqst && rqst->rq_iov) {
 		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
 		for (i = 1; i < rqst->rq_nvec; i++)
-			if (rqst->rq_iov[i].iov_base != smb2_padding)
+			if (rqst->rq_iov[i].iov_base !=
+			    SMB2_PADDING_BUF(rqst->rq_iov[0].iov_base))
 				kfree(rqst->rq_iov[i].iov_base);
 	}
 }
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index f57881b8464f..689973a3acbb 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -371,8 +371,6 @@ struct smb2_file_id_extd_directory_info {
 	char FileName[1];
 } __packed; /* level 60 */
 
-extern char smb2_padding[7];
-
 /* equivalent of the contents of SMB3.1.1 POSIX open context response */
 struct create_posix_rsp {
 	u32 nlink;
-- 
2.35.3

