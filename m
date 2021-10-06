Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2DCC433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 16:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BE2761175
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 16:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhJFQQ1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Oct 2021 12:16:27 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37206 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238827AbhJFQQ0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Oct 2021 12:16:26 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AD49A224A4;
        Wed,  6 Oct 2021 16:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633536873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Z6wr+OK/0n1B9E+CbBOca6roTZAN5vINlT87tb05ZlU=;
        b=gHMPuMSgUFEiD2X7RfwqYT7o6cdz0ZxhaUSmIvs3JiTq1ssS5SgyQ39jLpalOMdXYuMVYI
        gGzL/TEnysoNicncO3MCxkLEduid49nmPDaKpTy6okR0vFLrqY70bVte7tJaSlZuv9WcUQ
        AeYfPIXboqPWs4GkaLBJkP0c+o2DQis=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633536873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Z6wr+OK/0n1B9E+CbBOca6roTZAN5vINlT87tb05ZlU=;
        b=33xpWy4J2g71XevPcr9pxPyn1v6TBCeXmkVR8qGdMbNvxl3EEGzrqdENbv0+dLa+Wwrkkx
        xevq5e28l7zv/PDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3C11013E60;
        Wed,  6 Oct 2021 16:14:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dl9vAmnLXWFqOgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 06 Oct 2021 16:14:33 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org
Subject: [PATCH] ksmbd-tools: update names in logger
Date:   Wed,  6 Oct 2021 13:14:31 -0300
Message-Id: <20211006161431.4638-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 addshare/addshare.c | 2 +-
 adduser/adduser.c   | 2 +-
 mountd/mountd.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/addshare/addshare.c b/addshare/addshare.c
index 5d54f55e7e8e..7458b6c0be17 100644
--- a/addshare/addshare.c
+++ b/addshare/addshare.c
@@ -103,7 +103,7 @@ int main(int argc, char *argv[])
 	char *smbconf = PATH_SMBCONF;
 	int c, cmd = 0;
 
-	set_logger_app_name("smbshareadd");
+	set_logger_app_name("ksmbd.addshare");
 
 	opterr = 0;
 	while ((c = getopt(argc, argv, "c:a:d:u:p:o:Vvh")) != EOF)
diff --git a/adduser/adduser.c b/adduser/adduser.c
index 54774d3d6e15..5ffb29635c12 100644
--- a/adduser/adduser.c
+++ b/adduser/adduser.c
@@ -100,7 +100,7 @@ int main(int argc, char *argv[])
 	char *pwddb = PATH_PWDDB;
 	int c, cmd = 0;
 
-	set_logger_app_name("smbuseradd");
+	set_logger_app_name("ksmbd.adduser");
 
 	opterr = 0;
 	while ((c = getopt(argc, argv, "c:i:a:d:u:p:Vvh")) != EOF)
diff --git a/mountd/mountd.c b/mountd/mountd.c
index 71a4d985d5a9..a3a683222a92 100644
--- a/mountd/mountd.c
+++ b/mountd/mountd.c
@@ -560,7 +560,7 @@ int main(int argc, char *argv[])
 	int systemd_service = 0;
 	int c;
 
-	set_logger_app_name("ksmbd-manager");
+	set_logger_app_name("ksmbd.mountd");
 	memset(&global_conf, 0x00, sizeof(struct smbconf_global));
 	global_conf.pwddb = PATH_PWDDB;
 	global_conf.smbconf = PATH_SMBCONF;
-- 
2.33.0

