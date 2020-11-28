Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED96AC63777
	for <linux-cifs@archiver.kernel.org>; Sat, 28 Nov 2020 22:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 873EF2344C
	for <linux-cifs@archiver.kernel.org>; Sat, 28 Nov 2020 22:04:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="hydlgyxF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390118AbgK1Vuo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:44 -0500
Received: from mx.cjr.nz ([51.158.111.142]:22016 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387611AbgK1Ty6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 28 Nov 2020 14:54:58 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id C06507FD5F;
        Sat, 28 Nov 2020 19:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1606593256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=avdO6UaE0CIg4N5gKGDuIfmF4y8Ebc66cY/54BVmhyc=;
        b=hydlgyxFLl/5NJnbGr0GEsFx0fr/+wQ4sfy0sgfOnRP1GA2ldC5AlcW57N4/69TJ5gzBlF
        nkF4bVg3dewrce3eOOEO9DQJk+wHt+p86LoUL8UwrFo5kPim3JSphUyzyaXjvavAeYXzTl
        lkE7cvX+ZvzBWTCtHe7Q7CiuwQiUY9S6Vl/sq/qUcPHaW2rYh8SMwA7yYZTrgHoNpFb19G
        e8x48/eJ+ZFE0zqhojwysLP2bHb+ihZIx2t5eHIdlFH6qG21o3/OtD2Cm/UQmRy6i9RcW6
        AgBrlEtqz86Kan1K0sCvCYkzy//ACshWoYGKB+bAbsMITeEjpP8iTvDglhPMYA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: fix potential use-after-free in cifs_echo_request()
Date:   Sat, 28 Nov 2020 16:54:02 -0300
Message-Id: <20201128195402.12233-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch fixes a potential use-after-free bug in
cifs_echo_request().

For instance,

  thread 1
  --------
  cifs_demultiplex_thread()
    clean_demultiplex_info()
      kfree(server)

  thread 2 (workqueue)
  --------
  apic_timer_interrupt()
    smp_apic_timer_interrupt()
      irq_exit()
        __do_softirq()
          run_timer_softirq()
            call_timer_fn()
  	      cifs_echo_request() <- use-after-free in server ptr

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c38156f324dd..28c1459fb0fc 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -876,6 +876,8 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	list_del_init(&server->tcp_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
+	cancel_delayed_work_sync(&server->echo);
+
 	spin_lock(&GlobalMid_Lock);
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&GlobalMid_Lock);
-- 
2.29.2

