Return-Path: <SRS0=S2FA=RS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E83BC43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 07:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC4EA21872
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 07:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfCOH4Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Mar 2019 03:56:16 -0400
Received: from a2nlsmtp01-05.prod.iad2.secureserver.net ([198.71.225.49]:57274
        "EHLO a2nlsmtp01-05.prod.iad2.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727476AbfCOH4Q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 15 Mar 2019 03:56:16 -0400
Received: from linuxonhyperv2.linuxonhyperv.com ([107.180.71.197])
        by : HOSTING RELAY : with ESMTP
        id 4hgQhpap6vHD34hgQhNjov; Fri, 15 Mar 2019 00:55:14 -0700
x-originating-ip: 107.180.71.197
Received: from longli by linuxonhyperv2.linuxonhyperv.com with local (Exim 4.91)
        (envelope-from <longli@linuxonhyperv2.linuxonhyperv.com>)
        id 1h4hgP-0007EK-Tr; Fri, 15 Mar 2019 00:55:13 -0700
From:   Long Li <longli@linuxonhyperv.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [Patch v2 1/2] CIFS: Fix an issue with re-sending wdata when transport returning -EAGAIN
Date:   Fri, 15 Mar 2019 07:54:59 +0000
Message-Id: <20190315075500.27747-1-longli@linuxonhyperv.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Reply-To: longli@microsoft.com
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfKSI2fFxYg5Qun/7wIhri5PIZGr2XNF22LqVqfCnTFxGfzj9P7zCbasGBF5174eRc/S1BWP1Psy5GSg9Nd4DV8JpawczHGCWUjN0E7XIEwIrDq2vEMC4
 uOzgj/hRXHf3JAASo/ShJaVC8IzfDZX/I2eF6yJxJFTDQzp+KCGRimcT62mHOa9vSkGki5Duk+mCF5phplT3dDkPadfi8F8XL8useBbQEHw0b8YbsgRChy/F
 em+O3sfsX9sAm2WLw7ThdzM4fqd5IRITXP+LDDe4ampIxQSHmYBe4ZolE7y/UuOyg/mw1lFIsX+xlHFu0eJmV/KvBS25GXlGpzKERiwTbNJyn5psFK+cETuZ
 vk9KhnvB1fFoaMzOGSsMtbiUHN8p7Q==
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

When sending a wdata, transport may return -EAGAIN. In this case
we should re-obtain credits because the session may have been
reconnected.

Change in v2: adjust_credits before re-sending

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/file.c | 77 ++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 32 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9b53f33137b3..321df1d27422 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2620,43 +2620,56 @@ cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
 	struct TCP_Server_Info *server =
 		tlink_tcon(wdata->cfile->tlink)->ses->server;
 
-	/*
-	 * Wait for credits to resend this wdata.
-	 * Note: we are attempting to resend the whole wdata not in segments
-	 */
 	do {
-		rc = server->ops->wait_mtu_credits(server, wdata->bytes, &wsize,
-						   &credits);
+		if (wdata->cfile->invalidHandle) {
+			rc = cifs_reopen_file(wdata->cfile, false);
+			if (rc == -EAGAIN)
+				continue;
+			else if (rc)
+				break;
+		}
 
-		if (rc)
-			goto out;
 
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
+		wdata->credits = credits;
 
-	wdata->credits = credits;
-	rc = -EAGAIN;
-	while (rc == -EAGAIN) {
-		rc = 0;
-		if (wdata->cfile->invalidHandle)
-			rc = cifs_reopen_file(wdata->cfile, false);
-		if (!rc)
-			rc = server->ops->async_writev(wdata,
+		rc = adjust_credits(server, &wdata->credits, wdata->bytes);
+
+		if (!rc) {
+			if (wdata->cfile->invalidHandle)
+				rc = -EAGAIN;
+			else
+				rc = server->ops->async_writev(wdata,
 					cifs_uncached_writedata_release);
-	}
+		}
 
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
 
@@ -2884,12 +2897,12 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
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
2.14.1

