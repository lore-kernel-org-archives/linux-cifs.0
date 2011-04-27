From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs: fix some bounds checking problems
Date: Wed, 27 Apr 2011 11:14:43 -0400
Message-ID: <20110427111443.0a9fc5bc@tlielax.poochiereds.net>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
	<20110427101740.32be5c28@corrin.poochiereds.net>
	<BANLkTiko7K1HJFjAKfRokmFiWk=+rHe0DA@mail.gmail.com>
	<20110427110404.71b80c29@tlielax.poochiereds.net>
	<BANLkTinzFc5DgUuG9ohRQNGk12PDO7J-uQ@mail.gmail.com>
	<BANLkTikLYQg_zEWS5Joz=7eTj1P_YF6ZzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikLYQg_zEWS5Joz=7eTj1P_YF6ZzQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 27 Apr 2011 10:07:18 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Apr 27, 2011 at 10:06 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Wed, Apr 27, 2011 at 10:04 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> >> On Wed, 27 Apr 2011 09:59:52 -0500
> >> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >>> I will try to get the remaining cleanup patches (such as the bcc
> >>> little endian patches) remerged over the next few days - that should
> >>> make this easier to respin
> >>>
> >>
> >> Does this mean that you do not intend to push this set for 2.6.39?
> >
> > the bcc cleanup or the recent bounds checking series?
> >
> > It could make sense for your recent bounds checking patches
> > to go in - but I thought that you wanted to wait on those till 2.6.40
> 
> I had missed the comment about 2.6.39 in your summary.
> 
> 

Yeah, I think the bounds checking patches are reasonable for 2.6.39.
The patch to convert the BCC to little endian is probably 2.6.40
material at this point.

If you push the bounds checking patches for 2.6.39 though, then the BCC
patch will need to be respun for 2.6.40. It's not a problem, but I need
to know whether you plan to push the bounds checking fixes for 2.6.39
so that I know which one needs to be respun.

Make sense?
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
