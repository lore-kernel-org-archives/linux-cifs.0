Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AEBC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  8 Jan 2022 02:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbiAHCKG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jan 2022 21:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiAHCKF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jan 2022 21:10:05 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3817AC061574
        for <linux-cifs@vger.kernel.org>; Fri,  7 Jan 2022 18:10:05 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id x7so21850366lfu.8
        for <linux-cifs@vger.kernel.org>; Fri, 07 Jan 2022 18:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aTjZj9A3M7Ms6z996wnI82j8QAfXojpF/Y/uYiU3xZ8=;
        b=SmEUFu75CW4sXcro//mLm53sjVdPIxVO4hXnjInARG+tNZWSOhIVwk07JeClQfTmbm
         ZrVoHsFpFx1jS2xnatBj0XHw82xRW7rLVSVG0AQDStvsMGASXUwPgUaLcVxXbZ94WK54
         yEKidbNRCbenOnb1BRMZXRnPHq6d1rcdgSeEuy4wq0qqypsANEXj9xC4AY44yBKa44h+
         fPcbYKVyXSu99vW+eZEgGCsmnltQonOtzSrUBSIt4HA7INjguRPZEBamgwMLg5cwuViu
         1nKtKk8cb2E2n2AL+09kdisMnhH4CICr4gvch6pyAJHQdvVPiykID2TsK2UvcpnbFODN
         zG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aTjZj9A3M7Ms6z996wnI82j8QAfXojpF/Y/uYiU3xZ8=;
        b=bGtCLJC1fIWQj9/1YkVm/z1CGrjzxKxJl9nszI0CEmo3fG4p+md/SB25lvcXzcpRnK
         EkVe0+y2G/gNSGvntoBN3mKM9IvDVQU0Q0Z8AVcVmoZit/kuusCAnKMKQMJgJK3h/vwj
         J5+4JyjByHFidRMQfIx7Yx9qdtLHHXCykdO8BX3eZfhbFTJhQgeG/wn8yBQ8ZKcNUi8t
         6A2aAJalVBD8MDOdEFJfqRxOFhe944Z4QuMVATddsZp03lMYRtNaqEv/p+66SLbaKF3B
         loj1LoHHoZJftdKTaf57HrWQHcSB7seDt936eeVuQAw6X5DMdcx/NwF1SWDLczCsLZof
         pjFA==
X-Gm-Message-State: AOAM533T/bDz4jMS3jhOhsKIfqGUXrqJE5OUEihNFNTUp/NJogS5UnS3
        ZYBP7Kl6G5m52RSqhOQH8mbX40RHoaNNHTceNYw=
X-Google-Smtp-Source: ABdhPJyWnxYIZSsdEMhxms4PShB74oqj1iwydKAUARgmnvs4Qzx1cflaaDI3PYgMIgpqfJf8PSF7YK9i649vyfUf0YU=
X-Received: by 2002:ac2:529b:: with SMTP id q27mr59321208lfm.320.1641607803391;
 Fri, 07 Jan 2022 18:10:03 -0800 (PST)
MIME-Version: 1.0
References: <20220107225139.15323-1-ematsumiya@suse.de>
In-Reply-To: <20220107225139.15323-1-ematsumiya@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 7 Jan 2022 20:09:52 -0600
Message-ID: <CAH2r5mvi2-q3eDxmJVpckrYcKU0UniB56vt8xX4ZU67sLAYGxA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix hang on cifs_get_next_mid()
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

On Fri, Jan 7, 2022 at 4:51 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> Mount will hang if using SMB1 and DFS.
>
> This is because every call to get_next_mid() will, unconditionally,
> mark tcpStatus to CifsNeedReconnect before even establishing the
> initial connect, because "reconnect" variable was not initialized.
>
> Initializing "reconnect" to false fix this issue.
>
> Fixes: 220c5bc25d87 ("cifs: take cifs_tcp_ses_lock for status checks")
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/smb1ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 54319a789c92..6364c09296e8 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -163,7 +163,7 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
>  {
>         __u64 mid = 0;
>         __u16 last_mid, cur_mid;
> -       bool collision, reconnect;
> +       bool collision, reconnect = false;
>
>         spin_lock(&GlobalMid_Lock);
>
> --
> 2.34.1
>


-- 
Thanks,

Steve
