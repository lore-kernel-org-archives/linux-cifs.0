From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Packet signing and sequence numbers
Date: Wed, 27 Mar 2013 21:11:15 -0400
Message-ID: <20130327211115.1a09db9a@corrin.poochiereds.net>
References: <51536712.9060504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51536712.9060504-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 27 Mar 2013 17:39:30 -0400
Michael Mol <mikemol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I notice the patch in this message
> 
> http://thread.gmane.org/gmane.linux.kernel.cifs/7655/focus=7671
> 
> Never made it into Linus's tree. It's also not in Debian or RedHat's
> kernels. I'm running into this on CentOS.
> 
> Has there been any activity on this issue since December?
> 
> Incidentally, I filed a bug report on bugs.redhat.com relating to what
> I'm hitting:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=928516
> 

If you have a support contract with Red Hat, then it would be best to
open a support case, which will help make the case for its inclusion
into the RHEL kernel.

> I'm looking for a good reason to (or to not) apply the patches to the
> current RH kernel on my systems; I rather need it for my current project.
> 
> (I'd respond via the linux-cifs list, but Thunderbird is being a PITA
> and preventing me from subscribing to it via gmane's NNTP, through which
> I'd be able to reply to the thread directly...)
>

You're correct that it never made it in. I think the patch makes
sense...Steve, was there some reason you didn't merge it?

In the meantime, if you're able to test the patch and reply on-list
with the results then that would be helpful.

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
