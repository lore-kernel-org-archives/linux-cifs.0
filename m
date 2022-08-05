Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA34C25B08
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Aug 2022 14:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238570AbiHEOry (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Aug 2022 10:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237177AbiHEOrx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Aug 2022 10:47:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68B11EC56
        for <linux-cifs@vger.kernel.org>; Fri,  5 Aug 2022 07:47:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 744A11FE65;
        Fri,  5 Aug 2022 14:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659710871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R7STCyxNDzApob+Gbk/ljeGrQvenu52FcxXLazlGzc4=;
        b=NGVURkbly/So7uDbt05/sm85dCYSmMO4yTSHo+iqifoZdRlRQZY0zKI+8P2TrHJFAUPEE8
        gdephCJcxnw5t1nhfWKoaxm6Zg/NJ6cNMLWS4Zw8MT+nKArZ0JQQljdEBn4FeKnU7Pq5pG
        GxSyFG8nOJpBkHGULfawmFvKDUNZihU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659710871;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R7STCyxNDzApob+Gbk/ljeGrQvenu52FcxXLazlGzc4=;
        b=nVeHmStH+iLXTZiXVNM7z/iUWUitvc0Oan6Xbk/0vIo6P52W9ASG1lE5y0n7vLq+f/QCZ3
        IWVsX/1MzFRqmSAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E4F3D13A9C;
        Fri,  5 Aug 2022 14:47:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cm8gKZYt7WIRTwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 05 Aug 2022 14:47:50 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH v2 2/2] cifs: remove "cifs_" prefix from init/destroy mids functions
Date:   Fri,  5 Aug 2022 11:47:39 -0300
Message-Id: <20220805144739.27641-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220805144739.27641-1-ematsumiya@suse.de>
References: <20220805144739.27641-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rename generic mid functions to same style, i.e. without "cifs_"
prefix.

cifs_{init,destroy}_mids() -> {init,destroy}_mids()

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsfs.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index af4c5632490e..8849f0852110 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1568,8 +1568,7 @@ cifs_destroy_request_bufs(void)
 	kmem_cache_destroy(cifs_sm_req_cachep);
 }
 
-static int
-cifs_init_mids(void)
+static int init_mids(void)
 {
 	cifs_mid_cachep = kmem_cache_create("cifs_mpx_ids",
 					    sizeof(struct mid_q_entry), 0,
@@ -1587,8 +1586,7 @@ cifs_init_mids(void)
 	return 0;
 }
 
-static void
-cifs_destroy_mids(void)
+static void destroy_mids(void)
 {
 	mempool_destroy(cifs_mid_poolp);
 	kmem_cache_destroy(cifs_mid_cachep);
@@ -1685,7 +1683,7 @@ init_cifs(void)
 	if (rc)
 		goto out_destroy_deferredclose_wq;
 
-	rc = cifs_init_mids();
+	rc = init_mids();
 	if (rc)
 		goto out_destroy_inodecache;
 
@@ -1742,7 +1740,7 @@ init_cifs(void)
 #endif
 	cifs_destroy_request_bufs();
 out_destroy_mids:
-	cifs_destroy_mids();
+	destroy_mids();
 out_destroy_inodecache:
 	cifs_destroy_inodecache();
 out_destroy_deferredclose_wq:
@@ -1778,7 +1776,7 @@ exit_cifs(void)
 	dfs_cache_destroy();
 #endif
 	cifs_destroy_request_bufs();
-	cifs_destroy_mids();
+	destroy_mids();
 	cifs_destroy_inodecache();
 	destroy_workqueue(deferredclose_wq);
 	destroy_workqueue(cifsoplockd_wq);
-- 
2.35.3

