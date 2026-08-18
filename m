Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6173DF00B;
	Tue, 18 Aug 2026 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787048996; cv=none; b=F8bObI9sOt6wIZY6CW1WVzqWX5blJjaPNgg+nuC5HyujOrthBRBRwWeozaurouhmbo+m/wM3DirWyvobZZJ84e745z+5Lga/ZTYL0ZH4NzZL0H59KhBt0fusBtjLxyxyPr9v9ZHj/JwnGbcaLgdxs2CY1Gd/2TkLZG6Wrl5Tszs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787048996; c=relaxed/simple;
	bh=5J6LIO7ZuXJfHFopgZ4uyqtR3+Ho4X2+WCmNF1f3Q+M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W299RyZXFah3BDjb6eV3BRrOSFw6f+9vWIqGzCAtmlgsLzPIbPqNLhJuXQVaVPLikdESYz0XucT3Elj8Md/MFMacWvoW66VfW5lzuDDw2HBogMgmV4yT5qGVQ/QwtiQmqcTiyecHfXn2ByTxVwl5qBID+vGSXAZvVZlIwy4Lzys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CuE/lrGP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CuE/lrGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893EC1F00A3E;
	Tue, 18 Aug 2026 10:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787048993;
	bh=m/3ifLeO/V9zJX3ZBj1vaYITNvgCXsDgv6gphRWwGw0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CuE/lrGPX6isVHbIQzZA08LMcy27Fmp6ZutGuN35bVmcmUE6T9J6plBWxx+UPoRTK
	 Zkzl16Oup8Ae8THh6W+l3S2iXXd6dZ+J72hRFD00JdsgSLy1XBv0noXcbWI0lQRtum
	 kp0+ZYV58PVcvNhkXpSy2LSayAFbs8tkRA8+lgNrywF5nts3jf/Wcx9hXcQ/RYs12z
	 54qwPf4FJ0rQgfMJUOma6lN+XMxyE+eWMlJkafpdLln0TKidBJpozi+DMMVHMNaGtk
	 JrAC8Ef1Jqy7/iWGYBH3dcE/V75vAm8ADmk61Y+X/VUX9UAqZtm3Nj9Gb6ZZic0tiY
	 1UfitxFOe8m9w==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 18 Aug 2026 12:29:37 +0200
Subject: [PATCH 2/4] coredump: prevent TIF_NOTIFY_SIGNAL from interrupting
 coredumps
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-work-tif_notify_signal-v1-2-1ee1fcc5b3ff@kernel.org>
References: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
In-Reply-To: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3118; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5J6LIO7ZuXJfHFopgZ4uyqtR3+Ho4X2+WCmNF1f3Q+M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1mEhkrFpo4VP65tNxmZj9Ag+/njX6vOdz6U3X9TNMv
 lwxKknV6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIayEjwzpmh4fHJM1qey28
 jY5yFW///qv0TtHTgkrzwkk/b2iF/2P4w3Eqb13q8iOTxHM4OZz/PVTWeiex9r/2ZJm+U6wfe6f
 18gEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

TIF_NOTIFY_SIGNAL is used to kick a task in uninterruptible sleep to
return to userspace and run task work and then go back to sleep. This
mechanism works well but breaks coredumps. dump_interrupted() only
allows fatal signals to interrupt a coredump and the whole regular write
path going to actual filesystems is impervious to TIF_NOTIFY_SIGNAL as
well.

However, both the usermodehelper pipe and the coredump socket will bail
early on TIF_NOTIFY_SIGNAL. This affects the following codepaths:

- coredump_sock_recv() -> unix_stream_read_generic()
  The request/ack handshake is abandoned before any coredump data is
  sent.

- anon_pipe_write() returning -ERESTARTSYS
  Once the pipe is full this truncates the coredump.

- unix_stream_sendmsg() returning -ERESTARTSYS
  Once the send buffer is full this truncates the coredump.

- coredump_sock_wait() -> __kernel_read()
  This reports a failure that didn't happen.

- wait_for_dump_helpers() -> wait_event_interruptible()
  This stops waiting for the coredump helpers.

Such truncation is entirely invisible to userspace and all uapi bits
still indicate that a successful coredump happened. A crashing process
with a bunch of file backed mappings and io_uring thrown in loses most
of the coredump data. If the NT_FILE note goes past PAGE_SIZE mappings
it's gonzo.

TIF_NOTIFY_SIGNAL is sent by io_uring for the common case. And it uses
poll without sleeping so a completion callback runs task_work_add() from
interrupt context against the task that submitted the request. This is
the task that is running the coredump. Since that task hasn't set
work_exited (it hasn't exited yet after all) TIF_NOTIFY_SIGNAL keeps
reappearing.

A coredumping task doesn't return to userspace. The task work is run at
exit. So interrupting it doesn't buy anything and just loses the
coredump which is quite valuable.

Note that this isn't specific to io_uring. There's also
klp_send_signals(), bpf_task_work_schedule_signal(), landlock's tsync
and then  technically, kthread_stop() and the printk kunit test set the
bit raw.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index e68a76ff92a3..edb5a1a61d84 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1165,6 +1165,7 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
 	struct core_name cn;
 	const struct mm_struct *mm = current->mm;
 	const struct linux_binfmt *binfmt = mm->binfmt;
+	unsigned int notify_flags;
 	int argc = 0;
 	struct coredump_params cprm = {
 		.siginfo = siginfo,
@@ -1196,9 +1197,12 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
 	if (coredump_wait(siginfo->si_signo, &core_state) < 0)
 		return;
 
+	/* Task work must not cut the dump short, see signal_pending(). */
+	notify_flags = no_notify_signal_save();
 	scoped_with_creds(cred)
 		do_coredump(&cn, &cprm, &argv, &argc, binfmt);
 	coredump_cleanup(&cn, &cprm);
+	no_notify_signal_restore(notify_flags);
 	return;
 }
 

-- 
2.53.0

