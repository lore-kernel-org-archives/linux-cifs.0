Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE00C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 18 May 2022 14:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238746AbiEROme (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 May 2022 10:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238718AbiEROmd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 May 2022 10:42:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B5BB36CD
        for <linux-cifs@vger.kernel.org>; Wed, 18 May 2022 07:42:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 30C791F8C9;
        Wed, 18 May 2022 14:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652884951; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3EPCYhVjr8csqpAQ8Tp8LE6Z9p75mfTNxEtuuYLlEsA=;
        b=brj7UxNRH0z1HGiD6fGvfpfXmHuqmvtuY+ZNAGyaHCp35dViwcmZANPc77XI9WBhssI4xr
        i4T16ODYyojBQzWMB0TQ2cD/tM+MyiLOKRRWyILK8ZGRf83fgKVFXJNeGJG7EBWH0WP4wJ
        wT9AQqOgaCpqKJpSBu0zeYPPf5B6njA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652884951;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3EPCYhVjr8csqpAQ8Tp8LE6Z9p75mfTNxEtuuYLlEsA=;
        b=IurJBhAx6wp9RcbmBGDglkxtI7gBWKXeCVdIRVc4lNTt0rqVNg5PfaH6nRHGfhSSZUzJ0I
        1/5h+UnOJ9yA3iDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E1C7133F5;
        Wed, 18 May 2022 14:42:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sT4gF9YFhWJ2NQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 18 May 2022 14:42:30 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] cifs: print TIDs as hex
Date:   Wed, 18 May 2022 11:41:04 -0300
Message-Id: <20220518144105.21913-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518144105.21913-1-ematsumiya@suse.de>
References: <20220518144105.21913-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/connect.c  | 2 +-
 fs/cifs/smb2misc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9cd866d929a9..f3b165413ab7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1789,7 +1789,7 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 		goto out;
 	}
 
-	cifs_dbg(FYI, "IPC tcon rc = %d ipc tid = %d\n", rc, tcon->tid);
+	cifs_dbg(FYI, "IPC tcon rc=%d ipc tid=0x%x\n", rc, tcon->tid);
 
 	ses->tcon_ipc = tcon;
 out:
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 3fe47a88f47d..15b5d2565e79 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -798,7 +798,7 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 		if (tcon->ses)
 			server = tcon->ses->server;
 
-		cifs_server_dbg(FYI, "tid=%u: tcon is closing, skipping async close retry of fid %llu %llu\n",
+		cifs_server_dbg(FYI, "tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",
 				tcon->tid, persistent_fid, volatile_fid);
 
 		return 0;
-- 
2.36.1

