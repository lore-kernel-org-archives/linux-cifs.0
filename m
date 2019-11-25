Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20674C432C0
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 07:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E67BF2064B
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 07:33:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UfCErSQn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfKYHdr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 02:33:47 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:36774 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfKYHdr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Nov 2019 02:33:47 -0500
Received: by mail-io1-f67.google.com with SMTP id s3so15099105ioe.3
        for <linux-cifs@vger.kernel.org>; Sun, 24 Nov 2019 23:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XZlFw4d0PFZwVyioRky5TjFNrVnNuhesSjtG4ltQyAc=;
        b=UfCErSQnzTYS4Lw/IjnSm10EDAH1lowEgCrhZVA3KdyxmYAnFK4Zb8fVgOnb2low97
         X9PKZMpqmcQevd4VuL3foPQWDuCSUaa6XhITNjBtARfApdynzkwbldqaU20oLjXw2IoC
         +A44QD9QOypoODHW2bdWu5oBu4bRTuOMbRE69qMHueKfzmD4bEDXJBjp01xNfuRGucXE
         8UnM7Z0q/WzwW0/QIqkh1cc8Viei0FgEsP0JeEahZWJ7PJGcnNYZksNkSGtzhxAUP7zR
         yIYJE7yw23ptXPTEGFTvuz28IBn28auhsMbCVD5w0HQaP9M9dbgyV0GFILFlU1Jc31Cx
         AQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZlFw4d0PFZwVyioRky5TjFNrVnNuhesSjtG4ltQyAc=;
        b=ipwHLfo2I0aV9g8jn/4cBRGSyKW/tKVN0sMne+VDy8+F+JKxIj5cXNa/FGcyutObjE
         HlorHy0y1vHuN1ug3+NJe5E5idtjcAGD2Ovy35GNZLVfni93Ntx95SULCLJgPrRC96Ve
         YMm1deGDlcmsOiZOZiD7FVjIUHPx93/VyDgGnbRJ6ED9V+Y/NkWybF88RnouDB0T/LTy
         PTWcdvO/D7OJrbiSy3STMx29rIg1/HBTbZ+WRjIiUnqoMryrB4cs4456fRoO5+n+zKsU
         7rPHjqCVpt84C62JSt4wE0G8qxEfxlGVS5Z8mBKPB5u4x71fsT51GLjcrbdB9ceI8yrz
         LMfQ==
X-Gm-Message-State: APjAAAURS2RvY5zHVrVa1trGQ8nfD61+mbEvHSei22XxKQMjGMD+kyCy
        buR7t4nC6KPb31MxphWdNeF3Cj39TcMHCY/4sn1b2A==
X-Google-Smtp-Source: APXvYqyb0eCgMYXgd/b2Cnmrj9FraWeS22+L4fnWQScs1I59JdTXvfOx/PF+0o63cACy4Rhb6rTujtAHOL3ZEbs3TDk=
X-Received: by 2002:a5d:848c:: with SMTP id t12mr23621868iom.5.1574667226125;
 Sun, 24 Nov 2019 23:33:46 -0800 (PST)
MIME-Version: 1.0
References: <20191122153057.6608-1-pc@cjr.nz> <20191122153057.6608-3-pc@cjr.nz>
In-Reply-To: <20191122153057.6608-3-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Nov 2019 01:33:35 -0600
Message-ID: <CAH2r5muh8wfP331W6wVmegfrd-da-rcRe_YeJOyF=+5yy-pDjA@mail.gmail.com>
Subject: Re: [PATCH 2/7] cifs: Fix lookup of root ses in DFS referral cache
To:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Fri, Nov 22, 2019 at 9:31 AM Paulo Alcantara (SUSE) <pc@cjr.nz> wrote:
>
> We don't care about module aliasing validation in
> cifs_compose_mount_options(..., is_smb3) when finding the root SMB
> session of an DFS namespace in order to refresh DFS referral cache.
>
> The following issue has been observed when mounting with '-t smb3' and
> then specifying 'vers=2.0':
>
> ...
> Nov 08 15:27:08 tw kernel: address conversion returned 0 for FS0.WIN.LOCAL
> Nov 08 15:27:08 tw kernel: [kworke] ==> dns_query((null),FS0.WIN.LOCAL,13,(null))
> Nov 08 15:27:08 tw kernel: [kworke] call request_key(,FS0.WIN.LOCAL,)
> Nov 08 15:27:08 tw kernel: [kworke] ==> dns_resolver_cmp(FS0.WIN.LOCAL,FS0.WIN.LOCAL)
> Nov 08 15:27:08 tw kernel: [kworke] <== dns_resolver_cmp() = 1
> Nov 08 15:27:08 tw kernel: [kworke] <== dns_query() = 13
> Nov 08 15:27:08 tw kernel: fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: FS0.WIN.LOCAL to 192.168.30.26
> ===> Nov 08 15:27:08 tw kernel: CIFS VFS: vers=2.0 not permitted when mounting with smb3
> Nov 08 15:27:08 tw kernel: fs/cifs/dfs_cache.c: CIFS VFS: leaving refresh_tcon (xid = 26) rc = -22
> ...
>
> Fixes: 5072010ccf05 ("cifs: Fix DFS cache refresher for DFS links")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/dfs_cache.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
> index 1692c0c6c23a..2faa05860a48 100644
> --- a/fs/cifs/dfs_cache.c
> +++ b/fs/cifs/dfs_cache.c
> @@ -1317,7 +1317,6 @@ static struct cifs_ses *find_root_ses(struct dfs_cache_vol_info *vi,
>         int rc;
>         struct dfs_info3_param ref = {0};
>         char *mdata = NULL, *devname = NULL;
> -       bool is_smb3 = tcon->ses->server->vals->header_preamble_size == 0;
>         struct TCP_Server_Info *server;
>         struct cifs_ses *ses;
>         struct smb_vol vol;
> @@ -1344,7 +1343,7 @@ static struct cifs_ses *find_root_ses(struct dfs_cache_vol_info *vi,
>                 goto out;
>         }
>
> -       rc = cifs_setup_volume_info(&vol, mdata, devname, is_smb3);
> +       rc = cifs_setup_volume_info(&vol, mdata, devname, false);
>         kfree(devname);
>
>         if (rc) {
> --
> 2.24.0
>


-- 
Thanks,

Steve
