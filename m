Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E479C432C3
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 22:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D848B2068E
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 22:01:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BAId8u52"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfKUWBA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Nov 2019 17:01:00 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:34445 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfKUWBA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Nov 2019 17:01:00 -0500
Received: by mail-il1-f194.google.com with SMTP id p6so4914047ilp.1
        for <linux-cifs@vger.kernel.org>; Thu, 21 Nov 2019 14:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0NXwl2AhtTokQEuDPfAeUbmlZE5jOQqNJIcuGhmGcxE=;
        b=BAId8u526Ecnpo7/ZeiT6aLeCbpP8/UfDM9Vfxy0PXKRooCjGUUH7eTgDrE4zo/rQU
         WXen96TcytlWIAA6B5x6q0WETvKSro4JHqMK2q6W1hdUo4JjeucvtWPO4SLm4J7wZHY0
         Hg7jQBFqOlZcQfcKHOmpYK99WIDIgVW6XbBdv+X6bsw/y9h4jSHYxp7a/R50LURx303s
         gxvXlbVtlzwyHz3oS6JdKnZfVZ9LYFBfxb7yZdoXu8WfwVxXgQsWSBl/qOoYCrmTklVV
         7f7/Ji0LkUaM6kP3xSaBsQqnG9ho/CqrNBf8LOry/QAvtAPBHIKKAF/F53zlcQM+1dZi
         qs8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0NXwl2AhtTokQEuDPfAeUbmlZE5jOQqNJIcuGhmGcxE=;
        b=h/iumou1b6sBA9CYabKDe+9AcDdCqplyVGmjx2H2pn/NjHdoj7ggZ0cvWy+P7bqG4f
         fp2zO7UV9c+Ekzx/XCzXpHxp/+n+r/XdQWWQvIu5wb7WYQ8H7f2S3WI+n+YcZ2eMnTzf
         ppWOKK+DF2kjttDYPD41cUezGAZENpks2q5L6LnLg/OdZA0UK7IO9BC9fBKr7pIrld8Y
         Y8rxkIut5YTMj/2TCttiOabxBcDD46jZ9EOPv6wSSIY/PgNsjQzjCPFTnSV6W4kvO2Jy
         gk4TuU1u2wq1Y6ecKRheawOmHwdc1qrOlktqVL1QyCfNu5B2f3y3Fw78PRhGlt6RWinC
         EwBw==
X-Gm-Message-State: APjAAAV1VLzpu+CyQmo/QAfShO3gFDsIguHVkKKGdgXhKXCwemmjIKDR
        2TPSy263b6nJa/G9X4ILgoVK4Q/GXUZhg0eD960=
X-Google-Smtp-Source: APXvYqxRpeLWrkCJAIFoRChzo4lEqI/dBKCKC46qAF8YUceMJAjpBR5yIKhDjmlN8HtHer+3VB4xnZ0j54L6XFUtgvM=
X-Received: by 2002:a92:8b4e:: with SMTP id i75mr12088878ild.5.1574373658707;
 Thu, 21 Nov 2019 14:00:58 -0800 (PST)
