Return-Path: <SRS0=e9ua=QV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08D9C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 07:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E1622229F
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 07:33:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ebncazbG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387650AbfBNHdg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 02:33:36 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34818 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfBNHdg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Feb 2019 02:33:36 -0500
Received: by mail-pl1-f194.google.com with SMTP id p8so2702074plo.2
        for <linux-cifs@vger.kernel.org>; Wed, 13 Feb 2019 23:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=b2F/cECTSvtlg6f4yTPsq1KoKw8Me+yQdv1rZ7BdRS8=;
        b=ebncazbGelNFlo09mklmKoXLtVZ+ySYZmRpozCx52z8AcqgZHt3Guui2ecCQavZBkN
         Iy7EI+XN0APydbu3xW5r7LbkYENqKFNd/XcLj01QtfjMBx9h+P5CpOdg4GrOjjkHYyuk
         3vVWBRKp1yugiuO5p6ZfgKJCx9nlY+oqUnUYW/hnAG6d34PF4cu7AHu+4c+rNYmXrOud
         rsiixuWHGu/DlfVMAj04waASZpCE6t5tU9XBWjaZ0Gkm1HekvSpZDEQEIDYx9Kqot7TN
         bfss7BAW5zb8a4GGE0RrhCnwKJg6rVrQjKyMEb16nWMTBlh3HxBjHHbTHUJxFvrhb2L4
         801Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=b2F/cECTSvtlg6f4yTPsq1KoKw8Me+yQdv1rZ7BdRS8=;
        b=YWlchZmAAnYG9j+pS1XZXdELqHQZ64NHWv1zeJ+jwGm3S/cSPmutms6B/qJ2TfbyBq
         vTB56Y2HAyWQOqQBXjAHNEE7o7Zot/dLaj2cTIfUi3kdJffRYt1zy74WteS5gXOO1QXD
         PmDIpbXd/uZO2kWsuoUW6FKpcl8Nf/T3GBbWBorLn0lmrm/qfdCQroctyRt/VR6V9PcJ
         YkWbcPZhqqGq35OecGcEj5F4jx1wQzC7ER6hk87MGXxNDffmoYT8tM1w4o29ZKbIAWP6
         rZ2/sG4RAAGpXWCwF1/8pXXgov0gNZ+WMLTUlNUGr0ZG3S2N4wVJCyW6vYBWQ1Sj3xl3
         5YHQ==
X-Gm-Message-State: AHQUAuZY8BUqK7BBBw4YrUrtrmx9fZVHvObF5mUnzXt3zSzj3R4ACBOo
        Ry1fuZMKK83wIdS+RaqgVHa4EpmguS4dhpuyKgU=
X-Google-Smtp-Source: AHgI3Ib4CEjkbY+R2+u02BUCRVyvJKtXWI2q4qBCx7J+WoK1G0Kt2dP82GHjRXZgINSgBuUBP36/kvVX+85fHsEqUv8=
X-Received: by 2002:a17:902:822:: with SMTP id 31mr895767plk.290.1550129615591;
 Wed, 13 Feb 2019 23:33:35 -0800 (PST)
MIME-Version: 1.0
References: <1550101388-19431-1-git-send-email-pshilov@microsoft.com>
In-Reply-To: <1550101388-19431-1-git-send-email-pshilov@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Feb 2019 01:33:24 -0600
Message-ID: <CAH2r5mtVGv-a-LBWNoLeL4qZUjG11Bv7x4hZX9roJqDPhSQUpA@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Do not reset lease state to NONE on lease break
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Updated and remerged to cifs-2.6.git for-next

Buildbot kicked off again as well

