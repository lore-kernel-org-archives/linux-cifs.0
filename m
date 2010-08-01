From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended  file stats available [ver #6]
Date: Sun, 1 Aug 2010 09:25:29 -0400
Message-ID: <20100801092529.5e6ba0e0@corrin.poochiereds.net>
References: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>
	<20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	<20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	<30448.1279800887@redhat.com>
	<E1Obuiy-00C9jr-Al@intern.SerNet.DE>
	<AANLkTikBCXK6uEw  <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
	<1280524978.2452.9.camel@segv.aura.of.mankind>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsde-kxMDh+IBDuj1P9xLtpHBDw@public.gmane.org
To: utz lehmann <lkml123-4es5y7D8suKELgA04lAiVw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280524978.2452.9.camel-mrvVnycP54q9CgvvYfeeSAlEImK53Lvc@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 30 Jul 2010 23:22:58 +0200
utz lehmann <lkml123-4es5y7D8suKELgA04lAiVw@public.gmane.org> wrote:

> On Thu, 2010-07-22 at 09:40 -0700, Linus Torvalds wrote:
> > But the fact is, th Unix ctime semantics are insane and largely
> > useless. There's a damn good reason almost nobody uses ctime under
> > unix.
> > 
> > So what I'm suggesting is that we have a flag - either per-process or
> > per-mount - that just says "use windows semantics for ctime".
> 
> When abusing an existing time stamp use atime not ctime please.
> ctime has it's uses. atime was just a mistake and is nearly useless.
> 
> And with noatime we already have creation time semantics for atime.
> 

Ugh. Honestly all of this talk of abusing different time fields seems
like craziness to me. It's going to be very hard to do that without
breaking *something*. There's also very little reason to do this when
xattrs are a much cleaner approach.

Neil Brown has put forth a very reasoned justification for putting the
birthtime in an xattr. After reading it, I think that makes more sense
than anything. It's also something that can be done without any extra
infrastructure. If at some point in the future we get an xstat-like
syscall then we can always add birthtime to that as well.

Ditto for the other fields under discussion (i_generation and the like).

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
