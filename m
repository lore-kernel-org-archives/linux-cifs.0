Return-Path: <SRS0=S2FA=RS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE5FC43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 07:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66B821872
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 07:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbfCOH4U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Mar 2019 03:56:20 -0400
Received: from a2nlsmtp01-02.prod.iad2.secureserver.net ([198.71.225.36]:53086
        "EHLO a2nlsmtp01-02.prod.iad2.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727476AbfCOH4S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 15 Mar 2019 03:56:18 -0400
Received: from linuxonhyperv2.linuxonhyperv.com ([107.180.71.197])
        by : HOSTING RELAY : with ESMTP
        id 4hgShlWbWhEQ74hgShRKSC; Fri, 15 Mar 2019 00:55:16 -0700
x-originating-ip: 107.180.71.197
Received: from longli by linuxonhyperv2.linuxonhyperv.com with local (Exim 4.91)
        (envelope-from <longli@linuxonhyperv2.linuxonhyperv.com>)
        id 1h4hgS-0007EQ-4t; Fri, 15 Mar 2019 00:55:16 -0700
From:   Long Li <longli@linuxonhyperv.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [Patch v2 2/2] CIFS: Fix an issue with re-sending rdata when transport returning -EAGAIN
Date:   Fri, 15 Mar 2019 07:55:00 +0000
Message-Id: <20190315075500.27747-2-longli@linuxonhyperv.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190315075500.27747-1-longli@linuxonhyperv.com>
References: <20190315075500.27747-1-longli@linuxonhyperv.com>
MIME-Version: 1.0
Reply-To: longli@microsoft.com
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfEV/ZgpGjj3M+RV82U3P57nuxweXtFYuSkb21IEp+TudWgvNr40sXgQvKIw7qqODrRdTcRpq7HH4X2D8zARo8w7YegjY+UBRQYPCRD/3Pxcfs3vFJuLH
 L6dybI2eGV7X8GJEP7fv1uK6tJIjqnuxtEUOilz2NERtAOTInAFespl3kqUV/FJbxEa1aXO7c1ADNGMuoIPT38VahjfTa5DSNXnm3EthK2pspHYRWoEAtv6E
 MIck2PLUHYlrmCXWcuIWmJBfeR7Z7WFUL5FKR6sDS/amh0cYw5toqCCVlvt1R4U9VhtrDmQ7QK00iBJ32ImPJpgeCYSSzKAQVhMe6p/2JZgak2r2kZhxrvFz
 D2EzsVH22kJengRe9dFJ2tAyGuMPNA==
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

When sending a rdata, transport may return -EAGAIN. In this case
we should re-obtain credits because the session may have been
reconnected.

Change in v2: adjust_credits before re-sending

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/file.c | 71 +++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 41 insertions(+), 30 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 321df1d27422..9d90cc07e38b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3347,44 +3347,55 @@ static int cifs_resend_rdata(struct cifs_readdata *rdata,
 	struct TCP_Server_Info *server =
 		tlink_tcon(rdata->cfile->tlink)->ses->server;
 
-	/*
-	 * Wait for credits to resend this rdata.
-	 * Note: we are attempting to resend the whole rdata not in segments
-	 */
 	do {
-		rc = server->ops->wait_mtu_credits(server, rdata->bytes,
+		if (rdata->cfile->invalidHandle) {
+			rc = cifs_reopen_file(rdata->cfile, true);
+			if (rc == -EAGAIN)
+				continue;
+			else if (rc)
+				break;
+		}
+
+		/*
+		 * Wait for credits to resend this rdata.
+		 * Note: we are attempting to resend the whole rdata not in
+		 * segments
+		 */
+		do {
+			rc = server->ops->wait_mtu_credits(server, rdata->bytes,
 						&rsize, &credits);
 
-		if (rc)
-			goto out;
+			if (rc)
+				goto fail;
 
-		if (rsize < rdata->bytes) {
-			add_credits_and_wake_if(server, &credits, 0);
-			msleep(1000);
-		}
-	} while (rsize < rdata->bytes);
+			if (rsize < rdata->bytes) {
+				add_credits_and_wake_if(server, &credits, 0);
+				msleep(1000);
+			}
+		} while (rsize < rdata->bytes);
+		rdata->credits = credits;
 
-	rdata->credits = credits;
-	rc = -EAGAIN;
-	while (rc == -EAGAIN) {
-		rc = 0;
-		if (rdata->cfile->invalidHandle)
-			rc = cifs_reopen_file(rdata->cfile, true);
-		if (!rc)
-			rc = server->ops->async_readv(rdata);
-	}
+		rc = adjust_credits(server, &rdata->credits, rdata->bytes);
+		if (!rc) {
+			if (rdata->cfile->invalidHandle)
+				rc = -EAGAIN;
+			else
+				rc = server->ops->async_readv(rdata);
+		}
 
-	if (!rc) {
-		/* Add to aio pending list */
-		list_add_tail(&rdata->list, rdata_list);
-		return 0;
-	}
+		/* If the read was successfully sent, we are done */
+		if (!rc) {
+			/* Add to aio pending list */
+			list_add_tail(&rdata->list, rdata_list);
+			return 0;
+		}
 
-	add_credits_and_wake_if(server, &rdata->credits, 0);
-out:
-	kref_put(&rdata->refcount,
-		cifs_uncached_readdata_release);
+		/* Roll back credits and retry if needed */
+		add_credits_and_wake_if(server, &rdata->credits, 0);
+	} while (rc == -EAGAIN);
 
+fail:
+	kref_put(&rdata->refcount, cifs_uncached_readdata_release);
 	return rc;
 }
 
-- 
2.14.1

