Return-Path: <SRS0=HOJ7=W5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B12C3A59E
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Sep 2019 19:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46B072087E
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Sep 2019 19:42:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="drk3pFKr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfIBTmq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 2 Sep 2019 15:42:46 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44707 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfIBTmq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 2 Sep 2019 15:42:46 -0400
Received: by mail-io1-f66.google.com with SMTP id j4so30941846iog.11;
        Mon, 02 Sep 2019 12:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QnCqjttPsD9VOItZgQKR8PHxubyIWfecxGB1z85kRaA=;
        b=drk3pFKrwK38hMeRXxVG2/nOt7S70Pfl9vl3UrDB/SaQoNBjlHvB0wWXFsN+vGsWPL
         8lXwNSZhUfDAWlfNVUnhJv+pfSH9ZgqRoBfr1Kcc+BBYYDcuN2p65XDjF538ynOkczuK
         wRFtpxcgV1311tVqcH3hbqFBDIXln5wgwCjlbZFTNBNubr8ISIcFOJlOZwSs+d+mHpQ+
         cXrlhW+3yaMM4aqB4guKpTKEUawxMOsiDKUvFDGsiEL9+HGqB3c3muIkkPF3LxiQSZL/
         xmBNYgivufdorFGF+XdUVNhY/sMGsiaWwl0tHBewkKDTfPWu6mkl0VOPS5CgQE7ynN6B
         G2AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QnCqjttPsD9VOItZgQKR8PHxubyIWfecxGB1z85kRaA=;
        b=XTm571X7XphS82r6u6kerEvfNV6IjSNDHCuN+1oiStyoFXTB5a4JbUjHFrpHB9kbEf
         9xGY5LjGgttRUfuRJxgnuFFqEPDy+kv/Vw4ZL8XFWiDxJd5X7sfE00SKFAszyHT5Pd/S
         NCTV2/Fs8w4YeXusguxw9S2ROiAPOG5IOGtOCrqr50q/dN77SKNvk+xcDEHSapempY1Z
         Pc3XGB1VDCf70fNn6pFOo7KfSx2KWUM65ni7I7sQz4oQhkWYhuW6z23hujJmzqjNj/eY
         ALSFkKdB8vKInrrA+FAm6NiDgAoOy/IN5eNdVmuI5iFMav9egQ10UJAk8xh9BFA8IRPQ
         XcMg==
X-Gm-Message-State: APjAAAWgMVZPBrwc3KTk5MMkIfoiI3lkMqFEkNzjZYGLZe9xlB8Fem4s
        P4rLEC78jxRkdi3FSNUTXUAL5/qgGllOCMWU/OMkakIFPFw=
X-Google-Smtp-Source: APXvYqz0ig3Ou3gySoBUVnZyPjYLAcAupHpExck2qSURcqM7IatpW8/XwvrGxI/vgiYJ8fO0ibOunmPv31vCfW2Exhs=
X-Received: by 2002:a5d:9c4c:: with SMTP id 12mr15389478iof.5.1567453365705;
 Mon, 02 Sep 2019 12:42:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190902151059.22088-1-colin.king@canonical.com>
In-Reply-To: <20190902151059.22088-1-colin.king@canonical.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 2 Sep 2019 14:42:34 -0500
Message-ID: <CAH2r5mv_Fv_k8h=-i8-bBrgBU3ghCVM3W=KyLrL=LrrCiT=vOQ@mail.gmail.com>
Subject: Re: [PATCH][V2][cifs-next] cifs: fix dereference on ses before it is
 null checked
To:     Colin King <colin.king@canonical.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged into cifs-2.6.git pending additional testing

Kicked off buildbot with rc7+patches in cifs for-next

See http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/247

On Mon, Sep 2, 2019 at 10:33 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The assignment of pointer server dereferences pointer ses, however,
> this dereference occurs before ses is null checked and hence we
> have a potential null pointer dereference.  Fix this by only
> dereferencing ses after it has been null checked.
>
> Addresses-Coverity: ("Dereference before null check")
> Fixes: 2808c6639104 ("cifs: add new debugging macro cifs_server_dbg")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/cifs/smb2pdu.c   | 11 ++++++++---
>  fs/cifs/transport.c |  3 ++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index dbc6ef50dd45..0e92983de0b7 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2759,8 +2759,10 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>         else
>                 return -EIO;
>
> +       if (!ses)
> +               return -EIO;
>         server = ses->server;
> -       if (!ses || !(server))
> +       if (!server)
>                 return -EIO;
>
>         if (smb3_encryption_required(tcon))
> @@ -3058,13 +3060,16 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
>         int rc = 0;
>         int resp_buftype = CIFS_NO_BUFFER;
>         struct cifs_ses *ses = tcon->ses;
> -       struct TCP_Server_Info *server = ses->server;
> +       struct TCP_Server_Info *server;
>         int flags = 0;
>         bool allocated = false;
>
>         cifs_dbg(FYI, "Query Info\n");
>
> -       if (!ses || !(server))
> +       if (!ses)
> +               return -EIO;
> +       server = ses->server;
> +       if (!server)
>                 return -EIO;
>
>         if (smb3_encryption_required(tcon))
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 0d60bd2f4dca..a90bd4d75b4d 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -1242,12 +1242,13 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
>         struct kvec iov = { .iov_base = in_buf, .iov_len = len };
>         struct smb_rqst rqst = { .rq_iov = &iov, .rq_nvec = 1 };
>         struct cifs_credits credits = { .value = 1, .instance = 0 };
> -       struct TCP_Server_Info *server = ses->server;
> +       struct TCP_Server_Info *server;
>
>         if (ses == NULL) {
>                 cifs_dbg(VFS, "Null smb session\n");
>                 return -EIO;
>         }
> +       server = ses->server;
>         if (server == NULL) {
>                 cifs_dbg(VFS, "Null tcp session\n");
>                 return -EIO;
> --
> 2.20.1
>


-- 
Thanks,

Steve
