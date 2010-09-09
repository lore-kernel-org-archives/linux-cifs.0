From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS data coherency problem
Date: Thu, 9 Sep 2010 22:18:05 +0400
Message-ID: <AANLkTinYFe6O-4ANt1VYcvEMukiis-11cDuMP2GSKZ7j@mail.gmail.com>
References: <AANLkTin2iSc=Ob3DkhARJRV7CzwRUBJSGRMUJNJM+82k@mail.gmail.com>
	<AANLkTi=_eMSC99K1a2zWpgW5nc8UArzKj2MWHaRmCXzK@mail.gmail.com>
	<20100908063224.240b0419@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100908063224.240b0419-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/9/8 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Wed, 8 Sep 2010 10:49:13 +0400
>
> What sort of server were you working with here?

Samba 3.4, Samba 4, Windows XP.

>
> At the very least, we should consider a "strict" caching model like you
> describe as an option. If it has a large performance impact then we may
> want to allow people to use the existing caching model as well. OTOH,
> maintaining multiple caching models may be too cumbersome to support.

Yes, It brings complexity. As for performance: how can we talk about
performance if we have invalid data? In this case when we can't use
any serious application for business on CIFS file system (because of
wrong data coherency) why do we need such a performance? I think we at
first should keep all the data up to date and then think about
performance and other not so important things.

>
> If you're saying however that the spec says this, then it would
> also be helpful to point out the place in the spec that outlines this
> so we can go back and read over that part.

3.2.4.18 from [MS-CIFS].pdf states when a client should use a cache
for reading, writing or locking. You can also look at
http://go.microsoft.com/fwlink/?LinkID=140636 for more information
about oplock semantic. In every case I didn't noticed any information
for using cache if we don't have an oplock. If you have such an
information it'll be very interesting to see it.

>
> There's no need to hesitate in sending the patches however. Doing so
> gives us a starting point for discussing the change. If you're not sure
> about them, just declare them an "RFC".

Ok, I will prepare the patch and send it soon.

-- 
Best regards,
Pavel Shilovsky.
