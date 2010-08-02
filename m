From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Remove __exit mark from cifs_exit_dns_resolver()
Date: Mon, 02 Aug 2010 10:17:56 +0100
Message-ID: <1253.1280740676@redhat.com>
References: <20100801124059.GA7977@pengutronix.de> <20100730142519.18287.22053.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Uwe =?us-ascii?Q?=3D=3Fiso-8859-1=3FQ=3FKleine-K=3DF6nig=3F=3D?=
	<u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100801124059.GA7977-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Uwe Kleine-K=F6nig <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org> wrote:

> From time to time I think about introducing something like
> __init_or_exit that puts a function into .init.text if .exit.text is
> discarded.  Is it worth the effort?

It might be worth including __exit stuff in __init if we would otherwis=
e have
discarded it.  Otherwise there's liable to be a bunch of stuff that we =
could
otherwise discard left hanging around permanently.  But your suggestion=
 would
work too.

David
