Received: from smtpfb1-g21.free.fr (smtpfb1-g21.free.fr [212.27.42.9])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55412BE49
	for <linux-cifs@vger.kernel.org>; Sun,  4 Feb 2024 23:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707089770; cv=none; b=QpEi++tryqpPlrcz8zUl6tLtX+n5YDIZzYcaTGp3XlIYrraMBUPvoXYctIGidF10w9LfN4apkAUZhlykmRAL/vn6qjluTFX2Fr1g0HPSmTEtuJP0PdoM6BqfV0Ibgz0uwval/230Xe35utNZuNauaeTOP10kM5NgEEW3ExGzDs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707089770; c=relaxed/simple;
	bh=xxxv0go0u4Q9a+8Oo+oACrpQSPYIKTv4CHnwZxdao8M=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=RlcmpPv9OHsVhrn9ZDRKvkV/+/3zqYXdaHRb59ZTGkw63Pz655Uvrd0cFiRQgRK9EU9Y/2Ype18Bo2QtoSXwvOAe7iQqQpkqqwoiDnnd1R0ds8Ux/vxeMRidlY2++yvdKAIx/SzCQCM87kd2BIChGqFopvxMSg5ms4NM12esG4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kueny.fr; spf=none smtp.mailfrom=kueny.fr; arc=none smtp.client-ip=212.27.42.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kueny.fr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=kueny.fr
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id B4096DF8316
	for <linux-cifs@vger.kernel.org>; Mon,  5 Feb 2024 00:26:52 +0100 (CET)
Received: from [192.168.0.17] (unknown [86.242.90.107])
	(Authenticated sender: lucy.kueny@free.fr)
	by smtp2-g21.free.fr (Postfix) with ESMTPSA id 6E65C20039C;
	Mon,  5 Feb 2024 00:26:42 +0100 (CET)
Message-ID: <b5a481ec-7c97-4b28-a807-606bea3617ff@kueny.fr>
Date: Mon, 5 Feb 2024 00:26:42 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Lucy Kueny <lucy@kueny.fr>
Subject: Re: How to automatically drop unresponsive CIFS /SMB connections
To: "R. Diez" <rdiez-2006@rd10.de>, linux-cifs@vger.kernel.org
References: <428ab7ba-0960-4e5e-a4ab-290dac58f45b@rd10.de>
Content-Language: en-US
In-Reply-To: <428ab7ba-0960-4e5e-a4ab-290dac58f45b@rd10.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 03/02/2024 23:48, R. Diez wrote:
> Hi all:
> 
> I have been mounting Windows shares for years with this script, which
> just boils down to "sudo mount -t cifs":
> 
> https://github.com/rdiez/Tools/blob/master/MountWindowsShares/mount-windows-shares-sudo.sh
> 
> I noticed under Linux that some applications (like Emacs), the desktop's
> file manager (like Caja) or even the whole desktop sometimes hang for a
> number of seconds. It is very annoying. It turns out the reason is that
> the hanging software is trying to look at a file or a directory on an
> unresponsive CIFS / SMB mount.
> 
> The easiest way to reproduce this issue is from outside the office: I
> start the VPN, connect to the Windows shares, and then tear down the VPN.
> 
> I have tried mount option "echo_interval=4", but that does not really
> help. The Kernel does seem to notice more quickly that the connection
> has become unresponsive:
> 
> Feb 03 23:24:37 rdiez4 kernel: CIFS: VFS: \\192.168.1.3 has not
> responded in 12 seconds. Reconnecting...
> 
> The trouble is, it tries to reconnect automatically. That means that the
> next application which attempts to access something under the
> unresponsive mount will hang again. I think the pauses last 10 seconds,
> it must be hard-coded in the CIFS Kernel code. If the application
> retries itself, or tries to look at more than 1 file before failing the
> whole operation, then the time adds up accordingly. If the shell's
> current directory is on such a failing path, it bugs you for a while.
> 
> What I need is for the connection to automatically drop when it becomes
> unresponsive, and do not retry to connect again.
> 
> Alternatively, applications should fail immediately if a connection has
> been deemed unresponsive in the meantime, and hasn't been successfully
> re-established yet.
> 
> Is there a way to achieve that behaviour?
> 
> Thanks in advance,
>   rdiez
> 

Hi everyone,

I have written a patch that does this. It adds a mount flag to return as unavailable immediately after N reconnect attempts.
It's written against Linux 6.7 but still applies on cifs-2.6. I asked the same question on this mailing list a while ago.

Add "max_blocking_recon=1" to your mount arguments. I run it on my machines.
It probably needs polishing from somebody more experienced than me.


Best regards,
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




