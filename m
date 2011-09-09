From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if
 available
Date: Fri, 9 Sep 2011 09:37:36 -0400
Message-ID: <20110909093736.082f0ea4@corrin.poochiereds.net>
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
	<1315488187.541.16.camel@obed>
	<4E68EEAE.2090102@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Martin Wilck <mwilck-KvP5wT2u2U0@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E68EEAE.2090102-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 08 Sep 2011 18:34:54 +0200
Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org> wrote:

> (I needed to remove linux-cifs from cc because of DNS troubles again -
> sorry)
> 
> On 09/08/2011 03:23 PM, Andrew Bartlett wrote:
> 	
> >> The question remains: what are the windows clients doing to overcome
> >> this situation?
> > 
> > They use only the name, as typed.  Windows never uses reverse DNS, as it
> > is rare on Windows networks.
> 
> It turns out that with the mentioned server, Kerberos doesn't work with
> Windows clients, either. Instead I can see (in wireshark) the Win
> clients falling back to NTLM authentication (or using it right away).
> That explains a lot. Sorry for the noise. (I'm currently looking for a
> switch in XP to force it to use Kerberos for testing purposes, but so
> far I found none).
> 

Ok, good to know...thanks.

For now, we'll plan to table these patches.

For the record, I'm not 100% opposed to adding something like this as a
workaround. What would probably be better would be a way for someone to
specify the SPN in the mount options. The kernel could then pass that
to the upcall and we wouldn't need to trust this string from the
server. Admins would of course need to know what SPN to put in there
however. Something like:

    -o spn=cifs/otherhostname.example.com


...for example.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
