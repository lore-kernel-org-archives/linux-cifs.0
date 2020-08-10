Return-Path: <SRS0=3GXq=BU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FCB8C433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Aug 2020 17:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52A8220885
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Aug 2020 17:08:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D4odPv7P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgHJRI2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Aug 2020 13:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgHJRI2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Aug 2020 13:08:28 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D070C061756;
        Mon, 10 Aug 2020 10:08:28 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id g19so9691239ioh.8;
        Mon, 10 Aug 2020 10:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EV/Inn1yIq80k4xTWqNtB11Yxfxj2hvMoKBR9JcOwIo=;
        b=D4odPv7PmDBTv8Fr4bfErHYxqALMVwFsfFMmqsp82assrut3e69ZNXKmR+KDkxZRWG
         YHKA9IhaMldTiRLhsg500chNRM/ou501nJfjU3npvH1nZRX3900zmodkNGZi3mN8tIoC
         HG16jK4Jnd2ViNjtQv+rUQGWNzryHDcq8vAjZlzkA/BsTBqYxrVOPg6fwdiMCiUvEEre
         Oe23p+rdRhbdZd1C1OouJkp9juFnW93XUHKeSWiIVWd3wShY2JzsDi5U6LMui2hesChO
         FdLfAuwk/X5i0ZDdCJEU6MnAh5Emt7tb8nDx2Ia3X5f0BIpeXi+UQ5A/NvmrXqPKBFmF
         /5Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EV/Inn1yIq80k4xTWqNtB11Yxfxj2hvMoKBR9JcOwIo=;
        b=RjV6xbUPCA8Y0sOFoSobXIzpE2fpS1s5OuqNvyER7BmLjUj6EB+Hqr5CXCCrU2BXWl
         KH3Wb6yb0XxHZuLE69mcgPB726SRP6AS1Jgwl9SuVUShONp9aGhSBzw1j07NPcd7gBsw
         4gHirGSOWwHpGaRcGuSWIswQnUEGu3z49Dl/kVv1PDpsYTyjaGS8IsQ7ROJHEqw7jxMZ
         pFA8ZnZkP000424P+64GQ15dUEn5oXhOpg82wx0tI/qGnFmX+NfVjhjrre7jB7XBD2Uv
         9Xov+7d9y5NU4FCb4hrzhPaxxIRgGKap0m2I5xxHEYTX6c1GkvRVdQYAttfaRNb1ajI7
         XVcg==
X-Gm-Message-State: AOAM531YmzisXUL1fufAltKF67um1nMpv7wg0sGMqckP084dZD10v+RQ
        f7+j/vKKAkBtMSUUl6icy7gPNqQXECSaLU2Cv70=
X-Google-Smtp-Source: ABdhPJzz4KKqCWD8DewPuuMqNyLgFicLPDFscAPkzIrLXWdzhAtY0bnr7EccVxuIqigNWXrcGkoPoLjwlE3xYY1EmEg=
X-Received: by 2002:a05:6638:2604:: with SMTP id m4mr21271201jat.76.1597079306859;
 Mon, 10 Aug 2020 10:08:26 -0700 (PDT)
MIME-Version: 1.0
References: <1596875797-22710-1-git-send-email-linmiaohe@huawei.com>
In-Reply-To: <1596875797-22710-1-git-send-email-linmiaohe@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 10 Aug 2020 12:08:15 -0500
Message-ID: <CAH2r5mstN6P_kU_Riobdv5NJPL-pF6=oZoAh6k9qj1+nz9Z8Cw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Convert to use the fallthrough macro
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

(but note that most places in fs directory other than cifs and btrfs
have not been updated), and I noticed another 8 places in fs/cifs that
you didn't change in your patch (ie change from the older way of
indicating fallthrough   /* Fallthrough */ as a comment to the newer
fallthrough macro.

On Sat, Aug 8, 2020 at 3:34 AM linmiaohe <linmiaohe@huawei.com> wrote:
>
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> Convert the uses of fallthrough comments to fallthrough macro.
>
> Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  fs/cifs/smb2pdu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 24c2ac360591..667d70aa335f 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3913,7 +3913,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
>         case MID_RESPONSE_MALFORMED:
>                 credits.value = le16_to_cpu(shdr->CreditRequest);
>                 credits.instance = server->reconnect_instance;
> -               /* fall through */
> +               fallthrough;
>         default:
>                 rdata->result = -EIO;
>         }
> @@ -4146,7 +4146,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
>         case MID_RESPONSE_MALFORMED:
>                 credits.value = le16_to_cpu(rsp->sync_hdr.CreditRequest);
>                 credits.instance = server->reconnect_instance;
> -               /* fall through */
> +               fallthrough;
>         default:
>                 wdata->result = -EIO;
>                 break;
> --
> 2.19.1
>


-- 
Thanks,

Steve
