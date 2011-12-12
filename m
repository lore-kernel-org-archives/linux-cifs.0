From: Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: ceph, cifs, nfs, fuse: boolean and / or confusion
Date: Mon, 12 Dec 2011 18:45:11 -0500
Message-ID: <1323733511.13849.19.camel@lade.trondhjem.org>
References: <4EE688FC.8090606@gmail.com>
	 <20111212152856.871a8301.akpm@linux-foundation.org>
	 <1323733153.13849.17.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: roel <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>,
	fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323733153.13849.17.camel-SyLVLa/KEI9HwK5hSS5vWB2eb7JE58TQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 2011-12-12 at 18:39 -0500, Trond Myklebust wrote:

> As far as NFS is concerned, it reverts a regression. NFS only used to
> run revalidate_file_size() for SEEK_END prior to commit
> 06222e491e663dac939f04b125c9dc52126a75c4. I accept that we now also need
> to run it for SEEK_HOLE and SEEK_DATA, but we've never had to do so for
> SEEK_SET and SEEK_CUR.

BTW: The regression exists in 3.1, so this is probably a stable
candidate...

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
www.netapp.com

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
