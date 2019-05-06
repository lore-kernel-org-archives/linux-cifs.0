Return-Path: <SRS0=HMAP=TG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C99C04A6B
	for <linux-cifs@archiver.kernel.org>; Mon,  6 May 2019 16:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 548C0205ED
	for <linux-cifs@archiver.kernel.org>; Mon,  6 May 2019 16:53:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sgp1r6qY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfEFQx5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 May 2019 12:53:57 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42809 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEFQx5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 May 2019 12:53:57 -0400
Received: by mail-pl1-f193.google.com with SMTP id x15so6654506pln.9;
        Mon, 06 May 2019 09:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QHR30QHWaEMKuBtolQ2NneRKOvfmqfNuUO14VeP7MAA=;
        b=sgp1r6qYOBFSG8qGTJG4TAg8ach0Efpw/cUCKPggbuUhBsLq/dsFpQUu1zj79P+L2n
         SQi6WZg0PigG7bKi/lRcvCHsMvQjlcbjYocXvG9xz+bz+s27Ad+lKTniP2q0Jvf99mRF
         eiUcivMHfRNVaty/y74wjEqqauujO0MoFWjIgbBOSo7AFY96Lmsqlkh2DUbyjgd8lY6i
         MTBVv/z/DdjpsMVFvoe3mIwjGui+YdRFcukvblRxA8eDGIvja1QM6kOt5xcuTQa0HGWU
         653p5mxnmQfY4ORHVKDSBWljMDTyW/Yz1lt8VPQMwpu8pNfwW8mlhZxIGMF/7oJHXp+a
         bv0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QHR30QHWaEMKuBtolQ2NneRKOvfmqfNuUO14VeP7MAA=;
        b=O0a3XqB9QlSjzLRqpzrKPINVEJB0+94yBAUadZ2hFXnQVh/TvBJNDJwMS+TX+N2B9q
         NO1u4KfCDRMTOD1y6duhc1WD4po2Z+1y6NjzW/rfUJh2dqYMODLs4MHHh1KTa49U+5eA
         vGl08spCbu6ACqoPa0RDAYbBKpgqHjWaULF61u1h8+wRkSyhmKeiJnwIei8Ql6NHfVNr
         tAyLnAk5dQmmbokqOTpgDeX32vwJTtqqy9GX1xsbuURGdPd2C/7du1Ta11eg8iIrRQYN
         o+SimgcGXgZzqmBayJTK012lux6bxHWsT++RpUKenVE+/zBFMTKD+SBBqoD1TWC9/gsl
         /qNA==
X-Gm-Message-State: APjAAAXGF2OU7NiuMD6H1m0rBoHppO2jo+Etckw7OGoMVWZ+r768vrh8
        WYXPUpVCoLJ+i9QjR2V9FgrDn5kNIB9xZdhlMvI=
X-Google-Smtp-Source: APXvYqzaGiqL9mR+siJdXaeguo9sKcgdE+1cLSBWlV5e6WWf4IOPJp7Tv6iHi5jRykzIzNd2fEPK3FxER8iyVBqGkxQ=
X-Received: by 2002:a17:902:e00a:: with SMTP id ca10mr3094261plb.18.1557161636228;
 Mon, 06 May 2019 09:53:56 -0700 (PDT)
MIME-Version: 1.0
References: <1557155792-2703-1-git-send-email-kernel@probst.it>
In-Reply-To: <1557155792-2703-1-git-send-email-kernel@probst.it>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 6 May 2019 11:53:44 -0500
Message-ID: <CAH2r5mtdpOvcE25P2UuNFpOwsNyFiBWRQELQFui+FJGVOOBV8w@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix strcat buffer overflow in smb21_set_oplock_level()
To:     Christoph Probst <kernel@probst.it>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I think strcpy is clearer - but I don't think it can overflow since if
R, W or W were written to "message" then cinode->oplock would be
non-zero so we would never strcap "None"

On Mon, May 6, 2019 at 10:26 AM Christoph Probst <kernel@probst.it> wrote:
>
> Change strcat to strcpy in the "None" case as it is never valid to append
> "None" to any other message. It may also overflow char message[5], in a
> race condition on cinode if cinode->oplock is unset by another thread
> after "RHW" or "RH" had been written to message.
>
> Signed-off-by: Christoph Probst <kernel@probst.it>
> ---
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c36ff0d..5fd5567 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2936,7 +2936,7 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
>                 strcat(message, "W");
>         }
>         if (!cinode->oplock)
> -               strcat(message, "None");
> +               strcpy(message, "None");
>         cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
>                  &cinode->vfs_inode);
>  }
> --
> 2.1.4
>


-- 
Thanks,

Steve
