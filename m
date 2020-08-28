Return-Path: <SRS0=XS0s=CG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDC1C433E2
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Aug 2020 15:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69F8C208C9
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Aug 2020 15:50:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h/UfiPow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgH1Pu5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Aug 2020 11:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgH1Pux (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Aug 2020 11:50:53 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B27C061264
        for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2020 08:50:53 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id p191so811469ybg.0
        for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2020 08:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hp+VgC4z3aX3helAbHBY9JTHKkDXf2/xPL4Q1Er5W3E=;
        b=h/UfiPowNuUdX9AqwzSObrEpbE5eb62Q6mSH3izKz1xo9sbnEBXzCg/66FpdjOWRch
         Jwvz+OAUZtJGkynq0e21s+Sr03wPaxTID8rpD0KCftPjSTbRXcX4n9ZdypoX/Jqc5n6B
         YoRN/Wpo43QprywqyqZZ9RhLXq/f8EBliYmzq9DWaV/hcEbDRtt7dtxVo55+HGzUFk3p
         UcWHmIjjayI1B4Zu0sKTAui5AZn5jfjBfSUo9gB984oJm59+rm7uHnqBz3Wvj2sbnnCB
         As/ylWMAKeV18873T6d+DtCxbaBjHVe8HkXU7PdqLu+gRm2Tx2VT+qddLB410b+yN1VD
         XL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hp+VgC4z3aX3helAbHBY9JTHKkDXf2/xPL4Q1Er5W3E=;
        b=R0rT41DC9yBwbi8x5rVc41+09P3umMI1V32d6tt4fTz2XM8twfXrKP+sYBYp1jaiG3
         LOEZycZwUdTcAECJHvJR7lH8F3ctYnvwIbkoVq0twMB79yYbk7v5QxILw4BLMf/axfOj
         wUwvZ+7w9RxRXrmKIUIiaZf1sWQ96aBIaIquWtNcM5OMKrBdceHQVsfb7O2HwrZymdfF
         huaEaeVjCHkGdFDl4j4TI5VcbaaDqc22cnvFm/msAlxCPayhi2TD6FLXutsRKHomVKXA
         Lmr+oF250aNb/8Ou40U9uuAcjFeD5GIj6IISAYLnbWbNEtAcp0190QFh7LezxoOnGbLG
         FTmg==
X-Gm-Message-State: AOAM532JpcQ3pdsSfiVTrUdifVmCEZsNNdJUROeiWPbVC7AYG7OqG1kf
        6/FpkBB5/wz5B7WPzphz35xBWuWsy1n9hCLX6Tpqt2TOe8Y=
X-Google-Smtp-Source: ABdhPJxtPE/mbyyz1WKis8LlTZFfYhYyEx4lkL/AqH8buS05ygPO9WSOlv7671Rff9Q/KCXAb2TqCJcuVf9boQVPXhw=
X-Received: by 2002:a25:bb49:: with SMTP id b9mr3142981ybk.331.1598629852682;
 Fri, 28 Aug 2020 08:50:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200827142019.26968-1-pc@cjr.nz>
In-Reply-To: <20200827142019.26968-1-pc@cjr.nz>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 28 Aug 2020 21:20:40 +0530
Message-ID: <CANT5p=o2zdnioP+-McsM+AAzBGrdgNkq0pFXdXATc76=SP9YyA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix check of tcon dfs in smb1
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

These changes look good to me.
However, I see other places in the code where these flags are checked
separately. Don't we want to replace all those with is_tcon_dfs()
calls?

Regards,
Shyam

On Thu, Aug 27, 2020 at 8:05 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> For SMB1, the DFS flag should be checked against tcon->Flags rather
> than tcon->share_flags.  While at it, add an is_tcon_dfs() helper to
> check for DFS capability in a more generic way.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/cifsglob.h | 15 +++++++++++++++
>  fs/cifs/connect.c  |  2 +-
>  2 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index b296964b8afa..b565d83ba89e 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -2031,4 +2031,19 @@ static inline bool is_smb1_server(struct TCP_Server_Info *server)
>         return strcmp(server->vals->version_string, SMB1_VERSION_STRING) == 0;
>  }
>
> +static inline bool is_tcon_dfs(struct cifs_tcon *tcon)
> +{
> +       /*
> +        * For SMB1, see MS-CIFS 2.4.55 SMB_COM_TREE_CONNECT_ANDX (0x75) and MS-CIFS 3.3.4.4 DFS
> +        * Subsystem Notifies That a Share Is a DFS Share.
> +        *
> +        * For SMB2+, see MS-SMB2 2.2.10 SMB2 TREE_CONNECT Response and MS-SMB2 3.3.4.14 Server
> +        * Application Updates a Share.
> +        */
> +       if (!tcon || !tcon->ses || !tcon->ses->server)
> +               return false;
> +       return is_smb1_server(tcon->ses->server) ? tcon->Flags & SMB_SHARE_IS_IN_DFS :
> +               tcon->share_flags & (SHI1005_FLAGS_DFS | SHI1005_FLAGS_DFS_ROOT);
> +}
> +
>  #endif /* _CIFS_GLOB_H */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index a275ee399dce..392c44d64d8a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -4909,7 +4909,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
>                 if (!tcon)
>                         continue;
>                 /* Make sure that requests go through new root servers */
> -               if (tcon->share_flags & (SHI1005_FLAGS_DFS | SHI1005_FLAGS_DFS_ROOT)) {
> +               if (is_tcon_dfs(tcon)) {
>                         put_root_ses(root_ses);
>                         set_root_ses(cifs_sb, ses, &root_ses);
>                 }
> --
> 2.28.0
>


-- 
-Shyam
