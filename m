Return-Path: <SRS0=e7mR=CM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C763EC433E2
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Sep 2020 03:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9668F2072A
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Sep 2020 03:00:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uzyva9bn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgICDAJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgICDAI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Sep 2020 23:00:08 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16729C061244
        for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2020 20:00:08 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id v78so1102894ybv.5
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2020 20:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tlf/ogZ9MhG3/a+ZDc2S3ZzJIKPI4phhrApbF1hJWNc=;
        b=Uzyva9bnIadgUIn+LlP2SImwIEhgjzxZSMxTGjAFw0G/04lh0Li7afuKGDz4JA+AM5
         sIOS1EvK+YvsV7WafEcnwfqm+wUGFjg78p/2e+fm+31V708BrxgsGGBmyO17y0XWaQij
         dHIFJlNFN1pJuIsmAacUsNHGoqx6vvz9eWd6HLe8ZGWz0P2/zWL9vhBjD1es2UhQnbaT
         AVtb4Rzx/P8HRf2x6jd01rzbyFPk49WswbO6PSq/MZFn3lbRV1OZA7XZbCuZzfSsi1Jh
         3GGbu0i8Fgdy1LbgB1E5XeGXDXAKFfOrz2yDWMYm1o450kyLqQpsMz65dabXJ5oakT+R
         hQZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tlf/ogZ9MhG3/a+ZDc2S3ZzJIKPI4phhrApbF1hJWNc=;
        b=GgymWN3SwGcjpKbjRngPe7Bbakfy+eIl5KmSovIIyjMWBhI2QorLTmITt1ZPZTo7jf
         vqgdbRXEfh5+WCjjjxgDbXg6ppzDm2n7K7AIoNyc9kuuZaKOWyU9DblKOMLxMwgHldt2
         RsJSSi6MtUS3p0HZq8+8JQPRO0Rf9rgkiPkYknQQCpFMX03njDMMcZs51QnpeQ3iCnZT
         lGNdNG31ZO37JDCa0EEo+fdzdflhJ06hpqWSUxY30s56Qb/qobS5DnRS2nlah5tHfOj8
         foSglxxS6VCQgxRWxPetjK14zuyj+uFg9msw54G4A1jT21N0P6LntryCeVKIOXzPVDDK
         M4GA==
X-Gm-Message-State: AOAM530/V906oSB557R5r2/8clxH3WXfcbPtV/1Ekh4W4cO/y4XVvF8c
        +nF/e6Bw9GXFc0Pe3glvP3339XqQdjYGFI+X6tJ4UlWwrYU=
X-Google-Smtp-Source: ABdhPJxtrs1MMJn4HEDAQefqtXUWcE7u5nzUNG4WBl5/5eU8KEq3iwa7iZw1N5ZXKaHGHBnsc/3IwssZgNlkeB2IrQE=
X-Received: by 2002:a25:e83:: with SMTP id 125mr1223570ybo.376.1599102006998;
 Wed, 02 Sep 2020 20:00:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200903000239.31507-1-lsahlber@redhat.com>
In-Reply-To: <20200903000239.31507-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 2 Sep 2020 21:59:56 -0500
Message-ID: <CAH2r5muUZF6je2VNwE1pXWxg_HST+mhK3535mVn77HMZhK6V5A@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix DFS mount with cifsacl/modefromsid
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Wed, Sep 2, 2020 at 7:02 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 1871246
>
> If during cifs_lookup()/get_inode_info() we encounter a DFS link
> and we use the cifsacl or modefromsid mount options we must suppress
> any -EREMOTE errors that triggers or else we will not be able to follow
> the DFS link and automount the target.
>
> This fixes an issue with modefromsid/cifsacl where these mountoptions woul
> break DFS and we would no longer be able to access the share.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/inode.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 3989d08396ac..1f75b25e559a 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1017,6 +1017,8 @@ cifs_get_inode_info(struct inode **inode,
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) {
>                 rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, true,
>                                        full_path, fid);
> +               if (rc == -EREMOTE)
> +                       rc = 0;
>                 if (rc) {
>                         cifs_dbg(FYI, "%s: Get mode from SID failed. rc=%d\n",
>                                  __func__, rc);
> @@ -1025,6 +1027,8 @@ cifs_get_inode_info(struct inode **inode,
>         } else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
>                 rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, false,
>                                        full_path, fid);
> +               if (rc == -EREMOTE)
> +                       rc = 0;
>                 if (rc) {
>                         cifs_dbg(FYI, "%s: Getting ACL failed with error: %d\n",
>                                  __func__, rc);
> --
> 2.13.6
>


-- 
Thanks,

Steve
