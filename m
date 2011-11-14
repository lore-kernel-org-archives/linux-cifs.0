From: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs.upcall: attempt to use AD-style service
 principals
Date: Mon, 14 Nov 2011 18:04:42 -0500
Message-ID: <1321311883.3953.886.camel@pico.li.ssimo.org>
References: <1321233448-13548-1-git-send-email-jlayton@samba.org>
	 <1321237738.11559.31.camel@ruth>
	 <1321240351.3953.803.camel@pico.li.ssimo.org>
	 <20111114094449.66a35717@tlielax.poochiereds.net>
	 <1321310728.5973.29.camel@ruth>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321310728.5973.29.camel@ruth>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2011-11-15 at 09:45 +1100, Andrew Bartlett wrote: 
> On Mon, 2011-11-14 at 09:44 -0500, Jeff Layton wrote:
> 
> > The above scheme isn't perfect, but in many cases it will happen to
> > work. It's true that there's no reliable mapping between DNS and
> > samAccountName, but in a lot of cases the samAccountName *is* the
> > capitalized host portion of the DNS name. Does it hurt anything to
> > attempt to get a ticket with that name if "cifs/fqdn" fails?
> 
> We should never ask for a machine$ name.  It is always the wrong thing
> to do, because it will only exist on AD servers, which already do the
> mapping between cifs/foo and foo$ internally.  

You are contradicting yourself here.
First you say foo may not be the short name then you advocate for not
using foo$. But asking for foo$ comes handly exactly when the short name
is not the same as the fqdn truncated, as a use may pass on the command
line and that's why it was added.

> We should also not map between cifs/ and host/ - cifs/ is a separate
> service, just as nfs/ and http/ are. 

And yet it is possible to have cifs servers work when using the host/
ticket. Trying and failing is not a big deal.

> > Over the years, we've seen a lot of confused users on the list who are
> > not sure what name they need to put in the host portion of the UNC to
> > get their krb5 mount to work. This scheme seems like it'll make that a
> > bit more forgiving.
> 
> I certainly understand the need to make krb5 more forgiving, and
> certainly if the KDC indicates that cifs/foo does not exist, then
> guessing the DNS domain and asking for cifs/foo.<guessed domain> is
> reasonable.  
> 
> > If the wrong guesses just end up slowing down the upcall, then I'm ok
> > with that. If they potentially open a security hole then that's another
> > matter entirely. That's my main question here -- are we opening up any
> > vulnerabilities with this scheme?
> 
> Each time you second-guess the name, you open up a small security hole,
> because you potentially allow a connection that was to be to a trusted
> host to be impersonated by less trusted member of the same kerberos
> realm.  For that reason, any client-side canonicalisation should be
> strictly limited.  

While this is somewhat true, it is not always true. Sometimes
convenience is more important. If a user wants to be sure to get to the
right server he only has to provide the full fqdn, and the right match
will be done. The only case when the wrong case may happen is when the
user only provides the short name. But there isn't much you can do
there, unless you want to flatly refuse to work if users do not give a
fqdn.

> Furthermore, you may do more than just slow down the upcall - if you
> connect to the right server with the wrong ticket (because you guessed
> wrong - cifs vs host etc), the only way to find out is if the server
> gives you a LOGON_FAILURE error, and I think this will be even harder to
> debug. 

If cifs/ failed and later host/ also fails then there isn't much you can
do anyway. You'd be right to complain if we tried host/ first. We are
not doing that.

> I do want kerberos to be easier to use, and to 'just work' more often.
> I care passionately that Kerberos should be both secure and 'just work'
> - falling back to NTLM is an even worse fate.  
> 
> I just want to ensure we do not become the source of new expected
> behaviour patterns for non-AD domains (such as looking up foo$ or
> host/foo for cifs shares), as once we start, it will be very hard to
> undo. 

hard in what sense ?

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Principal Software Engineer at Red Hat, Inc. <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
