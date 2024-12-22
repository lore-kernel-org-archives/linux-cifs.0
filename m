Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076FD148FF5;
	Sun, 22 Dec 2024 16:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734885098; cv=none; b=bRc5zzksQlCnc+S9xtHd7jF35U/BkSbBgA8UGaoFwfQQHKsSF/awjOF+kVJ6ePppybwTxsvWceHW/KbLP3Rld96XqcYxR8rje6986znhN4622dFFGIv84QiSiDn0hXPc5QkT1uReZTLyc8RyyuH+KuLN9eD67W4t23hy/f/2Eqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734885098; c=relaxed/simple;
	bh=6mF6fFD1dpZLaf92pqiPx4MGnM0g/bhvYec0tCCgVo0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FL7R/t3xsbkHDmAFOYQmAHoyVtjXFlhFINHxLK+CX6PH171X0Z6dHzqYGW6EEfsosoUTcq/VWrE4Rlse0YFAvJimwK9PrVQRKG5Mce5GHzgDZsHpT+OYTPT6ezHsJzeYMKQO/1VbXVD2he4C5g6dmVSWWB0f4gkmhKaCnHFAdUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uO5yACPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uO5yACPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BDCC4CEDD;
	Sun, 22 Dec 2024 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734885097;
	bh=6mF6fFD1dpZLaf92pqiPx4MGnM0g/bhvYec0tCCgVo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uO5yACPcCOUaeBKbBwVut1TbXSGSpD3bPVFjWvnRnYB5yDTLkHT4TKe6O98k7fjTZ
	 IqcNROdB+PnNU13sRlMQLNA34h0Q0HbwIvFT9fpsbdBMU9QIQpV1xIK1xQdhWhaqx4
	 seIBT3ZjaPsxdBMoh6pAfMM1FpSuZI/00rYVSPLGHqKNDNSRnUPYIUMtMpUNt0vSdF
	 Qo8iFmxk/sSYfP8bQT42RovbBlhu/I+Yqm6pdn8QRIlG509tpSjNZujg+QfG5K7stY
	 5ftw4clVn1C7jh6IS1f2Lcx/bdgWDBbVqn/lGAbQ1d0EXmfb99OzGHpXDsR/VJnT1m
	 RpFHiuZoVyX1w==
Received: by pali.im (Postfix)
	id 00819982; Sun, 22 Dec 2024 17:31:26 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] cifs: Allow to disable or force initialization of NetBIOS session
Date: Sun, 22 Dec 2024 17:30:45 +0100
Message-Id: <20241222163050.24359-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222163050.24359-1-pali@kernel.org>
References: <20241222163050.24359-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently SMB client always tries to initialize NetBIOS session when the
server port is 139. This is useful for default cases, but nowadays when
using non-standard routing or testing between VMs, it is common that
servers are listening on non-standard ports.

So add a new mount option -o nbsessinit and -o nonbsessinit which either
forces initialization or disables initialization regardless of server port
number.

This allows Linux SMB client to connect to older SMB1 server listening on
non-standard port, which requires initialization of NetBIOS session, by
using additional mount options -o port= and -o nbsessinit.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h   |  1 +
 fs/smb/client/connect.c    | 11 ++++++++++-
 fs/smb/client/fs_context.c | 14 +++++++++++++-
 fs/smb/client/fs_context.h |  2 ++
 4 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index d4c60d85d7a4..bea4b8a8b30e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -716,6 +716,7 @@ struct TCP_Server_Info {
 	spinlock_t srv_lock;  /* protect anything here that is not protected */
 	__u64 conn_id; /* connection identifier (useful for debugging) */
 	int srv_count; /* reference counter */
+	int rfc1001_sessinit; /* whether to estasblish netbios session */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
 	char server_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	struct smb_version_operations	*ops;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 20b8bb957468..9cbfdc31cdda 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1738,6 +1738,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 		ctx->source_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
 	memcpy(tcp_ses->server_RFC1001_name,
 		ctx->target_rfc1001_name, RFC1001_NAME_LEN_WITH_NULL);
+	tcp_ses->rfc1001_sessinit = ctx->rfc1001_sessinit;
 	tcp_ses->session_estab = false;
 	tcp_ses->sequence_number = 0;
 	tcp_ses->channel_sequence_num = 0; /* only tracked for primary channel */
@@ -3206,7 +3207,15 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		return rc;
 	}
 	trace_smb3_connect_done(server->hostname, server->conn_id, &server->dstaddr);
