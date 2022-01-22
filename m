Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D19C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Jan 2022 17:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiAVRjV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Jan 2022 12:39:21 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:46726 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiAVRjU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 Jan 2022 12:39:20 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8245A1F380;
        Sat, 22 Jan 2022 17:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642873159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=EDgVTl8OuNCYSeHaFkj1HiE88I1lShAUUtTzSNoo9tk=;
        b=MuZl2qrolTBETXP08OjlH5qy74aEP4JfjQQKbft8QAQzuhLCEAfm98Ls3pL3YKCGli4zq7
        FKNsO+Wjs7PqVgc0cbFLs4Xv8zy3yjyGECrdCqBmwMmyQRQMZdYgOodmXNPGUfc2ebFFq+
        YI7TEoa2rHY8zgtYnU5PTedh05W8+60=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642873159;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=EDgVTl8OuNCYSeHaFkj1HiE88I1lShAUUtTzSNoo9tk=;
        b=n35ZnPIdJGk/syuclu7h9TfZlAXMLc9n22zaL3xh7jBXJeBs6WrXK4ss56EC6kCezFMv4w
        8ZLXADNE5SyjYSDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 14C2D13B04;
        Sat, 22 Jan 2022 17:39:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LkqvMEZB7GGxcgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sat, 22 Jan 2022 17:39:18 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] fix return-type warning in usm_handle_logout_request()
Date:   Sat, 22 Jan 2022 14:39:15 -0300
Message-Id: <20220122173915.3894-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Also put_ksmbd_user(user) before returning.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 lib/management/user.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/management/user.c b/lib/management/user.c
index b4727a761ba0..5ce75e83b70a 100644
--- a/lib/management/user.c
+++ b/lib/management/user.c
@@ -405,4 +405,7 @@ int usm_handle_logout_request(struct ksmbd_logout_request *req)
 		user->failed_login_count = 0;
 		user->flags &= ~KSMBD_USER_FLAG_DELAY_SESSION;
 	}
+
+	put_ksmbd_user(user);
+	return 0;
 }
-- 
2.31.1

