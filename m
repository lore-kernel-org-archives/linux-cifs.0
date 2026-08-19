Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C04A3101B2
	for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 12:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787143835; cv=none; b=ZTVN40XTk1NjaQ143BSISaGcOnVg64+Q+Bh/xokEQRSuoxftjvnGROj9ZbRYCZz2B9cAcRzI5x8v9ni8ieX/9LMLC7DM8ulmsWrfkrsxJvaY+R7FCsk/YBbaE2HjG9JqCqyqAzw+OLlEWq2shm6LO5bFUzzr2bShvjuti54NcIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787143835; c=relaxed/simple;
	bh=vfppvCG/qvbrNitjequc3qq46dLMqTHjUV4R5KJVO7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MmC7XSHI1Ry28w77BALcw27qbcyI2YO5FmoCdamUf6K8mH5eKRrOS0tyme1tf75k71kcvlKozDR08Mac7UQ969C3TPptf5+37jgcgkf2dauCx7ZBkXf7LXYZlN+4CZXWrK/lLH4WOaC2PUkBRvfK7JxAdpotI0oQ8PlNFzjsp6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WVoVn3pQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WVoVn3pQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787143831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+KudDx4GWA6m0kymTqV9B5+pPC4d5wMXWeaLZi91N90=;
	b=WVoVn3pQZT4ckT9uj8kHO+a00+NS4ANKdXhr0BPgcRXqep8ettJ/A8MFIlvTwXq0ozBzrq
	su0J9bz1fRLy4IU+ooJfSlPCcudteInHCU2bJN8oP9pTOK8bXR5a98f4GW9au9HrwTTdFJ
	+wm/yvRcMTD5pzBDmnNuy/c51qo4n6o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-INSEtobNO6C9huKBqR73aQ-1; Wed,
 19 Aug 2026 08:50:25 -0400
X-MC-Unique: INSEtobNO6C9huKBqR73aQ-1
X-Mimecast-MFC-AGG-ID: INSEtobNO6C9huKBqR73aQ_1787143824
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D55061955DBE;
	Wed, 19 Aug 2026 12:50:22 +0000 (UTC)
Received: from fedora (unknown [10.44.33.127])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id A33BE180034F;
	Wed, 19 Aug 2026 12:50:17 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 19 Aug 2026 14:50:22 +0200 (CEST)
Date: Wed, 19 Aug 2026 14:50:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org,
	bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/4] Stop TIF_NOTIFY_SIGNAL from interrupting work that
 can't be restarted
Message-ID: <aoWmiL2Ea6YalTiy@redhat.com>
References: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi Christian,

I am still travelling without my work laptop, can't read the code.
I'll try to take a look on Friday.

IIRC, zap_pid_ns() can use the new helper too...

Oleg.

