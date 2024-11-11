Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0702158A09
	for <linux-cifs@vger.kernel.org>; Mon, 11 Nov 2024 11:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731325447; cv=none; b=PvZzJOqb5/ugphVAAERaq3SSBjRshpUdKEOQEqBjzlrCC0/cM3OqQ9zJF/AMpABu8iwUM9ZnAYM7M7j0C63ckWRns9FquwuQYjPZzbJpTlo6KpUqN/qcRksw4c4V9J+6n5nWhr8BobOJbEqK5ocWIqmLNy5DK4ubw3Vyy3htKWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731325447; c=relaxed/simple;
	bh=wmI9aanQGDSf/Py+pL74/pNYaIEbfOO6xjB4krJG7Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r35rndqPGO0KDbwJ3GK/lQ4DcNxIJPI5uOpUtsCBZHMQpKElrovYbVH+v0sfq/yIkr1dob2smsIx4BxTeg79za8i9RMlEf5it6O7VZbS4wWXgqcjnT1CwepK2/1H03jFO07/wYNsyY5R6I0ilWBFSgZoyGZbwBPxJJcyijeD+Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PwPQ+S0L; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PwPQ+S0L"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-720d01caa66so4093562b3a.2
        for <linux-cifs@vger.kernel.org>; Mon, 11 Nov 2024 03:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731325445; x=1731930245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BC5iyknf4ZLBTtsx5CmtWBAvR9+x8pcTluvmMGmQAvc=;
        b=PwPQ+S0L3Y9L0IfbzBAwVfebA2JMhjxTfbZhnSY5WmL3N1c+CLSDdwOvkrNvKPdO79
         8zkFtWwCkNbQK1AwDikmHNHkRM/I/1Qjf8ynQ42vHEZXcqYG/3PNxRdwSX7fCLjNFwfZ
         fKepNNWbdJNXpoozSIaYz3FhMojEUi+oT9pjaB1WeAM9uX4Gs7Hgyriom/O0nDEmH0ra
         90Vymw8alc+PUdSOw+HEUeSdhNaGS6LdPuI7N+TSluKM6m7JIXUUJ3ih2vjnQHOOeRz9
         BPsltVShWF2dUB4hEJHhylmSkuQrdhW459PrgbNmNEWqSm7rneGeBpmygS/Cxptb2CRP
         adHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731325445; x=1731930245;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BC5iyknf4ZLBTtsx5CmtWBAvR9+x8pcTluvmMGmQAvc=;
        b=Xz30AC7kvCLsxxsNxtD8jk2yn1iMboMS9NuFwdfhA0vCSTTsPDr6292hv5vBZTzefM
         fvLv+ufEWkggGgUvMH7GopsBd8PGXXZ/dWWKphdhnbhLyQ/wROULhxu/IH2jhBbOrDjb
         8qpZoToRUJxUDPlrD+ra9pFVzRENIrxD5yQwQaCgTYc42fhjIJT4YOdGou2QhT/YW/qd
         nWCQ13L94Zrym7/Mc+wDAmeG378UKsmHOOzSBe+RXu7I90WAPIgq0KNGhe6rHShMOgAj
         4eTgLQE3HkJq/ULnBSf0dF9zYnq13q9kDGyt4YBzuV/Ziv1vwK9rG6ZdENntn+OkXO66
         Osmw==
X-Forwarded-Encrypted: i=1; AJvYcCXiQft/BNzHsXSSi0Qgtef3OPt3pXUC84lOwTi//Gzoa09SrBF8TxCPg+3iyV6YsIsXmd0n7raEy77E@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3AmuI739gD7NsPBoryw3HaHe4fzZxdZXyqpp2k6akzbdCfa4K
	cf4rHREK/oHBwpgQrqbb6J7nkTGH1XUC46sVBuZaJL3Q/YC8Q7Y9
X-Google-Smtp-Source: AGHT+IFE89vhgGY8eKHbp0tk2W0vLr2Xa6qBjYDBHn7v6c0hutQEcvEwAcUm2CkBksBNGTtQ98n6jg==
X-Received: by 2002:a05:6a00:a1d:b0:71e:693c:107c with SMTP id d2e1a72fcca58-724132c15a3mr15917600b3a.11.1731325444635;
        Mon, 11 Nov 2024 03:44:04 -0800 (PST)
