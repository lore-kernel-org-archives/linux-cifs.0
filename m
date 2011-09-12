From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if
 available
Date: Tue, 13 Sep 2011 09:23:12 +1000
Message-ID: <1315869795.19788.53.camel@ruth>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>
		<1315322794-10725-1-git-send-email-martin.wilck@ts.fujitsu.com>
		<20110906121017.7ce0018b@tlielax.poochiereds.net>
		<4E673D6F.90606@ts.fujitsu.com>
		<20110907090321.2196de8f@tlielax.poochiereds.net>
		<1315431768.22110.4.camel@obed>	<4E686D69.9090503@ts.fujitsu.com>
		<1315467589.22110.55.camel@obed>	<4E68BACD.2020403@ts.fujitsu.com>
		<1315486914.541.14.camel@obed>	<4E68BF73.2090707@ts.fujitsu.com>
		<1315488187.541.16.camel@obed>	<4E68EEAE.2090102@ts.fujitsu.com>
	 <20110909093736.082f0ea4@corrin.poochiereds.net>
	 <4E6DCA86.8020707@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Martin Wilck <mwilck-KvP5wT2u2U0@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E6DCA86.8020707-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2011-09-12 at 11:01 +0200, Martin Wilck wrote:
> > For the record, I'm not 100% opposed to adding something like this as a
> > workaround. What would probably be better would be a way for someone to
> > specify the SPN in the mount options. The kernel could then pass that
> > to the upcall and we wouldn't need to trust this string from the
> > server. Admins would of course need to know what SPN to put in there
> > however. Something like:
> > 
> >     -o spn=cifs/otherhostname.example.com
> 
> Sounds good. In our AD environment, an admin can do
> 
> ldapsearch "(cn=$COMPUTERNAME)" serviceprincipalname
> 
> to get the supported principal name(s).

If they know the computer name, why don't they connect to it as
$COMPUTERNAME?  That's how this is meant to work - the DNS or netbios
name the user resolves for the connection to is either the cn,
dnsHostname or in the servicePrincipalNames of the record.  

If your users are connecting to names not in that list, why not just add
them to the servicePrincipalNames list?  We really should not be adding
more and more hacks around this area, they will only bite us later.

Andrew Bartlett
-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
