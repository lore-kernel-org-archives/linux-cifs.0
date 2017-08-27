From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: return ENAMETOOLONG for overlong names in cifs_open()/cifs_lookup()
Date: Sun, 27 Aug 2017 17:02:14 -0500
Message-ID: <CAH2r5muH=kE+S0V=9RQRAq_bzUBR=v00vE3Pc_sy8MMtu0o5Eg@mail.gmail.com>
References: <20170823044814.9609-1-lsahlber@redhat.com> <CAH2r5mvqHKaSTU-E=xK8weYOeFw=TAR2N1J=OJYupPvpcf9biw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvqHKaSTU-E=xK8weYOeFw=TAR2N1J=OJYupPvpcf9biw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 27, 2017 at 5:01 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Had an endian warning - I fixed in followon patch (and cc: stable)
>
> Remember to make with sparse checking (and endian checking turned on)
>
> e.g.
> make C=1 M=fs/cifs modules CF=-D__CHECK_ENDIAN__
>
> On Tue, Aug 22, 2017 at 11:48 PM, Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
>>
>> Add checking for the path component length and verify it is <= the maximum
>> that the server advertizes via FileFsAttributeInformation.
>>
>> With this patch cifs.ko will now return ENAMETOOLONG instead of ENOENT
>> when users to access an overlong path.
>>
>> To test this, try to cd into a (non-existing) directory on a CIFS share
>> that has a too long name:
>> cd /mnt/aaaaaaaaaaaaaaa...
>>
>> and it now should show a good error message from the shell:
>> bash: cd: /mnt/aaaaaaaaaaaaaaaa...aaaaaa: File name too long
>>
>> rh bz 1153996
>>
>> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/dir.c | 18 ++++++++++++------
>>  1 file changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
>> index 56366e984076..569d3fb736be 100644
>> --- a/fs/cifs/dir.c
>> +++ b/fs/cifs/dir.c
>> @@ -194,15 +194,20 @@ build_path_from_dentry_optional_prefix(struct dentry
>> *direntry, bool prefix)
>>  }
>>
>>  /*
>> + * Don't allow path components longer than the server max.
>>   * Don't allow the separator character in a path component.
>>   * The VFS will not allow "/", but "\" is allowed by posix.
>>   */
>>  static int
>> -check_name(struct dentry *direntry)
>> +check_name(struct dentry *direntry, struct cifs_tcon *tcon)
>>  {
>>         struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
>>         int i;
>>
>> +       if (unlikely(direntry->d_name.len >
>> +                    tcon->fsAttrInfo.MaxPathNameComponentLength))
>> +               return -ENAMETOOLONG;
>> +
>>         if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
>>                 for (i = 0; i < direntry->d_name.len; i++) {
>>                         if (direntry->d_name.name[i] == '\\') {
>> @@ -500,10 +505,6 @@ cifs_atomic_open(struct inode *inode, struct dentry
>> *direntry,
>>                 return finish_no_open(file, res);
>>         }
>>
>> -       rc = check_name(direntry);
>> -       if (rc)
>> -               return rc;
>> -
>>         xid = get_xid();
>>
>>         cifs_dbg(FYI, "parent inode = 0x%p name is: %pd and dentry =
>> 0x%p\n",
>> @@ -516,6 +517,11 @@ cifs_atomic_open(struct inode *inode, struct dentry
>> *direntry,
>>         }
>>
>>         tcon = tlink_tcon(tlink);
>> +
>> +       rc = check_name(direntry, tcon);
>> +       if (rc)
>> +               goto out_free_xid;
>> +
>>         server = tcon->ses->server;
>>
>>         if (server->ops->new_lease_key)
>> @@ -776,7 +782,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct
>> dentry *direntry,
>>         }
>>         pTcon = tlink_tcon(tlink);
>>
>> -       rc = check_name(direntry);
>> +       rc = check_name(direntry, pTcon);
>>         if (rc)
>>                 goto lookup_out;
>>
>> --
>> 2.13.3
>>
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
