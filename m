Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391A5C4361B
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 09:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E723823A7B
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 09:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgLRJb3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Dec 2020 04:31:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:48592 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgLRJb3 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 18 Dec 2020 04:31:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6E188ABC6;
        Fri, 18 Dec 2020 09:30:47 +0000 (UTC)
From:   Samuel Cabrero <scabrero@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     palcantara@suse.de, Samuel Cabrero <scabrero@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] cifs: Avoid error pointer dereference
Date:   Fri, 18 Dec 2020 10:29:49 +0100
Message-Id: <20201218092949.1767-1-scabrero@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <X9tNXBJunTCYCoSw@mwanda>
References: <X9tNXBJunTCYCoSw@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The patch 7d6535b72042: "cifs: Simplify reconnect code when dfs
upcall is enabled" leads to the following static checker warning:

	fs/cifs/connect.c:160 reconn_set_next_dfs_target()
	error: 'server->hostname' dereferencing possible ERR_PTR()

Avoid dereferencing the error pointer by early returning on error
condition.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Samuel Cabrero <scabrero@suse.de>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 509a41ff56b8..b9df85506938 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -155,6 +155,7 @@ static void reconn_set_next_dfs_target(struct TCP_Server_Info *server,
 		cifs_dbg(FYI,
 			 "%s: failed to extract hostname from target: %ld\n",
 			 __func__, PTR_ERR(server->hostname));
+		return;
 	}
 
 	rc = reconn_set_ipaddr_from_hostname(server);
-- 
2.29.2

