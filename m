Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473D5C4332F
	for <linux-cifs@archiver.kernel.org>; Sat, 31 Dec 2022 08:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLaIV1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 31 Dec 2022 03:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiLaIV0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 31 Dec 2022 03:21:26 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C2511154
        for <linux-cifs@vger.kernel.org>; Sat, 31 Dec 2022 00:21:23 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id y19so5018336plb.2
        for <linux-cifs@vger.kernel.org>; Sat, 31 Dec 2022 00:21:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qk8SnHVTgVpxfdDRv9BQz8t3PBDoxE/UtJPW47JAQGI=;
        b=cs8srknKSuxCrGTWlbFOjPjmQzjdenv14Bq+7IUH4QZ/bZ1DWAuMeU5g84FIsEvIAc
         5Yx+o9zzcB1d38hTPcC1vPB7AwQ/H9uW6dnWX4nMEWUCG9QKezrVOIsxaQ+WBkrEantd
         RvTH1dmHVVseIz2XurR4jQCoWITuDLYD8sGSV9QYaNnmpsWEDkaUge/lxJEgd/jUZqnm
         N2jIriGauh+Za0oJB61aK1HijjoAZMcwRn1NOg8YfU8Nn1nugimgMf4HPClkNhRyaQ/I
         OiT7JMGBIBDjFah+4mIaAmXOdYh3GR9U+OqQBEUA9Bs9V+1eRb2Ci1OYiUkpNOwfnBXM
         Ozkg==
X-Gm-Message-State: AFqh2kpKvYbYrNK7MIK1JpWJmW4bFnJmivjZeYthPXyEstBbbWZ7pZS5
        Fs9F61JCFrE1+uI3ucQnJg7sqRD2lH0=
X-Google-Smtp-Source: AMrXdXupLZOlRdVoO0AfZojF6HKktThJekSaIOy4o4D9pIIeCyO9WstAbhfeLwtMMTmfhocKbbP7Jw==
X-Received: by 2002:a17:90a:7283:b0:225:be73:312 with SMTP id e3-20020a17090a728300b00225be730312mr30402633pjg.49.1672474882356;
        Sat, 31 Dec 2022 00:21:22 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id m9-20020a17090ab78900b00212e5fe09d7sm13856221pjr.10.2022.12.31.00.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Dec 2022 00:21:21 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v3] ksmbd-tools: add max connections parameter to global section
Date:   Sat, 31 Dec 2022 17:21:07 +0900
Message-Id: <20221231082107.9997-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add max connections parameter to limit number of maximum simultaneous
connections. The default value is 512. And the maximum value is 64k.
Values greater than 64k or 0 will be silently set to 64k.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - set default value as 512 and max 65536 value.
 v3:
   - add the macro for default value.
   - Set to allowable maximum value(64k) for "max connections = 0".

 include/linux/ksmbd_server.h |  3 ++-
 include/tools.h              |  4 ++++
 ksmbd.conf.5.in              |  6 +++---
 ksmbd.conf.example           |  3 ++-
 mountd/ipc.c                 |  1 +
 tools/config_parser.c        | 12 ++++++++++++
 tools/management/share.c     |  7 +++++++
 7 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/include/linux/ksmbd_server.h b/include/linux/ksmbd_server.h
index 8ec004f..64099f2 100644
--- a/include/linux/ksmbd_server.h
+++ b/include/linux/ksmbd_server.h
@@ -49,7 +49,8 @@ struct ksmbd_startup_request {
 	__u32	sub_auth[3];
 	__u32	smb2_max_credits;
 	__u32	smbd_max_io_size;	/* smbd read write size */
-	__u32   reserved[127];		/* Reserved room */
+	__u32	max_connections;	/* Number of maximum simultaneous connections */
+	__u32   reserved[126];		/* Reserved room */
 	__u32	ifc_list_sz;
 	__s8	____payload[];
 };
