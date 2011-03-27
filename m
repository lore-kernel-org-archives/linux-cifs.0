From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] allow cifs passwords with utf8 characters
Date: Sun, 27 Mar 2011 06:54:02 -0400
Message-ID: <20110327065402.4fa5685e@tlielax.poochiereds.net>
References: <20110327070144.GA3772@osk.mine.nu>
	<20110327075438.GA7174@osk.mine.nu>
	<20110327081834.GA22851@osk.mine.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110327081834.GA22851-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 27 Mar 2011 10:18:35 +0200
Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org> wrote:

> On Sunday, March 27, 2011 at 09:38, Oskar Liljeblad wrote:
> > > I noticed that I could not mount cifs shares when the password contained
> > > utf8-encoded latin1 characters. [..]
> > [..]
> > > +		len = utf8s_to_ucs2(passwd, 128, (wchar_t *) wpwd);
> > 
> > Looking at the code again, I wonder if not cifs_strtoUCS in cifs_unicode.c
> > should've been used instead?
> 
> Here is a tested patch that uses cifs_strtoUCS rather than utf8s_to_ucs2.
> 
> Regards,
> 
> Oskar

Looks good overall. I especially like the fact that we're removing
those broken unicode conversion routines. You should however resend
this patch with a proper description and "Signed-off-by:" line. Also,
be sure to run it through scripts/checkpatch.pl and fix anything it
complains about.

All that said, this is not an area of the code that I know very well.
Shirish probably ought to review this... cc'ing him.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