On 08/18, Christian Brauner wrote:
>
> Ok, so I was looking into things and as usual got
> side-tracked so here we are. Oleg, save me please.
> 
> IF_NOTIFY_SIGNAL is used to kick a task in uninterruptible sleep to
> return to userspace and run task work and then go back to sleep. This
> mechanism works well but breaks coredumps. dump_interrupted() only
> allows fatal signals to interrupt a coredump and the whole regular write
> path going to actual filesystems is impervious to TIF_NOTIFY_SIGNAL as
> well.
> 
> The core is that you can have quite deep callchains that end up calling
> signal_pending() in both the pipe and the socket codepaths so it's like
> we can just pass a flag through somehow.
> 
> For coredumps its very annoying because it means io_uring is - depending
> on how much outstanding work you have - incompatible with generating
> non-truncated coredumps. A process with too many file backed mappings
> and io_uring requests in flight ends up losing most of the coredump.
> 
> While zap_threads() has cleared TIF_SIGPENDING for a long time, just
> clearing TIF_NOTIFY_SIGNAL isn't going to work because the next
> completion will just set it again.
> 
> The fun part also is that io_uring isn't actually the only case:
> 
> (1) io_uring
> 
> (2) klp_send_signals()
> 
> (3) bpf_task_work_schedule_signal()
> 
> (4) landlock's tsync
> 
> And technically, kthread_stop() and the printk kunit test set the bit
> raw. So no simple way of just fixing this in one subsystem.
> 
> So, a fix for this issue has the following constraints:
> 
> (i) The places where a write is aborted are deep callchains that we
>     can't reasonably parameterize. For example, anon_pipe_write(),
>     unix_stream_sendmsg(), unix_stream_read_generic(),
>     sk_stream_wait_memory(), or a bare wait_event_interruptible() in
>     wait_for_dump_helpers(). All of them are shared with regular
>     syscalls that must stay interruptible.
> 
>     IOW, the state has to be per-task and ambient.
> 
>     An LLM would call this "load bearing"...
> 
> (ii) There are multiple ways TIF_NOTIFY_SIGNAL can get raised and they
>      can get set from irq context against any task. As said above we
>      have at least io_uring paths (poll task_work, msg_ring, tctx exit,
>      io-wq via __set_notify_signal()), bpf_task_work_schedule_signal(),
>      klp_send_signals(), landlock tsync, plus kthread_stop() and the
>      printk kunit stuff that set the bit raw.
> 
>      So fixing this up in the individual subsystems is doomed to fail or
>      require constant audits in case some new variant shows up.
> 
> (iii) The coredump task is exiting and can't restart the work.
> 
> So here's some stuff that was considered but I think it not really
> feasible:
> 
> (a) Check for task_is_coredumping(). That will end up forcing
>     task_work_add() users to know about coredumps. This seems like a
>     layering violation.
> 
>     I have a patch for this as well but it's ugly. It races with the
>     dump staarting unless the bit setter takes a lock in the io_uring
>     completion. I know someone that will disagree with this approach. ;)
> 
> (b) Oleg's old suggestion iirc. Just clear the bit at coredump entry.
>     That doesn't work because io_uring poll completions just raise it
>     again from irq context. So you also need synchronization with the
>     setter of which there are quite a few.
> 
> (c) Let the setting task defer setting the bit if the task is flagged
>     and then raise it again at exit.
> 
> (d) Take TIF_NOTIFY_SIGNAL out of singal_pending() and make it opt-in at
>     specific points. That breaks io_uring quite badly and forces a
>     tree-wide audit.
> 
> So the amount of patches for this issue over the years is impressive. So
> let me add one to the pile for the lolz.
> 
> Add PF_NO_NOTIFY_SIGNAL and helpers to raise/restore it. This is the
> same approach as memalloc_nofs_save(). signal_pending() will not report
> a fake pending signal via TIF_NOTIFY_SIGNAL if inside a
> PF_NO_NOTIFY_SIGNAL critical section. Obviously you can't
> fork()/clone3() in such a section.
> 
> Fix coredumps and smb. Fwiw, I think there's a few other potential users
> of the helpers that are left out of this series.
> 
> |         |    notify_signal_pipe     |   notify_signal_socket    |
> |---------|---------------------------|---------------------------|
> | fix     | ok                        | ok                        |
> |---------|---------------------------|---------------------------|
> | unfixed | 357324 of ≥ 5111808 bytes | 467336 of ≥ 5111808 bytes |
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> Christian Brauner (4):
>       signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL
>       coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps
>       selftests/coredump: test that TIF_NOTIFY_SIGNAL doesn't truncate a coredump
>       smb: prevent TIF_NOTIFY_SIGNAL from interrupting
> 
>  fs/coredump.c                                      |   4 +
>  fs/smb/client/transport.c                          |  13 +-
>  include/linux/sched.h                              |   2 +-
>  include/linux/sched/signal.h                       |  21 +-
>  tools/testing/selftests/coredump/Makefile          |   7 +-
>  .../selftests/coredump/coredump_notify_signal.h    |  29 ++
>  .../coredump/coredump_notify_signal_helper.c       |  46 +++
>  .../coredump/coredump_notify_signal_test.c         | 245 ++++++++++++++++
>  tools/testing/selftests/coredump/coredump_test.h   |   1 +
>  .../selftests/coredump/coredump_test_helpers.c     | 318 +++++++++++++++++++++
>  10 files changed, 674 insertions(+), 12 deletions(-)
> ---
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
> change-id: 20260817-work-tif_notify_signal-6ab080d33693
> 

