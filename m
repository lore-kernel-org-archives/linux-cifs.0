From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow mounts for paths for restricted intermediate paths
Date: Thu, 19 Dec 2013 12:56:22 -0600
Message-ID: <CADT32eK9ZbX9E0zZxJjP0CZJ0rWq1Zf1=vEj4YzLyC=iNW9Khg@mail.gmail.com>
References: <1384878813-7413-1-git-send-email-shirishpargaonkar@gmail.com>
	<20131119155923.31181d93@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131119155923.31181d93-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 19, 2013 at 2:59 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 19 Nov 2013 10:33:33 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Allow cifs mounts for a prefixpath with intermediate paths without access,
>> so as to continue with the shared superblock model.
>>
>> For the intermediate path entries that do not allow access, create "placeholder"
>> inodes and instantiate dentries with those inodes.
>> If and when such a path entry becomes accessible it is filled with correct
>> info.
>>
>
> I'm unclear on this last bit...
>
> How exactly do they end up being filled with the correct info once that
> happens?
>
>> Reference: Samba bugzilla 6950
>>
>> Signed-off-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
>>
>> ---
>>  fs/cifs/cifsfs.c    | 17 +++++++++++++++--
>>  fs/cifs/cifsproto.h |  3 +++
>>  fs/cifs/inode.c     | 16 ++++++++++++++++
>>  3 files changed, 34 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 849f613..bce185c 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -584,6 +584,9 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>>       char *full_path = NULL;
>>       char *s, *p;
>>       char sep;
>> +     struct inode *dir, *phinode;
>> +     struct dentry *child;
>> +     struct cifs_fattr phfattr;
>>
>>       full_path = cifs_build_path_to_root(vol, cifs_sb,
>>                                           cifs_sb_master_tcon(cifs_sb));
>> @@ -592,13 +595,13 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>>
>>       cifs_dbg(FYI, "Get root dentry for %s\n", full_path);
>>
>> +     fill_phfattr(&phfattr, sb);
>
> Hmmm...so this function sets up a cifs_fattr struct, including the
> cf_uniqueid...which won't be very unique when you reuse that struct
> several times in the do...while loop below. Don't you need to call it
> again after you use it once?
>
>>       sep = CIFS_DIR_SEP(cifs_sb);
>>       dentry = dget(sb->s_root);
>>       p = s = full_path;
>>
>>       do {
>> -             struct inode *dir = dentry->d_inode;
>> -             struct dentry *child;
>> +             dir = dentry->d_inode;
>>
>>               if (!dir) {
>>                       dput(dentry);
>> @@ -626,6 +629,16 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>>               mutex_unlock(&dir->i_mutex);
>>               dput(dentry);
>>               dentry = child;
>> +             if (!IS_ERR(dentry)) {
>> +                     if (*s) {
>> +                             /* EACCESS on an intermediate dir */
>> +                             if (!dentry->d_inode) {
>> +                                     phinode = cifs_iget(sb, &phfattr);
>> +                                     if (phinode)
>> +                                             d_instantiate(dentry, phinode);
>> +                             }
>> +                     }
>> +             }
>
> This doesn't make any sense to me.
>
> The do...while loop here is basically doing lookups and instantiating
> dentries and inodes down from the root of the mount to the root of the
> share. The lookup_one_len call is what does the single-level lookup in
> that directory.
>
> Why are you adding special handling when "dentry" is not an error?
> Would it not make more sense to do so when lookup_one_len does return
> an error?
>
>>       } while (!IS_ERR(dentry));
>>       kfree(full_path);
>>       return dentry;
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index aa33976..9a84e5c 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -498,4 +498,7 @@ void cifs_writedata_release(struct kref *refcount);
>>  int open_query_close_cifs_symlink(const unsigned char *path, char *pbuf,
>>                       unsigned int *pbytes_read, struct cifs_sb_info *cifs_sb,
>>                       unsigned int xid);
>> +
>> +extern void fill_phfattr(struct cifs_fattr *, struct super_block *);
>> +
>>  #endif                       /* _CIFSPROTO_H */
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index 36f9ebb..4f5a09a 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -322,6 +322,22 @@ cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
>>       fattr->cf_flags |= CIFS_FATTR_DFS_REFERRAL;
>>  }
>>
>> +void
>> +fill_phfattr(struct cifs_fattr *cf, struct super_block *sb)
>> +{
>> +     struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
>> +
>> +     memset(cf, 0, sizeof(*cf));
>> +     cf->cf_uniqueid = iunique(sb, ROOT_I);
>
>
> Also, iunique is only guaranteed to return a number that hasn't yet
> been used. So suppose we're going to instantiate one of these bogus
> inodes. We give it the uniqueid of '3'. Then later, once the mount is
> done we find another (legitimate) inode on the server and it also has a
> uniqueid of '3'. Now you have a collision. Worse yet, if it's a
> directory now it looks like we have a hardlinked directory...
>
> Once you start using iunique, you can't really go back to using server
> inode numbers since you can't guarantee that there won't be collisions.
>
> One possibility to deal with that would be to tag these entries as
> bogus and ensure that cifs_iget will never match them. Another
> possibility might be just to never hash these inodes, but I'm not clear
> on how kosher that is from a vfs standpoint.
>

I was thinking, we can have a fake inode per dentry for an
inaccessible path which has life only during the function
cifs_get_root, that too only just after lookup_one_len().
So use d_instantiate()/d_iput() pair for temporary creatation/delete
of these placeholder inodes!

So once a path is built and cifs_get_root is done, we should have
those intermediate path entries as negative but will have children
so will not be evicted from the dcache?

There is really no need for the inodes of the dentries for intermediate
inaccessible paths once a prefixpath mount completes successfully.


>> +     cf->cf_nlink = 1;
>> +     cf->cf_atime = CURRENT_TIME;
>> +     cf->cf_ctime = CURRENT_TIME;
>> +     cf->cf_mtime = CURRENT_TIME;
>> +     cf->cf_mode = S_IFDIR | S_IXUGO | S_IRWXU;
>> +     cf->cf_uid = cifs_sb->mnt_uid;
>> +     cf->cf_gid = cifs_sb->mnt_gid;
>> +}
>> +
>
>
>>  static int
>>  cifs_get_file_info_unix(struct file *filp)
>>  {
>
>
> I think the thing to do is to step back and describe (in English) how
> you envision this working. Then once that's done, we can start
> discussing what the code should look like...
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
