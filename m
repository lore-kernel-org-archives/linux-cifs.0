Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807CAC4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 03:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 302D123716
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 03:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgLQD3r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Dec 2020 22:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgLQD3r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Dec 2020 22:29:47 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F34C061794
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 19:29:07 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id f14so2880523pju.4
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 19:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DTk/co2YPgzqrf7wiBfjFy9N/RSO+QDjxRFX/wXXTOg=;
        b=DBAXFCE6vkDFXX4lX1eyaqtOnJHABvr//GYGJYUE6kRVXLBQV4HTR4+4mTzqmvRAMT
         mLVBpaUSY/ee6E3CH2MF7k66gW4/UyV0HnAYp/epaQJktirrk+U1O6g5x101U/Wqp0wK
         iXQGFCt+k/yikxucsbagLeZM2WNrxkDkcB2iaDpQh1ruzFJ3TlAzkKoPG9bOBTq5rLeE
         mfJKvjiavLfylSEhQrrpmNWGSF3VAzYgZAl5p5I7CEQCnrBx4Nybie6dKkBfgdMtFXq6
         zMc5q/Hmbq89iGAuO6Oso16yWQstKyM5q07mxfUynDtgHioCnXJMYhonDeop9NstIRqP
         9/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DTk/co2YPgzqrf7wiBfjFy9N/RSO+QDjxRFX/wXXTOg=;
        b=nVAxadykum25uBEmi/bnM7BmeLmOwKGkr6Djh4hIF9dyN550QUBZUGQW/gjBqDVxM1
         MwV++noCG8S8uVTHLsROGrCbXNcnF29/h08Hfoj3Lt/OzHO3q3X735S1+KMYtsd0VV/+
         L+hZNZfZ/S7KXmJsJYHYfxy+3YaHTglEc/e9iHTKndd1uVDGB07uBmqIQfQLbdYS97+u
         TmYWYc42TKU7/slRnxv4gTg7IczUKcQ8Gm9j2ABQ5M5kKznlOtWRfVsBPxfed0yBuFn7
         XwoJ17utg602tr5TRzC1jQqh5HYahFVIZ8MhZJR+OncFcpCUceB1H2o1qo8j/3LavZu8
         Z+Tw==
X-Gm-Message-State: AOAM533GJcoIcK+9HS+LJG/vNUf8Tt6D2s/hxApf3vMo0O0W9ysNWDN+
        ByDQgN9iiuIybW+LJ1m44zLtQEqktJFg+A==
X-Google-Smtp-Source: ABdhPJwoYykdRfLSps1PcgwzrWnk1x6344f6m9ITwA/fhfxcA/Dyv1CcDLUL1c2Zu89z4vwnQDHzIQ==
X-Received: by 2002:a17:90b:3907:: with SMTP id ob7mr6015696pjb.70.1608175746946;
        Wed, 16 Dec 2020 19:29:06 -0800 (PST)
Received: from localhost ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id js9sm3649039pjb.2.2020.12.16.19.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 19:29:05 -0800 (PST)
Date:   Thu, 17 Dec 2020 12:29:02 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To:     Stefan Metzmacher <metze@samba.org>,
        Namjae Jeon <namjae.jeon@samsung.com>
Cc:     'CIFS' <linux-cifs@vger.kernel.org>,
        'Steve French' <smfrench@gmail.com>,
        'samba-technical' <samba-technical@lists.samba.org>,
        'Hyunchul Lee' <hyc.lee@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: updated ksmbd (cifsd)
Message-ID: <X9rQfoW3BhOsX1ZX@jagdpanzerIV.localdomain>
References: <CAH2r5muRCUzvKOv1xWRZL4t-7Pifz-nsL_Sn4qmbX0o127tnGA@mail.gmail.com>
 <CGME20201214182517epcas1p1d710746f4dd56097f16ed08cfda0f6b2@epcas1p1.samsung.com>
 <3bf45223-484a-e86a-279a-619a779ceabd@samba.org>
 <003a01d6d28a$00989dd0$01c9d970$@samsung.com>
 <069556fc-cb6c-1e52-02ab-fa9b71f58cf6@samba.org>
 <X9l9/7rttZkNc389@jagdpanzerIV.localdomain>
 <X9mLUOxGI8QM/tgV@jagdpanzerIV.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9mLUOxGI8QM/tgV@jagdpanzerIV.localdomain>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (20/12/16 13:21), Sergey Senozhatsky wrote:
