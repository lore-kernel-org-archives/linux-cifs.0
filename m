From: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Subject: Re: Data corruption problem
Date: Fri, 11 Feb 2011 08:35:20 -0600
Message-ID: <20110211143520.GI27051@solid-constructs.com>
References: <20110211051458.GD27051@solid-constructs.com>
 <20110211065318.62f91a5b@tlielax.poochiereds.net>
Reply-To: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110211065318.62f91a5b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Feb 11, 2011 at 06:53:18AM -0500, Jeff Layton wrote:
> On Thu, 10 Feb 2011 23:14:59 -0600
> Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org> wrote:
> 
> > First, I'm not certain whether this is samba, the linux cifs driver, or
> > something else.
> > 
> > He got me involved.  I found no useful messages (cifs, IO, kernel mem,
> > network, or samba) in any logs on client or server anywhere near the
> > times of the file creations.
> 
> Did the close() or fsync() call return an error?

No, Jeff.  Nothing in the logs and from the user space side there are
no errors.  All debug levels are at the system defaults.  After 12
attempts last night I've still not reproduced.  I will work with my QA
guy this morning (CST here) to see if we can reproduce.  What can I do
to gather the best data for you guys?

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
