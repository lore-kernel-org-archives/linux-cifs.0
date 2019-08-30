Return-Path: <SRS0=0p8I=W2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B502C3A59F
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Aug 2019 01:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06F8121726
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Aug 2019 01:19:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J7kEhasa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfH3BT1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Aug 2019 21:19:27 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43451 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfH3BT1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Aug 2019 21:19:27 -0400
Received: by mail-io1-f68.google.com with SMTP id u185so6988878iod.10
        for <linux-cifs@vger.kernel.org>; Thu, 29 Aug 2019 18:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h0rXS/N41zhly+lQPtP+tNM0GegnEDnymGNZiDfm/UI=;
        b=J7kEhasacYsn8pImeSg2pQZaa8DXKwha28ThQllhnflzTe8MUO3PDiIuvq1c1yG69K
         amctfvUnRlU3Q2PRICX47GAiynXdmg6VvAQymuy4OavCxnJ7FrOAklazTG4iu1oEnQ7u
         ZaYg6ADIaCFjyai2X//BuTuLnPP643AZK0ZWrJz7bfjL5ojo56LeP3sAVxbFTdvA0kmp
         JWZGc2DltQ9NQFF3x7v4NeHQxQkpmgOXa3pJ2FQ3JSPyIkgYVxf5RPKUqo+52vRzpiBB
         MYoSywJXwZAsAyfXzqS1s/expDZsiFSDd2Lgs4dPtvqvw6juMk/F+6k38jcvHTC4dpWb
         usiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h0rXS/N41zhly+lQPtP+tNM0GegnEDnymGNZiDfm/UI=;
        b=ntFMb5xs1iZOSsCFlFgMEKzJ26PMAHExPa8uppsQ92YhFNm32PnKr+NI2hba+Yu/u0
         Dn6gJe2viTJFo/4UepVIwLCFVy/zpbZgvbw01dA2q69sVShW8lx2L6zNtvSizQ78mqJ8
         6toMxsrQgbvgaCGlgvCzknZGtd8GcmQ0MwXZ8XFp15A4LVVebKi+GDG8svqoJxeQsZMw
         9AsVT40inMHYul9ajzgyN+35yQmGv080X/hRqtFlv5rQdogVlltlCeA7q4AtGKtLC2Qq
         X0H1nNMHyaBZrMGx2hafSmPADVihErQGJfju41xDWEQU+cxQXxB6ENtBGFXNCI/Kk6eD
         OJbQ==
X-Gm-Message-State: APjAAAV0eT3mAhn0v9HLVmYXzU2hekzBWZLwLYiuEkEuaJv06gC3HVO6
        XpRl8V3dmehV9cOdMf9ujVVpb62eYK9tEGvR3DU=
X-Google-Smtp-Source: APXvYqzTqVRVLGiOn1G+iZYmUkWdIvzskGPGUDGrM90n2deWtD3I8dcolJv5ijUC1vevIkrLq0cX9Ejjy6O18HIWr5k=
X-Received: by 2002:a6b:6a07:: with SMTP id x7mr1311660iog.168.1567127966363;
 Thu, 29 Aug 2019 18:19:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190829235356.8591-1-lsahlber@redhat.com>
In-Reply-To: <20190829235356.8591-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Aug 2019 20:19:15 -0500
Message-ID: <CAH2r5mtTwdP3RCLvrQqsUTsjk73EAw4ChJqe=DfcSbD4tRUA4Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: use existing handle for compound_op(OP_SET_INFO)
 when possible
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged into cifs-2.6.git for-next pending more testing and review

