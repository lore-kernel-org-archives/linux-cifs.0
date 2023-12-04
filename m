Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OnMtzZ7+"
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D892E5
	for <linux-cifs@vger.kernel.org>; Mon,  4 Dec 2023 04:19:16 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-50bfe99b6edso223885e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 04 Dec 2023 04:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701692354; x=1702297154; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5BqC3k34JFwg4pBmA0f6pvvgzU05IbofQuLrhMixZnE=;
        b=OnMtzZ7+vrps/C8nv7M4cHvjnPHil+2K3ROElAXtIogZ3qGHbqb0JMC78fgecNNN/C
         MW7ZYOEsicZGsZrR2wIdouuyjTaWuxNGgCbsO/gdKGLm6KihkixPHfe3f3uD/TA2vydN
         +3nn9c67toP6o+iVYN0redGTZaa4Qyzpuw59+Kmr97IuKGpClfyChIoSvt7CUPB8FHQ3
         zqczw5XBYKKP+MIwZEeb4rQfS77IygUNeyHFlALSarOBOx2+HPSUVFeu481hPohCnnyX
         ozpU1twkwbBVfHnLkpJ3x1kEdzkStnDiJwXh0AXFLZI0tUdZPPnEqFbRKpi6alcEjtjq
         KJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701692354; x=1702297154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5BqC3k34JFwg4pBmA0f6pvvgzU05IbofQuLrhMixZnE=;
        b=tHTC16uiyDdX56E5Mo7GnGiDh6Nj9GfG1iBpdSOA5jPlFjpfmsiYqOKMULGOs6TwxF
         jd2OgU/UKu4Mpow4di+RjUkF8hhtqEha1HLnWYTxdNBLHYlccr6d+YfXoR/3dN5c+eL+
         cXYEKTO7IxF5UZ4EHs2YXiKN1Xsm+6wCZNqo0gTMOPlhmIr3W2kn5Zm864luyitfT+cG
         C4Wy9Lgo/otpwKsR7+02G6uEyIJbaPKqUqlRFfkHEnjU1Oqh+9cVQ9DHod9tBY7mbMaq
         DZFtDNG7TI036meSkEnHMqW/GIt4xScnOp8kfPdIzeyTJgVPy7rrbSazaZO42Oc6/V/Q
         EdzQ==
X-Gm-Message-State: AOJu0YwaceAEjKpBeMxQH7+A5I7cehcxMldifa8/SPiKugnso65awc/n
	gdztLGW5eBW/VgpWHgWt1WysdmLe9KolWHzJmFs=
X-Google-Smtp-Source: AGHT+IFDF/evx7hUyiukI/i8t5U0N8iOgurahIHou6xo8A5kKfF4BHYNYxH5xuCnd9pNyG2+R5uKKPOTD1NB+M1mkfc=
X-Received: by 2002:ac2:5982:0:b0:50b:ebbf:b319 with SMTP id
 w2-20020ac25982000000b0050bebbfb319mr1380854lfn.65.1701692353792; Mon, 04 Dec
 2023 04:19:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com>
In-Reply-To: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 4 Dec 2023 17:49:02 +0530
Message-ID: <CANT5p=pLFrVZCbSM7Y2PMzREmzn2P7-zhqq84nMKEBNbL7P3=A@mail.gmail.com>
Subject: Re: [PATCH] cifs: Reuse file lease key in compound operations
To: meetakshisetiyaoss@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, bharathsm.hsk@gmail.com, 
	pc@manguebit.com, lsahlber@redhat.com, tom@talpey.com, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 4, 2023 at 10:26=E2=80=AFAM <meetakshisetiyaoss@gmail.com> wrot=
e:
>
> From: Meetakshi Setiya <msetiya@microsoft.com>
>
> Lock contention during unlink operation causes cifs lease break ack
> worker thread to block and delay sending lease break acks to server.
> This case occurs when multiple threads perform unlink, write and lease
> break acks on the same file. Thhis patch fixes the problem by reusing
> the existing lease keys for rename, unlink and set path size compound
> operations so that the client does not break its own lease.

I think we can be more clear on when the issue can occur:

The issue can be seen when a file has a lot of dirty pages to be
written to the server.
When a rename, unlink or set path size compound operation is requested
on this file,
we do not send the lease key for these requests. As a result, the
server can assume
that this request is from a new client, and send a lease break
notification to the same
client, on the same connection. As a response to the lease break, the
client can consume
several credits to write the dirty pages to the server. Depending on
the server's credit
grant implementation, the server can stop granting more credits to
this connection, and
this can cause a deadlock (which can only be resolved when the lease
timer on the server
expires). One of the problems here is that the client is sending no
lease key, even if it
has a lease for the file.

Thhis patch fixes the problem by reusing the existing lease keys for
rename, unlink
and set path size compound operations so that the client does not
break its own lease.

>
> Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h  |  6 ++---
>  fs/smb/client/cifsproto.h |  8 +++----
>  fs/smb/client/cifssmb.c   |  6 ++---
>  fs/smb/client/inode.c     | 12 +++++-----
>  fs/smb/client/smb2inode.c | 49 +++++++++++++++++++++++++--------------
>  fs/smb/client/smb2proto.h |  8 +++----
>  6 files changed, 51 insertions(+), 38 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 7558167f603c..3f6f993357bd 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -355,7 +355,7 @@ struct smb_version_operations {
>                             struct cifs_open_info_data *data);
>         /* set size by path */
>         int (*set_path_size)(const unsigned int, struct cifs_tcon *,
> -                            const char *, __u64, struct cifs_sb_info *, =
bool);
> +                            const char *, __u64, struct cifs_sb_info *, =
bool, struct dentry *);
>         /* set size by file handle */
>         int (*set_file_size)(const unsigned int, struct cifs_tcon *,
>                              struct cifsFileInfo *, __u64, bool);
> @@ -385,13 +385,13 @@ struct smb_version_operations {
>                      struct cifs_sb_info *);
>         /* unlink file */
>         int (*unlink)(const unsigned int, struct cifs_tcon *, const char =
*,
> -                     struct cifs_sb_info *);
> +                     struct cifs_sb_info *, struct dentry *);
>         /* open, rename and delete file */
>         int (*rename_pending_delete)(const char *, struct dentry *,
>                                      const unsigned int);
>         /* send rename request */
>         int (*rename)(const unsigned int, struct cifs_tcon *, const char =
*,
> -                     const char *, struct cifs_sb_info *);
> +                     const char *, struct cifs_sb_info *, struct dentry =
*);
>         /* send create hardlink request */
>         int (*create_hardlink)(const unsigned int, struct cifs_tcon *,
>                                const char *, const char *,
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 46feaa0880bd..3bb15cc74bc2 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -397,8 +397,8 @@ extern int CIFSSMBSetFileDisposition(const unsigned i=
nt xid,
>                                      bool delete_file, __u16 fid,
>                                      __u32 pid_of_opener);
>  extern int CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
> -                        const char *file_name, __u64 size,
> -                        struct cifs_sb_info *cifs_sb, bool set_allocatio=
n);
> +                        const char *file_name, __u64 size, struct cifs_s=
b_info *cifs_sb,
> +                        bool set_allocation, struct dentry *dentry);
>  extern int CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *=
tcon,
>                               struct cifsFileInfo *cfile, __u64 size,
>                               bool set_allocation);
> @@ -434,10 +434,10 @@ extern int CIFSPOSIXDelFile(const unsigned int xid,=
 struct cifs_tcon *tcon,
>                         const struct nls_table *nls_codepage,
>                         int remap_special_chars);
>  extern int CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon=
,
> -                         const char *name, struct cifs_sb_info *cifs_sb)=
;
> +                         const char *name, struct cifs_sb_info *cifs_sb,=
 struct dentry *dentry);
