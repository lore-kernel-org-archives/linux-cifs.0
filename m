From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix symbolic links usage
Date: Mon, 4 Nov 2013 22:50:18 +0400
Message-ID: <CAKywueTXaZtjPyT2jjU-PLj0ubzKF5Dn70WMrOXs0ZQPtQpmag@mail.gmail.com>
References: <1383314259-4694-1-git-send-email-piastryyy@gmail.com>
	<20131101134219.02d33b75@tlielax.poochiereds.net>
	<CAKywueQGBtpvJwLjPja_xN5OA54qRC=24zSC9pcwhCrRt5Z86A@mail.gmail.com>
	<20131102211419.1b86a02d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Joao Correia <joaomiguelcorreia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131102211419.1b86a02d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/11/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> If you intend to push a fix to stable for this, then that sounds like
> the best approach. It will make cleaning up the API harder, but as long
> as you're ok with that...

Yes - it was targeted for stable as well. Any acks from your side?

Steve, do you have any objections to apply this patch (with Joao's
"Reported-and-tested-by: Joao Correia <joaomiguelcorreia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>"
tag)?

-- 
Best regards,
Pavel Shilovsky.
