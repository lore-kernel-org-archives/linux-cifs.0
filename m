Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76F1EB64DD
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Jun 2023 09:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbjF2JAN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Jun 2023 05:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbjF2I76 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Jun 2023 04:59:58 -0400
Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3462E4B
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jun 2023 01:59:55 -0700 (PDT)
X-QQ-mid: bizesmtp71t1688029182te8nlnxs
Received: from localhost.localdomain ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 29 Jun 2023 16:59:34 +0800 (CST)
X-QQ-SSF: 01400000000000F0H000000A0000000
X-QQ-FEAT: WP/PdQRFMYs8L0/4aWn/8mGsurvVJEdL43dlS+uxRokZl8yhk+mPOSYWKwWiz
        zjUTBQVHnv9by/aiMjahHNy8s2CWzQjraiEkNCVnodAeYTQLjr8xP1lRZPC1VVipyWYcPKC
        LdrCkGxG3bsVFUtTX9GNu+FpKyXpFQF6AQpmzhQj3Jvka7WcNYxb+ckUgPyZ6QfMoOVAsaW
        wHqFehqJWwZCMf9GONoPw/Qe15SEidmX1LPdxcnrkGSQei4ns/9OI6Pcox+mdyK7Id2yHpH
        KLkg0cvmaBl5uDyo934qEwtvnv/te7TWHoDPcsd/kBNVUNsCcrU8fpW4BuC9JwcG2XQDxom
        OpyWMdWRRq+1I7mIFHLQogB0snNtXwSDSR6CmpwAYl5Dbp/BuSrYPdfHEzf5jnLF11ICKgM
        z/6HXtL5pwrBegj7dM61dC1OzhHY7maD
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6905205907467928356
From:   Winston Wen <wentao@uniontech.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org, pc@manguebit.com,
        nspmangalore@gmail.com
Cc:     Winston Wen <wentao@uniontech.com>
Subject: [PATCH 2/3] cifs: stop waiting for credits if there are no more requests in flight
Date:   Thu, 29 Jun 2023 16:58:57 +0800
Message-Id: <20230629085858.2834937-2-wentao@uniontech.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230629085858.2834937-1-wentao@uniontech.com>
References: <20230629085858.2834937-1-wentao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

A compound request will wait for credits if free credits are not enough
now but there are in flight requests which might bring back some credits
to meet our needs in the near future.

But if the in-flight requests don't bring back enough credits, the
compound request will continue to wait unnecessarily until it times out
(60s now).

So add a helper has_credits_or_insufficient() to check if we should stop
waiting for credits in the loop to return faster.

Signed-off-by: Winston Wen <wentao@uniontech.com>
---
 fs/smb/client/cifsglob.h  | 13 +++++++++++++
 fs/smb/client/transport.c | 16 +++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index cb38c29b9a73..43d0a675b543 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -800,6 +800,19 @@ has_credits(struct TCP_Server_Info *server, int *credits, int num_credits)
 	return num >= num_credits;
 }
 
+static inline bool
+has_credits_or_insufficient(struct TCP_Server_Info *server, int *credits, int num_credits)
+{
+	int scredits;
+	int in_flight;
+
+	spin_lock(&server->req_lock);
+	scredits = *credits;
+	in_flight = server->in_flight;
+	spin_unlock(&server->req_lock);
+	return scredits >= num_credits || in_flight == 0;
+}
+
 static inline void
 add_credits(struct TCP_Server_Info *server, const struct cifs_credits *credits,
 	    const int optype)
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index f280502a2aee..82071142d72b 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -534,11 +534,21 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 		spin_lock(&server->req_lock);
 		if (*credits < num_credits) {
 			scredits = *credits;
+			in_flight = server->in_flight;
+			if (in_flight == 0) {
+				spin_unlock(&server->req_lock);
+				trace_smb3_insufficient_credits(server->CurrentMid,
+						server->conn_id, server->hostname, scredits,
+						num_credits, in_flight);
+				cifs_dbg(FYI, "%s: %d requests in flight, needed %d total=%d\n",
+						__func__, in_flight, num_credits, scredits);
+				return -EDEADLK;
+			}
 			spin_unlock(&server->req_lock);
 
 			cifs_num_waiters_inc(server);
 			rc = wait_event_killable_timeout(server->request_q,
-				has_credits(server, credits, num_credits), t);
+				has_credits_or_insufficient(server, credits, num_credits), t);
 			cifs_num_waiters_dec(server);
 			if (!rc) {
 				spin_lock(&server->req_lock);
@@ -578,8 +588,8 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 				cifs_num_waiters_inc(server);
 				rc = wait_event_killable_timeout(
 					server->request_q,
-					has_credits(server, credits,
-						    MAX_COMPOUND + 1),
+					has_credits_or_insufficient(server, credits,
+								MAX_COMPOUND + 1),
 					t);
 				cifs_num_waiters_dec(server);
 				if (!rc) {
-- 
2.40.1

