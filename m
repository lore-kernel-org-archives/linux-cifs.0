From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: Use systemd's mechanism for getting
 password, if present
Date: Fri, 20 Jul 2012 14:51:31 -0400
Message-ID: <20120720145131.0c846040@tlielax.poochiereds.net>
References: <4FE43C1F.8060605@suse.com>
	<20120625152439.1a68fb6f@tlielax.poochiereds.net>
	<4FE95EFA.4030809@suse.com>
	<20120626042835.0a20e3f3@corrin.poochiereds.net>
	<50056F71.9010509@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ankit Jain <jankit-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50056F71.9010509-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 17 Jul 2012 19:28:09 +0530
Ankit Jain <jankit-IBi9RG/b67k@public.gmane.org> wrote:

> Hi Jeff,
> 
> On 06/26/2012 04:58 PM, Jeff Layton wrote:
> [snip]
> > It does, but we do have to concern ourselves with older versions of
> > systemd that might not, and with distros that might use systemd but not
> > add the tool (consider embedded distros). I think we'll need a
> > mechanism to fall back to the legacy password mechanism.
> 
> I'm guessing that by "legacy" you mean get_pass(..)? But on a regular
> systemd install, it takes over stdin/stdout, and the prompt won't come
> up on a terminal. But I don't know how it is set up on the other
> scenarios you mentioned. So, I'll do that but you will have to test it
> ;) I tried using /dev/tty, but in/out are redirected AFAIU, so, this
> didn't help.
> 
> > Also, a way to disable this at compile-time would nice. Maybe a
> > --enable-systemd autoconf option would be good that defaults to "on"
> > with a simple test to see if the build machine is running systemd?
> 
> Sure, autoconf option sounds good. But do we want to check for systemd
> running on the *build* machine (and choose default value for
> --enable-systemd accordingly)? Systemd running or not sounds like a
> runtime behavior, and we fall back to getpass anyway. I haven't added
> this in the attached patch, but if you feel that this makes sense, then
> I can add it.
> 
> Regards,

Merged...

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
