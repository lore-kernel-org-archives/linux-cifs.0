Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D00C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 21:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2317B60ED8
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 21:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345078AbhIIVsG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:48:06 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40510 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhIIVsG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Sep 2021 17:48:06 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 013BE1FE36;
        Thu,  9 Sep 2021 21:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631224015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=KYEQfeb7GpLEDCgtN3fdOhil68NMIoT4dUWx2CTUaOM=;
        b=mwMdgObUrMFZuMH9wqCZ9lISzl9lK1Y0hbHv++uVjawAgYLlNI0XNt1Dz0h3ndDAeH0r3t
        tcEjX9lb3w2exIv3bRLS8QgPa/tyLSdwZRCgC55v77nVTktzU/9JMBEA4qkS9dUOBc+0Jj
        DNw7dfW383AesXmiJ7UjCiECRX+V9BI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631224015;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=KYEQfeb7GpLEDCgtN3fdOhil68NMIoT4dUWx2CTUaOM=;
        b=4YH6kkMWx6y1VDuFj5jpY4ZACjleOt5hnhQ+r+csyCYbHdrqNQdFQF/xVswSadDeshciNc
        NcCbO0zK2vS8ldDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 87A9113CDF;
        Thu,  9 Sep 2021 21:46:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id csSOFM6AOmGAbwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 09 Sep 2021 21:46:54 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     pc@cjr.nz, Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <sfrench@samba.org>,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: properly invalidate cached root handle when closing it
Date:   Thu,  9 Sep 2021 18:46:45 -0300
Message-Id: <20210909214646.8790-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Cached root file was not being completely invalidated sometimes.

Reproducing:
- With a DFS share with 2 targets, one disabled and one enabled
- start some I/O on the mount
  # while true; do ls /mnt/dfs; done
- at the same time, disable the enabled target and enable the disabled
  one
- wait for DFS cache to expire
- on reconnect, the previous cached root handle should be invalid, but
  open_cached_dir_by_dentry() will still try to use it, but throws a
  use-after-free warning (kref_get())

Make smb2_close_cached_fid() invalidate all fields every time, but only
send an SMB2_close() when the entry is still valid.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/smb2ops.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 2dfd0d8297eb..1b9de38a136a 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -689,13 +689,19 @@ smb2_close_cached_fid(struct kref *ref)
 		cifs_dbg(FYI, "clear cached root file handle\n");
 		SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
 			   cfid->fid->volatile_fid);
-		cfid->is_valid = false;
-		cfid->file_all_info_is_valid = false;
-		cfid->has_lease = false;
-		if (cfid->dentry) {
-			dput(cfid->dentry);
-			cfid->dentry = NULL;
-		}
+	}
+
+	/*
+	 * We only check validity above to send SMB2_close,
+	 * but we still need to invalidate these entries
+	 * when this function is called
+	 */
+	cfid->is_valid = false;
+	cfid->file_all_info_is_valid = false;
+	cfid->has_lease = false;
+	if (cfid->dentry) {
+		dput(cfid->dentry);
+		cfid->dentry = NULL;
 	}
 }
 
-- 
2.33.0

