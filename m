Return-Path: <SRS0=8y/q=VD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7352C5B578
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 22:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 808B620830
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Jul 2019 22:51:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sF0PCueW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfGFWvG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Jul 2019 18:51:06 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41794 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfGFWvF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Jul 2019 18:51:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id q4so5799669pgj.8
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jul 2019 15:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zdXiVUrvIF9gd7qyQO4cBD2VmZDOPmO0A3Hn+Xli5xw=;
        b=sF0PCueW6OkP6ThPaMrvftlC2dqcGwpqHdCPBfEe87rMFzDlY/p3Y2VR+tyIbfUZM9
         zFMK0Wz2LtpdU9RKKPcixI3KpHWxT08OpTTBr2JXtaydx+ugRIcHfvG80UyxGDVU8+Xo
         jcB3ItspJRmx+ZXQthyfcfmh+W6GLeCxi6RBNUzz2MtNr06T35VWjjfZkytUVKHWkAoD
         7AZkynUpA389CzPVvcMTPeyHd5D0FHv8fputQntP3Y2rQ5DKz2Rf0zz9WfvgOwzZB+rw
         TAFLYNrEprf1nahFHlO4ePWTwqxSdwRqp9TwXhv1w6izBTprOIkBJTg2H9u01jrQP2BQ
         1tCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zdXiVUrvIF9gd7qyQO4cBD2VmZDOPmO0A3Hn+Xli5xw=;
        b=tqs+dzAa8U2KB2kyYz7PzjAivwu1dsQsKCv3IWLU9IYk3aoei3ST54JTR3tiawBQGB
         iFGC1ZxH4yHcM6pqTpx9K9hvf43oINyDL+nZV8IIRZy+qHc29ZxwHGDC2ieALPNamt7q
         ZyAaLJ856VRg+8ue9bq4U17KzqhC4aqE6ji8aMEiyPM2Lv2x5b72XY/i0MRManCErc8L
         Q8tNt4LJXb5gWBIT0VSu9eiP+lWEOKiNFW+7HCkLN8tcemWWHwRgaf7jTbLx6M/lnTZe
         7OJRbVEhmJadryL5xJttcNhd8Dtvb9pdzeQktSVkLDXx7C+E4d998r2+sVIV5p3qLkdV
         PFLA==
X-Gm-Message-State: APjAAAWpvc9Dw+ZaSM9o9/FNjJn98AsW87nAbCtpkKw2G6iKxMY4/8QV
        beNgv7mKSESbvAbgMcrkhNPTTAJ/2Lqa1M/cSUU=
X-Google-Smtp-Source: APXvYqzO0OuOkDFvA94dYTbYwdWakMJr5Cu1tjaxqUdj6WzlFv/iC4bJmqaQTSb28xdc+oPnp42WRubE1zjjG41czx0=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr13609304pjb.138.1562453464541;
 Sat, 06 Jul 2019 15:51:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190706214542.1505-1-lsahlber@redhat.com>
In-Reply-To: <20190706214542.1505-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 6 Jul 2019 17:50:55 -0500
Message-ID: <CAH2r5muES-UAzZe1nmzXJrj9WZ189PbV1gVFb2GXte00ZB+sYQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: refactor and clean up arguments in the reparse
 point parsing
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged to cifs-2.6.git for-next pending testing and
additional review/cleanup of the reparse point handling code

