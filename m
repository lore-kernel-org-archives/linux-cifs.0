Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D527DEB64D7
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 03:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjFZDnl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 25 Jun 2023 23:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjFZDnk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 25 Jun 2023 23:43:40 -0400
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA22188
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 20:43:35 -0700 (PDT)
X-QQ-mid: bizesmtp77t1687751006tgvl97yj
Received: from localhost.localdomain ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 26 Jun 2023 11:43:26 +0800 (CST)
X-QQ-SSF: 01400000000000F0H000000A0000000
X-QQ-FEAT: 5q30pvLz2id44pY87f29IP/uit38oe9/9nQrs/QNZvsz5dwlR2ZzSOTs9S6Vv
        xH5BlzOE91CKG5EfiSI1+ghUcIlE+dosixkaY/N9qCwfKQPMcqEz6H3Sshb0+uETJnVv3zB
        IkPyOSFevOh/mSkVGGxJCZVsChqdJkEowJYu/nQo/Mz/jsi4SC7i/08lyJyOIY58UTTS2Ff
        ETOTOxG8/QtcpSoN4DnnxhP0wMhX0HU6XyTOzBvnNYAU2CiAS4m4P6miYYHP7TChQfmb6lO
        onGraGv6JzKq+DMl3hj1nX5RALMqmukeM41f3NCnmRn9LZaMKnsh2pSJziaeK69zV9Pcpqg
        KpzHH1xz0cv8cppV7DRciR9Wus7eSScfYtC2ZPgEP51ksDHGHX5A7BrVdUlOGH35o0U8YAs
        L+Yzp4LN2XbMlrS1F1+55w==
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13646095126810630976
From:   Winston Wen <wentao@uniontech.com>
To:     sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.com,
        sprasad@microsoft.com
Cc:     Winston Wen <wentao@uniontech.com>
Subject: [PATCH 3/3] cifs: fix session state check in smb2_find_smb_ses
Date:   Mon, 26 Jun 2023 11:42:57 +0800
Message-Id: <20230626034257.2078391-4-wentao@uniontech.com>
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

Chech the session state and skip it if it's exiting.

Signed-off-by: Winston Wen <wentao@uniontech.com>
---
 fs/smb/client/smb2transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 790acf65a092..22954a9c7a6c 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -153,7 +153,14 @@ smb2_find_smb_ses_unlocked(struct TCP_Server_Info *server, __u64 ses_id)
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		if (ses->Suid != ses_id)
 			continue;
+
+		spin_lock(&ses->ses_lock);
+		if (ses->ses_status == SES_EXITING) {
+			spin_unlock(&ses->ses_lock);
+			continue;
+		}
 		++ses->ses_count;
+		spin_unlock(&ses->ses_lock);
 		return ses;
 	}
 
-- 
2.40.1

