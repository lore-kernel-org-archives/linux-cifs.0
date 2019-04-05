Return-Path: <SRS0=n6BV=SH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A7AC282DA
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 21:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F1712186A
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 21:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfDEViB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Apr 2019 17:38:01 -0400
Received: from a2nlsmtp01-05.prod.iad2.secureserver.net ([198.71.225.49]:57894
        "EHLO a2nlsmtp01-05.prod.iad2.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725973AbfDEViB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Apr 2019 17:38:01 -0400
Received: from linuxonhyperv2.linuxonhyperv.com ([107.180.71.197])
        by : HOSTING RELAY : with ESMTP
        id CWWBhcj5QO8d9CWWBhwjnr; Fri, 05 Apr 2019 14:36:59 -0700
x-originating-ip: 107.180.71.197
Received: from longli by linuxonhyperv2.linuxonhyperv.com with local (Exim 4.91)
        (envelope-from <longli@linuxonhyperv2.linuxonhyperv.com>)
        id 1hCWWB-0006N1-I9; Fri, 05 Apr 2019 14:36:59 -0700
From:   Long Li <longli@linuxonhyperv.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [Patch (resend) 4/5] cifs: smbd: Retry on memory registration failure
Date:   Fri,  5 Apr 2019 21:36:34 +0000
Message-Id: <20190405213635.24383-4-longli@linuxonhyperv.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190405213635.24383-1-longli@linuxonhyperv.com>
References: <20190405213635.24383-1-longli@linuxonhyperv.com>
MIME-Version: 1.0
Reply-To: longli@microsoft.com
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfN4uVF5QeKT9JM4yiBeZw23HjTXYTV+mWeg96W/LtbPnuQK64WIH7rtXSGyX6rkAXzgXxdxt9U1M//cpc3wUdgfnAdRxf2EI/v1eaz/LTItLYU31KYhM
 6SehhJGGVbMX3EVrD6t+HUdzNSIlOhgk5yiUDy/oVHyb+qDMq1NUPLjBlOFWkbkaRqEzSkYmftzZhPWoVIQD365ElAaTzXhiCzgd0kB4Fbv/btjb0gZBaNNb
 1ppjKtvOOkP2lp5vwczFn7CSgA/IhAgzxUu4xeTdfoyZXeQziZCnC4g6GgK+W+wsuYuUUpzrc5qGf4sLImdLxzZC5nt83aHNkz1sMpK4iQCRYyrjuyfOIdYZ
 FONcO+Sar6kAPAQaU0wEkT0S5I/j6Q==
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

Memory registration failure doesn't mean this I/O has failed, it means the
transport is hitting I/O error or needs reconnect. This error is not from
the server.

Indicate this error to upper layer, and let upper layer decide how to
reconnect and proceed with this I/O.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 21ad01d..ff3b730 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3220,7 +3220,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 				rdata->nr_pages, rdata->page_offset,
 				rdata->tailsz, true, need_invalidate);
 		if (!rdata->mr)
-			return -ENOBUFS;
+			return -EAGAIN;
 
 		req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
 		if (need_invalidate)
@@ -3624,7 +3624,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 				wdata->nr_pages, wdata->page_offset,
 				wdata->tailsz, false, need_invalidate);
 		if (!wdata->mr) {
-			rc = -ENOBUFS;
+			rc = -EAGAIN;
 			goto async_writev_out;
 		}
 		req->Length = 0;
-- 
2.7.4

