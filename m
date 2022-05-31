Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F17C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 31 May 2022 17:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346543AbiEaR10 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 May 2022 13:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiEaR1Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 May 2022 13:27:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47F45523C
        for <linux-cifs@vger.kernel.org>; Tue, 31 May 2022 10:27:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2F58E211C3;
        Tue, 31 May 2022 17:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654018042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=eRk1pPeMOnUShLvsqijsjDp+4pmIxOm2jFUpSW+Zl3I=;
        b=ZZ/17DtnYlUY1iu8JSD5GXoEH3k/0TPpYhWFSTCBUEo2970s9uDs3qK0XdMHtxGMaxvPu4
        nPrFDSzoCiYvvSdqpSEP9riLIXwsemTnAPYZQ/zoCjCkFzDvxPr+HJNkTzEHBDLMiHSkuB
        IhXRK4wh0vPymD8uOPDbCggpmPJQe3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654018042;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=eRk1pPeMOnUShLvsqijsjDp+4pmIxOm2jFUpSW+Zl3I=;
        b=jq24Y4IhlmqGvUoQQAIOSDv2V6Jabp9X9+Z4PYo1XyGcBqMQil9ErckzaZdRCpDGJSLvyp
        Fz++09vzCa5B9uAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AAAA213AA2;
        Tue, 31 May 2022 17:27:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fmvMG/lPlmKzDQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 31 May 2022 17:27:21 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] cifs: remove repeated debug message on cifs_put_smb_ses()
Date:   Tue, 31 May 2022 14:27:18 -0300
Message-Id: <20220531172718.12982-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/connect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 53373a3649e1..f54409f6370a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1845,7 +1845,6 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 	unsigned int rc, xid;
 	unsigned int chan_count;
 	struct TCP_Server_Info *server = ses->server;
-	cifs_dbg(FYI, "%s: ses_count=%d\n", __func__, ses->ses_count);
 
 	spin_lock(&cifs_tcp_ses_lock);
 	if (ses->ses_status == SES_EXITING) {
-- 
2.35.3

