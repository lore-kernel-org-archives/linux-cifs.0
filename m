Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8FDEB64DD
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 20:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbjG1UcX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 16:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjG1UcW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 16:32:22 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73699423B
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 13:32:21 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b974031aeaso38535061fa.0
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 13:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690576340; x=1691181140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCVdPnhcuWqFosRZHjUQsJvunukzspOYYoCy7nVONiM=;
        b=b8W5e/+DfpzyEXlratkWOD6jppgggyssNU2ODmWgz19Q6wImfIYm8jCkL77eMD5SUN
         DYjhK2pnIdndnUlLrNU7ya0kjwwaWh/B7EI8nFHmH+3bZQjxQCHDJUqoj0bMNhuHLCkI
         Krr1PZ/wXDvt+SqV1CZhnpr0UVjSlku6aEqJjR/JIVzzJVi4z9uhHoSdCGgAk3s2JiL3
         jWRcDnrp7Sj9wzBBD10GaFnTdfC/abDsNIO7AjG19r59voaPpCOMaGa3PyqX6ths/Xp5
         rq6H7gadwp4QJQjixRugwH1REHqUjCgT7Han30/vYtYdLQl/vdqEDg41ZPIWWbyO67LB
         zs/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690576340; x=1691181140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JCVdPnhcuWqFosRZHjUQsJvunukzspOYYoCy7nVONiM=;
        b=R9xbo+22nwv2fr5TjBKzTl+M+OBVHr3XKm2pLqmdW2Ksm4oV6g7BSntccnZrVDHa+p
         Xkg0FaA32h4viutF9w2vzivrddbusQAGMRP69SKfYhqBbNBXmFo9+HoJtjCt4Ah5Su8y
         4ADGrIB7e5INOgQkryHFUxQSX24BLo5itBzFVP0Rrn5Kz0nN+h+UOcmwlE2nPRWQEzzj
         8nrl9W5oFNV82m5KL+W1LsSMnBICvDWT6nKh6zqHqdJ5OWvdo/eN1gEp4eH3BHlfhNmn
         1aj7YFuWIFrwbrTkBF5t2R+J6gC2yHfjt+QRbWc9cJisoPZo8YWyU5KE4FsM240s5/mI
         eCzg==
X-Gm-Message-State: ABy/qLarY9aiZF0mEUh9IlDm+bo2UkDdjKfTBinvsxauzJ8aXQzzJ7qr
        Xh2fmS1OG70ssCnwv/146bf/28/y5YUo8fs7Il3/OLls
X-Google-Smtp-Source: APBJJlHCrl/RdaWQWjExbHrT6d2iRf40+4BOhW49YVPDzRD64o7yRzJh/ncsRMJ4SzSq5b1Env6pZF/hZHWueSWafEc=
X-Received: by 2002:a2e:3211:0:b0:2b6:df5d:8e05 with SMTP id
 y17-20020a2e3211000000b002b6df5d8e05mr2722345ljy.33.1690576339343; Fri, 28
 Jul 2023 13:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230728195010.19122-1-pc@manguebit.com> <20230728195010.19122-7-pc@manguebit.com>
 <20230728200405.ghihnnsbnhrutypl@suse.de>
In-Reply-To: <20230728200405.ghihnnsbnhrutypl@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 28 Jul 2023 15:32:07 -0500
Message-ID: <CAH2r5mugftddTcd4xhbsa-DLh0REPMfZh-80zgn_c9Kk7PdFNA@mail.gmail.com>
Subject: Re: [PATCH 7/8] smb: client: reduce stack usage in smb2_query_symlink()
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

probably best to limit additional cleanup (and thus patch size) of
these so they don't get confusing and harder to backport.

We also have lots of testcases (xfstest features and failures) to work
through one by one that are high priority.

The obvious question is - are any of these high enough priority to go
into e.g. rc4 or rc5 - or wait till the merge window?