Received: from localhost ([74.225.236.108])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f41f5ba191sm8274186a12.22.2024.11.11.03.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 03:44:04 -0800 (PST)
From: budhirajaritviksmb@gmail.com
To: pc@manguebit.com,
	dhowells@redhat.com,
	jlayton@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	nspmangalore@gmail.com,
	bharathsm.hsk@gmail.com
Cc: Ritvik Budhiraja <rbudhiraja@microsoft.com>,
	Shyam Prasad <shyam.prasad@microsoft.com>,
	Bharath S M <bharathsm@microsoft.com>
Subject: [PATCH] CIFS: New mount option for cifs.upcall namespace resolution
Date: Mon, 11 Nov 2024 11:43:51 +0000
Message-ID: <20241111114351.200984-1-budhirajaritviksmb@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ritvik Budhiraja <rbudhiraja@microsoft.com>

In the current implementation, the SMB filesystem on a mount point can 
trigger upcalls from the kernel to the userspace to enable certain 
functionalities like spnego, dns_resolution, amongst others. These upcalls 
usually either happen in the context of the mount or in the context of an 
application/user. The upcall handler for cifs, cifs.upcall already has 
existing code which switches the namespaces to the caller's namespace 
before handling the upcall. This behaviour is expected for scenarios like 
multiuser mounts, but might not cover all single user scenario with 
services such as Kubernetes, where the mount can happen from different 
locations such as on the host, from an app container, or a driver pod 
which does the mount on behalf of a different pod. 

This patch introduces a new mount option called upcall_target, to 
customise the upcall behaviour. upcall_target can take 'mount' and 'app' 
as possible values. This aids use cases like Kubernetes where the mount 
happens on behalf of the application in another container altogether. 
Having this new mount option allows the mount command to specify where the 
upcall should happen: 'mount' for resolving the upcall to the host 
namespace, and 'app' for resolving the upcall to the ns of the calling 
thread. This will enable both the scenarios where the Kerberos credentials 
can be found on the application namespace or the host namespace to which 
just the mount operation is "delegated". 

Reviewed-by: Shyam Prasad <shyam.prasad@microsoft.com>
Reviewed-by: Bharath S M <bharathsm@microsoft.com>
Signed-off-by: Ritvik Budhiraja <rbudhiraja@microsoft.com>
---
 fs/smb/client/cifs_spnego.c | 16 +++++++++++++++
 fs/smb/client/cifsfs.c      | 25 ++++++++++++++++++++++++
 fs/smb/client/cifsglob.h    |  7 +++++++
 fs/smb/client/connect.c     | 20 +++++++++++++++++++
 fs/smb/client/fs_context.c  | 39 +++++++++++++++++++++++++++++++++++++
 fs/smb/client/fs_context.h  | 10 ++++++++++
 6 files changed, 117 insertions(+)

diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
index af7849e59..28f568b5f 100644
--- a/fs/smb/client/cifs_spnego.c
+++ b/fs/smb/client/cifs_spnego.c
@@ -82,6 +82,9 @@ struct key_type cifs_spnego_key_type = {
 /* strlen of ";pid=0x" */
 #define PID_KEY_LEN		7
 
+/* strlen of ";upcall_target=" */
+#define UPCALL_TARGET_KEY_LEN	15
+
 /* get a key struct with a SPNEGO security blob, suitable for session setup */
 struct key *
 cifs_get_spnego_key(struct cifs_ses *sesInfo,
@@ -108,6 +111,11 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
 	if (sesInfo->user_name)
 		desc_len += USER_KEY_LEN + strlen(sesInfo->user_name);
 
+	if (sesInfo->upcall_target == UPTARGET_MOUNT)
+		desc_len += UPCALL_TARGET_KEY_LEN + 5; // strlen("mount")
+	else
+		desc_len += UPCALL_TARGET_KEY_LEN + 3; // strlen("app")
+
 	spnego_key = ERR_PTR(-ENOMEM);
 	description = kzalloc(desc_len, GFP_KERNEL);
 	if (description == NULL)
@@ -156,6 +164,14 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
 	dp = description + strlen(description);
 	sprintf(dp, ";pid=0x%x", current->pid);
 
+	if (sesInfo->upcall_target == UPTARGET_MOUNT) {
+		dp = description + strlen(description);
+		sprintf(dp, ";upcall_target=mount");
+	} else {
+		dp = description + strlen(description);
+		sprintf(dp, ";upcall_target=app");
+	}
+
 	cifs_dbg(FYI, "key description = %s\n", description);
 	saved_cred = override_creds(spnego_cred);
 	spnego_key = request_key(&cifs_spnego_key_type, description, "");
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 2a2523c93..ac89bd199 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -535,6 +535,30 @@ static int cifs_show_devname(struct seq_file *m, struct dentry *root)
 	return 0;
 }
 
+static void
+cifs_show_upcall_target(struct seq_file *s, struct cifs_sb_info *cifs_sb)
+{
+	if (cifs_sb->ctx->upcall_target == UPTARGET_UNSPECIFIED) {
+		seq_puts(s, ",upcall_target=app");
+		return;
+	}
+
+	seq_puts(s, ",upcall_target=");
+
+	switch (cifs_sb->ctx->upcall_target) {
+	case UPTARGET_APP:
+		seq_puts(s, "app");
+		break;
+	case UPTARGET_MOUNT:
+		seq_puts(s, "mount");
+		break;
+	default:
+		/* shouldn't ever happen */
+		seq_puts(s, "unknown");
+		break;
+	}
+}
+
 /*
  * cifs_show_options() is for displaying mount options in /proc/mounts.
  * Not all settable options are displayed but most of the important
@@ -551,6 +575,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	seq_show_option(s, "vers", tcon->ses->server->vals->version_string);
 	cifs_show_security(s, tcon->ses);
 	cifs_show_cache_flavor(s, cifs_sb);
+	cifs_show_upcall_target(s, cifs_sb);
 
 	if (tcon->no_lease)
 		seq_puts(s, ",nolease");
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 9eae8649f..7878d1197 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -153,6 +153,12 @@ enum securityEnum {
 	Kerberos,		/* Kerberos via SPNEGO */
 };
 
