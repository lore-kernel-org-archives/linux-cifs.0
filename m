Return-Path: <SRS0=u+N2=TP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A43C04E53
	for <linux-cifs@archiver.kernel.org>; Wed, 15 May 2019 21:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88B3F2070D
	for <linux-cifs@archiver.kernel.org>; Wed, 15 May 2019 21:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfEOVJR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 May 2019 17:09:17 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58088 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbfEOVJR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 May 2019 17:09:17 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id BCBB520110AD; Wed, 15 May 2019 14:09:16 -0700 (PDT)
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH 1/2] cifs: Don't match port on SMBDirect transport
Date:   Wed, 15 May 2019 14:09:04 -0700
Message-Id: <1557954545-17831-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

SMBDirect manages its own ports in the transport layer, there is no need to
check the port to find a connection.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0b3ac8b76d18..8c4121da624e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2446,6 +2446,10 @@ match_port(struct TCP_Server_Info *server, struct sockaddr *addr)
 {
 	__be16 port, *sport;
 
+	/* SMBDirect manages its own ports, don't match it here */
+	if (server->rdma)
+		return true;
+
 	switch (addr->sa_family) {
 	case AF_INET:
 		sport = &((struct sockaddr_in *) &server->dstaddr)->sin_port;
-- 
2.17.1