On Fri, Jul 28, 2023 at 3:04=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> On 07/28, Paulo Alcantara wrote:
> >Clang warns about exceeded stack frame size
> >
> >  fs/smb/client/smb2ops.c:2974:1: warning: stack frame size (1368)
> >  exceeds limit (1024) in 'smb2_query_symlink' [-Wframe-larger-than]
> >
> >Fix this by allocating a qs_vars structure that will hold most of the
> >large structures.
> >
> >Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> >---
> > fs/smb/client/smb2ops.c | 43 ++++++++++++++++++++++++++---------------
> > 1 file changed, 27 insertions(+), 16 deletions(-)
> >
> >diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> >index d6a15d5ec4d2..9136c77cd407 100644
> >--- a/fs/smb/client/smb2ops.c
> >+++ b/fs/smb/client/smb2ops.c
> >@@ -2970,6 +2970,14 @@ parse_reparse_point(struct reparse_data_buffer *b=
uf,
> >       }
> > }
> >
> >+struct qs_vars {
> >+      struct smb_rqst rqst[3];
> >+      struct kvec rsp_iov[3];
> >+      struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> >+      struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
> >+      struct kvec close_iov;
> >+};
>
> I think structs qs_vars, qr_vars, and qi_vars should be a single "struct
> query_vars" instead of having 2 repeated + 1 very similar differently
> named structs around.
>
> Then for smb2_query_info_compound() you use only io_iov[0].
>
> And later on, maybe even embed such struct in "struct cop_vars"
> (smb2inode.c) to avoid even more duplicate code.
>
> Other than that,
>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
>
> for this and all the other patches in this series.
>
>
> Cheers,
>
> Enzo
>
> >+
> > static int
> > smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
> >                  struct cifs_sb_info *cifs_sb, const char *full_path,
> >@@ -2979,16 +2987,14 @@ smb2_query_symlink(const unsigned int xid, struc=
t cifs_tcon *tcon,
> >       __le16 *utf16_path =3D NULL;
> >       __u8 oplock =3D SMB2_OPLOCK_LEVEL_NONE;
> >       struct cifs_open_parms oparms;
> >+      struct smb_rqst *rqst;
> >       struct cifs_fid fid;
> >+      struct qs_vars *vars;
> >       struct kvec err_iov =3D {NULL, 0};
> >+      struct kvec *rsp_iov;
> >       struct TCP_Server_Info *server =3D cifs_pick_channel(tcon->ses);
> >       int flags =3D CIFS_CP_CREATE_CLOSE_OP;
> >-      struct smb_rqst rqst[3];
> >       int resp_buftype[3];
> >-      struct kvec rsp_iov[3];
> >-      struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> >-      struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
> >-      struct kvec close_iov[1];
> >       struct smb2_create_rsp *create_rsp;
> >       struct smb2_ioctl_rsp *ioctl_rsp;
> >       struct reparse_data_buffer *reparse_buf;
> >@@ -3002,17 +3008,22 @@ smb2_query_symlink(const unsigned int xid, struc=
t cifs_tcon *tcon,
> >       if (smb3_encryption_required(tcon))
> >               flags |=3D CIFS_TRANSFORM_REQ;
> >
> >-      memset(rqst, 0, sizeof(rqst));
> >-      resp_buftype[0] =3D resp_buftype[1] =3D resp_buftype[2] =3D CIFS_=
NO_BUFFER;
> >-      memset(rsp_iov, 0, sizeof(rsp_iov));
> >-
> >       utf16_path =3D cifs_convert_path_to_utf16(full_path, cifs_sb);
> >       if (!utf16_path)
> >               return -ENOMEM;
> >
> >+      resp_buftype[0] =3D resp_buftype[1] =3D resp_buftype[2] =3D CIFS_=
NO_BUFFER;
> >+
> >+      vars =3D kzalloc(sizeof(*vars), GFP_KERNEL);
> >+      if (!vars) {
> >+              rc =3D -ENOMEM;
> >+              goto out_free_path;
> >+      }
> >+      rqst =3D vars->rqst;
> >+      rsp_iov =3D vars->rsp_iov;
> >+
> >       /* Open */
> >-      memset(&open_iov, 0, sizeof(open_iov));
> >-      rqst[0].rq_iov =3D open_iov;
> >+      rqst[0].rq_iov =3D vars->open_iov;
> >       rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
> >
> >       oparms =3D (struct cifs_open_parms) {
> >@@ -3032,8 +3043,7 @@ smb2_query_symlink(const unsigned int xid, struct =
cifs_tcon *tcon,
> >
> >
> >       /* IOCTL */
> >-      memset(&io_iov, 0, sizeof(io_iov));
> >-      rqst[1].rq_iov =3D io_iov;
> >+      rqst[1].rq_iov =3D vars->io_iov;
> >       rqst[1].rq_nvec =3D SMB2_IOCTL_IOV_SIZE;
> >
> >       rc =3D SMB2_ioctl_init(tcon, server,
> >@@ -3050,8 +3060,7 @@ smb2_query_symlink(const unsigned int xid, struct =
cifs_tcon *tcon,
> >
> >
> >       /* Close */
> >-      memset(&close_iov, 0, sizeof(close_iov));
> >-      rqst[2].rq_iov =3D close_iov;
> >+      rqst[2].rq_iov =3D &vars->close_iov;
> >       rqst[2].rq_nvec =3D 1;
> >
> >       rc =3D SMB2_close_init(tcon, server,
> >@@ -3103,13 +3112,15 @@ smb2_query_symlink(const unsigned int xid, struc=
t cifs_tcon *tcon,
> >
> >  querty_exit:
> >       cifs_dbg(FYI, "query symlink rc %d\n", rc);
> >-      kfree(utf16_path);
> >       SMB2_open_free(&rqst[0]);
> >       SMB2_ioctl_free(&rqst[1]);
> >       SMB2_close_free(&rqst[2]);
> >       free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> >       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> >       free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
> >+      kfree(vars);
> >+out_free_path:
> >+      kfree(utf16_path);
> >       return rc;
> > }
> >
> >--
> >2.41.0
> >



--=20
Thanks,

Steve
