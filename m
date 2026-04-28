Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ECE3AEF4A
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391769; cv=none; b=sIM+oXW55IxCiPPCeRWG8UTMi3RrNPh7BD6quPbp3jM2Yk/Vm9hHlnqus2MUi1HK08vE8TdCuP2DrZJZQ1k/x8HpjBRhfDkxaZRN9xVM7DmxIZAUMgg5Kb1GDGp+C+Rr1RRJpk8llV3HuMAH3/tB+VgRcPD/3fUv088VzVrzHhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391769; c=relaxed/simple;
	bh=QvtrNXioYetBI3140PAmV31Sf7hvItugtvKoEJcK3kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0huSMWI8barGKF7v2nti2l6RvzAvsLM3kHycqYf+0nyRmawOCDTA7LiRRqXJfCmQgSdxgDHMYUN6AeFuMQgXPDFhjAZ6o1dlm5NIvvwqDCmRfWsnCsKenF3us5GHIqlSqW/AuojXZtkjJh1esKhKN9ILf71yEn5fhGqWALvz8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZvrEAViY; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZvrEAViY"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso89221015e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391766; x=1777996566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=44YlO/FFyQwPPBPg8EGdlogjBUMKNqCqptz/a4tBBBA=;
        b=ZvrEAViY7MapZAH6eFfDyffSnPt8m4dfGmLA2v2QLQTOfbDLtlsyPb0Y+Viq4GvBDa
         Gnh5ZZhUOUwxwuRQPN0/KQda67jPyZ9T856rocjLiUoT3LiKjM0of77YB3KbVVbPXVoS
         eTuP+FaWVqmo+geVMm7RA+vjXX+07k2sGz2dM9RYfEWueNye7p61Ni48UcJXdMAGkrg9
         QyrKQvhEdwHBfAX1+/7atJGBc64MrAzZTLntDnAdM/IbQw6q0JWlnX1f3ZCXLbxNPqZA
         EdMip0Qs7/mzWyq6Ga9fiQv+xCD3YNI9bcDlH8aqWyORVFwBydKGp4QKA3AGf421Y1qZ
         Qw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391766; x=1777996566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=44YlO/FFyQwPPBPg8EGdlogjBUMKNqCqptz/a4tBBBA=;
        b=hyGMIs+eQwMHsZXeSrMPqiW7iScflwF23kIPNIMhyjAlWCjA34YxcsxXz9tb9O5ZX6
         vzLLyPIcAi6c4D2OtWYeyxSBvmcqoIVvL2N2L0heP7BWjA+PzPBAsW0Rk9wPn2eTPGAP
         sujP8kN7QMc6sBjP4PVs94jRhbq0Xq7GlmhZps+F23zPiCAPklWtmBJ+3cO2Jbc56l/o
         TzT4nv6LDbnnJM28nZMoOOHbYjC/qRVliUXTwcHTTugsOczEqoo02eEUsAMnKrLhtq25
         l4raljaj3xUaYAe+vF7XPxW/7+Wzb7zo9iFWnZ1eB/CZHWnEqFwlSOgoWL3w78kjOrAe
         qU+g==
X-Gm-Message-State: AOJu0YxXqStNbPc0KWVf0J5snPkyV9S9DRb3ZqXxpEjMPwZ61d0rtHEu
	fglNMvxvzPBi9PNPovVHSPBiomf2WzhlY00EHp8RO0/rgUVxf8nH3WOF7YvjU2HbXko5sMLKzq9
	nGSnptool+Q==
