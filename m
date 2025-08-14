Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EC6192D97;
	Thu, 14 Aug 2025 07:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755158242; cv=none; b=hV/trG4Ko792k12LjTvI3rOnZcVfVI5RErenlRy8cupUzv/+paDIpv0zn4k2BUTWVV6CCL8u/dSX+s8x/Vg8FcFeLR4WkXpouWSrSJoKMPoFR5tXbhkYFjL2a3WJfN6kVNofmnE4wyZZB4SZAOlmJHq/2+VGw/+ADkaYQ7p5ONc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755158242; c=relaxed/simple;
	bh=VekpqMLi48GUYY4bLiDbE+i3ElROjozSHOOjAEFio5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YybOOA7DS+SUiRTBlE+YkEnH36ouh2UV83HP+HDVfrkRTmm+azE2huZhIuzH5hXrfYj3D4uAGzJMzRGtA1OuZerwOTb0uE15voiVlsQH0JQgUHMc3GMcOUh+NhWAsbwR7QbpfjQKeW8uA/7bbNfN86bI0AiBkdw5Kicq6qwcAUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YeulsA8i; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YeulsA8i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=PuRAswinh8/urW4wKOa4oa4QJd6JJHdsLCEMtXyb01g=; b=YeulsA8iWFwtMY+RLybhCg50Rs
	rTvAVyJR3J6VQ+ZN9vN47IGuPuPSjApETGvOiT4Wd/bKke4qbdyNltsxmjiepNnya8u5t1Mum3w+b
	1A+sIzQUDf6U36+Ar5O5/rqcwrsZ/T8Rz3BA/WV44ZhfdW1K+fwOMoILcwrZmdXfBQ4y0zqbzdHj5
	8c4dsoc25RoEeZOpuIl8w3ZeT6urG35x8YQMZpvs/gVa0pZDXjFaNgB/mbPfBIWC1DNP+LkPm9HMB
	tRIRJPxidKQ3zSa739ufOVDpwy25giezyvlIBBOpuZK5bOee0rR+ihaJkWYHHg/cC8CIEhuAKnuv2
	G22N7MvPG5Sc2tBJpE2fqzyFejysnZ1PpBMlkDidVb85rKaL/ylEPvxHDgo3kzFx/AprRpE+aFDaL
	E3rr+aFDrLehHkrBUGM+sspa3DSwwHhM714NdDUT1Gl2ooWu5OAnuONQ2BIMGD7NSM58dW5PapLYy
	JIh35PIRjC72qanao7RpgOYF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1umSpm-002mFC-1u;
	Thu, 14 Aug 2025 07:57:14 +0000
Message-ID: <13851363-0dc9-465c-9ced-3ede4904eef0@samba.org>
Date: Thu, 14 Aug 2025 09:57:14 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Questions about wake_up[_interruptible][_all]
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <b1f38f6b-9d14-46cb-81f1-6bc5f92e7c65@samba.org>
 <20250813173705.0e910f5a@gandalf.local.home>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20250813173705.0e910f5a@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 13.08.25 um 23:37 schrieb Steven Rostedt:
> On Wed, 13 Aug 2025 22:28:08 +0200
> Stefan Metzmacher <metze@samba.org> wrote:
> 
>> I guess I understand the difference between
>> wait_event() and wait_event_interruptible(),
>> the first ignores any signal even kill and the
>> 2nd returns -ERESTARTSYS on any signal.
> 
> The main difference is what the code does after the wait_event*().
> 
> If you use wait_event_interruptible() the first thing the code should do is
> to check if a signal is pending or not. Or at least check some status to
> know that what it is waiting for did not happen and handle it properly.
> 
> But there's places in the kernel where the task is waiting for something
> and it expects that whatever it is waiting for *must* happen eventually and
> it should not continue until it does.
> 
> Looking at one example: fs/jbd2/journal.c: jbd2_journal_start_thread()
> 
> It creates a thread, tests that it is created, and then waits for that
> thread to acknowledge that it is running, and the function should not
> return until it does.
> 
> If someone were to send a signal to that waiter and wake it up prematurely,
> the following code may become buggy as it expects the thread to be
> initialized and active when it is not.

Thanks!

Via a private channel I also got this answer:

wake_up_interruptible() only wakes tasks that are in the
TASK_INTERRUPTIBLE state.

wake_up() wakes tasks that are in either the TASK_INTERRUPTIBLE or
TASK_UNINTERRUPTIBLE state, as per the TASK_NORMAL macro used in the
definition of wake_up().

Call chain:

wake_up_interruptible
   __wake_up(mode = TASK_INTERRUPTIBLE)
     __wake_up_common_lock(mode = TASK_INTERRUPTIBLE)
       __wake_up_common(mode = TASK_INTERRUPTIBLE)
         curr->func(mode = TASK_INTERRUPTIBLE)
           // curr->func is usually default_wake_function
           default_wake_function(mode = TASK_INTERRUPTIBLE)
             try_to_wake_up(state = TASK_INTERRUPTIBLE)
               ttwu_state_match(state = TASK_INTERRUPTIBLE)
                 __task_state_match(state = TASK_INTERRUPTIBLE):
                 if (READ_ONCE(p->__state) & state) ...

metze
