From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: lower default wsize when unix extensions are not
 used
Date: Wed, 9 Nov 2011 16:41:34 -0500
Message-ID: <20111109164134.13edf723@corrin.poochiereds.net>
References: <1320863843-29406-1-git-send-email-jlayton@redhat.com>
	<20111109134140.2105ed9e@corrin.poochiereds.net>
	<CAH2r5mtmboSEMHbj6ixh6UGSgiTFz1Mn=ZU6fkQaCSu7n6h=EQ@mail.gmail.com>
	<20111109160408.44947815@corrin.poochiereds.net>
	<CAH2r5mtGbo4uHzp9KE_Jo3x=hkBewDM8+nvqoVqkyuG4TeRXhQ@mail.gmail.com>
	<20111109163457.14c37072@corrin.poochiereds.net>
	<CAH2r5mupsXVYYkkqdC9fQ=EHfeD6ZeCzV7ggYc0wX_0NR4mhmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, phireph0x-/E1597aS9LQAvxtiuMwx3w@public.gmane.org,
	piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mupsXVYYkkqdC9fQ=EHfeD6ZeCzV7ggYc0wX_0NR4mhmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 9 Nov 2011 15:36:04 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Nov 9, 2011 at 3:34 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Wed, 9 Nov 2011 15:14:30 -0600
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > > Part of the issue is whether we view this as a server "bug" or not.
> > > Reading the documentation it looks to me like a server bug if
> > > it doesn't handle writes up to almost 128K when the flag is on
> > > (even though Windows client doesn't us send requests for over 64K,
> > > or at least rarely sends over 64K).  I don't remember seeing problems
> > > with this to any Windows servers, but clearly if more than one
> > > major server (NetApp or EMC etc., not just Solaris) had this problem,
> > > your argument makes sense.  If this is just a bug in a single server
> > > implementation, then detecting that and working around it probably
> > > makes more sense than punishing NetApp, EMC and Windows
> > > for another vendors bug.  Do we have data on problems to
> > > any other servers with large writes?
> > >
> >
> > I'm not sure and that's a problem. For every user like Nick that takes
> > the time to report these sorts of issues, we may have dozens that
> > just give up and walk away when they hit them.
> >
> >
> Perhaps - but I think we would have hit these with fsx or connectathon test
> suite at the last (SNIA) test event if it were widespread.
> 

Again, we don't know. This is 100% dependent on what the server
supports. There is no way to test every possible cifs server that's in
the field. All we can do is follow the spec when there is one.

When the spec is unclear (as it is in this situation), then we really
have little choice but to look to the reference implementation for
guidance (aka Windows).

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
