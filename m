From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix the conflict between rwpidforward and rw mount options
Date: Sat, 27 Aug 2011 20:07:18 +0400
Message-ID: <CAKywueT722wP7h6Ugrk8_dMkXn-K-DZBTqbnT6icJW327k-3iw@mail.gmail.com>
References: <1314381783-5614-1-git-send-email-piastry@etersoft.ru>
	<20110827060011.55847806@tlielax.poochiereds.net>
	<CAKywueTwKA38HxwCmmON-96gasPvoSR2HzPgHuU1iEXw_Q6a-w@mail.gmail.com>
	<20110827102737.51d50046@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110827102737.51d50046-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/8/27 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> Except that this option is already in existing kernels that are in the
> field, as well as the documentation (the mount.cifs manpage). Changing
> user-visible interfaces like this without any warning is not good
> practice.
>
> As a side note...how was rwpidforward originally tested if the option
> was broken and could never be turned on?
>

I agree that is not good. I do really remember that I give it some
testing before send it to the list and I am not sure how it could
happen - guess that I gave it wrong testing or smth like that - sorry
about it.

I will provide new patches for kernel and mount.cifs that fix this problem.

Steve, can you remove this version of the patch from your tree or
revert it, please?

-- 
Best regards,
Pavel Shilovsky.
