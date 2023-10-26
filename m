Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D14C25B67
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Oct 2023 18:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjJZSHg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Oct 2023 14:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbjJZSHd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Oct 2023 14:07:33 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CFFC2
        for <linux-cifs@vger.kernel.org>; Thu, 26 Oct 2023 11:07:29 -0700 (PDT)
Message-ID: <92abdb27545d717b4e4898a1708b2013.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698343648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FcugxCW07hAnWatAa/4vfZXSXpHMMLRK1/b2xwS0Apw=;
        b=NMVFcE4JFgCTWR/+0+z34qJpXzLMyBtwdB9hf+Mu2gftCg2GqC0FUR6tE1cIixxOQgbtHy
        MWs+Sgk/UxS1V5r2Ry1dZUAFSwPZjvbQz6Z9duuR1wTbc7Vw9w5hqwpB13IuPCCz3VqhRx
        dw6+DroPuDFCjOiQ9HS0hr+Z9hU/D+9WOHIaapAyDRRyOBRuxctfdY7e+PXZ8a/7DbcCD+
        YJhEkhN0IHSkZ57PP1nFcHTX7qEe07cAhCCrl0M5NS98MUf0U028CBq9KvWs23ofuut66G
        GuzpfrZsu7L5bWZwrlYwZ0d5MKdr9XJ+37NgJHOgicRuP7n0vqXyUUPC/CWQ5g==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1698343648; a=rsa-sha256;
        cv=none;
        b=jbCWVTN0Jnh0I61UslODhMJue2MEy34CH6NpIUkvnS1ib7FsyA6vu6bO1MbdcBqx4XeEGp
        7NNGgWuf1EqqmCCyzUUhX3O+vMnXDjWC/KbT74BvlDo/twdPxm0GirSzf1oxTGye89ctZG
        eURrrTlP7SH8SBYE8OBfPV+AdsryVujCpI7wOv9qnjAK9Xvx7WBXzOT6YIx5wsIoFcOGoV
        jB/H6LtSYLrIWtYDeueiW5hex8vtTGdsGNoyiRSCcHR5nMxr/pVzx1XCH0jxJmD69k6j7J
        IjjNo7HPIToVo1oz42VMefkd7FQ1G49+HTS0bK6pBdNhjFGvO9r5F9VlteRRng==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698343648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FcugxCW07hAnWatAa/4vfZXSXpHMMLRK1/b2xwS0Apw=;
        b=pLEgx4IMQOnL9/niZtb1TI/oHKOCRJf02+GfxPYWHkEVFiMVL+oJmwnSolLBagsvJw1nou
        fpII4dz5ayUg1mgxJjNKYY6JJY8KSAZVXM/cyd5cjJ3liW34gMfj3nhawFHKBjOzVHC8ZU
        T5b+2A3eOwHWXJMWWm/tqc3ztSsgq0BZsNuLOGnn/M7UYTtBVan1IBw3VjQErFO5angjGT
        Gc2esmlpvpfky6v1+ysTRb1utN2YoMIC9eMU+jnQbFOpM3qchlpEPvjhcXdy5DjiJTkPCm
        j/KTfUkCMF/3IyF5gjvflLCuPhmh4i6T4jhMapMxGZEk1ydGj78gwTYAkOk4HQ==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Frank Sorenson <frank@tuxrocks.com>, linux-cifs@vger.kernel.org
Subject: Re: possible circular locking dependency detected warning and deadlock
In-Reply-To: <e04c7696-fc8a-b799-13f9-2cc051ba80dd@redhat.com>
References: <e04c7696-fc8a-b799-13f9-2cc051ba80dd@redhat.com>
Date:   Thu, 26 Oct 2023 15:07:22 -0300
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain

Frank Sorenson <frank@tuxrocks.com> writes:

> I'm getting a 'WARNING: possible circular locking dependency detected' 
> followed by a DEADLOCK when I access /proc/fs/cifs/DebugData while doing 
> a lot of mounts/unmounts/IO, etc.

Could you please retry with attached patches?

I was able to reproduce an GPF with a similar test by running xfstests
from Steve's for-next branch with

        'vers=3.1.1,multichannel,max_channels=2'

against Windows Server 2022.

No deadlocks or lockdep warnings.  The deadlock fix from second patch
was just based on code analysis.

--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=0001-smb-client-fix-use-after-free-bug-in-cifs_debug_data.patch

From f5d9cff737b04d99510e7b824253a36652b185d9 Mon Sep 17 00:00:00 2001
From: Paulo Alcantara <pc@manguebit.com>
Date: Tue, 24 Oct 2023 13:49:15 -0300
Subject: [PATCH 1/2] smb: client: fix use-after-free bug in
 cifs_debug_data_proc_show()

Skip SMB sessions that are being teared down
(e.g. @ses->ses_status == SES_EXITING) in cifs_debug_data_proc_show()
to avoid use-after-free in @ses.

