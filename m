From: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs.upcall: attempt to use AD-style service
 principals
Date: Wed, 16 Nov 2011 11:08:06 -0500
Message-ID: <1321459686.3953.1053.camel@pico.li.ssimo.org>
References: <1321233448-13548-1-git-send-email-jlayton@samba.org>
	 <1321237738.11559.31.camel@ruth>
	 <1321240351.3953.803.camel@pico.li.ssimo.org>
	 <20111114094449.66a35717@tlielax.poochiereds.net>
	 <1321310728.5973.29.camel@ruth>
	 <1321311883.3953.886.camel@pico.li.ssimo.org>
	 <1321319411.5973.38.camel@ruth>
	 <20111115091510.167a9435@tlielax.poochiereds.net>
	 <1321393046.5973.76.camel@ruth>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321393046.5973.76.camel@ruth>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2011-11-16 at 08:37 +1100, Andrew Bartlett wrote: 
> On Tue, 2011-11-15 at 09:15 -0500, Jeff Layton wrote:
> 
> > Ok, based on the comments so far, how does this sound for a potential
> > scheme:
> > 
> > 	INPUT: foo
> > 	TRY:
> > 	    FOO$
> > 	    cifs/foo.[guessed domain]
> > 
> >	INPUT: foo.example.com
> > 	TRY:
> > 	    cifs/foo.example.com
> > 
> > To summarize, for shortnames, we'd try SHORTNAME$ first. If that fails,
> > then guess a domain name, append the value to the hostname, and prepend
> > it with "cifs/".
> 
> No, we should never use FOO$ (this is AD only, and equivalent to
> cifs/foo), so we should instead simply do:
> 
> INPUT: foo
> TRY:
>     cifs/foo

This ^^^^ is also AD-only, so what's the point of objecting to one or
another ?
At least when you see FOO$@REALM, admins know it is an AD only thing.

> cifs/foo.[guessed domain]
> 
> INPUT: foo.example.com
> TRY:
>     cifs/foo.example.com
> 
> I would prefer that the kerberos client library actually did this (as
> then it would 'just work' for all other kerberos applications), but
> sadly the behaviour here is not always what you expect, and can use
> reverse DNS (which is an even worse fate).  See the rdns option in
> krb5.conf (which I typically turn off). 
> 
> Andrew Bartlett


-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Principal Software Engineer at Red Hat, Inc. <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
