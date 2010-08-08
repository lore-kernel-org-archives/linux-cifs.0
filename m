From: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended  file stats available [ver #6]
Date: Mon, 9 Aug 2010 09:07:03 +1000
Message-ID: <20100809090703.304d21c7@notabene>
References: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>
	<20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	<20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	<30448.1279800887@redhat.com>
	<E1Obuiy-00C9jr-Al@intern.SerNet.DE>
	<AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
	<1280524978.2452.9.camel@segv.aura.of.mankind>
	<20100801092529.5e6ba0e0@corrin.poochiereds.net>
	<20100805235218.GB31233@jeremy-laptop>
	<20100806133836.49757af9@notabene>
	<20100808121208.GA7329@jeremy-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, utz lehmann <lkml123-4es5y7D8suKELgA04lAiVw@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsde-kxMDh+IBDuj1P9xLtpHBDw@public.gmane.org
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100808121208.GA7329@jeremy-laptop>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Sun, 8 Aug 2010 05:12:09 -0700
Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Fri, Aug 06, 2010 at 01:38:36PM +1000, Neil Brown wrote:
> > I'm curious.  Why do you particularly care what interface the kernel uses to
> > provide you with access to this attribute?
> 
> It's a matter of taste. The *BSD's have this right IMHO. It
> should be part of the stat information. A file timestamp is not
> an EA. Making it available that way just feels like an appalingly
> tasteless kludge. It offends the artist in me :-).

Unfortunately whenever you work on a collaborative project someone has to make
concessions to taste, as we all taste different.. (or have different taste..
or something).

So I think it is very important to clearly differentiate the practical issues
from the aesthetic issues as I think we can hope for unity on the former, but
never on the latter.

> 
> > Or do you really want something like BSD's 'btime' which as I understand it
> > cannot be set.  Would that be really useful to you?
> 
> It is *already* useful to us, and is widely used in
> existing code. The occasions when btime is set are
> relatively rare, and at that point we store it in a
> separate EA for Windows reporting purposes.

I'm probably sounding like a scratched record, but when you say "is widely
used" do you mean "is used in samba which is widely used" or do you mean "is
used in a wide variety of applications"?

Because if you are only saying the former, then I don't think we should copy
BSD, but rather I think we should provide exactly the semantics that are most
useful to samba - and that would seem to be creation-time and DOS flags which
the filesystem can store directly in the inode and which samba can access
cheaply.
(and I would prefer to use xattrs, but that is a taste thing and as I'm not
writing the code, I don't get to choose the taste).

But if you are saying the later, then sharing those details might help us see
that copying bsd is actually the best thing to do, or maybe that something
else is better.

I'm just afraid that if some new interface is added without clear,
comprehensive and up-front justification then we will end up getting a
sub-optimal interface.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
