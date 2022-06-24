Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB1FC43334
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Jun 2022 18:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiFXSB4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Jun 2022 14:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiFXSBy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Jun 2022 14:01:54 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9F04B419
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jun 2022 11:01:53 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 937E57FCF3;
        Fri, 24 Jun 2022 18:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1656093711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HPoPwINMH17EXdhulft6O4TTKn7Zx1Zib8ePVX97N1Y=;
        b=z4msH6r+4iSVMLizStBJDdRPFfD35NDmwJZV/RIUKnnZH7TrGkUrt6vSAiDAU5UXTnh0Q9
        3eFmwXIeI8B3YShXe19oh0NO5eG4g/Pt7Qay62PKDghr992jS3UFrNfiktJIaU5v+itSNZ
        o5k95PuqwE4oJnQqtPt/Ja+huusoKn0Gw4Z+N4SIjDwNY4+hDuem3olj1E3p+RQnn/BeeO
        58OgG3+6438v+JSkjZks69GW4YenGN9hpe/qYV1digTthOhybwoI7tenn71irzC1AZRvWJ
        Z13LAD455qu56bcRse1Pduqolch+Xb4ylNIuGkTWAIwT/lj1+/c5RZ8r7E66sw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: update cifs_ses::ip_addr after failover
Date:   Fri, 24 Jun 2022 15:01:43 -0300
Message-Id: <20220624180143.6062-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cifs_ses::ip_addr wasn't being updated in cifs_session_setup() when
reconnecting SMB sessions thus returning wrong value in
/proc/fs/cifs/DebugData.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e666d2643ede..b71928e5acf4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4016,10 +4016,16 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		   struct nls_table *nls_info)
 {
 	int rc = -ENOSYS;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
+	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
 	bool is_binding = false;
 
-
 	spin_lock(&cifs_tcp_ses_lock);
+	if (server->dstaddr.ss_family == AF_INET6)
+		scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI6", &addr6->sin6_addr);
+	else
+		scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI4", &addr->sin_addr);
+
 	if (ses->ses_status != SES_GOOD &&
 	    ses->ses_status != SES_NEW &&
 	    ses->ses_status != SES_NEED_RECON) {
-- 
2.36.1

