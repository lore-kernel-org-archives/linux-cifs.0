From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/6] CIFS: Implement cifs_strict_writev (try #3)
Date: Mon, 27 Dec 2010 19:47:14 +0300
Message-ID: <AANLkTi=rXgeCOgrLA+RLvJ7eqZyhO7+cbbqwzu77-FnB@mail.gmail.com>
References: <1293357858-10006-1-git-send-email-piastryyy@gmail.com>
	<1293357858-10006-2-git-send-email-piastryyy@gmail.com>
	<20101227110538.48b150c7@tlielax.poochiereds.net>
	<AANLkTi=+Nw+Spp6pmDJbqn5sBt0TKp8g=wr2BTHHdSYu@mail.gmail.com>
	<20101227113556.56f1b3e8@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101227113556.56f1b3e8-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/27 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> A private_data of NULL on an open file is now a bug. Directories can
> currently have a NULL private_data, but that shouldn't be a problem
> here. I'd just check for invalidHandle. CIFS also has a ton of unneeded
> NULL pointer checks so it's not always worthwhile to use existing code
> as a guideline.

Ok, thanks for this info. In this case I'll remove private_data ==
NULL check from cifs_iovec_readv functions from the read patch too.

-- 
Best regards,
Pavel Shilovsky.