-	if (sport == htons(RFC1001_PORT))
+
+	/*
+	 * Establish RFC1001 NetBIOS session when it was explicitly requested
+	 * by mount option -o nbsessinit, or when connecting to default RFC1001
+	 * server port (139) and it was not explicitly disabled by mount option
+	 * -o nonbsessinit.
+	 */
+	if (server->rfc1001_sessinit == 1 ||
+	    (server->rfc1001_sessinit == -1 && sport == htons(RFC1001_PORT)))
 		rc = ip_rfc1001_connect(server);
 
 	return rc;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index e2ae9819b5ba..3774f02f45c9 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -134,6 +134,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_flag("compress", Opt_compress),
 	fsparam_flag("witness", Opt_witness),
 	fsparam_flag_no("unicode", Opt_unicode),
+	fsparam_flag_no("nbsessinit", Opt_nbsessinit),
 
 	/* Mount options which take uid or gid */
 	fsparam_uid("backupuid", Opt_backupuid),
@@ -965,6 +966,10 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change unicode during remount\n");
 		return -EINVAL;
 	}
+	if (new_ctx->rfc1001_sessinit != old_ctx->rfc1001_sessinit) {
+		cifs_errorf(fc, "can not change nbsessinit during remount\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -1585,6 +1590,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		if (i == RFC1001_NAME_LEN && param->string[i] != 0)
 			pr_warn("server netbiosname longer than 15 truncated\n");
 		break;
+	case Opt_nbsessinit:
+		ctx->rfc1001_sessinit = !result.negated;
+		cifs_dbg(FYI, "rfc1001_sessinit set to %d\n", ctx->rfc1001_sessinit);
+		break;
 	case Opt_ver:
 		/* version of mount userspace tools, not dialect */
 		/* If interface changes in mount.cifs bump to new ver */
@@ -1872,13 +1881,16 @@ int smb3_init_fs_context(struct fs_context *fc)
 	memset(ctx->source_rfc1001_name, 0x20, RFC1001_NAME_LEN);
 	for (i = 0; i < strnlen(nodename, RFC1001_NAME_LEN); i++)
 		ctx->source_rfc1001_name[i] = toupper(nodename[i]);
-
 	ctx->source_rfc1001_name[RFC1001_NAME_LEN] = 0;
+
 	/*
 	 * null target name indicates to use *SMBSERVR default called name
 	 *  if we end up sending RFC1001 session initialize
 	 */
 	ctx->target_rfc1001_name[0] = 0;
+
+	ctx->rfc1001_sessinit = -1; /* autodetect based on port number */
+
 	ctx->cred_uid = current_uid();
 	ctx->linux_uid = current_uid();
 	ctx->linux_gid = current_gid();
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index af2d94022a30..e6b22a5fbd0f 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -174,6 +174,7 @@ enum cifs_param {
 	Opt_iocharset,
 	Opt_netbiosname,
 	Opt_servern,
+	Opt_nbsessinit,
 	Opt_ver,
 	Opt_vers,
 	Opt_sec,
@@ -216,6 +217,7 @@ struct smb3_fs_context {
 	char *iocharset;  /* local code page for mapping to and from Unicode */
 	char source_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* clnt nb name */
 	char target_rfc1001_name[RFC1001_NAME_LEN_WITH_NULL]; /* srvr nb name */
+	int rfc1001_sessinit;
 	kuid_t cred_uid;
 	kuid_t linux_uid;
 	kgid_t linux_gid;
-- 
2.20.1

