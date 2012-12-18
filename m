From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] cifs: Do not enable debugging code by default
Date: Tue, 18 Dec 2012 16:19:05 +0100
Message-ID: <20121218151904.GC31255@liondog.tnic>
References: <1355737085-6671-1-git-send-email-bp@alien8.de>
 <CAH2r5mt=4ZoGR_4hP52uHsZabXpPfh1sa1X0GSg6W4=fawNFnA@mail.gmail.com>
 <20121218071317.01cbc41b@tlielax.poochiereds.net>
 <20121218144452.GB31255@liondog.tnic>
 <20121218100702.478fc1b1@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121218100702.478fc1b1-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Dec 18, 2012 at 10:07:02AM -0500, Jeff Layton wrote:
> Yeah, not many do, but presumably they'll set it once and forget about
> it. Once someone straightens them out, they should rarely break.
>
> OTOH, the value of defaulting to "N" is pretty low here. Maybe it
> would just be best to just drop this patch and have the embedded folks
> turn this off on their own.

Yeah, sure.

I just thought you have this debugging code forked out of the driver and
it should be enabled only for when there are issues.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
