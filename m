Return-Path: <SRS0=lkMc=RF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103D6C43381
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 03:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D61332083E
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 03:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfCBDEQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Mar 2019 22:04:16 -0500
Received: from a2nlsmtp01-03.prod.iad2.secureserver.net ([198.71.225.37]:36022
        "EHLO a2nlsmtp01-03.prod.iad2.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726693AbfCBDEQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Mar 2019 22:04:16 -0500
X-Greylist: delayed 676 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2019 22:04:15 EST
Received: from linuxonhyperv2.linuxonhyperv.com ([107.180.71.197])
        by : HOSTING RELAY : with ESMTP
        id zukng12mfvhwrzukngTnjM; Fri, 01 Mar 2019 19:51:58 -0700
x-originating-ip: 107.180.71.197
Received: from longli by linuxonhyperv2.linuxonhyperv.com with local (Exim 4.91)
        (envelope-from <longli@linuxonhyperv2.linuxonhyperv.com>)
        id 1gzukn-0000m1-HO; Fri, 01 Mar 2019 19:51:57 -0700
From:   Long Li <longli@linuxonhyperv.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH 1/2] CIFS: Fix a bug with re-sending wdata when transport returning -EAGAIN
Date:   Sat,  2 Mar 2019 02:51:45 +0000
Message-Id: <20190302025146.2935-1-longli@linuxonhyperv.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Reply-To: longli@microsoft.com
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfJX5FjUbmpArmWgxJ8znoJonI53gLp/UBGxpnyKmwW9kPMWQN0MqVAh4vrNWSZPvtL5F+TIAIAUqNrBeaOzaasJ2XkRnkmMckouZZ7+BxW3NV677CB5o
 2tzMBS0myN+Dd2zVDIxAXJPzT/IDAz+DztB/QmqjNxnk48FHLN+aMm8cGmHsxDdDBv2F6otlnyipv3HaSdMeazNz88pmBg/Z6dnL5pWyKZBuM8wUVHLM01RO
 sZTnbyRYckZVmI2Nxr6AlA8xhY/JmlZdA9U5aEJE2mHQiOYqmVZ5xGR1J4vrW9BQXtomnkA1QPGoJds8FQl7ZrFVr+wHmPrcPqD43lgXgqSswTYLXTDqXP5q
 JnX7MFZAP1kSfXAVtE+DVRop90L/K32bj9h0+wvNwuKoGVnRlwcUM1ANoXzFn9kQgbMNKWXY
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

When sending a wdata, transport may return -EAGAIN. In this case
we should re-obtain credits because the session may have been
reconnected.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/file.c | 61 +++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9b53f33137b3..08e73759d6ec 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2620,43 +2620,44 @@ cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
 	struct TCP_Server_Info *server =
 		tlink_tcon(wdata->cfile->tlink)->ses->server;
 
-	/*
-	 * Wait for credits to resend this wdata.
-	 * Note: we are attempting to resend the whole wdata not in segments
-	 */
 	do {
-		rc = server->ops->wait_mtu_credits(server, wdata->bytes, &wsize,
-						   &credits);
-
-		if (rc)
-			goto out;
-
-		if (wsize < wdata->bytes) {
-			add_credits_and_wake_if(server, &credits, 0);
-			msleep(1000);
-		}
-	} while (wsize < wdata->bytes);
+		/*
+		 * Wait for credits to resend this wdata.
+		 * Note: we are attempting to resend the whole wdata not in
+		 * segments
+		 */
+		do {
+			rc = server->ops->wait_mtu_credits(server, wdata->bytes,
+						&wsize, &credits);
+			if (rc)
+				goto fail;
+
+			if (wsize < wdata->bytes) {
+				add_credits_and_wake_if(server, &credits, 0);
+				msleep(1000);
+			}
+		} while (wsize < wdata->bytes);
 
-	wdata->credits = credits;
-	rc = -EAGAIN;
-	while (rc == -EAGAIN) {
+		wdata->credits = credits;
 		rc = 0;
 		if (wdata->cfile->invalidHandle)
 			rc = cifs_reopen_file(wdata->cfile, false);
 		if (!rc)
 			rc = server->ops->async_writev(wdata,
-					cifs_uncached_writedata_release);
-	}
+				cifs_uncached_writedata_release);
 
-	if (!rc) {
-		list_add_tail(&wdata->list, wdata_list);
-		return 0;
-	}
+		/* If the write was successfully sent, we are done */
+		if (!rc) {
+			list_add_tail(&wdata->list, wdata_list);
+			return 0;
+		}
 
-	add_credits_and_wake_if(server, &wdata->credits, 0);
-out:
-	kref_put(&wdata->refcount, cifs_uncached_writedata_release);
+		/* Roll back credits and retry if needed */
+		add_credits_and_wake_if(server, &wdata->credits, 0);
+	} while (rc == -EAGAIN);
 
+fail:
+	kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 	return rc;
 }
 
@@ -2884,12 +2885,12 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 						wdata->bytes, &tmp_from,
 						ctx->cfile, cifs_sb, &tmp_list,
 						ctx);
+
+					kref_put(&wdata->refcount,
+						cifs_uncached_writedata_release);
 				}
 
 				list_splice(&tmp_list, &ctx->list);
-
-				kref_put(&wdata->refcount,
-					 cifs_uncached_writedata_release);
 				goto restart_loop;
 			}
 		}
-- 
2.17.1

