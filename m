Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFE1C49EA2
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 03:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CEFE61369
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 03:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhFRDzv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Jun 2021 23:55:51 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8269 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhFRDzu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Jun 2021 23:55:50 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G5lJh0CjNz1BN5G;
        Fri, 18 Jun 2021 11:48:36 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 11:53:38 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 18 Jun
 2021 11:53:38 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <libaokun1@huawei.com>, Steve French <sfrench@samba.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>,
        <kernel-janitors@vger.kernel.org>, "Hulk Robot" <hulkci@huawei.com>
Subject: [PATCH -next v2] cifs: convert list_for_each to entry variant in smb2misc.c
Date:   Fri, 18 Jun 2021 12:02:32 +0800
Message-ID: <20210618040232.2550645-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

convert list_for_each() to list_for_each_entry() where
applicable.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
V1->V2:
	Convert the missing list_for_each to entry

 fs/cifs/smb2misc.c | 33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 06d555d4da9a..aba048153f79 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -164,12 +164,10 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
 		struct smb2_transform_hdr *thdr =
 			(struct smb2_transform_hdr *)buf;
 		struct cifs_ses *ses = NULL;
-		struct list_head *tmp;
 
 		/* decrypt frame now that it is completely read in */
 		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each(tmp, &srvr->smb_ses_list) {
-			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+		list_for_each_entry(ses, &srvr->smb_ses_list, smb_ses_list) {
 			if (ses->Suid == thdr->SessionId)
 				break;
 
@@ -548,7 +546,6 @@ static bool
 smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
 {
 	__u8 lease_state;
-	struct list_head *tmp;
 	struct cifsFileInfo *cfile;
 	struct cifsInodeInfo *cinode;
 	int ack_req = le32_to_cpu(rsp->Flags &
@@ -556,8 +553,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
 
 	lease_state = le32_to_cpu(rsp->NewLeaseState);
 
-	list_for_each(tmp, &tcon->openFileList) {
-		cfile = list_entry(tmp, struct cifsFileInfo, tlist);
+	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 		cinode = CIFS_I(d_inode(cfile->dentry));
 
 		if (memcmp(cinode->lease_key, rsp->LeaseKey,
@@ -618,7 +614,6 @@ static bool
 smb2_is_valid_lease_break(char *buffer)
 {
 	struct smb2_lease_break *rsp = (struct smb2_lease_break *)buffer;
-	struct list_head *tmp, *tmp1, *tmp2;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -628,15 +623,9 @@ smb2_is_valid_lease_break(char *buffer)
 
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp, &cifs_tcp_ses_list) {
-		server = list_entry(tmp, struct TCP_Server_Info, tcp_ses_list);
-
-		list_for_each(tmp1, &server->smb_ses_list) {
-			ses = list_entry(tmp1, struct cifs_ses, smb_ses_list);
-
-			list_for_each(tmp2, &ses->tcon_list) {
-				tcon = list_entry(tmp2, struct cifs_tcon,
-						  tcon_list);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				spin_lock(&tcon->open_file_lock);
 				cifs_stats_inc(
 				    &tcon->stats.cifs_stats.num_oplock_brks);
@@ -687,7 +676,6 @@ bool
 smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 {
 	struct smb2_oplock_break *rsp = (struct smb2_oplock_break *)buffer;
-	struct list_head *tmp, *tmp1, *tmp2;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct cifsInodeInfo *cinode;
@@ -710,16 +698,11 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp, &server->smb_ses_list) {
-		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
-
-		list_for_each(tmp1, &ses->tcon_list) {
-			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
+	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 
 			spin_lock(&tcon->open_file_lock);
-			list_for_each(tmp2, &tcon->openFileList) {
-				cfile = list_entry(tmp2, struct cifsFileInfo,
-						     tlist);
+			list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 				if (rsp->PersistentFid !=
 				    cfile->fid.persistent_fid ||
 				    rsp->VolatileFid !=
-- 
2.31.1

