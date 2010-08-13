From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended file stats available [ver #6]
Date: Fri, 13 Aug 2010 12:19:00 -0700
Message-ID: <20100813191900.GB8202@samba1>
References: <1280524978.2452.9.camel@segv.aura.of.mankind>
 <20100801092529.5e6ba0e0@corrin.poochiereds.net>
 <20100805235218.GB31233@jeremy-laptop>
 <20100806133836.49757af9@notabene>
 <20100808121208.GA7329@jeremy-laptop>
 <20100808085301.24f53e5a@tlielax.poochiereds.net>
 <20100808130501.GA9851@jeremy-laptop>
 <20100813125432.GB8945@fieldses.org>
 <20100813175410.GA8202@samba1>
 <alpine.LSU.2.01.1008132104290.12206@obet.zrqbmnf.qr>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>,
	utz lehmann <lkml123-4es5y7D8suKELgA04lAiVw@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsde-kxMDh+IBDuj1P9xLtpHBDw@public.gmane.org
To: Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1008132104290.12206-SHaQjdQMGhDmsUXKMKRlFA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Aug 13, 2010 at 09:06:28PM +0200, Jan Engelhardt wrote:
> 
> On Friday 2010-08-13 19:54, Jeremy Allison wrote:
> >On Fri, Aug 13, 2010 at 08:54:32AM -0400, J. Bruce Fields wrote:
> >> On Sun, Aug 08, 2010 at 06:05:01AM -0700, Jeremy Allison wrote:
> >> > We don't need to ape Windows in everything.
> >> > The coming ACL disaster will show that (we will go from an ACL
> >> > model that is slightly too complex to use, to one that is impossibly
> >> > complex to use :-).
> >> 
> >> Care to elaborate?
> >
> >POSIX ACLs -> RichACLs (NT-style). Not criticising Andreas here,
> >people are asking for this. But Windows ACLs are a nightmare
> >beyond human comprehension :-). In the "too complex to be
> >usable" camp.
> 
> Well, for one, ACLs in NT can be recursive IIRC. You can't say that of Linux
> ACLs - instead you have to setfacl -R and setfacl -Rd to give one user access
> to a directory and all its subdirs including future new inodes.

You do realize that Windows does exactly the same thing under
the covers, right ? Watch SMB or SMB2 traffic between a client
and Windows server when someone changes an ACL sometime :-).

Jeremy
