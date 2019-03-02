Return-Path: <SRS0=lkMc=RF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF48C43381
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 03:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65FA32083E
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 03:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfCBDET (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Mar 2019 22:04:19 -0500
Received: from a2nlsmtp01-05.prod.iad2.secureserver.net ([198.71.225.49]:45624
        "EHLO a2nlsmtp01-05.prod.iad2.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726693AbfCBDET (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Mar 2019 22:04:19 -0500
Received: from linuxonhyperv2.linuxonhyperv.com ([107.180.71.197])
        by : HOSTING RELAY : with ESMTP
        id zukrgx7wsvHD3zukrgCi7x; Fri, 01 Mar 2019 19:52:01 -0700
x-originating-ip: 107.180.71.197
Received: from longli by linuxonhyperv2.linuxonhyperv.com with local (Exim 4.91)
        (envelope-from <longli@linuxonhyperv2.linuxonhyperv.com>)
        id 1gzukr-0000m7-77; Fri, 01 Mar 2019 19:52:01 -0700
From:   Long Li <longli@linuxonhyperv.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH 2/2] CIFS: Fix a bug with re-sending rdata when transport returning -EAGAIN
Date:   Sat,  2 Mar 2019 02:51:46 +0000
Message-Id: <20190302025146.2935-2-longli@linuxonhyperv.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190302025146.2935-1-longli@linuxonhyperv.com>
References: <20190302025146.2935-1-longli@linuxonhyperv.com>
MIME-Version: 1.0
Reply-To: longli@microsoft.com
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfHVMZ3YZdpaQQHlyI15jJkM14XlHjpQ2z4a/I0Cm5O+W3FVh39b/6Upqj9K4R/9Al2mKNZKPovFAnoIKB09kuUPEzx3YmD0ouGFezZUDU98gpPM8unsT
 16Q71DqEq76upCWywgYPqvK9IrEV9eMtMkstIiERnDaLdt7ttt8unfhHot+jDYXTmNQZj/UDjG0dS8/TRCRWgUYqIQO02hB4Ln2h2nA9jrZGCPBqNkl3JLzY
 Vol31ubhDcLgk28qUooLZEHHp+kUOr6ICjcss7LbyZI13YMF5hUwaJSsjJymDJX8ONl/IxkwE8GbxKrqyNHehvANhw5bD1/XacqoNp3hQ+Lyd4myt3Nl23JM
 FHl1wCUMbYodxI5O3RpMmHOIlGDGhlelqK8D6VB2llHuSlaA+IacENdT2Q6QEsv07QeHJlSE
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

When sending a rdata, transport may return -EAGAIN. In this case
we should re-obtain credits because the session may have been
reconnected.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/file.c | 51 +++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 08e73759d6ec..c83ca96f883b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3335,44 +3335,45 @@ static int cifs_resend_rdata(struct cifs_readdata *rdata,
 	struct TCP_Server_Info *server =
 		tlink_tcon(rdata->cfile->tlink)->ses->server;
 
-	/*
-	 * Wait for credits to resend this rdata.
-	 * Note: we are attempting to resend the whole rdata not in segments
-	 */
 	do {
-		rc = server->ops->wait_mtu_credits(server, rdata->bytes,
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
 
-	rdata->credits = credits;
-	rc = -EAGAIN;
-	while (rc == -EAGAIN) {
+		rdata->credits = credits;
 		rc = 0;
 		if (rdata->cfile->invalidHandle)
 			rc = cifs_reopen_file(rdata->cfile, true);
 		if (!rc)
 			rc = server->ops->async_readv(rdata);
-	}
 
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
2.17.1

