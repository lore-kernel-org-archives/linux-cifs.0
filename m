Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A326EB64D7
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 05:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjFZFRy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jun 2023 01:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjFZFRx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jun 2023 01:17:53 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44577113
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 22:17:52 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2b5c231c23aso20603241fa.0
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 22:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687756670; x=1690348670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jEKmh3Bfvkb0mL5gv+kOl4X3aGZbk8QZOaGqxGplPuY=;
        b=K/jTuuvue3IumvjxJMnVj+uOsmdtTUJ6eCleHRw90YzMjeBS+59p44v2UOZN49EKzX
         YTW1qCOtrIlRzEsfxzuWpaOSbi+kL654EZWeEGy/FMysmKhNTkvgP7xIkTviOF/VCyiD
         iFHLD1SOJJ90uICyCz2pmQs7ifAVZGt5F9ceILQ0T/YRmpWcYFdbaxbSCD3Fyp2AgU1A
         u6tTg8nmXwcQNfkS3k/UZ0ZANTuRHukaHX9SsI03JODUUu4vqCI4c3400/K2xGgeZQwn
         ENtyHlsv8klcG/gOMa3eD/1sSTi8OavlJymwiZ4uFEGXrrDN6LYdQXNb3yqQHaNBM49l
         wAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687756670; x=1690348670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jEKmh3Bfvkb0mL5gv+kOl4X3aGZbk8QZOaGqxGplPuY=;
        b=Foxgq5vt5BBvyGfcCP1G5XOyp45fY2MOBPN/wWpixxkLEW5OinvWocWPG1rukH09d1
         gaYT9/c8cTD25VQDcNQFpzbXOuorH7IQTcU7lXfbTWYj91t9i1FdmNE1XJn56LjmCxhh
         w2w1vQgBu6QE+W1UqeBOzCbGtQATzvf9opAVGZVpcSZWUo8eyGC/jgMy7nijCRkcYiiK
         T0GTt7m3wfLplpFRKZMEVfgSq0HHufs1VQDU2ghdLrNc/WlBxR9MwK8/4MxQzG0bnl3B
         M9/rEeUSTDCdxXZG/IluX5Q5RIAkBFNRX1v7w4yg1AH0fm5uwBG6ikddYENYtCNRVBXy
         jMuQ==
X-Gm-Message-State: AC+VfDzKY6SEptdMbmbeBlG+eKmXjv1ZsHlO9FM4KToO/X39VDKhqqMt
        PRIczazjPTGDyxYw0hv3R8oCEeTCRt+7aKb5rSQ=
X-Google-Smtp-Source: ACHHUZ60rXz9fVyPQ5xaYlYrKBeaQZQtXBP8GPLtdQ8yyokjxq9KA2Cvh8NMoqvalXabxpDg9bth2HuUM8uxcKKDKs8=
X-Received: by 2002:a19:f242:0:b0:4f3:b97c:2d91 with SMTP id
 d2-20020a19f242000000b004f3b97c2d91mr14609899lfk.66.1687756670212; Sun, 25
 Jun 2023 22:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230626034257.2078391-1-wentao@uniontech.com> <20230626034257.2078391-4-wentao@uniontech.com>
In-Reply-To: <20230626034257.2078391-4-wentao@uniontech.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 26 Jun 2023 10:47:38 +0530
Message-ID: <CANT5p=q_-yHy5Z0fcQ7KrRrJ4OLCJ8otqNfC1Ee0ZTUMMsw_gA@mail.gmail.com>
Subject: Re: [PATCH 3/3] cifs: fix session state check in smb2_find_smb_ses
To:     Winston Wen <wentao@uniontech.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.com,
        sprasad@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 26, 2023 at 9:24=E2=80=AFAM Winston Wen <wentao@uniontech.com> =
wrote:
>
> Chech the session state and skip it if it's exiting.
>
> Signed-off-by: Winston Wen <wentao@uniontech.com>
> ---
>  fs/smb/client/smb2transport.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index 790acf65a092..22954a9c7a6c 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -153,7 +153,14 @@ smb2_find_smb_ses_unlocked(struct TCP_Server_Info *s=
erver, __u64 ses_id)
>         list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
>                 if (ses->Suid !=3D ses_id)
>                         continue;
> +
> +               spin_lock(&ses->ses_lock);
> +               if (ses->ses_status =3D=3D SES_EXITING) {
> +                       spin_unlock(&ses->ses_lock);
> +                       continue;
> +               }
>                 ++ses->ses_count;
> +               spin_unlock(&ses->ses_lock);
>                 return ses;
>         }
>
> --
> 2.40.1
>

Thanks for the change.
Looks good to me.
CC stable for this one too.

--=20
Regards,
Shyam
