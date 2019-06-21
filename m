Return-Path: <SRS0=xi1p=UU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEC9C43613
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Jun 2019 00:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B488D2070B
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Jun 2019 00:31:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q6/A2vWx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbfFUAbs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Jun 2019 20:31:48 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42698 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfFUAbr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Jun 2019 20:31:47 -0400
Received: by mail-io1-f68.google.com with SMTP id u19so55108ior.9
        for <linux-cifs@vger.kernel.org>; Thu, 20 Jun 2019 17:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FAqPBVV4hzXZ1v2jC9Uw8Tw+cFBLeMt0XSk2eOWXlEA=;
        b=q6/A2vWxung5nSbGrGPLYuntDw04ECsXTc09Gm4XpH1r2RiMu4D8lzDDhhH4Aem38u
         O9fWvCuAPWVfz2+/0Xh6i0v+xOQ7vhiRHpcizXQA1OtGT6aua+7bK7mv5GbQYrTM+kmT
         Qp6JJ+BUE6VXW4FY6ZL4P+Smt+6lavsLZMA01mqbs638h/HZX/Agi25EQuUo0Qk4hR8t
         KgEjn0RR/YBchfcy2YkYqCfQg0iiXBqxizNFsGUtHWstJVX2S2IaHbxEvrBhLly0FLGv
         1GkGAw/b1+SkVEtepb4PlbFTkOZ7mgccOt3slIrUaFej+dJev+IVgveIER0hP+yBO2Hr
         +c3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FAqPBVV4hzXZ1v2jC9Uw8Tw+cFBLeMt0XSk2eOWXlEA=;
        b=VcCCr2sLhEo1oS0lJBwHI8iNjCAf6+hwt5IfLPBf8uXbMgEglvnVFpkUd9GBAYtBUr
         ZrlRzqW1mpcRMcTKAQDoApdZzJnqBdVayVz2dKgFMP4bPX/xJIe/+/FmGe5zBGcoEC+n
         aFyUOV+T/kV7qSZCAQhrnxrI2BAljZYBlwsJ+Pwr4rUHHQ8jFx08vmTJNGN1d4Nw2NeY
         TyNGuBc1ucA+8Wru+/djcdYGAylhbFTS/50PgsFTBdGK+TxCUgoc+QVWnYECz7irBtHV
         S7XHODx+v6LUv7GdoM12MozSjgrHbUcDiJUXlhgQW4XItgRyXA3DZbWb7reuQ69tfG+v
         okog==
X-Gm-Message-State: APjAAAV5yJyVEqS1+BTDJB+ogNvt1DmE1PrIero077nDX88WBRRW6snz
        vKRHs1GALdi/+Q8tpVt8Wea+vzBFjRFCpUCw2Bw=
X-Google-Smtp-Source: APXvYqy1MgVZ1O222RJKHKIkh0+MgtFEoEGoCnvF0NNCH/phQYwoc7pd03KDQ7ZrN6z72cNW3BmXH0FbAzXkKhUg8S0=
X-Received: by 2002:a6b:7017:: with SMTP id l23mr41748963ioc.159.1561077106731;
 Thu, 20 Jun 2019 17:31:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190621000252.22432-1-lsahlber@redhat.com> <CAH2r5mv4LEo9T70uBfjQb5M3uc0phsXOgXTFD6qWByGfha9MFg@mail.gmail.com>
In-Reply-To: <CAH2r5mv4LEo9T70uBfjQb5M3uc0phsXOgXTFD6qWByGfha9MFg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 21 Jun 2019 10:31:35 +1000
Message-ID: <CAN05THQgBNqN4j42v=Td-h49yw2U4S1fNTNBuW8Sk6QrbyKrQQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: add mount option to encode xattr names as hexadecimal
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 21, 2019 at 10:20 AM Steve French <smfrench@gmail.com> wrote:
>
> Do you remember which xfstests this fixes?

I will take a look. As far as I remember we do run all those affected
xfstests in the buildbot.
I just pointed the failing tests to one of the samba hosts instead of
the default win2016 test server.

>
> Also any ideas on whether we still need a fix for deleting an empty or
> nonexistent xattr?

I think these bugs are already fixed in the current tree. At least for SMB2+.

