Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99561C32772
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 16:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242729AbiHWQr2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 12:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344021AbiHWQqf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 12:46:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5C296FE3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 07:26:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E425D336D1;
        Tue, 23 Aug 2022 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661264768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=kQP8V5IHNCXmxxLJYAcDWDNJasSurZgnEWXuF+pFeVI=;
        b=0B4+ZyQFTqns4R415hzuKXRBGqqx7LOYNc2sJbXROgubqwahgLn6eNdonEpnLsECWpyGjc
        CtDqGRNILlOeD5s0CMx8zJbkPU8tSVKSwQodOF1VRR17gbg6Svm5ATdk0J5b5RNMj5Cf2q
        593PLIggp4M02rAIm0C6IiBqDd5fEMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661264768;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=kQP8V5IHNCXmxxLJYAcDWDNJasSurZgnEWXuF+pFeVI=;
        b=CM9m50f5c+tMpJZQwpJs3Dx4DEz+bA20KdANWtmv9vdewgfwYxIgERz7hn0z99e8DMUswd
        nBCnVZeLAKSJ7IBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 655D113AB7;
        Tue, 23 Aug 2022 14:26:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OhdyCoDjBGOifwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 23 Aug 2022 14:26:08 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: set 'caps' variable as __maybe_unused in cifs_ioctl()
Date:   Tue, 23 Aug 2022 11:26:03 -0300
Message-Id: <20220823142603.9126-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The variable is only used when
CONFIG_CIFS_ALLOW_INSECURE_LEGACY && CONFIG_CIFS_POSIX.

Mark it as "__maybe_unused" (instead of ifdef'ing it).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index b6e6e5d6c8dd..5d5d7de793d9 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -321,7 +321,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb;
 	__u64	ExtAttrBits = 0;
-	__u64   caps;
+	__u64   caps __maybe_unused; /* SMB1+UNIX only */
 
 	xid = get_xid();
 
-- 
2.35.3

