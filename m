Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95400C32771
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 01:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiI2B5c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 21:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbiI2B5b (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 21:57:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEB174B8A
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 18:57:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7F2A71F74D;
        Thu, 29 Sep 2022 01:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664416649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fZl/z/ffrSVkQ/fuWDk+YuPSfXwqwBVlcSk60issN8Y=;
        b=1R9tMXj6TmP2H1FutNrYaG8GHgceWfq9Wsvpoc4oF3kKOPa8R5129XnP4vc1vDeLUr1rPr
        8ZfDTSWFYQAcmqbuGgF6KcbDQ5aXeqBwYrdLRMG48ax1FclFL8BNsR9nhF8inQhRhya0Kc
        5L5VhLtnE63WcYEwU0syEsJoWYiOCQo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664416649;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fZl/z/ffrSVkQ/fuWDk+YuPSfXwqwBVlcSk60issN8Y=;
        b=P9lThxkFfAmXoiPU86jfGgj1uberQQGg1mdPZqrQ2/hJb3ZTYEjvJ5zBz5mdKMGqYaGwLx
        vo158yj/oa0lqTBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F0555139B3;
        Thu, 29 Sep 2022 01:57:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id goOYK4j7NGOjeQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 01:57:28 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: [PATCH v3 8/8] cifs: use MAX_CIFS_SMALL_BUFFER_SIZE-8 as padding buffer
Date:   Wed, 28 Sep 2022 22:56:37 -0300
Message-Id: <20220929015637.14400-9-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220929015637.14400-1-ematsumiya@suse.de>
References: <20220929015637.14400-1-ematsumiya@suse.de>
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
For now, only used in smb2_set_next_command().

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/smb2ops.c | 7 +++++--
 fs/cifs/smb2pdu.c | 9 +++++----
 fs/cifs/smb2pdu.h | 2 --
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 22b40d181bba..0b8497e1c747 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2323,7 +2323,10 @@ smb2_set_related(struct smb_rqst *rqst)
 	shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
 }
 
-char smb2_padding[7] = {0, 0, 0, 0, 0, 0, 0};
+/*
+ * Use the last 8 bytes of the small buf as the padding buffer, when necessary
+ */
+#define SMB2_PADDING_BUF(buf) (buf + MAX_CIFS_SMALL_BUFFER_SIZE - 8)
 
 void
 smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
@@ -2352,7 +2355,7 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 		 * If we do not have encryption then we can just add an extra
 		 * iov for the padding.
 		 */
-		rqst->rq_iov[rqst->rq_nvec].iov_base = smb2_padding;
+		rqst->rq_iov[rqst->rq_nvec].iov_base = SMB2_PADDING_BUF(rqst->rq_iov[0].iov_base);
 		rqst->rq_iov[rqst->rq_nvec].iov_len = num_padding;
 		rqst->rq_nvec++;
 		len += num_padding;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6c22ead51feb..fca1b580d57d 100644
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
 
@@ -2993,8 +2996,7 @@ SMB2_open_free(struct smb_rqst *rqst)
 	if (rqst && rqst->rq_iov) {
 		cifs_small_buf_release(rqst->rq_iov[0].iov_base);
 		for (i = 1; i < rqst->rq_nvec; i++)
-			if (rqst->rq_iov[i].iov_base != smb2_padding)
-				kfree(rqst->rq_iov[i].iov_base);
+			kfree(rqst->rq_iov[i].iov_base);
 	}
 }
 
@@ -3187,8 +3189,7 @@ SMB2_ioctl_free(struct smb_rqst *rqst)
 	if (rqst && rqst->rq_iov) {
 		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
 		for (i = 1; i < rqst->rq_nvec; i++)
-			if (rqst->rq_iov[i].iov_base != smb2_padding)
-				kfree(rqst->rq_iov[i].iov_base);
+			kfree(rqst->rq_iov[i].iov_base);
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

