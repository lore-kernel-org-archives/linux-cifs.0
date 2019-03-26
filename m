Return-Path: <SRS0=KOHi=R5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB6CC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 19:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D130120823
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 19:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="POVa7Mg5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbfCZTGz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:06:55 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40398 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfCZTGz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Mar 2019 15:06:55 -0400
Received: by mail-lj1-f193.google.com with SMTP id q66so12170986ljq.7
        for <linux-cifs@vger.kernel.org>; Tue, 26 Mar 2019 12:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OEeeUTcq4KlvmOj009rtv9eu/ydXTr8/Jch+wkvfRV0=;
        b=POVa7Mg5HAQ5v1oIA2xQQ1/GBDsEoKHb/bLGSH338o+ZvdP/gnh9HESrTiguldNneo
         DqAsweWBtonOWQbUN5+UUnJEnS2Rtz+H8QYN3oDQiSIhUVdrmypTUtjGtGQ/rLUo5Vj3
         GHNP36TJYJYpnokPc2IO7RWBnYQ/chEqXQ+7Nhu4/VjsA9MrOt0EVjmQMO6+cMYrqXS8
         DTNzZqPf2rz/KavCCcHafr/u/pQMevh7JC5AdGNM09q2Q0dVokJTtEqqCguibivQGEd0
         F6dHq8V+zytzY0gYTq8sv2dco3czUO9Y7icwuLTn3sEXBGSOtCYvea/27a45zGeqStHD
         OrvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OEeeUTcq4KlvmOj009rtv9eu/ydXTr8/Jch+wkvfRV0=;
        b=qahnFRuULl5WKEmmA8CqUsRn3rSGTxbAninfeHkZSDvFaHL6Bw/57xxkk4NOyHwDlP
         6JVO2lfBr8SSb4MNl+xe88tpkRBs1ZEuJXNHNcWMEHIsEDX1i0HhtsBjaG5sjTIcSDnj
         7W6O2HScmvTnPa+UJBtWUh8QF7aQbRn8Feq1tFNYZelTl68usuwYnUN6SLj2+oNhAhDB
         P2nFdZ/Zc4M4SdGQI+INdgVFQ+3Iwhv9oZSxscF+7Lwg/H8zxg1/ag/yQn/r0hI8/ewI
         X+vR21cP2qtuQMT0j6otzLP+8laxhl/8jy9Oh6mLnMgaRjdvdnlDPHAJiEOmayJINTEG
         m4dQ==
X-Gm-Message-State: APjAAAUsSESo2yPnhiAKBUgSlkBBUhFrV2A7ZGlCfRk+JHWmyR9FJUy2
        tOis6vy2YigdhifEK4KsMSS3tgu7aMWXRWKW27iZNGc=
X-Google-Smtp-Source: APXvYqyOKHxcg5XVpo6ahoaeuhPlRiovQDV7QZumTWcLXDyYHUSv60qGgX0gI8Asjb3YzgZJKgpC4hqIYXPhUfzMXEk=
X-Received: by 2002:a2e:454:: with SMTP id 81mr8751904lje.23.1553627213091;
 Tue, 26 Mar 2019 12:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms+oJ8PpAbsmTmRDqoS4C=dcNV=xYv3tMWnoigA5JqFsA@mail.gmail.com>
 <CAN05THRYrWBi9cSB5-gbV_y9cAf+0KTPn-2ogPc7SU2t9ob6UQ@mail.gmail.com> <CAH2r5mt4yFse7kmR2Oe6wWSrGCVO2aq=PF2iiC7kYJSY3e7xtA@mail.gmail.com>
In-Reply-To: <CAH2r5mt4yFse7kmR2Oe6wWSrGCVO2aq=PF2iiC7kYJSY3e7xtA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 26 Mar 2019 12:06:41 -0700
Message-ID: <CAKywueQN-f1TAm9FW53hWFAXARXQCDJbbjLYOXBGtt=Rxxr60g@mail.gmail.com>
Subject: Re: [RFC][PATCH] Track time spent in each command
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 26 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 11:55, Steve Frenc=
h <smfrench@gmail.com>:
>
> How about this updated patch - note how I now display min/max
> (although min in this case will always be zero since jiffies are
> pretty coarse granularity - maybe would be more helpful to run this
> example over a slow link, or I could just make the patch simpler and
> not save the minimum time for each command).  Note that the new stats
> begin with the line "Total time spent processing by command ..."
>
>
>
>
> $ cat /proc/fs/cifs/Stats
> Resources in use
> CIFS Session: 1
> Share (unique mount targets): 3
> SMB Request/Response Buffer: 1 Pool size: 5
> SMB Small Req/Resp Buffer: 1 Pool size: 30
> Total Large 38854 Small 1039857 Allocations
> Operations (MIDs): 0
>
> 0 session 0 share reconnects
> Total vfs operations: 272653 maximum at one time: 3
>
> Total time spent processing by command. Time units are jiffies (250 per s=
econd)
>   SMB3 CMD    Number    Total Time    Fastest    Slowest
>   --------    ------    ----------    -------    -------
>   0        1    1        1    1
>   1        2    1        0    1
>   2        0    0        0    0
>   3        6    1        0    1
>   4        3    0        0    0
>   5        95353    5163        0    12
>   6        95314    3012        0    1
>   7        2    2        1    1
>   8        4263    57        0    1
>   9        1101    33        0    1
>   10        0    0        0    0
>   11        16    0        0    0
>   12        0    0        0    0
>   13        0    0        0    0
>   14        121    37        0    1
>   15        0    0        0    0
>   16        56357    1100        0    1
>   17        16703    1089        0    1
>   18        0    0        0    0


Looks good. Probably "SMB3 CMD" should be just "CMD" and extra tabs
are needed for proper indentation.

--
Best regards,
Pavel Shilovsky
