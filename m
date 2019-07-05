Return-Path: <SRS0=j5Ui=VC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097C7C46499
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jul 2019 20:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7E682133F
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jul 2019 20:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfGEUwz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Jul 2019 16:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfGEUwz (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 5 Jul 2019 16:52:55 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E3FA2C057F2E;
        Fri,  5 Jul 2019 20:52:54 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-27.bne.redhat.com [10.64.54.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4490319094;
        Fri,  5 Jul 2019 20:52:54 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: Fix a race condition with cifs_echo_request
Date:   Sat,  6 Jul 2019 06:52:46 +1000
Message-Id: <20190705205246.16304-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 05 Jul 2019 20:52:54 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There is a race condition with how we send (or supress and don't send)
smb echos that will cause the client to incorrectly think the
server is unresponsive and thus needs to be reconnected.

Summary of the race condition:
 1) Daisy chaining scheduling creates a gap.
 2) If traffic comes unfortunate shortly after
    the last echo, the planned echo is suppressed.
 3) Due to the gap, the next echo transmission is delayed
    until after the timeout, which is set hard to twice
    the echo interval.

This is fixed by changing the timeouts from 2 to three times the echo interval.

Detailed description of the bug: https://lutz.donnerhacke.de/eng/Blog/Groundhog-Day-with-SMB-remount

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 11adca981263..f37d402f0dcd 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -704,10 +704,10 @@ static bool
 server_unresponsive(struct TCP_Server_Info *server)
 {
 	/*
-	 * We need to wait 2 echo intervals to make sure we handle such
+	 * We need to wait 3 echo intervals to make sure we handle such
 	 * situations right:
 	 * 1s  client sends a normal SMB request
-	 * 2s  client gets a response
+	 * 3s  client gets a response
 	 * 30s echo workqueue job pops, and decides we got a response recently
 	 *     and don't need to send another
 	 * ...
@@ -716,9 +716,9 @@ server_unresponsive(struct TCP_Server_Info *server)
 	 */
 	if ((server->tcpStatus == CifsGood ||
 	    server->tcpStatus == CifsNeedNegotiate) &&
-	    time_after(jiffies, server->lstrp + 2 * server->echo_interval)) {
+	    time_after(jiffies, server->lstrp + 3 * server->echo_interval)) {
 		cifs_dbg(VFS, "Server %s has not responded in %lu seconds. Reconnecting...\n",
-			 server->hostname, (2 * server->echo_interval) / HZ);
+			 server->hostname, (3 * server->echo_interval) / HZ);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return true;
-- 
2.13.6

