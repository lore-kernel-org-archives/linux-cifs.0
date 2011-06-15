From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: trivial: cleanup fscache cFYI and cERROR messages
Date: Wed, 15 Jun 2011 08:58:41 -0400
Message-ID: <20110615085841.633bb3c3@corrin.poochiereds.net>
References: <4DF7804B.8000502@suse.de>
	<20110614120048.7c04567d@corrin.poochiereds.net>
	<4DF87E1D.70802@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DF87E1D.70802-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 15 Jun 2011 15:10:45 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 06/14/2011 09:30 PM, Jeff Layton wrote:
> > On Tue, 14 Jun 2011 21:07:47 +0530
> > Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> > 
> >> ... for uniformity and cleaner debug logs.
> >>
> >> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> >> ---
> >>  fs/cifs/cache.c   |    6 +++---
> >>  fs/cifs/fscache.c |   53 +++++++++++++++++++++++++----------------------------
> >>  2 files changed, 28 insertions(+), 31 deletions(-)
> >>
> >> diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
> >> index dd8584d..545509c 100644
> >> --- a/fs/cifs/cache.c
> >> +++ b/fs/cifs/cache.c
> >> @@ -92,7 +92,7 @@ static uint16_t cifs_server_get_key(const void *cookie_netfs_data,
> >>  		break;
> >>  
> >>  	default:
> >> -		cERROR(1, "CIFS: Unknown network family '%d'", sa->sa_family);
> >> +		cERROR(1, "Unknown network family '%d'", sa->sa_family);
> > 			^^^^^^^^^
> > 		Maybe this would be a good time to add in a new
> > 		cFYI/cERROR "flag" for fscache and convert all of these
> > 		to use it?
> 
> Sounds like a good idea to flag fsc debug messages separately but
> flagging errors separately would be useful?
> 

Good point. Now that you mention it, I'm not sure what purpose the
first argument to cERROR serves. Might be a good thing to do a global
search and replace -- "s/cERROR(1, /cERROR(/" and fix up the macro.

> Also, I don't understand the idea behing the "set" currently.
> 
> we have
> 
> #define cFYI(set, fmt, arg...)                  \
> do {                                            \
>         if (set)                                \
>                 cifsfyi(fmt, ##arg);            \
> } while (0)
> 
> and we call cFYI with always pass like this:
> 	cFYI(1, "..");
> 
> 

I think for cFYI, the idea was to have a bitmask that would allow you
to selectively turn on certain classes of debug messages (similar to
how NFS' dfprintk macro works). In practice though, it's rarely set to
anything but "1". Maybe we should consider eliminating that argument as
well?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
