From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: ceph, cifs, nfs, fuse: boolean and / or confusion
Date: Tue, 13 Dec 2011 09:34:46 -0500
Message-ID: <20111213093446.02de1df1@tlielax.poochiereds.net>
References: <4EE688FC.8090606@gmail.com>
	<20111212152856.871a8301.akpm@linux-foundation.org>
	<1323733153.13849.17.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	roel <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>,
	fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	josef-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323733153.13849.17.camel-SyLVLa/KEI9HwK5hSS5vWB2eb7JE58TQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 12 Dec 2011 18:39:13 -0500
Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, 2011-12-12 at 15:28 -0800, Andrew Morton wrote: 
> > On Tue, 13 Dec 2011 00:06:36 +0100
> > roel <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 
> > > The test not SEEK_CUR or not SEEK_SET always evaluates to true
> > > 
> > > Signed-off-by: Roel Kluin <roel.kluin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  fs/ceph/file.c   |    2 +-
> > >  fs/cifs/cifsfs.c |    2 +-
> > >  fs/fuse/file.c   |    2 +-
> > >  fs/nfs/file.c    |    2 +-
> > >  4 files changed, 4 insertions(+), 4 deletions(-)
> > > 
> <snip> 
> > > diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> > > index eca56d4..606ef0f 100644
> > > --- a/fs/nfs/file.c
> > > +++ b/fs/nfs/file.c
> > > @@ -147,7 +147,7 @@ static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
> > >  	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
> > >  	 * the cached file length
> > >  	 */
> > > -	if (origin != SEEK_SET || origin != SEEK_CUR) {
> > > +	if (origin != SEEK_SET && origin != SEEK_CUR) {
> > >  		struct inode *inode = filp->f_mapping->host;
> > >  
> > >  		int retval = nfs_revalidate_file_size(inode, filp);
> > 
> > This fix will cause changed runtime behaviour, such as NFS no longer
> > running nfs_revalidate_file_size() for all seek modes.
> 
> As far as NFS is concerned, it reverts a regression. NFS only used to
> run revalidate_file_size() for SEEK_END prior to commit
> 06222e491e663dac939f04b125c9dc52126a75c4. I accept that we now also need
> to run it for SEEK_HOLE and SEEK_DATA, but we've never had to do so for
> SEEK_SET and SEEK_CUR.
> 
> I suspect the same is true of ceph, cifs etc...
> 

(cc'ing Josef Bacik on this too, since he made this change originally)

Agreed. The patch looks correct to me for NFS and CIFS at at least.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
