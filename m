From: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Subject: Re: Can't mount Windows DFS root using NTLMv2 (fwd)
Date: Tue, 30 Nov 2010 21:08:34 +0100
Message-ID: <4CF559C2.1080503@exx.nl>
References: <alpine.DEB.2.00.1011301428530.15277@awakenings.cable.ziggo.nl>	<AANLkTinHDfxNhKLSEwHtH7oM+EUCj_HB97Ch-9RQXjTj@mail.gmail.com>	<alpine.DEB.2.00.1011301739010.31075@awakenings.cable.ziggo.nl>	<AANLkTinwtjkL_Exr57wDjRiKQTzVFwjuv=kBOw7s5mgS@mail.gmail.com>	<alpine.DEB.2.00.1011301809050.31075@awakenings.cable.ziggo.nl>	<AANLkTin3-k4AJRYvL4p8VQqvnnL5mLJJZXNf5mC1RBKg@mail.gmail.com>	<alpine.DEB.2.00.1011301827580.31075@awakenings.cable.ziggo.nl>	<AANLkTinneo5HQxeOoCKVXyBZ2_i0AYWj9gqauBWoVAhn@mail.gmail.com>	<alpine.DEB.2.00.1011301852040.31075@awakenings.cable.ziggo.nl>	<20101130143747.1fabcc37@corrin.poochiereds.net> <20101130145608.59840ea1@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101130145608.59840ea1-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Jeff,

Op 30-11-2010 20:56, Jeff Layton schreef:
> 
> I think I found it. Does this patch fix it for you?
> 
> --------------------------[snip]----------------------------
> 
> [PATCH] cifs: fix parsing of hostname in dfs referrals

Yep, verified fixed with sec=ntlm as well as sec=ntlmv2.

Thanks!

BTW, I will follow up with another bugreport concerning DFS of the bug I
was *originally* chasing before this got in the way ;)

Regards,
Robbert
