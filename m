Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C91BC4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Nov 2022 05:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiKIFce (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Nov 2022 00:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKIFcd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Nov 2022 00:32:33 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8340D1BE93
        for <linux-cifs@vger.kernel.org>; Tue,  8 Nov 2022 21:32:31 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id d3so24172052ljl.1
        for <linux-cifs@vger.kernel.org>; Tue, 08 Nov 2022 21:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=figGJPMMPFgeNmir/olEn2k1cJDmBqWy/n1ifxm92ws=;
        b=mxJq8tTM+49ebO1SNcPPI50Fh2lrJ1xva620WSeHEwphDrpWIkpmNWS0kOJgHGWxo/
         ZdGyJFlWwbNpcIdYGm72nNFk22xG9/6sTEmWGwzeyjWH0lkv1NvddzdYOiJffdDBIDfa
         et+6LoTz03aKnTzvJ56SGjY80mX9SmZArwge/+mP/TuRxvYOdtcpEyO2cDyCr+iGnw10
         EEYPoXhwCsnNQOhgAYdRyq0ut6o9fVTOX4zRw3xP7L4h7VaBfw78+dCsTPDYbXmURdSr
         MejE6yGeEfzahX5Ns9uFg4lxFTNRVR+G1X2Qwbtxx8Ycx3m8no+Cy9Us31XY+3u3PeaA
         uhlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=figGJPMMPFgeNmir/olEn2k1cJDmBqWy/n1ifxm92ws=;
        b=AigH1vXJk+AMIzZ85GiLVkaOy0JWsIINedvY4Mdh+Fil49/QuO1AK6ktM7oDpsk3/b
         18hXRRHapRaAk+3U1bHvZr9xncFVu0aMUcdXGaR870YpPa91HlZYIEPPVBSoiSfoj3uc
         hp4Bt2wnSJ85r0RfMurexk88CrDu9eQCkUJMXmFmO7vPdM1E1A5/zEigyw0NER+UW828
         ZR8NuHOB+Fnd9OiehtMdMRE2yeW/In4Z6+rIyB4ucyFqAHV2w5EmyhKasYdLl+oKVt/g
         iwZX9LV95xFSWBcNy/3cr8CKJUF82Q+owiGIDiM4O87zLPde2xIRBy0PdbMAxi9zh1vA
         Wv3Q==
X-Gm-Message-State: ACrzQf1xH/HAdMSoipSmDJ86UbnAyz1cM9J8ky4zOYJjPiNk8/Q+xwH8
        QwvrR+1Cm+sswqNWKcMP2/AIkFL59GnlgvEY0TI=
X-Google-Smtp-Source: AMsMyM68wK/WnFvSt/gGPZWYQBH7QF0VIsVrzjNyPWoNOAiOtQo7gGHnJ20BHbPf60+QZ+wcLsVACdKUllGwYW80IOE=
X-Received: by 2002:a2e:8541:0:b0:261:b44b:1a8b with SMTP id
 u1-20020a2e8541000000b00261b44b1a8bmr21391029ljj.46.1667971949594; Tue, 08
 Nov 2022 21:32:29 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muCMfv4HuPw6sEgKj3Ude3cz+-NRdxDXpJr3CNtUAnm7A@mail.gmail.com>
 <CAN05THQ_C_mqq-S69f53EZQUxB2Q3rNrnVU-vRH_6kt=M0-Uwg@mail.gmail.com>
 <CAH2r5mu5cTX2gWhoyUBbkLeTtJeVvOH0vn_j_5DNwQ2__Rh38w@mail.gmail.com>
 <CAN05THRpHkXnx8NqjdEb=4BcxwsK7u+jYDSTEHdHXX_c5OZmYg@mail.gmail.com>
 <CAN05THSBzu7fgXSybe4isLGPRYxWLkZDZb_Lmox3TneAQfVP=g@mail.gmail.com>
 <CAKYAXd8OwkEt=fJZrtooba_OYorBt4kEg68DrLJN=0OjQhkrjQ@mail.gmail.com>
 <CAH2r5mt08V-RQa8=apT-fAqXxQtKkj_9XNSMFvUBm=da-UMyCg@mail.gmail.com> <abbe9909-5bf6-23d0-3c86-4c7e98e8eea9@talpey.com>
In-Reply-To: <abbe9909-5bf6-23d0-3c86-4c7e98e8eea9@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 9 Nov 2022 11:02:18 +0530
Message-ID: <CANT5p=qEWs8WTJQ1h0Wgrs3D5KVL3V_T0+p=yo4X=gOD1jvKfg@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix oplock breaks when using multichannel
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Oct 29, 2022 at 6:18 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 10/28/2022 10:29 PM, Steve French wrote:
> > thx for testing this  - Shyam's fix for it looks promising (needs
> > review though and some testing)
>
> Good, because the original fix confuses me deeply. A tcon is not tied
> to a connection, or at least, it never should be. It's a property of
> the session, which is shared among multichannel connections. So if we
> have to poke at other connections to find a tcon, that's a fundamental
> issue.
>
> Shyam's fix always simply looks on the primary channel, which works,
> but it's weird relative to the protocol. The real fix would be to hang
> the tcon off the proper object.

