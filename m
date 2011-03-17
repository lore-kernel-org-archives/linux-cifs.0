From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Allocating SMB2 mids (multiplex identifier structures)
Date: Thu, 17 Mar 2011 09:41:34 -0500
Message-ID: <AANLkTin-YWNgvdNpZQx28hXR9ZdhQciCLgEhUwqZf3-C@mail.gmail.com>
References: <AANLkTi=oYKfaOP-oHbBKODddGkzAWg7bBsY2_ZT9e-W8@mail.gmail.com>
	<20110317143514.GB3295@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110317143514.GB3295-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Mar 17, 2011 at 9:35 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =
wrote:
> Btw, what branch are these commits for? =A0I dearly hope you're not t=
rying
> to push half-assed code to mainline. =A0Please do your development on=
 a
> branch first, and once there is a useable implementation it can be
> reviewed and synced over. =A0Take a look at pnfs development for exam=
ple.

We have an implementation that was in the test tree for a year, went
through 3 test events that is being ported.  I don't think it will
take more than a week or so to get enough of it in.  Unless it gets
upstream, it is not going to get much wider review than from the
original group (Pavel, Jeremy etc).  Note that all code is marked as
"broken" and the majority in distinct c files - this is not that
different than pNFS, which only recently got usable in mainline but
was checked in many releases back.


--=20
Thanks,

Steve
