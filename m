From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 5/6] CIFS: Do not permit write to a range mandatory
 locked with a read lock
Date: Mon, 3 Dec 2012 19:20:44 +0400
Message-ID: <CAKywueQ9VB+znaGcQ+ZEC5KQy+jwgs4OABFmUnwcBx2EO7r8sA@mail.gmail.com>
References: <1354112625-30315-1-git-send-email-piastry@etersoft.ru>
	<1354112625-30315-6-git-send-email-piastry@etersoft.ru>
	<20121130135721.5fef027b@tlielax.poochiereds.net>
	<CAKywueRtuz=pHWoa7fRkwyrOPsuOSS8MO7rhqVzKtd0SXVRfYQ@mail.gmail.com>
	<CAH2r5mut7i4g5qtrt3chf_nO6PEQoHYecoqKpkfwS7cPAaMkFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mut7i4g5qtrt3chf_nO6PEQoHYecoqKpkfwS7cPAaMkFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/12/3 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Just to doublecheck semantics ... posix applications (on the Linux
> kernel client) want to always allow a write where possible - if Wine
> issues a mandatory lock on a cached file do we want it to apply to
> posix applications or just applications like Wine?  Is the only way we
> can tell the difference the mount option you suggested?
>

This change is not targeted to fix Wine-specific behavior. If we
negotiate mandatory locking we need to be sure the server and client
are the same: the server denied writes to the range locked with read
lock - we should do the same things on the client to make the behavior
not depend on the kind of oplock we have now.

As for wine mount option: now, when we have rwpidforward and forcemand
mount options, I don't think we need it because all that it should do
is rwpidforward + forcemand + strictcache.

-- 
Best regards,
Pavel Shilovsky.
