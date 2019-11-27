Return-Path: <SRS0=l6Wi=ZT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FD3C432C0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 17:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C8382073F
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 17:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kzH4NtVh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfK0RfV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Nov 2019 12:35:21 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:42645 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbfK0RfV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Nov 2019 12:35:21 -0500
Received: by mail-il1-f193.google.com with SMTP id f6so17735899ilh.9;
        Wed, 27 Nov 2019 09:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m/7eafJgfpqueNmh9ZRZEk1gJa1dWUpLF0+zUtuTQtk=;
        b=kzH4NtVh4OYNO5XWK5q2X34roBeaEFv1hYVrJESPnFMoeX4x6zh9tBek7hAClUkA4g
         k0u/lh3gbjt9kDolNMObn5NxGmBbkvjXhXKltFq5DyktQmHKmXKOzcMrleO4B9c8gL6u
         J7mnuhFXSY7YfFoP6RPu+Bp5dJDR0woy9Z0IHdGYtYOwbPNrf/xDomR1JGfefAL0Liuz
         Q3G9OtMFeRBKoRex2cSnSpSGpnRJaooF0TyxQo6GhD17UXeaQGoP+0UqqDl0rVRkVKQz
         WlgoblxJza9sp4/4zTB3Z0fk6DVyt3n2DpJ/WsGkYjh9tgCL1TEagmjQp/WSOa6FD2FM
         djXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m/7eafJgfpqueNmh9ZRZEk1gJa1dWUpLF0+zUtuTQtk=;
        b=pvtV9tVfjpi6A38PjWtc4YiLQMJyWJ/9RYZzuc9Owtv61kN49PiDw8YR93AngaSos+
         fLGzLxVTRzKn5Iq+0CTg2NsyJ8UsLphZ59yvVk9PT2NDT2Ju0RpBVmWnGIkvkwT/cFaZ
         4WLS33zoMjHOF515SE5U9/aJkXcrrczljx2sjEMCKEaHFUdgqOEOFmT0q/X5/WS3oGlE
         eemYcaA//ri5U686P+MD052ktbSF/cqK/ilou0OVIVZktokOXl/3bavekUlU3VCU4l1d
         VUlxPO/x+VJPSVnwXBVq65Hh+453qBuGNml3fPvpqPtI/0CJJY6y6mFVnXU3LVCHuDrG
         UZPw==
X-Gm-Message-State: APjAAAXgpWVgC8XRkibQys1u5AH7bqwZ+8YDLu+zmuSm5yV8/l1/VOnz
        lfeT1W/AUTG72yTBdRGxmLIHTMDlPak8kOMbr3E=
X-Google-Smtp-Source: APXvYqzfpLfQOzc7XEa3BV41a6BtYeGTMMZpACmEKhIdx9LxMLKPyflnCM1JcbwVuzhbPGp9MFPcwKQVTKF6qnH46ag=
X-Received: by 2002:a92:d642:: with SMTP id x2mr8753929ilp.169.1574876120477;
 Wed, 27 Nov 2019 09:35:20 -0800 (PST)
MIME-Version: 1.0
References: <20191126071650.c76un267i4v6vuoz@kili.mountain>
In-Reply-To: <20191126071650.c76un267i4v6vuoz@kili.mountain>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 27 Nov 2019 11:35:09 -0600
Message-ID: <CAH2r5mvtC4Dt3XDigxp5cqwEtjYCnSK3_aATiW0Dt0s9kBtTuA@mail.gmail.com>
Subject: Re: [PATCH] CIFS: fix a white space issue in cifs_get_inode_info()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Steve French <sfrench@samba.org>, Aurelien Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Nov 26, 2019 at 6:14 AM Dan Carpenter via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> We accidentally messed up the indenting on this if statement.
>
> Fixes: 16c696a6c300 ("CIFS: refactor cifs_get_inode_info()")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/cifs/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 1fec2e7d796a..8a76195e8a69 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -967,7 +967,8 @@ cifs_get_inode_info(struct inode **inode,
>                 }
>         } else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
>                 rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, false,
> -                                      full_path, fid);         if (rc) {
> +                                      full_path, fid);
> +               if (rc) {
>                         cifs_dbg(FYI, "%s: Getting ACL failed with error: %d\n",
>                                  __func__, rc);
>                         goto out;
> --
> 2.11.0
>
>


-- 
Thanks,

Steve
