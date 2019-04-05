Return-Path: <SRS0=n6BV=SH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F6CC282CE
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 21:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1E7421726
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 21:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfDEVh6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Apr 2019 17:37:58 -0400
Received: from a2nlsmtp01-05.prod.iad2.secureserver.net ([198.71.225.49]:57894
        "EHLO a2nlsmtp01-05.prod.iad2.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725973AbfDEVh6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Apr 2019 17:37:58 -0400
Received: from linuxonhyperv2.linuxonhyperv.com ([107.180.71.197])
        by : HOSTING RELAY : with ESMTP
        id CWW8hcj33O8d9CWW8hwjlp; Fri, 05 Apr 2019 14:36:56 -0700
x-originating-ip: 107.180.71.197
Received: from longli by linuxonhyperv2.linuxonhyperv.com with local (Exim 4.91)
        (envelope-from <longli@linuxonhyperv2.linuxonhyperv.com>)
        id 1hCWW8-0006Mv-0Q; Fri, 05 Apr 2019 14:36:56 -0700
From:   Long Li <longli@linuxonhyperv.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [Patch (resend) 3/5] cifs: smbd: Indicate to retry on transport sending failure
Date:   Fri,  5 Apr 2019 21:36:33 +0000
Message-Id: <20190405213635.24383-3-longli@linuxonhyperv.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190405213635.24383-1-longli@linuxonhyperv.com>
References: <20190405213635.24383-1-longli@linuxonhyperv.com>
MIME-Version: 1.0
Reply-To: longli@microsoft.com
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfOK4J/ztf0Me2Rjg3R8lb29YFr59SOJNgd+Hfm/cFCyzyzuvdhlasXwTleFP1XWakgn2foTH5NK/ZxNy5eTTFMuvMKrt/cXFdh1NgUirQd+bgpKwPCQc
 BjzD4s80M1dVE4hExA+3NRMAQVThM8LfvnuU0swNkKlF+DtUBPViMSeRmbeTG/pyur4FoSX+ONNijYVdXbcDid88ZGVYIno9APkAo9RRAVtIUe+Oj1MumFS4
 TzxHCe3srkQNvP0V6+Mk41kUcScqRta+ewdDEMBkHFfNp7eoUZ+pBBcXoceBMnRlA1jeDt68Et7LEUClLLYkvrQcG+2eLbutvZrqeyAWVCaT/QzfA6MldrZY
 UXNVasJuUqEv/FewTBa0R+g0W5Z/8g==
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

Failure to send a packet doesn't mean it's a permanent failure, it can't be
returned to user process. This I/O should be retried or failed based on
server packet response and transport health. This logic is handled by the
upper layer.

Give this decision to upper layer.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index df95c75..05b05e7 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -853,7 +853,7 @@ static int smbd_create_header(struct smbd_connection *info,
 
 	if (info->transport_status != SMBD_CONNECTED) {
 		log_outgoing(ERR, "disconnected not sending\n");
-		return -ENOENT;
+		return -EAGAIN;
 	}
 	atomic_dec(&info->send_credits);
 
@@ -979,6 +979,7 @@ static int smbd_post_send(struct smbd_connection *info,
 				wake_up(&info->wait_send_pending);
 		}
 		smbd_disconnect_rdma_connection(info);
+		rc = -EAGAIN;
 	} else
 		/* Reset timer for idle connection after packet is sent */
 		mod_delayed_work(info->workqueue, &info->idle_timer_work,
@@ -2085,7 +2086,7 @@ int smbd_send(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	int rc;
 
 	if (info->transport_status != SMBD_CONNECTED) {
-		rc = -ENODEV;
+		rc = -EAGAIN;
 		goto done;
 	}
 
-- 
2.7.4

