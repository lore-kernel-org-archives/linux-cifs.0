Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5BBEB64DC
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jul 2023 15:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbjGNPdt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jul 2023 11:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbjGNPdp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jul 2023 11:33:45 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152941980
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 08:33:43 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b703caf344so30878351fa.1
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 08:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689348821; x=1691940821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kXqOdAw/LXv+PhyTfAHL4SziwMKyWT/NZMOsSiK9AzE=;
        b=cNzWRFkDVNHGGp0xj+tSHUdBcZggQbJErzfQoYFgIUl893TzRnneB7/zEdM21/pRrf
         6vfvtuqmZQeIz84tsPnyDMGrn0x7I8H7rY9jvxCX/8i9SRHLb8OeJuV7gLnBPPcQ5V8J
         0HB0PIK7emOG8H6maWsv7Irm+5Se9rwnbCeP8y5kdxap/sUFhncumP9FIa98U3LOwFxv
         DLMB3deu4KDWHOHwdOo/ZCQQjSwikfl9gQVuhhEu3xT3ebqkA6aAzu6LeFq9Uur61sHN
         v4M2RW/nRzAaozi1NX1ws4mEYyiIcZIvzcUUlFiusleIgSOTxXYWi89z8/AYsuFUJpO5
         w47g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689348821; x=1691940821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kXqOdAw/LXv+PhyTfAHL4SziwMKyWT/NZMOsSiK9AzE=;
        b=TYhJ/CttUqJrm5HM5V3vxYM03ZnbPlVe5TwJtG/t+VpOYEIhU1KO0WSBOgnnmBJ/BP
         gM4Dztts8v8q962TmHVUS7OAjRC2X4kjvc3wRwbFosY6WfJ33z6AlWZtYRl6gXbjxyKo
         0XbaXNaU/0QoQQl5JagB5Aiv3kbxfeUYZn51j49FSLje9PapS1pNPXKfh9/qubBTAmOq
         8xR9slpM9bLhM0DMiOtxSKTTDWbbJFKI39r+5T9mTWTtboCURa0MgkCSm87/ZgdQl5bg
         0NCSAUcRA//aPMzLbkdWg7zBp5Jk52YCfhBebfmfuULLmBaUxCC7H3FZT64D1FLyNIok
         TYEQ==
X-Gm-Message-State: ABy/qLa/E5q2fqjmD6L0uumWgakxh/c/7mbEnJ+/VXw1Hi59NcVvBV3g
        2lixf+pbAqngoP7ZfWqAbmlOOnvQV42qj+i27z4=
X-Google-Smtp-Source: APBJJlFeKT6X6HgAxnZEd/ms/6BQfWl8r/OpWfqp4jpKu2/sTvDhPSn0aLku+I+/67jYpoYznkXx6ZRYXf8DbwVnEJ4=
X-Received: by 2002:a2e:9cd3:0:b0:2b8:67d1:155c with SMTP id
 g19-20020a2e9cd3000000b002b867d1155cmr677849ljj.39.1689348820755; Fri, 14 Jul
 2023 08:33:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230711123034.23856-1-linkinjeon@kernel.org> <cda0b3e1-840f-25f6-3147-65c7526fdd33@talpey.com>
 <CAKYAXd8_BLnOaFCpkau=u-EKcg_P1ktB3Ryg_6VirJeNDNtSxA@mail.gmail.com>
 <a16e9b83-415f-4a5f-a5a9-4e482a53a207@talpey.com> <CAKYAXd8i2S6zWE2XHmZhX_pRjb6cWU5Drz0XCwES2k+ZB8zAwQ@mail.gmail.com>
In-Reply-To: <CAKYAXd8i2S6zWE2XHmZhX_pRjb6cWU5Drz0XCwES2k+ZB8zAwQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 Jul 2023 10:33:29 -0500
Message-ID: <CAH2r5musR4QJTz-Q1TEoRNKmk=Cd+pYch0gV6cHBb6JrM8N8eA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: check if a mount point is crossed during path lookup
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        senozhatsky@chromium.org, hyc.lee@gmail.com,
        atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In the future if we want to make this more visible to the client
(although presumably query fs info/statfs can still return the correct
information depending on the path given by the user) we could always
make this a fake DFS referral after we cross a mount point on the
server