>  extern int CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
>                          const char *from_name, const char *to_name,
> -                        struct cifs_sb_info *cifs_sb);
> +                        struct cifs_sb_info *cifs_sb, struct dentry *den=
try);
>  extern int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tco=
n *tcon,
>                                  int netfid, const char *target_name,
>                                  const struct nls_table *nls_codepage,
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index 9ee348e6d106..023b3bfa7b94 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -738,7 +738,7 @@ CIFSPOSIXDelFile(const unsigned int xid, struct cifs_=
tcon *tcon,
>
>  int
>  CIFSSMBDelFile(const unsigned int xid, struct cifs_tcon *tcon, const cha=
r *name,
> -              struct cifs_sb_info *cifs_sb)
> +              struct cifs_sb_info *cifs_sb, struct dentry *dentry)
>  {
>         DELETE_FILE_REQ *pSMB =3D NULL;
>         DELETE_FILE_RSP *pSMBr =3D NULL;
> @@ -2152,7 +2152,7 @@ CIFSSMBFlush(const unsigned int xid, struct cifs_tc=
on *tcon, int smb_file_id)
>  int
>  CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
>               const char *from_name, const char *to_name,
> -             struct cifs_sb_info *cifs_sb)
> +             struct cifs_sb_info *cifs_sb, struct dentry *dentry)
>  {
>         int rc =3D 0;
>         RENAME_REQ *pSMB =3D NULL;
> @@ -4982,7 +4982,7 @@ CIFSSMBQFSPosixInfo(const unsigned int xid, struct =
cifs_tcon *tcon,
>  int
>  CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
>               const char *file_name, __u64 size, struct cifs_sb_info *cif=
s_sb,
> -             bool set_allocation)
> +             bool set_allocation, struct dentry *dentry)
>  {
>         struct smb_com_transaction2_spi_req *pSMB =3D NULL;
>         struct smb_com_transaction2_spi_rsp *pSMBr =3D NULL;
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index d01e9ea67ccd..d5ad54733637 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -1828,7 +1828,7 @@ int cifs_unlink(struct inode *dir, struct dentry *d=
entry)
>                 goto psx_del_no_retry;
>         }
>
> -       rc =3D server->ops->unlink(xid, tcon, full_path, cifs_sb);
> +       rc =3D server->ops->unlink(xid, tcon, full_path, cifs_sb, dentry)=
;
>
>  psx_del_no_retry:
>         if (!rc) {
> @@ -2227,7 +2227,7 @@ cifs_do_rename(const unsigned int xid, struct dentr=
y *from_dentry,
>                 return -ENOSYS;
>
>         /* try path-based rename first */
> -       rc =3D server->ops->rename(xid, tcon, from_path, to_path, cifs_sb=
);
> +       rc =3D server->ops->rename(xid, tcon, from_path, to_path, cifs_sb=
, from_dentry);
>
>         /*
>          * Don't bother with rename by filehandle unless file is busy and
> @@ -2774,7 +2774,7 @@ void cifs_setsize(struct inode *inode, loff_t offse=
t)
>
>  static int
>  cifs_set_file_size(struct inode *inode, struct iattr *attrs,
> -                  unsigned int xid, const char *full_path)
> +                  unsigned int xid, const char *full_path, struct dentry=
 *dentry)
>  {
>         int rc;
>         struct cifsFileInfo *open_file;
> @@ -2825,7 +2825,7 @@ cifs_set_file_size(struct inode *inode, struct iatt=
r *attrs,
>          */
>         if (server->ops->set_path_size)
>                 rc =3D server->ops->set_path_size(xid, tcon, full_path,
> -                                               attrs->ia_size, cifs_sb, =
false);
> +                                               attrs->ia_size, cifs_sb, =
false, dentry);
>         else
>                 rc =3D -ENOSYS;
>         cifs_dbg(FYI, "SetEOF by path (setattrs) rc =3D %d\n", rc);
> @@ -2915,7 +2915,7 @@ cifs_setattr_unix(struct dentry *direntry, struct i=
attr *attrs)
>         rc =3D 0;
>
>         if (attrs->ia_valid & ATTR_SIZE) {
> -               rc =3D cifs_set_file_size(inode, attrs, xid, full_path);
> +               rc =3D cifs_set_file_size(inode, attrs, xid, full_path, d=
irentry);
>                 if (rc !=3D 0)
>                         goto out;
>         }
> @@ -3081,7 +3081,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct=
 iattr *attrs)