diff --git a/include/tools.h b/include/tools.h
index f6f51f8..254606e 100644
--- a/include/tools.h
+++ b/include/tools.h
@@ -53,6 +53,7 @@ struct smbconf_global {
 	unsigned int		smb2_max_trans;
 	unsigned int		smb2_max_credits;
 	unsigned int		smbd_max_io_size;
+	unsigned int		max_connections;
 	unsigned int		share_fake_fscaps;
 	unsigned int		gen_subauth[3];
 	char			*krb5_keytab_file;
@@ -84,6 +85,9 @@ extern struct smbconf_global global_conf;
 
 #define KSMBD_CONF_FILE_MAX		10000
 
+#define KSMBD_CONF_DEFAULT_CONNECTIONS	512
+#define KSMBD_CONF_MAX_CONNECTIONS	65536
+
 #define PATH_PWDDB		SYSCONFDIR "/ksmbd/ksmbdpwd.db"
 #define PATH_SMBCONF		SYSCONFDIR "/ksmbd/ksmbd.conf"
 #define PATH_SMBCONF_FALLBACK	SYSCONFDIR "/ksmbd/smb.conf"
diff --git a/ksmbd.conf.5.in b/ksmbd.conf.5.in
index a1dfb4a..0e7fdc6 100644
--- a/ksmbd.conf.5.in
+++ b/ksmbd.conf.5.in
@@ -172,11 +172,11 @@ Maximum number of simultaneous sessions to all shares.
 
 Default: \fBmax active sessions = 1024\fR \" KSMBD_CONF_DEFAULT_SESS_CAP
 .TP
-\fBmax connections\fR (S)
+\fBmax connections\fR (G)
 Maximum number of simultaneous connections to the share.
-With \fBmax connections = 0\fR, any number of connections may be made.
+The maximum value is 64k. Values greater than 64k or 0 will be silently set to 64k.
 
-Default: \fBmax connections = 0\fR
+Default: \fBmax connections = 512\fR
 .TP
 \fBmax open files\fR (G)
 Maximum number of simultaneous open files for a client.
diff --git a/ksmbd.conf.example b/ksmbd.conf.example
index 6ce4ec7..4dd2a65 100644
--- a/ksmbd.conf.example
+++ b/ksmbd.conf.example
@@ -30,6 +30,7 @@
 	smbd max io size = 8MB
 	tcp port = 445
 	workgroup = WORKGROUP
+	max connections = 512
 
 	; share parameters for all sections
 	browseable = yes
@@ -44,7 +45,7 @@
 	hide dot files = yes
 	inherit owner = no
 	invalid users = 
-	max connections = 0
+	max connections = 512
 	oplocks = yes
 	path = 
 	read list = 
diff --git a/mountd/ipc.c b/mountd/ipc.c
index 9d4c1ca..382f5ed 100644
--- a/mountd/ipc.c
+++ b/mountd/ipc.c
@@ -175,6 +175,7 @@ static int ipc_ksmbd_starting_up(void)
 	ev->smb2_max_write = global_conf.smb2_max_write;
 	ev->smb2_max_trans = global_conf.smb2_max_trans;
 	ev->smbd_max_io_size = global_conf.smbd_max_io_size;
+	ev->max_connections = global_conf.max_connections;
 	ev->share_fake_fscaps = global_conf.share_fake_fscaps;
 	memcpy(ev->sub_auth, global_conf.gen_subauth, sizeof(ev->sub_auth));
 	ev->smb2_max_credits = global_conf.smb2_max_credits;
diff --git a/tools/config_parser.c b/tools/config_parser.c
index 2dc6b34..a675b51 100644
--- a/tools/config_parser.c
+++ b/tools/config_parser.c
@@ -548,6 +548,17 @@ static gboolean global_group_kv(gpointer _k, gpointer _v, gpointer user_data)
 		return TRUE;
 	}
 
+	if (!cp_key_cmp(_k, "max connections")) {
+		global_conf.max_connections = memparse(_v);
+		if (!global_conf.max_connections ||
+		    global_conf.max_connections > KSMBD_CONF_MAX_CONNECTIONS) {
+			pr_info("Limits exceeding the maximum simultaneous connections(%d)\n",
+				KSMBD_CONF_MAX_CONNECTIONS);
+			global_conf.max_connections = KSMBD_CONF_MAX_CONNECTIONS;
+		}
+		return TRUE;
+	}
+
 	/* At this point, this is an option that must be applied to all shares */
 	return FALSE;
 }
@@ -556,6 +567,7 @@ static void global_conf_default(void)
 {
 	/* The SPARSE_FILES file system capability flag is set by default */
 	global_conf.share_fake_fscaps = 64;
+	global_conf.max_connections = KSMBD_CONF_DEFAULT_CONNECTIONS;
 }
 
 static void global_conf_create(void)
diff --git a/tools/management/share.c b/tools/management/share.c
index 295b1b6..3af3f48 100644
--- a/tools/management/share.c
+++ b/tools/management/share.c
@@ -585,6 +585,12 @@ static void process_group_kv(gpointer _k, gpointer _v, gpointer user_data)
 
 	if (shm_share_config(k, KSMBD_SHARE_CONF_MAX_CONNECTIONS)) {
 		share->max_connections = cp_get_group_kv_long_base(v, 10);
+		if (!share->max_connections ||
+		    share->max_connections > KSMBD_CONF_MAX_CONNECTIONS) {
+			pr_info("Limits exceeding the maximum simultaneous connections(%d)\n",
+				KSMBD_CONF_MAX_CONNECTIONS);
+			share->max_connections = KSMBD_CONF_MAX_CONNECTIONS;
+		}
 		return;
 	}
 
@@ -643,6 +649,7 @@ static void init_share_from_group(struct ksmbd_share *share,
 	share->directory_mask = KSMBD_SHARE_DEFAULT_DIRECTORY_MASK;
 	share->force_create_mode = 0;
 	share->force_directory_mode = 0;
+	share->max_connections = KSMBD_CONF_DEFAULT_CONNECTIONS;
 
 	share->force_uid = KSMBD_SHARE_INVALID_UID;
 	share->force_gid = KSMBD_SHARE_INVALID_GID;
-- 
2.25.1

