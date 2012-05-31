From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: ANNOUNCE: cifs-utils release 5.5 is ready for download
Date: Thu, 31 May 2012 11:19:42 +0530
Message-ID: <4FC70676.20504@suse.com>
References: <20120530063713.10a9f796@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120530063713.10a9f796-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 05/30/2012 04:07 PM, Jeff Layton wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1

> 
> I'm starting to have doubts as to whether it's a good idea to keep
> - -Werror in the default CFLAGS. This is built in a large range of
> environments and with a large range of different tool versions.
> Catching all of the warnings can be difficult.

Yeah, I'm having my doubts too, now.

> I've left that flag in place for now, but if it's causing significant
> pain for anyone then please speak up, and we might remove it in a later
> release.
> 

There is no significant pain for me, but I'm little worried about
cifs-utils not being to able to build successfully in different
environments (due to -Werror being default) which we won't be able to
test and verify anyway.

Perhaps, we can decide not to keep -Werror as the default flag but
ensure that we (maintainers/developers) run with this enabled from
time-to-time to ensure that real problems are not sneaking in.

Another way to approach is to leave the flag as-is for a while so that
we can catch all of these as they will probably be reported anyway.

The former sounds more user friendly than the latter. But, I don't have
any strong opinions on either.


Thanks
Suresh