On Thu, Aug 29, 2019 at 6:54 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> If we already have a writable handle for a path we want to set the
> attributes for then use that instead of a create/set-info/close compound.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2inode.c | 40 ++++++++++++++++++++++++++++++----------
>  1 file changed, 30 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 939fc7b2234c..6aeb2950382c 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -192,14 +192,27 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>                 size[0] = sizeof(FILE_BASIC_INFO);
>                 data[0] = ptr;
>
> -               rc = SMB2_set_info_init(tcon, &rqst[num_rqst], COMPOUND_FID,
> -                                       COMPOUND_FID, current->tgid,
> -                                       FILE_BASIC_INFORMATION,
> -                                       SMB2_O_INFO_FILE, 0, data, size);
> +               if (cfile)
> +                       rc = SMB2_set_info_init(tcon, &rqst[num_rqst],
> +                               cfile->fid.persistent_fid,
> +                               cfile->fid.volatile_fid, current->tgid,
> +                               FILE_BASIC_INFORMATION,
> +                               SMB2_O_INFO_FILE, 0, data, size);
> +               else {
> +                       rc = SMB2_set_info_init(tcon, &rqst[num_rqst],
> +                               COMPOUND_FID,
> +                               COMPOUND_FID, current->tgid,
> +                               FILE_BASIC_INFORMATION,
> +                               SMB2_O_INFO_FILE, 0, data, size);
> +                       if (!rc) {
> +                               smb2_set_next_command(tcon, &rqst[num_rqst]);
> +                               smb2_set_related(&rqst[num_rqst]);
> +                       }
> +               }
> +
>                 if (rc)
>                         goto finished;
> -               smb2_set_next_command(tcon, &rqst[num_rqst]);
> -               smb2_set_related(&rqst[num_rqst++]);
> +               num_rqst++;
>                 trace_smb3_set_info_compound_enter(xid, ses->Suid, tcon->tid,
>                                                    full_path);
>                 break;
> @@ -231,8 +244,10 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>                                         COMPOUND_FID, COMPOUND_FID,
>                                         current->tgid, FILE_RENAME_INFORMATION,
>                                         SMB2_O_INFO_FILE, 0, data, size);
> -                       smb2_set_next_command(tcon, &rqst[num_rqst]);
> -                       smb2_set_related(&rqst[num_rqst]);
> +                       if (!rc) {
> +                               smb2_set_next_command(tcon, &rqst[num_rqst]);
> +                               smb2_set_related(&rqst[num_rqst]);
> +                       }
>                 }
>                 if (rc)
>                         goto finished;
> @@ -475,6 +490,7 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
>  {
>         FILE_BASIC_INFO data;
>         struct cifsInodeInfo *cifs_i;
> +       struct cifsFileInfo *cfile;
>         u32 dosattrs;
>         int tmprc;
>
> @@ -482,10 +498,11 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
>         cifs_i = CIFS_I(inode);
>         dosattrs = cifs_i->cifsAttrs | ATTR_READONLY;
>         data.Attributes = cpu_to_le32(dosattrs);
> +       cifs_get_writable_path(tcon, name, &cfile);
>         tmprc = smb2_compound_op(xid, tcon, cifs_sb, name,
>                                  FILE_WRITE_ATTRIBUTES, FILE_CREATE,
>                                  CREATE_NOT_FILE, &data, SMB2_OP_SET_INFO,
> -                                NULL);
> +                                cfile);
>         if (tmprc == 0)
>                 cifs_i->cifsAttrs = dosattrs;
>  }
> @@ -570,6 +587,7 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
>  {
>         struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
>         struct tcon_link *tlink;
> +       struct cifsFileInfo *cfile;
>         int rc;
>
>         if ((buf->CreationTime == 0) && (buf->LastAccessTime == 0) &&
> @@ -581,9 +599,11 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
>         if (IS_ERR(tlink))
>                 return PTR_ERR(tlink);
>
> +       cifs_get_writable_path(tlink_tcon(tlink), full_path, &cfile);
> +
>         rc = smb2_compound_op(xid, tlink_tcon(tlink), cifs_sb, full_path,
>                               FILE_WRITE_ATTRIBUTES, FILE_OPEN, 0, buf,
> -                             SMB2_OP_SET_INFO, NULL);
> +                             SMB2_OP_SET_INFO, cfile);
>         cifs_put_tlink(tlink);
>         return rc;
>  }
> --
> 2.13.6
>


-- 
Thanks,

Steve
