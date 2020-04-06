Return-Path: <SRS0=Q1a1=5W=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F071AC2BA19
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Apr 2020 11:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF93F206C3
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Apr 2020 11:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgDFLec (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Apr 2020 07:34:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:53760 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727181AbgDFLec (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 Apr 2020 07:34:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EB822AEB8;
        Mon,  6 Apr 2020 11:34:29 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH v3] cifs: ignore cached share root handle closing errors
Date:   Mon,  6 Apr 2020 13:34:26 +0200
Message-Id: <20200406113426.20699-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix tcon use-after-free and NULL ptr deref.

Customer system crashes with the following kernel log:

[462233.169868] CIFS VFS: Cancelling wait for mid 4894753 cmd: 14       => a QUERY DIR
[462233.228045] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=-4
[462233.305922] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=-4
[462233.306205] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=-4
[462233.347060] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=-4
[462233.347107] CIFS VFS: Close unmatched open
[462233.347113] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
...
    [exception RIP: cifs_put_tcon+0xa0] (this is doing tcon->ses->server)
 #6 [...] smb2_cancelled_close_fid at ... [cifs]
 #7 [...] process_one_work at ...
 #8 [...] worker_thread at ...
 #9 [...] kthread at ...

The most likely explanation we have is:

* When we put the last reference of a tcon (refcount=0), we close the
  cached share root handle.
* If closing a handle is interrupted, SMB2_close() will
  queue a SMB2_close() in a work thread.
* The queued object keeps a tcon ref so we bump the tcon
  refcount, jumping from 0 to 1.
* We reach the end of cifs_put_tcon(), we free the tcon object despite
  it now having a refcount of 1.
* The queued work now runs, but the tcon, ses & server was freed in
  the meantime resulting in a crash.

THREAD 1
========
cifs_put_tcon                 => tcon refcount reach 0
  SMB2_tdis
   close_shroot_lease
    close_shroot_lease_locked => if cached root has lease && refcount = 0
     smb2_close_cached_fid    => if cached root valid
      SMB2_close              => retry close in a thread if interrupted
       smb2_handle_cancelled_close
        __smb2_handle_cancelled_close    => !! tcon refcount bump 0 => 1 !!
         INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
         queue_work(cifsiod_wq, &cancelled->work) => queue work
 tconInfoFree(tcon);    ==> freed!
 cifs_put_smb_ses(ses); ==> freed!

THREAD 2 (workqueue)
========
smb2_cancelled_close_fid
  SMB2_close(0, cancelled->tcon, ...); => use-after-free of tcon
  cifs_put_tcon(cancelled->tcon);      => tcon refcount reach 0 second time
  *CRASH*

Fixes: d9191319358d ("CIFS: Close cached root handle only if it has a lease")
Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
changes since v2:
* add WARN_ONCE
* show server hostname & tid
* VFS -> FYI

 fs/cifs/smb2misc.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 0511aaf451d4..cfa57e3ad352 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -766,6 +766,21 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 
 	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
 	spin_lock(&cifs_tcp_ses_lock);
+	if (tcon->tc_count <= 0) {
+		const char *host = "(null)";
+
+		WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative");
+		spin_unlock(&cifs_tcp_ses_lock);
+
+		if (tcon->ses && tcon->ses->server
+		    && tcon->ses->server->hostname)
+			host = tcon->ses->server->hostname;
+
+		cifs_dbg(FYI, "\\\\%s tid=%u: tcon is closing, skipping async close retry of fid %llu %llu\n",
+			 host, tcon->tid, persistent_fid, volatile_fid);
+
+		return 0;
+	}
 	tcon->tc_count++;
 	spin_unlock(&cifs_tcp_ses_lock);
 
-- 
2.16.4

