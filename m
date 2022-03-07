Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A5FC433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Mar 2022 01:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbiCGBf1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbiCGBf0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 6 Mar 2022 20:35:26 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB373ED2C
        for <linux-cifs@vger.kernel.org>; Sun,  6 Mar 2022 17:34:33 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 43CAD210ED;
        Mon,  7 Mar 2022 01:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646616872; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DdKnDshTPAmEuFG14WPqA2WfnB36v1ekAkXgEm8qzMA=;
        b=CjbBik6XUUTOLW06SGXBP+c8hqCFn78TXxj/jWzDFN1VCLAgdIrDMtX56agA9uQ8phZj9h
        JAR00S0tOoGvqCmnGJ/GzbV7BCzy26MLgshrcnyCX/vYfyKilaCN/FbbUL7xrcKB+mF7fn
        bTLhanf9S9y1cZAksoweF4fkNlxHICk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646616872;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DdKnDshTPAmEuFG14WPqA2WfnB36v1ekAkXgEm8qzMA=;
        b=oTc7yMKbV7o+2OJT4W1tF818UQ5mueUrVzyJpeBePh3/889FTA1EzuLAgDYF4x7Zx+TD/9
        83cOzd94gml3r/BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B897D1340A;
        Mon,  7 Mar 2022 01:34:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id d8VwHidhJWI+dAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 07 Mar 2022 01:34:31 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org
Cc:     senozhatsky@chromium.org, sergey.senozhatsky@gmail.com,
        hyc.lee@gmail.com, smfrench@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 7/9] daemon/rpc_samr: drop unused function rpc_samr_remove_domain_entry()
Date:   Sun,  6 Mar 2022 22:33:42 -0300
Message-Id: <20220307013344.29064-8-ematsumiya@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220307013344.29064-1-ematsumiya@suse.de>
References: <20220307013344.29064-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 daemon/rpc_samr.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/daemon/rpc_samr.c b/daemon/rpc_samr.c
index 396e38f58013..3e4b2d5dc95b 100644
--- a/daemon/rpc_samr.c
+++ b/daemon/rpc_samr.c
@@ -745,15 +745,6 @@ static int rpc_samr_add_domain_entry(char *name)
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
2.34.1

