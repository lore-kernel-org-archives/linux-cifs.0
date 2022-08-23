Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90F8C32796
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 15:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243203AbiHWPFR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 11:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243243AbiHWPEw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 11:04:52 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3590B31FC38
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 05:29:36 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MBnbH5FhfzlWR6;
        Tue, 23 Aug 2022 19:50:03 +0800 (CST)
Received: from fedora.huawei.com (10.175.101.6) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 23 Aug 2022 19:52:54 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-cifs@vger.kernel.org>, <zhangxiaoxu5@huawei.com>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>
Subject: [PATCH -next 2/3] cifs: Use help macro to get the mid header size
Date:   Tue, 23 Aug 2022 20:52:01 +0800
Message-ID: <20220823125202.1156172-3-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220823125202.1156172-1-zhangxiaoxu5@huawei.com>
References: <20220823125202.1156172-1-zhangxiaoxu5@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It's better to use MID_HEADER_SIZE because the unfolded expression
too long. No actual functional changes, minor readability improvement.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/cifsglob.h | 1 +
 fs/cifs/connect.c  | 9 +++------
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0057228b47cc..544f69634063 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -557,6 +557,7 @@ struct smb_version_values {
 #define HEADER_SIZE(server) (server->vals->header_size)
 #define MAX_HEADER_SIZE(server) (server->vals->max_header_size)
 #define HEADER_PREAMBLE_SIZE(server) (server->vals->header_preamble_size)
+#define MID_HEADER_SIZE(server) (HEADER_SIZE(server) - 1 - HEADER_PREAMBLE_SIZE(server))
 
 /**
  * CIFS superblock mount flags (mnt_cifs_flags) to consider when
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8a4ba1e93269..24df04d9b0f3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1065,8 +1065,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* now read the rest */
 	length = cifs_read_from_socket(server, buf + HEADER_SIZE(server) - 1,
-				       pdu_length - HEADER_SIZE(server) + 1 +
-				       HEADER_PREAMBLE_SIZE(server));
+				       pdu_length - MID_HEADER_SIZE(server));
 
 	if (length < 0)
 		return length;
@@ -1198,8 +1197,7 @@ cifs_demultiplex_thread(void *p)
 		server->pdu_size = pdu_length;
 
 		/* make sure we have enough to get to the MID */
-		if (server->pdu_size < HEADER_SIZE(server) - 1 -
-		    HEADER_PREAMBLE_SIZE(server)) {
+		if (server->pdu_size < MID_HEADER_SIZE(server)) {
 			cifs_server_dbg(VFS, "SMB response too short (%u bytes)\n",
 				 server->pdu_size);
 			cifs_reconnect(server, true);
@@ -1209,8 +1207,7 @@ cifs_demultiplex_thread(void *p)
 		/* read down to the MID */
 		length = cifs_read_from_socket(server,
 			     buf + HEADER_PREAMBLE_SIZE(server),
-			     HEADER_SIZE(server) - 1 -
-			     HEADER_PREAMBLE_SIZE(server));
+			     MID_HEADER_SIZE(server));
 		if (length < 0)
 			continue;
 		server->total_read += length;
-- 
2.31.1

