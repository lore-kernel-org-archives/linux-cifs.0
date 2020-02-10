Return-Path: <SRS0=6quT=36=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1155CC352A3
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Feb 2020 15:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9047206ED
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Feb 2020 15:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CdMRmPdL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgBJPNJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Feb 2020 10:13:09 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38713 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728485AbgBJPNJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Feb 2020 10:13:09 -0500
Received: by mail-io1-f67.google.com with SMTP id s24so7946615iog.5
        for <linux-cifs@vger.kernel.org>; Mon, 10 Feb 2020 07:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0cpn2liSfspYbAQzNgUpJ68GhurUQPPR7nFjQAAUAcQ=;
        b=CdMRmPdLCY1UOIHOIiiMJzlMCSrMDtEmwtKkVP1zg09WP+h/p4ffmoZnRw73WHmLcW
         z7aRSi8m5ox5rE6TSVvAGrV2UlHmPnWT/t+7KPuZkp4a5c3wp8iCDnHLg2z35GbKF3+J
         0PZlO77iFTlMiQaEhiHN2NxJZkGADftTfjfww0htYoaT1RtgPxeMtN4C5eYXm719kXbR
         T00yrs23JXAcwFGbG1WsqkUw37NBvl171g97sqAQgW+RRso9/wxu+4o/6gFAkhDjEFmu
         4oXTBpg5VG+ugP06M+q9hvmxMJup8+BAxs6gum2woxo4k1AMzXsylpdhKw5J7eVGxPQu
         2YeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0cpn2liSfspYbAQzNgUpJ68GhurUQPPR7nFjQAAUAcQ=;
        b=LwD2Xd3X9uAC7Zc67juS4G6xTitzxpMRPC23zM3rbfp6SJk6CGmv74heUJCEC67OJD
         XGoCtwpchPD+rIiwlU7j8Mcd3NVFqbcKSQyhh/VKk5Hzq3Lz+pTjWyvZGvlbYx61nwu+
         LroCcLsxB49N7EZJogu58TmVXFBIeGLW/ZDPCTL7vAtMdJBsCw/TUxu4X9y/DtC9tcde
         vUmW26mXgMFgmF18AK/LEErnN02uQ6+3rDDtTx2IHV/bDDsIlTyAzlrBvV/D12P1jnQi
         YIwinNujf81pt4pepG7q/67Yd+OzBtqWu55LMT/EoOzyfB1gQmCqijr0+KhxcHbwihhm
         gdyw==
X-Gm-Message-State: APjAAAVvUDwY0g5wXr0mCQaX9skt5+gAJYwh6VHlbNatqwtfEheGqRTw
        +/Od0yJl9j+EkGEkY3N++a/16C4wScistPm+jJI=
X-Google-Smtp-Source: APXvYqxjD3oF6tx7DJaPn9dfGtxue0FHFd3OuuTnkU5OFDAGNu4Wijti8WO5NXllF8Mkz7mMpO3WZwlyl+v2WrfBs3w=
X-Received: by 2002:a02:cd12:: with SMTP id g18mr10498977jaq.76.1581347588562;
 Mon, 10 Feb 2020 07:13:08 -0800 (PST)
MIME-Version: 1.0
References: <20200210093814.24198-1-petr.pavlu@suse.com>
In-Reply-To: <20200210093814.24198-1-petr.pavlu@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 10 Feb 2020 09:12:57 -0600
Message-ID: <CAH2r5ms9mOFk3SwLaoXZtk7eyNL3PWZECEyz0+mzGBGzYJaURw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix mount option display for sec=krb5i
To:     Petr Pavlu <petr.pavlu@suse.com>
Cc:     Steve French <stfrench@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Feb 10, 2020 at 3:40 AM Petr Pavlu <petr.pavlu@suse.com> wrote:
>
> Fix display for sec=krb5i which was wrongly interleaved by cruid,
> resulting in string "sec=krb5,cruid=<...>i" instead of
> "sec=krb5i,cruid=<...>".
>
> Fixes: 96281b9e46eb ("smb3: for kerberos mounts display the credential uid used")
> Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
> ---
>  fs/cifs/cifsfs.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 5492b9860baa..92b9c8221f07 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -414,7 +414,7 @@ cifs_show_security(struct seq_file *s, struct cifs_ses *ses)
>                 seq_puts(s, "ntlm");
>                 break;
>         case Kerberos:
> -               seq_printf(s, "krb5,cruid=%u", from_kuid_munged(&init_user_ns,ses->cred_uid));
> +               seq_puts(s, "krb5");
>                 break;
>         case RawNTLMSSP:
>                 seq_puts(s, "ntlmssp");
> @@ -427,6 +427,10 @@ cifs_show_security(struct seq_file *s, struct cifs_ses *ses)
>
>         if (ses->sign)
>                 seq_puts(s, "i");
> +
> +       if (ses->sectype == Kerberos)
> +               seq_printf(s, ",cruid=%u",
> +                          from_kuid_munged(&init_user_ns, ses->cred_uid));
>  }
>
>  static void
> --
> 2.16.4
>


-- 
Thanks,

Steve
