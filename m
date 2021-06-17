Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C19C2B9F4
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Jun 2021 11:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48FC2613CE
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Jun 2021 11:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhFQL3u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Jun 2021 07:29:50 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7353 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhFQL3u (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Jun 2021 07:29:50 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G5KSD64XCz6y79;
        Thu, 17 Jun 2021 19:23:40 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 19:27:41 +0800
Received: from huawei.com (10.175.127.227) by dggpeml500020.china.huawei.com
 (7.185.36.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 17 Jun
 2021 19:27:40 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <libaokun1@huawei.com>, Steve French <sfrench@samba.org>
CC:     <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] cifs: convert list_for_each to entry variant in cifs_debug.c
Date:   Thu, 17 Jun 2021 19:36:40 +0800
Message-ID: <20210617113640.4141487-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
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
 fs/cifs/cifs_debug.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 68e8e5b27841..8857ac7e7a14 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -50,7 +50,6 @@ void cifs_dump_detail(void *buf, struct TCP_Server_Info *server)
 void cifs_dump_mids(struct TCP_Server_Info *server)
 {
 #ifdef CONFIG_CIFS_DEBUG2
-	struct list_head *tmp;
 	struct mid_q_entry *mid_entry;
 
 	if (server == NULL)
@@ -58,8 +57,7 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 
 	cifs_dbg(VFS, "Dump pending requests:\n");
 	spin_lock(&GlobalMid_Lock);
-	list_for_each(tmp, &server->pending_mid_q) {
-		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+	list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
 		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
 			 mid_entry->mid_state,
 			 le16_to_cpu(mid_entry->command),
@@ -168,7 +166,7 @@ cifs_dump_iface(struct seq_file *m, struct cifs_server_iface *iface)
 
 static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 {
-	struct list_head *stmp, *tmp, *tmp1, *tmp2;
+	struct list_head *tmp, *tmp1, *tmp2;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -183,9 +181,7 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, " <filename>\n");
 #endif /* CIFS_DEBUG2 */
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(stmp, &cifs_tcp_ses_list) {
-		server = list_entry(stmp, struct TCP_Server_Info,
-				    tcp_ses_list);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 		list_for_each(tmp, &server->smb_ses_list) {
 			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
 			list_for_each(tmp1, &ses->tcon_list) {
@@ -220,7 +216,7 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 
 static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 {
-	struct list_head *tmp1, *tmp2, *tmp3;
+	struct list_head *tmp2, *tmp3;
 	struct mid_q_entry *mid_entry;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
@@ -278,11 +274,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 	c = 0;
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp1, &cifs_tcp_ses_list) {
-		server = list_entry(tmp1, struct TCP_Server_Info,
-				    tcp_ses_list);
-
-		/* channel info will be printed as a part of sessions below */
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 		if (server->is_channel)
 			continue;
 
@@ -563,7 +555,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 #ifdef CONFIG_CIFS_STATS2
 	int j;
 #endif /* STATS2 */
-	struct list_head *tmp1, *tmp2, *tmp3;
+	struct list_head *tmp2, *tmp3;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -594,9 +586,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 
 	i = 0;
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp1, &cifs_tcp_ses_list) {
-		server = list_entry(tmp1, struct TCP_Server_Info,
-				    tcp_ses_list);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 		seq_printf(m, "\nMax requests in flight: %d", server->max_in_flight);
 #ifdef CONFIG_CIFS_STATS2
 		seq_puts(m, "\nTotal time spent processing by command. Time ");

