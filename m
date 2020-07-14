Return-Path: <SRS0=KB7a=AZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDDFC433E4
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jul 2020 11:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A273221D90
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jul 2020 11:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgGNLL1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jul 2020 07:11:27 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:63404 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgGNLL1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 14 Jul 2020 07:11:27 -0400
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2020 07:11:26 EDT
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id 4E764778292AA454EF6B;
        Tue, 14 Jul 2020 18:56:10 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notessmtp.zte.com.cn [10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id 06EAu4vZ053028;
        Tue, 14 Jul 2020 18:56:04 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2020071418561828-4282339 ;
          Tue, 14 Jul 2020 18:56:18 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, wang.liang82@zte.com.cn,
        Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: [PATCH] cifs: Remove the superfluous break
Date:   Tue, 14 Jul 2020 18:59:12 +0800
Message-Id: <1594724352-11451-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2020-07-14 18:56:18,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2020-07-14 18:56:07,
        Serialize complete at 2020-07-14 18:56:07
X-MAIL: mse-fl1.zte.com.cn 06EAu4vZ053028
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Liao Pingfang <liao.pingfang@zte.com.cn>

Remove the superfuous break, as there is a 'return' before it.

Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 fs/cifs/sess.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 5d05bd2..6708ab0 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1705,7 +1705,6 @@ static int select_sec(struct cifs_ses *ses, struct sess_data *sess_data)
 #else
 		cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
 		return -ENOSYS;
-		break;
 #endif /* CONFIG_CIFS_UPCALL */
 	case RawNTLMSSP:
 		sess_data->func = sess_auth_rawntlmssp_negotiate;
-- 
2.9.5

