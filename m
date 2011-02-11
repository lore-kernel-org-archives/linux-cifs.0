From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Data corruption problem
Date: Fri, 11 Feb 2011 09:41:17 -0500
Message-ID: <20110211094117.1f012cae@tlielax.poochiereds.net>
References: <20110211051458.GD27051@solid-constructs.com>
	<20110211065318.62f91a5b@tlielax.poochiereds.net>
	<20110211143520.GI27051@solid-constructs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110211143520.GI27051-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 11 Feb 2011 08:35:20 -0600
Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org> wrote:

> On Fri, Feb 11, 2011 at 06:53:18AM -0500, Jeff Layton wrote:
> > On Thu, 10 Feb 2011 23:14:59 -0600
> > Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org> wrote:
> > 
> > > First, I'm not certain whether this is samba, the linux cifs driver, or
> > > something else.
> > > 
> > > He got me involved.  I found no useful messages (cifs, IO, kernel mem,
> > > network, or samba) in any logs on client or server anywhere near the
> > > times of the file creations.
> > 
> > Did the close() or fsync() call return an error?
> 
> No, Jeff.  Nothing in the logs and from the user space side there are
> no errors.  All debug levels are at the system defaults.  After 12
> attempts last night I've still not reproduced.  I will work with my QA
> guy this morning (CST here) to see if we can reproduce.  What can I do
> to gather the best data for you guys?
> 

To be clear...are you sure that the close(2) or fsync(2) syscalls did
not return an error? It's a common bug for programs to ignore the return
code from close(2), and that's where errors during writeback get
reported.

The reason I ask is that there were some issues that were fixed
recently in mainline with cifs writeback. The CIFS code treated
timeouts during writeback as hard errors instead of retrying them, but
in those cases the client should have returned an error during fsync or
close.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
