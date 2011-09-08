From: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if
 available
Date: Thu, 08 Sep 2011 15:13:23 +0200
Message-ID: <4E68BF73.2090707@ts.fujitsu.com>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>			 <1315322794-10725-1-git-send-email-martin.wilck@ts.fujitsu.com>			 <20110906121017.7ce0018b@tlielax.poochiereds.net>			 <4E673D6F.90606@ts.fujitsu.com>			 <20110907090321.2196de8f@tlielax.poochiereds.net>		 <1315431768.22110.4.camel@obed> <4E686D69.9090503@ts.fujitsu.com>	 <1315467589.22110.55.camel@obed> <4E68BACD.2020403@ts.fujitsu.com> <1315486914.541.14.camel@obed>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Martin Wilck <mwilck-KvP5wT2u2U0@public.gmane.org>
To: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315486914.541.14.camel@obed>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/08/2011 03:01 PM, Andrew Bartlett wrote:

> Try 
> [libdefaults]
>  rdns = false
> 
> in your krb5.conf

Doesn't work, sorry. Actually, it doesn't seem to make any difference in
my setup. In my scenario, cifs.upcall would be able to infer the correct
SPN with the following algorithm:

 - get the IP address using DNS
 - get the "real" server FQDN using RDNS
 - use "cifs/<hostname portion of the "real" FQDN>" as SPN

Thus RDNS might indeed be beneficial here (but "rdns = true" makes no
difference, either).

OTOH, from the security point of view, this algorithm might not be more
secure than the server-provided SPN, because the attack scenario assumes
that DNS and/or general network packet transmission is already hijacked.

The question remains: what are the windows clients doing to overcome
this situation?

Martin

> (The default value here isn't suitable for use in an AD environment). 
> 
> Andrew Bartlett

-- 
Dr. Martin Wilck
PRIMERGY System Software Engineer
x86 Server Engineering

FUJITSU
Fujitsu Technology Solutions GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn, Germany
Phone:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org
Internet:		http://ts.fujitsu.com
Company Details:	http://ts.fujitsu.com/imprint
