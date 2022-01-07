Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 425D9C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jan 2022 22:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiAGWvt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jan 2022 17:51:49 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:54856 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbiAGWvt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jan 2022 17:51:49 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 578EC21115;
        Fri,  7 Jan 2022 22:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1641595908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=pYDhJvJQ6PCuJ52bPVbjFMSFXt7DX+qaYpy52ELaPVg=;
        b=MxR0WWQFwXa620mk8XpTfPCeW90HpE7jTGhnXH20nja0qtxr+Gk6adiM4aYhttsFmKp64W
        oBWG8F7OvjGu1JmF4iCwJknWoi6jSIFbDwki4eGukFsxtRASqC0Po6AZwQ6oSRrKZrPpy3
        SfJR7WEVE/l8/ew1EiohqRhat8BJNj8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1641595908;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=pYDhJvJQ6PCuJ52bPVbjFMSFXt7DX+qaYpy52ELaPVg=;
        b=laRG39iR2/1RzVcLe7m+DrSM5u+euKoUk3RFTrXI7KyW9UCYrWZ51W5sI3u79ruHp36d4Z
        zpdOqFr7GCX//SBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DD68A13D42;
        Fri,  7 Jan 2022 22:51:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ETSpKQPE2GGYMQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 07 Jan 2022 22:51:47 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, nspmangalore@gmail.com, pc@cjr.nz,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] cifs: fix hang on cifs_get_next_mid()
Date:   Fri,  7 Jan 2022 19:51:39 -0300
Message-Id: <20220107225139.15323-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Mount will hang if using SMB1 and DFS.

This is because every call to get_next_mid() will, unconditionally,
mark tcpStatus to CifsNeedReconnect before even establishing the
initial connect, because "reconnect" variable was not initialized.

Initializing "reconnect" to false fix this issue.

Fixes: 220c5bc25d87 ("cifs: take cifs_tcp_ses_lock for status checks")
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/smb1ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 54319a789c92..6364c09296e8 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -163,7 +163,7 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 {
 	__u64 mid = 0;
 	__u16 last_mid, cur_mid;
-	bool collision, reconnect;
+	bool collision, reconnect = false;
 
 	spin_lock(&GlobalMid_Lock);
 
-- 
2.34.1

