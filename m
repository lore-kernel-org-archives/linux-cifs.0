Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A79D0C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 21 May 2022 17:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244601AbiEUR0r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 21 May 2022 13:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344247AbiEUR0q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 21 May 2022 13:26:46 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E483CA49
        for <linux-cifs@vger.kernel.org>; Sat, 21 May 2022 10:26:44 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id l13so12442000lfp.11
        for <linux-cifs@vger.kernel.org>; Sat, 21 May 2022 10:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X76Lc6b09YZEjDdQo+v01VNE6ktZKMsDqBEpH0wPDDs=;
        b=bBb8jY8daL+/fhw1aZLW3JG1+XOP+mULZaabu+VJtUh3ggPxIRHKbM/Jd8yI6Ty30z
         +OodcjNUsmvtBpkwehC2yG1FhK+Y9BBV3rnaKj69Et07Ikf5j8QRFlsNmxEgjXibDt56
         pIQV5pPzNN6+7+sIlzL0J5np7kFnGpH8ab3qIq41bPyFlg+Cui4CBLVROGAXjU+ITSax
         vW2VqTNeEzCqS0WHnu5JjeacAoOfSauTU5AEryDKVLWFrGGWoz9F8HgII61Uk71tlVYJ
         s3GtYXDrPCglAIEyy219iYp1OLzk64Bi8trzKy9LIy/gsNBte7SgsvDdMNwNzaG2ijGH
         m9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X76Lc6b09YZEjDdQo+v01VNE6ktZKMsDqBEpH0wPDDs=;
        b=D+gBg2wwddwD8xFXjqGgvbOrhfvhZQC07cKjL3DfG4Ks3yRXS69Z3RbNHsmf2NuhS+
         c9LkWlABmUuVQowaO3dfgBkzcOXFGSTYWYDiXn4GxVAlEbzSNn0th1MO4IjRExdMKkc1
         jzUU86i3WoU5hReG4kPNFLMyeig0bGMk0UycsihhjF2hBKENp42QjUC1O+hwPvM2Rwqr
         zY5Obtq7VWROXPQUV1EsbYfOvQGiPnxOJPZZ/Y6HvfFb5hlOpwPSF5WAV0gujjAF8cms
         aBNbvsj3niEhnlvUkOJAY4x2G1gqkbUYzim6eEQSfKuvF88mW+brR9PN6uD/TZlUhhHc
         OCrQ==
X-Gm-Message-State: AOAM5321efvxHRJRpt0caIyiM066o4p31mUI6XoPm4qwK9ftvlQEJVme
        tVczaHFAN1fr8D6ZpU4zoRyZCIoH3OnDbAXv6gFhRgTS
X-Google-Smtp-Source: ABdhPJzwNgL6rWXstn00ZGiFZlesK6Scon5TkI0ED8UeAp5MkwWOXxhcyF0MsL7Nte11i0L6ioLqmtloA9RtqwcmHf4=
X-Received: by 2002:ac2:561b:0:b0:472:586b:3209 with SMTP id
 v27-20020ac2561b000000b00472586b3209mr11061199lfd.234.1653154002283; Sat, 21
 May 2022 10:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220509234207.2469586-1-lsahlber@redhat.com> <20220509234207.2469586-4-lsahlber@redhat.com>
In-Reply-To: <20220509234207.2469586-4-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 21 May 2022 12:26:30 -0500
Message-ID: <CAH2r5mvRLqEz_HErEruqtPxF5d15yJp84USdQoNMFN6Sw_jZ1w@mail.gmail.com>
Subject: Re: [PATCH 3/4] cifs: set the CREATE_NOT_FILE when opening the
 directory in use_cached_dir()
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged the first 3 of the series (still looking at patch
4) pending testing

On Mon, May 9, 2022 at 6:42 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> This enforces that we can only do this for directories and not normal files
> or else the server will return an error.
> This means that we will have conditionally check IF the path refers
> to a directory or not in all the call-sites where we are unsure.
> Right now this check is for "" i.e. root.
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2inode.c | 5 ++++-
>  fs/cifs/smb2ops.c   | 5 +++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index fe5bfa245fa7..0c3e4d2c6207 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -514,8 +514,11 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>         if (smb2_data == NULL)
>                 return -ENOMEM;
>
> +       if (strcmp(full_path, ""))
> +               rc = -ENOENT;
> +       else
> +               rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
>         /* If it is a root and its handle is cached then use it */
> -       rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
>         if (!rc) {
>                 if (tcon->crfid.file_all_info_is_valid) {
>                         move_smb2_info_to_cifs(data,
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 2c93ee27d54d..cbe56ed35694 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -825,7 +825,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>         rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
>
>         oparms.tcon = tcon;
> -       oparms.create_options = cifs_create_options(cifs_sb, 0);
> +       oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
>         oparms.desired_access = FILE_READ_ATTRIBUTES;
>         oparms.disposition = FILE_OPEN;
>         oparms.fid = pfid;
> @@ -2696,7 +2696,8 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
>         resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
>         memset(rsp_iov, 0, sizeof(rsp_iov));
>
> -       rc = open_cached_dir(xid, tcon, path, cifs_sb, &cfid);
> +       if (!strcmp(path, ""))
> +               rc = open_cached_dir(xid, tcon, path, cifs_sb, &cfid);
>
>         memset(&open_iov, 0, sizeof(open_iov));
>         rqst[0].rq_iov = open_iov;
> --
> 2.30.2
>


-- 
Thanks,

Steve
