From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Alternate Data Streams
Date: Mon, 2 Apr 2012 10:23:46 -0700
Message-ID: <20120402172346.GA6980@samba2>
References: <CAH2r5mvOTo47SQ-aJSiEZvaZaoxeZWRXt0wa=BuiOOJXfHxHXg@mail.gmail.com>
 <CACyXjPyZGATA9vixXjG=O8FrTg6Aeb7Ew2jf_rKWqDhd5LW=1A@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACyXjPyZGATA9vixXjG=O8FrTg6Aeb7Ew2jf_rKWqDhd5LW=1A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Apr 02, 2012 at 10:21:31AM -0700, Richard Sharpe wrote:
> On 4/2/12, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > A user was asking about how to query alternate data streams of files
> > (over cifs) remotely for backup.
> >
> > Alternate Data Streams can be read from cifs (e.g.
> > /path/filename:streamname) but not listed or created.   Any thoughts
> > about whether this (at least listing the streams) should be done via
> > an ioctl, xattr or ...?
> 
> Well, FindFirstStreamW and FindNextStreamW seem to available from
> W2K03 on. There is a code project out there that you can search on. I
> hit it as the first link returned when I searched for "Enumerating
> Alternate Data Streams"

Remember Alternate Data Streams are dead from ReFS-onwards (thank
god :-).
