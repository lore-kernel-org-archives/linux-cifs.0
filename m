From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] KEYS/DNS: Fix ____call_usermodehelper() to not lose the
 session keyring
Date: Thu, 16 Jun 2011 17:26:21 -0700
Message-ID: <BANLkTimxJ5kHOODSPqRPcgbObjZbfT59uw@mail.gmail.com>
References: <20110616235600.14345.16839.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org,
	shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110616235600.14345.16839.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jun 16, 2011 at 4:56 PM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> ____call_usermodehelper() now erases any credentials set by the
> subprocess_inf::init() function. =A0The problem is that:

I absolutely puke looking at this patch.  It makes me want to dig out
my eyes with a spoon.

Yes, we had that nasty "umh" TLA before too, but it was mostly hidden
and private and kept a fairly low profile (ie only in that
wait-related enum). This makes it _truly_ barf-worthy by combining it
with a couple of new ugly function typedefs.

There really isn't any prize for the ugliest infrastructure ever.
Please just remove the pointless and ugly typedefs that are used in
just a couple of places. And in most of those cases it just makes the
code actually less readable (ie it's now totally impossible to see
what the type for the passed-in function pointers are, because it's
hidden behind that opaque type.

The only real reason to use typedefs in the kernel is if you really
have *different* types behind them, and explicitly want to make the
type more opaque. Yeah, we've occasionally broken that rule, but it's
almost always been a mistake when we do.

                                 Linus

PS. Possibly it might make more sense to just put the "struct cred *"
pointer into the "struct subprocess_info" and not change any of the
function prototypes at all?
