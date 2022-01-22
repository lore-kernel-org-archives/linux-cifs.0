Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755C4C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 22 Jan 2022 17:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbiAVRjf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Jan 2022 12:39:35 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:46736 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiAVRje (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 Jan 2022 12:39:34 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 528451F380;
        Sat, 22 Jan 2022 17:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642873173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=aq2wZtyUcid+/DJ0abP/95N12stf4XraHSsMb4ynJIk=;
        b=AK6c7cYLDGBB2x9Fc1ZcVn/1MnSyR7bw2nb5mHXL6jRw1Yk7yiLE3ZsXpQ3pjJ0b9OiLjl
        aX4TTYkwjo9N7RmGWoX4QumBOoNcHLmyKHh6sA/mnA4alFuxkQ/e9ndQ9gHWTTUbkxswPu
        HZESnAYRCUIPvoYrah3tLzmAkW7t+rk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642873173;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=aq2wZtyUcid+/DJ0abP/95N12stf4XraHSsMb4ynJIk=;
        b=QYzciGvk5KX59R3/xkgkBa+UnBNo+vmv9M5WmnmfyrkIImhr6/4Pt9L6xs11S8gmkCD0HE
        vo49wRHIjm5JKVAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D44F813B04;
        Sat, 22 Jan 2022 17:39:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dExQJ1RB7GHDcgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sat, 22 Jan 2022 17:39:32 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH] mountd/rpc_samr: drop unused function rpc_samr_remove_domain_entry()
Date:   Sat, 22 Jan 2022 14:39:28 -0300
Message-Id: <20220122173928.3979-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 mountd/rpc_samr.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/mountd/rpc_samr.c b/mountd/rpc_samr.c
index 95c607c101a3..7fe942cf3f08 100644
--- a/mountd/rpc_samr.c
+++ b/mountd/rpc_samr.c
@@ -744,15 +744,6 @@ static int rpc_samr_add_domain_entry(char *name)
 	return 0;
 }
 
-static void rpc_samr_remove_domain_entry(unsigned int eidx)
-{
-	gpointer entry;
-
-	entry = g_array_index(domain_entries, gpointer, eidx);
-	domain_entries = g_array_remove_index(domain_entries, eidx);
-	free(entry);
-}
-
 static void domain_entry_free(void *v)
 {
 	char **entry = v;
-- 
2.31.1

