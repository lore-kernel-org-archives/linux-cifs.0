Return-Path: <SRS0=edh0=32=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA1CC33CAC
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 18:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5401620659
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 18:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vgJOSc5r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbgBFSYK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Feb 2020 13:24:10 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34732 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgBFSYJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Feb 2020 13:24:09 -0500
Received: by mail-lf1-f66.google.com with SMTP id l18so4809085lfc.1
        for <linux-cifs@vger.kernel.org>; Thu, 06 Feb 2020 10:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lbZBSFwDqSxZ0pCrF1kKALw4EFoKV+ZsKnlp3YXTxLI=;
        b=vgJOSc5rGnhQV8WiHw6Tad37z8m44AU8q2WePJXWC4j/jR2PDuRtOI90yJIVNHRYyZ
         9KZZNwIuCh4cmJ3SLfVzymsI5dPLUy8+YSdYgjNOTvp7xjazy0ZmZlzgKxwWpxSNmnhs
         SB5l6qhAbH1GXPPzXv9D6WynfTGT7hXGVYOGF8POE4/K3eYIZanphbPqdlFZjCljn0ZB
         AFfGl1a/50/UtVceNAECKZBrSARdDN9X8V09h0MmF8UUZ35U+lRIV3FD6bRJcH2pHbFC
         t1Y2N0GgGqNYvnwxS/DO3YlFD7XzpgIfwpm3UI17FhsVleZaU+FBlmkdDKDMvkz6lCEL
         BBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lbZBSFwDqSxZ0pCrF1kKALw4EFoKV+ZsKnlp3YXTxLI=;
        b=OR2NdfQG7e0t35cnlDwFgp8O/NFC/f7fKUfSn4sUwQ0fEAlrWETArwUB4whCkYQY5A
         ySXIBrX/aOMj9I8SL8VFKa/t+XZq5xOesSKQOpRExRMsWvlKEFet9Xtp5CQ9jbgY3hTi
         gsYDPqLyuQ8DSv1ImN3RICHMtAwr00yF/+aIe7jQFeD015VQWmHjkaHxJi1l2gP6Lb8Q
         PD0gIQrTuxnM7iJDaVo0ApVVe7X8eTiiaRRUOhbkMY5iToaVNEJudlA6Z481DgPrNFKh
         tBzbrbiiDn2R4p2AZZxpnEhvV0tqQ/i5Kv6V778qr2QNDeWmmIXD70nvAXO/Rs3BOUEt
         H79g==
X-Gm-Message-State: APjAAAVzutQXzIm7QCphSBC2QiXI5vJlAWAfJ1XIBkOX8G/+41fRjTzI
        UU2gMGmsldtNzoUnuh2W0oVKRCQt9TNd1hyMRw==
X-Google-Smtp-Source: APXvYqxkgDvm0AZoaR1QZIbW8VouqQKCDomcYzki0rcQZ835QKhAfT6T/kZ5A5UV/HasTEZeBb14nv05psl9KY9+vGs=
X-Received: by 2002:ac2:5335:: with SMTP id f21mr2542134lfh.150.1581013446679;
 Thu, 06 Feb 2020 10:24:06 -0800 (PST)
MIME-Version: 1.0
References: <20200206171655.23659-1-aaptel@suse.com>
In-Reply-To: <20200206171655.23659-1-aaptel@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 6 Feb 2020 10:23:55 -0800
Message-ID: <CAKywueRn3R1P7FXAkMAOD0unbFvUAJcojEXrqT0=bUBCU9b8Jw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix mode bits from dir listing when mounted with modefromsid
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 6 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 09:17, Aureli=
en Aptel <aaptel@suse.com>:
>
> When mounting with -o modefromsid, the mode bits are stored in an
> ACE. Directory enumeration (e.g. ls -l /mnt) triggers an SMB Query Dir
> which does not include ACEs in its response. The mode bits in this
> case are silently set to a default value of 755 instead.
>
> This patch marks the dentry created during the directory enumeration
> as needing re-evaluation (i.e. additional Query Info with ACEs) so
> that the mode bits can be properly extracted.
>
> Quick repro:
>
> $ mount.cifs //win19.test/data /mnt -o ...,modefromsid
> $ touch /mnt/foo && chmod 751 /mnt/foo
> $ stat /mnt/foo
>   # reports 751 (OK)
> $ sleep 2
>   # dentry older than 1s by default get invalidated
> $ ls -l /mnt
>   # since dentry invalid, ls does a Query Dir
>   # and reports foo as 755 (WRONG)
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  fs/cifs/readdir.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index d17587c2c4ab..ba9dadf3be24 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -196,7 +196,8 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struc=
t cifs_sb_info *cifs_sb)
>          * may look wrong since the inodes may not have timed out by the =
time
>          * "ls" does a stat() call on them.
>          */
> -       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
> +       if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
> +           (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID))
>                 fattr->cf_flags |=3D CIFS_FATTR_NEED_REVAL;
>
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL &&
> --
> 2.16.4
>

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

This patch needs stable tag since "modefromsid" was introduced in v5.5.

--
Best regards,
Pavel Shilovsky