+enum upcall_target_enum {
+	UPTARGET_UNSPECIFIED, /* not specified, defaults to app */
+	UPTARGET_MOUNT, /* upcall to the mount namespace */
+	UPTARGET_APP, /* upcall to the application namespace which did the mount */
+};
+
 enum cifs_reparse_type {
 	CIFS_REPARSE_TYPE_NFS,
 	CIFS_REPARSE_TYPE_WSL,
@@ -1083,6 +1089,7 @@ struct cifs_ses {
 	struct session_key auth_key;
 	struct ntlmssp_auth *ntlmssp; /* ciphertext, flags, server challenge */
 	enum securityEnum sectype; /* what security flavor was specified? */
+	enum upcall_target_enum upcall_target; /* what upcall target was specified? */
 	bool sign;		/* is signing required? */
 	bool domainAuto:1;
 	bool expired_pwd;  /* track if access denied or expired pwd so can know if need to update */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 5375b0c1d..57766bca0 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2352,6 +2352,26 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 
 	ses->sectype = ctx->sectype;
 	ses->sign = ctx->sign;
+
+	/*
+	 *Explicitly marking upcall_target mount option for easier handling
+	 * by cifs_spnego.c and eventually cifs.upcall.c
+	 */
+
+	switch (ctx->upcall_target) {
+	case UPTARGET_UNSPECIFIED: /* default to app */
+	case UPTARGET_APP:
+		ses->upcall_target = UPTARGET_APP;
+		break;
+	case UPTARGET_MOUNT:
+		ses->upcall_target = UPTARGET_MOUNT;
+		break;
+	default:
+		// should never happen
+		ses->upcall_target = UPTARGET_APP;
+		break;
+	}
+
 	ses->local_nls = load_nls(ctx->local_nls->charset);
 
 	/* add server as first channel */
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index bc926ab25..2bae49507 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -67,6 +67,12 @@ static const match_table_t cifs_secflavor_tokens = {
 	{ Opt_sec_err, NULL }
 };
 
+static const match_table_t cifs_upcall_target = {
+	{ Opt_upcall_target_mount, "mount" },
+	{ Opt_upcall_target_application, "app" },
+	{ Opt_upcall_target_err, NULL }
+};
+
 const struct fs_parameter_spec smb3_fs_parameters[] = {
 	/* Mount options that take no arguments */
 	fsparam_flag_no("user_xattr", Opt_user_xattr),
@@ -178,6 +184,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_string("sec", Opt_sec),
 	fsparam_string("cache", Opt_cache),
 	fsparam_string("reparse", Opt_reparse),
+	fsparam_string("upcall_target", Opt_upcalltarget),
 
 	/* Arguments that should be ignored */
 	fsparam_flag("guest", Opt_ignore),
@@ -248,6 +255,29 @@ cifs_parse_security_flavors(struct fs_context *fc, char *value, struct smb3_fs_c
 	return 0;
 }
 
+static int
+cifs_parse_upcall_target(struct fs_context *fc, char *value, struct smb3_fs_context *ctx)
+{
+	substring_t args[MAX_OPT_ARGS];
+
+	ctx->upcall_target = UPTARGET_UNSPECIFIED;
+
+	switch (match_token(value, cifs_upcall_target, args)) {
+	case Opt_upcall_target_mount:
+		ctx->upcall_target = UPTARGET_MOUNT;
+		break;
+	case Opt_upcall_target_application:
+		ctx->upcall_target = UPTARGET_APP;
+		break;
+
+	default:
+		cifs_errorf(fc, "bad upcall target: %s\n", value);
+		return 1;
+	}
+
+	return 0;
+}
+
 static const match_table_t cifs_cacheflavor_tokens = {
 	{ Opt_cache_loose, "loose" },
 	{ Opt_cache_strict, "strict" },
@@ -1440,6 +1470,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		if (cifs_parse_security_flavors(fc, param->string, ctx) != 0)
 			goto cifs_parse_mount_err;
 		break;
+	case Opt_upcalltarget:
+		if (cifs_parse_upcall_target(fc, param->string, ctx) != 0)
+			goto cifs_parse_mount_err;
+		break;
 	case Opt_cache:
 		if (cifs_parse_cache_flavor(fc, param->string, ctx) != 0)
 			goto cifs_parse_mount_err;
@@ -1617,6 +1651,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	}
 	/* case Opt_ignore: - is ignored as expected ... */
 
+	if (ctx->multiuser && ctx->upcall_target == UPTARGET_MOUNT) {
+		cifs_errorf(fc, "multiuser mount option not supported with upcalltarget set as 'mount'\n");
+		goto cifs_parse_mount_err;
+	}
+
 	return 0;
 
  cifs_parse_mount_err:
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index cf577ec0d..e3ceed48c 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -61,6 +61,12 @@ enum cifs_sec_param {
 	Opt_sec_err
 };
 
+enum cifs_upcall_target_param {
+	Opt_upcall_target_mount,
+	Opt_upcall_target_application,
+	Opt_upcall_target_err
+};
+
 enum cifs_param {
 	/* Mount options that take no arguments */
 	Opt_user_xattr,
@@ -114,6 +120,8 @@ enum cifs_param {
 	Opt_multichannel,
 	Opt_compress,
 	Opt_witness,
+	Opt_is_upcall_target_mount,
+	Opt_is_upcall_target_application,
 
 	/* Mount options which take numeric value */
 	Opt_backupuid,
@@ -157,6 +165,7 @@ enum cifs_param {
 	Opt_sec,
 	Opt_cache,
 	Opt_reparse,
+	Opt_upcalltarget,
 
 	/* Mount options to be ignored */
 	Opt_ignore,
@@ -198,6 +207,7 @@ struct smb3_fs_context {
 	umode_t file_mode;
 	umode_t dir_mode;
 	enum securityEnum sectype; /* sectype requested via mnt opts */
+	enum upcall_target_enum upcall_target; /* where to upcall for mount */
 	bool sign; /* was signing requested via mnt opts? */
 	bool ignore_signature:1;
 	bool retry:1;
-- 
2.43.0

