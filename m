Return-Path: <SRS0=n6BV=SH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C68C282CE
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 21:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C7B921726
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 21:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfDEViG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Apr 2019 17:38:06 -0400
Received: from a2nlsmtp01-02.prod.iad2.secureserver.net ([198.71.225.36]:48492
        "EHLO a2nlsmtp01-02.prod.iad2.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725973AbfDEViG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Apr 2019 17:38:06 -0400
Received: from linuxonhyperv2.linuxonhyperv.com ([107.180.71.197])
        by : HOSTING RELAY : with ESMTP
        id CWWGhHHISO5E5CWWGhjAg9; Fri, 05 Apr 2019 14:37:04 -0700
x-originating-ip: 107.180.71.197
Received: from longli by linuxonhyperv2.linuxonhyperv.com with local (Exim 4.91)
        (envelope-from <longli@linuxonhyperv2.linuxonhyperv.com>)
        id 1hCWWG-0006N7-2b; Fri, 05 Apr 2019 14:37:04 -0700
From:   Long Li <longli@linuxonhyperv.com>
To:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [Patch (resend) 5/5] cifs: Call MID callback before destroying transport
Date:   Fri,  5 Apr 2019 21:36:35 +0000
Message-Id: <20190405213635.24383-5-longli@linuxonhyperv.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190405213635.24383-1-longli@linuxonhyperv.com>
References: <20190405213635.24383-1-longli@linuxonhyperv.com>
MIME-Version: 1.0
Reply-To: longli@microsoft.com
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfJ+n9swuzbs35gEa4jn/gP2/eIJpmINAyK9pJQ4qmXMBzDgDMYz5a5zmlw5U0juLXvcyw2bzNGxKpxy4LTQmqUshorBycMXjfxKrOcWdI1yMjDTRvqj5
 0Dt4JBPAOVB3brwjAWC/JLgx80CqJVk346zGaYPZG/Qp0kblGGwwK9VT4oNy7EcdmaXDi3ihn04RGBbuF5i3GeglidjlIQEODpdquV4xcknofIa0A3WV6qcM
 JwS8TOCQUmlFsvCddwiftyRpRK/t9XEq4e79hSqedyXO7/iNMJbn3CWUIOTbCKDNFjJABgxighHNT0RwgTgvyDZeVbAuRsKFpq7/fPPzpv5kTPdyNXCVl+qG
 1Ux5h40k5DP4mQkWxEJRTIOBWqg8QQ==
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Long Li <longli@microsoft.com>

When transport is being destroyed, it's possible that some processes may
hold memory registrations that need to be deregistred.

Call them first so nobody is using transport resources, and it can be
destroyed.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/connect.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 33e4d98..084756cf 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -528,22 +528,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	/* do not want to be sending data on a socket we are freeing */
 	cifs_dbg(FYI, "%s: tearing down socket\n", __func__);
 	mutex_lock(&server->srv_mutex);
-	if (server->ssocket) {
-		cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n",
-			 server->ssocket->state, server->ssocket->flags);
-		kernel_sock_shutdown(server->ssocket, SHUT_WR);
-		cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n",
-			 server->ssocket->state, server->ssocket->flags);
-		sock_release(server->ssocket);
-		server->ssocket = NULL;
-	} else if (cifs_rdma_enabled(server))
-		smbd_destroy(server);
-	server->sequence_number = 0;
-	server->session_estab = false;
-	kfree(server->session_key.response);
-	server->session_key.response = NULL;
-	server->session_key.len = 0;
-	server->lstrp = jiffies;
 
 	/* mark submitted MIDs for retry and issue callback */
 	INIT_LIST_HEAD(&retry_list);
@@ -556,7 +540,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		list_move(&mid_entry->qhead, &retry_list);
 	}
 	spin_unlock(&GlobalMid_Lock);
-	mutex_unlock(&server->srv_mutex);
 
 	cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
 	list_for_each_safe(tmp, tmp2, &retry_list) {
@@ -565,6 +548,25 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		mid_entry->callback(mid_entry);
 	}
 
+	if (server->ssocket) {
+		cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n",
+			 server->ssocket->state, server->ssocket->flags);
+		kernel_sock_shutdown(server->ssocket, SHUT_WR);
+		cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n",
+			 server->ssocket->state, server->ssocket->flags);
+		sock_release(server->ssocket);
+		server->ssocket = NULL;
+	} else if (cifs_rdma_enabled(server))
+		smbd_destroy(server);
+	server->sequence_number = 0;
+	server->session_estab = false;
+	kfree(server->session_key.response);
+	server->session_key.response = NULL;
+	server->session_key.len = 0;
+	server->lstrp = jiffies;
+
+	mutex_unlock(&server->srv_mutex);
+
 	do {
 		try_to_freeze();
 
-- 
2.7.4

