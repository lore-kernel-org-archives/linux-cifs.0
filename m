From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow mounts for paths for restricted
 intermediate paths
Date: Thu, 13 Mar 2014 16:57:15 -0400
Message-ID: <20140313165715.4bab6110@tlielax.poochiereds.net>
References: <1384878813-7413-1-git-send-email-shirishpargaonkar@gmail.com>
	<20131119155923.31181d93@tlielax.poochiereds.net>
	<CADT32eL5R3oFiH9ZO8hK=+QA7wcjCHQbfCFn0W9+o3VH4YfXnw@mail.gmail.com>
	<20140312150436.610544ed@tlielax.poochiereds.net>
	<CADT32eLvot8Qd_4OJ0gt5dD-d9GQiJjQPv593Wt+mu2mHNp92w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLvot8Qd_4OJ0gt5dD-d9GQiJjQPv593Wt+mu2mHNp92w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 13 Mar 2014 10:35:59 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Mar 12, 2014 at 2:04 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Wed, 12 Mar 2014 12:38:02 -0500
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Tue, Nov 19, 2013 at 2:59 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> > On Tue, 19 Nov 2013 10:33:33 -0600
> >> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >> >
> >> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >>
> >> >>
> >> >> Allow cifs mounts for a prefixpath with intermediate paths without access,
> >> >> so as to continue with the shared superblock model.
> >> >>
> >> >> For the intermediate path entries that do not allow access, create "placeholder"
> >> >> inodes and instantiate dentries with those inodes.
> >> >> If and when such a path entry becomes accessible it is filled with correct
> >> >> info.
> >> >>
> >> >
> >> > I'm unclear on this last bit...
> >> >
> >> > How exactly do they end up being filled with the correct info once that
> >> > happens?
> >> >
> >> >> Reference: Samba bugzilla 6950
> >> >>
> >> >> Signed-off-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
> >> >>
> >> >> ---
> >> >>  fs/cifs/cifsfs.c    | 17 +++++++++++++++--
> >> >>  fs/cifs/cifsproto.h |  3 +++
> >> >>  fs/cifs/inode.c     | 16 ++++++++++++++++
> >> >>  3 files changed, 34 insertions(+), 2 deletions(-)
> >> >>
> >> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> >> index 849f613..bce185c 100644
> >> >> --- a/fs/cifs/cifsfs.c
> >> >> +++ b/fs/cifs/cifsfs.c
> >> >> @@ -584,6 +584,9 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
> >> >>       char *full_path = NULL;
> >> >>       char *s, *p;
> >> >>       char sep;
> >> >> +     struct inode *dir, *phinode;
> >> >> +     struct dentry *child;
> >> >> +     struct cifs_fattr phfattr;
> >> >>
> >> >>       full_path = cifs_build_path_to_root(vol, cifs_sb,
> >> >>                                           cifs_sb_master_tcon(cifs_sb));
> >> >> @@ -592,13 +595,13 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
> >> >>
> >> >>       cifs_dbg(FYI, "Get root dentry for %s\n", full_path);
> >> >>
> >> >> +     fill_phfattr(&phfattr, sb);
> >> >
> >> > Hmmm...so this function sets up a cifs_fattr struct, including the
> >> > cf_uniqueid...which won't be very unique when you reuse that struct
> >> > several times in the do...while loop below. Don't you need to call it
> >> > again after you use it once?
> >> >
> >> >>       sep = CIFS_DIR_SEP(cifs_sb);
> >> >>       dentry = dget(sb->s_root);
> >> >>       p = s = full_path;
> >> >>
> >> >>       do {
> >> >> -             struct inode *dir = dentry->d_inode;
> >> >> -             struct dentry *child;
> >> >> +             dir = dentry->d_inode;
> >> >>
> >> >>               if (!dir) {
> >> >>                       dput(dentry);
> >> >> @@ -626,6 +629,16 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
> >> >>               mutex_unlock(&dir->i_mutex);
> >> >>               dput(dentry);
> >> >>               dentry = child;
> >> >> +             if (!IS_ERR(dentry)) {
> >> >> +                     if (*s) {
> >> >> +                             /* EACCESS on an intermediate dir */
> >> >> +                             if (!dentry->d_inode) {
> >> >> +                                     phinode = cifs_iget(sb, &phfattr);
> >> >> +                                     if (phinode)
> >> >> +                                             d_instantiate(dentry, phinode);
> >> >> +                             }
> >> >> +                     }
> >> >> +             }
> >> >
> >> > This doesn't make any sense to me.
> >> >
> >> > The do...while loop here is basically doing lookups and instantiating
> >> > dentries and inodes down from the root of the mount to the root of the
> >> > share. The lookup_one_len call is what does the single-level lookup in
> >> > that directory.
> >> >
> >> > Why are you adding special handling when "dentry" is not an error?
> >> > Would it not make more sense to do so when lookup_one_len does return
> >> > an error?
> >> >
> >> >>       } while (!IS_ERR(dentry));
> >> >>       kfree(full_path);
> >> >>       return dentry;
> >> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >> >> index aa33976..9a84e5c 100644
> >> >> --- a/fs/cifs/cifsproto.h
> >> >> +++ b/fs/cifs/cifsproto.h
> >> >> @@ -498,4 +498,7 @@ void cifs_writedata_release(struct kref *refcount);
> >> >>  int open_query_close_cifs_symlink(const unsigned char *path, char *pbuf,
> >> >>                       unsigned int *pbytes_read, struct cifs_sb_info *cifs_sb,
> >> >>                       unsigned int xid);
> >> >> +
> >> >> +extern void fill_phfattr(struct cifs_fattr *, struct super_block *);
> >> >> +
> >> >>  #endif                       /* _CIFSPROTO_H */
> >> >> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> >> >> index 36f9ebb..4f5a09a 100644
> >> >> --- a/fs/cifs/inode.c
> >> >> +++ b/fs/cifs/inode.c
> >> >> @@ -322,6 +322,22 @@ cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
> >> >>       fattr->cf_flags |= CIFS_FATTR_DFS_REFERRAL;
> >> >>  }
> >> >>
> >> >> +void
> >> >> +fill_phfattr(struct cifs_fattr *cf, struct super_block *sb)
> >> >> +{
> >> >> +     struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
> >> >> +
> >> >> +     memset(cf, 0, sizeof(*cf));
> >> >> +     cf->cf_uniqueid = iunique(sb, ROOT_I);
> >> >
> >> >
> >> > Also, iunique is only guaranteed to return a number that hasn't yet
> >> > been used. So suppose we're going to instantiate one of these bogus
> >> > inodes. We give it the uniqueid of '3'. Then later, once the mount is
> >> > done we find another (legitimate) inode on the server and it also has a
> >> > uniqueid of '3'. Now you have a collision. Worse yet, if it's a
> >> > directory now it looks like we have a hardlinked directory...
> >> >
> >> > Once you start using iunique, you can't really go back to using server
> >> > inode numbers since you can't guarantee that there won't be collisions.
> >> >
> >> > One possibility to deal with that would be to tag these entries as
> >> > bogus and ensure that cifs_iget will never match them. Another
> >> > possibility might be just to never hash these inodes, but I'm not clear
> >> > on how kosher that is from a vfs standpoint.
> >> >
> >> >> +     cf->cf_nlink = 1;
> >> >> +     cf->cf_atime = CURRENT_TIME;
> >> >> +     cf->cf_ctime = CURRENT_TIME;
> >> >> +     cf->cf_mtime = CURRENT_TIME;
> >> >> +     cf->cf_mode = S_IFDIR | S_IXUGO | S_IRWXU;
> >> >> +     cf->cf_uid = cifs_sb->mnt_uid;
> >> >> +     cf->cf_gid = cifs_sb->mnt_gid;
> >> >> +}
> >> >> +
> >> >
> >> >
> >> >>  static int
> >> >>  cifs_get_file_info_unix(struct file *filp)
> >> >>  {
> >> >
> >> >
> >>
> >> > I think the thing to do is to step back and describe (in English) how
> >> > you envision this working. Then once that's done, we can start
> >> > discussing what the code should look like...
> >> >
> >> > --
> >> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>
> >> Trying to solve this using like this:
> >>
> >> If during mounting a share, if the share path is accessbile but
> >> if any of the intermediate paths to the share is inaccessible
> >> i.e. returns error EACCES,
> >>  - get inode info for the share path using query path info
> >>  - look for a dentry and if not found, add - using d_obtain_alias()
> >>  - if server does not support unique ids/ inode numbers, add to the
> >>    begining of the list maintained in superblock, an element consisting of
> >>    full path, pointer to this dentry, and a pointer to the inode.
> >>
> >> During lookup,
> >>  for a case where server does support unique_ids/inode numbers,
> >>  - obtain inode info using query path info
> >>  - splice (d_splice_alias()) the dentry corrosponding to this inode if any
> >>    if spliced, remove the element from the list maintained in the superblock.
> >>
> >>  for a case where server does not support unique id/inode number,
> >>  - search for an entry for inode based on the full path
> >>    if no such entry, obtain inode info using query path info
> >>  - splice (d_splice_alias()) the dentry corrosponding to this inode if any
> >>    if successful, remove the element from the list maintained in the superblock.
> >>
> >>    That is one way an element will come off of the list maintained in the
> >>    superblock.  If the dentry does not get ever get spliced, whenever either
> >>    it is deleted with zero d_count (unmount e.g.) or it is released
> >>    (superblock is being deleted), cifs d_delete and cifs_d_release
> >>    respectively, whichever applies first, will take the element off the list
> >>    and free it.
> >>
> >>    If the superblock is intact and anonymous root dentry does not get deleted
> >>    during unmount (d_count is not zero i.e. has child dentries with referenece
> >>    to the parent) i.e. d_delete does not get called, the dentries would remain
> >>    till vfs code deletes them as needed (as their d_count starts approaching
> >>    zero).
> >>
> >>    Whenever we have the same mount again with a anonymous dentry, the
> >>    elements are added to the head of the list maintained in the superblock,
> >>    so stale elements will not be reachable.
> >>
> >> Your comments are most welcome.
> >>
> >> Regards,
> >>
> >> Shirish
> >
> > Really, the whole problem boils down to this:
> >
> > Suppose we mount two cifs mounts:
> >
> >     //server/a on /mnt/a
> >
> > ...and...
> >
> >     //server/a/b on /mnt/b
> >
> > Now suppose there is a directory under there:
> >
> >     /mnt/a/b/c
> >
> > ...so logically, this should be the same dentry:
> >
> >     /mnt/b/c
> >
> > The problem is -- how do you know that that's the same dentry?
> 
> So this will be a problem only if a dentry for c is not in dcache,
> is that correct?
> 

No, it's a problem either way. Let's say you mount /mnt/b first. You
don't have an inode for "a" because your creds don't allow you to look
it up. So, you have to either instantiate "b" as a disconnected dentry
(I may have the wrong terminology here), or fake up "a" somehow so it
can be set up as the parent of "b".

The problem comes in later when you go to mount /mnt/a, and then the
user walks into /mnt/a/b. At that point you don't want a new dentry for
"b", you want to get the "b" that got instantiated when you did the
first mount, but how do you know they're one in the same so you can
splice it correctly into the hierarchy?

Note that this example is relatively simple, but sprinkle in some
renames/recreates of directories on the server and dentries that are
farther down in the directory tree and things get nastier to handle.


> If so, the problem arises when two lookups for c for two different
> paths go out on the wire because a dentry for c is not in the cache.
> So in that case, in cifs code, can we serialize instantiating a dentry
> i.e. check for a dentry in dcache just before instantiating and if it is,
> discard the inode?
> dentries would be unique with their d_parent and d_name combination.
> 

I don't get it. I don't see how serializing things makes any difference
at all. Part of the problem is that the client has no control over
things that happen on other clients or on the server. Those kind of
changes are very difficult to guard against and we always have to be
prepared for them to occur.

> >
> > The reason that the shared superblock stuff works with NFS is that
> > there is a 1:1 correspondence between inodes and filehandles. So, even
> > if the file is renamed on the server, you end up with the same inode
> > and can tell that that dentry is the same as another.
> >
> > That's more or less the case for CIFS too where you have a uniqueid,
> > but when you don't that whole model breaks down.
> >
> > Hashing filenames sounds like a possibility too, but what happens if
> > someone does this on the directory above on the server?
> >
> >     $ mv c d
> >
> 
> Assuming using hashing full path names to generate uniqueids, if above happens,
> would not revalidation of the dentry (for c) fail on the client so we
> will end up discarding
> the inode and dentry and a creating a new dentry with correct d_name
> and an inode with
> hashed full pathname unique_id during lookup?
> 

Not necessarily. What would cause d_revalidate to fail in that case? In
any case cifs d_revalidate is pretty iffy...

> In above case, wonder how NFS updates d_name of a dentry with the same inode!
> 

Sorry, I don't quite follow this question. With NFS, we basically look
at the parent directory and if it has changed since the dentry was
instantiated, we toss out the dentry and redo the lookup.

> 
> > Since you can't guard against changes to lookup information on the
> > server that makes that method of uniquely id'ing an inode pretty
> > worthless.
> >
> > I think that really leaves you with just two choices:
> >
> > 1) figure out some mechanism to hook things up at mount time.
> > Basically, instantiate "placeholder" inodes for directories above the
> > root of the mount. IOW, if someone mounts /mnt/b above and then you'd
> > need a placeholder inode for "a" that will be filled out when /mnt/a
> > mounted.
> >
> > 2) abandon the shared-superblock model altogether. That'll mean that in
> > the above mount setup that you don't have cache coherency between the
> > two mounts (since they'll be different superblocks), and you may need
> > to tweak how fscache works in order to ensure that collisions between
> > two different mounts isn't a problem.
> >
> > At this point #2 doesn't seem altogether unreasonable. Most people
> > don't have pathological mount configurations like that so I'm not sure
> > it's worthwhile to jump through hoops to enable them.
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