>
> On Thu, Jun 20, 2019 at 7:03 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > We store xattrs as Extended Attributes for SMB.
> > Some servers treat the EA names as case-insensitive as well as converting them to all upper-case.
> >
> > This addresses that issue by adding a new mount option to convert all EA names to/from
> > hexadecimal representation.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cifs_fs_sb.h |  1 +
> >  fs/cifs/cifsfs.c     |  3 +++
> >  fs/cifs/cifsglob.h   |  3 ++-
> >  fs/cifs/connect.c    |  7 +++++++
> >  fs/cifs/smb2ops.c    | 58 ++++++++++++++++++++++++++++++++++++++++------------
> >  5 files changed, 58 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> > index ed49222abecb..11fb5f4d2b0e 100644
> > --- a/fs/cifs/cifs_fs_sb.h
> > +++ b/fs/cifs/cifs_fs_sb.h
> > @@ -52,6 +52,7 @@
> >  #define CIFS_MOUNT_UID_FROM_ACL 0x2000000 /* try to get UID via special SID */
> >  #define CIFS_MOUNT_NO_HANDLE_CACHE 0x4000000 /* disable caching dir handles */
> >  #define CIFS_MOUNT_NO_DFS 0x8000000 /* disable DFS resolving */
> > +#define CIFS_MOUNT_ENCODED_XATTR  0x10000000 /* encode the xattr names */
> >
> >  struct cifs_sb_info {
> >         struct rb_root tlink_tree;
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index d06edebf3a73..c3c837ee3c4e 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -471,6 +471,9 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
> >         else
> >                 seq_puts(s, ",noforcegid");
> >
> > +       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_ENCODED_XATTR)
> > +               seq_puts(s, ",endodedxattr");
> > +
> >         cifs_show_address(s, tcon->ses->server);
> >
> >         if (!tcon->unix_ext)
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 4777b3c4a92c..b479207f7f74 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -585,6 +585,7 @@ struct smb_vol {
> >         bool resilient:1; /* noresilient not required since not fored for CA */
> >         bool domainauto:1;
> >         bool rdma:1;
> > +       bool encoded_xattr:1;
> >         unsigned int bsize;
> >         unsigned int rsize;
> >         unsigned int wsize;
> > @@ -617,7 +618,7 @@ struct smb_vol {
> >                          CIFS_MOUNT_FSCACHE | CIFS_MOUNT_MF_SYMLINKS | \
> >                          CIFS_MOUNT_MULTIUSER | CIFS_MOUNT_STRICT_IO | \
> >                          CIFS_MOUNT_CIFS_BACKUPUID | CIFS_MOUNT_CIFS_BACKUPGID | \
> > -                        CIFS_MOUNT_NO_DFS)
> > +                        CIFS_MOUNT_NO_DFS|CIFS_MOUNT_ENCODED_XATTR)
> >
> >  /**
> >   * Generic VFS superblock mount flags (s_flags) to consider when
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 51f272377ae1..f955b28a9b38 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -97,6 +97,7 @@ enum {
> >         Opt_persistent, Opt_nopersistent,
> >         Opt_resilient, Opt_noresilient,
> >         Opt_domainauto, Opt_rdma,
> > +       Opt_encodedxattr,
> >
> >         /* Mount options which take numeric value */
> >         Opt_backupuid, Opt_backupgid, Opt_uid,
> > @@ -194,6 +195,7 @@ static const match_table_t cifs_mount_option_tokens = {
> >         { Opt_noresilient, "noresilienthandles"},
> >         { Opt_domainauto, "domainauto"},
> >         { Opt_rdma, "rdma"},
> > +       { Opt_encodedxattr, "encodedxattr" },
> >
> >         { Opt_backupuid, "backupuid=%s" },
> >         { Opt_backupgid, "backupgid=%s" },
> > @@ -1911,6 +1913,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
> >                 case Opt_rdma:
> >                         vol->rdma = true;
> >                         break;
> > +               case Opt_encodedxattr:
> > +                       vol->encoded_xattr = 1;
> > +                       break;
> >
> >                 /* Numeric Values */
> >                 case Opt_backupuid:
> > @@ -3986,6 +3991,8 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
> >                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_UID;
> >         if (pvolume_info->override_gid)
> >                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_GID;
> > +       if (pvolume_info->encoded_xattr)
> > +               cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_ENCODED_XATTR;
> >         if (pvolume_info->dynperm)
> >                 cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DYNPERM;
> >         if (pvolume_info->fsc)
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 376577cc4159..e2684a6627bb 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -891,7 +891,8 @@ smb2_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
> >  static ssize_t
> >  move_smb2_ea_to_cifs(char *dst, size_t dst_size,
> >                      struct smb2_file_full_ea_info *src, size_t src_size,
> > -                    const unsigned char *ea_name)
> > +                    const unsigned char *ea_name,
> > +                    struct cifs_sb_info *cifs_sb)
> >  {
> >         int rc = 0;
> >         unsigned int ea_name_len = ea_name ? strlen(ea_name) : 0;
> > @@ -905,6 +906,18 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
> >                 value = &src->ea_data[src->ea_name_length + 1];
> >                 value_len = (size_t)le16_to_cpu(src->ea_value_length);
> >
> > +               if (cifs_sb->mnt_cifs_flags | CIFS_MOUNT_ENCODED_XATTR) {
> > +                       if (name_len & 0x01) {
> > +                               rc = -EINVAL;
> > +                               goto out;
> > +                       }
> > +                       name_len = name_len / 2;
> > +                       if (hex2bin(name, name, name_len)) {
> > +                               rc = -EINVAL;
> > +                               goto out;
> > +                       }
> > +               }
> > +
> >                 if (name_len == 0)
> >                         break;
> >
> > @@ -1018,7 +1031,8 @@ smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
> >         info = (struct smb2_file_full_ea_info *)(
> >                         le16_to_cpu(rsp->OutputBufferOffset) + (char *)rsp);
> >         rc = move_smb2_ea_to_cifs(ea_data, buf_size, info,
> > -                       le32_to_cpu(rsp->OutputBufferLength), ea_name);
> > +                                 le32_to_cpu(rsp->OutputBufferLength),
> > +                                 ea_name, cifs_sb);
> >
> >   qeas_exit:
> >         kfree(utf16_path);
> > @@ -1029,13 +1043,14 @@ smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
> >
> >  static int
> >  smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
> > -           const char *path, const char *ea_name, const void *ea_value,
> > +           const char *path, const char *name, const void *ea_value,
> >             const __u16 ea_value_len, const struct nls_table *nls_codepage,
> >             struct cifs_sb_info *cifs_sb)
> >  {
> >         struct cifs_ses *ses = tcon->ses;
> >         __le16 *utf16_path = NULL;
> > -       int ea_name_len = strlen(ea_name);
> > +       char *ea_name = (char *)name;
> > +       int ea_name_len = strlen(name);
> >         int flags = 0;
> >         int len;
> >         struct smb_rqst rqst[3];
> > @@ -1050,21 +1065,36 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
> >         void *data[1];
> >         struct smb2_file_full_ea_info *ea = NULL;
> >         struct kvec close_iov[1];
> > -       int rc;
> > +       int i, rc;
> > +
> > +       memset(rqst, 0, sizeof(rqst));
> > +       resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
> > +       memset(rsp_iov, 0, sizeof(rsp_iov));
> >
> >         if (smb3_encryption_required(tcon))
> >                 flags |= CIFS_TRANSFORM_REQ;
> >
> > -       if (ea_name_len > 255)
> > -               return -EINVAL;
> > +       /* Do we need to encode the name in hex ? */
> > +       if (cifs_sb->mnt_cifs_flags | CIFS_MOUNT_ENCODED_XATTR) {
> > +               ea_name = kzalloc(ea_name_len * 2 + 1, GFP_KERNEL);
> > +               if (ea_name == NULL) {
> > +                       rc = -ENOMEM;
> > +                       goto sea_exit;
> > +               }
> > +               bin2hex(ea_name, name, ea_name_len);
> > +               ea_name_len = 2 * ea_name_len;
> > +       }
> >
> > -       utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> > -       if (!utf16_path)
> > -               return -ENOMEM;
> > +       if (ea_name_len > 255) {
> > +               rc = -EINVAL;
> > +               goto sea_exit;
> > +       }
> >
> > -       memset(rqst, 0, sizeof(rqst));
> > -       resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
> > -       memset(rsp_iov, 0, sizeof(rsp_iov));
> > +       utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> > +       if (!utf16_path) {
> > +               rc = -ENOMEM;
> > +               goto sea_exit;
> > +       }
> >
> >         if (ses->server->ops->query_all_EAs) {
> >                 if (!ea_value) {
> > @@ -1137,6 +1167,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
> >                                 resp_buftype, rsp_iov);
> >
> >   sea_exit:
> > +       if (cifs_sb->mnt_cifs_flags | CIFS_MOUNT_ENCODED_XATTR)
> > +               kfree(ea_name);
> >         kfree(ea);
> >         kfree(utf16_path);
> >         SMB2_open_free(&rqst[0]);
> > --
> > 2.13.6
> >
>
>
> --
> Thanks,
>
> Steve
