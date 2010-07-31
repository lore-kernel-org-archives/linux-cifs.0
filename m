From: utz lehmann <lkml123-4es5y7D8suKELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended file stats available [ver #6]
Date: Sat, 31 Jul 2010 16:43:53 +0200
Message-ID: <1280587433.3284.10.camel@segv.aura.of.mankind>
References: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>
	 <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	 <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	 <30448.1279800887@redhat.com> <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
	 <AANLkTikBCXK6uEw  <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
	 <1280524978.2452.9.camel@segv.aura.of.mankind>
	 <alpine.LSU.2.01.1007311006070.19122@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsde-kxMDh+IBDuj1P9xLtpHBDw@public.gmane.org
To: Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.01.1007311006070.19122-SHaQjdQMGhDmsUXKMKRlFA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2010-07-31 at 10:08 +0200, Jan Engelhardt wrote:
> >When abusing an existing time stamp use atime not ctime please.
> >ctime has it's uses. atime was just a mistake and is nearly useless.
> 
> MUAs make use of atime.

I know mutt uses atime to detect new messages. But there are better and
more reliable ways to do this.

> 
> >And with noatime we already have creation time semantics for atime.
> 
> noatime was a late afterthought, and because it can interfere with
> some programs, relatime came along too.

There are people who prefer noatime over relatime.

Using an existing time stamp for creation time is a bad idea IMHO. But
when doing this use the least important one. Which is atime. For example
ctime is used by backup programs.

Anyway when we want to support creation time it should be an additional
time stamp.


utz
