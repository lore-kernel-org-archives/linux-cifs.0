Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D574AC43334
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jun 2022 21:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiFHVzO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Jun 2022 17:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiFHVzN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Jun 2022 17:55:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFE67CDD4
        for <linux-cifs@vger.kernel.org>; Wed,  8 Jun 2022 14:55:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 2AD1B1F460;
        Wed,  8 Jun 2022 21:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654725311; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zbHMkHKx6aAOYrp+F+57t5Ha0/TI11vNRjjQnU9GEQY=;
        b=mlDD7rS0FVjn9fpBUqRoreFHHqP2OgBjs03gUtonSKu/86G9sEr+f/pGUXPaO08+aMmCUf
        Xh9tK8GoKxcf2jZlcm/pLMcAPQ5ICMfxlyaIN3HghSFLejRrh9B2vpc25UtsCQmr/bq+9v
        noRkLpGnFleu55X1oW2fm5CpdCV5TYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654725311;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zbHMkHKx6aAOYrp+F+57t5Ha0/TI11vNRjjQnU9GEQY=;
        b=BLYtSu1xR+FDt4csi5tEu/8YJo/7i1A9D8cQgA0el8iCP3+bEyPB8sVo5E/wUaI7XRFUUv
        Ch7tGXpQpgEn4rDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9D11D13AD9;
        Wed,  8 Jun 2022 21:55:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ryOFF74aoWKqFwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 08 Jun 2022 21:55:10 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 2/2] cifs: reschedule DNS resolve worker based on dns_interval
Date:   Wed,  8 Jun 2022 18:54:44 -0300
Message-Id: <20220608215444.1216-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608215444.1216-1-ematsumiya@suse.de>
References: <20220608215444.1216-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch makes use of the dns_interval introduced in the previous
commit when re/scheduling the resolve worker.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/connect.c     | 4 ++--
 fs/cifs/dns_resolve.c | 8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 06bafba9c3ff..edd4f0020f9c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -92,7 +92,7 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 	int len;
 	char *unc, *ipaddr = NULL;
 	time64_t expiry, now;
-	unsigned long ttl = SMB_DNS_RESOLVE_INTERVAL_DEFAULT;
+	unsigned long ttl = dns_interval;
 
 	if (!server->hostname ||
 	    server->hostname[0] == '\0')
@@ -130,7 +130,7 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 			 * To make sure we don't use the cached entry, retry 1s
 			 * after expiry.
 			 */
-			ttl = max_t(unsigned long, expiry - now, SMB_DNS_RESOLVE_INTERVAL_MIN) + 1;
+			ttl = max_t(unsigned long, expiry - now, dns_interval) + 1;
 	}
 	rc = !rc ? -1 : 0;
 
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 0458d28d71aa..eff1e61180ed 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -67,6 +67,14 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr, time64_t *expiry)
 	/* Perform the upcall */
 	rc = dns_query(current->nsproxy->net_ns, NULL, hostname, len,
 		       NULL, ip_addr, expiry, false);
+
+	/*
+	 * If the upcall didn't get a TTL, we use the value from dns_interval
+	 * procfs setting
+	 */
+	if (expiry && *expiry == 0)
+		*expiry = dns_interval;
+
 	if (rc < 0)
 		cifs_dbg(FYI, "%s: unable to resolve: %*.*s\n",
 			 __func__, len, len, hostname);
-- 
2.36.1

