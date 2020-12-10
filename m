Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F10DC4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 09:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E18123BE5
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 09:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729891AbgLJJIb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Dec 2020 04:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgLJJIa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Dec 2020 04:08:30 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923B4C0613CF;
        Thu, 10 Dec 2020 01:07:49 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id w6so3458203pfu.1;
        Thu, 10 Dec 2020 01:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PNWxza0pQ+gVMkdkA2hwtJMSzL/KzeSFs29w2WSx87k=;
        b=ex8eMwwg+1pYMSXqc8U+dJLvFIBTeWWOvq0KxqtK3n7SRoxAFXfmvlUjLU9G+hdSUA
         rwqq6JT49Vz0O1XZ72lVUXaooBdxUWq2d31QbqvGIlNsKlyteHuPQrvU/4bttqbl83VL
         k4qIdVt7OTIlulM9xMuNmwJ6gnztZ+xmMcs7xx8R6W3xXGvMgwHIyIvr25s5ufKYb6Uw
         Sek4x81m6YqHArlqsXvMWt8cgnNpiVABEhnY3KUBX/gbRTD+u3fJ6X9fqCh9hu60cMG9
         uS+arR0nGpY0E+SKmpa7ZgO7wPjgXt1ZajGOjvOKKfd6WzRIzXgtFqlpPxSuR1u6rdTS
         f75g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PNWxza0pQ+gVMkdkA2hwtJMSzL/KzeSFs29w2WSx87k=;
        b=SBui9/+5k+eldbwZbrEaSBSmt6xYoH/64gvbqvR8l97rm8pjcZCIN5w5M1Dqe+xSSc
         vGZ2ViQKgOnkgSEvKiKunrEjDPk/3NWE0DcK5HC6zhE10N5vemhy92n8ynT/HJugZSyj
         WUPgluopknej+YSN7qu37rj37pj5oZFB64JhldB6bXKrNzcvxraiL4XuSTyEJAy72LIn
         wCOwMi6JNWDhCur1eCE2o2JDBFYal9MndEKJs5TxNQrHJEyaAdpLzTCMU2+9LLxDJX29
         5nQOotscL0J+vfUHhK5i8g0CxbAnxH74o7B44h7yJHnFu+S5nQ6levLV3Ox9NvD9kAlY
         46pw==
X-Gm-Message-State: AOAM532spnuIY+XgfIZb2kNdpS6nig70H8/2lU1a3+TNRE4VIfNHox26
        SItxvCeY3oMyX54qwdlsReo=
X-Google-Smtp-Source: ABdhPJwgEuB7RbOC6nXm978xX2NHpAWcNUjxnIoxQjK+9blYMkJZ2vftqct6ZXKfs3lXQNLIovXz7A==
X-Received: by 2002:a05:6a00:7c5:b029:19e:2965:7a6 with SMTP id n5-20020a056a0007c5b029019e296507a6mr5756116pfu.60.1607591269172;
        Thu, 10 Dec 2020 01:07:49 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id n127sm5815328pfd.143.2020.12.10.01.07.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Dec 2020 01:07:48 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, yejune.deng@gmail.com
Subject: [PATCH] cifs: fix msleep() is imprecise
Date:   Thu, 10 Dec 2020 17:07:38 +0800
Message-Id: <1607591258-13865-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

See Documentation/timers/timers-howto.rst, msleep() is not
for (1ms - 20ms), There is a more advanced API is used.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 fs/cifs/cifsfs.c    |  4 ++--
 fs/cifs/connect.c   | 14 +++++++-------
 fs/cifs/file.c      |  6 +++---
 fs/cifs/smbdirect.c |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 472cb77..d35ce52 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -664,10 +664,10 @@ static void cifs_umount_begin(struct super_block *sb)
 		cifs_dbg(FYI, "wake up tasks now - umount begin not complete\n");
 		wake_up_all(&tcon->ses->server->request_q);
 		wake_up_all(&tcon->ses->server->response_q);
