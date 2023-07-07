Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954C0EB64D9
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jul 2023 16:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjGGQRr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jul 2023 12:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjGGQRq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jul 2023 12:17:46 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2C11FF6
        for <linux-cifs@vger.kernel.org>; Fri,  7 Jul 2023 09:17:45 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2b700e85950so31784361fa.3
        for <linux-cifs@vger.kernel.org>; Fri, 07 Jul 2023 09:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688746663; x=1691338663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+j+PgDSJr6cQXOyx+DKqTeq3XXXtDMWv5YNVRgg2OY=;
        b=snnm7xcDQSTVOw04hErQXdsyqnVYIRqk1LFPXdcQ3lcKJzvuuGrM5DtFXpi9WyaIqp
         VXC5SY7RKzCjgVvuxF9na0wQrVOVSGvm6kFJfnHoTIVH3hE0M15ydhjymn55Q2MuiPZg
         KlCq8J4nIljZVQPOzqV/S/ysOKKcknXJ0V3SOxQnT9dLVSNrguEsqEdCfRh7j0CyMD0g
         RihNTJFI+v3Hp0j3vGndQ5hywWow2WoKepAdmskfMPPQi5eHdE6xHJR9BfHoWB65NTx+
         ZBdtesLF6MFe8BLURTO6D1NYLB6liqcaPBHAF2CNnZzdfg77Slny6esW91jaRRErZ/ux
         mjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688746663; x=1691338663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b+j+PgDSJr6cQXOyx+DKqTeq3XXXtDMWv5YNVRgg2OY=;
        b=bQ8IJDEnV9yKY/kt5EMaXaj2LW13Xy0qFPYngAOVPjtSPDe2blOKMjSh2H1ofuDo+H
         39V0U66Uia+UbWW5+b7uIa+GfUB68Rycr88XaXZbJkvc3LGxi5sb95yDPXYWOUE2f1su
         mpox4oci/3N1G6e/VDnHqsMoPpMEIzFawji3GAyrYQKemLc7Q7MUWblEZqHwTWo5oIXF
         4H0xJ6eiuRABIJAEl+uaiUtveIL6FpmZHmJ01oxCYYmw14jRQe/pjxXmY2CSiGLBPRrw
         wjwFDbbLAtMNYebU3AIsLDp4+L36P+ospO9Yd92jOzXxLpKuJhuc/94utAEl2vLTam6f
         rnCg==
X-Gm-Message-State: ABy/qLZHfhYMS33nmaaTHzPu0Zl1w9vkmhvaIXNf2FiWWfW6wimrNz91
        rWmiKaIevda6gV5cJHEXkd5UD5LdCuBCN/KR1fs=
X-Google-Smtp-Source: APBJJlFf1b/6kTtBgN6s7hrDP8qvH3S6Vy2pX/76mi0lBtHikM5LkKxD3c2f9qE9LEIStU/94YM1JlUyvXFAsKvjaVA=
X-Received: by 2002:a2e:9cc2:0:b0:2b6:d7d1:95bf with SMTP id
 g2-20020a2e9cc2000000b002b6d7d195bfmr4088942ljj.9.1688746663043; Fri, 07 Jul
 2023 09:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230706023224.609324-1-lsahlber@redhat.com> <CAH2r5mtAXKOOUN6BfVD25SzAq6TXfeRt+9u19i5o+f6oSgfGrA@mail.gmail.com>
 <CANT5p=oMg3wx4qPCV9EEtmP7FCLG43iqO47iFwimCNS6E=QnFA@mail.gmail.com>
 <CAN05THSjxZ=_L-Ho8tffz9xRfc8R8kCWf-_GtYUe=yFNEC2bhw@mail.gmail.com> <CANT5p=qxZjxpqx49BO7G-8=se2_5gEPyLOi_W-sUDm0p7VhbEQ@mail.gmail.com>
In-Reply-To: <CANT5p=qxZjxpqx49BO7G-8=se2_5gEPyLOi_W-sUDm0p7VhbEQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 7 Jul 2023 11:17:31 -0500
Message-ID: <CAH2r5mt5gt8E1riGaoPVs1o40ssFDpuv2CAL-wMz8ucGBJMamg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add a laundromat thread for cached directories
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jul 7, 2023 at 1:37=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.c=
om> wrote:
>
> On Fri, Jul 7, 2023 at 11:20=E2=80=AFAM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > We can only cache a limited amount of entries.
> > We need to force entries to be dropped from the cache at regular
> > intervals to make room for potential new entries/different
> > directories.
> >
> > Access patterns change over time and what is the "hot" directory will
> > also change over time so we need to drop entries to make sure that
> > when some directory becomes hot there will be decent chance that it
> > will be able to become cached.
> >
> > If a directory becomes "cold" we no longer want it to take up entries
> > in our cache.
> >
>
> Makes sense.
>
> However, the value of MAX_CACHED_FIDS to 16 seems very restrictive.
> And as Steve suggested, 30s expiry seems very aggressive.
> I think we can increase both.

At least for the short term we can make this configurable (which will
make it easier to test the best default values in the long run) e.g.
via mount parm.   Will make it much easier to experiment to optimize
the value


--=20
Thanks,

Steve