On Sat, Jul 6, 2019 at 4:45 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 66 ++++++++++++++++++++++++++-----------------------------
>  1 file changed, 31 insertions(+), 35 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c4047ad7b43f..4b0b14946343 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2383,11 +2383,6 @@ parse_reparse_posix(struct reparse_posix_data *symlink_buf,
>         /* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
>         len = le16_to_cpu(symlink_buf->ReparseDataLength);
>
> -       if (len + sizeof(struct reparse_data_buffer) > plen) {
> -               cifs_dbg(VFS, "srv returned malformed symlink buffer\n");
> -               return -EINVAL;
> -       }
> -
>         if (le64_to_cpu(symlink_buf->InodeType) != NFS_SPECFILE_LNK) {
>                 cifs_dbg(VFS, "%lld not a supported symlink type\n",
>                         le64_to_cpu(symlink_buf->InodeType));
> @@ -2437,22 +2432,38 @@ parse_reparse_symlink(struct reparse_symlink_data_buffer *symlink_buf,
>  }
>
>  static int
> -parse_reparse_point(struct reparse_symlink_data_buffer *buf,
> -                     u32 plen, char **target_path,
> -                     struct cifs_sb_info *cifs_sb)
> +parse_reparse_point(struct reparse_data_buffer *buf,
> +                   u32 plen, char **target_path,
> +                   struct cifs_sb_info *cifs_sb)
>  {
> -       /* See MS-FSCC 2.1.2 */
> -       if (le32_to_cpu(buf->ReparseTag) == IO_REPARSE_TAG_NFS)
> -               return parse_reparse_posix((struct reparse_posix_data *)buf,
> -                       plen, target_path, cifs_sb);
> -       else if (le32_to_cpu(buf->ReparseTag) == IO_REPARSE_TAG_SYMLINK)
> -               return parse_reparse_symlink(buf, plen, target_path,
> -                                       cifs_sb);
> +       if (plen < sizeof(struct reparse_data_buffer)) {
> +               cifs_dbg(VFS, "reparse buffer is too small. Must be "
> +                        "at least 8 bytes but was %d\n", plen);
> +               return -EIO;
> +       }
>
> -       cifs_dbg(VFS, "srv returned invalid symlink buffer tag:%d\n",
> -               le32_to_cpu(buf->ReparseTag));
> +       if (plen < le16_to_cpu(buf->ReparseDataLength) +
> +           sizeof(struct reparse_data_buffer)) {
> +               cifs_dbg(VFS, "srv returned invalid reparse buf "
> +                        "length: %d\n", plen);
> +               return -EIO;
> +       }
>
> -       return -EIO;
> +       /* See MS-FSCC 2.1.2 */
> +       switch (le32_to_cpu(buf->ReparseTag)) {
> +       case IO_REPARSE_TAG_NFS:
> +               return parse_reparse_posix(
> +                       (struct reparse_posix_data *)buf,
> +                       plen, target_path, cifs_sb);
> +       case IO_REPARSE_TAG_SYMLINK:
> +               return parse_reparse_symlink(
> +                       (struct reparse_symlink_data_buffer *)buf,
> +                       plen, target_path, cifs_sb);
> +       default:
> +               cifs_dbg(VFS, "srv returned unknown symlink buffer "
> +                        "tag:0x%08x\n", le32_to_cpu(buf->ReparseTag));
> +               return -EOPNOTSUPP;
> +       }
>  }
>
>  #define SMB2_SYMLINK_STRUCT_SIZE \
> @@ -2581,23 +2592,8 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>                         goto querty_exit;
>                 }
>
> -               if (plen < 8) {
> -                       cifs_dbg(VFS, "reparse buffer is too small. Must be "
> -                                "at least 8 bytes but was %d\n", plen);
> -                       rc = -EIO;
> -                       goto querty_exit;
> -               }
> -
> -               if (plen < le16_to_cpu(reparse_buf->ReparseDataLength) + 8) {
> -                       cifs_dbg(VFS, "srv returned invalid reparse buf "
> -                                "length: %d\n", plen);
> -                       rc = -EIO;
> -                       goto querty_exit;
> -               }
> -
> -               rc = parse_reparse_point(
> -                       (struct reparse_symlink_data_buffer *)reparse_buf,
> -                       plen, target_path, cifs_sb);
> +               rc = parse_reparse_point(reparse_buf, plen, target_path,
> +                                        cifs_sb);
>                 goto querty_exit;
>         }
>
> --
> 2.13.6
>


-- 
Thanks,

Steve
