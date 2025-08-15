Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224E417B425;
	Fri, 15 Aug 2025 02:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755226051; cv=none; b=du0ADfFA1y31qJ8joJno1DrMxZyIJ9ZYjPZdlcmT2COBsZa4MfWbx7HH4spJMwZQX4WtS33/GejqvX5t6RuEUGpuDxdKgPBgg29+GZjOe5Xs7XshX0dpvXhMAVrw6jVRqG6ebyrtfipLAoZHrpdYrvdTo8iHako6NgDEVCAsLPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755226051; c=relaxed/simple;
	bh=gCxvoSncoAMm5cb9dzgd7qhiA0eQqS5E6UWE1gIlj9c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E6TswCWYakqgroS3jaiGPQE4/oCPc2vn/i9Kx1GOrp0mubOvI3fgzl9MKhA2VlZoZte7JJnvaw+dn1yEjaHM8gQ1ht7nHgEij/wQoNFH3p/NoEWeTGepDhdGxeCoIA7c6ppvSgLvaR1giFHjgBiz3eIHAfyv5j4ZxprPfIzzl8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C10D138A54;
	Fri, 15 Aug 2025 02:47:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id BC96920028;
	Fri, 15 Aug 2025 02:47:18 +0000 (UTC)
Date: Thu, 14 Aug 2025 22:47:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Steve French
 <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Questions about wake_up[_interruptible][_all]
Message-ID: <20250814224717.192b625d@batman.local.home>
In-Reply-To: <13851363-0dc9-465c-9ced-3ede4904eef0@samba.org>
References: <b1f38f6b-9d14-46cb-81f1-6bc5f92e7c65@samba.org>
	<20250813173705.0e910f5a@gandalf.local.home>
	<13851363-0dc9-465c-9ced-3ede4904eef0@samba.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BC96920028
X-Stat-Signature: d7j3jhht8x7kzuug1ayaokbqreb8xzst
X-Rspamd-Server: rspamout02
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+kB/E05ewgxoOfBc2Q59evmuhbOc9V8vo=
X-HE-Tag: 1755226038-949633
X-HE-Meta: U2FsdGVkX18ER/X4Pycl7WxqoZbrV4JlFQQpekn0pgKoGJ8nythpJW7r01fUx4nteqr4HyBNn+zsYbeUyNVLpDHw09jfr823H0eeYWFPo09Y1nxdFT1jqog5vReGyYz5Fw095wv5miSQ2aDW17/iAXj+GDahu7XH96A/O5gVT//yXInyhRcLU06BWIq/LLEOo/6cm74EHPObysU6cHdhgJXH0ppzRw4BNOvB+VTwOHeh/Z49K3EZ7EESwB7BUQzimN1Nmoe2FVdAeaNivcXhe59Im7e/2GcBQl3GdnuRkmar5H4bJJUzAH+f+kci+GT+Ydsc3SMdk0BpIvDBUrFM9AsyhwwE+fxCpNk90K5hWOtCOx+XEO/W8rac1Dsrep9q

On Thu, 14 Aug 2025 09:57:14 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> Am 13.08.25 um 23:37 schrieb Steven Rostedt:
> > On Wed, 13 Aug 2025 22:28:08 +0200
> > Stefan Metzmacher <metze@samba.org> wrote:
> >   
> >> I guess I understand the difference between
> >> wait_event() and wait_event_interruptible(),
> >> the first ignores any signal even kill and the
> >> 2nd returns -ERESTARTSYS on any signal.  
> > 
> > The main difference is what the code does after the wait_event*().
> > 
> > If you use wait_event_interruptible() the first thing the code should do is
> > to check if a signal is pending or not. Or at least check some status to
> > know that what it is waiting for did not happen and handle it properly.
> > 
> > But there's places in the kernel where the task is waiting for something
> > and it expects that whatever it is waiting for *must* happen eventually and
> > it should not continue until it does.
> > 
> > Looking at one example: fs/jbd2/journal.c: jbd2_journal_start_thread()
> > 
> > It creates a thread, tests that it is created, and then waits for that
> > thread to acknowledge that it is running, and the function should not
> > return until it does.
> > 
> > If someone were to send a signal to that waiter and wake it up prematurely,
> > the following code may become buggy as it expects the thread to be
> > initialized and active when it is not.  
> 
> Thanks!
> 
> Via a private channel I also got this answer:
> 
> wake_up_interruptible() only wakes tasks that are in the
> TASK_INTERRUPTIBLE state.
> 
> wake_up() wakes tasks that are in either the TASK_INTERRUPTIBLE or
> TASK_UNINTERRUPTIBLE state, as per the TASK_NORMAL macro used in the
> definition of wake_up().
> 
> Call chain:
> 
> wake_up_interruptible
>    __wake_up(mode = TASK_INTERRUPTIBLE)
>      __wake_up_common_lock(mode = TASK_INTERRUPTIBLE)
>        __wake_up_common(mode = TASK_INTERRUPTIBLE)
>          curr->func(mode = TASK_INTERRUPTIBLE)
>            // curr->func is usually default_wake_function
>            default_wake_function(mode = TASK_INTERRUPTIBLE)
>              try_to_wake_up(state = TASK_INTERRUPTIBLE)
>                ttwu_state_match(state = TASK_INTERRUPTIBLE)
>                  __task_state_match(state = TASK_INTERRUPTIBLE):
>                  if (READ_ONCE(p->__state) & state) ...
> 

That's a differentiation in implementation, but I thought your question
was more about what the differentiation in the purpose of the two.

-- Steve