X-Gm-Gg: AeBDievlcTC5IvaFmZo9XY1P+DTOiR1Dteo0AswTFEWabIpOulDEk8ggpBzjboi+1cx
	x8TYqAI3F0W2eR98QQE8TySgPHlonMr1ddZmPrxnMWYr5EL/2dYOedgRbEMAkP42y4F+obxzgGu
	5kSBCwEZTVsOcnRRGZwTseGgBzs22VO5+YemqJbD5KZ7liJs6O5JxAjKFv8EO1Dsv4ZOFmeDCgo
	HiV0/7tBQCpcuGpZ60lDwToxwWQPS8EI2JFtCIef46RM0odAanWECAq5iS9mka4itrjL5iP9Enr
	3f2NYp2AMN0lFzdvr3qHcy4ujutzWV1sItUCgIZAkzgjehBQ9TQKYLeZoLVLJKkYqYkuhcUxL6a
	RlusPuihYOyWint16GNziMiPTY82xvPVtxFWcLX2+F/+YgNNIEdpj7RXX+RLt31f7SrYsYX/4Ap
	rl4vCFvMlhQJpbnrxVwP6l9+h7Jfx2hLn/FlcEbPER9ikw
X-Received: by 2002:a05:600c:8582:b0:485:3abe:ab86 with SMTP id 5b1f17b1804b1-48a77af3ddamr41059845e9.4.1777391765758;
        Tue, 28 Apr 2026 08:56:05 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a775f56fcsm23475685e9.25.2026.04.28.08.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:56:05 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	linkinjeon@kernel.org,
	metze@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 04/11] smb: client: add QUIC mount and transport setup
Date: Tue, 28 Apr 2026 12:55:42 -0300
Message-ID: <20260428155542.226234-5-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428155542.226234-1-henrique.carvalho@suse.com>
References: <20260428155542.226234-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce new mount options used to drive SMB over QUIC: `quic` and
`mtls`. Introduce per-server state needed to drive the QUIC transport.
Introduce transport functions for smb quic tls handshake setup and
initial quic transport setup. Include SMB2_TRANSPORT_CAPABILITIES
negotiate context for QUIC.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cifsglob.h   |  19 +++-
 fs/smb/client/connect.c    | 184 +++++++++++++++++++++++++++++++++++--
 fs/smb/client/fs_context.c |  37 ++++++++
 fs/smb/client/fs_context.h |   4 +
 fs/smb/client/smb2pdu.c    |  27 ++++++
 fs/smb/client/transport.c  |  40 ++++----
 6 files changed, 284 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 58be72377c7d..f56d3732bfa8 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -35,6 +35,7 @@
 #define CIFS_PORT 445
 #define RFC1001_PORT 139
 #define SMBD_IWARP_PORT 5445
+#define SMB_QUIC_PORT 443
 
 /*
  * The sizes of various internal tables and strings
@@ -759,8 +760,10 @@ struct TCP_Server_Info {
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
 	bool	sec_iakerb;		/* supports pass-through auth for Kerberos (krb5 proxy) */
 	bool	large_buf;		/* is current buffer large? */
-	int	ipproto; /* IPPROTO_TCP or IPOROTO_SMBDIRECT */
+	int	ipproto; /* IPPROTO_TCP, IPOROTO_SMBDIRECT or IPPROTO_QUIC */
 #define cifs_rdma_enabled(__server)	((__server)->ipproto == IPPROTO_SMBDIRECT)
+	/* point to the SMBD connection if RDMA is used instead of socket */
+	struct smbd_connection *smbd_conn;
 	struct delayed_work	echo; /* echo ping workqueue job */
 	char	*smallbuf;	/* pointer to current "small" buffer */
 	char	*bigbuf;	/* pointer to current "big" buffer */
@@ -832,6 +835,14 @@ struct TCP_Server_Info {
 	char *leaf_fullpath;
 	bool dfs_conn:1;
 	char dns_dom[CIFS_MAX_DOMAINNAME_LEN + 1];
+
+	struct {
+		bool need_smb_seal; /* if unset, smb encryption is disabled over QUIC
+				     * transport, and QUIC security (i.e. TLS 1.3) is
+				     * the one used
+				     */
+		bool mtls;
+	} quic_conn;
 };
 
 static inline bool is_smb1(const struct TCP_Server_Info *server)
