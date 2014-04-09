From: Sebastian Krahmer <krahmer-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifskey: better use snprintf()
Date: Wed, 9 Apr 2014 08:11:04 +0200
Message-ID: <20140409061104.GA27130@suse.de>
References: <20140408124444.GB23274@suse.de> <20140408103212.356655ac@tlielax.poochiereds.net> <20140408144129.GA7863@suse.de> <20140408132326.7bb0de89@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140408132326.7bb0de89-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Apr 08, 2014 at 01:23:26PM -0400, Jeff Layton wrote:

> > > If you do that then you don't need to use strlen() either.
> > > 
> > > -- 
> > > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > 
> 
> Ok, I think you're correct about snprintf. I got it confused with
> sprintf, which doesn't always NULL-terminate.
> 
> If it does indeed always null-terminate then there is indeed no harm in
> using strlen, it's just not as efficient. Why not instead simply take
> the return value of snprintf and use that to determine whether the
> output got truncated? I think we'd rather return an error if it is,
> than pass in a possibly bogus string to add_key().

Could be done indeed.

Sebastian

-- 

~ perl self.pl
~ $_='print"\$_=\47$_\47;eval"';eval
~ krahmer-l3A5Bk7waGM@public.gmane.org - SuSE Security Team
