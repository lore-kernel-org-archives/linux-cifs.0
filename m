From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IPv6 mount support
Date: Sun, 14 Oct 2012 21:47:50 -0400
Message-ID: <CAFB9KM0K-L_E+zppOawzib88NfxryH75VBzg74Wtge8euGHFmw@mail.gmail.com>
References: <CAFB9KM2GbrVzE+UEatrV5-QH_iT_Vu4Z0=o3GmezEJo_uKsyWw@mail.gmail.com>
	<CAFB9KM2kFUO39TCmh5rHh8Y8yCoU=8hpw=ahnM_teCLkfTXsRg@mail.gmail.com>
	<20121012132203.1c39533d@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121012132203.1c39533d-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 12, 2012 at 1:22 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
> What if some component of the pathname has a ':' in it? For instance:
>
>     <ip6 address>:/share/foo:bar/baz/
>
> Personally, I'd rather see us deprecate the "nfs syntax". I don't see
> that that provides us any value. We've never documented that it was
> supported, so maybe a patch to warn for a couple of releases when
> someone uses it and then rip it out?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

If the pathname has a ':' in it, I'd want to yell at someone.  What
kind of sick person does that? :)
Honestly, I can think of a scenario where this kind of pathname is
somewhat likely; an iSCSI initiator exporting a target using its iSCSI
pathname which usually contain a few ':'s.  I'm sure that's not
common, but surely not unused.

I'll spin a patch Tuesday (I'm traveling Monday) and if anyone
disagrees with this behavior they can NAK it.

-- 
Peace and Blessings,
-Scott.
