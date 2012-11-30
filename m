From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: clean up handling of unc= option commit
Date: Fri, 30 Nov 2012 07:02:11 -0500
Message-ID: <20121130070211.749e76fe@tlielax.poochiereds.net>
References: <CAH2r5mtPsux7U3MpLxnNGDBQS7OdYqBeUXhS=XspyrUgsrrevg@mail.gmail.com>
	<20121129200208.56653c6a@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121129200208.56653c6a-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 29 Nov 2012 20:02:08 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, 29 Nov 2012 18:17:14 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > Jeff,
> > In your patch "cifs: clean up handling of unc= option	commit" aren't
> > you changing the parsing of not just the beginning of the UNC name to
> > change //server/share to \\server/share (e.g.) but did you mean to
> > change the parsing of the rest of the UNC name as well.  Doesn't
> > convert delimiter change all occurrences not just the first) ?
> > 
> 
> Yes, that's intentional.
> 

To clarify...

The mount helper has passed in the unc= option with '\\' delimiters for
a long time, regardless of what the user passes in. '/' is not an
allowable character in a UNC component, so there's no harm in
converting those characters unconditionally.

The prefixpath is different, of course...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
