From: Sven-Haegar Koch <haegar-DcL44mDNY06zQB+pC5nmwQ@public.gmane.org>
Subject: Re: 3.0-rc+git OOPS losetup on cifs
Date: Sat, 9 Jul 2011 15:42:44 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1107091541080.17541@aurora>
References: <alpine.DEB.2.02.1107042132500.18300@aurora> <4E155F6F.6070506@suse.de> <alpine.DEB.2.02.1107090250240.5791@aurora>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Linux-Kernel-Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.02.1107090250240.5791@aurora>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 9 Jul 2011, Sven-Haegar Koch wrote:

> On Thu, 7 Jul 2011, Suresh Jayaraman wrote:
> 
> > On 07/05/2011 01:18 AM, Sven-Haegar Koch wrote:
> > > Since a short while (I know it worked with 3.0-rc1) loopback-mounting an 
> > > image on a samba server mounted with cifs oopses the kernel.
> ...
> > I couldn't reproduce this with 3.0-rc6 with a smaller image file (1GB).
> > But I see no relevant fixes between -rc5 and -rc6.
> > 
> > Can you try to reproduce the same problem with a smaller non-encrypted file?
> 
> I can, and it seems something even more fundamental.


Update for the list (archive) readers:

The patch in https://bugzilla.kernel.org/show_bug.cgi?id=38972#c12 fixes 
the problem for me completely.

Thanks Jeff Layton

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
