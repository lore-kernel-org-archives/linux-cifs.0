Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF0A3D8120
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 05:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781589257; cv=none; b=B3PX6vbN4Zz5TZrdRKYN+J9DRok4Acj4pcliRliX7jGaXeDyLK/eilBbPLQVADKEJkNWQyIYaPam2hieg7WXXMfS+up/I0P/NS3+j6APC9c/uPOxXv4N8i//jBX07BCaK35oJKw3zyRzHa3z2VKdyPVm+q5jf7IyWT/tmK/VPD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781589257; c=relaxed/simple;
	bh=nhK5erLPMld59NqJFTXEr32ELobTHwtHREBLVNCVBQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWytUCxrfESR4xumX9TVKWNsQdEa60TM4yX3UcGCzt3GdHAHS+ZLpW0ygxpBaXH8DU61KX/sgT8UmJVZ3w4Uwwm1KoqCFa1igjgWpsJPdMT4xfe9jo96Oa2TTL3XelvYYYz/dtzxuVP3qzR/gIiWJ0SoBE3sNPnCLRG6Mnd2K+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VF1jOOGS; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VF1jOOGS"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c27fc587ebso16174705ad.0
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jun 2026 22:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781589255; x=1782194055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a2WHE69XCvPsuob7aME3t/R6BnMk/X5IWMhOHC9uOQw=;
        b=VF1jOOGSIZdWpBUdGaRH1mg5+uzle+N9cI94DENkgIS2HAY501A34n8DPSlpY/qICC
         Z5Cluxj6uVEq5CRodJ85gtzbvcParHAblyZ+rnLW4vi/RRA7H1oWlC9BEP1UtOQXC1Fh
         wt5tJoLrU9fZmyGtQbXFrf65LKHT2tytXX2HkD9BsY+X97MqixtqSQ7VqKr+Dg8gk1km
         sAKNeGDMaJHmygKczwjeVyoLwnUyzCjRNzS5oQxgG+fIl3rGzt8mXJIUYDz/duPUTirA
         pQV39OQxHNlNSO1k5ZYxoZSBdl63AcSLiMjS2fR09Af66SY12WVx+49Q+/51I5D7i+5X
         lH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781589255; x=1782194055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a2WHE69XCvPsuob7aME3t/R6BnMk/X5IWMhOHC9uOQw=;
        b=RjBC93mROKIgIDIHWOlx0xwe2nxr5pIdoKFb53JFSGWMsbfYDIJqzAyloF3wmZQQLT
         At0Mxsg3tRh1KRFfBULM060skRUyNKSjFLMqg3/q9xiuMXwn6VH+Q0juBMPiqUJDED64
         D/o2mehK6r/EzwdBmq8Lbv9pZwdY+b/xfTTENvndPtopyydZXdmtAr0Qh8ng1Xru6Wwy
         pwHKyek810tK8xJlHDXG9OWl2OfP/4Ggkb7ct8SO5msRMM7XMEVJh9JtKOeHH7znjuY2
         7KPtu/JidTomqv/si6zhC5WqOxACf/bEytCpd46t3iOKOJLRVo1Gquy9vZRNVz+8mwbp
         sDfg==
X-Gm-Message-State: AOJu0YxePHD9y6wXkU5VqRz2zShiBvxqH4HVqXLZKwTYMgvaF8Jd2WzY
	i0ylSxw5pYmRUPp1WhWis3hPC4RQrTDtcv0K5Xh9k0V4eIr7XxMFTqKO
