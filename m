From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs.upcall: attempt to use AD-style service
 principals
Date: Wed, 16 Nov 2011 08:37:24 +1100
Message-ID: <1321393046.5973.76.camel@ruth>
References: <1321233448-13548-1-git-send-email-jlayton@samba.org>
	 <1321237738.11559.31.camel@ruth>
	 <1321240351.3953.803.camel@pico.li.ssimo.org>
	 <20111114094449.66a35717@tlielax.poochiereds.net>
	 <1321310728.5973.29.camel@ruth>
	 <1321311883.3953.886.camel@pico.li.ssimo.org>
	 <1321319411.5973.38.camel@ruth>
	 <20111115091510.167a9435@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111115091510.167a9435-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2011-11-15 at 09:15 -0500, Jeff Layton wrote:

> Ok, based on the comments so far, how does this sound for a potential
> scheme:
> 
> 	INPUT: foo
> 	TRY:
> 	    FOO$
> 	    cifs/foo.[guessed domain]
> 
>	INPUT: foo.example.com
> 	TRY:
> 	    cifs/foo.example.com
> 
> To summarize, for shortnames, we'd try SHORTNAME$ first. If that fails,
> then guess a domain name, append the value to the hostname, and prepend
> it with "cifs/".

No, we should never use FOO$ (this is AD only, and equivalent to
cifs/foo), so we should instead simply do:

INPUT: foo
TRY:
    cifs/foo
    cifs/foo.[guessed domain]

INPUT: foo.example.com
TRY:
    cifs/foo.example.com

I would prefer that the kerberos client library actually did this (as
then it would 'just work' for all other kerberos applications), but
sadly the behaviour here is not always what you expect, and can use
reverse DNS (which is an even worse fate).  See the rdns option in
krb5.conf (which I typically turn off). 

Andrew Bartlett
-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org