This fixes the following GPF when reading from /proc/fs/cifs/DebugData
while mounting and umounting

  [ 816.251274] general protection fault, probably for non-canonical
  address 0x6b6b6b6b6b6b6d81: 0000 [#1] PREEMPT SMP NOPTI
  ...
  [  816.260138] Call Trace:
  [  816.260329]  <TASK>
  [  816.260499]  ? die_addr+0x36/0x90
  [  816.260762]  ? exc_general_protection+0x1b3/0x410
  [  816.261126]  ? asm_exc_general_protection+0x26/0x30
  [  816.261502]  ? cifs_debug_tcon+0xbd/0x240 [cifs]
  [  816.261878]  ? cifs_debug_tcon+0xab/0x240 [cifs]
  [  816.262249]  cifs_debug_data_proc_show+0x516/0xdb0 [cifs]
  [  816.262689]  ? seq_read_iter+0x379/0x470
  [  816.262995]  seq_read_iter+0x118/0x470
  [  816.263291]  proc_reg_read_iter+0x53/0x90
  [  816.263596]  ? srso_alias_return_thunk+0x5/0x7f
  [  816.263945]  vfs_read+0x201/0x350
  [  816.264211]  ksys_read+0x75/0x100
  [  816.264472]  do_syscall_64+0x3f/0x90
  [  816.264750]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
  [  816.265135] RIP: 0033:0x7fd5e669d381

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifs_debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 76922fcc4bc6..9a0ccd87468e 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -452,6 +452,11 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "\n\n\tSessions: ");
 		i = 0;
 		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			spin_lock(&ses->ses_lock);
+			if (ses->ses_status == SES_EXITING) {
+				spin_unlock(&ses->ses_lock);
+				continue;
+			}
 			i++;
 			if ((ses->serverDomain == NULL) ||
 				(ses->serverOS == NULL) ||
@@ -472,6 +477,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				ses->ses_count, ses->serverOS, ses->serverNOS,
 				ses->capabilities, ses->ses_status);
 			}
+			spin_unlock(&ses->ses_lock);
 
 			seq_printf(m, "\n\tSecurity type: %s ",
 				get_security_type_str(server->ops->select_sectype(server, ses->sectype)));
-- 
2.42.0


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=0002-smb-client-fix-potential-deadlock-when-releasing-mid.patch

From 42a1b90a00bfb4315d1d30b17ca8524d5ece4f82 Mon Sep 17 00:00:00 2001
From: Paulo Alcantara <pc@manguebit.com>
Date: Wed, 25 Oct 2023 14:58:35 -0300
Subject: [PATCH 2/2] smb: client: fix potential deadlock when releasing mids

All release_mid() callers seem to hold a reference of @mid so there is
no need to call kref_put(&mid->refcount, __release_mid) under
@server->mid_lock spinlock.  If they don't, then an use-after-free bug
would have caused anyways.

By getting rid of such spinlock also fixes a potential deadlock as
shown below

CPU 0                                CPU 1
------------------------------------------------------------------
cifs_demultiplex_thread()            cifs_debug_data_proc_show()
 release_mid()
  spin_lock(&server->mid_lock);
                                     spin_lock(&cifs_tcp_ses_lock)
				      spin_lock(&server->mid_lock)
  __release_mid()
   smb2_find_smb_tcon()
    spin_lock(&cifs_tcp_ses_lock) *deadlock*

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsproto.h |  7 ++++++-
 fs/smb/client/smb2misc.c  |  2 +-
 fs/smb/client/transport.c | 11 +----------
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 0c37eefa18a5..890ceddae07e 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -81,7 +81,7 @@ extern char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 char *cifs_build_devname(char *nodename, const char *prepath);
 extern void delete_mid(struct mid_q_entry *mid);
-extern void release_mid(struct mid_q_entry *mid);
+void __release_mid(struct kref *refcount);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
@@ -740,4 +740,9 @@ static inline bool dfs_src_pathname_equal(const char *s1, const char *s2)
 	return true;
 }
 
+static inline void release_mid(struct mid_q_entry *mid)
+{
+	kref_put(&mid->refcount, __release_mid);
+}
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 25f7cd6f23d6..32dfa0f7a78c 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -787,7 +787,7 @@ __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
 {
 	struct close_cancelled_open *cancelled;
 
-	cancelled = kzalloc(sizeof(*cancelled), GFP_ATOMIC);
+	cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
 	if (!cancelled)
 		return -ENOMEM;
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 14710afdc2a3..d553b7a54621 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -76,7 +76,7 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	return temp;
 }
 
-static void __release_mid(struct kref *refcount)
+void __release_mid(struct kref *refcount)
 {
 	struct mid_q_entry *midEntry =
 			container_of(refcount, struct mid_q_entry, refcount);
@@ -156,15 +156,6 @@ static void __release_mid(struct kref *refcount)
 	mempool_free(midEntry, cifs_mid_poolp);
 }
 
-void release_mid(struct mid_q_entry *mid)
-{
-	struct TCP_Server_Info *server = mid->server;
-
-	spin_lock(&server->mid_lock);
-	kref_put(&mid->refcount, __release_mid);
-	spin_unlock(&server->mid_lock);
-}
-
 void
 delete_mid(struct mid_q_entry *mid)
 {
-- 
2.42.0


--=-=-=--