-		msleep(1); /* yield */
+		fsleep(1000); /* yield */
 		/* we have to kick the requests once more */
 		wake_up_all(&tcon->ses->server->response_q);
-		msleep(1);
+		fsleep(1000);
 	}
 
 	return;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 44f9cce..62a9c64 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -538,7 +538,7 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
 		if (rc) {
 			cifs_dbg(FYI, "reconnect error %d\n", rc);
 			mutex_unlock(&server->srv_mutex);
-			msleep(3000);
+			ssleep(3);
 		} else {
 			atomic_inc(&tcpSesReconnectCount);
 			set_credits(server, 1);
@@ -621,7 +621,7 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
 		server->bigbuf = (char *)cifs_buf_get();
 		if (!server->bigbuf) {
 			cifs_server_dbg(VFS, "No memory for large SMB response\n");
-			msleep(3000);
+			ssleep(3);
 			/* retry will check if exiting */
 			return false;
 		}
@@ -634,7 +634,7 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
 		server->smallbuf = (char *)cifs_small_buf_get();
 		if (!server->smallbuf) {
 			cifs_server_dbg(VFS, "No memory for SMB response\n");
-			msleep(1000);
+			ssleep(1);
 			/* retry will check if exiting */
 			return false;
 		}
@@ -729,7 +729,7 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
 			 * to clear and app threads to set tcpStatus
 			 * CifsNeedReconnect if server hung.
 			 */
-			usleep_range(1000, 2000);
+			fsleep(1000);
 			length = 0;
 			continue;
 		}
@@ -790,7 +790,7 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
 		 */
 		cifs_dbg(FYI, "RFC 1002 negative session response\n");
 		/* give server a second to clean up */
-		msleep(1000);
+		ssleep(1);
 		/*
 		 * Always try 445 first on reconnect since we get NACK
 		 * on some if we ever connected to port 139 (the NACK
@@ -944,7 +944,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		 * response and going ahead and killing cifsd.
 		 */
 		cifs_dbg(FYI, "Wait for exit from demultiplex thread\n");
-		msleep(46000);
+		ssleep(46);
 		/*
 		 * If threads still have not exited they are probably never
 		 * coming home not much else we can do but free the memory.
@@ -3655,7 +3655,7 @@ static void rfc1002mangle(char *target, char *source, unsigned int length)
 		 * significant slowing down on mount
 		 * for everyone else
 		 */
-		usleep_range(1000, 2000);
+		fsleep(1000);
 	}
 	/*
 	 * else the negprot may still work without this
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index be46fab..75538a8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -283,7 +283,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 cifs_down_write(struct rw_semaphore *sem)
 {
 	while (!down_write_trylock(sem))
-		msleep(10);
+		fsleep(10000);
 }
 
 static void cifsFileInfo_put_work(struct work_struct *work);
@@ -2828,7 +2828,7 @@ size_t get_numpages(const size_t wsize, const size_t len, size_t *cur_len)
 
 			if (wsize < wdata->bytes) {
 				add_credits_and_wake_if(server, &credits, 0);
-				msleep(1000);
+				ssleep(1);
 			}
 		} while (wsize < wdata->bytes);
 		wdata->credits = credits;
@@ -3563,7 +3563,7 @@ static int cifs_resend_rdata(struct cifs_readdata *rdata,
 
 			if (rsize < rdata->bytes) {
 				add_credits_and_wake_if(server, &credits, 0);
-				msleep(1000);
+				ssleep(1);
 			}
 		} while (rsize < rdata->bytes);
 		rdata->credits = credits;
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index b029ed3..84f97f8 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1372,7 +1372,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	wake_up_interruptible_all(&info->wait_mr);
 	while (atomic_read(&info->mr_used_count)) {
 		mutex_unlock(&server->srv_mutex);
-		msleep(1000);
+		ssleep(1);
 		mutex_lock(&server->srv_mutex);
 	}
 	destroy_mr_list(info);
-- 
1.9.1

