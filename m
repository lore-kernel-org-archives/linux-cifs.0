Return-Path: <SRS0=9w6c=D5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE86FC4363A
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 17:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 015BD24630
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 17:25:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XfEVaaXB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899719AbgJVRZC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Oct 2020 13:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2899710AbgJVRZC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Oct 2020 13:25:02 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9676C0613CE
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 10:25:01 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id m16so2789147ljo.6
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 10:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EpQmqnvSoJ61ab70do51j6Sf7KJdEtsCoutHnGrO1Nw=;
        b=XfEVaaXB9vCzGTTlGW6TDY9/9kLVZnYF5TZfj85fSVroa28Cm99+TmlMCUOn80PJiH
         xYhscParSQxWXXClN2Pg6iPmA4YwWI20BGrKB8kZ6s/sGQENxeTCGY5whW4LpLGbd6+V
         rDvTCBvym8PLcVlGK8Nu52YkmuMaq5G24XWbxb5eFFBgBbwlzoDopXR1yJOKRn82Tfgf
         NAYEbxJ7m2e+eigF/bGDLGoWlnNIj/GnOJ2f63qq+g+Rc9pev6SejvdVb38Ji9adHXCW
         w2nVXFpR5VRJjSxcGvJ9TCAd50cjxdz4KbfIE8TcM9frj5t0/rBt4StPqwDndu3lMTDN
         Riew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EpQmqnvSoJ61ab70do51j6Sf7KJdEtsCoutHnGrO1Nw=;
        b=Z5i6j+OyelfPZsCAPolxgdxZDOKe4iid4V+W/ua3JVELYPM03idQPxqXylQvMzxDzB
         +vHBATygn7ai1hRLThLWXhGYBP/GwgnmD2OnU6qMowrfFf1aJbUosk0fHGf5vKhiH4/b
         fMoNWbq1elwclqYlxyzBkVlahr9VjnpJVK5FoWdyDUy16DIp07przNREOjFRtDXeje83
         ARHvYfzg3k1nm3GARa7lTnxkHkTaT39J6v8YE+FhcKFYoJ1hbbD4qOrVYkwfHH6B202p
         abNNfdMjGKmzpH6cnXoXj8QLm5GzdX7SM+cECFiyvXvbJ0B2AXO1jZgdOVA7n4W6rUi9
         2bzg==
X-Gm-Message-State: AOAM530P1bLLg8ihwCG5ur+H3uabNRA5f3fzcN1a/K+tTodXj3/L0M7P
        AepfYoUxjmVagW4AELBnq1yG2VYkTiOSll9Pl5I=
X-Google-Smtp-Source: ABdhPJylndIuBbo6cmC69yRErHDIHF0EJUO1Y9OMAetro43WUP1Dm/+WXY8wtIGFzIDoMWMdT2yqVdgcUhKNWy6083A=
X-Received: by 2002:a05:651c:2db:: with SMTP id f27mr1329791ljo.394.1603387500113;
 Thu, 22 Oct 2020 10:25:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtAOxF=PCndMTXxj_dZVLc-NQJfoawOvMeS3FbxiCU6xw@mail.gmail.com>
 <87eelzho1b.fsf@suse.com> <CAH2r5mvdOBeLJsPZRqj1O8UU24aUxhc-cWEWO+8RAW9fPzYSJg@mail.gmail.com>
 <CAH2r5msGP-=qow2A3eJPiHg-CaNCM+6cvfbP9=_z3ZJSeU9UKw@mail.gmail.com>
 <CAH2r5muN34JRZOxsG2+jvh9F8X9E7Lb85gmQud6MJKR43qKZyA@mail.gmail.com> <1743629c-c183-fab9-1bcf-89dbcec2c53f@samba.org>
In-Reply-To: <1743629c-c183-fab9-1bcf-89dbcec2c53f@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 22 Oct 2020 12:24:48 -0500
Message-ID: <CAH2r5mvtJK53iP86WGiaN0DE12ygDboWRkdL7TSafTdQ-bcSxQ@mail.gmail.com>
Subject: Re: Add support for GCM256 encryption
To:     Stefan Metzmacher <metze@samba.org>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The patch series is missing the final piece (the small change to
encryption related parms), because I was waiting to test that part
with Pavel.  I did verify the negotiation works fine to the newest
Windows download mentioned earlier but also wanted to try it to Azure
and expect the final change needed to be small.  I had also been
trying to focus on the larger changes needed during the merge window
and finish the final piece off next week of this one.


On Thu, Oct 22, 2020 at 7:59 AM Stefan Metzmacher <metze@samba.org> wrote:
>
> Am 16.10.20 um 06:45 schrieb Steve French:
> > Redid patch 5 (includes Aurelien's suggestion, fixes a typo and fixes
> > a problem with vers=3D3.0 mounts) - attached.
> >
> > On Thu, Oct 15, 2020 at 12:41 PM Steve French <smfrench@gmail.com> wrot=
e:
> >>
> >> found another typo in patch 5 ccm instead of gcm - fixing it now
> >>
> >> On Thu, Oct 15, 2020 at 11:33 AM Steve French <smfrench@gmail.com> wro=
te:
> >>>
> >>> Good point.  Updated patches attached.  Also added a one line comment
> >>> to smb2pdu.h mentioning why we don't request AES_256_CCM
> >>>
> >>>
> >>> On Thu, Oct 15, 2020 at 3:49 AM Aur=C3=A9lien Aptel <aaptel@suse.com>=
 wrote:
