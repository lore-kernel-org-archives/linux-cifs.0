From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] Extract DFS referral expansion to new function in
 cifs_mount
Date: Fri, 1 Apr 2011 11:04:12 -0400
Message-ID: <20110401110412.7a4f9fb6@tlielax.poochiereds.net>
References: <20110401090908.6f96c045@tlielax.poochiereds.net>
	<20110401073256.70180710@tlielax.poochiereds.net>
	<E1Q5dRc-0005je-TI@seldlx2151.corpusers.net>
	<20110401091418.76871d76@tlielax.poochiereds.net>
	<20110401073256.70180710@tlielax.poochiereds.net>
	<E1Q5dRd-0005jh-0Z@seldlx2151.corpusers.net>
	<20110401092717.03b42cfe@tlielax.poochiereds.net>
	<20110401073256.70180710@tlielax.poochiereds.net>
	<E1Q5dRc-0005jZ-Mf@seldlx2151.corpusers.net>
	<20110401090829.5521384b@tlielax.poochiereds.net>
	<20110401142625.GA8348@cobija.connexer.com>
	<20110401110157.42a571e6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110401110157.42a571e6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 1 Apr 2011 11:01:57 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> 
> Good point. I wasn't thinking about that case.
> 
> I think having cifs_sb->mountdata as an unconditional member would be a
> better option. We don't generally have *that* many superblocks and it
> would be nice to get rid of some #ifdef's. In most cases these strings
> are quite small so if someone compiles DFS support out, it won't be
> wasting that much memory.
> 

Another argument for this solution...

The CIFS code currently handles remounts poorly. If we make it a point
to keep the original mount options around it may make it easier to
eventually fix that.
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
