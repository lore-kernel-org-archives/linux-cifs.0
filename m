From: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if
 available
Date: Tue, 13 Sep 2011 13:01:21 +0200
Message-ID: <4E6F3801.7060900@ts.fujitsu.com>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>		<1315322794-10725-1-git-send-email-martin.wilck@ts.fujitsu.com>		<20110906121017.7ce0018b@tlielax.poochiereds.net>		<4E673D6F.90606@ts.fujitsu.com>		<20110907090321.2196de8f@tlielax.poochiereds.net>		<1315431768.22110.4.camel@obed>	<4E686D69.9090503@ts.fujitsu.com>		<1315467589.22110.55.camel@obed>	<4E68BACD.2020403@ts.fujitsu.com>		<1315486914.541.14.camel@obed>	<4E68BF73.2090707@ts.fujitsu.com>		<1315488187.541.16.camel@obed>	<4E68EEAE.2090102@ts.fujitsu.com>	 <20110909093736.082f0ea4@corrin.poochiereds.net>	 <4E6DCA86.8020707@ts.fujitsu.com> <1315869795.19788.53.camel@ruth>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Martin Wilck <mwilck-KvP5wT2u2U0@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315869795.19788.53.camel@ruth>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/13/2011 01:23 AM, Andrew Bartlett wrote:

> If they know the computer name, why don't they connect to it as
> $COMPUTERNAME?  That's how this is meant to work - the DNS or netbios
> name the user resolves for the connection to is either the cn,
> dnsHostname or in the servicePrincipalNames of the record.  

As I said earlier, that's what the Win clients do, and when it fails,
they fall back to NTLM which won't bother with SPNs. The user never gets
to know the difference.

> If your users are connecting to names not in that list, why not just add
> them to the servicePrincipalNames list?  We really should not be adding
> more and more hacks around this area, they will only bite us later.

I have requested that from our sysadmin.

When I first discovered that Win clients could connect to the service in
question while the Linux cifs client couldn't, I suspected a problem
with the cifs client (especially because smbclient was able to connect
with kerberos, too). I do understand now that this conclusion was wrong.

Regards
Martin

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
