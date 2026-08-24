Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF929352004;
	Mon, 24 Aug 2026 12:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787573310; cv=none; b=OI3Cdqp8P5uNvdcm7dgTK5mhq+pPAbPtrX/DxKLdT6t9VtxoibuJXMBxx+c5vsrMzhCG8KADXDELQpqvnGD2prrm+bjw+HI7lf+zJNFhOuy3Hn+6FIri5Tnm070h1VhRWrMslEn/oY1OXA4zFLkCRzoJv4eKOyB+BN/7ieIhKYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787573310; c=relaxed/simple;
	bh=dWRAsCglCo/M3vK0FN3SrSESVBbJXhJ2obKurvHCQb0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HKr2OJeCwJw+HZvvkNkl/ho1hNFDgzRG73gCPUMvYkR/PMcCHTBwJFCXntOlv4KivZyQhQDHAag9IfIQp7+i75fMVbnz5m0bLRfVH1fH+ZFVgUGym1gF7b17iQ5QS7Qr2jkDD+i0XX0ILPLhpDvPFHs51M8+ttSs7bJdrn6Mv74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G98Ov3/n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G98Ov3/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16701F000E9;
	Mon, 24 Aug 2026 12:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787573308;
	bh=f/+JvnDhjNopw+2Gz7qCznpexTN/om/tJxtCsJ2MGLM=;
	h=From:Subject:Date:To:Cc;
	b=G98Ov3/nUrA9AhbdYxFPOM3c/11BTrh7mgkH3pJEfqouS9ul+ppypntqTl2J8+vLC
	 ggNL6L3KYdHMLhAR9ur84/ldXHuBdThGIo1M8bcsIkqjJrDfMAjrDq7TRUM/1i+nGN
	 7oqBHTj1yJaAqP9yTiI6IdvALGuR+GZOBi+55SYp1kMveeyvZozfQQKHUg0nFGcBkF
	 w3Wm2IdDhMPba/7yh6+qDxKjiPC6BmPQvLXb8aiLCfnCnpIUiODhZ1tbrOVgUMsYzw
	 Ohe19K9g2KH/BXzcm9HY9Rkt6YpMw5hwY70s3eWGm8/CXeGf0bX/3jcPEyopSYZi8a
	 5oE/EU8v7NlWQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 0/5] Stop TIF_NOTIFY_SIGNAL from interrupting work that
 can't be restarted
Date: Mon, 24 Aug 2026 14:08:15 +0200
Message-Id: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WO3crCMAyGb0V6bKVdt1o98j5EpD/p1k9tJZ1Tk
 d27reLhRyDwhOTJ+yIZMEAm28WLIEwhhxQLNMsFsYOOPdDgCpOGNZIpvqb3hCc6Bn+MqfTnMYc
 +6jOV2jDFnBByI0g5viL48PiI94cv55v5AztWW90wOgM1qKMd6uii8wi4UlwZKCWFc9L4zrfA1
 sDbzkvrjLbQNUyL1lbDEPKY8PnJPvH66RdT/Rdz4pRRDsC9tZ0R3u9OgBHOq4Q9Oczz/AYX9Qf
 KEQEAAA==
X-Change-ID: 20260817-work-tif_notify_signal-6ab080d33693
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Paulo Alcantara <pc@manguebit.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=6564; i=brauner@kernel.org;
 h=from:subject:message-id; bh=dWRAsCglCo/M3vK0FN3SrSESVBbJXhJ2obKurvHCQb0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT1mFje156X5qe7usXgWtz6TE1h5ZlnX2ZJsLe/e7B8y
 bqAxGM5HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMpecXIsJRT8v9dxvCsc9FW
 No+21M1Kfv1z88eTjsfSqjxj2pfsPMLIcGilbv7s24wLMxM2/NP/cVrwWVnF3T3L2vY9+pkfuOH
 adV4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Ok, so I was looking into things and as usual got
side-tracked so here we are. Oleg, save me please.

TIF_NOTIFY_SIGNAL is used to kick a task in uninterruptible sleep to
return to userspace and run task work and then go back to sleep. This
mechanism works well but breaks coredumps. dump_interrupted() only
allows fatal signals to interrupt a coredump and the whole regular write
path going to actual filesystems is impervious to TIF_NOTIFY_SIGNAL as
well.

The core is that you can have quite deep callchains that end up calling
signal_pending() in both the pipe and the socket codepaths so it's like
we can just pass a flag through somehow.

For coredumps its very annoying because it means io_uring is - depending
on how much outstanding work you have - incompatible with generating
non-truncated coredumps. A process with too many file backed mappings
and io_uring requests in flight ends up losing most of the coredump.

While zap_threads() has cleared TIF_SIGPENDING for a long time, just
clearing TIF_NOTIFY_SIGNAL isn't going to work because the next
completion will just set it again.

The fun part also is that io_uring isn't actually the only case:

(1) io_uring

(2) klp_send_signals()

