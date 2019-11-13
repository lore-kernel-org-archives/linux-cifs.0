Return-Path: <SRS0=3kj9=ZF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA53C43331
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 05:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3562222D0
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 05:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J12LO26W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfKMFgn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Nov 2019 00:36:43 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:42392 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfKMFgn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Nov 2019 00:36:43 -0500
Received: by mail-il1-f195.google.com with SMTP id n18so636127ilt.9
        for <linux-cifs@vger.kernel.org>; Tue, 12 Nov 2019 21:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Ex2RV6R+84+wD0ZUugcdpdh/JZoFChuhNjMx/Kmt8M=;
        b=J12LO26Wi2hSAggo6ascAeESpbBXUbhKeH5lSYfHBH3WqvDC9XbHxjLbHOSfJ0A16W
         JBHdmZBAbDD+W3QMWLutcKJ0sy7T1CFpm6vlS6fvAj6UaFv93VYsaZW6buiHnWh6TsWJ
         68I916bFoibE5nKLOAFDS3OOaEQreMYNrLKZ1uGPLbG90BmX7MtrfhniiC1Q762sHYeL
         mm+7RiAx83AAkdBntGAkX7XuSfvMju5gukuVRlJFjr9cPtdmsT4snfQILaKpDJzzcCtK
         lgLy6E53VkhYZOZoL2xZNot8mxHK8hK+2kpnR6h9V4y6a7UCZI5Y4wpVaTOjM1hTmdKq
         /dVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Ex2RV6R+84+wD0ZUugcdpdh/JZoFChuhNjMx/Kmt8M=;
        b=MHBiUK8F8eqNj4PXbgsjMRm54r20TysipXq7tkBZWc4PAjPjOMBauM8yeUO0lnegle
         +7Cl9azDzt+5nyiXC5AiJ1kvDcmk9DCf26q/B79C/nngwCXwON/MOuVArCoOgi0oDdtc
         dfM8k3u8MT+FWF3lOxpkx8ejyLOD1SLuY6oM9qNe8yfn7+PZWIeoRf1avhl74N9nVQJR
         7Rh1KraH7N77nKlSsSQ2CS3Ob4f7v9xDH0gbcUnAzUArexGdzDwNrylGtHxvQgJMI0uJ
         ewVMKivXHECIH9ob4+e0DPNtkY1OsdQf5xxC3c60UHUojD6VDc/YrBP9Xnku1Ty3kMVU
         waWQ==
X-Gm-Message-State: APjAAAXlkmtOzaRrQbHgS22EhQ9V/UpxLtmNoahtyy2xXakY/qqPLYY/
        TdW4WY1s9Z/xrnEsCs87OJyTzZCkgpfEfoGtxt4=
X-Google-Smtp-Source: APXvYqy8AXb2770sBpZMorwVEEEkaBQP272M4arQvwaHjGujo9UlYdpe1wz6eyXraies9NKaoBQnqs8q8oRMWHADHks=
X-Received: by 2002:a92:5d8f:: with SMTP id e15mr1907333ilg.173.1573623402362;
 Tue, 12 Nov 2019 21:36:42 -0800 (PST)
MIME-Version: 1.0
References: <20191113011635.3511-1-pshilov@microsoft.com> <1128615593.11430327.1573615953153.JavaMail.zimbra@redhat.com>
In-Reply-To: <1128615593.11430327.1573615953153.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 12 Nov 2019 23:36:31 -0600
Message-ID: <CAH2r5mvoGpOPZQuvct+7eovewmuCTrnErpvqkgc033dk-skKiw@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Respect O_SYNC and O_DIRECT flags during reconnect
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next and also updated the github tree
(used by the buildbot e.g.)

On Tue, Nov 12, 2019 at 9:32 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>
>
> ----- Original Message -----
> From: "Pavel Shilovsky" <piastryyy@gmail.com>
> To: linux-cifs@vger.kernel.org, smfrench@gmail.com
> Sent: Wednesday, 13 November, 2019 11:16:35 AM
> Subject: [PATCH] CIFS: Respect O_SYNC and O_DIRECT flags during reconnect
>
> Currently the client translates O_SYNC and O_DIRECT flags
> into corresponding SMB create options when openning a file.
> The problem is that on reconnect when the file is being
> re-opened the client doesn't set those flags and it causes
> a server to reject re-open requests because create options
> don't match. The latter means that any subsequent system
> call against that open file fail until a share is re-mounted.
>
> Fix this by properly setting SMB create options when
> re-openning files after reconnects.
>
> Fixes: 1013e760d10e6: ("SMB3: Don't ignore O_SYNC/O_DSYNC and O_DIRECT flags")
> Cc: Stable <stable@vger.kernel.org>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/file.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index b6f544bc6c73..89617bb058ae 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -721,6 +721,13 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
>         if (backup_cred(cifs_sb))
>                 create_options |= CREATE_OPEN_BACKUP_INTENT;
>
> +       /* O_SYNC also has bit for O_DSYNC so following check picks up either */
> +       if (cfile->f_flags & O_SYNC)
> +               create_options |= CREATE_WRITE_THROUGH;
> +
> +       if (cfile->f_flags & O_DIRECT)
> +               create_options |= CREATE_NO_BUFFER;
> +
>         if (server->ops->get_lease_key)
>                 server->ops->get_lease_key(inode, &cfile->fid);
>
> --
> 2.17.1
>


-- 
Thanks,

Steve