@@ -855,6 +866,12 @@ static inline void cifs_server_unlock(struct TCP_Server_Info *server)
 	memalloc_nofs_restore(nofs_flag);
 }
 
+static inline bool
+cifs_quic_enabled(struct TCP_Server_Info *server)
+{
+	return server->ipproto == IPPROTO_QUIC;
+}
+
 struct cifs_credits {
 	unsigned int value;
 	unsigned int instance;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 33d619007905..bfe949b14db2 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -25,11 +25,14 @@
 #include <linux/namei.h>
 #include <linux/uuid.h>
 #include <linux/uaccess.h>
+#include <linux/quic.h>
 #include <asm/processor.h>
 #include <linux/inet.h>
 #include <linux/module.h>
 #include <keys/user-type.h>
 #include <net/ipv6.h>
+#include <net/handshake.h>
+#include <keys/asymmetric-type.h>
 #include <linux/parser.h>
 #include <linux/bvec.h>
 #include "cifsglob.h"
@@ -70,7 +73,11 @@ static void mchan_mount_work_fn(struct work_struct *work);
 
 static void smb_sock_release(struct TCP_Server_Info *server)
 {
-	sock_release(server->ssocket);
+	/* ->ssocket will be released by fput() */
+	if (cifs_quic_enabled(server) && server->ssocket->file)
+		fput(server->ssocket->file);
+	else if (server->ssocket)
+		sock_release(server->ssocket);
 	server->ssocket = NULL;
 }
 
@@ -1643,6 +1650,9 @@ static int match_server(struct TCP_Server_Info *server,
 	if (cifs_rdma_enabled(server) != ctx->rdma)
 		return 0;
 
+	if (cifs_quic_enabled(server) != ctx->quic)
+		return 0;
+
 	if (server->ignore_signature != ctx->ignore_signature)
 		return 0;
 
@@ -1784,7 +1794,10 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	tcp_ses->tcp_nodelay = ctx->sockopt_tcp_nodelay;
 	if (ctx->rdma)
 		tcp_ses->ipproto = IPPROTO_SMBDIRECT;
-	else
+	else if (ctx->quic) {
+		tcp_ses->ipproto = IPPROTO_QUIC;
+		tcp_ses->quic_conn.mtls = ctx->mtls;
+	} else
 		tcp_ses->ipproto = IPPROTO_TCP;
 
 	tcp_ses->in_flight = 0;
@@ -3304,6 +3317,145 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	return 0;
 }
 
+static void
+smb_tls_handshake_done(void *data, int status, key_serial_t peerid)
+{
+	struct smb_tls *smb_tls = (struct smb_tls *)data;
+
+	smb_tls->status = status;
+	smb_tls->peerid = peerid;
+
+	complete(&smb_tls->handshake_done);
+}
+
+static inline struct smb_tls *
+smb_tls_init(struct TCP_Server_Info *server)
+{
+	struct smb_tls *tls;
+
+	tls = kzalloc_obj(*tls, GFP_KERNEL);
+	if (!tls)
+		return ERR_PTR(-ENOMEM);
+
+	tls->status = 0;
+
+	tls->args.ta_sock = server->ssocket;
+	tls->args.ta_done = smb_tls_handshake_done;
+	tls->args.ta_data = tls;
+	tls->args.ta_peername = kstrdup(server->hostname, GFP_KERNEL); /* do I need kstrdup ? */
+	tls->args.ta_timeout_ms = SMB_TLS_TIMEOUT_MS;
+	tls->args.ta_keyring = TLS_NO_KEYRING;
+
+	init_completion(&tls->handshake_done);
+
+	return tls;
+}
+
+static void smb_tls_free(struct smb_tls **tls)
+{
+	kfree((*tls)->args.ta_peername);
+	kfree_sensitive(*tls);
+	*tls = NULL;
+}
+
+static inline void
+smb_tls_debug(int rc)
+{
+	switch (rc) {
+	case 0:
+		cifs_dbg(VFS, "smb tls: Handshake successful");
+		return;
+	case -ERESTARTSYS:
+		cifs_dbg(VFS, "smb tls: Handshake interrupted");
+		return;
+	case -ETIMEDOUT:
+		cifs_dbg(VFS, "smb tls: Handshake timed out");
+		return;
+	case -EINVAL:
+		cifs_dbg(VFS, "smb tls: Consumer provided an invalid argument");
+		return;
+	case -ENOKEY:
+		cifs_dbg(VFS, "smb tls: Missing authentication material");
+		return;
+	case -EIO:
+		cifs_dbg(VFS, "smb tls: An unexpected fault occurred");
+		return;
+	default:
+		cifs_dbg(VFS, "smb tls: Error: %d", -rc);
+		return;
+	}
+}
+
+static int
+smb_tls_handshake(struct TCP_Server_Info *server)
+{
+	int rc;
+	struct smb_tls *tls;
+
+	cifs_dbg(FYI, "smb tls: starting TLS handshake");
+
+	tls = smb_tls_init(server);
+	if (IS_ERR(tls))
+		return PTR_ERR(tls);
+
+	if (server->quic_conn.mtls)
+		rc = tls_client_hello_x509(&tls->args, GFP_KERNEL);
+	else
+		rc = tls_client_hello_anon(&tls->args, GFP_KERNEL);
+
+	if (rc < 0)
+		goto free;
+
+	rc = wait_for_completion_interruptible(&tls->handshake_done);
+	if (rc < 0)
+		tls_handshake_cancel(server->ssocket->sk);
+	else
+		rc = tls->status;
+
+free:
+	smb_tls_free(&tls);
+
+	smb_tls_debug(rc);
+
+	return rc;
+}
+
+static int
+smb_quic_tls(struct TCP_Server_Info *server)
+{
+	int rc;
+	size_t sinfolen;
+	struct quic_stream_info sinfo;
+	struct socket *socket = server->ssocket;
+
+	rc = smb_tls_handshake(server);
+	if (rc < 0)
+		return rc;
+
+	/* open a new stream after handshake, default to stream id == 0 */
+	sinfo.stream_id = -1;
+	sinfolen = sizeof(sinfo);
+	rc = quic_do_getsockopt(socket->sk, QUIC_SOCKOPT_STREAM_OPEN,
+				KERNEL_SOCKPTR(&sinfo), KERNEL_SOCKPTR(&sinfolen));
+
+	return rc;
+}
+
+static int
+smb_quic_prepare_socket(struct TCP_Server_Info *server)
+{
+	int flags = 0;
+	struct file *filp;
+	struct socket *socket = server->ssocket;
+
+	filp = sock_alloc_file(socket, flags, NULL);
+	if (IS_ERR(filp))
+		return PTR_ERR(filp);
+
+	return quic_do_setsockopt(socket->sk, QUIC_SOCKOPT_ALPN,
+				  KERNEL_SOCKPTR("smb"), 3);
+}
+
 static inline const char *
 get_protocol_name(struct TCP_Server_Info *server)
 {
@@ -3350,8 +3502,6 @@ generic_ip_connect(struct TCP_Server_Info *server)
 			 __func__, pname, &ipv4->sin_addr, ntohs(sport));
 	}
 
