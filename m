Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A4AC433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  5 Oct 2022 23:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJEXLq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Oct 2022 19:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiJEXLp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Oct 2022 19:11:45 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1374855B4
        for <linux-cifs@vger.kernel.org>; Wed,  5 Oct 2022 16:11:44 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id o21so826308ejm.11
        for <linux-cifs@vger.kernel.org>; Wed, 05 Oct 2022 16:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LSuLE3bMPDKjgonwGCBflfR4ANjDPFEV37y4NbzKd3Y=;
        b=btW3ifjYNrBYi4b+dJIj1vIvvkdVH0wphQPxycg/BZqLvMWjvhYCo9izWVBUf3qMd+
         kH+kHsTsiOEPIasZIY5DEyAI0xQoC4PVTy6KP8JjMijuS7fSg7NTHrSozmEkRy9UY3dH
         cxDZAt/p06YJzT3IHCOFRlI6mATKt1f/makht7RO0to8Md9RntnrrmJQaM7mUoDI0yop
         K4YuVbmEbOPA2mqE6Wd8KW9FbGvUUd3ZOZpIS/lCBoSpjlqFDSo1YgMu6ldkbpA3uHHi
         ckNW1cSufQeIv+ihDM1vl0vhBvheb6JvdZLrEX4dxTgmsmNTBuHSlamyLc05IN9a/T/S
         FGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LSuLE3bMPDKjgonwGCBflfR4ANjDPFEV37y4NbzKd3Y=;
        b=k25cKHiplq8rKTa960HS6UO9BdpBWs0ARFTeWzAWimi+EnWD63EjqTle8jtXbfpgRe
         EZnS+0sKXT0A2Qt6O2ZLHhrbW1hCBEu2s2AOjkb+/RkhVHrccTTT4fuOMI0HLstSxK+2
         4m/fs1n8GCuP5fATr/5EkErJmwy/wE8igIZs9natVrEDF66RqlT8nweKJSXcwwy+mQo/
         MF9uqVYZDYYr/ncCyicJjMeUmDJs6tjgTuhGaLR+cpB2ywN6EWaKNVvpxovVt1dapP4H
         zILEzrBdd30DX4V8u+xM/ciLywZMzdRJNLt2OJ1a9b52SttscKD2tNsctG/WAixr7MYQ
         VEtA==
X-Gm-Message-State: ACrzQf2AHV0FeW2+DxFMxbXGMGbIrX/f8qyRFPe5sczS8AY5k8CcxiAI
        fu/94VJkWSODKDsA6kCN+UFYVagM11nBJa84454=
X-Google-Smtp-Source: AMsMyM5V36s20yVBEZ+KdlpRPIDXKg4YD4cleP0563BJszfTCfdxO+SXHRtJtewNIsvyCVTsP2Mh36TZ59fiC+KjY00=
X-Received: by 2002:a17:906:a0d3:b0:73d:be5b:2b52 with SMTP id
 bh19-20020a170906a0d300b0073dbe5b2b52mr1553223ejb.727.1665011503524; Wed, 05
 Oct 2022 16:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <20221004181325.15207-1-pc@cjr.nz> <20221005230447.9551-1-pc@cjr.nz>
 <20221005230447.9551-2-pc@cjr.nz>
In-Reply-To: <20221005230447.9551-2-pc@cjr.nz>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 6 Oct 2022 09:11:31 +1000
Message-ID: <CAN05THTRgN-YTO42CwYPVeooY3mFccgA9t7ajKyFWt+Px-Pp3w@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] cifs: fix uninitialised var in smb2_compound_op()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed by me

On Thu, 6 Oct 2022 at 09:06, Paulo Alcantara <pc@cjr.nz> wrote:
>
> Fix uninitialised variable @idata when calling smb2_compound_op() with
> SMB2_OP_POSIX_QUERY_INFO.
>
> Fixes: 5079f2691f73 ("cifs: improve symlink handling for smb2+")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
> v2 -> v3: no changes
>
>  fs/cifs/smb2inode.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index adf71b328f32..a6640e6ea58b 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -415,6 +415,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
>                                                 tcon->tid);
>                 break;
>         case SMB2_OP_POSIX_QUERY_INFO:
> +               idata = ptr;
>                 if (rc == 0 && cfile && cfile->symlink_target) {
>                         idata->symlink_target = kstrdup(cfile->symlink_target, GFP_KERNEL);
>                         if (!idata->symlink_target)
> --
> 2.37.3
>
