Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82983C3F6B0
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Aug 2022 19:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiHBTBR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Aug 2022 15:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbiHBTBK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Aug 2022 15:01:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97DE19C01;
        Tue,  2 Aug 2022 12:01:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8A6D920B18;
        Tue,  2 Aug 2022 19:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659466867; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x7CVA3ezN29fi8HTvDoRtpKit33X8WuLRCBguAgxowc=;
        b=uNhvWlezOigVUH1MN75hT1XM/sy7FezqNNsvOwODAg/Jp8ch3uaGh33HtxgrbLY64rtgcv
        13/cR0gWDC2mCdUB6HGs63mq6+a+f+SvrqRKBeTWeYSVpsx/vMHuTjNkcKY1GecMGPMgCN
        wbhZBJKMAK5o88I+npN5+kUqc8gRrwY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659466867;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x7CVA3ezN29fi8HTvDoRtpKit33X8WuLRCBguAgxowc=;
        b=OjOIXdUlLIX5/l2psdLXRkQLocg3vBzpUqAf7h6/gd851BETIutU9TZyuNkY3lmxTNNtAe
        T6oAy2s75C3RERCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 01E6013A8E;
        Tue,  2 Aug 2022 19:01:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kpjtLHJ06WL8XwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 02 Aug 2022 19:01:06 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tom@talpey.com,
        samba-technical@lists.samba.org, pshilovsky@samba.org,
        jlayton@kernel.org, rpenny@samba.org
Subject: [RFC PATCH v2 4/5] smbfs: update module description
Date:   Tue,  2 Aug 2022 16:00:47 -0300
Message-Id: <20220802190048.19881-5-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220802190048.19881-1-ematsumiya@suse.de>
References: <20220802190048.19881-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

More concise and direct description fits a new module name.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/core.c b/fs/smb/core.c
index 8b135c1cd5ae..4bc019ef90e2 100644
--- a/fs/smb/core.c
+++ b/fs/smb/core.c
@@ -1791,9 +1791,7 @@ exit_cifs(void)
 
 MODULE_AUTHOR("Steve French");
 MODULE_LICENSE("GPL");	/* combination of LGPL + GPL source behaves as GPL */
-MODULE_DESCRIPTION
-	("VFS to access SMB3 servers e.g. Samba, Macs, Azure and Windows (and "
-	"also older servers complying with the SNIA CIFS Specification)");
+MODULE_DESCRIPTION ("SMB client filesystem (supports SMB1, SMB2, and SMB3)");
 MODULE_VERSION(CIFS_VERSION);
 MODULE_SOFTDEP("ecb");
 MODULE_SOFTDEP("hmac");
-- 
2.35.3