-	smb_sock_release(server);
-
 	{
 		struct net *net = cifs_net_ns(server);
 		struct sock *sk;
@@ -3380,8 +3530,8 @@ generic_ip_connect(struct TCP_Server_Info *server)
 
 	rc = bind_socket(server);
 	if (rc < 0) {
-		cifs_dbg(FYI, "Error %d bind_socket() %s\n", rc, pname);
-		goto close_socket;
+		cifs_dbg(VFS, "Error %d bind_socket() %s\n", rc, pname);
+		return rc;
 	}
 
 	/*
@@ -3406,10 +3556,16 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	if (cifs_rdma_enabled(server)) {
 		rc = smbd_prepare_socket(server, ntohs(sport));
 		if (rc < 0) {
-			cifs_dbg(FYI, "Error %d from smbd_prepare_socket(port=%u)\n",
+			cifs_dbg(VFS, "Error %d from smbd_prepare_socket(port=%u)\n",
 				 rc, ntohs(sport));
 			goto close_socket;
 		}
+	} else if (cifs_quic_enabled(server)) {
+		rc = smb_quic_prepare_socket(server);
+		if (rc < 0) {
+			cifs_dbg(VFS, "Error %d from smb_quic_prepare_socket()\n", rc);
+			goto close_socket;
+		}
 	}
 
 	cifs_dbg(FYI, "sndbuf %d rcvbuf %d rcvtimeo 0x%lx\n",
@@ -3426,9 +3582,18 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	if (server->noblockcnt && rc == -EINPROGRESS)
 		rc = 0;
 	if (rc < 0) {
-		cifs_dbg(FYI, "Error %d connecting with %s to server\n", rc, pname);
+		cifs_dbg(VFS, "Error %d connecting with %s to server\n", rc, pname);
 		goto close_socket;
 	}
+
+	if (cifs_quic_enabled(server)) {
+		rc = smb_quic_tls(server);
+		if (rc < 0) {
+			cifs_dbg(VFS, "Error %d from smb_quic_tls()\n", rc);
+			goto close_socket;
+		}
+	}
+
 	trace_smb3_connect_done(server->hostname, server->conn_id, &server->dstaddr);
 
 	/*
@@ -3467,6 +3632,9 @@ ip_connect(struct TCP_Server_Info *server)
 	if (cifs_rdma_enabled(server)) {
 		port1 = SMBD_IWARP_PORT;
 		port2 = CIFS_PORT;
+	} else if (cifs_quic_enabled(server)) {
+		port1 = SMB_QUIC_PORT;
+		port2 = 0;
 	}
 
 	if (server->dstaddr.ss_family == AF_INET6)
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 54090739535f..067058c39619 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -127,6 +127,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_flag("nosparse", Opt_nosparse),
 	fsparam_flag("domainauto", Opt_domainauto),
 	fsparam_flag("rdma", Opt_rdma),
+	fsparam_flag("quic", Opt_quic),
 	fsparam_flag("modesid", Opt_modesid),
 	fsparam_flag("modefromsid", Opt_modesid),
 	fsparam_flag("rootfs", Opt_rootfs),
@@ -135,6 +136,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_flag_no("nativesocket", Opt_nativesocket),
 	fsparam_flag_no("unicode", Opt_unicode),
 	fsparam_flag_no("nbsessinit", Opt_nbsessinit),
+	fsparam_flag("mtls", Opt_mtls),
 
 	/* Mount options which take uid or gid */
 	fsparam_uid("backupuid", Opt_backupuid),
@@ -840,6 +842,30 @@ static int smb3_fs_context_validate(struct fs_context *fc)
 		return -EOPNOTSUPP;
 	}
 
