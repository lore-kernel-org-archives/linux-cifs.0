From: utz lehmann <lkml123-4es5y7D8suKELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended file stats available [ver #6]
Date: Sun, 01 Aug 2010 18:18:44 +0200
Message-ID: <1280679524.2464.49.camel@segv.aura.of.mankind>
References: <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	 <30448.1279800887@redhat.com> <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
	 <AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>
	 <E1Obxpd-00CRIo-SF@intern.SerNet.DE>
	 <AANLkTimwIq0pBhCeOjOVjB0y  <1280603032.3125.24.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Phil Pishioneri <pgp-8DAjSxpRXgY@public.gmane.org>,
	Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-41N18TsMXrtuMpJDpNschA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280603032.3125.24.camel-rJ7iovZKK19ZJLDQqaL3InhyD016LWXt@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2010-07-31 at 15:03 -0400, Trond Myklebust wrote:
> Sigh... So please explain how it would be useful to export that
> particular filesystem through _both_ CIFS and NFS?
> 
> My point was that in most circumstances you want to export either
> through CIFS or through NFS, but very rarely both.

It common in heterogeneous networks. Linux clients uses NFS. Windows
clients uses CIFS. Both working on the same data.

And even the better ones of these small SATA NAS boxes support NFS and
CIFS for the same volumes.

utz
