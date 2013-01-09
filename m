From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: remove support for "complex" usernames from mount.cifs
Date: Wed, 9 Jan 2013 11:15:19 -0600
Message-ID: <CAH2r5mtPo558QcpjinZHFAZoWXvucrhoZYEWpVJrnHYHtYgM7A@mail.gmail.com>
References: <1357214055-24911-1-git-send-email-jlayton@samba.org>
	<CAFB9KM0-BrPcjV8gTW9BV_Awiw5bHbgYr=42smTJWKxCr=Y-PA@mail.gmail.com>
	<20130103142110.269ea0d1@tlielax.poochiereds.net>
	<CAH2r5mtRD85Te3g=G7Ez80NzGgG+36wHsiRnCzszQu9uee1-kQ@mail.gmail.com>
	<CAFB9KM3uR1xCa9gGyyRyKjRgsL8npdzo4zxfyLUQToAvrJUCEw@mail.gmail.com>
	<CAH2r5mv_gyNuTTf1-uSe1_HtWZgXmKUqyAHtu2UeJLi-aqT=9g@mail.gmail.com>
	<CAH2r5mv6jAZqKyFdccriM0wtusRr_XEhekUwMfzf7746p8McXg@mail.gmail.com>
	<20130104152224.497bdd1b@tlielax.poochiereds.net>
	<CAFB9KM1NPSx1nUXen+RpSbUZUHwVsCUBPz52yUv-iGXQkpxt_Q@mail.gmail.com>
	<CAH2r5muGfpgZ=dU=QZqeJK6z=MuJ=jG7=n1mkEwA3jzg1g1fUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muGfpgZ=dU=QZqeJK6z=MuJ=jG7=n1mkEwA3jzg1g1fUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jan 9, 2013 at 11:02 AM, Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
wrote:
>
> On Fri, Jan 4, 2013 at 3:22 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Fri, 4 Jan 2013 14:09:00 -0600
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Jan 4, 2013 12:26 PM, "Scott Lovenberg" <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> wrote:
> >> >
> >> > On Thu, Jan 3, 2013 at 3:04 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> > wrote:
> >> > > I am not as worried about code cleanliness as I am about losing
> >> > > function,
> >> > > especially as it is sometimes hard to figure out how many users
> >> > > would be
> >> > > affected by removing function.  I mildly prefer leaving the nfs
> >> > > syntax
> >> > > if it makes it easier for nfs users to use smb3, but we could make
> >> > > a stub
> >> > > mount helper that parses nfs syntax and simply calls mount.cifs if
> >> > > you
> >> > > prefer that approach - in any case I don't feel strongly about nfs
> >> > > syntax.
> >> >
> >> > I don't care much either way.  The reason behind removing it, IIRC,
> >> > was that it was an undocumented feature that lead to an ambiguous
> >> > parsing situation when you had NFS syntax with an IPv6 address as the
> >> > server portion of the string (ie
> >> > dead:beef::1:/shareNameWithColon:/prepath).  It was easier to remove
> >> > the undocumented feature than to support it for this use case.
> >> >
> >> > How does NFS syntax make things easier for SMB3?
> >>
> >> UNC names may be unfamiliar for some NFS users. Smb3 has many
> >> performance advantages and other features that may eventually be of
> >> strong interest to some Linux  NFS users
>
> Sorry to resurrect a dead thread, but how does the nfs-utils mount
> helper deal with parsing IPv6 addresses when using NFS syntax?  Does
> it just search for ":/" and assume that's the beginning of the share
> name (which 99.99999% of the time it will be)?
> --
> Peace and Blessings,
> -Scott.



I thought that NFS required that the IPv6 address be enclosed in brackets?
I haven't tested this to see how mount.cifs would handle this (if it is
broken presumably we should fix it)

https://fedoraproject.org/wiki/QA:Testcase_NFS_IPv6




--
Thanks,

Steve



--
Thanks,

Steve
