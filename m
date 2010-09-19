From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: New read cache mechanism
Date: Sun, 19 Sep 2010 20:53:45 +0400
Message-ID: <AANLkTi=1xKefrYnxMLpLQQKTBgRNESN9FJ1MzMWsAeis@mail.gmail.com>
References: <AANLkTinA+YpcYFF6YE-df7sg-thCg87_7Bn5qjC+LxYH@mail.gmail.com>
	<20100918073214.4104b01e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100918073214.4104b01e-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> Looks reasonable, but it would be good to know what sort of performance
> impact to expect from this. Have you done any benchmarking pre and post
> patch?

I don't run any performance benchmarking on it but of course I did
checkings with for logic and tried it with the real Wine application,
that has network mode provided by CIFS.

-- 
Best regards,
Pavel Shilovsky.