On Fri, Jul 14, 2023 at 8:25=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> 2023-07-14 21:44 GMT+09:00, Tom Talpey <tom@talpey.com>:
> > On 7/12/2023 7:40 PM, Namjae Jeon wrote:
> >> 2023-07-13 2:23 GMT+09:00, Tom Talpey <tom@talpey.com>:
> >>> On 7/11/2023 8:30 AM, Namjae Jeon wrote:
> >>>> Since commit 74d7970febf7 ("ksmbd: fix racy issue from using ->d_par=
ent
> >>>> and ->d_name"),
> >>>> ksmbd can not lookup cross mount points. If last component is a cros=
s
> >>>> mount point during path lookup, check if it is crossed to follow it
> >>>> down.
> >>>
> >>> I actually thought not crossing mount points was intended, since
> >>> semantics can shift if the crossing changes filesystems or fs types.
> >>>
> >>> Does this change somehow prevent walking out of a mount via embedded
> >>> "/../" in the path? It's not obvious to me whether
> >>> vfs_path_parent_lookup
> >>> denies this.
> >> Yes, LOOKUP_BENEATH flags protect to lookup out of share.
> >>>
> >>> Tom.
> >>>
> >>> I'm not familiar enough with the VFS protection, but does this
> >> I have checked it before and now again. There is no problem.
> >
> > I'm still concerned about this. Crossing mount points in the server is
> > completely invisible to the client, yet the semantics change radically.
> Have you checked it with samba server ? This is exactly the same behavior
> as samba server.
>
> And users are also wanting exactly the same behavior as before.
> https://github.com/namjaejeon/ksmbd/issues/436
> >
> > What if someone shares "/mnt", and proceeds to mount an ext4, a USB
> > FAT32, a CD-Rom, and an NFS filesystem in subdirectories? The client
> > has no clue, and will walk into them all, finding a very different
> > world in each.
> >
> > How will Posix extensions work across this? Case sensitivity/preserving=
?
> > Caching and locks/leases?
> I didn't understand exactly your question.
> And NFS also supports crossmnt, and we will be able to add 'crossmnt' par=
ameter
> in smb.conf and work crossmnt by default.
>
> Thanks.
> >
> > Tom.
> >> Thanks!
> >>>>
> >>>> Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent an=
d
> >>>> ->d_name")
> >>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> >>>> ---
> >>>>    fs/smb/server/smb2pdu.c | 27 ++++++++++++--------
> >>>>    fs/smb/server/vfs.c     | 56
> >>>> +++++++++++++++++++++++------------------
> >>>>    fs/smb/server/vfs.h     |  4 +--
> >>>>    3 files changed, 49 insertions(+), 38 deletions(-)
> >>>>
> >>>> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> >>>> index cf8822103f50..ca276634fd58 100644
> >>>> --- a/fs/smb/server/smb2pdu.c
> >>>> +++ b/fs/smb/server/smb2pdu.c
> >>>> @@ -2467,8 +2467,9 @@ static void smb2_update_xattrs(struct
> >>>> ksmbd_tree_connect *tcon,
> >>>>            }
> >>>>    }
> >>>>
> >>>> -static int smb2_creat(struct ksmbd_work *work, struct path *path, c=
har
> >>>> *name,
> >>>> -                int open_flags, umode_t posix_mode, bool is_dir)
> >>>> +static int smb2_creat(struct ksmbd_work *work, struct path
> >>>> *parent_path,
> >>>> +                struct path *path, char *name, int open_flags,
> >>>> +                umode_t posix_mode, bool is_dir)
> >>>>    {
> >>>>            struct ksmbd_tree_connect *tcon =3D work->tcon;
> >>>>            struct ksmbd_share_config *share =3D tcon->share_conf;
> >>>> @@ -2495,7 +2496,7 @@ static int smb2_creat(struct ksmbd_work *work,
> >>>> struct path *path, char *name,
> >>>>                            return rc;
> >>>>            }
> >>>>
> >>>> -  rc =3D ksmbd_vfs_kern_path_locked(work, name, 0, path, 0);
> >>>> +  rc =3D ksmbd_vfs_kern_path_locked(work, name, 0, parent_path, pat=
h, 0);
> >>>>            if (rc) {
> >>>>                    pr_err("cannot get linux path (%s), err =3D %d\n"=
,
> >>>>                           name, rc);
> >>>> @@ -2565,7 +2566,7 @@ int smb2_open(struct ksmbd_work *work)
> >>>>            struct ksmbd_tree_connect *tcon =3D work->tcon;
> >>>>            struct smb2_create_req *req;
> >>>>            struct smb2_create_rsp *rsp;
> >>>> -  struct path path;
> >>>> +  struct path path, parent_path;
> >>>>            struct ksmbd_share_config *share =3D tcon->share_conf;
> >>>>            struct ksmbd_file *fp =3D NULL;
> >>>>            struct file *filp =3D NULL;
> >>>> @@ -2786,7 +2787,8 @@ int smb2_open(struct ksmbd_work *work)
> >>>>                    goto err_out1;
> >>>>            }
> >>>>
> >>>> -  rc =3D ksmbd_vfs_kern_path_locked(work, name, LOOKUP_NO_SYMLINKS,
> >>>> &path,
> >>>> 1);
> >>>> +  rc =3D ksmbd_vfs_kern_path_locked(work, name, LOOKUP_NO_SYMLINKS,
> >>>> +                                  &parent_path, &path, 1);
> >>>>            if (!rc) {
> >>>>                    file_present =3D true;
> >>>>
> >>>> @@ -2906,7 +2908,8 @@ int smb2_open(struct ksmbd_work *work)
> >>>>
> >>>>            /*create file if not present */
> >>>>            if (!file_present) {
> >>>> -          rc =3D smb2_creat(work, &path, name, open_flags, posix_mo=
de,
> >>>> +          rc =3D smb2_creat(work, &parent_path, &path, name, open_f=
lags,
> >>>> +                          posix_mode,
> >>>>                                    req->CreateOptions & FILE_DIRECTO=
RY_FILE_LE);
> >>>>                    if (rc) {
> >>>>                            if (rc =3D=3D -ENOENT) {
> >>>> @@ -3321,8 +3324,9 @@ int smb2_open(struct ksmbd_work *work)
> >>>>
> >>>>    err_out:
> >>>>            if (file_present || created) {
> >>>> -          inode_unlock(d_inode(path.dentry->d_parent));
> >>>> -          dput(path.dentry);
> >>>> +          inode_unlock(d_inode(parent_path.dentry));
> >>>> +          path_put(&path);
> >>>> +          path_put(&parent_path);
> >>>>            }
> >>>>            ksmbd_revert_fsids(work);
> >>>>    err_out1:
> >>>> @@ -5545,7 +5549,7 @@ static int smb2_create_link(struct ksmbd_work
> >>>> *work,
> >>>>                                struct nls_table *local_nls)
> >>>>    {
> >>>>            char *link_name =3D NULL, *target_name =3D NULL, *pathnam=
e =3D NULL;
> >>>> -  struct path path;
> >>>> +  struct path path, parent_path;
> >>>>            bool file_present =3D false;
> >>>>            int rc;
> >>>>
> >>>> @@ -5575,7 +5579,7 @@ static int smb2_create_link(struct ksmbd_work
> >>>> *work,
> >>>>
> >>>>            ksmbd_debug(SMB, "target name is %s\n", target_name);
> >>>>            rc =3D ksmbd_vfs_kern_path_locked(work, link_name,
> >>>> LOOKUP_NO_SYMLINKS,
> >>>> -                                  &path, 0);
> >>>> +                                  &parent_path, &path, 0);
> >>>>            if (rc) {
> >>>>                    if (rc !=3D -ENOENT)
> >>>>                            goto out;
> >>>> @@ -5605,8 +5609,9 @@ static int smb2_create_link(struct ksmbd_work
> >>>> *work,
> >>>>                    rc =3D -EINVAL;
> >>>>    out:
> >>>>            if (file_present) {
> >>>> -          inode_unlock(d_inode(path.dentry->d_parent));
> >>>> +          inode_unlock(d_inode(parent_path.dentry));
> >>>>                    path_put(&path);
> >>>> +          path_put(&parent_path);
> >>>>            }
> >>>>            if (!IS_ERR(link_name))
> >>>>                    kfree(link_name);
> >>>> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> >>>> index e35914457350..fd06d267de61 100644
> >>>> --- a/fs/smb/server/vfs.c
> >>>> +++ b/fs/smb/server/vfs.c
> >>>> @@ -63,13 +63,13 @@ int ksmbd_vfs_lock_parent(struct dentry *parent,
> >>>> struct dentry *child)
> >>>>
> >>>>    static int ksmbd_vfs_path_lookup_locked(struct ksmbd_share_config
> >>>> *share_conf,
> >>>>                                            char *pathname, unsigned =
int flags,
> >>>> +                                  struct path *parent_path,
> >>>>                                            struct path *path)
> >>>>    {
> >>>>            struct qstr last;
> >>>>            struct filename *filename;
> >>>>            struct path *root_share_path =3D &share_conf->vfs_path;
> >>>>            int err, type;
> >>>> -  struct path parent_path;
> >>>>            struct dentry *d;
> >>>>
> >>>>            if (pathname[0] =3D=3D '\0') {
> >>>> @@ -84,7 +84,7 @@ static int ksmbd_vfs_path_lookup_locked(struct
> >>>> ksmbd_share_config *share_conf,
> >>>>                    return PTR_ERR(filename);
> >>>>
> >>>>            err =3D vfs_path_parent_lookup(filename, flags,
> >>>> -                               &parent_path, &last, &type,
> >>>> +                               parent_path, &last, &type,
> >>>>                                         root_share_path);
> >>>>            if (err) {
> >>>>                    putname(filename);
> >>>> @@ -92,13 +92,13 @@ static int ksmbd_vfs_path_lookup_locked(struct
> >>>> ksmbd_share_config *share_conf,
> >>>>            }
> >>>>
> >>>>            if (unlikely(type !=3D LAST_NORM)) {
> >>>> -          path_put(&parent_path);
> >>>> +          path_put(parent_path);
> >>>>                    putname(filename);
> >>>>                    return -ENOENT;
> >>>>            }
> >>>>
> >>>> -  inode_lock_nested(parent_path.dentry->d_inode, I_MUTEX_PARENT);
> >>>> -  d =3D lookup_one_qstr_excl(&last, parent_path.dentry, 0);
> >>>> +  inode_lock_nested(parent_path->dentry->d_inode, I_MUTEX_PARENT);
> >>>> +  d =3D lookup_one_qstr_excl(&last, parent_path->dentry, 0);
> >>>>            if (IS_ERR(d))
> >>>>                    goto err_out;
> >>>>
> >>>> @@ -108,15 +108,20 @@ static int ksmbd_vfs_path_lookup_locked(struct
> >>>> ksmbd_share_config *share_conf,
> >>>>            }
> >>>>
> >>>>            path->dentry =3D d;
> >>>> -  path->mnt =3D share_conf->vfs_path.mnt;
> >>>> -  path_put(&parent_path);
> >>>> -  putname(filename);
> >>>> +  path->mnt =3D mntget(parent_path->mnt);
> >>>> +
> >>>> +  err =3D follow_down(path, 0);
> >>>> +  if (err < 0) {
> >>>> +          path_put(path);
> >>>> +          goto err_out;
> >>>> +  }
> >>>>
> >>>> +  putname(filename);
> >>>>            return 0;
> >>>>
> >>>>    err_out:
> >>>> -  inode_unlock(parent_path.dentry->d_inode);
> >>>> -  path_put(&parent_path);
> >>>> +  inode_unlock(d_inode(parent_path->dentry));
> >>>> +  path_put(parent_path);
> >>>>            putname(filename);
> >>>>            return -ENOENT;
> >>>>    }
> >>>> @@ -1194,14 +1199,14 @@ static int ksmbd_vfs_lookup_in_dir(const str=
uct
> >>>> path *dir, char *name,
> >>>>     * Return:      0 on success, otherwise error
> >>>>     */
> >>>>    int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *nam=
e,
> >>>> -                         unsigned int flags, struct path *path,
> >>>> -                         bool caseless)
> >>>> +                         unsigned int flags, struct path *parent_pa=
th,
> >>>> +                         struct path *path, bool caseless)
> >>>>    {
> >>>>            struct ksmbd_share_config *share_conf =3D work->tcon->sha=
re_conf;
> >>>>            int err;
> >>>> -  struct path parent_path;
> >>>>
> >>>> -  err =3D ksmbd_vfs_path_lookup_locked(share_conf, name, flags, pat=
h);
> >>>> +  err =3D ksmbd_vfs_path_lookup_locked(share_conf, name, flags,
> >>>> parent_path,
> >>>> +                                     path);
> >>>>            if (!err)
> >>>>                    return 0;
> >>>>
> >>>> @@ -1216,10 +1221,10 @@ int ksmbd_vfs_kern_path_locked(struct
> >>>> ksmbd_work
> >>>> *work, char *name,
> >>>>                    path_len =3D strlen(filepath);
> >>>>                    remain_len =3D path_len;
> >>>>
> >>>> -          parent_path =3D share_conf->vfs_path;
> >>>> -          path_get(&parent_path);
> >>>> +          *parent_path =3D share_conf->vfs_path;
> >>>> +          path_get(parent_path);
> >>>>
> >>>> -          while (d_can_lookup(parent_path.dentry)) {
> >>>> +          while (d_can_lookup(parent_path->dentry)) {
> >>>>                            char *filename =3D filepath + path_len - =
remain_len;
> >>>>                            char *next =3D strchrnul(filename, '/');
> >>>>                            size_t filename_len =3D next - filename;
> >>>> @@ -1228,7 +1233,7 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_wo=
rk
> >>>> *work, char *name,
> >>>>                            if (filename_len =3D=3D 0)
> >>>>                                    break;
> >>>>
> >>>> -                  err =3D ksmbd_vfs_lookup_in_dir(&parent_path, fil=
ename,
> >>>> +                  err =3D ksmbd_vfs_lookup_in_dir(parent_path, file=
name,
> >>>>                                                          filename_le=
n,
> >>>>                                                          work->conn-=
>um);
> >>>>                            if (err)
> >>>> @@ -1245,8 +1250,8 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_wo=
rk
> >>>> *work, char *name,
> >>>>                                    goto out2;
> >>>>                            else if (is_last)
> >>>>                                    goto out1;
> >>>> -                  path_put(&parent_path);
> >>>> -                  parent_path =3D *path;
> >>>> +                  path_put(parent_path);
> >>>> +                  *parent_path =3D *path;
> >>>>
> >>>>                            next[0] =3D '/';
> >>>>                            remain_len -=3D filename_len + 1;
> >>>> @@ -1254,16 +1259,17 @@ int ksmbd_vfs_kern_path_locked(struct
> >>>> ksmbd_work
> >>>> *work, char *name,
> >>>>
> >>>>                    err =3D -EINVAL;
> >>>>    out2:
> >>>> -          path_put(&parent_path);
> >>>> +          path_put(parent_path);
> >>>>    out1:
> >>>>                    kfree(filepath);
> >>>>            }
> >>>>
> >>>>            if (!err) {
> >>>> -          err =3D ksmbd_vfs_lock_parent(parent_path.dentry, path->d=
entry);
> >>>> -          if (err)
> >>>> -                  dput(path->dentry);
> >>>> -          path_put(&parent_path);
> >>>> +          err =3D ksmbd_vfs_lock_parent(parent_path->dentry, path->=
dentry);
> >>>> +          if (err) {
> >>>> +                  path_put(path);
> >>>> +                  path_put(parent_path);
> >>>> +          }
> >>>>            }
> >>>>            return err;
> >>>>    }
> >>>> diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
> >>>> index 80039312c255..72f9fb4b48d1 100644
> >>>> --- a/fs/smb/server/vfs.h
> >>>> +++ b/fs/smb/server/vfs.h
> >>>> @@ -115,8 +115,8 @@ int ksmbd_vfs_xattr_stream_name(char *stream_nam=
e,
> >>>> char **xattr_stream_name,
> >>>>    int ksmbd_vfs_remove_xattr(struct mnt_idmap *idmap,
> >>>>                               const struct path *path, char *attr_na=
me);
> >>>>    int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *nam=
e,
> >>>> -                         unsigned int flags, struct path *path,
> >>>> -                         bool caseless);
> >>>> +                         unsigned int flags, struct path *parent_pa=
th,
> >>>> +                         struct path *path, bool caseless);
> >>>>    struct dentry *ksmbd_vfs_kern_path_create(struct ksmbd_work *work=
,
> >>>>                                              const char *name,
> >>>>                                              unsigned int flags,
> >>>
> >>
> >



--=20
Thanks,

Steve
