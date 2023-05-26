Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09276C77B7A
	for <linux-cifs@archiver.kernel.org>; Fri, 26 May 2023 02:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjEZCQl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 22:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjEZCQk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 22:16:40 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72579135
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 19:16:39 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96aae59bbd6so32674966b.3
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 19:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685067398; x=1687659398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+YRl0CK0/vDUx+BiavA9wwrG9kcCyV04wSL16+Nl5k=;
        b=XJpl9Z4OX/DxszTowtfwAADz9DHbNc6dEhFIVTbT4aojTkFxaPBGsPtvruUhr85oMI
         hNhfOqkJdOD1SZnPplDKHfhuLKrxoTPEn45q8Iv5sbKEzIGcLafIGfHDHL9tDAkL38x7
         jToupvyB5/bzGJagH8D9MhG0R5aX6GFXI/TFc9c4XjcUYeYIh77usPwbhX2xy3/lJKOq
         FrmMUmwdUqHp7OJu6QZiOsda4HgJmrA8h1++wF+2cgDv8zE1tCulSjriMWhBLoty5Nnc
         eKVczAU85cvxNtDGkopeL+5QDOHv4rs7tbnfYn7JEVz76plDBlh6vIjZp7Q6+Di7PWSF
         xblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685067398; x=1687659398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e+YRl0CK0/vDUx+BiavA9wwrG9kcCyV04wSL16+Nl5k=;
        b=hWBzFifqG1qElH2emWIqY5HkRBWTCeSxJ+gNiRyU0Gdc1zx09zpHwfpf8IT4pqyJwb
         nWmpbh3CKPw4j1WtvtPP9+85dhEuosoQbj4ZsGlGod+XpMgzK4o3oFfW3cc1pcdeT5VB
         HVGa0lsP1gHraarAdJmjhWvsw0XZvpe6CJFrlS5vjaL+wNZuqbW3qhCZX7ZU6WCTAfMd
         w74RzMVc+5+2ljyugt1QBEJBv1J2VfIUV48EvSkmPSBK0qsVhLgeM0J3bqWl0yUJW63O
         EMnmGGOvAQE1Jar1ljun/ndQ8an6z4sLpCmW30CDYKSVnrbwYRNJprICelbkH14dmPXN
         aD6w==
X-Gm-Message-State: AC+VfDzNctCyk8j84Rw6vV2tNJMOWVyJWFTJ896tdWgn01IE/SOjsMpm
        5M6FEUwB7+wwwWkB/c239Q7i6KvQ2sLvruWVH5IOCHU9
X-Google-Smtp-Source: ACHHUZ49t58ZOhm1/YEaL5LYLIIy2bdA55XjL/If7r+7JZpXa3CyUB8dDOBPrBea2MVcZJlwo+qJS6A1kl0i0UQPcBo=
X-Received: by 2002:a17:907:3684:b0:958:cc8:bd55 with SMTP id
 bi4-20020a170907368400b009580cc8bd55mr704325ejc.0.1685067397801; Thu, 25 May
 2023 19:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop> <20230525093900.GA261009@sernet.de>
 <CAN05THTi0BC_iwjXMiWn61fg3hRemi5Momwp3O0WGygyWLGomQ@mail.gmail.com>
 <ZG+LOKTr8B+zjQsC@jeremy-rocky-laptop> <CAH2r5mv7aZ8nm30oKyYpa-bd8-MqA13EcEmQWV4mOyrV-rj8Ug@mail.gmail.com>
 <ZG/DajG6spMO6A7v@jeremy-rocky-laptop> <20230525221449.GA9932@sernet.de> <CAH2r5mvGb_e-kjLoKpwF3Eg7f7oOGGKcM7rL95SkU4q=pSE1AQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvGb_e-kjLoKpwF3Eg7f7oOGGKcM7rL95SkU4q=pSE1AQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 26 May 2023 12:16:25 +1000
Message-ID: <CAN05THS3=XDPA7SzZF9zVPDFhyG5NpxHz8Gi8LoDsbZVYmZSSw@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     Steve French <smfrench@gmail.com>
Cc:     Jeremy Allison <jra@samba.org>, Christoph Hellwig <hch@lst.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 26 May 2023 at 09:50, Steve French <smfrench@gmail.com> wrote:
>
> On Thu, May 25, 2023 at 5:14=E2=80=AFPM Bj=C3=B6rn JACKE <bj@sernet.de> w=
rote:
> >
> > On 2023-05-25 at 13:22 -0700 Jeremy Allison sent off:
> > > I think cifsfs providing access to ADS remotely on Windows
> > > and Samba shares is fine.
> > >
> > > What I'm scared of is adding ADS as a generic "feature" to
> > > the Linux VFS and other filesystems :-).
> >
> > full ack on Jeremy's view here.
> >
> > If there is something the the Linux VFS layer should *really* add to he=
lp
> > interoperability with basically all other major OS implementations is N=
FSv4
> > ACLs.  Seriously, for so many people living with Linux is a real pain d=
ue to
> > the lack of NFS4 ACLs here.
>
> Today the "RichACLs" can be displayed multiple ways (e.g. "getcifsacl"
> and various other
> tools and also via system xattrs).
> Being able to display "RichACLs" makes sense - and I am fine with
> mapping these (and
> probably would make sense to at least have a readonly mapping of the
> existing richacls on
> a file to "posixacl") and RichACLs are very important.
>
> Wouldn't it be easier to let them also be queried for cifs.ko via
> "system.getrichacl" (or whatever
> the "getrichacl" tool used in various xfstests uses)?

Lets not use xattrs for this.
Xattrs are capped at a very tiny maximum size for the amount of data
they can store
and I suspect very complex ACLs could probably quite easily grow
beyond that limit.


>
> I was also wondering how we should display (and how to retrieve via
> SMB3) "claims based ACLs" (presumably these are reasonably common on a
> few server types like Windows)?
>
>
>
> --
> Thanks,
>
> Steve
