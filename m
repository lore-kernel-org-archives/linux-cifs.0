From: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if
 available
Date: Thu, 08 Sep 2011 09:23:00 -0400
Message-ID: <1315488180.22877.230.camel@pico.li.ssimo.org>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>
	 <1315322794-10725-1-git-send-email-martin.wilck@ts.fujitsu.com>
	 <20110906121017.7ce0018b@tlielax.poochiereds.net>
	 <4E673D6F.90606@ts.fujitsu.com>
	 <20110907090321.2196de8f@tlielax.poochiereds.net>
	 <1315431768.22110.4.camel@obed> <4E686D69.9090503@ts.fujitsu.com>
	 <1315467589.22110.55.camel@obed> <4E68BACD.2020403@ts.fujitsu.com>
	 <1315486914.541.14.camel@obed>  <4E68BF73.2090707@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Martin Wilck <mwilck-KvP5wT2u2U0@public.gmane.org>
To: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E68BF73.2090707-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2011-09-08 at 15:13 +0200, Martin Wilck wrote:
> Doesn't work, sorry. Actually, it doesn't seem to make any difference
> in
> my setup. In my scenario, cifs.upcall would be able to infer the
> correct
> SPN with the following algorithm:
> 
>  - get the IP address using DNS
>  - get the "real" server FQDN using RDNS
>  - use "cifs/<hostname portion of the "real" FQDN>" as SPN

If cifs does an explicit PTR resolution than that is probably a bug and
should be fixed.

> Thus RDNS might indeed be beneficial here (but "rdns = true" makes no
> difference, either).
> 
> OTOH, from the security point of view, this algorithm might not be
> more
> secure than the server-provided SPN, because the attack scenario
> assumes
> that DNS and/or general network packet transmission is already
> hijacked.

DNS being hijacked is not an issue. The issue is thinking you are
connecting to server A and instead ending up with connecting to B

If DNS is hijacked so the A points to B's ip address you still ask for a
ticket for A and that's what you get from the KDC. When then ou try to
auth to B with A's ticket, all breaks down.

Instead if you trust what B says its name is, then you would get a
ticket for B and auth will continue properly.

So a user that wanted to contact server A ends up contacting servr B and
may not notice.

Now reply A with topsecret.agency.gov and B with public.agency.gov and
you understand why that is an issue.

> The question remains: what are the windows clients doing to overcome
> this situation?

They delegate a lot of name resolution to the KDC, in particular they
let the KDC do the name canonicalization instead of doing it on their
own.

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Principal Software Engineer at Red Hat, Inc. <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
