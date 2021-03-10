Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8A8C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 18:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BA4D64F78
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 18:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhCJSv5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Mar 2021 13:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbhCJSvh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Mar 2021 13:51:37 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688FDC061760
        for <linux-cifs@vger.kernel.org>; Wed, 10 Mar 2021 10:51:37 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id p15so26910818ljc.13
        for <linux-cifs@vger.kernel.org>; Wed, 10 Mar 2021 10:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vgtzwWXnNt/QbPt89eKeOf/9u4gmDMF92saT2vu8/o8=;
        b=rLqIuF//rB9YDgVo27IJ8KDqMsEwkBF2wkV0uJlQjgu5iycbVYiHm/4S4302vgvvhb
         i2n4IXrfXMneokVURrBdGYnpXiddiSvJ8D+oMFx9XqkZInmTlmxetLFbF7phcmOD73uK
         aZLDYg1J4sMzFiVwLoJmHnDWMs4yxi/sjfbT4HxrECoTCIRwtUUO8HsTkIQxtuJTPjsZ
         2x/jvworQid/yl+pEKn5LHGNAkNgDCPMkk5zHvdMovagoJtt2qdIU9nT+UyCc4AEkiKL
         GAL2gpDQ0zl/f6OC2fjw+XjQ7xQOIuSvrk6c1Oycymbt6n45feZImr8dKT1i0fVTKoKv
         vKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vgtzwWXnNt/QbPt89eKeOf/9u4gmDMF92saT2vu8/o8=;
        b=g79vFrJ/pJfZNnTzS2aFFnBPFUD6wpOO+c4bz+W0x/EX9rRBiQP3QJbbS+XQv1qCfL
         CZNdB98noXDOGg/VCSPVtpJah6bAnJd3aRlY9/L4XUlKYS9xg0fY7vcsytxnGwlOlbTK
         FwpkLn+zD91W/0I4OmPalEYo1IurxedZUNjFxRHrnF4R0zfhg+WJXopCG2U6iL+dx+9r
         355XIjUGXvZ9PBYuDbdAyBYvzd5//Vxw2GzClj6GikMwk6fBFzMtesrYptBidwXlTM57
         ZgpsbdYaIHMT52+0bhNVJAifW8UTHJwXd2nQt/L+Ml0MN0BIZUq07pBwekvXSHM/F8t5
         5RLg==
X-Gm-Message-State: AOAM533GFIIIMxmbLS55ZgrVY1KqsK4J6DyGA741xe7X0oBvANrxjs1L
        bWjtFfkGbxRRbqXXcHWdDGzVCvcv3h10qjHyrbFkh7tVx9A=
X-Google-Smtp-Source: ABdhPJwHnROQ9D4yrrzGy61h/vNOTYKHMw7OssQlctcFXSxbAgez+GRvrtXMNs3CO97k7o+8xOpANcHHQTJlGOxSfM8=
X-Received: by 2002:a2e:8503:: with SMTP id j3mr2619891lji.272.1615402295900;
 Wed, 10 Mar 2021 10:51:35 -0800 (PST)
MIME-Version: 1.0
References: <20210310122040.17515-1-vincent.whitchurch@axis.com>
In-Reply-To: <20210310122040.17515-1-vincent.whitchurch@axis.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Mar 2021 12:51:25 -0600
Message-ID: <CAH2r5mvkX7T=HLCJmL-T=5B3P7ipKMuzGJF6psoBLru-2fNfWw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix preauth hash corruption
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        kernel <kernel@axis.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cc: stable?

On Wed, Mar 10, 2021 at 6:21 AM Vincent Whitchurch
<vincent.whitchurch@axis.com> wrote:
>
> smb311_update_preauth_hash() uses the shash in server->secmech without
> appropriate locking, and this can lead to sessions corrupting each
> other's preauth hashes.
>
> The following script can easily trigger the problem:
>
>         #!/bin/sh -e
>
>         NMOUNTS=10
>         for i in $(seq $NMOUNTS);
>                 mkdir -p /tmp/mnt$i
>                 umount /tmp/mnt$i 2>/dev/null || :
>         done
>         while :; do
>                 for i in $(seq $NMOUNTS); do
>                         mount -t cifs //192.168.0.1/test /tmp/mnt$i -o ... &
>                 done
>                 wait
>                 for i in $(seq $NMOUNTS); do
>                         umount /tmp/mnt$i
>                 done
>         done
>
> Usually within seconds this leads to one or more of the mounts failing
> with the following errors, and a "Bad SMB2 signature for message" is
> seen in the server logs:
>
>  CIFS: VFS: \\192.168.0.1 failed to connect to IPC (rc=-13)
>  CIFS: VFS: cifs_mount failed w/return code = -13
>
> Fix it by holding the server mutex just like in the other places where
> the shashes are used.
>
> Fixes: 8bd68c6e47abff34e4 ("CIFS: implement v3.11 preauth integrity")
> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> ---
>  fs/cifs/transport.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index e90a1d1380b0..aa9c0f6bc263 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -1196,9 +1196,12 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
>         /*
>          * Compounding is never used during session establish.
>          */
> -       if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP))
> +       if ((ses->status == CifsNew) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
> +               mutex_lock(&server->srv_mutex);
>                 smb311_update_preauth_hash(ses, rqst[0].rq_iov,
>                                            rqst[0].rq_nvec);
> +               mutex_unlock(&server->srv_mutex);
> +       }
>
>         for (i = 0; i < num_rqst; i++) {
>                 rc = wait_for_response(server, midQ[i]);
> @@ -1266,7 +1269,9 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
>                         .iov_base = resp_iov[0].iov_base,
>                         .iov_len = resp_iov[0].iov_len
>                 };
> +               mutex_lock(&server->srv_mutex);
>                 smb311_update_preauth_hash(ses, &iov, 1);
> +               mutex_unlock(&server->srv_mutex);
>         }
>
>  out:
> --
> 2.28.0
>


-- 
Thanks,

Steve