MIME-Version: 1.0
References: <20191121193514.3086-1-pshilov@microsoft.com>
In-Reply-To: <20191121193514.3086-1-pshilov@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 21 Nov 2019 16:00:47 -0600
Message-ID: <CAH2r5muszgyJWP6mUYs6nsHQQN-6ST63DJvyFus+STrJYP4-ug@mail.gmail.com>
Subject: Re: [PATCH 1/3] CIFS: Close open handle after interrupted close
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Paulo Alcantara <paulo@paulo.ac>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Frank Sorenson <sorenson@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged these three (and one of Aurelien's recent patches for
multichannel - need updates to that, also waiting on Paulo's DFS fix)
into cifs-2.6.git for-next (and also the buildbot's gitub for-next
branch)


On Thu, Nov 21, 2019 at 1:35 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> If Close command is interrupted before sending a request
> to the server the client ends up leaking an open file
> handle. This wastes server resources and can potentially
> block applications that try to remove the file or any
> directory containing this file.
>
> Fix this by putting the close command into a worker queue,
> so another thread retries it later.
>
> Cc: Stable <stable@vger.kernel.org>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/smb2misc.c  | 59 ++++++++++++++++++++++++++++++++++-----------
>  fs/cifs/smb2pdu.c   | 16 +++++++++++-
>  fs/cifs/smb2proto.h |  3 +++
>  3 files changed, 63 insertions(+), 15 deletions(-)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 527c9efd3de0..80a8f4b2daab 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -725,36 +725,67 @@ smb2_cancelled_close_fid(struct work_struct *work)
>         kfree(cancelled);
>  }
>
> +/* Caller should already has an extra reference to @tcon */
> +static int
> +__smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
> +                             __u64 volatile_fid)
> +{
> +       struct close_cancelled_open *cancelled;
> +
> +       cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
> +       if (!cancelled)
> +               return -ENOMEM;
> +
> +       cancelled->fid.persistent_fid = persistent_fid;
> +       cancelled->fid.volatile_fid = volatile_fid;
> +       cancelled->tcon = tcon;
> +       INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
> +       WARN_ON(queue_work(cifsiod_wq, &cancelled->work) == false);
> +
> +       return 0;
> +}
> +
> +int
> +smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
> +                           __u64 volatile_fid)
> +{
> +       int rc;
> +
> +       cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
> +       spin_lock(&cifs_tcp_ses_lock);
> +       tcon->tc_count++;
> +       spin_unlock(&cifs_tcp_ses_lock);
> +
> +       rc = __smb2_handle_cancelled_close(tcon, persistent_fid, volatile_fid);
> +       if (rc)
> +               cifs_put_tcon(tcon);
> +
> +       return rc;
> +}
> +
>  int
>  smb2_handle_cancelled_mid(char *buffer, struct TCP_Server_Info *server)
>  {
>         struct smb2_sync_hdr *sync_hdr = (struct smb2_sync_hdr *)buffer;
>         struct smb2_create_rsp *rsp = (struct smb2_create_rsp *)buffer;
>         struct cifs_tcon *tcon;
> -       struct close_cancelled_open *cancelled;
> +       int rc;
>
>         if (sync_hdr->Command != SMB2_CREATE ||
>             sync_hdr->Status != STATUS_SUCCESS)
>                 return 0;
>
> -       cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
> -       if (!cancelled)
> -               return -ENOMEM;
> -
>         tcon = smb2_find_smb_tcon(server, sync_hdr->SessionId,
>                                   sync_hdr->TreeId);
> -       if (!tcon) {
> -               kfree(cancelled);
> +       if (!tcon)
>                 return -ENOENT;
> -       }
>
> -       cancelled->fid.persistent_fid = rsp->PersistentFileId;
> -       cancelled->fid.volatile_fid = rsp->VolatileFileId;
> -       cancelled->tcon = tcon;
> -       INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
> -       queue_work(cifsiod_wq, &cancelled->work);
> +       rc = __smb2_handle_cancelled_close(tcon, rsp->PersistentFileId,
> +                                          rsp->VolatileFileId);
> +       if (rc)
> +               cifs_put_tcon(tcon);
>
> -       return 0;
> +       return rc;
>  }
>
>  /**
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 0aa40129dfb5..2f541e9efba1 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2942,7 +2942,21 @@ int
>  SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
>            u64 persistent_fid, u64 volatile_fid)
>  {
> -       return SMB2_close_flags(xid, tcon, persistent_fid, volatile_fid, 0);
> +       int rc;
> +       int tmp_rc;
> +
> +       rc = SMB2_close_flags(xid, tcon, persistent_fid, volatile_fid, 0);
> +
> +       /* retry close in a worker thread if this one is interrupted */
> +       if (rc == -EINTR) {
> +               tmp_rc = smb2_handle_cancelled_close(tcon, persistent_fid,
> +                                                    volatile_fid);
> +               if (tmp_rc)
> +                       cifs_dbg(VFS, "handle cancelled close fid 0x%llx returned error %d\n",
> +                                persistent_fid, tmp_rc);
> +       }
> +
> +       return rc;
>  }
>
>  int
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 07ca72486cfa..e239f98093a9 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -203,6 +203,9 @@ extern int SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
>  extern int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
>                              const u64 persistent_fid, const u64 volatile_fid,
>                              const __u8 oplock_level);
> +extern int smb2_handle_cancelled_close(struct cifs_tcon *tcon,
> +                                      __u64 persistent_fid,
> +                                      __u64 volatile_fid);
>  extern int smb2_handle_cancelled_mid(char *buffer,
>                                         struct TCP_Server_Info *server);
>  void smb2_cancelled_close_fid(struct work_struct *work);
> --
> 2.17.1
>


-- 
Thanks,

Steve
