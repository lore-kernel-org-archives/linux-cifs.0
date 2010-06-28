From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 2/3] cifs: use CreationTime like an i_generation field
Date: Mon, 28 Jun 2010 09:47:31 -0400
Message-ID: <20100628094731.33b6b9c8@corrin.poochiereds.net>
References: <1277723413-23769-1-git-send-email-jlayton@redhat.com>
	<1277723413-23769-3-git-send-email-jlayton@redhat.com>
	<4C28A2F1.1040309@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C28A2F1.1040309@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 28 Jun 2010 18:56:09 +0530
Suresh Jayaraman <sjayaraman@suse.de> wrote:

> On 06/28/2010 04:40 PM, Jeff Layton wrote:
> > Reduce false inode collisions by using the CreationTime like an
> > i_generation field. This way, even if the server ends up reusing
> > a uniqueid after a delete/create cycle, we can avoid matching
> > the inode incorrectly.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  fs/cifs/cifsfs.c   |    2 ++
> >  fs/cifs/cifsglob.h |    2 ++
> >  fs/cifs/inode.c    |    6 ++++++
> >  fs/cifs/readdir.c  |    1 +
> >  4 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 484e52b..e409216 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -314,6 +314,8 @@ cifs_alloc_inode(struct super_block *sb)
> >  	cifs_inode->invalid_mapping = false;
> >  	cifs_inode->vfs_inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
> >  	cifs_inode->server_eof = 0;
> > +	cifs_inode->uniqueid = 0;
> > +	cifs_inode->createtime = 0;
> >  
> >  	/* Can not set i_flags here - they get immediately overwritten
> >  	   to zero by the VFS */
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index e15d7a5..a0fd2c2 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -382,6 +382,7 @@ struct cifsInodeInfo {
> >  	bool invalid_mapping:1;		/* pagecache is invalid */
> >  	u64  server_eof;		/* current file size on server */
> >  	u64  uniqueid;			/* server inode number */
> > +	u64  createtime;		/* creation time on server */
> >  	struct inode vfs_inode;
> >  };
> >  
> > @@ -499,6 +500,7 @@ struct cifs_fattr {
> >  	u64		cf_uniqueid;
> >  	u64		cf_eof;
> >  	u64		cf_bytes;
> > +	u64		cf_createtime;
> >  	uid_t		cf_uid;
> >  	gid_t		cf_gid;
> >  	umode_t		cf_mode;
> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > index f64b95f..35e2466 100644
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -487,6 +487,7 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
> >  
> >  	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
> >  	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
> > +	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
> >  
> >  	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
> >  		fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
> > @@ -727,6 +728,10 @@ cifs_find_inode(struct inode *inode, void *opaque)
> >  	if (CIFS_I(inode)->uniqueid != fattr->cf_uniqueid)
> >  		return 0;
> >  
> > +	/* use createtime like an i_generation field */
> > +	if (CIFS_I(inode)->createtime != fattr->cf_createtime)
> > +		return 0;
> > +
> >  	/* don't match inode of different type */
> >  	if ((inode->i_mode & S_IFMT) != (fattr->cf_mode & S_IFMT))
> >  		return 0;
> > @@ -750,6 +755,7 @@ cifs_init_inode(struct inode *inode, void *opaque)
> >  	struct cifs_fattr *fattr = (struct cifs_fattr *) opaque;
> >  
> >  	CIFS_I(inode)->uniqueid = fattr->cf_uniqueid;
> > +	CIFS_I(inode)->createtime = fattr->cf_createtime;
> >  	return 0;
> >  }
> >  
> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > index daf1753..8bd18be 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -160,6 +160,7 @@ cifs_dir_info_to_fattr(struct cifs_fattr *fattr, FILE_DIRECTORY_INFO *info,
> >  	fattr->cf_cifsattrs = le32_to_cpu(info->ExtFileAttributes);
> >  	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
> >  	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
> > +	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
> 
> cifs_std_info_to_fattr() needs this too?
> 


I don't think so. If we're using that function then we're probably
going to be using the legacy SMBQueryInformation calls too. Those do
not return a CreateTime and it ends up being set to 0. This *should*
do the right thing I think...

It would be nice to do this in a more definite way somehow though. The
legacy QPathInfo codepath is a bit of a mess...

> >  	fattr->cf_atime = cifs_NTtimeToUnix(info->LastAccessTime);
> >  	fattr->cf_ctime = cifs_NTtimeToUnix(info->ChangeTime);
> >  	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
> 
> 


-- 
Jeff Layton <jlayton@redhat.com>
