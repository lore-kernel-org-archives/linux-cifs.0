Return-Path: <SRS0=fkjb=YJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AABBFA3728
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Oct 2019 20:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4440021A49
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Oct 2019 20:52:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxonhyperv.com header.i=@linuxonhyperv.com header.b="fEJ5jG1S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437304AbfJPUwm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Oct 2019 16:52:42 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58846 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437299AbfJPUwk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Oct 2019 16:52:40 -0400
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 74F4120B9C01; Wed, 16 Oct 2019 13:52:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 74F4120B9C01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1571259159;
        bh=4sfYqfNcpqUyQQbNHu50T1zrwYwZAKGk5e7iBBIfSaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=fEJ5jG1S1MwamTnSlDlKPEPKPQZoloArDSkK1MWu89vIhffBH8pIzueXDS3OyoKRe
         hOpdrnE4BABVWf5KhMLqSS2oASgx141KJp5415iAzkLTiOMdBMZX9O6hlD0nVyeisd
         Kam0Tmk3Iiy6f4NIs+n4nQ54gqqU/u4GhABEWH5c=
From:   longli@linuxonhyperv.com
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 7/7] cifs: smbd: Return -EAGAIN when transport is reconnecting
Date:   Wed, 16 Oct 2019 13:51:56 -0700
Message-Id: <1571259116-102015-8-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
References: <1571259116-102015-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

During reconnecting, the transport may have already been destroyed and is in
the process being reconnected. In this case, return -EAGAIN to not fail and
to retry this I/O.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/cifs/transport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index afe66f9cb15e..66fde7bfec4f 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -318,8 +318,11 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	int val = 1;
 	__be32 rfc1002_marker;
 
-	if (cifs_rdma_enabled(server) && server->smbd_conn) {
-		rc = smbd_send(server, num_rqst, rqst);
+	if (cifs_rdma_enabled(server)) {
+		/* return -EAGAIN when connecting or reconnecting */
+		rc = -EAGAIN;
+		if (server->smbd_conn)
+			rc = smbd_send(server, num_rqst, rqst);
 		goto smbd_done;
 	}
 
-- 
2.17.1