X-Gm-Gg: Acq92OFgkbuYwcthdI9BXssnGOCiLPd9nzqTGWZ4a48kcf7PncmX07maVXXYW6KRZMO
	Di1J88XBBpF4ddVzGR21hP08FbdX1hjVXHfGjGDxp3ChVSmSHkZu91YF/0XUqbYdx6zegp42yY6
	kYha9XWSevm5swfAi7XnCV4kKtjk+4nTj9lq2pGTwNC/eNLHtYKoWolb0rIvUGZWPhBATBo9cqk
	LfJoWR4KCj42u6busv5VuSIBqM4r6TP2jUouf6EpuWXhDT2efXYJi1rJxJ8KA1Gs0d7wfjo0X4i
	P31bPYBt0jgRZ9yMB5QOesZMCvdMS9GvNFmwznbp1Ki/a3hBe23A/dpSO4LgQfFW/vM3a7H/X+d
	inTVKxox9o6lau0PMZOxOPn7Vq23Yh6TkP/2Q0nxOIMwdawBqL1vmEK1vdGdUHRczaO7GnbRc3T
	t2WnKrxEk+QCpGhoL6hbw2JNjWMIUgq23P07eEyn7sZ60gK3od+GPROnfoDpfTq46IXJ6xLZo1/
	opVSsZCj8j2wUlbcvL1FF0=
X-Received: by 2002:a17:903:2f44:b0:2c0:cb0e:ac3a with SMTP id d9443c01a7336-2c69a1678c4mr23532235ad.23.1781589255443;
        Mon, 15 Jun 2026 22:54:15 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e52b5sm120805275ad.7.2026.06.15.22.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 22:54:15 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	Rajasi Mandal <rajasimandal@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v4 3/7] smb: client: sync retrans on remount
Date: Tue, 16 Jun 2026 05:53:53 +0000
Message-ID: <20260616055357.3798387-4-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616055357.3798387-1-rajasimandalos@gmail.com>
References: <20260616055357.3798387-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

The retrans mount option controls how many times the client retries
sending a request before giving up.  Although remount already stored
the new value in cifs_sb->ctx, it was never propagated to
server->retrans, so the running connection kept using the old count.

Introduce smb3_sync_server_opts() to push ctx options that live on
TCP_Server_Info into the live server struct after a successful
remount.  For now it handles retrans; subsequent patches will extend
it to other server-level knobs.

The previous patch in this series ("smb: client: sync runtime state
into ctx on reconfigure") duplicates the existing context on remount,
so a bare 'mount -o remount' carries the old retrans value forward and
the parser only overwrites it when the user explicitly passes
retrans=N.  No special-casing for the bare-remount /proc/mounts replay
is therefore needed; in particular, an explicit retrans=0 from the
user now correctly resets the value to the compile-time default.

Writes to server->retrans are unsynchronized to match the existing
convention: every other reader of the field (smb2ops.c retry path,
cifs_show_options(), the original cifs_get_tcp_session() writer) does
not take server->srv_lock, and match_server() only reads it under
srv_lock as part of the larger match function.

Note that retrans lives on TCP_Server_Info and is therefore shared
across all mounts to the same server; reconfiguring one mount updates
the value seen by every other mount sharing the connection.  This is
consistent with the existing semantics: cifs_show_options() already
reads server->retrans for /proc/mounts on every mount, and the
runtime retry path always uses the server's value rather than any
per-mount copy.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/fs_context.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index d5a7d4dd402b..bfbea0648f6a 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1278,6 +1278,24 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels)
 	spin_unlock(&ses->chan_lock);
 }
 
+/*
+ * Synchronize server-level options that are stored on TCP_Server_Info
+ * at mount time.  These fields are consulted at runtime (retry logic)
+ * so remount needs to update the live server struct in addition to
+ * cifs_sb->ctx.  Note these live on TCP_Server_Info and are therefore
+ * shared across all mounts to the same server; reconfiguring one mount
+ * updates the value seen by every other mount sharing the connection,
+ * matching how cifs_show_options() and the runtime retry path already
+ * read them unsynchronized from the server struct.
+ */
+static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
+{
+	struct TCP_Server_Info *server = cifs_sb_master_tcon(cifs_sb)->ses->server;
+	struct smb3_fs_context *ctx = cifs_sb->ctx;
+
+	server->retrans = ctx->retrans;
+}
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
@@ -1447,6 +1465,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (!rc)
 		rc = dfs_cache_remount_fs(cifs_sb);
 #endif
+	if (!rc)
+		smb3_sync_server_opts(cifs_sb);
 
 	return rc;
 
-- 
2.43.0

