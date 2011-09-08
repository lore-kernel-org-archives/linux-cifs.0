From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if
 available
Date: Thu, 8 Sep 2011 09:31:57 -0400
Message-ID: <20110908093157.6a6abe89@corrin.poochiereds.net>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>
	<1315322794-10725-1-git-send-email-martin.wilck@ts.fujitsu.com>
	<20110906121017.7ce0018b@tlielax.poochiereds.net>
	<4E673D6F.90606@ts.fujitsu.com>
	<20110907090321.2196de8f@tlielax.poochiereds.net>
	<1315431768.22110.4.camel@obed>
	<4E686D69.9090503@ts.fujitsu.com>
	<1315467589.22110.55.camel@obed>
	<4E68BACD.2020403@ts.fujitsu.com>
	<1315486914.541.14.camel@obed>
	<4E68BF73.2090707@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Martin Wilck <mwilck-KvP5wT2u2U0@public.gmane.org>
To: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E68BF73.2090707-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 08 Sep 2011 15:13:23 +0200
Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org> wrote:

> On 09/08/2011 03:01 PM, Andrew Bartlett wrote:
> 
> > Try 
> > [libdefaults]
> >  rdns = false
> > 
> > in your krb5.conf
> 
> Doesn't work, sorry. Actually, it doesn't seem to make any difference in
> my setup. In my scenario, cifs.upcall would be able to infer the correct
> SPN with the following algorithm:
> 
>  - get the IP address using DNS
>  - get the "real" server FQDN using RDNS
>  - use "cifs/<hostname portion of the "real" FQDN>" as SPN
> 

Another somewhat unsecure option for you then is to use the --trust-dns
option to cifs.upcall, which will do basically what you describe above.

Of course, the best solution would be to lobby your server admins to
either fix their DNS, or use setspn.exe to set up the necessary
principals in the KDC.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
