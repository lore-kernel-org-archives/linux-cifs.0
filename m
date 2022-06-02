Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CB1C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 05:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiFBFTG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 01:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiFBFTF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 01:19:05 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AC9113A0E
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 22:19:03 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id o6-20020a17090a0a0600b001e2c6566046so8358971pjo.0
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jun 2022 22:19:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dqbIu/z3kutvbA/d95aQ/WfDs9T0zMj09X2nKeiidQA=;
        b=0JIU0XBeiHM7m9zdVt3Xb+glahM6cC6WiNvV8/HV07GCNmgGEtymkYEZj/0R8gryof
         Sx+dGo+sLAPtgYBm+giavJEmJuebPlYmBhu9YcPgr/QcRWi/sIcSvY2Oq13F+xe5zUAI
         L8fXw4lRUeMgiZp6BQby1D5+lE8pLctyKTtKSwoMzIyHGygRv6xalDjwRYIeo3mzFzuX
         313qdnx+8ecfGjhfZ5ClAG2LjkIIZbeFPb6/vDQY8n+59y3ooQMElMasZl5IT2FmaWYr
         ppYLg+7eXLlDL+vj91+ovimLdVqaPRG23cO/jdxroFqqn8yC6ztwHboz4wN0UsD7A7QM
         iw6Q==
X-Gm-Message-State: AOAM533OB+ESVA78Cjz+4onMaPr1bfHiHZ5HMuZ5H6daSjpb5/grH35z
        VjzVNuUVhMoj7zcIu3I50NYoe6A/UVM3zg==
X-Google-Smtp-Source: ABdhPJxOyuSCygyv9WV/9LQ/9N3wE1WswwvEXc8oXI5FanhcVxL1x7Zm125kZ8CZG3p9wFFHDXS17A==
X-Received: by 2002:a17:903:40ce:b0:164:248:1464 with SMTP id t14-20020a17090340ce00b0016402481464mr3126090pld.16.1654147142679;
        Wed, 01 Jun 2022 22:19:02 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c15-20020a170902c2cf00b0016231f64631sm2343038pla.309.2022.06.01.22.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 22:19:01 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     hyc.lee@gmail.com, sfrench@samba.org, senozhatsky@chromium.org,
        smfrench@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH v2] ksmbd-tools: add missing long option in adduser/addshare/control
Date:   Thu,  2 Jun 2022 14:18:52 +0900
Message-Id: <20220602051852.75949-1-linkinjeon@kernel.org>
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
 v2:
   - add NULL element in opts[].

 addshare/addshare.c | 12 +++++++++++-
 adduser/adduser.c   | 13 ++++++++++++-
 control/control.c   | 10 +++++++++-
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/addshare/addshare.c b/addshare/addshare.c
index 4d25047..af36e4b 100644
--- a/addshare/addshare.c
+++ b/addshare/addshare.c
@@ -54,6 +54,16 @@ static void usage(void)
 	exit(EXIT_FAILURE);
 }
 
+static const struct option opts[] = {
+	{"add-share",		required_argument,	NULL,	'a' },
+	{"del-share",		required_argument,	NULL,	'd' },
+	{"update-share",	required_argument,	NULL,	'u' },
+	{"options",		required_argument,	NULL,	'o' },
+	{"version",		no_argument,		NULL,	'V' },
+	{"verbose",		no_argument,		NULL,	'v' },
+	{NULL,			0,			NULL,	 0  }
+};
+
 static void show_version(void)
 {
 	printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
@@ -102,7 +112,7 @@ int main(int argc, char *argv[])
 	set_logger_app_name("ksmbd.addshare");
 
 	opterr = 0;
-	while ((c = getopt(argc, argv, "c:a:d:u:p:o:Vvh")) != EOF)
+	while ((c = getopt_long(argc, argv, "c:a:d:u:p:o:Vvh", opts, NULL)) != EOF)
 		switch (c) {
 		case 'a':
 			arg_name = g_ascii_strdown(optarg, strlen(optarg));
diff --git a/adduser/adduser.c b/adduser/adduser.c
index 88b12db..9e736ee 100644
--- a/adduser/adduser.c
+++ b/adduser/adduser.c
@@ -50,6 +50,17 @@ static void usage(void)
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
+	{NULL,			0,			NULL,	 0  }
+};
+
 static void show_version(void)
 {
 	printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
@@ -102,7 +113,7 @@ int main(int argc, char *argv[])
 	set_logger_app_name("ksmbd.adduser");
 
 	opterr = 0;
-	while ((c = getopt(argc, argv, "c:i:a:d:u:p:Vvh")) != EOF)
+	while ((c = getopt_long(argc, argv, "c:i:a:d:u:p:Vvh", opts, NULL)) != EOF)
 		switch (c) {
 		case 'a':
 			arg_account = g_strdup(optarg);
diff --git a/control/control.c b/control/control.c
index 780a48a..94fec33 100644
--- a/control/control.c
+++ b/control/control.c
@@ -23,6 +23,14 @@ static void usage(void)
 	exit(EXIT_FAILURE);
 }
 
+static const struct option opts[] = {
+	{"shutdown",		no_argument,		NULL,	's' },
+	{"debug",		required_argument,	NULL,	'd' },
+	{"ksmbd-version",	no_argument,		NULL,	'c' },
+	{"version",		no_argument,		NULL,	'V' },
+	{NULL,			0,			NULL,	 0  }
+};
+
 static void show_version(void)
 {
 	printf("ksmbd-tools version : %s\n", KSMBD_TOOLS_VERSION);
@@ -101,7 +109,7 @@ int main(int argc, char *argv[])
 	}
 
 	opterr = 0;
-	while ((c = getopt(argc, argv, "sd:cVh")) != EOF)
+	while ((c = getopt_long(argc, argv, "sd:cVh", opts, NULL)) != EOF)
 		switch (c) {
 		case 's':
 			ret = ksmbd_control_shutdown();
-- 
2.25.1

