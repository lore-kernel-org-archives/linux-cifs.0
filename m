Return-Path: <SRS0=0fOs=4L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB35C35671
	for <linux-cifs@archiver.kernel.org>; Sun, 23 Feb 2020 04:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12914206D7
	for <linux-cifs@archiver.kernel.org>; Sun, 23 Feb 2020 04:11:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W93IWvUv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgBWEK7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Feb 2020 23:10:59 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:54814 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgBWEK7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 Feb 2020 23:10:59 -0500
Received: by mail-pj1-f65.google.com with SMTP id dw13so2560008pjb.4
        for <linux-cifs@vger.kernel.org>; Sat, 22 Feb 2020 20:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=znst/61SMQoegV1KpACYLjyRx/4kUV+wCrGP/kXWePk=;
        b=W93IWvUvmVyaK/pR/FPx6WgK9Z0DhiFsu8Qy6TIN2JXegn1okoHpMxNlW7WdjdnFVU
         xu7wARE3GGZgg/UZKH+n60oChaqktpjNJmH0wnGIxMQEq5Of/e8io7NkFJyXVnib5jHV
         ujVzeM4pKHl2s6Vj1QHRF02kdeJm+REQsqTYfO02+uPX1v/zBmBs4AFmvlTeJMaC+bnU
         gTjhV0HTqelqIRicJZ4yACt6NQVvCGMyRsMXHakeV5KYs+EzbjJy+1HHlJpsCek+2b4d
         15fcScOW7uH9GOnywAYLiit735Que4jVh1P902gr1Nh9qgI4Z/I9RRE/+c+OxVXMZw8u
         hMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=znst/61SMQoegV1KpACYLjyRx/4kUV+wCrGP/kXWePk=;
        b=s3A5hf/WA95bCJwzC0Mlkc4bHD8l2wK7CF6uxo9T6AkFjIwZZHDIDpZ4f3PfEHZlbR
         R6CeGmqSDXPS3YYGnPLT9jRpvMZeSuiTOiNA+oiNsRE4EzA0LxE17IHQADIWbygmNoZa
         C1Xf/Is8uxrlGl44EeXNw+tBgPqYI6DLANyl+V7El4ZdxovoIkMoJxTsvV4bDODA6yUG
         EH18PS2sl8BbT+nSzbeTHAmkIZN9uuYaof4esHmzjKwKRknKB2+OQebNAHC9ZilUe40+
         HS+qQSxfQR/E4c/XtMvqhu1GS7nN6Mw9OOqcRpc60dt+jB8Bvtsua07UbjWs9I3jSU36
         IJ/w==
X-Gm-Message-State: APjAAAViguiWIPYpJvso6WxtR4bopMi+pmLyHGBgqm+hz6A+sNupv2OO
        vhtvy32x7ia4mrRs0/js+ns=
X-Google-Smtp-Source: APXvYqwZokIEuCBhoZEhdMhYIcCRJPhi/wcjGiv4jjfJNTg9yd/6c5etliowNIOjKqbPT6gfHeNwow==
X-Received: by 2002:a17:90a:f492:: with SMTP id bx18mr13037679pjb.118.1582431058597;
        Sat, 22 Feb 2020 20:10:58 -0800 (PST)
Received: from localhost ([43.224.245.179])
        by smtp.gmail.com with ESMTPSA id a9sm7457859pjk.1.2020.02.22.20.10.57
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 22 Feb 2020 20:10:58 -0800 (PST)
From:   qiwuchen55@gmail.com
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        chenqiwu <chenqiwu@xiaomi.com>
Subject: [PATCH] cifs/cifs_debug: convert to list_for_each_entry()
Date:   Sun, 23 Feb 2020 12:10:51 +0800
Message-Id: <1582431051-30388-1-git-send-email-qiwuchen55@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: chenqiwu <chenqiwu@xiaomi.com>

