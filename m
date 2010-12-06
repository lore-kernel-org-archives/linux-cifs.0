From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: linux-next: Tree for December 3 (cifs)
Date: Mon, 6 Dec 2010 07:35:13 -0500
Message-ID: <20101206073513.54ca2c71@tlielax.poochiereds.net>
References: <20101203130440.9f89dd31.sfr@canb.auug.org.au>
	<20101203094844.68f2bc40.randy.dunlap@oracle.com>
	<20101206070956.GA5570@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101206070956.GA5570-X9Un+BFzKDI@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 6 Dec 2010 08:09:56 +0100
Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org> wrote:

> 
> * Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Fri, 3 Dec 2010 13:04:40 +1100 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20101202:
> > 
> > 
> > When CIFS_EXPERIMENTAL is not enabled:
> > 
> > (.text+0xdf6c9): undefined reference to `get_cifs_acl'
> > 
> > from fs/cifs/xattr.c:cifs_getxattr()
> > 
> > 
> > CONFIG_CIFS=y
> > # CONFIG_CIFS_STATS is not set
> > CONFIG_CIFS_WEAK_PW_HASH=y
> > # CONFIG_CIFS_UPCALL is not set
> > CONFIG_CIFS_XATTR=y
> > CONFIG_CIFS_POSIX=y
> > # CONFIG_CIFS_DEBUG2 is not set
> > # CONFIG_CIFS_DFS_UPCALL is not set
> > CONFIG_CIFS_FSCACHE=y
> > CONFIG_CIFS_ACL=y
> > # CONFIG_CIFS_EXPERIMENTAL is not set
> 
> And this build regression has been pushed upstream now, as of:
> 
>    8520eeaa1235: Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
> 
> and it is triggering for me too:
> 
>    fs/built-in.o: In function `cifs_getxattr':
>    (.text+0xc518e): undefined reference to `get_cifs_acl'
> 
> The regression got introduced by:
> 
>    fbeba8bb16d7: cifs: Handle extended attribute name cifs_acl to generate cifs acl blob (try #4)
> 
> Which introduced the new CIFS_ACL option.
> 
> Thanks,
> 
> 	Ingo

Yeah, looks like this new Kconfig option depends on some code that's
under the (much-overloaded) CIFS_EXPERIMENTAL Kconfig option. I think
this patch needs some rework. The simple fix would be to make it
dependent on CIFS_EXPERIMENTAL, but that's rather icky since
CIFS_EXPERIMENTAL pulls in some rather broken stuff...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
