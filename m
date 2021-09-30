Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A829C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 00:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 553C06128C
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 00:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347443AbhI3Axt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 20:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347311AbhI3Axs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 20:53:48 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369CEC06161C
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 17:52:07 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id 188so5359412vsv.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 17:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=COMRjryoPRLGKtOpS6FwHUFTbYKtvyCU57G2pPa3sV8=;
        b=YGVT5u6KShHDHK0gkazCb0m12Ea5Jh4R2j37FzpaUDM6WHL5pKTuDl7i2i7JUt8T8P
         KFJIjUnRNaUdOotECUnTBcJJ13KDQ+F7yqpKfJ7EKHFW/VJ8cQxetC+7gHZnBvUmsBjW
         Mt2lIDcCanXBDzVabOxS8fIkVJ7ecZwpOL7Nu3rF/cJMP62qrdGWzWBhpKp2y5pro6y3
         hXjmqRB98tWaO7ObUQJel3xBPbDwbLwt/0sHytrl/s7LvRYO6zQbVyWLq4COi4UD9LB4
         LQZcxyeV7YpEh/gRcL6acpQTEKy/BpSNIspILUGHjr/3ZSc2ahvLHUCwVzWAskYbh4Ft
         I2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=COMRjryoPRLGKtOpS6FwHUFTbYKtvyCU57G2pPa3sV8=;
        b=ZQSbsdBL3OjOrfQmnijrOzuzZFBflsrVDoVT9Cz5pNZoA0ipKRi0VpI4Zg59TKvFxR
         4MWILU/LhFK8E22YjwMvOfzkCh7J3/rQYcHbsExkUvkOv/UwtzPtQtlGwSNCTUKbqXXq
         jJDFRDAO3yqSjlbCWxrmvixZcVsKjCTbdPlU/tzt2DYzpJm0oABTA+kRV+R8jFmeuklM
         XqQ/rBNkj/Q35XtL+5X9iRGnnw28zDz4wiZLG40LO1abxDmzDxaGJKIODauJ8grv2KHT
         RkA99zgZDPICeym43h3Ne/jXNM2gLrcXctGaWZVNq5WTr6+mbwAIvJu62ZJgTVGXxgCt
         QEFQ==
X-Gm-Message-State: AOAM5301/Wv4BwDDqV4elVz1K5nmzhjFpuNuTFYpzp9e5cFmh+wjqbYm
        qQZzCkIDxFxzBtEZ0SRigXDReeD5kgacdvKVEdhmQwQIRz0zx8u9
X-Google-Smtp-Source: ABdhPJziC0dXduhCSV2LcZYaUp3FB0tQNpPIEtA+XSbZtOngxedta4Ntv/8l5buhpRUFVzadB187kPySguF4Oy4liRE=
X-Received: by 2002:a67:c088:: with SMTP id x8mr1300645vsi.45.1632963126295;
 Wed, 29 Sep 2021 17:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org> <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org> <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
 <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
 <79ed52be-c92e-1c62-423f-ee126b3da409@samba.org> <YVNR6w7dq0HMIcFA@jeremy-acer>
 <76fcdc45-0a94-d9e6-14c8-1c638d0bd00f@talpey.com> <YVSJWPa8dalyzsl0@jeremy-acer>
 <ce52c130-74de-feaa-6995-6a0d947816a6@samba.org> <27908e3e-140e-8c7a-e792-414fec5b5190@talpey.com>
 <CAH2r5mvPy0UBJ2z=gSbyOSK9cMYMdB-Unr4Jk14Fve4W1XFTJQ@mail.gmail.com>
 <0132d0cb-5efd-f042-d8d6-720e7f3dc69b@samba.org> <CAKYAXd8R2OQ3=m8HjUffph5+hw_D2KaT60ZDsYmEtCqEFE3gQQ@mail.gmail.com>
In-Reply-To: <CAKYAXd8R2OQ3=m8HjUffph5+hw_D2KaT60ZDsYmEtCqEFE3gQQ@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 30 Sep 2021 09:51:55 +0900
Message-ID: <CANFS6bZRLygxNGO7RJ-Nz9s4-Q7ykoxEK2yCAVPADyCytKfUPg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Ralph Boehme <slow@samba.org>, Steve French <smfrench@gmail.com>,
        Tom Talpey <tom@talpey.com>, Jeremy Allison <jra@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 9=EC=9B=94 30=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 9:32, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2021-09-30 2:18 GMT+09:00, Ralph Boehme <slow@samba.org>:
> > Am 29.09.21 um 19:11 schrieb Steve French:
> >> gitnub is fine for many things, and we can automated "kernel
> >> development process"
> >> things presumably with github easier than alternatives:
> >> - running "scripts/checkpatch"
> >> - make with C=3D1 and "_CHECK_ENDIAN" support turned on
> >> - kick off smbtorture tests (as Namjae already does in his branches in
> >> github)
> >
> > you can also add "doing review". :)
> >
> > As for running tests: I want that as well! :) How can I get that? Maybe
> > other want to run CI on their patches too before posting them.
> >
> >> BUT ... we have to ensure a couple things.
> >> - we don't annoy Linus (and linux-next and stable maintainers) by doin=
g
> >> things
> >> like web merges in github (he complained about the
> >> meaningless/distracting
> >> github web ui empty merge messages)
> >
> > as said before: just don't do the merge there, just the review. That's
> > the way Samba has been doing it for years. Are you actually aware of th=
e
> > current Samba workflow?
> Is it friendly to new developers? I know samba workflow now too. New
> developers can do everything easily by simply subscribing to the
> mailing list. And do we review only the SMB protocol on github? If we
> review and discuss kernel common code usage and touching, it should be
> visible to the component kernel maintainers as well.
>

I agreed. Kernel developers are familiar with reviews in the mailing list.
And only for patches about the SMB protocol, If someone asks for
review in github,
we can do it.

> And is the review history likely to be discarded on github? Doesn't it
> get thrown away the moment you change or update a patch? Also, review
> discussions left on each individual's github cannot be easily searched
> like mailing list.
> >
> > -slow
> >
> > --
> > Ralph Boehme, Samba Team                 https://samba.org/
> > SerNet Samba Team Lead      https://sernet.de/en/team-samba
> >



--=20
Thanks,
Hyunchul
