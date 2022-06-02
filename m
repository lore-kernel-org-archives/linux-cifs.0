Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077E9C43334
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 01:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbiFBBOZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Jun 2022 21:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiFBBOX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Jun 2022 21:14:23 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2E428DC2C
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 18:14:22 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso7910925pjl.3
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jun 2022 18:14:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zMmwggPC79nvr+PapSRkahq0fTeeRRyMjGuaFsyiMec=;
        b=wkndDvcUBughshZHSrXBTQw+rnke3KDXIBp1HDXMpd1Xb5x9nHieLK1EiP/O6Wovdw
         In5jF8Q/Bc9q+ScA6wEda0NSgnm9q8XvigysLHCZt/UjktriJNUn2JwNHg+MRXQwRXa5
         oh87gapKumMvnrQcA95Vl3kJdvZqwTNBD2JN2EPzaISMXhBPDyOy5nHFTBg6yrwQxVPp
         sodXsDMRac47lUsZuNG5Z8TCM7KUu20hvL9GKu1IupRLEzzkur/Th4A+CToON//0Dd6/
         8DzDm9Je48vIP61ej67Khc8R93kFARkZ1NXml5ZqBfO5ZqAHNzdF6ukltsXp7Ib9CAov
         kDqA==
X-Gm-Message-State: AOAM531ImDbE22uGa6A7W0tfT72q1xLiHKolb3eyBgRpEsnv5ai88Hmj
        aFCVsw64CEAz5LBCsrBy7UIAVcBd1SdFJg==
X-Google-Smtp-Source: ABdhPJxb0a/++58BcsMwP+yA3lwKTQlndqnfnMOX+WSkrCD2q2mhkjL9mBlXa79cHiqN2G35UVykug==
X-Received: by 2002:a17:903:290:b0:15c:1c87:e66c with SMTP id j16-20020a170903029000b0015c1c87e66cmr2267654plr.61.1654132461516;
        Wed, 01 Jun 2022 18:14:21 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id e15-20020a056a001a8f00b0050dc762818dsm2086679pfv.103.2022.06.01.18.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 18:14:21 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     hyc.lee@gmail.com, sfrench@samba.org, senozhatsky@chromium.org,
        smfrench@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] ksmbd-tools: add missing long option in adduser/addshare/control
Date:   Thu,  2 Jun 2022 10:14:10 +0900
Message-Id: <20220602011410.56202-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add missing long option in adduser/addshare/control.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 addshare/addshare.c | 11 ++++++++++-
 adduser/adduser.c   | 12 +++++++++++-
 control/control.c   |  9 ++++++++-
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/addshare/addshare.c b/addshare/addshare.c
index 4d25047..a8ba71a 100644
--- a/addshare/addshare.c
+++ b/addshare/addshare.c
@@ -54,6 +54,15 @@ static void usage(void)
 	exit(EXIT_FAILURE);
 }
 
+static const struct option opts[] = {
+	{"add-share",		required_argument,	NULL,	'a' },
+	{"del-share",		required_argument,	NULL,	'd' },
+	{"update-share",	required_argument,	NULL,	'u' },
+	{"options",		required_argument,	NULL,	'o' },
+	{"version",		no_argument,		NULL,	'V' },
+	{"verbose",		no_argument,		NULL,	'v' },
+};
+
 static void show_version(void)
 {
 	printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
@@ -102,7 +111,7 @@ int main(int argc, char *argv[])
 	set_logger_app_name("ksmbd.addshare");
 
 	opterr = 0;
-	while ((c = getopt(argc, argv, "c:a:d:u:p:o:Vvh")) != EOF)
+	while ((c = getopt_long(argc, argv, "c:a:d:u:p:o:Vvh", opts, NULL)) != EOF)
 		switch (c) {
 		case 'a':
 			arg_name = g_ascii_strdown(optarg, strlen(optarg));
diff --git a/adduser/adduser.c b/adduser/adduser.c
index 88b12db..60a059d 100644
--- a/adduser/adduser.c
+++ b/adduser/adduser.c
@@ -50,6 +50,16 @@ static void usage(void)
 	exit(EXIT_FAILURE);
 }
 
+static const struct option opts[] = {
+	{"add-user",		required_argument,	NULL,	'a' },
+	{"del-user",		required_argument,	NULL,	'd' },
+	{"update-user",		required_argument,	NULL,	'u' },
+	{"password",		required_argument,	NULL,	'p' },
+	{"import-users",	required_argument,	NULL,	'i' },
+	{"version",		no_argument,		NULL,	'V' },
+	{"verbose",		no_argument,		NULL,	'v' },
+};
+
 static void show_version(void)
 {
 	printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
@@ -102,7 +112,7 @@ int main(int argc, char *argv[])
 	set_logger_app_name("ksmbd.adduser");
 
 	opterr = 0;
-	while ((c = getopt(argc, argv, "c:i:a:d:u:p:Vvh")) != EOF)
+	while ((c = getopt_long(argc, argv, "c:i:a:d:u:p:Vvh", opts, NULL)) != EOF)
 		switch (c) {
 		case 'a':
 			arg_account = g_strdup(optarg);
diff --git a/control/control.c b/control/control.c
index 780a48a..3dc8c7e 100644
--- a/control/control.c
+++ b/control/control.c
@@ -23,6 +23,13 @@ static void usage(void)
 	exit(EXIT_FAILURE);
 }
 
+static const struct option opts[] = {
+	{"shutdown",		no_argument,		NULL,	's' },
+	{"debug",		required_argument,	NULL,	'd' },
+	{"ksmbd-version",	no_argument,		NULL,	'c' },
+	{"version",		no_argument,		NULL,	'V' },
+};
+
 static void show_version(void)
 {
 	printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
@@ -101,7 +108,7 @@ int main(int argc, char *argv[])
 	}
 
 	opterr = 0;
-	while ((c = getopt(argc, argv, "sd:cVh")) != EOF)
+	while ((c = getopt_long(argc, argv, "sd:cVh", opts, NULL)) != EOF)
 		switch (c) {
 		case 's':
 			ret = ksmbd_control_shutdown();
-- 
2.25.1

