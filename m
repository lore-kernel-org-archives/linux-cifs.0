From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Packet signing and sequence numbers
Date: Wed, 3 Apr 2013 07:26:58 -0400
Message-ID: <20130403072658.4123a066@tlielax.poochiereds.net>
References: <51536712.9060504@gmail.com>
	<20130327211115.1a09db9a@corrin.poochiereds.net>
	<CAH2r5mvz=U615HC_dNBsnRc8JYdJ7gEAQxQWa5JMS339z8x7MQ@mail.gmail.com>
	<5153B021.1010400@gmail.com>
	<20130328065234.60801d2f@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130328065234.60801d2f-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 28 Mar 2013 06:52:34 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Wed, 27 Mar 2013 22:51:13 -0400
> Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > On 03/27/2013 10:15 PM, Steve French wrote:
> > > On Wed, Mar 27, 2013 at 8:11 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > >>
> > >> On Wed, 27 Mar 2013 17:39:30 -0400
> > >> Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >>
> > >>> I notice the patch in this message
> > >>>
> > >>> http://thread.gmane.org/gmane.linux.kernel.cifs/7655/focus=7671
> > >>>
> > >>> Never made it into Linus's tree. It's also not in Debian or RedHat's
> > >>> kernels. I'm running into this on CentOS.
> > >>>
> > >>> Has there been any activity on this issue since December?
> > >>>
> > >>> Incidentally, I filed a bug report on bugs.redhat.com relating to what
> > >>> I'm hitting:
> > >>>
> > >>> https://bugzilla.redhat.com/show_bug.cgi?id=928516
> > >>>
> > >>
> > >> If you have a support contract with Red Hat, then it would be best to
> > >> open a support case, which will help make the case for its inclusion
> > >> into the RHEL kernel.
> > >>
> > >>> I'm looking for a good reason to (or to not) apply the patches to the
> > >>> current RH kernel on my systems; I rather need it for my current project.
> > >>>
> > >>> (I'd respond via the linux-cifs list, but Thunderbird is being a PITA
> > >>> and preventing me from subscribing to it via gmane's NNTP, through which
> > >>> I'd be able to reply to the thread directly...)
> > >>>
> > >>
> > >> You're correct that it never made it in. I think the patch makes
> > >> sense...Steve, was there some reason you didn't merge it?
> > >>
> > >> In the meantime, if you're able to test the patch and reply on-list
> > >> with the results then that would be helpful.
> > >>
> > >> Thanks,
> > >> --
> > >> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > 
> > > 
> > > 
> > > I don't remember getting any other test feedback on it - do we have
> > > some additional tested-by to add (or anyone else review it).  I didn't
> > > personally try it (I was traveling during the holiday break when it
> > > was discussed) and I didn't see it in Jeff's tree so I assumed that he
> > > found a problem with it.
> > > 
> 
> I think I thought you had merged it for 3.8 and dropped it. I never saw
> any problems with it. Let's get it in for 3.9.
> 


I think I was confused...

The main patch that I am concerned with was merged quite some time ago
in commit 31efee60f489c759c341. The other one needs more work before we
can merge it, I think.

That problem ought to be more rare though. Basically, you'd need to
have the task catch a signal before sending anything on the wire. I'll
see if I can clean that patch up later today and will send a draft of
it.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
