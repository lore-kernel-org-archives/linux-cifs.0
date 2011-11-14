From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs.upcall: attempt to use AD-style service
 principals
Date: Mon, 14 Nov 2011 09:44:49 -0500
Message-ID: <20111114094449.66a35717@tlielax.poochiereds.net>
References: <1321233448-13548-1-git-send-email-jlayton@samba.org>
	<1321237738.11559.31.camel@ruth>
	<1321240351.3953.803.camel@pico.li.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321240351.3953.803.camel-akOVU7JyYd8WIfilqQrPtNi2O/JbrIOy@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 13 Nov 2011 22:12:31 -0500
simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On Mon, 2011-11-14 at 13:28 +1100, Andrew Bartlett wrote: 
> > On Sun, 2011-11-13 at 20:17 -0500, Jeff Layton wrote:
> > > We've had a request recently to allow cifs.upcall to use AD-style
> > > service principals. While trying to nail down what they need, I asked
> > > Simo his opinion on how best to pick a service principal for a given
> > > hostname. His suggestion was:
> > > 
> > > 	INPUT: fooo
> > > 	TRY in order:
> > >   		FOOO$@REALM
> > > 		cifs/fooo.<guessed domain ?>@REALM
> > >   		host/fooo.<guessed domain ?>@REALM
> > > 
> > > 	INPUT: bar.example.com
> > > 	TRY in order:
> > > 		cifs/bar.example.com@REALM
> > > 		BAR$@REALM
> > > 		host/bar.example.com@REALM
> > > 
> > > This patchset attempts to embody that logic.
> > > 
> > > Suggestions welcome. Those reviewing it, please pay particular attention
> > > to the scheme for guessing a domain name. I want to make certain that
> > > we're not opening up any security holes with that scheme.
> > 
> > Perhaps I'm missing some background, but this looks wrong to me, at
> > least for the pure AD case.  
> > 
> > First, in AD cifs/ is an alias of host/, so looking for both will not
> > help.  Secondly, looking for bar$ is an outright guess, as there is no
> > reliable mapping between a long name in DNS and the short
> > samAccountName.
> > 
> > If we map wrongly, we might luck out and get a KDC error indicating no
> > such host, or we might fail at session setup time, with logon failure. 
> > 
> > What is wrong with simply requesting a principal of cifs/INPUT@REALM?
> > In AD, the KDC does all the canonicalisation work (perhaps I should have
> > clarified this in the previous thread).
> 
> What is wrong is that it works only with AD. The above heuristics should
> allow more flexibility against both AD and samba servers configured to
> use other KDCs.
> 

The above scheme isn't perfect, but in many cases it will happen to
work. It's true that there's no reliable mapping between DNS and
samAccountName, but in a lot of cases the samAccountName *is* the
capitalized host portion of the DNS name. Does it hurt anything to
attempt to get a ticket with that name if "cifs/fqdn" fails?

Over the years, we've seen a lot of confused users on the list who are
not sure what name they need to put in the host portion of the UNC to
get their krb5 mount to work. This scheme seems like it'll make that a
bit more forgiving.

If the wrong guesses just end up slowing down the upcall, then I'm ok
with that. If they potentially open a security hole then that's another
matter entirely. That's my main question here -- are we opening up any
vulnerabilities with this scheme?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
