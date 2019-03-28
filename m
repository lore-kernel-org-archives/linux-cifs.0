Return-Path: <SRS0=iY7O=R7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3EAC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 05:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E5A52075E
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 05:11:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+qu48wq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbfC1FLL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Mar 2019 01:11:11 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37393 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfC1FLK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Mar 2019 01:11:10 -0400
Received: by mail-pl1-f194.google.com with SMTP id q6so4404903pll.4
        for <linux-cifs@vger.kernel.org>; Wed, 27 Mar 2019 22:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZUDPUPoWTciBNcqse9GhmgtFTO5TkMfrxB8j9f8IQts=;
        b=g+qu48wqAQtRyjwh4WHtF7yzg+qXlmvOuHnrJUP7wGS65vMK16AdymvcktL7hUwo9e
         kGfDipzN5nlnciAD62dVwtuYGK1cC/EbqUMrbM9+fnRTSYcidVL7CmazvIftzxBWf7YZ
         Bvl50CqYNUHMKwSflg2IRDAM34wypGB9UG1k4wOgckApw1dMakAatJj+GY/GXMaPtQgf
         YawZ9XUkKbR6b+SCoVBZrMVkYxw3wA6I/VeBNm6l11U6ypDl/jO3Ws0Wwyo+RQfAE4lN
         nEPNKFWN5kfEx6B7KuMrmvTmn9FyBR4ezDZmvv4vQtgZlEY/wmokoksllpaJk2AVyPYB
         1mvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZUDPUPoWTciBNcqse9GhmgtFTO5TkMfrxB8j9f8IQts=;
        b=lYNTw2RXCufbO4/U4/tNa+H13w/4YJKcck6tl0aVdgkYsw6SNHrxt75R5efr76ZcX4
         QcdHirGESSi7wqK3QcyeEYaYdwJRjRjxUFD2T/hly4TqWs1Peh9bJaF7LxUbnRbh4Ig6
         fAXv7Px3tS9SCZvYQUIbg5opl2Y6mDSr0kIGZrqwrT7uxyyvjqqbFLqNjVm9a9rsf/5D
         Ti9DrEAiU4+AbsAHcNUgTQMr1eY9/8COih4n3z5QCy4uH6eepYNuuYesver5uKDAL6jR
         kvEisyw+YRXPG1C3GzBJjzUeF/t/EUmKrIhqPyyB4NFXIHrm94g0/RnxNvCioazGwMpR
         DgKw==
X-Gm-Message-State: APjAAAVA4RBOsGQgAkyfJtF2ZyJkuC/oxl5yWsiLNPsFKsx+HtOfRKi8
        DevRILTcCxStpls7bftO6WvAeByh/yPAn5Qb5MA=
X-Google-Smtp-Source: APXvYqx3G7b9dDfcGxwbLkM5a01MJALp3ywDfN74bOAWkn/SggLVjPa1KUzD8OCcqQ0Yf69wSEmVXk/nUDRvwlM4LZU=
X-Received: by 2002:a17:902:31a4:: with SMTP id x33mr4883614plb.24.1553749869979;
 Wed, 27 Mar 2019 22:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190328012002.842-1-lsahlber@redhat.com>
In-Reply-To: <20190328012002.842-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 28 Mar 2019 00:10:57 -0500
Message-ID: <CAH2r5mvCC95ve_VFGoE+4ckujA8eXcSGFj6qs+jzpeZVrJ-Gpg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix kref underflow in close_shroot()
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Should this be CC:stable?

On Wed, Mar 27, 2019 at 8:21 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Fix a bug where we used to not initialize the cached fid structure at all
> in open_shroot() if the open was successful but we did not get a lease.
> This would leave the structure uninitialized and later when we close the handle
> we would in close_shroot() try to kref_put() an uninitialized refcount.
>
> Fix this by always initializing this structure if the open was successful
> but only do the extra get() if we got a lease.
> This extra get() is only used to hold the structure until we get a lease
> break from the server at which point we will kref_put() it during lease
> processing.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 1022a3771e14..7cfafac255aa 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -717,20 +717,18 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon, struct cifs_fid *pfid)
>         oparms.fid->mid = le64_to_cpu(o_rsp->sync_hdr.MessageId);
>  #endif /* CIFS_DEBUG2 */
>
> -       if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE)
> -               oplock = smb2_parse_lease_state(server, o_rsp,
> -                                               &oparms.fid->epoch,
> -                                               oparms.fid->lease_key);
> -       else
> -               goto oshr_exit;
> -
> -
>         memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
>         tcon->crfid.tcon = tcon;
>         tcon->crfid.is_valid = true;
>         kref_init(&tcon->crfid.refcount);
> -       kref_get(&tcon->crfid.refcount);
>
> +       if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE) {
> +               kref_get(&tcon->crfid.refcount);
> +               oplock = smb2_parse_lease_state(server, o_rsp,
> +                                               &oparms.fid->epoch,
> +                                               oparms.fid->lease_key);
> +       } else
> +               goto oshr_exit;
>
>         qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
>         if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
> --
> 2.13.6
>


-- 
Thanks,

Steve
