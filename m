Return-Path: <SRS0=8LXX=Y5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C7BC5DF60
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 23:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94B84206BA
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Nov 2019 23:00:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BTke/Ek/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbfKEXAP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Nov 2019 18:00:15 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:35500 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729895AbfKEXAP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Nov 2019 18:00:15 -0500
Received: by mail-io1-f68.google.com with SMTP id x21so9042313iol.2;
        Tue, 05 Nov 2019 15:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yoWC56++M3uoXU+oelt/CMWG4cbTRPSJURz59kUPoBM=;
        b=BTke/Ek/zLnhDSfeNuipm+/POYtDfp0HKri7zNJmRTzwXXipSLLmLhnkoOckfDN6nO
         8TTiEw3HGDSUKqcTm45ypk1+kJ8UuNAJX/CezHPd7OJw93mc4BKm+wbFEYtIOZQgmTBH
         o2KpPpA2rdVqMWMM4+5O9T7/VLFM0ymlptrGwB5vSex6Q1XQVMxopHPH9fmmxHtRFihV
         OuQ/lYpc9OnqT3W3PEIX+ghL8KKLxw1l4gOJDqSEwJUIAkF+S12VaEckCDZm/bptd4ns
         0UqHhFK7k8EXe1UQazdsR1SIQts/AurUGvu+lWlSNzbqiDCwmynlZ2mkx+fuTU7bKeQQ
         btaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yoWC56++M3uoXU+oelt/CMWG4cbTRPSJURz59kUPoBM=;
        b=MT0Q7r63AX5ct5PefG82Ar6fgIiN/wNkQz370crssUU8+V2bYIlw54AuT3wa5f4ku4
         u2PYSIMCoGXMOsyS2oGWo/KJfGlMaADWn8HWjHwrnFUneIk1Kj8jfl/USKnzIfKlyzjI
         PetmHXWQ6MhtqX796dL6ORJPtIkbduaUThEzEsAfD9tKd7VMGBgIv6VInoogUzWhzdLU
         /DgzTxAdgnPVKkkuETt+gqHLzC/bXI1t8xcbqg8cfXy6g7QXKQsBxuC4J5Y7TVPEnjiZ
         n1uSQtxhtqDx4RrsMZhpcMbxYrSZm4pa386th1kq8JznJYLZ7bZr2bTDKPQijnKaytwb
         TfSQ==
X-Gm-Message-State: APjAAAWXDmCIgpW/3GFodjjk7fJicqAOwNpKE18VvjFCAZT6WH2NZ9dM
        0xt4X7tXN6RF71yBKaeaRCvFYEdhxB1i9Tp9mrA=
X-Google-Smtp-Source: APXvYqzZ6TB+/QC8CW+9Q+EgSJexTwDdd/GYLyU/P7veuUPS+oIhgF0WwBMlhoBMAUS8bZWv6xwB5kIhrqIFrG+wCBI=
X-Received: by 2002:a5d:848c:: with SMTP id t12mr2960373iom.5.1572994814380;
 Tue, 05 Nov 2019 15:00:14 -0800 (PST)
MIME-Version: 1.0
References: <201911041524.o7kWSYSC%lkp@intel.com> <20191104075911.23rhzcbztbhlbjk5@4978f4969bb8>
In-Reply-To: <20191104075911.23rhzcbztbhlbjk5@4978f4969bb8>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Nov 2019 17:00:03 -0600
Message-ID: <CAH2r5mv43iPuAgvM699A5TstZGzHj=WOsYd8ffmk1DSUsQXdrA@mail.gmail.com>
Subject: Re: [RFC PATCH cifs] cifs: smb3_crypto_shash_allocate can be static
To:     kbuild test robot <lkp@intel.com>
Cc:     Aurelien Aptel <aaptel@suse.com>, kbuild-all@lists.01.org,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Steve French <stfrench@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

FYI - I updated cifs-2.6.for-next with the equivalent change (fixing a
line change to one of Aurelien's patches in the multichannel series)

On Mon, Nov 4, 2019 at 1:59 AM kbuild test robot <lkp@intel.com> wrote:
>
>
> Fixes: 4d1cc0309f7e ("cifs: try opening channels after mounting")
> Signed-off-by: kbuild test robot <lkp@intel.com>
> ---
>  smb2transport.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 1af789871ec2e..86501239cef55 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -48,7 +48,7 @@ smb2_crypto_shash_allocate(struct TCP_Server_Info *server)
>                                &server->secmech.sdeschmacsha256);
>  }
>
> -int
> +static int
>  smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
>  {
>         struct cifs_secmech *p = &server->secmech;



-- 
Thanks,

Steve
