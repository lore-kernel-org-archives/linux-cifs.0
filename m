Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49382C3DA50
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353360AbjHQPx0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353362AbjHQPxP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:53:15 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31EB30C6
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:53:12 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2bba5d0c687so9138081fa.1
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692287591; x=1692892391;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ni65THkf5hFslZH1WnVatoiDJmWoxjTwFvRE8WCk3r0=;
        b=lYW41L+hKh9CkXc8qCZLoAdyOz7S8nQDuOiSsJLrCutDnqf1RUpyC3rtB+UF7Xap+I
         gsWz04ES0uB1Pz3bGggyO4u8R2AHDlp33oprC2N8+qAh8xmpBGjiEmTbisVKYGaQLYd0
         GWKaCLJzllG/HRKhGMWmTmX0QdrsIwaUERZ7QDBYxc8epDbxJHW3n0mrSK310NDX7hKz
         KKspOunPsn4eAXPoNMpbN2Be4z+U/9oAiM7detjwy9CMNfYxCeWTw8FWTav1EetwxA3O
         Ue6IOGZ7eQGwSA12BSHxarOvNkjIsQjqGxhNkiJe4Cn56pQ5K6ZKL+EKQnrpJfd4Y76V
         JL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692287591; x=1692892391;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ni65THkf5hFslZH1WnVatoiDJmWoxjTwFvRE8WCk3r0=;
        b=PxnhrdPZYayJqIWn/ZZD3+K21jhGojY2h/biMWKZeVogN8tsaaU/VejiaQiWKvkMnj
         7mM+oY00EBbLrtiZa6S24RN+f9r8xutvrVmte81GwrA1P6dY2AtVRD8WbLTBAg7jVqiH
         J0e2rHv6Na7kSx5WBBfxjTGVUfR/XVXGXaiMOCnhE9Z5i5fGy5r23CmdUj/vzL54hKM+
         I+mD1YdsOu89GgMf7ZHEeeh5vX2V1c9+rEvYSUsQw/hjnFmbNlGJgnBHIOiL8a/5aRtF
         0zUCErNrZ6zBYqITWee8DKpKIkGV238sAQDl2T5C1GGR4magKQIBHm5YbBvX+sqP/sct
         xu9g==
X-Gm-Message-State: AOJu0Yw/l4DqJojh+W33mMW3kWzpjDrHdhSXxVZ9IT+xSp1Z9Eda6yU2
        XaiGM8vwIUuzwKGiLiYJPT/QaQIDMPTlXkRt+0Vox6WM3ggx/w==
X-Google-Smtp-Source: AGHT+IFtcJtrR3fYnaTyjJo0owWUb0hoxVIWRl1gqzcHc9eSAQ99DbCZE/L92Ym2USA6g4y99XyP3ezNXLumQBSU+9I=
X-Received: by 2002:a2e:9bd5:0:b0:2b6:cb3f:97e2 with SMTP id
 w21-20020a2e9bd5000000b002b6cb3f97e2mr1365271ljj.16.1692287590760; Thu, 17
 Aug 2023 08:53:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230817153416.28083-1-pc@manguebit.com> <20230817153416.28083-10-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-10-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 17 Aug 2023 10:52:59 -0500
Message-ID: <CAH2r5msoEON7SE9H9sEMLMZcH2BgT94wOhhtXBnkpC3PAJCKXQ@mail.gmail.com>
Subject: Fwd: [PATCH 09/17] smb: client: do not query reparse points twice on symlinks
To:     Paulo Alcantara <pc@manguebit.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Am also curious about the problem where we do an extra query on
mfsymlinks with ls -l

---------- Forwarded message ---------
From: Paulo Alcantara <pc@manguebit.com>
Date: Thu, Aug 17, 2023 at 10:35=E2=80=AFAM
Subject: [PATCH 09/17] smb: client: do not query reparse points twice
on symlinks
To: <smfrench@gmail.com>
Cc: <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.com>


