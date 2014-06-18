From: "Bob Balsover" <cifs-MPfZBXey4klWk0Htik3J/w@public.gmane.org>
Subject: Re: cifs SRV record
Date: Wed, 18 Jun 2014 15:01:01 -0700
Message-ID: <0a840b51be30d5535ae0b7f59f83e5c1.squirrel@mail.balsover.com>
References: <1403101167.9166.6.camel@hh16.hh3.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403101167.9166.6.camel-HkULYb+WTT7YCGPCin2YbQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Why not just use DFS? I believe that this is what it was designed for.

-Bob

> Hi
> Is it possible to have cifs SRV rrs like ldap and kerberos where clients
> can look for the service themselves? We'd like to be able to offer
> shares on more than one server without the cluster stuff.
>
> ATM we have e.g.
> mount -t cifs //server/share -owhatever
>
> Our question is, would having cifs SRV be a  way around having to
> specify a specific server?
> Cheers,
> Steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
