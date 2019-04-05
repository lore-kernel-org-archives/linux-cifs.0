Return-Path: <SRS0=n6BV=SH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350FAC282CE
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 21:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C64D21726
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 21:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfDEVhw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Apr 2019 17:37:52 -0400
Received: from a2nlsmtp01-03.prod.iad2.secureserver.net ([198.71.225.37]:53672
        "EHLO a2nlsmtp01-03.prod.iad2.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726384AbfDEVhw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Apr 2019 17:37:52 -0400
Received: from linuxonhyperv2.linuxonhyperv.com ([107.180.71.197])
        by : HOSTING RELAY : with ESMTP
        id CWW3hh1bJiCMnCWW3howuv; Fri, 05 Apr 2019 14:36:51 -0700
x-originating-ip: 107.180.71.197
Received: from longli by linuxonhyperv2.linuxonhyperv.com with local (Exim 4.91)
        (envelope-from <longli@linuxonhyperv2.linuxonhyperv.com>)
        id 1hCWW3-0006Mo-EN; Fri, 05 Apr 2019 14:36:51 -0700
From:   Long Li <longli@linuxonhyperv.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [Patch (resend) 2/5] cifs: smbd: Return EINTR when interrupted
Date:   Fri,  5 Apr 2019 21:36:32 +0000
Message-Id: <20190405213635.24383-2-longli@linuxonhyperv.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190405213635.24383-1-longli@linuxonhyperv.com>
References: <20190405213635.24383-1-longli@linuxonhyperv.com>
MIME-Version: 1.0
Reply-To: longli@microsoft.com
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfLzAwzddYY7LJmHGB1C1t3zdyDnB1TP6Pl1jIw9atxoETD9y7YSSUrrwB3fl/or6YSao52twPVZyFQVp0fssxAULasZOIZBujFPJMH6DwY14oDBV+kye
 57mMo0h6BN++thkrdO84xVv6dTa95EZpUxMkJVYKydu/lHEm6q/heoxxm+O0zYxkqLfxwx/Juxp2jdRiUO3zfx2OlyoPWxkAQveK8I8lAdrpEMN9Yes6OXt7
 cGPtl8SMsoel3w8cAjkD/otb+JX3b2xcIt/6uvgOzMSjAJKK7PzVzFd7MtXme2r9OLFWcGLYQ3x19+GLY9mbDXhkqXitx3e6cd2PgLIkzxeS68uqD/pJ2Ud/
 jtCwYrvhMvJ/W2bHO0IxEUBFKsijig==
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

When packets are waiting for outbound I/O and interrupted, return the
proper error code to user process.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 7259427..df95c75 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1972,7 +1972,7 @@ static int smbd_recv_buf(struct smbd_connection *info, char *buf,
 			info->transport_status != SMBD_CONNECTED);
 	/* Don't return any data if interrupted */
 	if (rc)
-		return -ENODEV;
+		return rc;
 
 	if (info->transport_status != SMBD_CONNECTED) {
 		log_read(ERR, "disconnected\n");
-- 
2.7.4

