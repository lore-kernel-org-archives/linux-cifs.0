Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD761C6FA82
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 18:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiINSyZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Sep 2022 14:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiINSyY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Sep 2022 14:54:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C744E847
        for <linux-cifs@vger.kernel.org>; Wed, 14 Sep 2022 11:54:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9B99E33E7E;
        Wed, 14 Sep 2022 18:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663181661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=qsvqC+DE1Dty62ww5ICnSOA5/tp/INSgXRSzpDx6aoA=;
        b=SJiHLcgXbw3tUECHxzAD7jRD1ROMUsIUTFD47KlP8IM/C+BUIWYY40BFNWFdQEvRLhL4JF
        vpbSINMVo6Z+cOY9bWkhELN3aYFLOfoYbinE6VFIhLRt3a8av/5DbRpQtWlaufTMnzclZM
        43vcMdO4EYvtQuXULkCALsdYIacJskM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663181661;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=qsvqC+DE1Dty62ww5ICnSOA5/tp/INSgXRSzpDx6aoA=;
        b=v8/swdjQTKOku2PleS1Y4iLbTpPrJV/ICFC+KLUor9ULIxgPikStfwefcllKCY0Vyqwa2m
        mhqcEa5EG6DRRaAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1EDFC134B3;
        Wed, 14 Sep 2022 18:54:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KcLHNFwjImMWEwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 14 Sep 2022 18:54:20 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: dump_stack() only when non-interrupt error in AIO
Date:   Wed, 14 Sep 2022 15:54:17 -0300
Message-Id: <20220914185417.32509-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Int cifs_send_async_read() and cifs_write_from_iter(), check if rc is an
interrupt code and only call dump_stack() if it's not.

In SMB2_{read,write}, show a different error message if rc is an
interrupt code, as it gives more context to the users, e.g. the
operation was aborted by the user, so not really an error.

This can be observed when, e.g., running xfstests generic/208, where the
stack dump in ring buffer can be confusing, as the test actually passes.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/file.c    |  8 ++++++--
 fs/cifs/smb2pdu.c | 10 ++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6f38b134a346..e54c0144b71d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3278,7 +3278,9 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 					 "direct_writev couldn't get user pages (rc=%zd) iter type %d iov_offset %zd count %zd\n",
 					 result, iov_iter_type(from),
 					 from->iov_offset, from->count);
-				dump_stack();
+
+				if (!is_interrupt_error(result))
+					dump_stack();
 
 				rc = result;
 				add_credits_and_wake_if(server, credits, 0);
@@ -4018,7 +4020,9 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
 					 result, iov_iter_type(&direct_iov),
 					 direct_iov.iov_offset,
 					 direct_iov.count);
-				dump_stack();
+
+				if (!is_interrupt_error(result))
+					dump_stack();
 
 				rc = result;
 				add_credits_and_wake_if(server, credits, 0);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6352ab32c7e7..c9f5adc0d0d0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4313,7 +4313,10 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	if (rc) {
 		if (rc != -ENODATA) {
 			cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
-			cifs_dbg(VFS, "Send error in read = %d\n", rc);
+			if (is_interrupt_error(rc))
+				cifs_dbg(VFS, "Read interrupted (%d), aborting\n", rc);
+			else
+				cifs_dbg(VFS, "Send error in read, rc=%d\n", rc);
 			trace_smb3_read_err(xid,
 					    req->PersistentFileId,
 					    io_parms->tcon->tid, ses->Suid,
@@ -4656,7 +4659,10 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 				     io_parms->tcon->ses->Suid,
 				     io_parms->offset, io_parms->length, rc);
 		cifs_stats_fail_inc(io_parms->tcon, SMB2_WRITE_HE);
-		cifs_dbg(VFS, "Send error in write = %d\n", rc);
+		if (is_interrupt_error(rc))
+			cifs_dbg(VFS, "Write interrupted (%d), aborting\n", rc);
+		else
+			cifs_dbg(VFS, "Send error in write, rc=%d\n", rc);
 	} else {
 		*nbytes = le32_to_cpu(rsp->DataLength);
 		trace_smb3_write_done(xid,
-- 
2.35.3

