Received: from smtpfb2-g21.free.fr (smtpfb2-g21.free.fr [212.27.42.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD00198E60
	for <linux-cifs@vger.kernel.org>; Tue,  6 May 2025 10:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746527498; cv=none; b=DEjhTbRFkzo65a+5ywMUm8tgriYbXrlKk/2y/ggRHESRxlcI4+1tHOn6STeKNwFUlJX3z5ENaEaiHeQ8wUUlV4II5ec15Ot1Vrrar7u4XsvnTPNIx27rAJvj/0BSh/cIuLmxYmp9M9J8UpyZFwxsNC9kd+J6YT4B05mm34Lmofw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746527498; c=relaxed/simple;
	bh=IZPfWgjSaP/63XRchVKUgVeekZJDTqKXmUd9Bec2H4c=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=hVMJ2GbtkSW60zH5ZBhG/sD9wPoSWa3VGYRiYZ1717/jgIoha/VXhh2X5OFe9MkExxxUEkmYRKn7T6etjb4BSv2F7HspQGennZlckxrcVV1RHP7tswyNYOUGBtNjB3zB8f+Uf3YsoFxoXNh+EFZisboCDG+lzQJgLtaX2hhoafo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kueny.fr; spf=pass smtp.mailfrom=kueny.fr; arc=none smtp.client-ip=212.27.42.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kueny.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kueny.fr
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id B818842C07C
	for <linux-cifs@vger.kernel.org>; Tue,  6 May 2025 12:25:29 +0200 (CEST)
Received: from [192.168.0.17] (unknown [92.151.61.131])
	(Authenticated sender: lucy.kueny@free.fr)
	by smtp5-g21.free.fr (Postfix) with ESMTPSA id AD51160236
	for <linux-cifs@vger.kernel.org>; Tue,  6 May 2025 12:25:21 +0200 (CEST)
Message-ID: <d7084ebd-64c0-46cb-b1d0-fd04c9de96d2@kueny.fr>
Date: Tue, 6 May 2025 12:25:21 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-cifs@vger.kernel.org
Content-Language: en-US
From: Lucy Kueny <lucy@kueny.fr>
Subject: Soft mount option not behaving as intended
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello everyone,

The "soft" mount option is described in the man page as:
"The program accessing a file on the cifs mounted file system will not hang when the server crashes and will return errors to the user application."

In practice, this is not the case. Modern software, especially GUIs, makes multiple calls to the filesystem at once. Each of which will result in a reconnect attempt with a 10-second timeout. In practice, this results in frozen user interfaces and shells.

It seems illogical to wait 10 seconds for every filesystem call once we know the server is inaccessible.

I wrote a patch that limits the number of blocking calls two years ago but failed to send it correctly. I have been using it without issues for that time. I have recently seen interest in this idea from others.

The mount option "max_blocking_recon" limits the number of successive failed connection attempts, after which EHOSTDOWN will be returned immediately. This avoids locking up whole desktop environments. I recommend setting it to 1.

Any comments on this idea?

Thanks in advance,
Lucy Kueny


From 98e2e44d39f4f5172e3ce416a2e65a48b51e2de1 Mon Sep 17 00:00:00 2001
From: Lucy Kueny <lucy@kueny.fr>
Date: Fri, 22 Sep 2023 11:06:20 +0200
Subject: [PATCH] Stop reconnect timeouts from freezing userspace

---
 fs/smb/client/cifsfs.c     |  3 +++
 fs/smb/client/cifsglob.h   |  6 ++++++
 fs/smb/client/connect.c    |  2 ++
 fs/smb/client/fs_context.c |  6 ++++++
 fs/smb/client/fs_context.h |  2 ++
 fs/smb/client/misc.c       | 13 +++++++++++++
 6 files changed, 32 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 22869cda1356..ea338b335074 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -694,6 +694,9 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",noblocksend");
 	if (tcon->ses->server->nosharesock)
 		seq_puts(s, ",nosharesock");
+	if (tcon->ses->server->max_blocking_reconnect != DEFAULT_MAX_BLOCKING_RECONNECT)
+		seq_printf(s, ",max_blocking_reconnect=%lu",
+			   tcon->ses->server->max_blocking_reconnect);

 	if (tcon->snapshot_time)
 		seq_printf(s, ",snapshot=%llu", tcon->snapshot_time);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 032d8716f671..5128123148e1 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -84,6 +84,10 @@
 /* maximum number of PDUs in one compound */
 #define MAX_COMPOUND 5

+/* maximum failed reconnects before file access fails without waiting */
+#define DEFAULT_MAX_BLOCKING_RECONNECT 0
+
+
 /*
  * Default number of credits to keep available for SMB3.
  * This value is chosen somewhat arbitrarily. The Windows client
@@ -731,6 +735,8 @@ struct TCP_Server_Info {
 	struct delayed_work reconnect; /* reconnect workqueue job */
 	struct mutex reconnect_mutex; /* prevent simultaneous reconnects */
 	unsigned long echo_interval;
+	unsigned long max_blocking_reconnect; /* maximum failed reconnects before file access fails without waiting */
+	unsigned long reconnect_fail_cnt; /* subsequent reconnect timeout on file access */

 	/*
 	 * Number of targets available for reconnect. The more targets
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 687754791bf0..999f87633baa 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1740,6 +1740,8 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 			goto out_err_crypto_release;
 		}
 	}
+	tcp_ses->max_blocking_reconnect = ctx->max_blocking_reconnect;
+	tcp_ses->reconnect_fail_cnt = 0;
 	rc = ip_connect(tcp_ses);
 	if (rc < 0) {
 		cifs_dbg(VFS, "Error connecting to socket. Aborting operation.\n");
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index e45ce31bbda7..0ae441c97bff 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -154,6 +154,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_u32("handletimeout", Opt_handletimeout),
 	fsparam_u64("snapshot", Opt_snapshot),
 	fsparam_u32("max_channels", Opt_max_channels),
+	fsparam_u32("max_blocking_recon", Opt_max_blocking_reconnect),

 	/* Mount options which take string value */
 	fsparam_string("source", Opt_source),
@@ -1166,6 +1167,9 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		if (result.uint_32 > 1)
 			ctx->multichannel = true;
 		break;
+	case Opt_max_blocking_reconnect:
+		ctx->max_blocking_reconnect = result.uint_32;
+		break;
 	case Opt_max_cached_dirs:
 		if (result.uint_32 < 1) {
 			cifs_errorf(fc, "%s: Invalid max_cached_dirs, needs to be 1 or more\n",
@@ -1615,6 +1619,8 @@ int smb3_init_fs_context(struct fs_context *fc)
 	ctx->multichannel = false;
 	ctx->max_channels = 1;

+	ctx->max_blocking_reconnect = DEFAULT_MAX_BLOCKING_RECONNECT;
+
 	ctx->backupuid_specified = false; /* no backup intent for a user */
 	ctx->backupgid_specified = false; /* no backup intent for a group */

diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 9d8d34af0211..478b3a9d3af5 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -131,6 +131,7 @@ enum cifs_param {
 	Opt_max_cached_dirs,
 	Opt_snapshot,
 	Opt_max_channels,
+	Opt_max_blocking_reconnect,
 	Opt_handletimeout,

 	/* Mount options which take string value */
@@ -262,6 +263,7 @@ struct smb3_fs_context {
 	__u32 handle_timeout; /* persistent and durable handle timeout in ms */
 	unsigned int max_credits; /* smb3 max_credits 10 < credits < 60000 */
 	unsigned int max_channels;
+	unsigned int max_blocking_reconnect;
 	unsigned int max_cached_dirs;
 	__u16 compression; /* compression algorithm 0xFFFF default 0=disabled */
 	bool rootfs:1; /* if it's a SMB root file system */
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 366b755ca913..51320ec6b08a 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1318,6 +1318,13 @@ int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
 		return 0;
 	}
 	timeout *= server->nr_targets;
+	/* return immediatly on repeated timeouts */
+	if (server->max_blocking_reconnect &&
+		server->reconnect_fail_cnt >= server->max_blocking_reconnect) {
+		spin_unlock(&server->srv_lock);
+		cifs_dbg(FYI, "%s: not waiting for reconnect as requested\n", __func__);
+		return -EHOSTDOWN;
+	}
 	spin_unlock(&server->srv_lock);

 	/*
@@ -1341,12 +1348,18 @@ int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
 		/* are we still trying to reconnect? */
 		spin_lock(&server->srv_lock);
 		if (server->tcpStatus != CifsNeedReconnect) {
+			server->reconnect_fail_cnt = 0;
 			spin_unlock(&server->srv_lock);
 			return 0;
 		}
 		spin_unlock(&server->srv_lock);
 	} while (retry);

+	/* increase failed attempt counter */
+	spin_lock(&server->srv_lock);
+	server->reconnect_fail_cnt += 1;
+	spin_unlock(&server->srv_lock);
+
 	cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
 	return -EHOSTDOWN;
 }
--
2.42.0
