Return-Path: <SRS0=OUxG=UX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8293C4646B
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 23:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AC3120679
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 23:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="osTxWZKe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbfFXXxU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jun 2019 19:53:20 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:39391 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbfFXXxU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jun 2019 19:53:20 -0400
Received: by mail-pf1-f170.google.com with SMTP id j2so8401111pfe.6
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jun 2019 16:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yEZRKToCFP4b1ak9ElW2Y0dFmiZroNdqqOtT5XGBtH4=;
        b=osTxWZKef/2JQwHMTNGE5qn6DSng8C+VhOi8CtSpoHodnR9A62CdyLh/UCCofuMACy
         UqXmxgCXDnKRxdNxFejYKiKulD14osXhd6O3cnVr1lHQ/DvcBI1sh0IOAa3Tics3V9i+
         hQKDGhLgGCIPtqQnGeKSmuyYMDeHBjntCVg/jNUZGhTPX38zj09xM9ouZkTC5hk9gOqi
         o5E8cB0K9P1CzNIrci9OjCPQ6ab6pzRxt+MLM+LkYZ8HD6m+VlML1g1UlOAk0an03uvf
         pFNgeUY54sn08uvON3r/HShZfSKZ5tITKF1DwxtcLTcCF84s6M+vktXY9y6jQHid7Aqi
         Iyvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yEZRKToCFP4b1ak9ElW2Y0dFmiZroNdqqOtT5XGBtH4=;
        b=uZD7utpuM604FLuwECV9lGpqvDuZtA6wtWrBNMqGKBQ2gfSewVhFa7YPQj41vHyBqi
         HLHyatmx0GvAprsIze6HadeFAW4kmOx+4vaM7b8wAcKiwqyNMZakVUjKwwC1oFsN6UNo
         ztB80/gv/QWxHOHa5CC/+oG3ToL8+9PKs06t8Exo3q47yMp0IFdh/qbVypPTeSTwx8Qg
         oWvwAe291ogVFXTZlUBkYnWrT0mIdN3f1gHNVBRx7ti0x+e4F6Vkl8ZIw6TGP9SSTAZw
         eOcvcrIb3C66Zr1MKqIbH+Tg1LlsJeOqP6zjmC6kuLlM68Ci9xWb44lXbhQRJ5lk8DMk
         EY7A==
X-Gm-Message-State: APjAAAUY7Gm6aCmZkVF6F23xAdcXTncjXfd65xITJlgkG06vvnWTIi4f
        H11aAMQmJ6CZybcra2aRHkfKCnaHyiZRNzROdu8=
X-Google-Smtp-Source: APXvYqxImFP3gdJxeWenM25DmSnyiOFol/91Ciiez4EBDZNXLqcLABTYRZk/FtCZKbWe9ypNJnOk4mjBb7MtHxmDChk=
X-Received: by 2002:a63:8b4c:: with SMTP id j73mr25294794pge.11.1561420398965;
 Mon, 24 Jun 2019 16:53:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvobnG1wvyk-ymMKKUCRsAzn2ky8jA8YguFFaUjsVihGw@mail.gmail.com>
 <CAN05THSyPoune8RoZ27Az42Os+1chJWWrRwZn9KTmQ3iHJV2EA@mail.gmail.com>
In-Reply-To: <CAN05THSyPoune8RoZ27Az42Os+1chJWWrRwZn9KTmQ3iHJV2EA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 24 Jun 2019 18:53:07 -0500
Message-ID: <CAH2r5muCDjeCDJXNP2HOcw1UV7G+B9bNf9oP335Twt81RfD_cw@mail.gmail.com>
Subject: Re: Minor cleanup of compound_send_recv
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 24, 2019 at 4:41 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Tue, Jun 25, 2019 at 7:24 AM Steve French <smfrench@gmail.com> wrote:
> >
> > In Aurelien's earlier patch series I noticed a cleanup (converting
> > ses->server to a local variable server=ses->server) which made code
> > easier to read in this function.  This doesn't require compounding but
> > probably helps his
> >
>
> LGTM.
>
> Possibly initialize server where you declare it as we do that for
> *server almost everywhere else :
>
> + struct TCP_Server_Info *server = ses->server;

I didn't set it there because later in the function we check:

           if ((ses == NULL) || (ses->server == NULL))

so I need to make sure the assignment is after the null check
(even if the null check is superfluous it would trigger a static check
warning to initialize server before the null check)
-- 
Thanks,

Steve
