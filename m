Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BC43009C0;
	Wed, 13 Aug 2025 21:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755120990; cv=none; b=apNVs0OOBwHpZmfBxzULWs/Go3qyDCGUZ5dPSy9ohT/cYPcZhYXkM0fCa/+VC2b9oY0EghrjEV2R/uEgC0bdn79VRiOJdXNYAgxl4BZ+UwNjb8hzJB+s7YmwF/UzRuP8spdp/7Ro18uOXT9yWCI7rbYFHUX7jtDvTUegz7yZuEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755120990; c=relaxed/simple;
	bh=9u9qyTxq9GUUPmnwYgUQNZZCwOUsKzYOrD0587GjY/g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kI6wZPn8T2OgxbsVGLYLuWnuXYYkKdsC5/V2e0zEggy623tp+P8CN/nbLCuHKSCRDbVoNrExYC/Wz8WmJNIDMsHJwGUytXgT5y8L22vFjMxcMOmkIMfWZm1eNBODwVSAfpEL5jGfMGCQSP8ZsEpvcQEgOtV6uHYeYVyf3TJyIE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A7995904C;
	Wed, 13 Aug 2025 21:36:20 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 02EB220016;
	Wed, 13 Aug 2025 21:36:17 +0000 (UTC)
Date: Wed, 13 Aug 2025 17:37:05 -0400
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
Message-ID: <20250813173705.0e910f5a@gandalf.local.home>
In-Reply-To: <b1f38f6b-9d14-46cb-81f1-6bc5f92e7c65@samba.org>
References: <b1f38f6b-9d14-46cb-81f1-6bc5f92e7c65@samba.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uk761dayegjwyqr34btzqfdwzd8aw5p6
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 02EB220016
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+1v2gaf5LH2Ifw8qqncN7cYJdn6Jv67FE=
X-HE-Tag: 1755120977-516136
X-HE-Meta: U2FsdGVkX18zdVEfGRsuy3xDb89u1iK3GzR2p3nDviZ9Bdq2CyG6OnnA1TS6WZGRvOwm+xvnEvVPT6kADdLzfSUTbIe+RRB1e7iKSwES2tARP1T4eMkyxlr9Xsj4BDew1IokwJVAX3o5oW2Jhw9F7EuFrfKxI+oyfcFENdcKD7ATCpH5JuWSFK/7Co1U5cIk0r94DSIkVIKbML9vjODIVFfRzAKjd6N3Fn4mVkLUXO7whKwBLNBe3KNCiGUker9Voez2MInjtciREEc2NABWx7Pu43iDfxY5Pg6tKNYyD10IWedYKvR51Wk8lN14bQH066sbDWhbFPf0iM4qDe3VJIl9wZ2kQQc6l4vPtWfiht46V1KTijHEV1e3TM/4ur1K

On Wed, 13 Aug 2025 22:28:08 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> I guess I understand the difference between
> wait_event() and wait_event_interruptible(),
> the first ignores any signal even kill and the
> 2nd returns -ERESTARTSYS on any signal.

The main difference is what the code does after the wait_event*().

If you use wait_event_interruptible() the first thing the code should do is
to check if a signal is pending or not. Or at least check some status to
know that what it is waiting for did not happen and handle it properly.

But there's places in the kernel where the task is waiting for something
and it expects that whatever it is waiting for *must* happen eventually and
it should not continue until it does.

Looking at one example: fs/jbd2/journal.c: jbd2_journal_start_thread()

It creates a thread, tests that it is created, and then waits for that
thread to acknowledge that it is running, and the function should not
return until it does.

If someone were to send a signal to that waiter and wake it up prematurely,
the following code may become buggy as it expects the thread to be
initialized and active when it is not.

-- Steve
