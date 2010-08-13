From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
 file stats available [ver #6]
Date: Fri, 13 Aug 2010 13:09:36 -0500
Message-ID: <AANLkTik3dBUgDEww8E+3T=bvKh7a5j82tBKStjVM73p3@mail.gmail.com>
References: <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
	<AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
	<1280524978.2452.9.camel@segv.aura.of.mankind>
	<20100801092529.5e6ba0e0@corrin.poochiereds.net>
	<20100805235218.GB31233@jeremy-laptop>
	<20100806133836.49757af9@notabene>
	<20100808121208.GA7329@jeremy-laptop>
	<20100808085301.24f53e5a@tlielax.poochiereds.net>
	<20100808130501.GA9851@jeremy-laptop>
	<20100813125432.GB8945@fieldses.org>
	<20100813175410.GA8202@samba1>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>,
	utz lehmann <lkml123-4es5y7D8suKELgA04lAiVw@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsde-kxMDh+IBDuj1P9xLtpHBDw@public.gmane.org
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100813175410.GA8202@samba1>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Aug 13, 2010 at 12:54 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, Aug 13, 2010 at 08:54:32AM -0400, J. Bruce Fields wrote:
>> On Sun, Aug 08, 2010 at 06:05:01AM -0700, Jeremy Allison wrote:
>> > We don't need to ape Windows in everything.
>> > The coming ACL disaster will show that (we will go from an ACL
>> > model that is slightly too complex to use, to one that is impossibly
>> > complex to use :-).
>>
>> Care to elaborate?
>
> POSIX ACLs -> RichACLs (NT-style). Not criticising Andreas here,
> people are asking for this. But Windows ACLs are a nightmare
> beyond human comprehension :-). In the "too complex to be
> usable" camp.

Not much choice - even community colleges now have
to teach students about this ACL model in their sysadmin courses.

>> And what would native ACL support mean for Samba?
>
> RichACLs'll do it, but I feel sorry for the admins :-).

Yes - RichACLs and Windows ACLs allow you to set
some strange combinations of permssion bits.
RichACLs will make a more natural mapping for
Samba and NFSv4 - and it is far too late to
remove the requirement for Windows and
MacOS (among other clients) support.



-- 
Thanks,

Steve
