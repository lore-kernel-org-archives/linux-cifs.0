From: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH 00/10] locks/nfsd: internal lease API overhaul
Date: Sun, 24 Aug 2014 21:43:01 -0400
Message-ID: <20140824214301.61019123@synchrony.poochiereds.net>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
	<20140824161046.GI15908@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140824161046.GI15908-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 24 Aug 2014 09:10:46 -0700
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> One more wishlist item in addition to the one mentioned in the patches:
> 
>  - add a return value to lm_break so that the lock manager can tell the
>    core code "you can delete this lease right now".  That gets rid of
>    the games with the timeout which require all kinds of race avoidance
>    code in the users.
> 

I'm not sure I understand what you're suggesting here. Isn't it just as
simple to have lm_break call lease_modify to just remove the lease?

> And a big one that doesn't seem easily addressable, but I'll drop it in
> anyway:
> 
>  - calling ->lm_break without i_lock would make everyones life a heck
>    lot easier..
> 

Indeed. I have some ideas for a larger cleanup of the file locking
code. This series is really sort of prep work for that overhaul, and
I'm hoping we'll be able to do something along those lines.

-- 
Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