On Wed, Feb 13, 2019 at 5:43 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> Currently on lease break the client sets a caching level twice:
> when oplock is detected and when oplock is processed. While the
> 1st attempt sets the level to the value provided by the server,
> the 2nd one resets the level to None unconditionally.
> This happens because the oplock/lease processing code was changed
> to avoid races between page cache flushes and oplock breaks.
> The commit c11f1df5003d534 ("cifs: Wait for writebacks to complete
> before attempting write.") fixed the races for oplocks but didn't
> apply the same changes for leases resulting in overwriting the
> server granted value to None. Fix this by properly processing
> lease breaks.
>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/smb2misc.c | 17 ++++++++++++++---
>  fs/cifs/smb2ops.c  | 15 ++++++++++++---
>  2 files changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 7b8b58f..58700d2 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -517,7 +517,6 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
>         __u8 lease_state;
>         struct list_head *tmp;
>         struct cifsFileInfo *cfile;
> -       struct TCP_Server_Info *server = tcon->ses->server;
>         struct cifs_pending_open *open;
>         struct cifsInodeInfo *cinode;
>         int ack_req = le32_to_cpu(rsp->Flags &
> @@ -537,13 +536,25 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
>                 cifs_dbg(FYI, "lease key match, lease break 0x%x\n",
>                          le32_to_cpu(rsp->NewLeaseState));
>
> -               server->ops->set_oplock_level(cinode, lease_state, 0, NULL);
> -
>                 if (ack_req)
>                         cfile->oplock_break_cancelled = false;
>                 else
>                         cfile->oplock_break_cancelled = true;
>
> +               set_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
> +
> +               /*
> +                * Set or clear flags depending on the lease state being READ.
> +                * HANDLE caching flag should be added when the client starts
> +                * to defer closing remote file handles with HANDLE leases.
> +                */
> +               if (lease_state & SMB2_LEASE_READ_CACHING_HE)
> +                       set_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
> +                               &cinode->flags);
> +               else
> +                       clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
> +                                 &cinode->flags);
> +
>                 queue_work(cifsoplockd_wq, &cfile->oplock_break);
>                 kfree(lw);
>                 return true;
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 1995bbe..e560e60 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2641,6 +2641,15 @@ smb2_downgrade_oplock(struct TCP_Server_Info *server,
>  }
>
>  static void
> +smb21_downgrade_oplock(struct TCP_Server_Info *server,
> +                      struct cifsInodeInfo *cinode, bool set_level2)
> +{
> +       server->ops->set_oplock_level(cinode,
> +                                     set_level2 ? SMB2_LEASE_READ_CACHING_HE :
> +                                     0, 0, NULL);
> +}
> +
> +static void
>  smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
>                       unsigned int epoch, bool *purge_cache)
>  {
> @@ -3693,7 +3702,7 @@ struct smb_version_operations smb21_operations = {
>         .print_stats = smb2_print_stats,
>         .is_oplock_break = smb2_is_valid_oplock_break,
>         .handle_cancelled_mid = smb2_handle_cancelled_mid,
> -       .downgrade_oplock = smb2_downgrade_oplock,
> +       .downgrade_oplock = smb21_downgrade_oplock,
>         .need_neg = smb2_need_neg,
>         .negotiate = smb2_negotiate,
>         .negotiate_wsize = smb2_negotiate_wsize,
> @@ -3791,7 +3800,7 @@ struct smb_version_operations smb30_operations = {
>         .dump_share_caps = smb2_dump_share_caps,
>         .is_oplock_break = smb2_is_valid_oplock_break,
>         .handle_cancelled_mid = smb2_handle_cancelled_mid,
> -       .downgrade_oplock = smb2_downgrade_oplock,
> +       .downgrade_oplock = smb21_downgrade_oplock,
>         .need_neg = smb2_need_neg,
>         .negotiate = smb2_negotiate,
>         .negotiate_wsize = smb3_negotiate_wsize,
> @@ -3897,7 +3906,7 @@ struct smb_version_operations smb311_operations = {
>         .dump_share_caps = smb2_dump_share_caps,
>         .is_oplock_break = smb2_is_valid_oplock_break,
>         .handle_cancelled_mid = smb2_handle_cancelled_mid,
> -       .downgrade_oplock = smb2_downgrade_oplock,
> +       .downgrade_oplock = smb21_downgrade_oplock,
>         .need_neg = smb2_need_neg,
>         .negotiate = smb2_negotiate,
>         .negotiate_wsize = smb3_negotiate_wsize,
> --
> 2.7.4
>


-- 
Thanks,

Steve