> So SMB_SERVER_CHECK_CAP_NET_ADMIN enforces the "user-space must
> be a privileged process" policy. Even CAP_NET_ADMIN is too huge,
> not to mention that _probably_ this CAP requirement means that
> people will just "sudo cifsd". One way or another a malformed
> RPC request can do quite a bit of damage to the system, because
> user-space runs with the CAPs it doesn't really need.
> 
> It would be better to enforce a different policy, IMHO.
> Something like:
> 
> 	groupadd ... CIFSD_GROUP
> 	useradd -g CIFSD_GID -p CIFSD_PASSWORD CIFSD_LOGIN
> 	chmod 0700 smb.conf and password db
> 	chown CIFSD_LOGIN:CIFSD_GROUP smb.conf and password db

Just a sketch. Completely untested (wasn't even compile tested).
Merely an idea.

This removes the requirement for user-space to run as a privileged
process. Because "let's grant some random user-space daemon
administrative privileges" most likely doesn't improve security
of the system.

So the idea is to provide CIFSD administrator UID and GID during
kcifsd modprobe and then in IPC handlers check if the app issuing
a netlink syscall has the same UID and GID as the CIFSD administrator
or not.

This untested, sorry. Just checking the idea.

---

diff --git a/fs/cifsd/Kconfig b/fs/cifsd/Kconfig
index e12616cf8477..9f221a37223d 100644
--- a/fs/cifsd/Kconfig
+++ b/fs/cifsd/Kconfig
@@ -50,14 +50,6 @@ config SMB_SERVER_SMBDIRECT
 	  SMB Direct allows transferring SMB packets over RDMA. If unsure,
 	  say N.
 
-config SMB_SERVER_CHECK_CAP_NET_ADMIN
-	bool "Enable check network administration capability"
-	depends on SMB_SERVER
-	default n
-
-	help
-	  Prevent unprivileged processes to start the cifsd kernel server.
-
 config SMB_SERVER_KERBEROS5
 	bool "Support for Kerberos 5"
 	depends on SMB_SERVER
diff --git a/fs/cifsd/server.c b/fs/cifsd/server.c
index b9e114f8a5d2..dbbdb3503b0d 100644
--- a/fs/cifsd/server.c
+++ b/fs/cifsd/server.c
@@ -25,6 +25,7 @@
 
 int ksmbd_debug_types;
 
+static int admin_uid = -1, admin_gid = -1;
 struct ksmbd_server_config server_conf;
 
 enum SERVER_CTRL_TYPE {
@@ -335,6 +336,26 @@ static void server_conf_free(void)
 	}
 }
 
+static int server_admin_cred_init(void)
+{
+	if (admin_uid == -1 || admin_gid == -1)
+		return 0;
+
+	server_conf.admin_cred = kmalloc(sizeof(struct admin_cred), GFP_KERNEL);
+	if (!server_conf.admin_cred)
+		return -ENOMEM;
+
+	server_conf.admin_cred.uid = make_kuid(&init_user_ns, admin_uid);
+	server_conf.admin_cred.gid = make_kgid(&init_user_ns, admin_gid);
+	if (!(uid_validserver_conf.admin_cred.uid() &&
+	      gid_valid(server_conf.admin_cred.gid))) {
+		kfree(server_conf.admin_cred);
+		server_conf.admin_cred = NULL;
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int server_conf_init(void)
 {
 	WRITE_ONCE(server_conf.state, SERVER_STATE_STARTING_UP);
@@ -343,10 +364,9 @@ static int server_conf_init(void)
 	server_conf.max_protocol = ksmbd_max_protocol();
 	server_conf.auth_mechs = KSMBD_AUTH_NTLMSSP;
 #ifdef CONFIG_SMB_SERVER_KERBEROS5
-	server_conf.auth_mechs |= KSMBD_AUTH_KRB5 |
-				KSMBD_AUTH_MSKRB5;
+	server_conf.auth_mechs |= KSMBD_AUTH_KRB5 | KSMBD_AUTH_MSKRB5;
 #endif
-	return 0;
+	return server_admin_cred_init();
 }
 
 static void server_ctrl_handle_init(struct server_ctrl_struct *ctrl)
@@ -418,6 +438,21 @@ int server_queue_ctrl_reset_work(void)
 	return __queue_ctrl_work(SERVER_CTRL_TYPE_RESET);
 }
 
+int server_validate_admin_cred(void)
+{
+	if (admin_uid == -1 || admin_gid == -1)
+		return 0;
+
+	/* We couldn't init server admin UID/GID */
+	if (!server_conf.admin_cred)
+		return -EINVAL;
+
+	if (uid_eq(task_uid(current), server_conf.admin_cred.uid) &&
+	    gid_eq(task_gid(current), server_conf.admin_cred.gid))
+		return 0;
+	return -EINVAL;
+}
+
 static ssize_t stats_show(struct class *class,
 			  struct class_attribute *attr,
 			  char *buf)
@@ -614,6 +649,11 @@ static void __exit ksmbd_server_exit(void)
 	ksmbd_release_inode_hash();
 }
 
