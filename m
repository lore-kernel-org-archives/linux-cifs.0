Return-Path: <SRS0=6quT=36=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC17CC352A4
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Feb 2020 09:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBCC821739
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Feb 2020 09:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgBJJis (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Feb 2020 04:38:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:50854 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgBJJis (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 10 Feb 2020 04:38:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BB124AEC4;
        Mon, 10 Feb 2020 09:38:46 +0000 (UTC)
From:   Petr Pavlu <petr.pavlu@suse.com>
To:     stfrench@microsoft.com, linux-cifs@vger.kernel.org
Cc:     Petr Pavlu <petr.pavlu@suse.com>
Subject: [PATCH] cifs: fix mount option display for sec=krb5i
Date:   Mon, 10 Feb 2020 10:38:14 +0100
Message-Id: <20200210093814.24198-1-petr.pavlu@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix display for sec=krb5i which was wrongly interleaved by cruid,
resulting in string "sec=krb5,cruid=<...>i" instead of
"sec=krb5i,cruid=<...>".

Fixes: 96281b9e46eb ("smb3: for kerberos mounts display the credential uid used")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
---
 fs/cifs/cifsfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5492b9860baa..92b9c8221f07 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -414,7 +414,7 @@ cifs_show_security(struct seq_file *s, struct cifs_ses *ses)
 		seq_puts(s, "ntlm");
 		break;
 	case Kerberos:
-		seq_printf(s, "krb5,cruid=%u", from_kuid_munged(&init_user_ns,ses->cred_uid));
+		seq_puts(s, "krb5");
 		break;
 	case RawNTLMSSP:
 		seq_puts(s, "ntlmssp");
@@ -427,6 +427,10 @@ cifs_show_security(struct seq_file *s, struct cifs_ses *ses)
 
 	if (ses->sign)
 		seq_puts(s, "i");
+
+	if (ses->sectype == Kerberos)
+		seq_printf(s, ",cruid=%u",
+			   from_kuid_munged(&init_user_ns, ses->cred_uid));
 }
 
 static void
-- 
2.16.4