+	if (ctx->rdma && ctx->quic) {
+		pr_warn_once("SMB Direct and QUIC transport are mutually exclusive. Default to rdma\n");
+		ctx->quic = false;
+	}
+
+	if (ctx->quic && !ctx->got_version) {
+		pr_warn_once("No dialect specified on mount, but 'quic' implies a minimum dialect of SMB3.1.1. Default has changed to SMB3.1.1\n");
+		ctx->ops = &smb311_operations;
+		ctx->vals = &smb311_values;
+		ctx->got_version = true;
+	}
+
+	if (ctx->quic) {
+		if (!IS_ENABLED(CONFIG_IP_QUIC)) {
+			cifs_errorf(fc, "SMB over QUIC requires CONFIG_IP_QUIC to be enabled\n");
+			return -EOPNOTSUPP;
+		}
+	}
+
+	if (ctx->quic && ctx->vals->protocol_id < SMB311_PROT_ID) {
+		cifs_errorf(fc, "SMB over QUIC requires Version >=3.1.1\n");
+		return -EOPNOTSUPP;
+	}
+
 #ifndef CONFIG_KEYS
 	/* Muliuser mounts require CONFIG_KEYS support */
 	if (ctx->multiuser) {
@@ -1011,6 +1037,10 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change nbsessinit during remount\n");
 		return -EINVAL;
 	}
