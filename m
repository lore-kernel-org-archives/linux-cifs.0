Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F645C4167D
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 20:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjJ3UUM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 16:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjJ3UUL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 16:20:11 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C91F7
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 13:20:09 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698697207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H6wAReVm2ABWu6tWfK+vmOedUVKy+h4P9/PxypfJcgw=;
        b=Tiuut6djOfWkGfg7iWwmImoOGw3S0gqwSivUvX03AAi0P/wIlRnBh2Zjw+X1bh4GzkIr4A
        d8mhd8uTMeqN/R5QRRP+SablSpywIg/DkACre55sd7HQTPm5KphUIL1JfUdNyIa7KX7bJK
        6n09FFYfQKvWYx42uccA+3cdx2+Qd6MMhFMZZYomCPfaq2DupO/2Pcpb/8432I9OoQRSZl
        bbHQu71HDG3wXQQDJkHzpiHuFqgi1jfwNOwk6HycWJRYdRhSfuj4/ngKfzmKFTn4HJnQcG
        a68L87BnH5c14KmjteDVTE2Mex0aKoFuqwHMdz4tYhyyWzDs9BLOGoLBaH2waQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1698697207; a=rsa-sha256;
        cv=none;
        b=K9GMapi7xW4dHuSMK7KtZcuDVjLhr5dPE7ZBk6sM+4Uv7Hqy+x01gogmCXzQibT/LixoLs
        jU7oS9N3NfOjSg5QPlCiwRSEIqpE8SfjMCR8X41WcTujAKv46rV0qjjOmi4vq8e6IKz8e1
        jthrtaQjxhSKezoWNeggPkLN3PDkE9eCBG9j4kptab9kV+D5og2qzidZ0fCm9mBJN1Aks9
        g+QFv176TOJk5HSV58ij2IuFjo62VD1ryHvTXA8FvYgu1lisje+3NXhUhQHBECxnvTmzey
        smxDDUmr13xdEZOVAbxP7egfhmYMAJM41o38+uuftnTmd2SyF02rih60ymkIpw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1698697207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H6wAReVm2ABWu6tWfK+vmOedUVKy+h4P9/PxypfJcgw=;
        b=BXqcuDpqge1a2eUW8oMuY5AA2WkAjg+w7rSQVY+E4JYamML83Jrxah+IRxelNz+auoWyfc
        WokqZooVzYfD21ducQBkj2kOVIag6gfgeBr6PRARW9JzWEs1fbpDHMwxpPfJlPVJjglrkS
        kS8yv3MUgZvgmDD/pctYs/0Xgm5rSeImxdzQYDYdmYN7+RGCNaaRCEg6rsTPV9ctx38tIn
        Bu1QeXd/GAMyy1KAxSjUyja5ei22Tgn07kbLjbmA/8aydI0D/cTSQGbmY6p49D96hTR/eZ
        iMU98cQpDNoxW7z8FJ4AEduamQIfM6Xp0XdobaxRMunDfqXka/fqjJRy+jjHBQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>,
        Frank Sorenson <sorenson@redhat.com>
Subject: [PATCH 2/4] smb: client: fix use-after-free bug in cifs_debug_data_proc_show()
Date:   Mon, 30 Oct 2023 17:19:54 -0300
Message-ID: <20231030201956.2660-2-pc@manguebit.com>
In-Reply-To: <20231030201956.2660-1-pc@manguebit.com>
References: <20231030201956.2660-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

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

Cc: Frank Sorenson <sorenson@redhat.com>
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

