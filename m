From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if
 available
Date: Thu, 08 Sep 2011 23:01:52 +1000
Message-ID: <1315486914.541.14.camel@obed>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>
			 <1315322794-10725-1-git-send-email-martin.wilck@ts.fujitsu.com>
			 <20110906121017.7ce0018b@tlielax.poochiereds.net>
			 <4E673D6F.90606@ts.fujitsu.com>
			 <20110907090321.2196de8f@tlielax.poochiereds.net>
		 <1315431768.22110.4.camel@obed> <4E686D69.9090503@ts.fujitsu.com>
	 <1315467589.22110.55.camel@obed> <4E68BACD.2020403@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Martin Wilck <mwilck-KvP5wT2u2U0@public.gmane.org>
To: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E68BACD.2020403-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2011-09-08 at 14:53 +0200, Martin Wilck wrote:
> On 09/08/2011 09:39 AM, Andrew Bartlett wrote:
> 
> > The name of the server is the right name, ie the name in the UNC path
> > or URL.
> 
> Hmm, it may be that just a few servers are affected here. we have one
> important server which appears to have a weird DNS setup:
> 
> dig +short -t A server.domain.net
> 172.100.10.25
> dig +short -t CNAME server.domain.net
> (NORESPONSE)
> dig +short -t PTR -x 172.100.10.25
> c10203.domain.net
> dig +short -t A c10203.domain.net
> (NORESPONSE)
> 
> While this is quite obviously broken, Windows clients in the domain have
> no problems accessing this server, while Linux clients do. The only
> temporary workaround I found for this is to add c10203 to /etc/hosts
> locally and mount the share as "//c10203/share"
> (//c10203.domain.net/share does *not* work).
> 
> This is samba 3.5.8, kernel 2.6.38.6-27.fc15 on Fedora 15.

Try 
[libdefaults]
 rdns = false

in your krb5.conf

(The default value here isn't suitable for use in an AD environment). 

Andrew Bartlett
-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