(3) bpf_task_work_schedule_signal()

(4) landlock's tsync

And technically, kthread_stop() and the printk kunit test set the bit
raw. So no simple way of just fixing this in one subsystem.

So, a fix for this issue has the following constraints:

(i) The places where a write is aborted are deep callchains that we
    can't reasonably parameterize. For example, anon_pipe_write(),
    unix_stream_sendmsg(), unix_stream_read_generic(),
    sk_stream_wait_memory(), or a bare wait_event_interruptible() in
    wait_for_dump_helpers(). All of them are shared with regular
    syscalls that must stay interruptible.

    IOW, the state has to be per-task and ambient.

    An LLM would call this "load bearing"...

(ii) There are multiple ways TIF_NOTIFY_SIGNAL can get raised and they
     can get set from irq context against any task. As said above we
     have at least io_uring paths (poll task_work, msg_ring, tctx exit,
     io-wq via __set_notify_signal()), bpf_task_work_schedule_signal(),
     klp_send_signals(), landlock tsync, plus kthread_stop() and the
     printk kunit stuff that set the bit raw.

     So fixing this up in the individual subsystems is doomed to fail or
     require constant audits in case some new variant shows up.

(iii) The coredump task is exiting and can't restart the work.

So here's some stuff that was considered but I think is not really
feasible:

(a) Check for task_is_coredumping(). That will end up forcing
    task_work_add() users to know about coredumps. This seems like a
    layering violation.

    I have a patch for this as well but it's ugly. It races with the
    dump starting unless the bit setter takes a lock in the io_uring
    completion. I know someone that will disagree with this approach. ;)

(b) Oleg's old suggestion iirc. Just clear the bit at coredump entry.
    That doesn't work because io_uring poll completions just raise it
    again from irq context. So you also need synchronization with the
    setter of which there are quite a few.

(c) Let the setting task defer setting the bit if the task is flagged
    and then raise it again at exit.

(d) Take TIF_NOTIFY_SIGNAL out of singal_pending() and make it opt-in at
    specific points. That breaks io_uring quite badly and forces a
    tree-wide audit.

So the amount of patches for this issue over the years is impressive. So
let me add one to the pile for the lolz.

Add PF_NO_NOTIFY_SIGNAL and helpers to raise/restore it. This is the
same approach as memalloc_nofs_save(). signal_pending() will not report
a fake pending signal via TIF_NOTIFY_SIGNAL if inside a
PF_NO_NOTIFY_SIGNAL critical section. Obviously you can't
fork()/clone3() in such a section.

Fix coredumps, smb, and pid namespace busy-reaping. Fwiw, I think
there's a few other potential users of the helpers that are left out of
this series.

|         |    notify_signal_pipe     |   notify_signal_socket    |
|---------|---------------------------|---------------------------|
| fix     | ok                        | ok                        |
|---------|---------------------------|---------------------------|
| unfixed | 357324 of ≥ 5111808 bytes | 467336 of ≥ 5111808 bytes |

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- no_notify_signal_save() now returns the unmasked current->flags,
  current_restore_flags() masks on restore (Oleg)
- Add an irqsave-style no_notify_signal guard on top of the helpers
  and use it at all three sites
- New patch: pid_namespace: prevent TIF_NOTIFY_SIGNAL from
  interrupting the reaper (suggested by Oleg)
- selftests: unlink stale core file and socket in the fixture setup so
  a killed previous run can't fake a result; assert the exact expected
  dump size
- Add Fixes:/Cc: stable tags
- Carried Paulo's Acked-by on the smb patch over the mechanical
  conversion to the scoped guard
- Link to v1: https://patch.msgid.link/20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org

---
Christian Brauner (5):
      signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL
      coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps
      selftests/coredump: test that TIF_NOTIFY_SIGNAL doesn't truncate a coredump
      smb: prevent TIF_NOTIFY_SIGNAL from interrupting
      pid_namespace: prevent TIF_NOTIFY_SIGNAL from interrupting the reaper

 fs/coredump.c                                      |   2 +
 fs/smb/client/transport.c                          |  13 +-
 include/linux/sched.h                              |   2 +-
 include/linux/sched/signal.h                       |  27 +-
 kernel/pid_namespace.c                             |   3 +-
 tools/testing/selftests/coredump/Makefile          |   7 +-
 .../selftests/coredump/coredump_notify_signal.h    |  29 ++
 .../coredump/coredump_notify_signal_helper.c       |  46 +++
 .../coredump/coredump_notify_signal_test.c         | 245 ++++++++++++++++
 tools/testing/selftests/coredump/coredump_test.h   |   1 +
 .../selftests/coredump/coredump_test_helpers.c     | 311 +++++++++++++++++++++
 11 files changed, 672 insertions(+), 14 deletions(-)
---
base-commit: 818bebeb63dd6bf5f4e07e145f6cdbace520a34c
change-id: 20260817-work-tif_notify_signal-6ab080d33693

