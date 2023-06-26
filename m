Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A254EB64DC
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 03:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjFZDna (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 25 Jun 2023 23:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjFZDn3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 25 Jun 2023 23:43:29 -0400
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF8B188
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 20:43:26 -0700 (PDT)
X-QQ-mid: bizesmtp77t1687750996tygbpvnd
Received: from localhost.localdomain ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 26 Jun 2023 11:43:15 +0800 (CST)
X-QQ-SSF: 01400000000000F0H000000A0000000
X-QQ-FEAT: 3M0okmaRx3jaQPzfpSY30cB71JE3+l7VvClHz0nSRgn8ncW8qHqGSJk/f8oaB
        +NEURMWYhag5gGtMmfqv3lgL1VYfB/rVqMwEEo55njWBSQLWcBLdPUgkCQX+Be99Ghq/Akr
        RqfxESq/7hySNBtVrz6HzU9yyxuWmY02PUXbo5f4NMJJxFRwsEZvhKROMlhJGaPcVAi4+3n
        HljNTB5f/vW1F4EbQUZvjAuVgH8j1qAfQ1QIKPp0nLFDUooRoL5qedHb2R6ILrgC/N4Zlvt
        xVEiGitjnYTZ+4GIK+N4/F+TU2PnmKJmLVSUrDZXSY/cpl0/0jL+Gm0cbmFjGvOP9+nUYYS
        lrGIcLms6bJaJ9JRxydzaOiS1MCNCrl1BkoXJQUttppVWym9rWPTuCVEqZFwY/KLlOmkZ6Z
        omMcsyW7YLIjpCxwEPxw1A==
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1665100745496941920
From:   Winston Wen <wentao@uniontech.com>
To:     sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.com,
        sprasad@microsoft.com
Cc:     Winston Wen <wentao@uniontech.com>
Subject: [PATCH 1/3] cifs: fix session state transition to avoid use-after-free issue
Date:   Mon, 26 Jun 2023 11:42:55 +0800
Message-Id: <20230626034257.2078391-2-wentao@uniontech.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230626034257.2078391-1-wentao@uniontech.com>
References: <20230626034257.2078391-1-wentao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We switch session state to SES_EXITING without cifs_tcp_ses_lock now,
it may lead to potential use-after-free issue.

Consider the following execution processes:

Thread 1:
__cifs_put_smb_ses()
    spin_lock(&cifs_tcp_ses_lock)
    if (--ses->ses_count > 0)
        spin_unlock(&cifs_tcp_ses_lock)
        return
    spin_unlock(&cifs_tcp_ses_lock)
        ---> **GAP**
    spin_lock(&ses->ses_lock)
    if (ses->ses_status == SES_GOOD)
        ses->ses_status = SES_EXITING
    spin_unlock(&ses->ses_lock)

Thread 2:
cifs_find_smb_ses()
    spin_lock(&cifs_tcp_ses_lock)
    list_for_each_entry(ses, ...)
        spin_lock(&ses->ses_lock)
        if (ses->ses_status == SES_EXITING)
            spin_unlock(&ses->ses_lock)
            continue
        ...
        spin_unlock(&ses->ses_lock)
    if (ret)
        cifs_smb_ses_inc_refcount(ret)
    spin_unlock(&cifs_tcp_ses_lock)

If thread 1 is preempted in the gap and thread 2 start executing, thread 2
will get the session, and soon thread 1 will switch the session state to
SES_EXITING and start releasing it, even though thread 1 had increased the
session's refcount and still uses it.

So switch session state under cifs_tcp_ses_lock to eliminate this gap.

Signed-off-by: Winston Wen <wentao@uniontech.com>
---
 fs/smb/client/connect.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 9d16626e7a66..165ecb222c19 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1963,15 +1963,16 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
 	}
+	spin_lock(&ses->ses_lock);
+	if (ses->ses_status == SES_GOOD)
+		ses->ses_status = SES_EXITING;
+	spin_unlock(&ses->ses_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/* ses_count can never go negative */
 	WARN_ON(ses->ses_count < 0);
 
 	spin_lock(&ses->ses_lock);
-	if (ses->ses_status == SES_GOOD)
-		ses->ses_status = SES_EXITING;
-
 	if (ses->ses_status == SES_EXITING && server->ops->logoff) {
 		spin_unlock(&ses->ses_lock);
 		cifs_free_ipc(ses);
-- 
2.40.1

