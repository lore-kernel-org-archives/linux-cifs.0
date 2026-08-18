Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95101339B3D;
	Tue, 18 Aug 2026 10:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787048988; cv=none; b=Yu/5h26mQSl2zZYSpJR6aEHDPy9AzbO0OdL05OtWnp58g8eaUCMgPIXbuusm8sicHMqSRN9p2vmTpx3sDhplhk13fewowUIUie5URLU35rsXIvfDNNPlJ9Jf1snC/kl57camplmtuJ6PKuxodJM9P3xk05M5S0Nfp8zAvbfXLQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787048988; c=relaxed/simple;
	bh=IkGa6xqKFM5x7wT1EwhGFPFaIGs9Gn9uxpjtq8no2A0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Qw9rnQa81cGwRWZQ7mFA8YXRn6XNgxpOmqezE3Z12+KN22g4DH3DSlPg011gPrRTUabe2JGMXGrxJ1b5pgB5VB1OWXaFM59zrEXTH3pMcLzdeXiX00RFlmhljiTmc3nf7xfrlAz2IqCoo8Vcht92M5E9l9tLOvrXYaZoUkFEk4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuFqqhx/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuFqqhx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D781A1F000E9;
	Tue, 18 Aug 2026 10:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787048987;
	bh=YGBu95KxEYL60/6Z19Vi2hF5fBbivoB9n1qwKiIoQCA=;
	h=From:Subject:Date:To:Cc;
	b=NuFqqhx/OBpG4enp+eYRdbfn7ghsLQThetOxvPIFUTslDtl7sQEqYSRncFJjSNLME
	 tHvpuXUaGEtJTshEQmEvEVrUELhr+x1sNnlmdx1UCiFIaPIE+IrKfWyl3o7MTFzBMb
	 Jar4dMZ3WjHgaLLQO6WO7Ja9zmMVR1kt1OEmVkuHHF5RR0Q86DvDqiAmw6LwjmBi5B
	 h4E2Lg6wzH9kFsEDnzkC1wRwo6KnPdQ5vLIlZJlxGBOkPwXICi7jrmFueLVOhV4ej2
	 QQwJd8okOEDS3uRsMKSgpN1UCfDt4PEl3FJpD/+bKiHjbddgIHnq89OPvGv1ccmzxr
	 Gtq34sog6jPVg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/4] Stop TIF_NOTIFY_SIGNAL from interrupting work that
 can't be restarted
Date: Tue, 18 Aug 2026 12:29:35 +0200
Message-Id: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM2w6CMBBEf4XssyWlJAX9FWNICwusl5bsImoI/
 27Rl0nOZOasIMiEAqdsBcaFhGJIUBwyaEcXBlTUJQajjdV1UalX5JuaqW9CTPlphIbg7so6r2v
 dlaU9lpDOE2NP75/4fPmzPP0V23m37QvvBJVnF9pxrx5OZuR8qXID2/YF7EDK4pgAAAA=
X-Change-ID: 20260817-work-tif_notify_signal-6ab080d33693
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=5657; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IkGa6xqKFM5x7wT1EwhGFPFaIGs9Gn9uxpjtq8no2A0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1mEi8d51zdc+hz9ordprwXjomqr104t+pot8OP7qwa
 HWzg5HqqY5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJ7LnL8E9PxWHzicts8foZ
 F3/cvrzC4o1tSNqiCqX8JUa+ibeY15gyMryZ/v76KZGtC5tuGcUzKUoETNkWlnfx4bqnp2UcDnN
 OZuEDAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Ok, so I was looking into things and as usual got
side-tracked so here we are. Oleg, save me please.

IF_NOTIFY_SIGNAL is used to kick a task in uninterruptible sleep to
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

So here's some stuff that was considered but I think it not really
feasible:

(a) Check for task_is_coredumping(). That will end up forcing
    task_work_add() users to know about coredumps. This seems like a
    layering violation.

    I have a patch for this as well but it's ugly. It races with the
    dump staarting unless the bit setter takes a lock in the io_uring
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

Fix coredumps and smb. Fwiw, I think there's a few other potential users
of the helpers that are left out of this series.

|         |    notify_signal_pipe     |   notify_signal_socket    |
|---------|---------------------------|---------------------------|
| fix     | ok                        | ok                        |
|---------|---------------------------|---------------------------|
| unfixed | 357324 of ≥ 5111808 bytes | 467336 of ≥ 5111808 bytes |

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (4):
      signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL
      coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps
      selftests/coredump: test that TIF_NOTIFY_SIGNAL doesn't truncate a coredump
      smb: prevent TIF_NOTIFY_SIGNAL from interrupting

 fs/coredump.c                                      |   4 +
 fs/smb/client/transport.c                          |  13 +-
 include/linux/sched.h                              |   2 +-
 include/linux/sched/signal.h                       |  21 +-
 tools/testing/selftests/coredump/Makefile          |   7 +-
 .../selftests/coredump/coredump_notify_signal.h    |  29 ++
 .../coredump/coredump_notify_signal_helper.c       |  46 +++
 .../coredump/coredump_notify_signal_test.c         | 245 ++++++++++++++++
 tools/testing/selftests/coredump/coredump_test.h   |   1 +
 .../selftests/coredump/coredump_test_helpers.c     | 318 +++++++++++++++++++++
 10 files changed, 674 insertions(+), 12 deletions(-)
---
base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
change-id: 20260817-work-tif_notify_signal-6ab080d33693

