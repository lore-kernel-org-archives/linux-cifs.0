Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEE3C32772
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 15:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243177AbiHWPFQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 11:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243238AbiHWPEv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 11:04:51 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BC131FC35
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 05:29:36 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MBnbH5SrCzlWR8;
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
Subject: [PATCH -next 3/3] cifs: Add helper function to check smb1+ server
Date:   Tue, 23 Aug 2022 20:52:02 +0800
Message-ID: <20220823125202.1156172-4-zhangxiaoxu5@huawei.com>
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

SMB1 server's header_preamble_size is not 0, add use is_smb1 function
to simplify the code, no actual functional changes.

Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/cifsencrypt.c |  3 +--
 fs/cifs/cifsglob.h    |  5 +++++
 fs/cifs/connect.c     | 10 +++++-----
 fs/cifs/transport.c   |  4 ++--
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 61a9fed56548..46f5718754f9 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -32,10 +32,9 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
 	int rc;
 	struct kvec *iov = rqst->rq_iov;
 	int n_vec = rqst->rq_nvec;
-	bool is_smb2 = HEADER_PREAMBLE_SIZE(server) == 0;
 
 	/* iov[0] is actual data and not the rfc1002 length for SMB2+ */
-	if (is_smb2) {
+	if (!is_smb1(server)) {
 		if (iov[0].iov_len <= 4)
 			return -EIO;
 		i = 0;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 544f69634063..45d21ebaff9f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -751,6 +751,11 @@ struct TCP_Server_Info {
 #endif
 };
 
+static inline bool is_smb1(struct TCP_Server_Info *server)
+{
+	return HEADER_PREAMBLE_SIZE(server) != 0;
+}
+
 static inline void cifs_server_lock(struct TCP_Server_Info *server)
 {
 	unsigned int nofs_flag = memalloc_nofs_save();
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 24df04d9b0f3..7d4f8119006d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -871,7 +871,7 @@ smb2_get_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 	/*
 	 * SMB1 does not use credits.
 	 */
-	if (HEADER_PREAMBLE_SIZE(server))
+	if (is_smb1(server))
 		return 0;
 
 	return le16_to_cpu(shdr->CreditRequest);
@@ -1121,7 +1121,7 @@ smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 	/*
 	 * SMB1 does not use credits.
 	 */
-	if (HEADER_PREAMBLE_SIZE(server))
+	if (is_smb1(server))
 		return;
 
 	if (shdr->CreditRequest) {
@@ -1179,10 +1179,10 @@ cifs_demultiplex_thread(void *p)
 		if (length < 0)
 			continue;
 
-		if (HEADER_PREAMBLE_SIZE(server) == 0)
-			server->total_read = 0;
-		else
+		if (is_smb1(server))
 			server->total_read = length;
+		else
+			server->total_read = 0;
 
 		/*
 		 * The right amount was read from socket - 4 bytes,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index bb1052dbac5b..c2fe035e573b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -261,7 +261,7 @@ smb_rqst_len(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	int nvec;
 	unsigned long buflen = 0;
 
-	if (HEADER_PREAMBLE_SIZE(server) == 0 && rqst->rq_nvec >= 2 &&
+	if (!is_smb1(server) && rqst->rq_nvec >= 2 &&
 	    rqst->rq_iov[0].iov_len == 4) {
 		iov = &rqst->rq_iov[1];
 		nvec = rqst->rq_nvec - 1;
@@ -346,7 +346,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	sigprocmask(SIG_BLOCK, &mask, &oldmask);
 
 	/* Generate a rfc1002 marker for SMB2+ */
-	if (HEADER_PREAMBLE_SIZE(server) == 0) {
+	if (!is_smb1(server)) {
 		struct kvec hiov = {
 			.iov_base = &rfc1002_marker,
 			.iov_len  = 4
-- 
2.31.1

