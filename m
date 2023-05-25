Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6FBC77B7E
	for <linux-cifs@archiver.kernel.org>; Thu, 25 May 2023 23:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjEYXub (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 19:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjEYXua (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 19:50:30 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB41612F
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 16:50:28 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f3b314b1d7so69752e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 16:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685058627; x=1687650627;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggWLpR5SIsdGQr/iFMBh/HeMCJnyFwZgVHSjyUREoBU=;
        b=Ar5pb64m8luvleoEMT5l/KwPtlu2fSEhq3qP0yDS9gQJI+EkOMIbMewT2mR1b2QpX+
         MEv1wZ2FKg3Si8BVhfqBEZve1txGIDQSM+ew70/dfX47ecXkwXLr9X0bGwItZFZXTfYx
         xEralR8UXsG/0G3jNiQyKzcvwDBbW+6REhF8kiVWP3Wj7hEskrsj/KXk702JND1UZmTX
         ocrvOE+E6aSt/byH/tMjGUGyp0rp0t489V5PIzWZwURW7R2It6l2BKNjoZ7g10O4rLRn
         7bYqUnWgEo9p3UT3icdMLpbBFRIVa333J6NbTouBGMMhS9idioZZsD8HOy6kaiK0AW6j
         zgdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685058627; x=1687650627;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ggWLpR5SIsdGQr/iFMBh/HeMCJnyFwZgVHSjyUREoBU=;
        b=YPh/uig08ucMWFcxkEo/XwSqkNYnMaIRSkuOgU7Fenf7/qGmWZqRyNFGXTv7LdaMQk
         smwjceQ+uitXYJa1IfOTGWvM+EL8Bcen/qV4r6t8pHPitplAE+TJhiXt3NEI8iFEUiat
         oRT4RGzFQFl9XVxnPNV+RJN57dgqH66KmCSMwhKc0T75FlgRhNX90ErDbICwbdbMXj+F
         6iSueUxrLEk4UCvkAF+5KLXex9STVGFXsisSY7ShsRphrjsW4nBsRrda47c/HXEzoy5k
         AMCUFGgGb3BpruO6Fsh6+J+Gl2skfTbumApK2I7S45tJMGTZO5eKWyO38VjunrJoW5hQ
         9wAg==
X-Gm-Message-State: AC+VfDwxA7PSskuuGz+LFVxARpslpdUQ5DakV355eW5qYHIWmzYJAuFU
        HueMoxbbr0Myb7kLiGFvXceD5r7l3hQDCDFtSSI=
X-Google-Smtp-Source: ACHHUZ60GaMNEO7fvqQdli4vTnAMaqI/aq6v+5xZUGoaDmitC4MDvDndxXc8/fkMnH2djVNGYSHK6kN4ZJs4zUJA0jo=
X-Received: by 2002:a19:7003:0:b0:4e8:5576:98f4 with SMTP id
 h3-20020a197003000000b004e8557698f4mr6536043lfc.45.1685058626856; Thu, 25 May
 2023 16:50:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop> <20230525093900.GA261009@sernet.de>
 <CAN05THTi0BC_iwjXMiWn61fg3hRemi5Momwp3O0WGygyWLGomQ@mail.gmail.com>
 <ZG+LOKTr8B+zjQsC@jeremy-rocky-laptop> <CAH2r5mv7aZ8nm30oKyYpa-bd8-MqA13EcEmQWV4mOyrV-rj8Ug@mail.gmail.com>
 <ZG/DajG6spMO6A7v@jeremy-rocky-laptop> <20230525221449.GA9932@sernet.de>
In-Reply-To: <20230525221449.GA9932@sernet.de>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 May 2023 18:50:15 -0500
Message-ID: <CAH2r5mvGb_e-kjLoKpwF3Eg7f7oOGGKcM7rL95SkU4q=pSE1AQ@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     Jeremy Allison <jra@samba.org>, Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, May 25, 2023 at 5:14=E2=80=AFPM Bj=C3=B6rn JACKE <bj@sernet.de> wro=
te:
>
> On 2023-05-25 at 13:22 -0700 Jeremy Allison sent off:
> > I think cifsfs providing access to ADS remotely on Windows
> > and Samba shares is fine.
> >
> > What I'm scared of is adding ADS as a generic "feature" to
> > the Linux VFS and other filesystems :-).
>
> full ack on Jeremy's view here.
>
> If there is something the the Linux VFS layer should *really* add to help
> interoperability with basically all other major OS implementations is NFS=
v4
> ACLs.  Seriously, for so many people living with Linux is a real pain due=
 to
> the lack of NFS4 ACLs here.

Today the "RichACLs" can be displayed multiple ways (e.g. "getcifsacl"
and various other
tools and also via system xattrs).
Being able to display "RichACLs" makes sense - and I am fine with
mapping these (and
probably would make sense to at least have a readonly mapping of the
existing richacls on
a file to "posixacl") and RichACLs are very important.

Wouldn't it be easier to let them also be queried for cifs.ko via
"system.getrichacl" (or whatever
the "getrichacl" tool used in various xfstests uses)?

I was also wondering how we should display (and how to retrieve via
SMB3) "claims based ACLs" (presumably these are reasonably common on a
few server types like Windows)?



--=20
Thanks,

Steve
