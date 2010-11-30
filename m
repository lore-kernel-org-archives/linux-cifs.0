From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -v3] cifs: add attribute cache timeout (actimeo) tunable
Date: Tue, 30 Nov 2010 13:29:38 -0500
Message-ID: <20101130132938.7c72ae62@corrin.poochiereds.net>
References: <1291125010-12772-1-git-send-email-sjayaraman@suse.de>
	<20101130090825.78865825@tlielax.poochiereds.net>
	<4CF5302A.7030200@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF5302A.7030200-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 30 Nov 2010 22:41:06 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> >> +/*
> >>   * MAX_REQ is the maximum number of requests that WE will send
> >>   * on one socket concurrently. It also matches the most common
> >>   * value of max multiplex returned by servers.  We may
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index 32fa4d9..ee7cb11 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -105,6 +105,7 @@ struct smb_vol {
> >>  	unsigned int wsize;
> >>  	bool sockopt_tcp_nodelay:1;
> >>  	unsigned short int port;
> >> +	unsigned long actimeo; /* attribute cache timeout (jiffies) */
> > 
> > 	^^^ unused variable?
> 
> We use this to store the actimeo value in jiffies as we parse the mount
> options in cifs_parse_mount_options() below in this patch.
> 
> Did you mean this could be avoided?
> 

Sorry, I misread the patch and thought it was a local variable in
cifs_parse_mount_options. Please disregard that comment.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
