Return-Path: <SRS0=SAbX=A2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1E9C433E4
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jul 2020 04:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05DEE206F5
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jul 2020 04:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOX6dxv5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGOETR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Jul 2020 00:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgGOETR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Jul 2020 00:19:17 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D04C061755;
        Tue, 14 Jul 2020 21:19:16 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x9so511032ybd.4;
        Tue, 14 Jul 2020 21:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n7GY+WJuUal6vZC2qyTKGq0rmN3PIL2kDK1bpGspZE0=;
        b=KOX6dxv50PeEz3NBTMxawpG8CoBeTrEHVlITwgBKI3UTMRJ8c75Q6boiJzj9k4Susm
         wNqYZ66jq52MHGD9rifNgImnw3xGQn/nis+awUIqZ81o2L6vW00sWSoVbGmMrxsfX3NS
         /hBu8s1l6dZD/Y4K0b4WtYr80grhepO+nTZHMGyvCfKwIOVqLa8JU821PVw0Js6pv5Hu
         55Wj64k9JPuD3E3qvP1ZTrUadB7iT+Y0WcXCHYjBnJgFargui2RkQ9KUoIsHv35mNTXV
         +YQwHyj17w4MsUasUmbdCmb3mEJlwc4F5Uq7vJ0mpsx0jOcT1xZZcgXlQdh8+DMVWxV7
         HOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n7GY+WJuUal6vZC2qyTKGq0rmN3PIL2kDK1bpGspZE0=;
        b=YVU9ujWzSVo8NhxBC5d8GcVDK76pZ2JP9fJM4dmxUuekuhJ6N1DxfJ9zKG7y7vCEH9
         uomSkr5O8rf72AWlzzSeMBdTIIxz/iVvRrDUbkJSsWSfkzYFh7dMt/yf0ou5P9iVWUgA
         6/IpJt9eci7XUF8RTcKSLbvEIeD8+OliCIPpYJdopv53pv5wzQMruDmOiiZapB27dOWk
         LUgbEEWpBoM333fXbtghm1Ex8gF404zQHpEjCEAw131UIZ0kD3cMLdyMXrdUTi/WMejU
         kDkIHQY87gd1fUrvh9WK4Pmdi2akBbK6FKkEFvv4gCb3m7yWdKduH2KjimierXejCGnZ
         cz0w==
X-Gm-Message-State: AOAM531/Zk2aDD1ytB3vfEDRiq2MGkj9eW/DQIDII38mNK7UkIKW/tYu
        mnVUMbqT2JipE5MIfKP5/J1siJMnFRQKONmt/SFB6naE
X-Google-Smtp-Source: ABdhPJzxOEManeM1VS4Ej7+mHpB4DMdkSQHnSTzwu69n9tgGLjbMLG2LU44grBL/dzIbmNNcNI9vP+KqcTTTYenwGj0=
X-Received: by 2002:a25:880e:: with SMTP id c14mr14101146ybl.376.1594786756160;
 Tue, 14 Jul 2020 21:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <1594724352-11451-1-git-send-email-wang.yi59@zte.com.cn>
In-Reply-To: <1594724352-11451-1-git-send-email-wang.yi59@zte.com.cn>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 14 Jul 2020 23:19:05 -0500
Message-ID: <CAH2r5mvm=PWV4cVKznJEB1FQW3jRMXBFF1vXv=-Jy8PQLRCgdQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Remove the superfluous break
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, xue.zhihong@zte.com.cn,
        wang.liang82@zte.com.cn, Liao Pingfang <liao.pingfang@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

thx

On Tue, Jul 14, 2020 at 6:14 AM Yi Wang <wang.yi59@zte.com.cn> wrote:
>
> From: Liao Pingfang <liao.pingfang@zte.com.cn>
>
> Remove the superfuous break, as there is a 'return' before it.
>
> Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> ---
>  fs/cifs/sess.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 5d05bd2..6708ab0 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -1705,7 +1705,6 @@ static int select_sec(struct cifs_ses *ses, struct sess_data *sess_data)
>  #else
>                 cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
>                 return -ENOSYS;
> -               break;
>  #endif /* CONFIG_CIFS_UPCALL */
>         case RawNTLMSSP:
>                 sess_data->func = sess_auth_rawntlmssp_negotiate;
> --
> 2.9.5
>


-- 
Thanks,

Steve
