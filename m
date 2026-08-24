Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4925283FDC;
	Mon, 24 Aug 2026 12:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787573316; cv=none; b=pXTcp7b4OnRvf3zhNEoU/T0pDRFAbSAowft17rcxPpCOt63T3f6e7h1wOgPnvNbMiC/KuH4CvE6i4wxMQmWsyXTiQVBFVLNXjORa6daHj5nU5uY+m7VapLmgW3DL7T6RCT/FIRouafnbk16Z/nFL102E5i1Hf88+VjPWvpo9VaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787573316; c=relaxed/simple;
	bh=DHJsUzzShnk3N0huGLg1kLKcHTGnYQ2IAgRGy+bA1w0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OOZoItTf1Z1g3w52tf9Hc9Ax1n7pmUGD0nvIBfXJSAVsafHY6/9Vyqm4r8w4ZPswBrc+TuLwfMM21O9yY0x0B/xInlJss8TkNw+WSWUWzuAB+Tn0JSIe0w41MyIOLOf5XVnyNclvyXxvZHJCC9wKtVypteg/yZNgEyYPeAO6Fio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HtVwjkb+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HtVwjkb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B711F00A3D;
	Mon, 24 Aug 2026 12:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787573314;
	bh=9DywixF9AvDfrDjTJhpivG128OaV1hgmNtytvsZpw/U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HtVwjkb+nDOrvH5qXwXX8MGKNAbdAFVFD8riPDCq7bF1TvOogIiq09EjYNW+dpdxI
	 QqV3KdOWp04ZYrl1bv1cwrEpO6sGdaX2SUUyEIN3luTRIsAnCTnwzRsQJvqE6EF7+Z
	 km4HKvL0CZjnhq9bKs7Hi+qxrdVE23/CSdU5CTpX6fdI/yJuLh6oaXHePwHmAAtClv
	 cSfbqEUjJibUe5ccU5R+qMlLmSBXQAmi/8tcb9I4h5DElwR6tipigesxloKZf+nqpN
	 o8zwnIB3GeRSdpXc/pqdKaIBxn1JNWQf2eSUGA58Obh3X8sQf1fpTUpgjZEJAa+5mu
	 CIsOZrHVIwt4Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 24 Aug 2026 14:08:17 +0200
Subject: [PATCH v2 2/5] coredump: prevent TIF_NOTIFY_SIGNAL from
 interrupting coredumps
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-work-tif_notify_signal-v2-2-6609e42b3157@kernel.org>
References: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
In-Reply-To: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2835; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DHJsUzzShnk3N0huGLg1kLKcHTGnYQ2IAgRGy+bA1w0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT1mFjuu39KX6Nz52rGh43NFzMPzn7tfkBok1DwDO0XF
 2I7g0u/d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyEqYuRYdYa1cJ3X48XvV7u
 edLy9AvlnNvPP3kk7Jxg8PEfs9zemRwMv1ler38uUVDLu276ih8vPLeeOqQ5g/vjEjOF6quRMxi
 ubWQHAA==
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

Fixes: 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index ac3cd74808c6..7c0f276c3e0d 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1191,6 +1191,8 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
 	if (coredump_wait(siginfo->si_signo, &core_state) < 0)
 		return;
 
+	/* Task work must not cut the dump short, see signal_pending(). */
+	guard(no_notify_signal)();
 	scoped_with_creds(cred)
 		do_coredump(&cn, &cprm, &argv, &argc, binfmt);
 	coredump_cleanup(&cn, &cprm);

-- 
2.53.0

