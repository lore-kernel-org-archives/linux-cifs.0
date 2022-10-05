Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3F6C433FE
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Oct 2022 14:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiJEOak (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Oct 2022 10:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiJEOaj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Oct 2022 10:30:39 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E7E62937
        for <linux-cifs@vger.kernel.org>; Wed,  5 Oct 2022 07:30:37 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 10DB07FE88;
        Wed,  5 Oct 2022 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1664980235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=56S2Jbh20uJPWJqc9/C30okqD4clGqafRzuGMTfx1K4=;
        b=UcuSLV8v44rhfVgK46LETExtirIW8Zkn5yAZgxuXdq5DOOGIuPxONCprinPsy4lrmfXEWZ
        ZM13Rbasy3g9EwZJsSre4oQ3CPnUL++y3yzLrP58wewRpdpLRcl/DZHGexpFV3k60cS6dc
        1TGk6gSViq18UI70i0UfUn2LHeCpSnEsrRBZx3+VuX4LmjB0upRhNFQL2gKD/+e/wjgNUZ
        19b0f6b1oaCbQLpMQJcdHIoj8KzoFVkCQzmwfWdTuUHf3rAVjcYfB+hGO4Q7lNEbPGkRqy
        lCQolB7omkU98P6nRvTxlHabZuFtY5M5iV3n0KnovwN4A26gtOj1MJ336pFcOQ==
Date:   Wed, 05 Oct 2022 11:29:13 -0300
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>
CC:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] cifs: improve symlink handling for smb2+
In-Reply-To: <CAH2r5mu_xZvZEFp4_Nhf+BK0Eg9AVstB2SK29WyijGwYuN=90Q@mail.gmail.com>
References: <20221004181325.15207-1-pc@cjr.nz> <CAH2r5mu_xZvZEFp4_Nhf+BK0Eg9AVstB2SK29WyijGwYuN=90Q@mail.gmail.com>
Message-ID: <C917F0C0-C9AA-443B-8D4B-0051659DDB72@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Autocrypt: addr=pc@cjr.nz; keydata=
 mDMEYoac8xYJKwYBBAHaRw8BAQdAM1oQiOLRzlDAG+P/4GTNfJfK2B/t1AYD2DwRn5AHs7y0G1Bh
 dWxvIEFsY2FudGFyYSA8cGNAY2pyLm56PoiYBBMWCgBAAhsBBQkDwmcAAheABQsJCAcDBRUKCQgL
 BBYCAwECHgUWIQTRQNZFHUfXojpaAge18c3GqiCw3QUCYo12XgIZAQAKCRC18c3GqiCw3eQHAP97
 fZEKSMTyh54xhvH4hzjBykM8jnfh6eXd9R25TP/wnQEAhNm9+qrzas1/BMA6ky+MC/CMTGC9YYgn
 /KXZJEkgWwq4OARihp5QEgorBgEEAZdVAQUBAQdAZINGc6Yes3DJI9lnkWuaIwGDbyHD1GjdugkZ
 eHNxNXkDAQgHiH4EGBYKACYWIQTRQNZFHUfXojpaAge18c3GqiCw3QUCYoaeUAIbDAUJAO1OAAAK
 CRC18c3GqiCw3dFBAP9HHZkgjYL7ud5DLNVVkWnda5gwX1M3CFdY/2eUC8LKCgD8DZcPH9vUrOeX
 rO6t75t+mNQdURjvgWgT79R2Lns4jgC4MwRihp2TFgkrBgEEAdpHDwEBB0DiISiiRmsicWRU97kF
 1/hUFxSbFMsbvYdYT5r7iw/SIIj1BBgWCgAmFiEE0UDWRR1H16I6WgIHtfHNxqogsN0FAmKGnZMC
 GwIFCQDtTgAAgQkQtfHNxqogsN12IAQZFgoAHRYhBLuWPI/TqULtfs9/CDqGjQQFBjceBQJihp2T
 AAoJEDqGjQQFBjcerNIBAKZym2X8cYAx1RrO0yEKgLI2zRzfQciPOUImIJ+gaMMyAQDNOdf2B4w/
 s5sqBN2b6PKniuBbo2ZnPf4lhqjX4Pr0A5UmAQCMBouDX7UtHjIi8574VDiGQm4j+7G5Kzc2g3Dm
 gbvqfwD9F+JS5FD6fBgLOHZeTdsNPmhkWKR6NPnskZMkfStCdAQ=
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 5 October 2022 04:39:43 GMT-03:00, Steve French <smfrench@gmail=2Ecom> w=
rote:
>could you fixup some of the checkpatch warnings - the ENOSYS one looks
>like a potential problem and "unsigned int" is better style than
>"unsigned" etc=2E
>
>WARNING: function definition argument 'const unsigned int' should also
>have an identifier name
>#113: FILE: fs/cifs/cifsglob=2Eh:333:
>+ int (*query_path_info)(const unsigned int, struct cifs_tcon *,
>struct cifs_sb_info *,
>
>WARNING: function definition argument 'struct cifs_tcon *' should also
>have an identifier name
>#113: FILE: fs/cifs/cifsglob=2Eh:333:
>+ int (*query_path_info)(const unsigned int, struct cifs_tcon *,
>struct cifs_sb_info *,
>
>WARNING: function definition argument 'struct cifs_sb_info *' should
>also have an identifier name
>#113: FILE: fs/cifs/cifsglob=2Eh:333:
>+ int (*query_path_info)(const unsigned int, struct cifs_tcon *,
>struct cifs_sb_info *,
>
>WARNING: function definition argument 'const char *' should also have
>an identifier name
>#113: FILE: fs/cifs/cifsglob=2Eh:333:
>+ int (*query_path_info)(const unsigned int, struct cifs_tcon *,
>struct cifs_sb_info *,
>
>WARNING: function definition argument 'struct cifs_open_info_data *'
>should also have an identifier name
>#113: FILE: fs/cifs/cifsglob=2Eh:333:
>+ int (*query_path_info)(const unsigned int, struct cifs_tcon *,
>struct cifs_sb_info *,
>
>WARNING: function definition argument 'bool *' should also have an
>identifier name
>#113: FILE: fs/cifs/cifsglob=2Eh:333:
>+ int (*query_path_info)(const unsigned int, struct cifs_tcon *,
>struct cifs_sb_info *,
>
>WARNING: function definition argument 'bool *' should also have an
>identifier name
>#113: FILE: fs/cifs/cifsglob=2Eh:333:
>+ int (*query_path_info)(const unsigned int, struct cifs_tcon *,
>struct cifs_sb_info *,
>
>WARNING: function definition argument 'const unsigned int' should also
>have an identifier name
>#118: FILE: fs/cifs/cifsglob=2Eh:336:
>+ int (*query_file_info)(const unsigned int, struct cifs_tcon *,
>struct cifsFileInfo *,
>
>WARNING: function definition argument 'struct cifs_tcon *' should also
>have an identifier name
>#118: FILE: fs/cifs/cifsglob=2Eh:336:
>+ int (*query_file_info)(const unsigned int, struct cifs_tcon *,
>struct cifsFileInfo *,
>
>WARNING: function definition argument 'struct cifsFileInfo *' should
>also have an identifier name
>#118: FILE: fs/cifs/cifsglob=2Eh:336:
>+ int (*query_file_info)(const unsigned int, struct cifs_tcon *,
>struct cifsFileInfo *,
>
>WARNING: function definition argument 'struct cifs_open_info_data *'
>should also have an identifier name
>#118: FILE: fs/cifs/cifsglob=2Eh:336:
>+ int (*query_file_info)(const unsigned int, struct cifs_tcon *,
>struct cifsFileInfo *,
>
>WARNING: function definition argument 'const unsigned int' should also
>have an identifier name
>#128: FILE: fs/cifs/cifsglob=2Eh:343:
>+ int (*get_srv_inum)(const unsigned int, struct cifs_tcon *, struct
>cifs_sb_info *,
>
>WARNING: function definition argument 'struct cifs_tcon *' should also
>have an identifier name
>#128: FILE: fs/cifs/cifsglob=2Eh:343:
>+ int (*get_srv_inum)(const unsigned int, struct cifs_tcon *, struct
>cifs_sb_info *,
>
>WARNING: function definition argument 'struct cifs_sb_info *' should
>also have an identifier name
>#128: FILE: fs/cifs/cifsglob=2Eh:343:
>+ int (*get_srv_inum)(const unsigned int, struct cifs_tcon *, struct
>cifs_sb_info *,
>
>WARNING: function definition argument 'const char *' should also have
>an identifier name
>#128: FILE: fs/cifs/cifsglob=2Eh:343:
>+ int (*get_srv_inum)(const unsigned int, struct cifs_tcon *, struct
>cifs_sb_info *,
>
>WARNING: function definition argument 'struct cifs_open_info_data *'
>should also have an identifier name
>#128: FILE: fs/cifs/cifsglob=2Eh:343:
>+ int (*get_srv_inum)(const unsigned int, struct cifs_tcon *, struct
>cifs_sb_info *,
>
>WARNING: function definition argument 'const unsigned int' should also
>have an identifier name
>#139: FILE: fs/cifs/cifsglob=2Eh:393:
>+ int (*open)(const unsigned int, struct cifs_open_parms *, __u32 *, void=
 *);
>
>WARNING: function definition argument 'struct cifs_open_parms *'
>should also have an identifier name
>#139: FILE: fs/cifs/cifsglob=2Eh:393:
>+ int (*open)(const unsigned int, struct cifs_open_parms *, __u32 *, void=
 *);
>
>WARNING: function definition argument '__u32 *' should also have an
>identifier name
>#139: FILE: fs/cifs/cifsglob=2Eh:393:
>+ int (*open)(const unsigned int, struct cifs_open_parms *, __u32 *, void=
 *);
>
>WARNING: function definition argument 'void *' should also have an
>identifier name
>#139: FILE: fs/cifs/cifsglob=2Eh:393:
>+ int (*open)(const unsigned int, struct cifs_open_parms *, __u32 *, void=
 *);
>
>WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
>#226: FILE: fs/cifs/dir=2Ec:169:
>+   struct tcon_link *tlink, unsigned oflags, umode_t mode, __u32 *oplock=
,
>
>WARNING: ENOSYS means 'invalid syscall nr' and nothing else
>#525: FILE: fs/cifs/inode=2Ec:436:
>+ return -ENOSYS;
>
>total: 0 errors, 23 warnings, 1689 lines checked
>
>On Tue, Oct 4, 2022 at 1:12 PM Paulo Alcantara <pc@cjr=2Enz> wrote:
>>
>> When creating inode for symlink, the client used to send below
>> requests to fill it in:
>>
>>     * create+query_info+close (STATUS_STOPPED_ON_SYMLINK)
>>     * create(+reparse_flag)+query_info+close (set file attrs)
>>     * create+ioctl(get_reparse)+close (query reparse tag)
>>
>> and then for every access to the symlink dentry, the ->link() method
>> would send another:
>>
>>     * create+ioctl(get_reparse)+close (parse symlink)
>>
>> So, in order to improve:
>>
>>     (i) Get rid of unnecessary roundtrips and then resolve symlinks as
>>         follows:
>>
>>         * create+query_info+close (STATUS_STOPPED_ON_SYMLINK + parse sy=
mlink + get reparse tag)
>>         * create(+reparse_flag)+query_info+close (set file attrs)
>>
>>     (ii) Set the resolved symlink target directly in inode->i_link and
>>          use simple_get_link() for ->link() to simply return it=2E
>>
>> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr=2Enz>
>> ---
>>  fs/cifs/cifsfs=2Ec    |   9 ++-
>>  fs/cifs/cifsglob=2Eh  |  43 ++++++++---
>>  fs/cifs/cifsproto=2Eh |  13 ++--
>>  fs/cifs/dir=2Ec       |  30 +++-----
>>  fs/cifs/file=2Ec      |  41 ++++++-----
>>  fs/cifs/inode=2Ec     | 170 ++++++++++++++++++++++++++----------------=
--
>>  fs/cifs/link=2Ec      | 107 +---------------------------
>>  fs/cifs/readdir=2Ec   |   2 +
>>  fs/cifs/smb1ops=2Ec   |  56 +++++++++------
>>  fs/cifs/smb2file=2Ec  | 127 +++++++++++++++++++++++++++------
>>  fs/cifs/smb2inode=2Ec | 169 ++++++++++++++++++++++--------------------=
-
>>  fs/cifs/smb2ops=2Ec   | 109 ++++++----------------------
>>  fs/cifs/smb2pdu=2Eh   |   3 +
>>  fs/cifs/smb2proto=2Eh |  22 +++---
>>  14 files changed, 448 insertions(+), 453 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs=2Ec b/fs/cifs/cifsfs=2Ec
>> index 8042d7280dec=2E=2Ec6ac19223ddc 100644
>> --- a/fs/cifs/cifsfs=2Ec
>> +++ b/fs/cifs/cifsfs=2Ec
>> @@ -396,6 +396,7 @@ cifs_alloc_inode(struct super_block *sb)
>>         cifs_inode->epoch =3D 0;
>>         spin_lock_init(&cifs_inode->open_file_lock);
>>         generate_random_uuid(cifs_inode->lease_key);
>> +       cifs_inode->symlink_target =3D NULL;
>>
>>         /*
>>          * Can not set i_flags here - they get immediately overwritten =
to zero
>> @@ -412,7 +413,11 @@ cifs_alloc_inode(struct super_block *sb)
>>  static void
>>  cifs_free_inode(struct inode *inode)
>>  {
>> -       kmem_cache_free(cifs_inode_cachep, CIFS_I(inode));
>> +       struct cifsInodeInfo *cinode =3D CIFS_I(inode);
>> +
>> +       if (S_ISLNK(inode->i_mode))
>> +               kfree(cinode->symlink_target);
>> +       kmem_cache_free(cifs_inode_cachep, cinode);
>>  }
>>
>>  static void
>> @@ -1139,7 +1144,7 @@ const struct inode_operations cifs_file_inode_ops=
 =3D {
>>  };
>>
>>  const struct inode_operations cifs_symlink_inode_ops =3D {
>> -       =2Eget_link =3D cifs_get_link,
>> +       =2Eget_link =3D simple_get_link,
>>         =2Epermission =3D cifs_permission,
>>         =2Elistxattr =3D cifs_listxattr,
>>  };
>> diff --git a/fs/cifs/cifsglob=2Eh b/fs/cifs/cifsglob=2Eh
>> index 52ddf4163b98=2E=2E9a3386d827b6 100644
>> --- a/fs/cifs/cifsglob=2Eh
>> +++ b/fs/cifs/cifsglob=2Eh
>> @@ -185,6 +185,19 @@ struct cifs_cred {
>>         struct cifs_ace *aces;
>>  };
>>
>> +struct cifs_open_info_data {
>> +       char *symlink_target;
>> +       union {
>> +               struct smb2_file_all_info fi;
>> +               struct smb311_posix_qinfo posix_fi;
>> +       };
>> +};
>> +
>> +static inline void cifs_free_open_info(struct cifs_open_info_data *dat=
a)
>> +{
>> +       kfree(data->symlink_target);
>> +}
>> +
>>  /*
>>   *****************************************************************
>>   * Except the CIFS PDUs themselves all the
>> @@ -307,20 +320,18 @@ struct smb_version_operations {
>>         int (*is_path_accessible)(const unsigned int, struct cifs_tcon =
*,
>>                                   struct cifs_sb_info *, const char *);
>>         /* query path data from the server */
>> -       int (*query_path_info)(const unsigned int, struct cifs_tcon *,
>> -                              struct cifs_sb_info *, const char *,
>> -                              FILE_ALL_INFO *, bool *, bool *);
>> +       int (*query_path_info)(const unsigned int, struct cifs_tcon *, =
struct cifs_sb_info *,
>> +                              const char *, struct cifs_open_info_data=
 *, bool *, bool *);
>>         /* query file data from the server */
>> -       int (*query_file_info)(const unsigned int, struct cifs_tcon *,
>> -                              struct cifs_fid *, FILE_ALL_INFO *);
>> +       int (*query_file_info)(const unsigned int, struct cifs_tcon *, =
struct cifsFileInfo *,
>> +                              struct cifs_open_info_data *);
>>         /* query reparse tag from srv to determine which type of specia=
l file */
>>         int (*query_reparse_tag)(const unsigned int xid, struct cifs_tc=
on *tcon,
>>                                 struct cifs_sb_info *cifs_sb, const cha=
r *path,
>>                                 __u32 *reparse_tag);
>>         /* get server index number */
>> -       int (*get_srv_inum)(const unsigned int, struct cifs_tcon *,
>> -                           struct cifs_sb_info *, const char *,
>> -                           u64 *uniqueid, FILE_ALL_INFO *);
>> +       int (*get_srv_inum)(const unsigned int, struct cifs_tcon *, str=
uct cifs_sb_info *,
>> +                           const char *, u64 *uniqueid, struct cifs_op=
en_info_data *);
>>         /* set size by path */
>>         int (*set_path_size)(const unsigned int, struct cifs_tcon *,
>>                              const char *, __u64, struct cifs_sb_info *=
, bool);
>> @@ -369,8 +380,7 @@ struct smb_version_operations {
>>                              struct cifs_sb_info *, const char *,
>>                              char **, bool);
>>         /* open a file for non-posix mounts */
>> -       int (*open)(const unsigned int, struct cifs_open_parms *,
>> -                   __u32 *, FILE_ALL_INFO *);
>> +       int (*open)(const unsigned int, struct cifs_open_parms *, __u32=
 *, void *);
>>         /* set fid protocol-specific info */
>>         void (*set_fid)(struct cifsFileInfo *, struct cifs_fid *, __u32=
);
>>         /* close a file */
>> @@ -1123,6 +1133,7 @@ struct cifs_fattr {
>>         struct timespec64 cf_mtime;
>>         struct timespec64 cf_ctime;
>>         u32             cf_cifstag;
>> +       char            *cf_symlink_target;
>>  };
>>
>>  /*
>> @@ -1385,6 +1396,7 @@ struct cifsFileInfo {
>>         struct work_struct put; /* work for the final part of _put */
>>         struct delayed_work deferred;
>>         bool deferred_close_scheduled; /* Flag to indicate close is sch=
eduled */
>> +       char *symlink_target;
>>  };
>>
>>  struct cifs_io_parms {
>> @@ -1543,6 +1555,7 @@ struct cifsInodeInfo {
>>         struct list_head deferred_closes; /* list of deferred closes */
>>         spinlock_t deferred_lock; /* protection on deferred list */
>>         bool lease_granted; /* Flag to indicate whether lease or oplock=
 is granted=2E */
>> +       char *symlink_target;
>>  };
>>
>>  static inline struct cifsInodeInfo *
>> @@ -2111,4 +2124,14 @@ static inline size_t ntlmssp_workstation_name_si=
ze(const struct cifs_ses *ses)
>>         return sizeof(ses->workstation_name);
>>  }
>>
>> +static inline void move_cifs_info_to_smb2(struct smb2_file_all_info *d=
st, const FILE_ALL_INFO *src)
>> +{
>> +       memcpy(dst, src, (size_t)((u8 *)&src->AccessFlags - (u8 *)src))=
;
>> +       dst->AccessFlags =3D src->AccessFlags;
>> +       dst->CurrentByteOffset =3D src->CurrentByteOffset;
>> +       dst->Mode =3D src->Mode;
>> +       dst->AlignmentRequirement =3D src->AlignmentRequirement;
>> +       dst->FileNameLength =3D src->FileNameLength;
>> +}
>> +
>>  #endif /* _CIFS_GLOB_H */
>> diff --git a/fs/cifs/cifsproto=2Eh b/fs/cifs/cifsproto=2Eh
>> index f5adcb8ea04d=2E=2E13a675d9d3b9 100644
>> --- a/fs/cifs/cifsproto=2Eh
>> +++ b/fs/cifs/cifsproto=2Eh
>> @@ -182,10 +182,9 @@ extern int cifs_unlock_range(struct cifsFileInfo *=
cfile,
>>  extern int cifs_push_mandatory_locks(struct cifsFileInfo *cfile);
>>
>>  extern void cifs_down_write(struct rw_semaphore *sem);
>> -extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid,
>> -                                             struct file *file,
>> -                                             struct tcon_link *tlink,
>> -                                             __u32 oplock);
>> +struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct fi=
le *file,
>> +                                      struct tcon_link *tlink, __u32 o=
plock,
>> +                                      const char *symlink_target);
>>  extern int cifs_posix_open(const char *full_path, struct inode **inode=
,
>>                            struct super_block *sb, int mode,
>>                            unsigned int f_flags, __u32 *oplock, __u16 *=
netfid,
>> @@ -200,9 +199,9 @@ extern int cifs_fattr_to_inode(struct inode *inode,=
 struct cifs_fattr *fattr);
>>  extern struct inode *cifs_iget(struct super_block *sb,
>>                                struct cifs_fattr *fattr);
>>
>> -extern int cifs_get_inode_info(struct inode **inode, const char *full_=
path,
>> -                              FILE_ALL_INFO *data, struct super_block =
*sb,
>> -                              int xid, const struct cifs_fid *fid);
>> +int cifs_get_inode_info(struct inode **inode, const char *full_path,
>> +                       struct cifs_open_info_data *data, struct super_=
block *sb, int xid,
>> +                       const struct cifs_fid *fid);
>>  extern int smb311_posix_get_inode_info(struct inode **pinode, const ch=
ar *search_path,
>>                         struct super_block *sb, unsigned int xid);
>>  extern int cifs_get_inode_info_unix(struct inode **pinode,
>> diff --git a/fs/cifs/dir=2Ec b/fs/cifs/dir=2Ec
>> index f58869306309=2E=2E4edd55384662 100644
>> --- a/fs/cifs/dir=2Ec
>> +++ b/fs/cifs/dir=2Ec
>> @@ -165,10 +165,9 @@ check_name(struct dentry *direntry, struct cifs_tc=
on *tcon)
>>
>>  /* Inode operations in similar order to how they appear in Linux file =
fs=2Eh */
>>
>> -static int
>> -cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned =
int xid,
>> -              struct tcon_link *tlink, unsigned oflags, umode_t mode,
>> -              __u32 *oplock, struct cifs_fid *fid)
>> +static int cifs_do_create(struct inode *inode, struct dentry *direntry=
, unsigned int xid,
>> +                         struct tcon_link *tlink, unsigned oflags, umo=
de_t mode, __u32 *oplock,
>> +                         struct cifs_fid *fid, struct cifs_open_info_d=
ata *buf)
>>  {
>>         int rc =3D -ENOENT;
>>         int create_options =3D CREATE_NOT_DIR;
>> @@ -177,7 +176,6 @@ cifs_do_create(struct inode *inode, struct dentry *=
direntry, unsigned int xid,
>>         struct cifs_tcon *tcon =3D tlink_tcon(tlink);
>>         const char *full_path;
>>         void *page =3D alloc_dentry_path();
>> -       FILE_ALL_INFO *buf =3D NULL;
>>         struct inode *newinode =3D NULL;
>>         int disposition;
>>         struct TCP_Server_Info *server =3D tcon->ses->server;
>> @@ -290,12 +288,6 @@ cifs_do_create(struct inode *inode, struct dentry =
*direntry, unsigned int xid,
>>                 goto out;
>>         }
>>
>> -       buf =3D kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
>> -       if (buf =3D=3D NULL) {
>> -               rc =3D -ENOMEM;
>> -               goto out;
>> -       }
>> -
>>         /*
>>          * if we're not using unix extensions, see if we need to set
>>          * ATTR_READONLY on the create call
>> @@ -364,8 +356,7 @@ cifs_do_create(struct inode *inode, struct dentry *=
direntry, unsigned int xid,
>>         {
>>  #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
>>                 /* TODO: Add support for calling POSIX query info here,=
 but passing in fid */
>> -               rc =3D cifs_get_inode_info(&newinode, full_path, buf, i=
node->i_sb,
>> -                                        xid, fid);
>> +               rc =3D cifs_get_inode_info(&newinode, full_path, buf, i=
node->i_sb, xid, fid);
>>                 if (newinode) {
>>                         if (server->ops->set_lease_key)
>>                                 server->ops->set_lease_key(newinode, fi=
d);
>> @@ -402,7 +393,6 @@ cifs_do_create(struct inode *inode, struct dentry *=
direntry, unsigned int xid,
>>         d_add(direntry, newinode);
>>
>>  out:
>> -       kfree(buf);
>>         free_dentry_path(page);
>>         return rc;
>>
>> @@ -427,6 +417,7 @@ cifs_atomic_open(struct inode *inode, struct dentry=
 *direntry,
>>         struct cifs_pending_open open;
>>         __u32 oplock;
>>         struct cifsFileInfo *file_info;
>> +       struct cifs_open_info_data buf =3D {};
>>
>>         if (unlikely(cifs_forced_shutdown(CIFS_SB(inode->i_sb))))
>>                 return -EIO;
>> @@ -484,8 +475,7 @@ cifs_atomic_open(struct inode *inode, struct dentry=
 *direntry,
>>         cifs_add_pending_open(&fid, tlink, &open);
>>
>>         rc =3D cifs_do_create(inode, direntry, xid, tlink, oflags, mode=
,
>> -                           &oplock, &fid);
>> -
>> +                           &oplock, &fid, &buf);
>>         if (rc) {
>>                 cifs_del_pending_open(&open);
>>                 goto out;
>> @@ -510,7 +500,7 @@ cifs_atomic_open(struct inode *inode, struct dentry=
 *direntry,
>>                         file->f_op =3D &cifs_file_direct_ops;
>>                 }
>>
>> -       file_info =3D cifs_new_fileinfo(&fid, file, tlink, oplock);
>> +       file_info =3D cifs_new_fileinfo(&fid, file, tlink, oplock, buf=
=2Esymlink_target);
>>         if (file_info =3D=3D NULL) {
>>                 if (server->ops->close)
>>                         server->ops->close(xid, tcon, &fid);
>> @@ -526,6 +516,7 @@ cifs_atomic_open(struct inode *inode, struct dentry=
 *direntry,
>>         cifs_put_tlink(tlink);
>>  out_free_xid:
>>         free_xid(xid);
>> +       cifs_free_open_info(&buf);
>>         return rc;
>>  }
>>
>> @@ -547,6 +538,7 @@ int cifs_create(struct user_namespace *mnt_userns, =
struct inode *inode,
>>         struct TCP_Server_Info *server;
>>         struct cifs_fid fid;
>>         __u32 oplock;
>> +       struct cifs_open_info_data buf =3D {};
>>
>>         cifs_dbg(FYI, "cifs_create parent inode =3D 0x%p name is: %pd a=
nd dentry =3D 0x%p\n",
>>                  inode, direntry, direntry);
>> @@ -565,11 +557,11 @@ int cifs_create(struct user_namespace *mnt_userns=
, struct inode *inode,
>>         if (server->ops->new_lease_key)
>>                 server->ops->new_lease_key(&fid);
>>
>> -       rc =3D cifs_do_create(inode, direntry, xid, tlink, oflags, mode=
,
>> -                           &oplock, &fid);
>> +       rc =3D cifs_do_create(inode, direntry, xid, tlink, oflags, mode=
, &oplock, &fid, &buf);
>>         if (!rc && server->ops->close)
>>                 server->ops->close(xid, tcon, &fid);
>>
>> +       cifs_free_open_info(&buf);
>>         cifs_put_tlink(tlink);
>>  out_free_xid:
>>         free_xid(xid);
>> diff --git a/fs/cifs/file=2Ec b/fs/cifs/file=2Ec
>> index 7d756721e1a6=2E=2Edcec1690312b 100644
>> --- a/fs/cifs/file=2Ec
>> +++ b/fs/cifs/file=2Ec
>> @@ -209,16 +209,14 @@ int cifs_posix_open(const char *full_path, struct=
 inode **pinode,
>>  }
>>  #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
>>
>> -static int
>> -cifs_nt_open(const char *full_path, struct inode *inode, struct cifs_s=
b_info *cifs_sb,
>> -            struct cifs_tcon *tcon, unsigned int f_flags, __u32 *oploc=
k,
>> -            struct cifs_fid *fid, unsigned int xid)
>> +static int cifs_nt_open(const char *full_path, struct inode *inode, st=
ruct cifs_sb_info *cifs_sb,
>> +                       struct cifs_tcon *tcon, unsigned int f_flags, _=
_u32 *oplock,
>> +                       struct cifs_fid *fid, unsigned int xid, struct =
cifs_open_info_data *buf)
>>  {
>>         int rc;
>>         int desired_access;
>>         int disposition;
>>         int create_options =3D CREATE_NOT_DIR;
>> -       FILE_ALL_INFO *buf;
>>         struct TCP_Server_Info *server =3D tcon->ses->server;
>>         struct cifs_open_parms oparms;
>>
>> @@ -255,10 +253,6 @@ cifs_nt_open(const char *full_path, struct inode *=
inode, struct cifs_sb_info *ci
>>
>>         /* BB pass O_SYNC flag through on file attributes =2E=2E BB */
>>
>> -       buf =3D kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
>> -       if (!buf)
>> -               return -ENOMEM;
>> -
>>         /* O_SYNC also has bit for O_DSYNC so following check picks up =
either */
>>         if (f_flags & O_SYNC)
>>                 create_options |=3D CREATE_WRITE_THROUGH;
>> @@ -276,9 +270,8 @@ cifs_nt_open(const char *full_path, struct inode *i=
node, struct cifs_sb_info *ci
>>         oparms=2Ereconnect =3D false;
>>
>>         rc =3D server->ops->open(xid, &oparms, oplock, buf);
>> -
>>         if (rc)
>> -               goto out;
>> +               return rc;
>>
>>         /* TODO: Add support for calling posix query info but with pass=
ing in fid */
>>         if (tcon->unix_ext)
>> @@ -294,8 +287,6 @@ cifs_nt_open(const char *full_path, struct inode *i=
node, struct cifs_sb_info *ci
>>                         rc =3D -EOPENSTALE;
>>         }
>>
>> -out:
>> -       kfree(buf);
>>         return rc;
>>  }
>>
>> @@ -325,9 +316,9 @@ cifs_down_write(struct rw_semaphore *sem)
>>
>>  static void cifsFileInfo_put_work(struct work_struct *work);
>>
>> -struct cifsFileInfo *
>> -cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
>> -                 struct tcon_link *tlink, __u32 oplock)
>> +struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid, struct fi=
le *file,
>> +                                      struct tcon_link *tlink, __u32 o=
plock,
>> +                                      const char *symlink_target)
>>  {
>>         struct dentry *dentry =3D file_dentry(file);
>>         struct inode *inode =3D d_inode(dentry);
>> @@ -347,6 +338,15 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct fil=
e *file,
>>                 return NULL;
>>         }
>>
>> +       if (symlink_target) {
>> +               cfile->symlink_target =3D kstrdup(symlink_target, GFP_K=
ERNEL);
>> +               if (!cfile->symlink_target) {
>> +                       kfree(fdlocks);
>> +                       kfree(cfile);
>> +                       return NULL;
>> +               }
>> +       }
>> +
>>         INIT_LIST_HEAD(&fdlocks->locks);
>>         fdlocks->cfile =3D cfile;
>>         cfile->llist =3D fdlocks;
>> @@ -440,6 +440,7 @@ static void cifsFileInfo_put_final(struct cifsFileI=
nfo *cifs_file)
>>         cifs_put_tlink(cifs_file->tlink);
>>         dput(cifs_file->dentry);
>>         cifs_sb_deactive(sb);
>> +       kfree(cifs_file->symlink_target);
>>         kfree(cifs_file);
>>  }
>>
>> @@ -572,6 +573,7 @@ int cifs_open(struct inode *inode, struct file *fil=
e)
>>         bool posix_open_ok =3D false;
>>         struct cifs_fid fid;
>>         struct cifs_pending_open open;
>> +       struct cifs_open_info_data data =3D {};
>>
>>         xid =3D get_xid();
>>
>> @@ -662,15 +664,15 @@ int cifs_open(struct inode *inode, struct file *f=
ile)
>>                 if (server->ops->get_lease_key)
>>                         server->ops->get_lease_key(inode, &fid);
>>
>> -               rc =3D cifs_nt_open(full_path, inode, cifs_sb, tcon,
>> -                                 file->f_flags, &oplock, &fid, xid);
>> +               rc =3D cifs_nt_open(full_path, inode, cifs_sb, tcon, fi=
le->f_flags, &oplock, &fid,
>> +                                 xid, &data);
>>                 if (rc) {
>>                         cifs_del_pending_open(&open);
>>                         goto out;
>>                 }
>>         }
>>
>> -       cfile =3D cifs_new_fileinfo(&fid, file, tlink, oplock);
>> +       cfile =3D cifs_new_fileinfo(&fid, file, tlink, oplock, data=2Es=
ymlink_target);
>>         if (cfile =3D=3D NULL) {
>>                 if (server->ops->close)
>>                         server->ops->close(xid, tcon, &fid);
>> @@ -712,6 +714,7 @@ int cifs_open(struct inode *inode, struct file *fil=
e)
>>         free_dentry_path(page);
>>         free_xid(xid);
>>         cifs_put_tlink(tlink);
>> +       cifs_free_open_info(&data);
>>         return rc;
>>  }
>>
>> diff --git a/fs/cifs/inode=2Ec b/fs/cifs/inode=2Ec
>> index 3784d3a88053=2E=2E37ada3912022 100644
>> --- a/fs/cifs/inode=2Ec
>> +++ b/fs/cifs/inode=2Ec
>> @@ -212,6 +212,17 @@ cifs_fattr_to_inode(struct inode *inode, struct ci=
fs_fattr *fattr)
>>         }
>>         spin_unlock(&inode->i_lock);
>>
>> +       if (S_ISLNK(fattr->cf_mode)) {
>> +               kfree(cifs_i->symlink_target);
>> +               cifs_i->symlink_target =3D fattr->cf_symlink_target;
>> +               fattr->cf_symlink_target =3D NULL;
>> +
>> +               if (unlikely(!cifs_i->symlink_target))
>> +                       inode->i_link =3D ERR_PTR(-EOPNOTSUPP);
>> +               else
>> +                       inode->i_link =3D cifs_i->symlink_target;
>> +       }
>> +
>>         if (fattr->cf_flags & CIFS_FATTR_DFS_REFERRAL)
>>                 inode->i_flags |=3D S_AUTOMOUNT;
>>         if (inode->i_state & I_NEW)
>> @@ -347,13 +358,20 @@ cifs_get_file_info_unix(struct file *filp)
>>         int rc;
>>         unsigned int xid;
>>         FILE_UNIX_BASIC_INFO find_data;
>> -       struct cifs_fattr fattr;
>> +       struct cifs_fattr fattr =3D {};
>>         struct inode *inode =3D file_inode(filp);
>>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
>>         struct cifsFileInfo *cfile =3D filp->private_data;
>>         struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
>>
>>         xid =3D get_xid();
>> +
>> +       if (cfile->symlink_target) {
>> +               fattr=2Ecf_symlink_target =3D kstrdup(cfile->symlink_ta=
rget, GFP_KERNEL);
>> +               if (!fattr=2Ecf_symlink_target)
>> +                       return -ENOMEM;
>> +       }
>> +
>>         rc =3D CIFSSMBUnixQFileInfo(xid, tcon, cfile->fid=2Enetfid, &fi=
nd_data);
>>         if (!rc) {
>>                 cifs_unix_basic_to_fattr(&fattr, &find_data, cifs_sb);
>> @@ -378,6 +396,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
>>         FILE_UNIX_BASIC_INFO find_data;
>>         struct cifs_fattr fattr;
>>         struct cifs_tcon *tcon;
>> +       struct TCP_Server_Info *server;
>>         struct tcon_link *tlink;
>>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>>
>> @@ -387,10 +406,12 @@ int cifs_get_inode_info_unix(struct inode **pinod=
e,
>>         if (IS_ERR(tlink))
>>                 return PTR_ERR(tlink);
>>         tcon =3D tlink_tcon(tlink);
>> +       server =3D tcon->ses->server;
>>
>>         /* could have done a find first instead but this returns more i=
nfo */
>>         rc =3D CIFSSMBUnixQPathInfo(xid, tcon, full_path, &find_data,
>>                                   cifs_sb->local_nls, cifs_remap(cifs_s=
b));
>> +       cifs_dbg(FYI, "%s: query path info: rc =3D %d\n", __func__, rc)=
;
>>         cifs_put_tlink(tlink);
>>
>>         if (!rc) {
>> @@ -410,6 +431,17 @@ int cifs_get_inode_info_unix(struct inode **pinode=
,
>>                         cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
>>         }
>>
>> +       if (S_ISLNK(fattr=2Ecf_mode) && !fattr=2Ecf_symlink_target) {
>> +               if (!server->ops->query_symlink)
>> +                       return -ENOSYS;
>> +               rc =3D server->ops->query_symlink(xid, tcon, cifs_sb, f=
ull_path,
>> +                                               &fattr=2Ecf_symlink_tar=
get, false);
>> +               if (rc) {
>> +                       cifs_dbg(FYI, "%s: query_symlink: %d\n", __func=
__, rc);
>> +                       goto cgiiu_exit;
>> +               }
>> +       }
>> +
>>         if (*pinode =3D=3D NULL) {
>>                 /* get new inode */
>>                 cifs_fill_uniqueid(sb, &fattr);
>> @@ -432,6 +464,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
>>         }
>>
>>  cgiiu_exit:
>> +       kfree(fattr=2Ecf_symlink_target);
>>         return rc;
>>  }
>>  #else
>> @@ -601,10 +634,10 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr=
, const unsigned char *path,
>>  }
>>
>>  /* Fill a cifs_fattr struct with info from POSIX info struct */
>> -static void
>> -smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struct smb311_pos=
ix_qinfo *info,
>> -                          struct super_block *sb, bool adjust_tz, bool=
 symlink)
>> +static void smb311_posix_info_to_fattr(struct cifs_fattr *fattr, struc=
t cifs_open_info_data *data,
>> +                                      struct super_block *sb, bool adj=
ust_tz, bool symlink)
>>  {
>> +       struct smb311_posix_qinfo *info =3D &data->posix_fi;
>>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>>         struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
>>
>> @@ -639,6 +672,8 @@ smb311_posix_info_to_fattr(struct cifs_fattr *fattr=
, struct smb311_posix_qinfo *
>>         if (symlink) {
>>                 fattr->cf_mode |=3D S_IFLNK;
>>                 fattr->cf_dtype =3D DT_LNK;
>> +               fattr->cf_symlink_target =3D data->symlink_target;
>> +               data->symlink_target =3D NULL;
>>         } else if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
>>                 fattr->cf_mode |=3D S_IFDIR;
>>                 fattr->cf_dtype =3D DT_DIR;
>> @@ -655,13 +690,11 @@ smb311_posix_info_to_fattr(struct cifs_fattr *fat=
tr, struct smb311_posix_qinfo *
>>                 fattr->cf_mode, fattr->cf_uniqueid, fattr->cf_nlink);
>>  }
>>
>> -
>> -/* Fill a cifs_fattr struct with info from FILE_ALL_INFO */
>> -static void
>> -cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
>> -                      struct super_block *sb, bool adjust_tz,
>> -                      bool symlink, u32 reparse_tag)
>> +static void cifs_open_info_to_fattr(struct cifs_fattr *fattr, struct c=
ifs_open_info_data *data,
>> +                                   struct super_block *sb, bool adjust=
_tz, bool symlink,
>> +                                   u32 reparse_tag)
>>  {
>> +       struct smb2_file_all_info *info =3D &data->fi;
>>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>>         struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
>>
>> @@ -703,7 +736,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FI=
LE_ALL_INFO *info,
>>         } else if (reparse_tag =3D=3D IO_REPARSE_TAG_LX_BLK) {
>>                 fattr->cf_mode |=3D S_IFBLK | cifs_sb->ctx->file_mode;
>>                 fattr->cf_dtype =3D DT_BLK;
>> -       } else if (symlink) { /* TODO add more reparse tag checks */
>> +       } else if (symlink || reparse_tag =3D=3D IO_REPARSE_TAG_SYMLINK=
 ||
>> +                  reparse_tag =3D=3D IO_REPARSE_TAG_NFS) {
>>                 fattr->cf_mode =3D S_IFLNK;
>>                 fattr->cf_dtype =3D DT_LNK;
>>         } else if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
>> @@ -735,6 +769,11 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, F=
ILE_ALL_INFO *info,
>>                 }
>>         }
>>
>> +       if (S_ISLNK(fattr->cf_mode)) {
>> +               fattr->cf_symlink_target =3D data->symlink_target;
>> +               data->symlink_target =3D NULL;
>> +       }
>> +
>>         fattr->cf_uid =3D cifs_sb->ctx->linux_uid;
>>         fattr->cf_gid =3D cifs_sb->ctx->linux_gid;
>>  }
>> @@ -744,23 +783,28 @@ cifs_get_file_info(struct file *filp)
>>  {
>>         int rc;
>>         unsigned int xid;
>> -       FILE_ALL_INFO find_data;
>> +       struct cifs_open_info_data data =3D {};
>>         struct cifs_fattr fattr;
>>         struct inode *inode =3D file_inode(filp);
>>         struct cifsFileInfo *cfile =3D filp->private_data;
>>         struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
>>         struct TCP_Server_Info *server =3D tcon->ses->server;
>> +       bool symlink =3D false;
>> +       u32 tag =3D 0;
>>
>>         if (!server->ops->query_file_info)
>>                 return -ENOSYS;
>>
>>         xid =3D get_xid();
>> -       rc =3D server->ops->query_file_info(xid, tcon, &cfile->fid, &fi=
nd_data);
>> +       rc =3D server->ops->query_file_info(xid, tcon,
Yep=2E