+	if (new_ctx->quic != old_ctx->quic) {
+		cifs_errorf(fc, "can not change quic transport during remount\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -1871,6 +1901,9 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	case Opt_rdma:
 		ctx->rdma = true;
 		break;
+	case Opt_quic:
+		ctx->quic = true;
+		break;
 	case Opt_reparse:
 		if (parse_reparse_flavor(fc, param->string, ctx))
 			goto cifs_parse_mount_err;
@@ -1896,7 +1929,11 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->symlinkroot = param->string;
 		param->string = NULL;
 		break;
+	case Opt_mtls:
+		ctx->mtls = true;
+		break;
 	}
+
 	/* case Opt_ignore: - is ignored as expected ... */
 
 	if (ctx->multiuser && ctx->upcall_target == UPTARGET_MOUNT) {
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 0b64fcb5d302..e9b85c1c1937 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -143,6 +143,7 @@ enum cifs_param {
 	Opt_tcp_nodelay,
 	Opt_domainauto,
 	Opt_rdma,
+	Opt_quic,
 	Opt_modesid,
 	Opt_rootfs,
 	Opt_multichannel,
@@ -199,6 +200,7 @@ enum cifs_param {
 	Opt_nativesocket,
 	Opt_symlink,
 	Opt_symlinkroot,
+	Opt_mtls,
 
 	/* Mount options to be ignored */
 	Opt_ignore,
@@ -293,6 +295,8 @@ struct smb3_fs_context {
 	bool resilient:1; /* noresilient not required since not fored for CA */
 	bool domainauto:1;
 	bool rdma:1;
+	bool quic:1;
+	bool mtls:1;
 	bool multichannel:1;
 	bool multichannel_specified:1; /* true if user specified multichannel or nomultichannel */
 	bool max_channels_specified:1; /* true if user specified max_channels */
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index bac88a612d5d..848f9137f01d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -732,6 +732,16 @@ build_posix_ctxt(struct smb2_posix_neg_context *pneg_ctxt)
 	return smb2_neg_context_len(pneg_ctxt);
 }
 
+static unsigned int
+build_transport_ctxt(struct smb2_transport_capabilities_context *pneg_ctxt)
+{
+	pneg_ctxt->ContextType = SMB2_TRANSPORT_CAPABILITIES;
+	pneg_ctxt->DataLength = cpu_to_le16(sizeof(struct smb2_transport_capabilities_context) -
+					    sizeof(struct smb2_neg_context));
+	pneg_ctxt->Flags = cpu_to_le32(SMB2_ACCEPT_TRANSPORT_LEVEL_SECURITY);
+	return smb2_neg_context_len(pneg_ctxt);
+}
+
 struct neg_ctx {
 	char *pos;
 	unsigned int len;
@@ -801,6 +811,11 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
 	if (enable_negotiate_signing)
 		add_context(&nc, build_signing_ctxt((struct smb2_signing_capabilities *)nc.pos));
 
+	if (cifs_quic_enabled(server) && server->quic_conn.need_smb_seal)
+		add_context(&nc,
+			    build_transport_ctxt(
+				    (struct smb2_transport_capabilities_context *)nc.pos));
+
 	/* check for and add transport_capabilities and signing capabilities */
 	req->NegotiateContextCount = cpu_to_le16(nc.cnt);
 
@@ -945,6 +960,15 @@ static void decode_signing_ctx(struct TCP_Server_Info *server,
 		     server->signing_algorithm);
 }
 
+static void
+decode_transport_ctx(struct TCP_Server_Info *server,
+		     struct smb2_transport_capabilities_context *pctxt)
+{
+	if (pctxt->Flags == cpu_to_le32(SMB2_ACCEPT_TRANSPORT_LEVEL_SECURITY))
+		server->quic_conn.need_smb_seal = false;
+	else
+		server->quic_conn.need_smb_seal = true;
+}
 
 static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
 				     struct TCP_Server_Info *server,
@@ -997,6 +1021,9 @@ static int smb311_decode_neg_context(struct smb2_negotiate_rsp *rsp,
 		else if (pctx->ContextType == SMB2_SIGNING_CAPABILITIES)
 			decode_signing_ctx(server,
 				(struct smb2_signing_capabilities *)pctx);
+		else if (pctx->ContextType == SMB2_TRANSPORT_CAPABILITIES)
+			decode_transport_ctx(server,
+				(struct smb2_transport_capabilities_context *)pctx);
 		else
 			cifs_server_dbg(VFS, "unknown negcontext of type %d ignored\n",
 				le16_to_cpu(pctx->ContextType));
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index e64becee928f..46a67c7eba54 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -23,6 +23,7 @@
 #include <linux/sched/signal.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/task_work.h>
+#include <linux/quic.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
@@ -148,10 +149,12 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 
 	*sent = 0;
 
-	if (server->noblocksnd)
-		smb_msg->msg_flags = MSG_DONTWAIT + MSG_NOSIGNAL;
-	else
-		smb_msg->msg_flags = MSG_NOSIGNAL;
+	if (cifs_quic_enabled(server)) {
+		if (server->noblocksnd)
+			smb_msg->msg_flags = MSG_DONTWAIT + MSG_NOSIGNAL;
+		else
+			smb_msg->msg_flags = MSG_NOSIGNAL;
+	}
 
 	while (msg_data_left(smb_msg)) {
 		/*
@@ -270,7 +273,8 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 
 	rc = 0;
 	/* cork the socket */
-	tcp_sock_set_cork(ssocket->sk, true);
+	if (!cifs_quic_enabled(server))
+		tcp_sock_set_cork(ssocket->sk, true);
 
 	for (j = 0; j < num_rqst; j++)
 		send_length += smb_rqst_len(server, &rqst[j]);
@@ -287,19 +291,17 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	sigprocmask(SIG_BLOCK, &mask, &oldmask);
 
 	/* Generate a rfc1002 marker */
-	{
-		struct kvec hiov = {
-			.iov_base = &rfc1002_marker,
-			.iov_len  = 4
-		};
-		iov_iter_kvec(&smb_msg.msg_iter, ITER_SOURCE, &hiov, 1, 4);
-		rc = smb_send_kvec(server, &smb_msg, &sent);
-		if (rc < 0)
-			goto unmask;
+	struct kvec hiov = {
+		.iov_base = &rfc1002_marker,
+		.iov_len  = 4
+	};
+	iov_iter_kvec(&smb_msg.msg_iter, ITER_SOURCE, &hiov, 1, 4);
+	rc = smb_send_kvec(server, &smb_msg, &sent);
+	if (rc < 0)
+		goto unmask;
 
-		total_len += sent;
-		send_length += 4;
-	}
+	total_len += sent;
+	send_length += 4;
 
 	cifs_dbg(FYI, "Sending smb: smb_len=%u\n", send_length);
 
@@ -350,7 +352,9 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	}
 
 	/* uncork it */
-	tcp_sock_set_cork(ssocket->sk, false);
+
+	if (!cifs_quic_enabled(server))
+		tcp_sock_set_cork(ssocket->sk, false);
 
 	if ((total_len > 0) && (total_len != send_length)) {
 		cifs_dbg(FYI, "partial send (wanted=%u sent=%zu): terminating session\n",
-- 
2.53.0

