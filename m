From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: remove support for "complex" usernames from
 mount.cifs
Date: Thu, 3 Jan 2013 14:21:10 -0500
Message-ID: <20130103142110.269ea0d1@tlielax.poochiereds.net>
References: <1357214055-24911-1-git-send-email-jlayton@samba.org>
	<CAFB9KM0-BrPcjV8gTW9BV_Awiw5bHbgYr=42smTJWKxCr=Y-PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM0-BrPcjV8gTW9BV_Awiw5bHbgYr=42smTJWKxCr=Y-PA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 3 Jan 2013 10:10:38 -0500
Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Jan 3, 2013 at 6:54 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >
> > In commit 569cfcb3a, we added a warning of the removal for support for
> > username= options in the form of DOMAIN/username%password. This patch
> > removes that support as promised prior to the 5.9 release.
> 
> 
> That makes the code so much cleaner. :)  Next up for 6.0, removing NFS syntax.
> 

It does. That said, I'm not opposed to dropping this patch if
someone can outline a compelling use-case for this syntax. I don't see
how this makes anything easier vs. using discrete mount options, but
I'm willing to reconsider it if there is such a case.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
