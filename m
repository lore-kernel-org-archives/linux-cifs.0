From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs.upcall: attempt to use AD-style service
 principals
Date: Thu, 17 Nov 2011 21:16:40 +1100
Message-ID: <1321525044.20295.11.camel@ruth>
References: <1321233448-13548-1-git-send-email-jlayton@samba.org>
	 <1321237738.11559.31.camel@ruth>
	 <1321240351.3953.803.camel@pico.li.ssimo.org>
	 <20111114094449.66a35717@tlielax.poochiereds.net>
	 <1321310728.5973.29.camel@ruth>
	 <1321311883.3953.886.camel@pico.li.ssimo.org>
	 <1321319411.5973.38.camel@ruth>
	 <20111115091510.167a9435@tlielax.poochiereds.net>
	 <1321393046.5973.76.camel@ruth>
	 <1321459686.3953.1053.camel@pico.li.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321459686.3953.1053.camel-akOVU7JyYd8WIfilqQrPtNi2O/JbrIOy@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2011-11-16 at 11:08 -0500, simo wrote:
> On Wed, 2011-11-16 at 08:37 +1100, Andrew Bartlett wrote: 
> > On Tue, 2011-11-15 at 09:15 -0500, Jeff Layton wrote:
> > 
> > > Ok, based on the comments so far, how does this sound for a potential
> > > scheme:
> > > 
> > > 	INPUT: foo
> > > 	TRY:
> > > 	    FOO$
> > > 	    cifs/foo.[guessed domain]
> > > 
> > >	INPUT: foo.example.com
> > > 	TRY:
> > > 	    cifs/foo.example.com
> > > 
> > > To summarize, for shortnames, we'd try SHORTNAME$ first. If that fails,
> > > then guess a domain name, append the value to the hostname, and prepend
> > > it with "cifs/".
> > 
> > No, we should never use FOO$ (this is AD only, and equivalent to
> > cifs/foo), so we should instead simply do:
> > 
> > INPUT: foo
> > TRY:
> >     cifs/foo
> 
> This ^^^^ is also AD-only, so what's the point of objecting to one or
> another ?
> At least when you see FOO$@REALM, admins know it is an AD only thing.

The reason that we should not translate between foo and foo$ on the
client side is that a server may have multiple service principal names.
A host with multiple names will have only one machine account in AD, and
we have no way to know that this particular name is that of the machine
account.

Also, while requests for cifs/foo will cause a lookup of host/foo and
foo$ on the server side, this is a server-side fallback, not an absolute
rule.  If an account has the more specific form as a
servicePrincipalName, then implicit mappings are not needed.  We cannot
on a client make assumptions about how the administrator has configured
their domain.

Finally, cifs/foo is a perfectly valid and reasonable kerberos service
principal name, and the name that other cifs clients such as Samba 3.6,
and Windows will use, and so we should ensure constancy with those
clients to reduce the administrator burden in the non-AD case. 

Indeed, it is this final reason why this process is futile.  The correct
fix is to ensure that the non-AD KDC has principal entries for each
aliases (cifs/foo and cifs/foo.domain) by which the server can be
resolved. 

Andrew Bartlett

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
