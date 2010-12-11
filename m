From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/6] CIFS: Make read call work with strict cache mode (try #4)
Date: Sat, 11 Dec 2010 22:47:42 +0300
Message-ID: <AANLkTikrDA_NnK_unas1FABStcre2MPCbV0iJoV2HcYG@mail.gmail.com>
References: <1291103671-2983-1-git-send-email-piastryyy@gmail.com>
	<20101207072610.50c5810a@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101207072610.50c5810a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/7 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> Hmmm...that looks a little ugly. There is no batching here, so if the
> application sends you an array of very small iovecs, then that becomes
> a set of very small reads on the wire. I don't think that's what you
> want.

Jeff, I investigated this a little and found out a problem with
mandatory byte-range locks:

For example, the first user locks file from 11 to 12, the second user
specifies two buffers with 10 and 20 lengths and wants to fill them
with readv call. In your case we merge these buffers into one request,
sends it and got error. As the result we don't have any data returned
from the server. So the second user thinks that the file is locked on
both regions (from 0 to 10 and from 10 to 30) but it is not true!
Almost the same things we can see in write case. So, what's why I
think we shouldn't do it in strict cache case.

Thoughts?

-- 
Best regards,
Pavel Shilovsky.
