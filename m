From: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Subject: Re: UNS: Re: Data corruption problem
Date: Fri, 11 Feb 2011 09:00:51 -0600
Message-ID: <20110211150051.GL27051@solid-constructs.com>
References: <20110211051458.GD27051@solid-constructs.com>
 <20110211065318.62f91a5b@tlielax.poochiereds.net>
 <20110211143520.GI27051@solid-constructs.com>
 <20110211094117.1f012cae@tlielax.poochiereds.net>
Reply-To: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110211094117.1f012cae-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Feb 11, 2011 at 09:41:17AM -0500, Jeff Layton wrote:
> > No, Jeff.  Nothing in the logs and from the user space side there are
> > no errors.  All debug levels are at the system defaults.  After 12
> > attempts last night I've still not reproduced.  I will work with my QA
> > guy this morning (CST here) to see if we can reproduce.  What can I do
> > to gather the best data for you guys?
> > 
> 
> To be clear...are you sure that the close(2) or fsync(2) syscalls did
> not return an error? It's a common bug for programs to ignore the return
> code from close(2), and that's where errors during writeback get
> reported.

Gotcha, I will grab a java dev and code review the test app.  My java-fu
is weak, but I think java will throw an exception on either failure,
just have to make sure some dev didn't put in a wide open catch.

> The reason I ask is that there were some issues that were fixed
> recently in mainline with cifs writeback. The CIFS code treated
> timeouts during writeback as hard errors instead of retrying them, but
> in those cases the client should have returned an error during fsync or
> close.

Good to know.  Thank you.

-- 

Wayne Walker
wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org
(512) 633-8076
Senior Consultant
Solid Constructs, LLC

> A: Because it messes up the order in which people normally read text.
> > Q: Why is top-posting such a bad thing?
> > > A: Top-posting.
> > > > Q: What is the most annoying thing in e-mail?
