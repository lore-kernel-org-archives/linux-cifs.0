From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs.upcall: attempt to use AD-style service
 principals
Date: Tue, 15 Nov 2011 12:10:08 +1100
Message-ID: <1321319411.5973.38.camel@ruth>
References: <1321233448-13548-1-git-send-email-jlayton@samba.org>
	 <1321237738.11559.31.camel@ruth>
	 <1321240351.3953.803.camel@pico.li.ssimo.org>
	 <20111114094449.66a35717@tlielax.poochiereds.net>
	 <1321310728.5973.29.camel@ruth>
	 <1321311883.3953.886.camel@pico.li.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321311883.3953.886.camel-akOVU7JyYd8WIfilqQrPtNi2O/JbrIOy@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2011-11-14 at 18:04 -0500, simo wrote:
> On Tue, 2011-11-15 at 09:45 +1100, Andrew Bartlett wrote: 
> > On Mon, 2011-11-14 at 09:44 -0500, Jeff Layton wrote:
> > 
> > > The above scheme isn't perfect, but in many cases it will happen to
> > > work. It's true that there's no reliable mapping between DNS and
> > > samAccountName, but in a lot of cases the samAccountName *is* the
> > > capitalized host portion of the DNS name. Does it hurt anything to
> > > attempt to get a ticket with that name if "cifs/fqdn" fails?
> > 
> > We should never ask for a machine$ name.  It is always the wrong thing
> > to do, because it will only exist on AD servers, which already do the
> > mapping between cifs/foo and foo$ internally.  
> 
> You are contradicting yourself here.
> First you say foo may not be the short name then you advocate for not
> using foo$. But asking for foo$ comes handly exactly when the short name
> is not the same as the fqdn truncated, as a use may pass on the command
> line and that's why it was added.

You should never truncate a FQDN.  If the user connects with a FQDN we
should always use cifs/FQDN as the only name that is attempted.  

> > We should also not map between cifs/ and host/ - cifs/ is a separate
> > service, just as nfs/ and http/ are. 
> 
> And yet it is possible to have cifs servers work when using the host/
> ticket. Trying and failing is not a big deal.

I disagree, and just because some servers accept the host/ principal
does not mean we should use it.  Kerberos specifically defines service
types, and we should use them as intended. 

> > > Over the years, we've seen a lot of confused users on the list who are
> > > not sure what name they need to put in the host portion of the UNC to
> > > get their krb5 mount to work. This scheme seems like it'll make that a
> > > bit more forgiving.
> > 
> > I certainly understand the need to make krb5 more forgiving, and
> > certainly if the KDC indicates that cifs/foo does not exist, then
> > guessing the DNS domain and asking for cifs/foo.<guessed domain> is
> > reasonable.  
> > 
> > > If the wrong guesses just end up slowing down the upcall, then I'm ok
> > > with that. If they potentially open a security hole then that's another
> > > matter entirely. That's my main question here -- are we opening up any
> > > vulnerabilities with this scheme?
> > 
> > Each time you second-guess the name, you open up a small security hole,
> > because you potentially allow a connection that was to be to a trusted
> > host to be impersonated by less trusted member of the same kerberos
> > realm.  For that reason, any client-side canonicalisation should be
> > strictly limited.  
> 
> While this is somewhat true, it is not always true. Sometimes
> convenience is more important. If a user wants to be sure to get to the
> right server he only has to provide the full fqdn, and the right match
> will be done. The only case when the wrong case may happen is when the
> user only provides the short name. But there isn't much you can do
> there, unless you want to flatly refuse to work if users do not give a
> fqdn.

Allowing the local domain to be appended seems quite reasonable, after
cifs/ is not found.  We could also follow the policy of the local
kerberos library for other applications.  

> > Furthermore, you may do more than just slow down the upcall - if you
> > connect to the right server with the wrong ticket (because you guessed
> > wrong - cifs vs host etc), the only way to find out is if the server
> > gives you a LOGON_FAILURE error, and I think this will be even harder to
> > debug. 
> 
> If cifs/ failed and later host/ also fails then there isn't much you can
> do anyway. You'd be right to complain if we tried host/ first. We are
> not doing that.

I still think we should never use host/.

> > I do want kerberos to be easier to use, and to 'just work' more often.
> > I care passionately that Kerberos should be both secure and 'just work'
> > - falling back to NTLM is an even worse fate.  
> > 
> > I just want to ensure we do not become the source of new expected
> > behaviour patterns for non-AD domains (such as looking up foo$ or
> > host/foo for cifs shares), as once we start, it will be very hard to
> > undo. 
> 
> hard in what sense ?

Patterns of server and administrator behaviour are in part set by
patterns of client behaviour.  Therefore, if Samba starts asking for foo
$ or host/foo tickets, then administrators attempting to debug failures
will start creating such principals in their non-AD KDCs, and soon it
becomes internet folklore and 'best practice'.  Once this starts, it is
very hard to undo, which is why I strongly advocate for doing the exact
minimum to make this work, and no more. 

No other cifs client asks for foo$ or host/, and Samba even stopped
doing so indirectly with 3.5.8 (using the server-supplied principal).  

Andrew Bartlett

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
