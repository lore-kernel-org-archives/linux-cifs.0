From: Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: ceph, cifs, nfs, fuse: boolean and / or confusion
Date: Mon, 12 Dec 2011 18:39:13 -0500
Message-ID: <1323733153.13849.17.camel@lade.trondhjem.org>
References: <4EE688FC.8090606@gmail.com>
	 <20111212152856.871a8301.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: roel <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>,
	fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111212152856.871a8301.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2011-12-12 at 15:28 -0800, Andrew Morton wrote: 
> On Tue, 13 Dec 2011 00:06:36 +0100
> roel <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > The test not SEEK_CUR or not SEEK_SET always evaluates to true
> > 
> > Signed-off-by: Roel Kluin <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >  fs/ceph/file.c   |    2 +-
> >  fs/cifs/cifsfs.c |    2 +-
> >  fs/fuse/file.c   |    2 +-
> >  fs/nfs/file.c    |    2 +-
> >  4 files changed, 4 insertions(+), 4 deletions(-)
> > 
<snip> 
> > diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> > index eca56d4..606ef0f 100644
> > --- a/fs/nfs/file.c
> > +++ b/fs/nfs/file.c
> > @@ -147,7 +147,7 @@ static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
> >  	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
> >  	 * the cached file length
> >  	 */
> > -	if (origin != SEEK_SET || origin != SEEK_CUR) {
> > +	if (origin != SEEK_SET && origin != SEEK_CUR) {
> >  		struct inode *inode = filp->f_mapping->host;
> >  
> >  		int retval = nfs_revalidate_file_size(inode, filp);
> 
> This fix will cause changed runtime behaviour, such as NFS no longer
> running nfs_revalidate_file_size() for all seek modes.

As far as NFS is concerned, it reverts a regression. NFS only used to
run revalidate_file_size() for SEEK_END prior to commit
06222e491e663dac939f04b125c9dc52126a75c4. I accept that we now also need
to run it for SEEK_HOLE and SEEK_DATA, but we've never had to do so for
SEEK_SET and SEEK_CUR.

I suspect the same is true of ceph, cifs etc...

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
www.netapp.com
