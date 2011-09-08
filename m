From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if
 available
Date: Thu, 08 Sep 2011 17:39:47 +1000
Message-ID: <1315467589.22110.55.camel@obed>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>
		 <1315322794-10725-1-git-send-email-martin.wilck@ts.fujitsu.com>
		 <20110906121017.7ce0018b@tlielax.poochiereds.net>
		 <4E673D6F.90606@ts.fujitsu.com>
		 <20110907090321.2196de8f@tlielax.poochiereds.net>
	 <1315431768.22110.4.camel@obed> <4E686D69.9090503@ts.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Martin Wilck <mwilck-KvP5wT2u2U0@public.gmane.org>
To: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E686D69.9090503-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2011-09-08 at 09:23 +0200, Martin Wilck wrote:
> Hi Andrew,
> 
> > Samba 3.5 (latest release) and Samba 3.6 now default to the
> > server-provided SPN being untrusted and unused.  Samba 3.6 also does not
> > send it by default.  No new software should start using this principal,
> > and now all modern servers will not send it.
> 
> Please let me repeat my dumb question: Once a Windows user has logged in
> to the AD Domain, she'll be able to access all shares in the domain
> (which her account is allowed to use) without having to retype the
> domain password. Am  I wrong assuming this works through Kerberos somehow?
> 
> On Linux clients, users need to retype passwords all the time. That
> makes Linux machines 2nd class network members, at least psychologically
> for their users. The reason (in my environment) is that the samba tools
>  are unable to figure out the correct SPN. I understand your argument
> that trying to do that via the server-provided name is insecure. That
> means there must be some other way, as Windows clients are able to find
> the SPN. What is it?

The name of the server is the right name, ie the name in the UNC path or
URL.  Do your linux users mount by IP address perhaps?

Andrew Bartlett

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
