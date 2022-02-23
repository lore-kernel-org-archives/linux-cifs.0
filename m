Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CB4C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Feb 2022 02:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiBWCrM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Feb 2022 21:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiBWCrF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Feb 2022 21:47:05 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A7445792
        for <linux-cifs@vger.kernel.org>; Tue, 22 Feb 2022 18:44:15 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id b11so28476381lfb.12
        for <linux-cifs@vger.kernel.org>; Tue, 22 Feb 2022 18:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aB5e2tjVmAADTaOQSzpkGPj0yJ8zFPpGuVapYuWYx/U=;
        b=o5NDsxUAHE48brHPcaz4/1JQNN2tEEzHUzTeE8wuY4d90jl0I+a9bQuhi+gt7/ET1J
         JyZ70iNgR7YD6Fvf+hrstyWNiHVa/kUzpOZKrGwDvU8uIzVGGB3g3z4vdCclI6STeHvg
         sxjysEPU8CuKC/yvB2WJwS0A7OhLFZJAgTPzDEdP4SDyKxI2vixe8gUjde9xhVs7GGo4
         MYUgbtTZFm46SWJDbJaERXttnlbD0pAsOXt7Nh2rl3PLwOo+MpgSY8qwI3KVeL3YZwk6
         YfPcGNUCdghX1qHmd6mdI5yd1oJDVsvSo6Q6KPXAUWVkIrTv2QIj4JPUGNe2JGdJPf8b
         OGVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aB5e2tjVmAADTaOQSzpkGPj0yJ8zFPpGuVapYuWYx/U=;
        b=t5z7ybaUvW5VDHjezKwuVR1Nc2ehEqjH+CusxFLUYejWMSTFN/4L19uaHSH+KZBxqb
         +Bs9rNcGP/cnidNSP0+pJ5rKRlS51tGKYVTs5QyK5vZGEjKOeheV1qalECESE0PySxYF
         pkv/VmVavqOchPBOsVJvThEDq9nH/MNksprB6l3oj14f9X9JwOId/FUoffCxtZZQZvUT
         qrRYDg/B1LfhMJuz0tAWJF5Srb9dEyiQ0/Oqrv/GD72HQUj3nhs0GnCvp718HlykkDgh
         EMvjumMnIF9y2uLmu5qA53PBDJ+qFhYv4qNqR5NEBz0FmIeNHwkus9hLZYfexxNoE5oW
         kiAQ==
X-Gm-Message-State: AOAM533c93oFDx2zNJyD9tiC1vHCMlEX1iZrPBTYvwUPTGDzMpQ2s9/g
        HdAENVyfTe/AEOSwhffIFCEd7dJQZqhTHPQrsdkykvA2ZGk=
X-Google-Smtp-Source: ABdhPJzO39nNvyFEktWfpip5OBtFU7GbxdMTYj9FaurcfqP/XSa40Uspy9xnleBxl8os8qSnmr82bQB4dgHgrt+iGZg=
X-Received: by 2002:ac2:4156:0:b0:443:1591:c2be with SMTP id
 c22-20020ac24156000000b004431591c2bemr19640418lfi.234.1645584253705; Tue, 22
 Feb 2022 18:44:13 -0800 (PST)
MIME-Version: 1.0
References: <20220223011416.323085-1-lsahlber@redhat.com>
In-Reply-To: <20220223011416.323085-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Feb 2022 20:44:02 -0600
Message-ID: <CAH2r5mth2tMZq5k2Z89aSC9Tv1+k-WWN9a_5TGBJ5kTQGDWYUg@mail.gmail.com>
Subject: Re: [PATCH] cifs: truncate the inode and mapping when we simulate fcollapse
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged into cifs-2.6.git for-next pending review and testing

On Tue, Feb 22, 2022 at 7:14 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ:1997367
>
> When we collapse a range in smb3_collapse_range() we must make sure
> we update the inode size and pagecache accordingly.
>
> If not, both inode size and pagecahce may be stale until it is refreshed.
>
> This can be demonstrated for the inode size by running :
>
> xfs_io -i -f -c "truncate 320k" -c "fcollapse 64k 128k" -c "fiemap -v"  \
> /mnt/testfile
>
> where we can see the result of stale data in the fiemap output.
> The third line of the output is wrong, all this data should be truncated.
>
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..127]:        hole               128
>    1: [128..383]:      128..383           256   0x1
>    2: [384..639]:      hole               256
>
> And the correct output, when the inode size has been updated correctly should
> look like this:
>
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..127]:        hole               128
>    1: [128..383]:      128..383           256   0x1
>
> Reported-by: Xiaoli Feng <xifeng@redhat.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index af5d0830bc8a..891b11576e55 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -25,6 +25,7 @@
>  #include "smb2glob.h"
>  #include "cifs_ioctl.h"
>  #include "smbdirect.h"
> +#include "fscache.h"
>  #include "fs_context.h"
>
>  /* Change credits for different ops and return the total number of credits */
> @@ -3887,29 +3888,38 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
>  {
>         int rc;
>         unsigned int xid;
> +       struct inode *inode;
>         struct cifsFileInfo *cfile = file->private_data;
> +       struct cifsInodeInfo *cifsi;
>         __le64 eof;
>
>         xid = get_xid();
>
> -       if (off >= i_size_read(file->f_inode) ||
> -           off + len >= i_size_read(file->f_inode)) {
> +       inode = d_inode(cfile->dentry);
> +       cifsi = CIFS_I(inode);
> +
> +       if (off >= i_size_read(inode) ||
> +           off + len >= i_size_read(inode)) {
>                 rc = -EINVAL;
>                 goto out;
>         }
>
>         rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
> -                                 i_size_read(file->f_inode) - off - len, off);
> +                                 i_size_read(inode) - off - len, off);
>         if (rc < 0)
>                 goto out;
>
> -       eof = cpu_to_le64(i_size_read(file->f_inode) - len);
> +       eof = cpu_to_le64(i_size_read(inode) - len);
>         rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
>                           cfile->fid.volatile_fid, cfile->pid, &eof);
>         if (rc < 0)
>                 goto out;
>
>         rc = 0;
> +
> +       cifsi->server_eof = i_size_read(inode) - len;
> +       truncate_setsize(inode, cifsi->server_eof);
> +       fscache_resize_cookie(cifs_inode_cookie(inode), cifsi->server_eof);
>   out:
>         free_xid(xid);
>         return rc;
> --
> 2.30.2
>


-- 
Thanks,

Steve
