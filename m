Return-Path: <SRS0=wCsU=WX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D54C3A59F
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Aug 2019 02:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B3C52080C
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Aug 2019 02:14:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rgphM301"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbfH0COX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Aug 2019 22:14:23 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40868 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfH0COX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Aug 2019 22:14:23 -0400
Received: by mail-io1-f65.google.com with SMTP id t6so42539665ios.7
        for <linux-cifs@vger.kernel.org>; Mon, 26 Aug 2019 19:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q9SgN6ef87LmaFpwzU4zroE5UTEKIoevkIa7RfFZlCI=;
        b=rgphM301p4K4ULAf1Lve9o0BolqN8rivk9y4aVl3aYAgW7h8PtzI6wua/O1vLE9/HV
         uoTwcUXEPLJqMHt/+nwnzr9d2kZRKF2rjaqJhzXtPEEAQvAzkIs7OlFX34iMMQwfZDIP
         v2/Fc3p81tPgW97M8L0BHKXkx1rKymZrMJusCdxs2LLLPdbtAf53jh6oQLLtNY/FzvoM
         6xVE5KT+GFcCUs0m9bmttGzUT3YQb0+38G/IHARiYyhGsjafwFdJhiR11QxVHXNRKAxM
         kBXuS2/prWN8KawyEyB1Cgn4U07+rJmDVUQN60GHHlKOWwEzdlZ6H/HBVZ7M9Lf0dzNE
         Y7IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q9SgN6ef87LmaFpwzU4zroE5UTEKIoevkIa7RfFZlCI=;
        b=pFWocj+FuBmnSTJv6lLAm7QiJwGwLfLAGB/MFmTuVejrqqwpiqx4o5R3/MNqGF+yrj
         R0fVfhaNJDCZsJ/Jj9BsswAwVO8KW8c4OeFfl6bbSJzfPaLIGJxJCVmt63gw/c5swQmQ
         aPSB2neFeWdef6g1S1n9LBR8fc0BujxS/jp914RKREVpJFlw/yfwLehKiGiTP2AN3wmh
         6ajrQ+bPqSjLY+BUgicwKjF3ZveoFbEFVDGEny5A3jcCcDu6zYk1xfuBzrXzyuJ2b+M+
         AsXkaVxiWhKyKJBoMaSmCLL65FlQik3bsqZu0pu/SUXbJkWQ88F37MKZ4fQjHDz59GOq
         tcQQ==
X-Gm-Message-State: APjAAAUbAIvPF1cNQ9xxacqlR1kMeYubtt+B36Ckiai0/BA+vr7eZq3K
        fJqmCK8/A4jxgKZC8yguw/De7TykZ6rQ5Imn5M0=
X-Google-Smtp-Source: APXvYqw8oEZL1PvP4KdREwWDzOLUujGGq/qEh/WAoBgmRISCFFHT5s+C2fhzVYz/pqRV2pudzHX7EsjUxMA7yF8Yxn0=
X-Received: by 2002:a02:a492:: with SMTP id d18mr21696369jam.27.1566872061957;
 Mon, 26 Aug 2019 19:14:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190827013558.18281-1-lsahlber@redhat.com> <20190827013558.18281-2-lsahlber@redhat.com>
In-Reply-To: <20190827013558.18281-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 26 Aug 2019 21:14:10 -0500
Message-ID: <CAH2r5mvSjf1vXnoan1vasH=CoOLjQ7se-M5_HaULC=rZSFWFvA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: fix incorrect error return in build_unc_path_to_root
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Do you have a simple repro for this one that would lead us to want to cc:stable

On Mon, Aug 26, 2019 at 8:36 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 1ed449f4a8ec..c5dc8265b671 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -4232,7 +4232,7 @@ build_unc_path_to_root(const struct smb_vol *vol,
>         unsigned int unc_len = strnlen(vol->UNC, MAX_TREE_SIZE + 1);
>
>         if (unc_len > MAX_TREE_SIZE)
> -               return -EINVAL;
> +               return ERR_PTR(-EINVAL);
>
>         full_path = kmalloc(unc_len + pplen + 1, GFP_KERNEL);
>         if (full_path == NULL)
> --
> 2.13.6
>


-- 
Thanks,

Steve