The reference to the primary channel there is to just get to the
session (and from there, the tcon) lists, which only hang off the
primary channel today. I'm not sure why this choice was made by
Aurelien originally, but that is how it can be fixed with minimal
changes today.
Ideally, each channel should point to the session list (taking the
necessary reference), and hence the tcons.

Also, we should be able to share connections between sessions. Today,
the secondary channels are used exclusively by one session.
I plan to get to that next.

>
> Ronnie asked:
>
>  > What does MS-SMB2.pdf say about channels and oplocks?
>
> Oplocks are not tied to channels, they're tied to sessions, tree
> connects and files. An oplock can be granted on one channel and be
> valid client-wide. And broken on any channel too btw.
>
> Tom.
>
> > On Fri, Oct 28, 2022 at 5:30 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
> >>
> >> 2022-10-28 18:19 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
> >>> On Fri, 28 Oct 2022 at 16:55, ronnie sahlberg <ronniesahlberg@gmail.com>
> >>> wrote:
> >>>>
> >>>> On Fri, 28 Oct 2022 at 16:53, Steve French <smfrench@gmail.com> wrote:
> >>>>>
> >>>>> I haven't tried a scenario to windows where we turn off leases and force
> >>>>> server to use oplocks but with ksmbd that is the default.
> >>>>> Worth also investigating how primary vs secondary works for finding
> >>>>> leases for windows case
> >>>>
> >>>> Yes. Until we know what/how windows does things and what ms-smb2.pdf
> >>>> says  we can not know if this is a cifs client bug or a ksmbd bug.
> >>>
> >>> So lets wait with this patch until we know where the bug is.
> >>> I will review it later for locking correctness, but lets make sure it
> >>> is not a ksmbd bug first.
> >> We can reproduce it against samba with the following parameters.
> >>
> >> server multi channel support = yes
> >> oplock break wait time = 35000
> >> smb2 leases = no
> >>
> >>>
> >>>
> >>>>
> >>>>
> >>>>>
> >>>>> On Fri, Oct 28, 2022, 01:48 ronnie sahlberg <ronniesahlberg@gmail.com>
> >>>>> wrote:
> >>>>>>
> >>>>>> On Fri, 28 Oct 2022 at 16:25, Steve French <smfrench@gmail.com> wrote:
> >>>>>>>
> >>>>>>> If a mount to a server is using multichannel, an oplock break
> >>>>>>> arriving
> >>>>>>> on a secondary channel won't find the open file (since it won't find
> >>>>>>> the
> >>>>>>> tcon for it), and this will cause each oplock break on secondary
> >>>>>>> channels
> >>>>>>> to time out, slowing performance drastically.
> >>>>>>>
> >>>>>>> Fix smb2_is_valid_oplock_break so that if it is a secondary channel
> >>>>>>> and
> >>>>>>> an oplock break was not found, check for tcons (and the files
> >>>>>>> hanging
> >>>>>>> off the tcons) on the primary channel.
> >>>>>>
> >>>>>> Does this also happen against windows or is is only against ksmbd this
> >>>>>> triggers?
> >>>>>> What does MS-SMB2.pdf say about channels and oplocks?
> >>>>>>
> >>>>>>>
> >>>>>>> Fixes xfstest generic/013 to ksmbd
> >>>>>>>
> >>>>>>> Cc: <stable@vger.kernel.org>
> >>>>>>>
> >>>>>>>
> >>>>>>> --
> >>>>>>> Thanks,
> >>>>>>>
> >>>>>>> Steve
> >>>
> >
> >
> >



-- 
Regards,
Shyam
