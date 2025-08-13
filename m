Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42372D0C84;
	Wed, 13 Aug 2025 20:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755116902; cv=none; b=lVIo1lx9dE4kjvMJKGIQFGaGDLgRU7jzD5FKmV9e5BT67K1UpI/sZ21p/bRDs5FZsI8OHtiLIzIxYbSLfiqLIdcIWWfEmq3J/mAZlPHJpOPGteb1QSU7Zk27TF0gRC729UkA69FYFKByYMPl6Mwnq0PTix2hqitDyOXzQg85jqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755116902; c=relaxed/simple;
	bh=UI9uzxcFhZdDRGpVbBU0kvP0r2sAv8wlZufwUb+jYI8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=P66UGFmY9qsbx9BmSDGilNhRB9l34LuWni7ArWcKDJs5hgAF1zn1lJmz03q5smKQKsYSxIurQTlVvlf18TLzSaimRd6ULc9OdW7sTmkOJeEob83pItsbNJIyvZHofUhYc8ObtFViNaAvSHkGW7KNcJlVjWFsQ4FJT/EdERfWZVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=NZz9E+kK; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="NZz9E+kK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=UI9uzxcFhZdDRGpVbBU0kvP0r2sAv8wlZufwUb+jYI8=; b=NZz9E+kKJOmSESWw4GScW5SG31
	AacnsXhvMbl1PhNWB/7IA83jTX/5dcuo4kK24+59InRND6N8yVbdMZC4qTAU6ylfwIDxW3Mv3b8oJ
	zHb12bE0Y9x7cBpe5lNbj8NnrPkCLkGp/RfWx3JKV+OjV6kPN7cvEl3VMYeh1hP4LtAhaUsJ9YdeS
	mk1Q867zmvZjriEXF+tGEWWIGfCrTDdatDazZ7UNWv48rNnG0Gg5d6uZzy/n70eiLR/f4I5yh2yl6
	Y7WeHPOvDcBbPlGxaXy94fYgEDvDo+GTA8ZMX0LyilJuTE9Sj+9hVz887J2oXSXSXzEiY5wkFMSws
	yrHFYDiuTsoKPFA/2QNrcOmoFmm9MLFjcEYnylV7NOSWI5Ef0cg29YFHLkgQvHeUm8GbvqWJTLYtg
	rco3FBImGZM1at10ZIqbEgls9BPJBcWXgTDoZbta6cvBAjlRqyCTnntO8tPFTIgFzZ6INtLaRV+rK
	ZX97nGq82h8IgLiNh+Jdi3IS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1umI4v-002gKU-2K;
	Wed, 13 Aug 2025 20:28:09 +0000
Message-ID: <b1f38f6b-9d14-46cb-81f1-6bc5f92e7c65@samba.org>
Date: Wed, 13 Aug 2025 22:28:08 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
Subject: Questions about wake_up[_interruptible][_all]
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

there are several cases where wait queues are used in:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/smb/client/smbdirect.c
and
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/smb/server/transport_rdma.c

I'm a bit confused because we the use mixed use of
wake_up(), wake_up_interruptible() and wake_up_interruptible_all()

On the wait side the following are used
wait_event(), wait_event_interruptible() and wait_event_interruptible_timeout()

The documentation of all wait_event_* macros say 'wake_up()' should be used.
And there's no documentation on the various wake_up_* macros.

I guess I understand the difference between
wait_event() and wait_event_interruptible(),
the first ignores any signal even kill and the
2nd returns -ERESTARTSYS on any signal.

I'm wondering if using wait_event_killable() should
be preferred instead of wait_event() in order to prevent
processes in state D hanging forever.

For some wait queues it would be desired that only
a single waiter is woken, so it can make good forward progress,
so maybe some wait_event_*_exclusive() would be useful for this.

As far as I understand the difference between
wake_up() and wake_up_all() is that the first
stops after the first waiter with WQ_FLAG_EXCLUSIVE.
and wake_up_all() wakes all waiters (useful for error conditions,
which all waiters should handle immediately.

But I don't understand the difference between
wake_up() and wake_up_interruptible().
My best guess would be that wake_up_interruptible()
would not wake waiters using wait_event(), but only
waiters using wait_event_interruptible() or any other
version that includes TASK_INTERRUPTIBLE.

So I guess we never want to use wake_up_interruptible(),
but always wake_up() or wake_up_all() instead...

It would be great if the documentation of
the wake_up macros and their interaction with
the wait_event macros could be improved.

Any hints are highly welcome :-)

Thanks!
metze
