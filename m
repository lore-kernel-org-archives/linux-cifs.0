Return-Path: <SRS0=Y4Lp=XS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59799C3A5A6
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Sep 2019 06:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2813020882
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Sep 2019 06:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hCjl/Ax5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393331AbfIWGww (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Sep 2019 02:52:52 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33489 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393326AbfIWGww (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 Sep 2019 02:52:52 -0400
Received: by mail-io1-f68.google.com with SMTP id z19so8642091ior.0
        for <linux-cifs@vger.kernel.org>; Sun, 22 Sep 2019 23:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z85QrtkGcybx2b7mPXz0O23AYigzi/Zd3Z2RbqgHVGA=;
        b=hCjl/Ax5byXja50PYSgB66pmp4MFMh8ZogEacH1NpwcieCAOcymhiowMfjMvJHgU7P
         7ceCWtf5qqrXrz4YjJU0QuNS7opXlVXSKrNx//9QgbVo6IIo/Yl7ON5lnZxHNq4SDDZI
         IFaMM56xuu9XOTPIQNHoOgPXl8sGFf8aR7267sl3mAJ0J2AAudyhAWNnb12HYTvCZHbn
         G+mor/w7O5Ucm7QXIpzguS7Qu06762xTCD5KF7Z8nJUa2GuATx3txPnVSmdBA7tBilYb
         F+UoxF4ZglHVTaTKVJMOnDYBFGM9r15njcZvB0g9pMKPedJh3VJCz6SBB0TXJyYmYhod
         dHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z85QrtkGcybx2b7mPXz0O23AYigzi/Zd3Z2RbqgHVGA=;
        b=mIHr4Xo1b0anITKZgAqNoRgaAWDcz1EPbSktDgnXRiVCMH1hb+KLbbVsCs5kxeg6zj
         UOTC7Z9ET1yzutnA/+TyDUAaIUlIwwKpOuqSehF9BC5p8oROcV5uSoCXiQOiY744+eiT
         2Rv5l4DARTkd7QgP6FPeXAC158evkjGBb84XY20lXf1L2mwqd7U9OvKEYu6ZTqJW9HlB
         hkfCFG+OmRvdfNIy+DADTdvKt2nLTWeTVddEU0SxPw++Gqzl9T2b+hMsPB/FSZ+LgnTs
         inOIJakSVgZLYI5V0myFBfCxVsJaNC6qkfcYSLTAmhl7OaP1esonvGeid9OPqszZg1Nt
         JwuQ==
X-Gm-Message-State: APjAAAVRILj+/9QxFXoom2AKriI5zCLnboqaPwgs2bQNAUBEMfrk4DnQ
        HEFpl3JP671f0HauZrzf/hQbZ1Qz1o5C3bo2IO88FDAk
X-Google-Smtp-Source: APXvYqycjrGPqZzZOnBD/ekxnDNkKaVcWo58zx3XzgaC/bN6VdxEeurAEOVNl7ZkgRY+m3oyDhoX5SeHi9WiGH1M0FQ=
X-Received: by 2002:a6b:2b07:: with SMTP id r7mr12851629ior.173.1569221571623;
 Sun, 22 Sep 2019 23:52:51 -0700 (PDT)
MIME-Version: 1.0
References: <1569046966-118677-1-git-send-email-zhengbin13@huawei.com>
 <CAH2r5mu+ytpDOcq4Au2AZe7M00p3XJnBVD2wO949G7Ud5bp=dQ@mail.gmail.com>
 <65f0ed75-045d-6b07-609c-a23d747d99f3@huawei.com> <CAH2r5mtfEnA-E0xLi+C1PvaFOFbByT_UHjRO_CS4MbKpZipnkA@mail.gmail.com>
 <6de8d563-b6eb-7ee3-291a-2b98ab1aaf14@huawei.com>
In-Reply-To: <6de8d563-b6eb-7ee3-291a-2b98ab1aaf14@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 23 Sep 2019 01:52:40 -0500
Message-ID: <CAH2r5msa7MORuPw==zGk_dE7+iLd21cORpqg4UEhntw7sSQ+WA@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/smb2transport.c: Make some functions static
To:     "zhengbin (A)" <zhengbin13@huawei.com>
Cc:     "zhangyi (F)" <yi.zhang@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes - notify init should be static - but not SMB2_notify

On Mon, Sep 23, 2019 at 1:48 AM zhengbin (A) <zhengbin13@huawei.com> wrote:
>
>
> On 2019/9/23 14:33, Steve French wrote:
> > The code to call SMB2_change_notify (from an ioctl) should make it in
> > pretty soon (let's hope we can finish testing it this  week).   The
> > fix to inotify to allow inotify to call into a network file system
> > will be helpful in the long run, but in the short term at least a GUI
> > should be able to call into a cifs.ko specific ioctl soon for it.
> Thus SMB2_notify_init should be static? I send a patch later?
> >
> > On Mon, Sep 23, 2019 at 1:08 AM zhengbin (A) <zhengbin13@huawei.com> wr=
ote:
> >>
> >> On 2019/9/23 13:07, Steve French wrote:
> >>> Thanks - merged into cifs-2.6.git for-next
> >>>
> >>> Aur=C3=A9lien -
> >>> FYI - it makes minor update to code you changed to remove the warning=
.
> >> We have a similar warning in fs/cifs/smb2pdu.c
> >>
> >> fs/cifs/smb2pdu.c:3184:1: warning: symbol 'SMB2_notify_init' was not d=
eclared. Should it be static?
> >> fs/cifs/smb2pdu.c:3213:1: warning: symbol 'SMB2_change_notify' was not=
 declared. Should it be static?
> >>
> >>
> >> while these two functions are introduced by commit af8d46ab49b8
> >>
> >> ("smb3: add missing worker function for SMB3 change notify"). SMB2_not=
ify_init is called by SMB2_change_notify
> >>
> >> No one calls  SMB2_change_notify? Or we will call SMB2_change_notify i=
n the future?
> >>
> >>>
> >>> On Sun, Sep 22, 2019 at 2:13 PM zhengbin <zhengbin13@huawei.com> wrot=
e:
> >>>> Fix sparse warnings:
> >>>>
> >>>> fs/cifs/smb2transport.c:52:1: warning: symbol 'smb3_crypto_shash_all=
ocate' was not declared. Should it be static?
> >>>> fs/cifs/smb2transport.c:101:4: warning: symbol 'smb2_find_chan_signk=
ey' was not declared. Should it be static?
> >>>> fs/cifs/smb2transport.c:121:17: warning: symbol 'smb2_find_global_sm=
b_ses' was not declared. Should it be static?
> >>>>
> >>>> Reported-by: Hulk Robot <hulkci@huawei.com>
> >>>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> >>>> ---
> >>>>  fs/cifs/smb2transport.c | 7 ++++---
> >>>>  1 file changed, 4 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> >>>> index 12988df..7cc8641 100644
> >>>> --- a/fs/cifs/smb2transport.c
> >>>> +++ b/fs/cifs/smb2transport.c
> >>>> @@ -48,7 +48,7 @@ smb2_crypto_shash_allocate(struct TCP_Server_Info =
*server)
> >>>>                                &server->secmech.sdeschmacsha256);
> >>>>  }
> >>>>
> >>>> -int
> >>>> +static int
> >>>>  smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
> >>>>  {
> >>>>         struct cifs_secmech *p =3D &server->secmech;
> >>>> @@ -98,7 +98,8 @@ smb311_crypto_shash_allocate(struct TCP_Server_Inf=
o *server)
> >>>>         return rc;
> >>>>  }
> >>>>
> >>>> -u8 *smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_=
Info *server)
> >>>> +static u8 *
> >>>> +smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_Info=
 *server)
> >>>>  {
> >>>>         int i;
> >>>>         struct cifs_chan *chan;
> >>>> @@ -118,7 +119,7 @@ u8 *smb2_find_chan_signkey(struct cifs_ses *ses,=
 struct TCP_Server_Info *server)
> >>>>         return NULL;
> >>>>  }
> >>>>
> >>>> -struct cifs_ses *
> >>>> +static struct cifs_ses *
> >>>>  smb2_find_global_smb_ses(__u64 ses_id)
> >>>>  {
> >>>>         struct TCP_Server_Info *server;
> >>>> --
> >>>> 2.7.4
> >>>>
> >
>


--=20
Thanks,

Steve
