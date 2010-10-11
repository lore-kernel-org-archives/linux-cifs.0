From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/15] cifs: eliminate oflags option from
 cifs_new_fileinfo
Date: Mon, 11 Oct 2010 07:13:22 -0400
Message-ID: <20101011071322.3a6e090c@corrin.poochiereds.net>
References: <1286559072-29032-1-git-send-email-jlayton@redhat.com>
	<1286559072-29032-5-git-send-email-jlayton@redhat.com>
	<4CB2A392.9030400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CB2A392.9030400-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 11 Oct 2010 11:11:38 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 10/08/2010 11:01 PM, Jeff Layton wrote:
> > Eliminate the poor, misunderstood "oflags" option from cifs_new_fileinfo.
> > The callers mostly pass in the filp->f_flags here, except for one place
> > that passes in the flags after they've been converted to their SMB_O_*
> > equivalents.
> > 
> > None of these are correct however since we're checking that value for
> > the presence of FMODE_READ. Luckily that only affects how the f_list is
> > ordered. What it really wants here is the file->f_mode, but this check
> > really makes no sense whatsoever. FMODE_READ will be set for O_RDWR or
> > O_RDONLY opens. So this in effect just moves those to the front of the
> > list and leaves O_WRONLY at the end.
> > 
> > That might make some sense if anything actually paid attention to this
> > list order, but nothing does. find_readable_file and find_writable_file
> > both walk through the list in the same direction.
> > 
> > Let's just keep this simple and just put things on the list with
> > list_add.
> > 
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/cifsproto.h |    3 +--
> >  fs/cifs/dir.c       |   15 ++++-----------
> >  fs/cifs/file.c      |    5 ++---
> >  3 files changed, 7 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index 7f416ab..bed004c 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -107,8 +107,7 @@ extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
> >  
> >  extern struct cifsFileInfo *cifs_new_fileinfo(struct inode *newinode,
> >  				__u16 fileHandle, struct file *file,
> > -				struct tcon_link *tlink,
> > -				unsigned int oflags, __u32 oplock);
> > +				struct tcon_link *tlink, __u32 oplock);
> >  extern int cifs_posix_open(char *full_path, struct inode **pinode,
> >  				struct super_block *sb,
> >  				int mode, int oflags,
> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> > index c205ec9..452c9b5 100644
> > --- a/fs/cifs/dir.c
> > +++ b/fs/cifs/dir.c
> > @@ -132,7 +132,7 @@ cifs_bp_rename_retry:
> >  
> >  struct cifsFileInfo *
> >  cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
> > -		  struct tcon_link *tlink, unsigned int oflags, __u32 oplock)
> > +		  struct tcon_link *tlink, __u32 oplock)
> >  {
> >  	struct dentry *dentry = file->f_path.dentry;
> >  	struct cifsFileInfo *pCifsFile;
> > @@ -160,13 +160,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 fileHandle, struct file *file,
> >  	list_add(&pCifsFile->tlist, &(tlink_tcon(tlink)->openFileList));
> >  	pCifsInode = CIFS_I(newinode);
> >  	if (pCifsInode) {
> > -		/* if readable file instance put first in list*/
> > -		if (oflags & FMODE_READ)
> > -			list_add(&pCifsFile->flist, &pCifsInode->openFileList);
> > -		else
> > -			list_add_tail(&pCifsFile->flist,
> > -				      &pCifsInode->openFileList);
> > -
> > +		list_add(&pCifsFile->flist, &pCifsInode->openFileList);
> 
> find_readable_file() assumes that if it is a write-only file, it will be
> in the tail and it can break out of the loop. That needs to be fixed as
> well?
> 

Good catch. You're correct...

So I guess my assertion that nothing cares about the list order isn't
true. Is this optimization worth preserving?

My gut feeling is "no". The operations inside of find_readable_file are
sufficiently cheap that it's not worth the extra complexity, but I'm
willing to listen to arguments to the contrary...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
