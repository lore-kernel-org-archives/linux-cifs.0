Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65926C77B7A
	for <linux-cifs@archiver.kernel.org>; Sat, 27 May 2023 01:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjE0BuY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 May 2023 21:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjE0BuY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 May 2023 21:50:24 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CB8F3
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 18:50:22 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2af177f12d1so14233001fa.0
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 18:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685152220; x=1687744220;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpZgqZg+kBm2WUGSX2QGnSQmGiuF2EmK2iiEE2sNjvI=;
        b=LQgnILsCXixQZtTvT+ryRMvHs3UxE5Nq/4qDlecOkcgzOr7k9AqdOk3oHQfP8IkH3+
         WfF4DvM9uCP8kuzyDAbmB2LyNb+OX1peiLnUfBy4G9xkvlDWORbLbEv1pebK9VNMwL/8
         Kgh44dh9r1Q1GpW5NyH7TAN49uRfrVtVIfqYQ/7IhRdPWi52e7fqvL5fsQpuJPS4IhiR
         Xo+Qhz+t6gDEnWCdv3WC6+DRov6FtUDq9bUX/WXOccqFczvq7Oez77JKjsyKJ/ymGppx
         PXa/J56v+zG3A/ChPPCrZQNN4BMo4Bziz4YGmXhCY1GPfEJzdUdn/LdzB+McVqaLxWQ3
         NNkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685152220; x=1687744220;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LpZgqZg+kBm2WUGSX2QGnSQmGiuF2EmK2iiEE2sNjvI=;
        b=RTgBFaZXqlVvcEeypMiofZeCTS2BSZMxGWs/vYl3EwwIi+2G9HQAZL7XkslK96/diP
         FOjOgavCsGZQbd8eQlBuN33JseFoNR8J1qRFOuhqVxQswA16d4OKCdt91xQCuObpRPyW
         vhkOi1cjMdD66wgljWs/ngUO46TKiTFU3Opz8jfJI3DaQlaJ39zajBx6XA+KZVla5ehK
         9aGQ/JdQ5TJiQsfeLyBasbti3PibRNTFH8AlJaxofPvX31nGtsQPK8+qbCS5fDTlu9ux
         kRdwg2olzGBEJS5Kvlymz1natJoFXBmZdXT5ewJr8dwWh1gaFle7X9VOr6B/BlbV03EF
         mWZg==
X-Gm-Message-State: AC+VfDy0VR4DhzwYo4pOvaAwswd/4vqnUWI0sp3YfhWTjdqyyiIZw5Y8
        wm/EcI2JgraFiL8K4/JrxknFp1Nvt/qowhJwepo=
X-Google-Smtp-Source: ACHHUZ6J4K6jBj99WDJdTSvvrEHHAo2uLG4cZLgBiDRh5Ya5WQ2ZJrzMoJ7wnsO9kPUDMEfCdd0KtpC5OHUWsMzraIY=
X-Received: by 2002:a2e:96da:0:b0:2af:1a58:2c83 with SMTP id
 d26-20020a2e96da000000b002af1a582c83mr1174678ljj.30.1685152220266; Fri, 26
 May 2023 18:50:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop> <20230525093900.GA261009@sernet.de>
 <CAN05THTi0BC_iwjXMiWn61fg3hRemi5Momwp3O0WGygyWLGomQ@mail.gmail.com>
 <ZG+LOKTr8B+zjQsC@jeremy-rocky-laptop> <CAH2r5mv7aZ8nm30oKyYpa-bd8-MqA13EcEmQWV4mOyrV-rj8Ug@mail.gmail.com>
 <ZG/DajG6spMO6A7v@jeremy-rocky-laptop> <20230525221449.GA9932@sernet.de>
 <CAH2r5mvGb_e-kjLoKpwF3Eg7f7oOGGKcM7rL95SkU4q=pSE1AQ@mail.gmail.com>
 <20230526160320.GA13176@sernet.de> <CAH2r5muD89QUcaqWNQy5NUwyji9CinN_5kGcfFSQAbpJP5gn+A@mail.gmail.com>
In-Reply-To: <CAH2r5muD89QUcaqWNQy5NUwyji9CinN_5kGcfFSQAbpJP5gn+A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 26 May 2023 20:50:08 -0500
Message-ID: <CAH2r5mt-8fwG5h=K0qBiKY4S-7YAcJYt2HtOgb_zOxVzRvROLw@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     Steve French <smfrench@gmail.com>, Jeremy Allison <jra@samba.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, May 26, 2023 at 7:54=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
>
>
> On Fri, May 26, 2023, 06:03 Bj=C3=B6rn JACKE <bj@sernet.de> wrote:
>>
>> On 2023-05-25 at 18:50 -0500 Steve French via samba-technical sent off:
>> > Today the "RichACLs" can be displayed multiple ways (e.g. "getcifsacl"
>> > and various other
>> > tools and also via system xattrs).
>> > Being able to display "RichACLs" makes sense - and I am fine with
>> > mapping these (and
>> > probably would make sense to at least have a readonly mapping of the
>> > existing richacls on
>> > a file to "posixacl") and RichACLs are very important.
>> >
>> > Wouldn't it be easier to let them also be queried for cifs.ko via
>> > "system.getrichacl" (or whatever
>> > the "getrichacl" tool used in various xfstests uses)?
>> >
>> > I was also wondering how we should display (and how to retrieve via
>> > SMB3) "claims based ACLs" (presumably these are reasonably common on a
>> > few server types like Windows)?
>>
>> let's stop calling them RichACLs becuase that was only the name that And=
reas
>> Gr=C3=BCnbacher was giving his implementation of the NFS4 ACLs

The name "richacls" looks like it is embedded in the standard
filesystem functional tests
(to pass xfstests generic/362 through generic/370 requires this - so I
would have to finish
off the mapping of this richacl pseudo-xattr query to the SMB3.1.1 get
acl query over the wire).
It doesn't look too bad, and it would.   Most users would probably use
the normal
tools (like getcifsacl or even Samba's "smbcacls" user space tool or
the pseudo-xattr
e.g. system.cifs_ntsd_full) but if it helps to use a common format
that helps ntfs and nfsv4.1 and later
that is fine with me.


> Remember that at Connectathon conferences years ago when nfs4.1 ACLS were=
 explained  (fixing NFS 4 ACLS to address some missed things). The NFS ACL =
ideas were modelled after smb ACLs so NFS ACLs have many similarities to th=
eir predecessor SMB ACLs (although presumably do not support claims based A=
CEs/CBAC/DAC yet)



--=20
Thanks,

Steve
