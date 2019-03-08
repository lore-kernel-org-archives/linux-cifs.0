Return-Path: <SRS0=c5gJ=RL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB26AC43381
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Mar 2019 03:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79BB020840
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Mar 2019 03:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfCHDe6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Mar 2019 22:34:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58130 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfCHDe6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 7 Mar 2019 22:34:58 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C80523084244;
        Fri,  8 Mar 2019 03:34:57 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-95.bne.redhat.com [10.64.54.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 301325D786;
        Fri,  8 Mar 2019 03:34:56 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 4/6] cifs: prevent starvation in wait_for_free_credits for multi-credit requests
Date:   Fri,  8 Mar 2019 12:58:21 +1000
Message-Id: <20190308025823.24382-5-lsahlber@redhat.com>
In-Reply-To: <20190308025823.24382-1-lsahlber@redhat.com>
References: <20190308025823.24382-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 08 Mar 2019 03:34:57 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reserve the last MAX_COMPOUND credits for any request asking for >1 credit.
This is to prevent future compound requests from becoming starved while waiting
for potentially many requests is there is a large number of concurrent
singe-credit requests.

However, we need to protect from servers that are very slow to hand out
new credits on new sessions so we only do this IFF there are 2*MAX_COMPOUND
(arbitrary) credits already in flight.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/transport.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index baf15194aa3d..f4ec9635dab2 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -520,6 +520,34 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 			}
 
 			/*
+			 * For normal commands, reserve the last MAX_COMPOUND
+			 * credits to compound requests.
+			 * Otherwise these compounds could be permanently
+			 * starved for credits by single-credit requests.
+			 *
+			 * To prevent spinning CPU, block this thread until
+			 * there are >MAX_COMPOUND credits available.
+			 * But only do this is we already have a lot of
+			 * credits in flight to avoid triggering this check
+			 * for servers that are slow to hand out credits on
+			 * new sessions.
+			 */
+			if (!optype && num_credits == 1 &&
+			    server->in_flight > 2 * MAX_COMPOUND &&
+			    *credits <= MAX_COMPOUND) {
+				spin_unlock(&server->req_lock);
+				cifs_num_waiters_inc(server);
+				rc = wait_event_killable(server->request_q,
+					has_credits(server, credits,
+						    MAX_COMPOUND + 1));
+				cifs_num_waiters_dec(server);
+				if (rc)
+					return rc;
+				spin_lock(&server->req_lock);
+				continue;
+			}
+
+			/*
 			 * Can not count locking commands against total
 			 * as they are allowed to block on server.
 			 */
-- 
2.13.6

