From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] KEYS/DNS: Fix ____call_usermodehelper() to not lose the session keyring
Date: Fri, 17 Jun 2011 10:56:51 +0100
Message-ID: <23040.1308304611@redhat.com>
References: <BANLkTimxJ5kHOODSPqRPcgbObjZbfT59uw@mail.gmail.com> <20110616235600.14345.16839.stgit@warthog.procyon.org.uk>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org,
	shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimxJ5kHOODSPqRPcgbObjZbfT59uw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:

> PS. Possibly it might make more sense to just put the "struct cred *"
> pointer into the "struct subprocess_info" and not change any of the
> function prototypes at all?

That's the way I did it originally, but someone thought doing it with an init
function was a better idea:-/

Your suggestion is slightly complicated by the capability restriction stuff
that caused the breakage.  That needs to hack the creds at some point.

David
