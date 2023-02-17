Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80267C05027
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 06:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjBQGNp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Feb 2023 01:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBQGNo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Feb 2023 01:13:44 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4044AFE6
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 22:13:43 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id be32so271388lfb.10
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 22:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4LO/TzNRdGS+NAkb5c71zI75VS0pG4xxytpLbiPd0I4=;
        b=a0yFFbFs/eJ2WILLyY882FII66RWrbk398R/rZ0L/ZeHqDFp913+T2sVegcfKUWID4
         AohpGOyIdvs2TGy2qWgWHwKme0y38MV3X/DpiI+2Hd7gEbGsCcrTeTM/Ru/38n32dbxS
         5e1BlC8GxCGQP3VOi1HsqKIJIt67Dd9dSqjJIrPtqHZXBlAVpgWGWt/umU/JE7RAXrP2
         QlG3glusrc/XCVIUDiJ8oK1RP0aLD9usUXY2MXnfFEPGdKIxUo49tp/5D3a9rqlvn0lT
         z7s1wTYEWhdc1wyR1Y8GOwgDQ0E04nsZp15GuDbb0dpGRGU7IofG84zX3hDwKHZU5STH
         DPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4LO/TzNRdGS+NAkb5c71zI75VS0pG4xxytpLbiPd0I4=;
        b=f5ra+T2Q61IDeE+jzzKZjtWB5cd8kZLnDCgckkLo1SkFUdr9fE/Lo3/uEVxZLBaCh0
         l2YTKwmv60Qq2Qo/DwGx4c88teY1gYnSf8dAJrLDWseWfGoacbdRAaviDMrv/vJQ557c
         SqSlInAEGsnIPgQXuPGVyAy5ADwEF+6XQtsRmbVOEfj3RJHAPAvE//iHNQe84DY6eOMH
         VVVWOjlFp4vQxVvz0i5S9dfeL9dm1O+0mrL1Ih6ETn2L1zHeKJ3Y8uxl+H3sbqZ7BcRD
         +u3uTRAtRSN41LDDuLdpmMZVAb8hYsV7CHPB+OHazlNyl+VsU8h/10+QhkbvjV6qtSoY
         eoxg==
X-Gm-Message-State: AO0yUKVy+Qd9EhqvoANcaLZAyvn2ZLJVzriUYqt4KwlbUZnHHqaD3186
        O8HAZDhL52wTe3ciDt1eH2HeAtR8+HyMSyJGBXCGYcjy
X-Google-Smtp-Source: AK7set9S9Seir/i6DgEs+RqoWhQF/hPQa59O4G6cqdQtLs7xZuqUSRELsdsB+V7FfMzZpncdr4t9+qilRfIY/IrIka0=
X-Received: by 2002:a19:700f:0:b0:4d5:ca32:6aea with SMTP id
 h15-20020a19700f000000b004d5ca326aeamr117217lfc.10.1676614422064; Thu, 16 Feb
 2023 22:13:42 -0800 (PST)
MIME-Version: 1.0
References: <Y+UrrjvGrOT6Bcmy@sernet.de> <87lel6enq6.fsf@cjr.nz>
 <CAH2r5mvGWJVjPJo1Guyd7W0eiHyRD9Wd7F0ndKLaGCj6VyHUwA@mail.gmail.com>
 <Y+Y4vMiTFdev4V1L@sernet.de> <CAH2r5mvzVQKAT-a+MJ-qN=Ogn8PqNdMz=3zYntaq26UdgcY0Cg@mail.gmail.com>
 <Y+nrvNByzLDMnDvU@sernet.de> <CAH2r5mtoSHTXNeOF-MzOA_EmgZS0C7WsBkQJcNtRXpDmj=mowg@mail.gmail.com>
In-Reply-To: <CAH2r5mtoSHTXNeOF-MzOA_EmgZS0C7WsBkQJcNtRXpDmj=mowg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 17 Feb 2023 00:13:30 -0600
Message-ID: <CAH2r5mtx4d+V3OETUU8+_Q_Ec5OUqT0gtdjYvbezUDGKuBDejQ@mail.gmail.com>
Subject: Re: Fix an uninitialized read in smb3_qfs_tcon()
To:     Volker.Lendecke@sernet.de
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

also I added cc:stable (to this and to the followon related patch) ...
let me know if any objections

On Tue, Feb 14, 2023 at 4:54 PM Steve French <smfrench@gmail.com> wrote:
>
> merged into cifs-2.6.git for-next (pending testing and any additional review)
>
> On Mon, Feb 13, 2023 at 1:50 AM Volker Lendecke
> <Volker.Lendecke@sernet.de> wrote:
> >
> > Am Fri, Feb 10, 2023 at 10:01:37PM -0600 schrieb Steve French:
> > > Yes. On top of for next. They don't have to be squashed into one if it
> > > makes it harder to review.
> >
> > Attached.
> >
> > Volker
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