> >>>>
> >>>> Hi Steve,
> >>>>
> >>>> Patch 2:
> >>>>
> >>>>> From 3897b440fd14dfc7b2ad2b0a922302ea7705b5d9 Mon Sep 17 00:00:00 2=
001
> >>>>> From: Steve French <stfrench@microsoft.com>
> >>>>> Date: Wed, 14 Oct 2020 20:24:09 -0500
> >>>>> Subject: [PATCH 2/5] smb3.1.1: add new module load parm enable_gcm_=
256
> >>>>> --- a/fs/cifs/smb2pdu.h
> >>>>> +++ b/fs/cifs/smb2pdu.h
> >>>>> @@ -361,8 +361,9 @@ struct smb2_encryption_neg_context {
> >>>>>       __le16  ContextType; /* 2 */
> >>>>>       __le16  DataLength;
> >>>>>       __le32  Reserved;
> >>>>> -     __le16  CipherCount; /* AES-128-GCM and AES-128-CCM */
> >>>>> -     __le16  Ciphers[2];
> >>>>> +     /* CipherCount usally 2, but can be 3 when AES256-GCM enabled=
 */
> >>>>> +     __le16  CipherCount; /* AES128-GCM and AES128-CCM by defalt *=
/
> >>>>
> >>>> Typo defalt =3D> default
> >>>>
> >>>>> +     __le16  Ciphers[3];
> >>>>>  } __packed;
> >>>>>
> >>>>>  /* See MS-SMB2 2.2.3.1.3 */
> >>>>> --
> >>>>> 2.25.1
> >>>>>
> >>>>
> >>>> Patch 5:
> >>>>
> >>>>> From 314d7476e404c37acb77c3f9ecc142122e7afbfd Mon Sep 17 00:00:00 2=
001
> >>>>> From: Steve French <stfrench@microsoft.com>
> >>>>> Date: Fri, 11 Sep 2020 16:47:09 -0500
> >>>>> Subject: [PATCH 5/5] smb3.1.1: set gcm256 when requested
> >>>>>
> >>>>> update code to set 32 byte key length and to set gcm256 when reques=
ted
> >>>>> on mount.
> >>>>>
> >>>>> Signed-off-by: Steve French <stfrench@microsoft.com>
> >>>>> ---
> >>>>>  fs/cifs/smb2glob.h      |  1 +
> >>>>>  fs/cifs/smb2ops.c       | 20 ++++++++++++--------
> >>>>>  fs/cifs/smb2transport.c | 16 ++++++++--------
> >>>>>  3 files changed, 21 insertions(+), 16 deletions(-)
> >>>>>
> >>>>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> >>>>> index dd1edabec328..d8e74954d101 100644
> >>>>> --- a/fs/cifs/smb2ops.c
> >>>>> +++ b/fs/cifs/smb2ops.c
> >>>>> @@ -3954,7 +3954,12 @@ crypt_message(struct TCP_Server_Info *server=
, int num_rqst,
> >>>>>
> >>>>>       tfm =3D enc ? server->secmech.ccmaesencrypt :
> >>>>>                                               server->secmech.ccmae=
sdecrypt;
> >>>>> -     rc =3D crypto_aead_setkey(tfm, key, SMB3_SIGN_KEY_SIZE);
> >>>>> +
> >>>>> +     if (require_gcm_256)
> >>>>> +             rc =3D crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPT=
KEY_SIZE);
> >>>>
> >>>> Shouldn't the check be on server->cipher_type?
> >>>>
> >>>>> +     else
> >>>>> +             rc =3D crypto_aead_setkey(tfm, key, SMB3_SIGN_KEY_SIZ=
E);
> >>>>> +
>
> You still just use u8 key[SMB3_SIGN_KEY_SIZE];
>
> Shouldn't smb2_get_enc_key() get the buffer size and return the size actu=
ally used?
>
> I also don't see where you setup the 32 byte encryption/decryption keys f=
rom
> the authentication session key?
>
> [MS-SMB2] 3.3.5.5.3 Handling GSS-API Authentication point 11.)
> specifies that the full authentication session key should be used as key =
derivation key
> for AES256 (NTLMSSP always returns 16 bytes, kerberos can return 16 or 32=
 bytes).
> 3.3.1.8 Per Session says the resulting keys should be 256-bit (32 bytes) =
for AES-256.
>
> I don't see any of this in your patchset.
>
> Did you actually tested this successful against a Windows Server?
>
> Can you use 'git format-patch --stdout > patches.txt' and attach patches.=
txt
> as inline text attachment? Or use git send-email ...
> Individual randomly sorted non text/plain attachments are very hard to co=
mment on
> (at least for me).
>
> metze
>


--
Thanks,

Steve