>         }
>
>         if (attrs->ia_valid & ATTR_SIZE) {
> -               rc =3D cifs_set_file_size(inode, attrs, xid, full_path);
> +               rc =3D cifs_set_file_size(inode, attrs, xid, full_path, d=
irentry);
>                 if (rc !=3D 0)
>                         goto cifs_setattr_exit;
>         }
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index c94940af5d4b..ebee4779c743 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -48,7 +48,7 @@ static int smb2_compound_op(const unsigned int xid, str=
uct cifs_tcon *tcon,
>                             __u32 desired_access, __u32 create_dispositio=
n, __u32 create_options,
>                             umode_t mode, void *ptr, int command, struct =
cifsFileInfo *cfile,
>                             __u8 **extbuf, size_t *extbuflen,
> -                           struct kvec *out_iov, int *out_buftype)
> +                           struct kvec *out_iov, int *out_buftype, struc=
t dentry *dentry)
>  {
>         struct smb2_compound_vars *vars =3D NULL;
>         struct kvec *rsp_iov;
> @@ -59,6 +59,8 @@ static int smb2_compound_op(const unsigned int xid, str=
uct cifs_tcon *tcon,
>         struct cifs_fid fid;
>         struct cifs_ses *ses =3D tcon->ses;
>         struct TCP_Server_Info *server;
> +       struct inode *inode =3D NULL;
> +       struct cifsInodeInfo *cinode =3D NULL;
>         int num_rqst =3D 0;
>         int resp_buftype[3];
>         struct smb2_query_info_rsp *qi_rsp =3D NULL;
> @@ -93,6 +95,16 @@ static int smb2_compound_op(const unsigned int xid, st=
ruct cifs_tcon *tcon,
>                 goto finished;
>         }
>
> +       //if there is an existing lease, reuse it
> +       if (dentry) {
> +               inode =3D d_inode(dentry);
> +               cinode =3D CIFS_I(inode);
> +               if (cinode->lease_granted) {
> +                       oplock =3D SMB2_OPLOCK_LEVEL_LEASE;
> +                       memcpy(fid.lease_key, cinode->lease_key, SMB2_LEA=
SE_KEY_SIZE);
> +               }
> +       }
> +
>         vars->oparms =3D (struct cifs_open_parms) {
>                 .tcon =3D tcon,
>                 .path =3D full_path,
> @@ -596,7 +608,7 @@ int smb2_query_path_info(const unsigned int xid,
>         cifs_get_readable_path(tcon, full_path, &cfile);
>         rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_=
ATTRIBUTES, FILE_OPEN,
>                               create_options, ACL_NO_MODE, data, SMB2_OP_=
QUERY_INFO, cfile,
> -                             NULL, NULL, out_iov, out_buftype);
> +                             NULL, NULL, out_iov, out_buftype, NULL);
>         hdr =3D out_iov[0].iov_base;
>         /*
>          * If first iov is unset, then SMB session was dropped or we've g=
ot a
> @@ -619,7 +631,7 @@ int smb2_query_path_info(const unsigned int xid,
>                                       FILE_READ_ATTRIBUTES, FILE_OPEN,
>                                       create_options, ACL_NO_MODE, data,
>                                       SMB2_OP_QUERY_INFO, cfile, NULL, NU=
LL,
> -                                     NULL, NULL);
> +                                     NULL, NULL, NULL);
>                 break;
>         case -EREMOTE:
>                 break;
> @@ -674,7 +686,7 @@ int smb311_posix_query_path_info(const unsigned int x=
id,
>         cifs_get_readable_path(tcon, full_path, &cfile);
>         rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, FILE_READ_=
ATTRIBUTES, FILE_OPEN,
>                               create_options, ACL_NO_MODE, data, SMB2_OP_=
POSIX_QUERY_INFO, cfile,
> -                             &sidsbuf, &sidsbuflen, out_iov, out_buftype=
);
> +                             &sidsbuf, &sidsbuflen, out_iov, out_buftype=
, NULL);
>         /*
>          * If first iov is unset, then SMB session was dropped or we've g=
ot a
>          * cached open file (@cfile).
> @@ -696,7 +708,7 @@ int smb311_posix_query_path_info(const unsigned int x=
id,
>                 rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, FI=
LE_READ_ATTRIBUTES,
>                                       FILE_OPEN, create_options, ACL_NO_M=
ODE, data,
>                                       SMB2_OP_POSIX_QUERY_INFO, cfile,
> -                                     &sidsbuf, &sidsbuflen, NULL, NULL);
> +                                     &sidsbuf, &sidsbuflen, NULL, NULL, =
NULL);
>                 break;
>         }
>
> @@ -735,7 +747,7 @@ smb2_mkdir(const unsigned int xid, struct inode *pare=
nt_inode, umode_t mode,
>         return smb2_compound_op(xid, tcon, cifs_sb, name,
>                                 FILE_WRITE_ATTRIBUTES, FILE_CREATE,
>                                 CREATE_NOT_FILE, mode, NULL, SMB2_OP_MKDI=
R,
> -                               NULL, NULL, NULL, NULL, NULL);
> +                               NULL, NULL, NULL, NULL, NULL, NULL);
>  }
>
>  void
> @@ -757,7 +769,7 @@ smb2_mkdir_setinfo(struct inode *inode, const char *n=
ame,
>         tmprc =3D smb2_compound_op(xid, tcon, cifs_sb, name,
>                                  FILE_WRITE_ATTRIBUTES, FILE_CREATE,
>                                  CREATE_NOT_FILE, ACL_NO_MODE,
> -                                &data, SMB2_OP_SET_INFO, cfile, NULL, NU=
LL, NULL, NULL);
> +                                &data, SMB2_OP_SET_INFO, cfile, NULL, NU=
LL, NULL, NULL, NULL);
>         if (tmprc =3D=3D 0)
>                 cifs_i->cifsAttrs =3D dosattrs;
>  }
> @@ -769,23 +781,24 @@ smb2_rmdir(const unsigned int xid, struct cifs_tcon=
 *tcon, const char *name,
>         drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
>         return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OP=
EN,
>                                 CREATE_NOT_FILE, ACL_NO_MODE,
> -                               NULL, SMB2_OP_RMDIR, NULL, NULL, NULL, NU=
LL, NULL);
> +                               NULL, SMB2_OP_RMDIR, NULL, NULL, NULL, NU=
LL, NULL, NULL);
>  }
>
>  int
>  smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *=
name,
> -           struct cifs_sb_info *cifs_sb)
> +           struct cifs_sb_info *cifs_sb, struct dentry *dentry)
>  {
>         return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OP=
EN,
>                                 CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POI=
NT,
> -                               ACL_NO_MODE, NULL, SMB2_OP_DELETE, NULL, =
NULL, NULL, NULL, NULL);
> +                               ACL_NO_MODE, NULL, SMB2_OP_DELETE, NULL, =
NULL,
> +                               NULL, NULL, NULL, dentry);
>  }
>
>  static int
>  smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
>                    const char *from_name, const char *to_name,
>                    struct cifs_sb_info *cifs_sb, __u32 access, int comman=
d,
> -                  struct cifsFileInfo *cfile)
> +                  struct cifsFileInfo *cfile, struct dentry *dentry)
>  {
>         __le16 *smb2_to_name =3D NULL;
>         int rc;
> @@ -797,7 +810,7 @@ smb2_set_path_attr(const unsigned int xid, struct cif=
s_tcon *tcon,
>         }
>         rc =3D smb2_compound_op(xid, tcon, cifs_sb, from_name, access,
>                               FILE_OPEN, 0, ACL_NO_MODE, smb2_to_name,
> -                             command, cfile, NULL, NULL, NULL, NULL);
> +                             command, cfile, NULL, NULL, NULL, NULL, den=
try);
>  smb2_rename_path:
>         kfree(smb2_to_name);
>         return rc;
> @@ -806,7 +819,7 @@ smb2_set_path_attr(const unsigned int xid, struct cif=
s_tcon *tcon,
>  int
>  smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
>                  const char *from_name, const char *to_name,
> -                struct cifs_sb_info *cifs_sb)
> +                struct cifs_sb_info *cifs_sb, struct dentry *dentry)
>  {
>         struct cifsFileInfo *cfile;
>
> @@ -814,7 +827,7 @@ smb2_rename_path(const unsigned int xid, struct cifs_=
tcon *tcon,
>         cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfi=
le);
>
>         return smb2_set_path_attr(xid, tcon, from_name, to_name,
> -                                 cifs_sb, DELETE, SMB2_OP_RENAME, cfile)=
;
> +                                 cifs_sb, DELETE, SMB2_OP_RENAME, cfile,=
 dentry);
>  }
>
>  int
> @@ -824,13 +837,13 @@ smb2_create_hardlink(const unsigned int xid, struct=
 cifs_tcon *tcon,
>  {
>         return smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
>                                   FILE_READ_ATTRIBUTES, SMB2_OP_HARDLINK,
> -                                 NULL);
> +                                 NULL, NULL);
>  }
>
>  int
>  smb2_set_path_size(const unsigned int xid, struct cifs_tcon *tcon,
>                    const char *full_path, __u64 size,
> -                  struct cifs_sb_info *cifs_sb, bool set_alloc)
> +                  struct cifs_sb_info *cifs_sb, bool set_alloc, struct d=
entry *dentry)
>  {
>         __le64 eof =3D cpu_to_le64(size);
>         struct cifsFileInfo *cfile;
> @@ -838,7 +851,7 @@ smb2_set_path_size(const unsigned int xid, struct cif=
s_tcon *tcon,
>         cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
>         return smb2_compound_op(xid, tcon, cifs_sb, full_path,
>                                 FILE_WRITE_DATA, FILE_OPEN, 0, ACL_NO_MOD=
E,
> -                               &eof, SMB2_OP_SET_EOF, cfile, NULL, NULL,=
 NULL, NULL);
> +                               &eof, SMB2_OP_SET_EOF, cfile, NULL, NULL,=
 NULL, NULL, dentry);
>  }
>
>  int
> @@ -865,7 +878,7 @@ smb2_set_file_info(struct inode *inode, const char *f=
ull_path,
>         rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path,
>                               FILE_WRITE_ATTRIBUTES, FILE_OPEN,
>                               0, ACL_NO_MODE, buf, SMB2_OP_SET_INFO, cfil=
e,
> -                             NULL, NULL, NULL, NULL);
> +                             NULL, NULL, NULL, NULL, NULL);
>         cifs_put_tlink(tlink);
>         return rc;
>  }
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index 46eff9ec302a..ec3755110da5 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -62,8 +62,8 @@ int smb2_query_path_info(const unsigned int xid,
>                          const char *full_path,
>                          struct cifs_open_info_data *data);
>  extern int smb2_set_path_size(const unsigned int xid, struct cifs_tcon *=
tcon,
> -                             const char *full_path, __u64 size,
> -                             struct cifs_sb_info *cifs_sb, bool set_allo=
c);
> +                             const char *full_path, __u64 size, struct c=
ifs_sb_info *cifs_sb,
> +                                 bool set_alloc, struct dentry *dentry);
>  extern int smb2_set_file_info(struct inode *inode, const char *full_path=
,
>                               FILE_BASIC_INFO *buf, const unsigned int xi=
d);
>  extern int smb311_posix_mkdir(const unsigned int xid, struct inode *inod=
e,
> @@ -79,10 +79,10 @@ extern void smb2_mkdir_setinfo(struct inode *inode, c=
onst char *full_path,
>  extern int smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon,
>                       const char *name, struct cifs_sb_info *cifs_sb);
>  extern int smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon,
> -                      const char *name, struct cifs_sb_info *cifs_sb);
> +                      const char *name, struct cifs_sb_info *cifs_sb, st=
ruct dentry *dentry);
>  extern int smb2_rename_path(const unsigned int xid, struct cifs_tcon *tc=
on,
>                             const char *from_name, const char *to_name,
> -                           struct cifs_sb_info *cifs_sb);
> +                           struct cifs_sb_info *cifs_sb, struct dentry *=
dentry);
>  extern int smb2_create_hardlink(const unsigned int xid, struct cifs_tcon=
 *tcon,
>                                 const char *from_name, const char *to_nam=
e,
>                                 struct cifs_sb_info *cifs_sb);
> --
> 2.39.2
>

Looks good to me.
Please make sure to test this out by setting a low value for
max_credits (maybe 10 or 20).
Make sure that the vm layer maintains dirty buffers for longer (check
vm.dirty_ratio and vm.dirty_background_ratio). And then periodically
trigger renames to the file.

--=20
Regards,
Shyam
