Return-Path: <SRS0=RdgD=7Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FAFC433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jun 2020 17:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7419020836
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jun 2020 17:14:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rsj8TZ8I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgFLROO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Jun 2020 13:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbgFLROE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Jun 2020 13:14:04 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D359C03E96F
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2020 10:14:03 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id q19so10812609eja.7
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2020 10:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rzi+oK9tqZUrHm5HWWJ5CBfZszXOWwhM5Ile1Uslw8c=;
        b=Rsj8TZ8I+T5idqZNfgYIR7CSn8EfVuQqkk9AZmiWPUsNAqEiEWAeLtGngt00IPw7Xc
         HI0z10cUlX5Ayk+DAYIpkoKevi//o6Vp3CbnWh9eP6sYzG51NaCSPtsTMAEe63Uomwh8
         3qGd6z76NUtoIwwVwNX9JA+obERfETwe9PFJkuscAQWFcfWgC7865oX8bjWRCq/8gnVv
         Q0qLkXwg/dBG1HCahya7+8Q8Ve8gdIS9YzQU3XxJ5uIlO7fUG2yBCmqtLbQdJ8pm0U8x
         4briet02NZxFa6ZtwpUi3QnqnJAI8NlJkxAasXS+OGwL8qJKLKIit6SPYdL7ADiMtE4+
         9pqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rzi+oK9tqZUrHm5HWWJ5CBfZszXOWwhM5Ile1Uslw8c=;
        b=ax9f30x6311jCJWQXxzxXdtIrLHqyeRw5mv2sURWr2r96cHymsnySitXuX74mAJeLW
         +5oMc8x16GxAplXx40vAK8iHuNDAiO9isPsznJVvr1z/urAtMhEahwWupEwGC82UU4ro
         rRkowPaS+9PP2NTj1lfPJWjL2+lw9nm7a4yuWCNTY98FIYR8Et8TMPTYHxnY1bI+QN5V
         oOvA4rMuCJN/RIc1IHqZCXTzeb6iHZAmCE2jvT42pVXYpE1/MXiYbkyy8Up0sM+P6kR0
         ZlzL5+Z7KVgNISnOXNkglrmewIXY5JxIqELObKiNF2TboNofr9a3PUMuNuEL/3PyjLap
         Ij4g==
X-Gm-Message-State: AOAM531YYv67I2gPvjCODVaTTjIfA2VeU2vX3OLIZ6vEE6XXIst7541v
        JhCgGu7C6EUCrphIHU1MiwMsMMDmncaowVF/rt95
X-Google-Smtp-Source: ABdhPJwF+5tM+xC0weAM3Wfy1enqOVGyYwXQ8BdRRtnQZOrRW8fmKKto3uHCskw6ACbrGHCJhkGES2mLEZu0mPcGsRY=
X-Received: by 2002:a17:906:6a1b:: with SMTP id o27mr1698843ejr.271.1591982041997;
 Fri, 12 Jun 2020 10:14:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msn-fB-zi7waM8AWhpwRu0HpY_MNO86ED=8ykc-ZM5VkA@mail.gmail.com>
 <CAKywueQCH_=cywB6w53xje+Okm_WSxB0qSHjGGz6CgGMuia6MA@mail.gmail.com>
In-Reply-To: <CAKywueQCH_=cywB6w53xje+Okm_WSxB0qSHjGGz6CgGMuia6MA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 12 Jun 2020 10:13:50 -0700
Message-ID: <CAKywueSzichPrZ1iUf6o0nAw5etbucewUACbp-RA0=i-=H13Kw@mail.gmail.com>
Subject: Re: [PATCH] smb3: allow uid and gid owners to be set on create with
 idsfromsid mount option
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Other than that looks good.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 12 =D0=B8=D1=8E=D0=BD. 2020 =D0=B3. =D0=B2 10:13, Pavel Shilo=
vsky <piastryyy@gmail.com>:
>
> We probably need to add an FYI log message inside
> setup_owner_group_sids to print resulting SIDs for both UID and GID.
> We do have a similar log message for mode.
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D1=82, 12 =D0=B8=D1=8E=D0=BD. 2020 =D0=B3. =D0=B2 07:32, Steve Fre=
nch <smfrench@gmail.com>:
> >
> > Currently idsfromsid mount option allows querying owner information fro=
m the
> > special sids used to represent POSIX uids and gids but needed changes t=
o
> > populate the security descriptor context with the owner information whe=
n
> > idsfromsid mount option was used.
> >
> > --
> > Thanks,
> >
> > Steve
