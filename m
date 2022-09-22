Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2786FC54EE9
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Sep 2022 22:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiIVWc6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 18:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiIVWc3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 18:32:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21293F392E
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 15:32:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BDDE11F8C4;
        Thu, 22 Sep 2022 22:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663885946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=pxeyW4zfMwOfZSzFdZnI2Rrbh5/G5biEJ4ZilT/LJtE=;
        b=2MSAw1xXJ4m85lfC+gg1AK1D1HuNZBm0zu/hc/dRitM1uvFil0pELmMuvlc5RHoZr6wz8b
        GkgKGjUU+wUGsa85IE0qRwuxjHWr/uK9Fk8UMoo6k5zsbpNOvxfRyJ4GZWmNO4IQIe2dfB
        68MZ6zPX6mQGbc61QnG9/9xaTJmyvI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663885946;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=pxeyW4zfMwOfZSzFdZnI2Rrbh5/G5biEJ4ZilT/LJtE=;
        b=ytrKypedvLOyDeC+b6tQEurR03hSS/5q6NRPzB5qEPtLaXkLQIGoxOaw2ndP3Q37E4aa9a
        Fy1gcgXlkBeVK1BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4054013AA5;
        Thu, 22 Sep 2022 22:32:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id g7dhAXriLGMvQgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 22 Sep 2022 22:32:26 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com
Subject: [RFC PATCH] cifs: fix signature check for error responses
Date:   Thu, 22 Sep 2022 19:32:16 -0300
Message-Id: <20220922223216.4730-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

This patch is the (apparent) correct way to fix the issues regarding some
messages with invalid signatures. My previous patch
https://lore.kernel.org/linux-cifs/20220918235442.2981-1-ematsumiya@suse.de/
was wrong because a) it covered up the real issue (*), and b) I could never
again "reproduce" the "race" -- I had other patches in place when I tested it,
and (thus?) the system memory was not in "pristine" conditions, so it's very
likely that there's no race at all.

(*) Thanks a lot to Tom Talpey for pointing me to the right direction here.

Since it sucks to be wrong twice, I'm sending this one as RFC because I
wanted to confirm some things:

  1) Can I rely on the fact that status != STATUS_SUCCESS means no variable
     data in the message?  I could only infer from the spec, but not really
     confirm.
  
  2) (probably only in async cases) When the signature fails, for whatever
     reason, we don't take any action.  This doesn't seem right IMHO,
     e.g. if the message is spoofed, we show a warning that the signatures
     doesn't match, but I would expect at least for the operation to stop,
     or maybe even a complete dis/reconnect.

  3) For SMB1, I couldn't really use generic/465 as a real confirmation for
     this because it says "O_DIRECT is not supported".  From reading the
     code and 'man mount.cifs' I understood that this is supported, so what
     gives?  Worth noting that I don't follow/use/test SMB1 too much.
     The patch does work for other cases I tried though.

I hope someone can address my questions/concerts above, and please let me
know if the patch is technically and semantically correct.

Patch follows.


Enzo

--------
When verifying a response's signature, the computation will go through
the iov buffer (header + response structs) and the over the page data, to
verify any dynamic data appended to the message (usually on an SMB2 READ
response).

When the response is an error, however, specifically on async reads,
the page data is allocated before receiving the expected data.  Being
"valid" data (from the signature computation POV; non-NULL, >0 pages),
it's included in the parsing and generates an invalid signature for the
message.

Fix this by checking if the status is non-zero, and skip the page data
if it is.  The issue happens in all protocol versions, and this fix
applies to all.

This issue can be observed with xfstests generic/465.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsencrypt.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 46f5718754f9..e3260bb436b3 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -32,15 +32,28 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 	int rc;
 	struct kvec *iov = rqst->rq_iov;
 	int n_vec = rqst->rq_nvec;
+	bool has_error = false;
 
 	/* iov[0] is actual data and not the rfc1002 length for SMB2+ */
 	if (!is_smb1(server)) {
+		struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
+
 		if (iov[0].iov_len <= 4)
 			return -EIO;
+
+		if (shdr->Status != 0)
+			has_error = true;
+
 		i = 0;
 	} else {
+		struct smb_hdr *hdr = (struct smb_hdr *)iov[1].iov_base;
+
 		if (n_vec < 2 || iov[0].iov_len != 4)
 			return -EIO;
+
+		if (hdr->Status.CifsError != 0)
+			has_error = true;
+
 		i = 1; /* skip rfc1002 length */
 	}
 
@@ -61,6 +74,9 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 		}
 	}
 
+	if (has_error)
+		goto out_final;
+
 	/* now hash over the rq_pages array */
 	for (i = 0; i < rqst->rq_npages; i++) {
 		void *kaddr;
@@ -81,6 +97,7 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 		kunmap(rqst->rq_pages[i]);
 	}
 
+out_final:
 	rc = crypto_shash_final(shash, signature);
 	if (rc)
 		cifs_dbg(VFS, "%s: Could not generate hash\n", __func__);
-- 
2.35.3