Save a roundtrip by getting the reparse point tag and buffer at once
in ->query_reparse_point() and then pass the buffer down to
->query_symlink().

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h |  20 +++--
 fs/smb/client/inode.c    |  19 +++--
 fs/smb/client/smb1ops.c  |  11 ++-
 fs/smb/client/smb2ops.c  | 166 ++++++---------------------------------
 4 files changed, 55 insertions(+), 161 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 95e62502cb01..639a61417b08 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -336,10 +336,13 @@ struct smb_version_operations {
        /* query file data from the server */
        int (*query_file_info)(const unsigned int xid, struct cifs_tcon *tc=
on,
                               struct cifsFileInfo *cfile, struct
cifs_open_info_data *data);
-       /* query reparse tag from srv to determine which type of special fi=
le */
-       int (*query_reparse_tag)(const unsigned int xid, struct cifs_tcon *=
tcon,
-                               struct cifs_sb_info *cifs_sb, const char *p=
ath,
-                               __u32 *reparse_tag);
+       /* query reparse point to determine which type of special file */
+       int (*query_reparse_point)(const unsigned int xid,
+                                  struct cifs_tcon *tcon,
+                                  struct cifs_sb_info *cifs_sb,
+                                  const char *full_path,
+                                  u32 *tag, struct kvec *rsp,
+                                  int *rsp_buftype);
        /* get server index number */
        int (*get_srv_inum)(const unsigned int xid, struct cifs_tcon *tcon,
                            struct cifs_sb_info *cifs_sb, const char
*full_path, u64 *uniqueid,
@@ -388,9 +391,12 @@ struct smb_version_operations {
                               const char *, const char *,
                               struct cifs_sb_info *);
        /* query symlink target */
-       int (*query_symlink)(const unsigned int, struct cifs_tcon *,
-                            struct cifs_sb_info *, const char *,
-                            char **, bool);
+       int (*query_symlink)(const unsigned int xid,
+                            struct cifs_tcon *tcon,
+                            struct cifs_sb_info *cifs_sb,
+                            const char *full_path,
+                            char **target_path,
+                            struct kvec *rsp_iov);
        /* open a file for non-posix mounts */
        int (*open)(const unsigned int xid, struct cifs_open_parms
*oparms, __u32 *oplock,
                    void *buf);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 51e2916730cf..96a09818aa5b 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -428,7 +428,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
                if (!server->ops->query_symlink)
                        return -EOPNOTSUPP;
                rc =3D server->ops->query_symlink(xid, tcon, cifs_sb, full_=
path,
-
&fattr.cf_symlink_target, false);
+                                               &fattr.cf_symlink_target, N=
ULL);
                if (rc) {
                        cifs_dbg(FYI, "%s: query_symlink: %d\n", __func__, =
rc);
                        goto cgiiu_exit;
@@ -988,17 +988,21 @@ static int query_reparse(struct cifs_open_info_data *=
data,
 {
        struct TCP_Server_Info *server =3D tcon->ses->server;
        struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
-       bool reparse_point =3D data->reparse_point;
+       struct kvec rsp_iov, *iov =3D NULL;
+       int rsp_buftype =3D CIFS_NO_BUFFER;
        u32 tag =3D data->reparse_tag;
        int rc =3D 0;

-       if (!tag && server->ops->query_reparse_tag) {
-               server->ops->query_reparse_tag(xid, tcon, cifs_sb,
-                                              full_path, &tag);
+       if (!tag && server->ops->query_reparse_point) {
+               rc =3D server->ops->query_reparse_point(xid, tcon, cifs_sb,
+                                                     full_path, &tag,
+                                                     &rsp_iov, &rsp_buftyp=
e);
+               if (!rc)
+                       iov =3D &rsp_iov;
        }
        switch ((data->reparse_tag =3D tag)) {
        case 0: /* SMB1 symlink */
-               reparse_point =3D false;
+               iov =3D NULL;
                fallthrough;
        case IO_REPARSE_TAG_NFS:
        case IO_REPARSE_TAG_SYMLINK:
@@ -1006,10 +1010,11 @@ static int query_reparse(struct
cifs_open_info_data *data,
                        rc =3D server->ops->query_symlink(xid, tcon,
                                                        cifs_sb, full_path,
                                                        &data->symlink_targ=
et,
-                                                       reparse_point);
+                                                       iov);
                }
                break;
        }
+       free_rsp_buf(rsp_buftype, rsp_iov.iov_base);
        return rc;
 }

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 094ef4fe2219..9bf8735cdd1e 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -972,13 +972,16 @@ cifs_unix_dfs_readlink(const unsigned int xid,
struct cifs_tcon *tcon,
 #endif
 }

-static int
-cifs_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
-                  struct cifs_sb_info *cifs_sb, const char *full_path,
-                  char **target_path, bool is_reparse_point)
+static int cifs_query_symlink(const unsigned int xid,
+                             struct cifs_tcon *tcon,
+                             struct cifs_sb_info *cifs_sb,
+                             const char *full_path,
+                             char **target_path,
+                             struct kvec *rsp_iov)
 {
        int rc;
        int oplock =3D 0;
+       bool is_reparse_point =3D !!rsp_iov;
        struct cifs_fid fid;
        struct cifs_open_parms oparms;

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 0f62bc373ad0..5eb2720f4aa7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2948,153 +2948,30 @@ parse_reparse_point(struct reparse_data_buffer *bu=
f,
        }
 }

-static int
-smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
-                  struct cifs_sb_info *cifs_sb, const char *full_path,
-                  char **target_path, bool is_reparse_point)
+static int smb2_query_symlink(const unsigned int xid,
+                             struct cifs_tcon *tcon,
+                             struct cifs_sb_info *cifs_sb,
+                             const char *full_path,
+                             char **target_path,
+                             struct kvec *rsp_iov)
 {
-       int rc;
-       __le16 *utf16_path =3D NULL;
-       __u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
-       struct cifs_open_parms oparms;
-       struct cifs_fid fid;
-       struct kvec err_iov =3D {NULL, 0};
-       struct TCP_Server_Info *server =3D cifs_pick_channel(tcon->ses);
-       int flags =3D CIFS_CP_CREATE_CLOSE_OP;
-       struct smb_rqst rqst[3];
-       int resp_buftype[3];
-       struct kvec rsp_iov[3];
-       struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
-       struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
-       struct kvec close_iov[1];
-       struct smb2_create_rsp *create_rsp;
-       struct smb2_ioctl_rsp *ioctl_rsp;
-       struct reparse_data_buffer *reparse_buf;
-       int create_options =3D is_reparse_point ? OPEN_REPARSE_POINT : 0;
-       u32 plen;
+       struct reparse_data_buffer *buf;
+       struct smb2_ioctl_rsp *io =3D rsp_iov->iov_base;
+       u32 plen =3D le32_to_cpu(io->OutputCount);

        cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);

-       *target_path =3D NULL;
-
-       if (smb3_encryption_required(tcon))
-               flags |=3D CIFS_TRANSFORM_REQ;
-
-       memset(rqst, 0, sizeof(rqst));
-       resp_buftype[0] =3D resp_buftype[1] =3D resp_buftype[2] =3D CIFS_NO=
_BUFFER;
-       memset(rsp_iov, 0, sizeof(rsp_iov));
-
-       utf16_path =3D cifs_convert_path_to_utf16(full_path, cifs_sb);
-       if (!utf16_path)
-               return -ENOMEM;
-
-       /* Open */
-       memset(&open_iov, 0, sizeof(open_iov));
-       rqst[0].rq_iov =3D open_iov;
-       rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
-
-       oparms =3D (struct cifs_open_parms) {
-               .tcon =3D tcon,
-               .path =3D full_path,
-               .desired_access =3D FILE_READ_ATTRIBUTES,
-               .disposition =3D FILE_OPEN,
-               .create_options =3D cifs_create_options(cifs_sb, create_opt=
ions),
-               .fid =3D &fid,
-       };
-
-       rc =3D SMB2_open_init(tcon, server,
-                           &rqst[0], &oplock, &oparms, utf16_path);
-       if (rc)
-               goto querty_exit;
-       smb2_set_next_command(tcon, &rqst[0]);
-
-
-       /* IOCTL */
-       memset(&io_iov, 0, sizeof(io_iov));
-       rqst[1].rq_iov =3D io_iov;
-       rqst[1].rq_nvec =3D SMB2_IOCTL_IOV_SIZE;
-
-       rc =3D SMB2_ioctl_init(tcon, server,
-                            &rqst[1], fid.persistent_fid,
-                            fid.volatile_fid, FSCTL_GET_REPARSE_POINT, NUL=
L, 0,
-                            CIFSMaxBufSize -
-                            MAX_SMB2_CREATE_RESPONSE_SIZE -
-                            MAX_SMB2_CLOSE_RESPONSE_SIZE);
-       if (rc)
-               goto querty_exit;
-
-       smb2_set_next_command(tcon, &rqst[1]);
-       smb2_set_related(&rqst[1]);
-
-
-       /* Close */
-       memset(&close_iov, 0, sizeof(close_iov));
-       rqst[2].rq_iov =3D close_iov;
-       rqst[2].rq_nvec =3D 1;
-
-       rc =3D SMB2_close_init(tcon, server,
-                            &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
-       if (rc)
-               goto querty_exit;
-
-       smb2_set_related(&rqst[2]);
-
-       rc =3D compound_send_recv(xid, tcon->ses, server,
-                               flags, 3, rqst,
-                               resp_buftype, rsp_iov);
-
-       create_rsp =3D rsp_iov[0].iov_base;
-       if (create_rsp && create_rsp->hdr.Status)
-               err_iov =3D rsp_iov[0];
-       ioctl_rsp =3D rsp_iov[1].iov_base;
-
-       /*
-        * Open was successful and we got an ioctl response.
-        */
-       if ((rc =3D=3D 0) && (is_reparse_point)) {
-               /* See MS-FSCC 2.3.23 */
-
-               reparse_buf =3D (struct reparse_data_buffer *)
-                       ((char *)ioctl_rsp +
-                        le32_to_cpu(ioctl_rsp->OutputOffset));
-               plen =3D le32_to_cpu(ioctl_rsp->OutputCount);
-
-               if (plen + le32_to_cpu(ioctl_rsp->OutputOffset) >
-                   rsp_iov[1].iov_len) {
-                       cifs_tcon_dbg(VFS, "srv returned invalid ioctl
len: %d\n",
-                                plen);
-                       rc =3D -EIO;
-                       goto querty_exit;
-               }
-
-               rc =3D parse_reparse_point(reparse_buf, plen, target_path,
-                                        cifs_sb);
-               goto querty_exit;
-       }
-
-       if (!rc || !err_iov.iov_base) {
-               rc =3D -ENOENT;
-               goto querty_exit;
-       }
-
-       rc =3D smb2_parse_symlink_response(cifs_sb, &err_iov, target_path);
-
- querty_exit:
-       cifs_dbg(FYI, "query symlink rc %d\n", rc);
-       kfree(utf16_path);
-       SMB2_open_free(&rqst[0]);
-       SMB2_ioctl_free(&rqst[1]);
-       SMB2_close_free(&rqst[2]);
-       free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
-       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
-       free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
-       return rc;
+       buf =3D (struct reparse_data_buffer *)((u8 *)io +
+                                            le32_to_cpu(io->OutputOffset))=
;
+       return parse_reparse_point(buf, plen, target_path, cifs_sb);
 }

-int
-smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
-                  struct cifs_sb_info *cifs_sb, const char *full_path,
-                  __u32 *tag)
+static int smb2_query_reparse_point(const unsigned int xid,
+                                   struct cifs_tcon *tcon,
+                                   struct cifs_sb_info *cifs_sb,
+                                   const char *full_path,
+                                   u32 *tag, struct kvec *rsp,
+                                   int *rsp_buftype)
 {
        int rc;
        __le16 *utf16_path =3D NULL;
@@ -3205,6 +3082,9 @@ smb2_query_reparse_tag(const unsigned int xid,
struct cifs_tcon *tcon,
                        goto query_rp_exit;
                }
                *tag =3D le32_to_cpu(reparse_buf->ReparseTag);
+               *rsp =3D rsp_iov[1];
+               *rsp_buftype =3D resp_buftype[1];
+               resp_buftype[1] =3D CIFS_NO_BUFFER;
        }

  query_rp_exit:
@@ -5503,7 +5383,7 @@ struct smb_version_operations smb30_operations =3D {
        .echo =3D SMB2_echo,
        .query_path_info =3D smb2_query_path_info,
        /* WSL tags introduced long after smb2.1, enable for SMB3, 3.11 onl=
y */
-       .query_reparse_tag =3D smb2_query_reparse_tag,
+       .query_reparse_point =3D smb2_query_reparse_point,
        .get_srv_inum =3D smb2_get_srv_inum,
        .query_file_info =3D smb2_query_file_info,
        .set_path_size =3D smb2_set_path_size,
@@ -5616,7 +5496,7 @@ struct smb_version_operations smb311_operations =3D {
        .can_echo =3D smb2_can_echo,
        .echo =3D SMB2_echo,
        .query_path_info =3D smb2_query_path_info,
-       .query_reparse_tag =3D smb2_query_reparse_tag,
+       .query_reparse_point =3D smb2_query_reparse_point,
        .get_srv_inum =3D smb2_get_srv_inum,
        .query_file_info =3D smb2_query_file_info,
        .set_path_size =3D smb2_set_path_size,
--
2.41.0



--=20
Thanks,

Steve
