Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10181C7EE23
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Mar 2023 01:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjCBBt2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Mar 2023 20:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCBBt1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Mar 2023 20:49:27 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F9C3866D
        for <linux-cifs@vger.kernel.org>; Wed,  1 Mar 2023 17:49:26 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id g17so20201882lfv.4
        for <linux-cifs@vger.kernel.org>; Wed, 01 Mar 2023 17:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2EvutdPIZw6OKgsWKoXGVzYu5Tg8WZTYz3bsspnRlIw=;
        b=FvgYwkirchvjnHNedbRrQWHZHEYv2PzS4yUdcgCdZOikqhqKW3EwZFw3U7PVW65Mxo
         kYvJqk+ON0ZHhAkGm3Du5umyRD2qUJcubwZaWozCjnpvS7tXtQIxUc9Keb+u3oWO9+fw
         2wyQm9UXRudgzQWOZwUpOAdoTHNesk4PerSj4moLaOU1ocp17nQ0qS5Tv+93Jjbk2JkV
         DCU57rwrZ49CTD4JxAku/ktzuNAuLwtssrjrz7SnwUD/lq+mJ6ZpmBQ6lzQKgbhN+Ec4
         mZXNG14AAwAqVkQ1iM71XWN/A6NNj7FwXDgCgUoCqOV3+uDGwQOIqb/lMAJVunFYomz7
         iJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2EvutdPIZw6OKgsWKoXGVzYu5Tg8WZTYz3bsspnRlIw=;
        b=v/0fxZdhYrAWwnew7goH76ytF8c+9VaGcuUjVRIJz303pGJOdMV/+dII5zow9DjcVj
         p6lhED/jKRti7a7P7UMSu/vHgWKAnDvcYh0KjQiwTVb2XeHVKcH2C2ZfRhmwIOA+hu4C
         MYahB2C/12LLtjR+xWLkMkztLLbYK8n+M+lN02Bc0H5j90Bb/QWmarABv7tCq5Hm71pR
         6F3ilvTFSrQCnGTZBhqZUVesA1yxHC0BUTmaz2gBx/8Ov/Uh8cn0Z40tD0ztjvoygwyf
         jsDgQOnf41+Y0n5F075GxnhIXg4xJLzMvKLynoPxcsrOg6cZgswy6iaItbM19pi8SWK6
         rZKw==
X-Gm-Message-State: AO0yUKWnqAXAw0Pu8H7k/8k9/XpTi1xUxDqCtO/5EyjhDWGidAdKqTek
        07DvBW1fVs7yiXlVGUzgiQO5YXZn/JvIEACqHqt5bkYr
X-Google-Smtp-Source: AK7set8N8H9x+KErVm4rC29ZA/0wnB4f4lcM92JoOfDf9V99p0NH3wjPyoa1o3cEi57p483c7OyyEehIGt1ZMasT0bs=
X-Received: by 2002:ac2:5451:0:b0:4d5:ca32:6ae4 with SMTP id
 d17-20020ac25451000000b004d5ca326ae4mr2466646lfn.4.1677721764782; Wed, 01 Mar
 2023 17:49:24 -0800 (PST)
MIME-Version: 1.0
References: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
 <514a3d90d263bd8422e9d13bd4c6e269.pc@manguebit.com> <CAB5c7xrdKSO4YE_vUQ6tg+p=WwxEdquj+VrRpwKxi8Jd0vPyAQ@mail.gmail.com>
In-Reply-To: <CAB5c7xrdKSO4YE_vUQ6tg+p=WwxEdquj+VrRpwKxi8Jd0vPyAQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 1 Mar 2023 19:49:13 -0600
Message-ID: <CAH2r5mv52koGnKbvtRKE95c_JwwtitTXFaRc6mcM8nwLmWNo9A@mail.gmail.com>
Subject: Re: Nested NTFS volumes within Windows SMB share may result in inode
 collisions in linux client
To:     Andrew Walker <awalker@ixsystems.com>
Cc:     Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I would expect when the inode collision is noted that
"cifs_autodisable_serverino()" will get called in the Linux client and
you should see: "Autodisabling the user of server inode numbers on
..."
"Consider mounting with noserverino to silence this message"

If this is easy to setup we could try some tricks when we encounter
such a reparse point - do you have patch ideas for the client to fake
up inode numbers in this case?

On Wed, Mar 1, 2023 at 7:39=E2=80=AFPM Andrew Walker <awalker@ixsystems.com=
> wrote:
>
> On Wed, Mar 1, 2023 at 5:37=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
> >
> > Andrew Walker <awalker@ixsystems.com> writes:
> >
> > > On my Windows server I mounted multiple NTFS volumes within the same
> > > share and played around until I was able to create directories with
> > > the same fileid number.
> >
> > Did you try it with 'noserverino' mount option?  For more information,
> > see mount.cifs(8).
>
> Yes. In this case I get a unique inode number
>
> > Did it work with older kernels?
> I only tested with 5.15 kernel. Was there a different algorithm in
> older kernels that's worth testing?
>
> > Perhaps we could conditionally stop trusting file ids sent by the serve=
r
> > as we currently do for hardlinks when we see these reparse points as
> > well.
>
> Maybe fail chdir with EXDEV unless mount is with noserverino?



--=20
Thanks,

Steve
