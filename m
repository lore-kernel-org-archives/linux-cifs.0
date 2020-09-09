Return-Path: <SRS0=9Mpj=CS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5C0C433E2
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Sep 2020 17:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA7F121556
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Sep 2020 17:25:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UYkxOpcL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgIIRZR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Sep 2020 13:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgIIRZP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Sep 2020 13:25:15 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4D3C061573
        for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2020 10:25:14 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id r7so2269968ybl.6
        for <linux-cifs@vger.kernel.org>; Wed, 09 Sep 2020 10:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=INP3q49dtVY7fmaPmHxKqo4VLe2pXX7YeXHdHOGhfe8=;
        b=UYkxOpcLhJRRt+BJzCZhLwS/l0e2yVKxbj2KU1KxgbEHytjjpYoSUFxsNkrck3LS41
         BPvnrUuXnVF9cIe0sJOwytcWSri3vsEA/Zm34UyWutjSMk68z+VIw8GancZSGgi4WXSH
         kuwH+Hy+XWDuCf7Pya38p+QBoZZrYngijz82BKkEo1jRLTLYr4LTTR0huW/d8QpUOFto
         sXfvziJJ1LiX/ZKdXOjvOQ0IRyoxEGRPVbRWIe3/8+dTfN6QY3+GC5UTAeFcnA2kgZVC
         WOV76kn/k/jxgVU9GwbVvOXlLZLmQ7CTKtGeDOTukSuN6LjJnAYvCF+Zgfv2sIUQQasq
         vUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=INP3q49dtVY7fmaPmHxKqo4VLe2pXX7YeXHdHOGhfe8=;
        b=t6B6ixWMUXhziMuiuTRkqIZPyINwe2RHxR3z4jGqT7jQsUHyu3xyPWxSIo+uvLXGMT
         vFi79DAA8WiXEQj+sOItBilQOw8Un3pfllD8MqMDlw/gIjr5fbRTwWrFFOOS0iGkhJL1
         RcJLIQXMX4VWcffxdpv3I5MSFugI+vAQo+2FL1cAT8kt2Kfr1N8NFKGhvTLAFpdb/0Le
         bH99KDIhioVFbG9Wf0MF6OMbMmzvwbmnWWcVhaM7dimHtIg48Klr3s2hd3RxGRWdAaMg
         0hkJoZivyh3O3GkqKBENgXlE+COFOtkE4pMpGEtZbuD+mkCqL9+BQVjaTayJekmdvN5M
         ZRIQ==
X-Gm-Message-State: AOAM531xkbwWCjcaLFrR3fKrkY9g1Z4H1X0PA6gF+Too6rOLThbTKXp5
        An/nOFF6AJm2/DHEumNuMPUzQjAca2HmZgFVdDY=
X-Google-Smtp-Source: ABdhPJyWItvsBshr25INT6hwc+JNOagWP6BHehXT5M3JcGFY6WRzT2O0ZkTIdVob0TQ6LliYrlcqnrGqL/bPrid1jxU=
X-Received: by 2002:a25:aca3:: with SMTP id x35mr6809170ybi.3.1599672310941;
 Wed, 09 Sep 2020 10:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pxPsBwAv3oJX6Ae9wjpZoEjLvyfGM1sM9DEhS11RNgog@mail.gmail.com>
 <87pn7t4kr9.fsf@suse.com> <CANT5p=oeY91u17DPe6WO75Eq_bjzrVC0kmAErrZ=h3S1qh-Wxw@mail.gmail.com>
 <87eeo54q0i.fsf@suse.com> <CANT5p=rxp3iQMgxaM_mn3RE3B+zezWr3o8zpkFyWUR27CpeVCA@mail.gmail.com>
 <CANT5p=qMHxq_L5RpXAixzrQztjMr8-P_aO4aPg5uqfPSLNUiTA@mail.gmail.com> <874ko7vy0z.fsf@suse.com>
In-Reply-To: <874ko7vy0z.fsf@suse.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 9 Sep 2020 22:55:00 +0530
Message-ID: <CANT5p=o07RqmMkcFoLeUVTeQHhzh5MmFYpfAdv0755iiGbp1ZA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs integration with PAM
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, samba-technical@lists.samba.org,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>, sribhat.msa@outlook.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Your understanding is correct. We could also go for a hybrid approach,
where we fallback to option b when option a fails to authenticate.
But for now, I'll resubmit a patch with option a as a fallback when
regular mount fails, just like you had suggested.

Regards,
Shyam

On Wed, Sep 9, 2020 at 7:43 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > Thoughts?
>
> You are reaching the limits of my poor understanding of this kerberos
> stuff. What is the difference between keytab and credential cache?
>
> So IIUC you are proposing 2 ways to go about it:
>
> a) - do PAM login in mount.cifs (which in turns calls into sssd/winbind)
>    - implement umount.cifs for PAM logoff
>
> b) - ignore PAM and winbind/sssd and do kinit in mount.cifs manually
>    - would this requires umount.cifs as well?
>
> I like (b) because it feels we have more control and don't require a big
> external program like winbind *but* if (b) doesn't do the refreshing of
> the tickets then the mount will always stop working after they
> expire. This seems only useful for quick one-off mounting or
> testing/debugging. Real end users will find it unreliable unless they
> setup something like what winbind does essentially.
>
> So ultimately, to me, (a) seems like the better choice. Let me know if I
> misunderstood something.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
-Shyam