Use list_for_each() instead of list_for_each_entry()
to simplify code.

Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
---
 fs/cifs/cifs_debug.c | 69 +++++++++++++++-------------------------------------
 1 file changed, 19 insertions(+), 50 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 276e4b5..0ab6e53 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -48,7 +48,6 @@ void cifs_dump_detail(void *buf, struct TCP_Server_Info *server)
 void cifs_dump_mids(struct TCP_Server_Info *server)
 {
 #ifdef CONFIG_CIFS_DEBUG2
-	struct list_head *tmp;
 	struct mid_q_entry *mid_entry;
 
 	if (server == NULL)
@@ -56,8 +55,7 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 
 	cifs_dbg(VFS, "Dump pending requests:\n");
 	spin_lock(&GlobalMid_Lock);
-	list_for_each(tmp, &server->pending_mid_q) {
-		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+	list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
 		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
 			 mid_entry->mid_state,
 			 le16_to_cpu(mid_entry->command),
@@ -163,7 +161,6 @@ static void cifs_debug_tcon(struct seq_file *m, struct cifs_tcon *tcon)
 
 static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 {
-	struct list_head *stmp, *tmp, *tmp1, *tmp2;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -178,17 +175,12 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, " <filename>\n");
 #endif /* CIFS_DEBUG2 */
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(stmp, &cifs_tcp_ses_list) {
-		server = list_entry(stmp, struct TCP_Server_Info,
-				    tcp_ses_list);
-		list_for_each(tmp, &server->smb_ses_list) {
-			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
-			list_for_each(tmp1, &ses->tcon_list) {
-				tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				spin_lock(&tcon->open_file_lock);
-				list_for_each(tmp2, &tcon->openFileList) {
-					cfile = list_entry(tmp2, struct cifsFileInfo,
-						     tlist);
+				list_for_each_entry(cfile, &tcon->openFileList,
+						    tlist) {
 					seq_printf(m,
 						"0x%x 0x%llx 0x%x %d %d %d %s",
 						tcon->tid,
@@ -215,7 +207,6 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 
 static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 {
-	struct list_head *tmp1, *tmp2, *tmp3;
 	struct mid_q_entry *mid_entry;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
@@ -269,9 +260,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 	i = 0;
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp1, &cifs_tcp_ses_list) {
-		server = list_entry(tmp1, struct TCP_Server_Info,
-				    tcp_ses_list);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
 		if (!server->rdma)
@@ -355,9 +344,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			seq_printf(m, " posix");
 
 		i++;
-		list_for_each(tmp2, &server->smb_ses_list) {
-			ses = list_entry(tmp2, struct cifs_ses,
-					 smb_ses_list);
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
 			if ((ses->serverDomain == NULL) ||
 				(ses->serverOS == NULL) ||
 				(ses->serverNOS == NULL)) {
@@ -413,9 +400,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			else
 				seq_puts(m, "none\n");
 
-			list_for_each(tmp3, &ses->tcon_list) {
-				tcon = list_entry(tmp3, struct cifs_tcon,
-						  tcon_list);
+			list_for_each(tcon, &ses->tcon_list, tcon_list) {
 				++j;
 				seq_printf(m, "\n\t%d) ", j);
 				cifs_debug_tcon(m, tcon);
@@ -424,9 +409,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			seq_puts(m, "\n\tMIDs:\n");
 
 			spin_lock(&GlobalMid_Lock);
-			list_for_each(tmp3, &server->pending_mid_q) {
-				mid_entry = list_entry(tmp3, struct mid_q_entry,
-					qhead);
+			list_for_each_entry(mid_entry, &server->pending_mid_q,
+					    qhead) {
 				seq_printf(m, "\tState: %d com: %d pid:"
 					      " %d cbdata: %p mid %llu\n",
 					      mid_entry->mid_state,
@@ -465,7 +449,6 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 {
 	bool bv;
 	int rc;
-	struct list_head *tmp1, *tmp2, *tmp3;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -486,9 +469,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 		GlobalCurrentXid = 0;
 		spin_unlock(&GlobalMid_Lock);
 		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each(tmp1, &cifs_tcp_ses_list) {
-			server = list_entry(tmp1, struct TCP_Server_Info,
-					    tcp_ses_list);
+		list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 			server->max_in_flight = 0;
 #ifdef CONFIG_CIFS_STATS2
 			for (i = 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
@@ -499,13 +480,10 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 				server->fastest_cmd[0] = 0;
 			}
 #endif /* CONFIG_CIFS_STATS2 */
-			list_for_each(tmp2, &server->smb_ses_list) {
-				ses = list_entry(tmp2, struct cifs_ses,
-						 smb_ses_list);
-				list_for_each(tmp3, &ses->tcon_list) {
-					tcon = list_entry(tmp3,
-							  struct cifs_tcon,
-							  tcon_list);
+			list_for_each_entry(ses, &server->smb_ses_list,
+					    smb_ses_list) {
+				list_for_each_entry(tcon, &ses->tcon_list,
+						    tcon_list) {
 					atomic_set(&tcon->num_smbs_sent, 0);
 					spin_lock(&tcon->stat_lock);
 					tcon->bytes_read = 0;
@@ -530,7 +508,6 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 #ifdef CONFIG_CIFS_STATS2
 	int j;
 #endif /* STATS2 */
-	struct list_head *tmp1, *tmp2, *tmp3;
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -561,9 +538,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 
 	i = 0;
 	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each(tmp1, &cifs_tcp_ses_list) {
-		server = list_entry(tmp1, struct TCP_Server_Info,
-				    tcp_ses_list);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
 		seq_printf(m, "\nMax requests in flight: %d", server->max_in_flight);
 #ifdef CONFIG_CIFS_STATS2
 		seq_puts(m, "\nTotal time spent processing by command. Time ");
@@ -582,15 +557,9 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 					atomic_read(&server->smb2slowcmd[j]),
 					server->hostname, j);
 #endif /* STATS2 */
-		list_for_each(tmp2, &server->smb_ses_list) {
-			ses = list_entry(tmp2, struct cifs_ses,
-					 smb_ses_list);
-			list_for_each(tmp3, &ses->tcon_list) {
-				tcon = list_entry(tmp3,
-						  struct cifs_tcon,
-						  tcon_list);
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 				i++;
-				seq_printf(m, "\n%d) %s", i, tcon->treeName);
 				if (tcon->need_reconnect)
 					seq_puts(m, "\tDISCONNECTED ");
 				seq_printf(m, "\nSMBs: %d",
-- 
1.9.1

