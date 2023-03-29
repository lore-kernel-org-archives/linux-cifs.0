Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C74BC77B60
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Mar 2023 20:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjC2U2A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Mar 2023 16:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjC2U17 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Mar 2023 16:27:59 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4775C10C7
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:27:58 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r11so68253873edd.5
        for <linux-cifs@vger.kernel.org>; Wed, 29 Mar 2023 13:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680121676;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c51vyg3Udnps6hM+1ubVV5iPGxubsQIIjHhmJ2U7nrU=;
        b=Sg7FNAych3WUCCUC9YOFddCxVzFhLbbIPldbuz/CGdpXDgcVQfEiBZTBeE7IcHMcnb
         IsprcLDqAvrHaQGlYLCHPBSiPtK8iyH9mTAQh9BCW7Jq1WkO744zIrMlrY6aonYvDkuB
         pS+uxgA6Ob0frS64iWeo1S3KLOAaxh09fFhDzlRB7Dm4inPabBMGUvc4Cu6ZZzXbSxEi
         u7aeWsQu8KAYOUM6OqOeg61MLNNjPtiwPMd5b41bc1qc2l9TWGrTz6wwd/igyXIWU3zb
         jlHPEJT4zwWGOPa3WsAYnjl3VX0O7UTqkXHQONs6oW7YB/mqNc2u4DW3zMgkID1phVku
         Npdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680121676;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c51vyg3Udnps6hM+1ubVV5iPGxubsQIIjHhmJ2U7nrU=;
        b=eflcP3ZxKhQ2nrZ8wrBvhkfsPtWO1Q0xSY0Zde8l6KNxTUMEVhXkvnGyhChzqFPF/G
         VP90tr+nsBRzO3tmJuLsy7LV8adosOL9vK6Rn1IQzXhCDssrNug4hOu/KRM5khLnBxIC
         xGmgj9ZJ3fOOKrjdvhQCwlRyWECi/JtXNZWVxjnpOhFlVaQ8KYryXruO+z2XH1fe6CTf
         lBV7KeCAtNUu3ss+WL1sKlcrBLcZ1MQ9nITVWWRTEG4bGoIrmSMauPOaO2337KfBIrw4
         4RAVab88Hr5a0iLPuUSn6o1OYePnlyKgvYhHpc+18dwknfD3HENZssc21OvuS49u7kXB
         UhYQ==
X-Gm-Message-State: AAQBX9cn5YuuK0IBF+9fc/oDiuz3zSetLZo7nAXU25KUL3vv7zhuqajK
        bGZ8/r/t9bsG0u+Np3W6wAxMOIAQ6lw602nVoP4=
X-Google-Smtp-Source: AKy350ZYlzByB4cI2ptf2ch8odksXzoJQCnu0l9lCrSHxGfIq8ZzItqKrAJIC2P/NYAT4Pv0H415LXpVzwKPela2kcM=
X-Received: by 2002:a17:907:d687:b0:93d:a14f:c9b4 with SMTP id
 wf7-20020a170907d68700b0093da14fc9b4mr10467071ejc.2.1680121676647; Wed, 29
 Mar 2023 13:27:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230329201423.32134-1-pc@manguebit.com> <20230329201423.32134-4-pc@manguebit.com>
In-Reply-To: <20230329201423.32134-4-pc@manguebit.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 30 Mar 2023 06:27:44 +1000
Message-ID: <CAN05THS+FzhH=R-BgXPyx5-wVuBJdKMH_Vkwyo3_+82R9hqaPA@mail.gmail.com>
Subject: Re: [PATCH 4/5] cifs: prevent infinite recursion in CIFSGetDFSRefer()
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed-by me

On Thu, 30 Mar 2023 at 06:20, Paulo Alcantara <pc@manguebit.com> wrote:
>
> We can't call smb_init() in CIFSGetDFSRefer() as cifs_reconnect_tcon()
> may end up calling CIFSGetDFSRefer() again to get new DFS referrals
> and thus causing an infinite recursion.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/cifs/cifssmb.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index c9d57ba84be4..0d30b17494e4 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -4382,8 +4382,13 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
>                 return -ENODEV;
>
>  getDFSRetry:
> -       rc = smb_init(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc, (void **) &pSMB,
> -                     (void **) &pSMBr);
> +       /*
> +        * Use smb_init_no_reconnect() instead of smb_init() as
> +        * CIFSGetDFSRefer() may be called from cifs_reconnect_tcon() and thus
> +        * causing an infinite recursion.
> +        */
> +       rc = smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc,
> +                                  (void **)&pSMB, (void **)&pSMBr);
>         if (rc)
>                 return rc;
>
> --
> 2.40.0
>
