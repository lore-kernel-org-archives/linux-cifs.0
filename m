From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Mon, 6 Dec 2010 12:42:55 -0500
Message-ID: <20101206124255.7ea8a8a9@tlielax.poochiereds.net>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<E1POnFL-00BKfp-6h@intern.SerNet.DE>
	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>
	<20101205210634.602b076b@corrin.poochiereds.net>
	<AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>
	<E1PPSnw-00DDbs-Va@intern.SerNet.DE>
	<AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com>
	<4CFD16D8.4090207@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFD16D8.4090207-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 06 Dec 2010 11:01:12 -0600
"Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> 
> Question (for which I do not have an answer):  How much work do you want to
> do to make their intentionally broken model work?
> 

Very little...live by the sword, die by the sword :)

I'm not opposed to trying to work around this sort of brokenness, but
not at the expense of more conventional configurations.

If the proxy keeps responding to echoes regardless of what happens on
the server side of its connection then that sounds really broken to me.
Does it do nothing to detect whether the server is still around? I don't
see a way for us to detect such a broken device if not.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
