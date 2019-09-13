Return-Path: <SRS0=frs6=XI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F0BC4CEC6
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 00:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F2D12075C
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 00:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJmjO/WI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfIMAug (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Sep 2019 20:50:36 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:32958 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbfIMAug (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Sep 2019 20:50:36 -0400
Received: by mail-io1-f66.google.com with SMTP id m11so59333425ioo.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Sep 2019 17:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oJcuFL/00K9P8cLI9/NdPWCxOvxXUynFGiYaPBsJwLc=;
        b=KJmjO/WIrdEyoEh4V6gY51W6glxkYbeE6osl8+wvY6F0TLHgvGcZsYXYI1n8qgDcn9
         fWrs/DwjX+T1DxC6LVt1kodHE8p5nRBy3RsYXMp2HtuSjs9wG2uKcDSnZGhIVA2vs3nt
         buWgPcEYDXckKD7XO7z18t3zLY2mH1yJk1j3rcfKrBrq/d0H9Cv5A4WihXu/TDNFfS0r
         bMh7x2IdogrSzJteStcjJyv24e+eW6/ywWnrVbrOG+VkljjNmgCBIuKrgdmzLV8tl0bg
         sy7dmMPSuQ7YrUyPDXL1SWFoZc2O2cIErYjV0X8deLKFGJes+9VfhF1DThYaxDZknvT9
         Q9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oJcuFL/00K9P8cLI9/NdPWCxOvxXUynFGiYaPBsJwLc=;
        b=EKAhV54oREilCQwczIhkpB634aSWZcOoweF2GizDhED0gRT4A04ivc4I4S+svCEGu9
         9sOBzw8lwPnzaLYLA/V+5touaVtYbdPGtzSOEMvPQOlTNuxrDCskgPBRoGLXQsV9rl2a
         +2g7JHJ3++Y63jRgicfylYaEcQ870ihImBwZDEJ7EuwtxYZeXjIpYwB6xYApCsIVwwCK
         dOdTsD2VhEJPRFehAuCgswM9ex1h+/jQiUyKk5yjFjnyIbp/ifnXi1/Xt72F1j3MyE91
         aLRjMTeViA9Xfikzm08ox1hOEpx/1UzmHGEO8NilUNfTNMLOndaDEvz9tRA1rTcSeAKQ
         Hh3Q==
X-Gm-Message-State: APjAAAWNIA8OPYA7Yqh4dgXwneBuj+8aLQEWXuRdj0li0+5DbOxOX4Xr
        2TYhfGKbGouUJzv8pNsfpVh2knmcP2ICjkGxC//ajDuk
X-Google-Smtp-Source: APXvYqwBfN9yLb8DNhwTWW4a9z9IRl0E7N3JoBbVe1KEQphD1OYXFtKnhhHT44lbCWSPtobYf60kD03/t/4E0piWgT4=
X-Received: by 2002:a02:608:: with SMTP id 8mr46966023jav.88.1568335835251;
 Thu, 12 Sep 2019 17:50:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtFA5c5XxL6ohwyGqj=zPc0mUR1_VNvcMyhrZZJuwcBPA@mail.gmail.com>
 <CAN05THSjpqqgXgfvDndFyZS2TwyvKDCNMSfxxgMApQVECk=cSA@mail.gmail.com>
 <CAKywueR6Z1QbkbA3RxXrBEZOvHxECnAGV1ko+DnLgTusv2tEhA@mail.gmail.com>
 <CAN05THSBw-6WMJK8Sb_nXevrCceqkjuYRumF1pjqPoeg90aMtg@mail.gmail.com> <CAKywueQUOyNPG7QKEAeiJY7=pCqfHZhkPKTT0r404vgh8-HJSA@mail.gmail.com>
In-Reply-To: <CAKywueQUOyNPG7QKEAeiJY7=pCqfHZhkPKTT0r404vgh8-HJSA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 12 Sep 2019 19:50:23 -0500
Message-ID: <CAH2r5muU7O8D=OS8N1zkbyo1+x9X1_uccNUSmAag3M7z6uGydA@mail.gmail.com>
Subject: Re: [SMB3][PATCH] Fix share deleted and share recreated cases
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixed with a different patch following Pavel's suggestion - (a
followon to Aurelien's open_shroot hang patch)

On Thu, Sep 12, 2019 at 12:01 PM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> We need to skip TreeDisconnect command if tcon->need_reconnect is
> true. Steve, could you add this to the patch?
> --
> Best regards,
> Pavel Shilovsky
>
> =D1=81=D1=80, 11 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 15:10, ron=
nie sahlberg <ronniesahlberg@gmail.com>:
> >
> > On Thu, Sep 12, 2019 at 3:08 AM Pavel Shilovsky <piastryyy@gmail.com> w=
rote:
> > >
> > > can this error code be returned on any operation?
> >
> > Not sure.
> > I think it is only returned by TreeConnect and possibly also
> > SessionSetup, but not sure.
> >
> >
> > > --
> > > Best regards,
> > > Pavel Shilovsky
> > >
> > > =D0=B2=D1=82, 10 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 22:26,=
 ronnie sahlberg <ronniesahlberg@gmail.com>:
> > > >
> > > > Looks good.
> > > >
> > > >
> > > > We also need to handle the case where the share is deleted but is
> > > > never added back.
> > > >
> > > > On Wed, Sep 11, 2019 at 3:15 PM Steve French <smfrench@gmail.com> w=
rote:
> > > > >
> > > > > When a share is deleted, returning EIO is confusing and no useful
> > > > > information is logged.  Improve the handling of this case by
> > > > > at least logging a better error for this (and also mapping the er=
ror
> > > > > differently to EREMCHG).  See e.g. the new messages that would be=
 logged:
> > > > >
> > > > > [55243.639530] server share \\192.168.1.219\scratch deleted
> > > > > [55243.642568] CIFS VFS: \\192.168.1.219\scratch BAD_NETWORK_NAME=
:
> > > > > \\192.168.1.219\scratch
> > > > >
> > > > > In addition for the case where a share is deleted and then recrea=
ted
> > > > > with the same name, have now fixed that so it works. This is some=
times
> > > > > done for example, because the admin had to move a share to a diff=
erent,
> > > > > bigger local drive when a share is running low on space.
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve



--=20
Thanks,

Steve