+module_param(admin_uid, int, 0);
+MODULE_PARM_DESC(admin_uid, "ksmb administrator user id");
+module_param(admin_gid, int, 0);
+MODULE_PARM_DESC(admin_gid, "ksmb administrator group id");
+
 MODULE_AUTHOR("Namjae Jeon <linkinjeon@kernel.org>");
 MODULE_VERSION(KSMBD_VERSION);
 MODULE_DESCRIPTION("Linux kernel CIFS/SMB SERVER");
diff --git a/fs/cifsd/server.h b/fs/cifsd/server.h
index 7b2f6318fcff..ed0249061470 100644
--- a/fs/cifsd/server.h
+++ b/fs/cifsd/server.h
@@ -19,6 +19,11 @@
 
 extern int ksmbd_debugging;
 
+struct admin_cred {
+	kuid_t			uid;
+	kgid_t			gid;
+};
+
 struct ksmbd_server_config {
 	unsigned int		flags;
 	unsigned int		state;
@@ -34,6 +39,7 @@ struct ksmbd_server_config {
 	struct smb_sid		domain_sid;
 	unsigned int		auth_mechs;
 
+	struct admin_cred	*admin_cred;
 	char			*conf[SERVER_CONF_WORK_GROUP + 1];
 };
 
@@ -57,6 +63,7 @@ static inline int ksmbd_server_configurable(void)
 	return READ_ONCE(server_conf.state) < SERVER_STATE_RESETTING;
 }
 
+int server_verify_admin_cred(void);
 int server_queue_ctrl_init_work(void);
 int server_queue_ctrl_reset_work(void);
 #endif /* __SERVER_H__ */
diff --git a/fs/cifsd/transport_ipc.c b/fs/cifsd/transport_ipc.c
index 5f24a1ed5c34..b2a42f6ce6e3 100644
--- a/fs/cifsd/transport_ipc.c
+++ b/fs/cifsd/transport_ipc.c
@@ -345,10 +345,8 @@ static int handle_startup_event(struct sk_buff *skb, struct genl_info *info)
 {
 	int ret = 0;
 
-#ifdef CONFIG_SMB_SERVER_CHECK_CAP_NET_ADMIN
-	if (!netlink_capable(skb, CAP_NET_ADMIN))
+	if (server_validate_admin_cred())
 		return -EPERM;
-#endif
 
 	if (!ksmbd_ipc_validate_version(info))
 		return -EINVAL;
@@ -401,10 +399,8 @@ static int handle_generic_event(struct sk_buff *skb, struct genl_info *info)
 	int sz;
 	int type = info->genlhdr->cmd;
 
-#ifdef CONFIG_SMB_SERVER_CHECK_CAP_NET_ADMIN
-	if (!netlink_capable(skb, CAP_NET_ADMIN))
+	if (server_validate_admin_cred())
 		return -EPERM;
-#endif
 
 	if (type >= KSMBD_EVENT_MAX) {
 		WARN_ON(1);
