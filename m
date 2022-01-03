Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680CBC433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jan 2022 18:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbiACSZN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Jan 2022 13:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbiACSZN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Jan 2022 13:25:13 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725DDC061761
        for <linux-cifs@vger.kernel.org>; Mon,  3 Jan 2022 10:25:13 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id x6so41105071iol.13
        for <linux-cifs@vger.kernel.org>; Mon, 03 Jan 2022 10:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WQM6NkYf8w5RZh5by65LWjSlOEwA6UQEhcnv6PETkkc=;
        b=Fp/wj7Nv4OzciEZYV4nC0uZNBQGGmAzEa4VMsxWHkzF3Va/Jr3DMDsk6MitMU32s25
         KphHPYDeZyXVJEnBbKVEHEcPzJObUEEVY8rx9RYpufKKQ7CFr6qN/li8BC8IIrgZffCn
         Kce5TWEBp1wUavxGd2M2f7QWSPQVVMMfKh8CYXMICXWhZPsdszZhWavqVjWXTc66uKDz
         aeKBFArSgys9FeQirLEcpfba+oVk0TmiByblHQ3lEk9iDSExkaHF31F5PbLp5xNiUagP
         JwYSXMbf7Wp6SxcSkN2c92+eeHRX6UbGV6HPLwlOqGY8TpjwNN8LvGSQgv5nmN5NbIPp
         PY2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WQM6NkYf8w5RZh5by65LWjSlOEwA6UQEhcnv6PETkkc=;
        b=6Yr/c3zBfQtYeY4UHSNYNuZbF3w7BbMYF9bfeDkp4MfZIzB5C7kDha1x/6rdzbhb97
         lO2Qge6TGoKIFFQF81tTpQwQ+tppM22xR3PF3FRBIGS4zText5s+qxtfJHRelf5aZZJ5
         8RvA502RNoUiRbXpbGQgs1q7lKtSTkit2Rf/+xr5wtLrVZrxNPmOuainMtXJzQxTeaDb
         G31lY2v0RSWrTkrpLSfQy5Sqp8z86Q6765+mPoxZVsEfGXuB7o+P/AKtrzG5TjwXqp7S
         hUnUKQ/zQdUkqTa8pMQIj3DAH/QEJYkHZqPy7jRt/CSM01xMNgcOFJLmNprFgyUR3r8G
         QlYw==
X-Gm-Message-State: AOAM531D7Kz/U0bRfIe5c/1zAUw5Aimr/wMeL73s94aq+nbtibuHkXcK
        fCbLnOLho0HiQ5tHAxvMfN8o2PhnDHxniQ2/1Sc=
X-Google-Smtp-Source: ABdhPJz0ndd6Shfi2XVeS2RyUMvvp881O4TZ1OmoiL8HVf/SRr5TD97rwrLb3f1K/sLVTyaM4MYRW5RdpeBu91RbgFI=
X-Received: by 2002:a05:6638:160c:: with SMTP id x12mr22541684jas.1.1641234312246;
 Mon, 03 Jan 2022 10:25:12 -0800 (PST)
MIME-Version: 1.0
References: <20220103145025.3867146-1-amir73il@gmail.com> <69FC68E2-31C6-493A-BC60-ED1DF5860FC2@amazon.com>
In-Reply-To: <69FC68E2-31C6-493A-BC60-ED1DF5860FC2@amazon.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 3 Jan 2022 20:25:01 +0200
Message-ID: <CAOQ4uxjY3b5_1WCL3hpy27h3VkGfH1+6BTKF35aXexjuFvE+cA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix set of group SID via NTSD xattrs
To:     "Protopopov, Boris" <pboris@amazon.com>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jan 3, 2022 at 6:56 PM Protopopov, Boris <pboris@amazon.com> wrote:
>
> Hello, Amir,
>
> It has been a while, but I recall that from my reading of the MS docs, th=
e notion of "owner" was supposed to include both user and the primary group=
 SIDs, which is why the comments in the code did not call out groups explic=
itly.
> I also recall that during development, I tested with CIFS_ACL_GROUP flag =
against Windows 2012 and 2019 servers, and did not see a difference. I did =
not test against Samba, which clearly, showed an issue discussed below.

Interesting.
I admit that the language of the docs is ambiguous:
https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/ee9614=
c4-be54-4a3c-98f1-769a7032a0e4
"...flags indicating what security attributes MUST be applied".
So attributes whose flag is not set (e.g. group SID) MAY be applied or
MUST NOT be applied?
Perhaps samba would want to be as relaxed as Windows about the ACL_GROUP fl=
ag.

In any case, I don't see a reason not to set the flag when the group
SID information
is present.

Thanks,
Amir.

>
> Boris.
>
> =EF=BB=BFOn 1/3/22, 9:51 AM, "Amir Goldstein" <amir73il@gmail.com> wrote:
>
>     CAUTION: This email originated from outside of the organization. Do n=
ot click links or open attachments unless you can confirm the sender and kn=
ow the content is safe.
>
>
>
>     'setcifsacl -g <SID>' silently fails to set the group SID on server.
>
>     Actually, the bug existed since commit 438471b67963 ("CIFS: Add suppo=
rt
>     for setting owner info, dos attributes, and create time"), but this f=
ix
>     will not apply cleanly to kernel versions <=3D v5.10.
>
>     Fixes: a9352ee926eb ("SMB3: Add support for getting and setting SACLs=
")
>     Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>     ---
>
>     Boris,
>
>     I am a little confused from the comments in the code an emails.
>     In this thread [1] you wrote that you tested "setting/getting the own=
er,
>     DACL, and SACL...".
>
>     Does it mean that you did not test setting group SID?
>
>     It is also confusing that comments in the code says /* owner plus DAC=
L */
>     and /* owner/DACL/SACL */.
>     Does it mean that setting group SID is not supposed to be supported?
>     Or was this just an oversight?
>
>     Anyway, with this patch, setcifsacl -g <SID> works as expected,
>     at least when the server is samba.
>
>     Thanks,
>     Amir.
>
>
>     [1] https://lore.kernel.org/linux-cifs/CAHhKpQ7PwgDysS3nUAA0ALLdMZqnz=
G6q6wL1tmn3aqOPwZbyyg@mail.gmail.com/
>
>      fs/cifs/xattr.c | 2 ++
>      1 file changed, 2 insertions(+)
>
>     diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
>     index 7d8b72d67c80..9d486fbbfbbd 100644
>     --- a/fs/cifs/xattr.c
>     +++ b/fs/cifs/xattr.c
>     @@ -175,11 +175,13 @@ static int cifs_xattr_set(const struct xattr_ha=
ndler *handler,
>                                     switch (handler->flags) {
>                                     case XATTR_CIFS_NTSD_FULL:
>                                             aclflags =3D (CIFS_ACL_OWNER =
|
>     +                                                   CIFS_ACL_GROUP |
>                                                         CIFS_ACL_DACL |
>                                                         CIFS_ACL_SACL);
>                                             break;
>                                     case XATTR_CIFS_NTSD:
>                                             aclflags =3D (CIFS_ACL_OWNER =
|
>     +                                                   CIFS_ACL_GROUP |
>                                                         CIFS_ACL_DACL);
>                                             break;
>                                     case XATTR_CIFS_ACL:
>     --
>     2.25.1
>
>
