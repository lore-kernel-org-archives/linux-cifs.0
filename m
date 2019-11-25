Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32142C432C3
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 19:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0612620748
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 19:53:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RjRMdwbx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfKYTxQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 14:53:16 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45732 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfKYTxQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Nov 2019 14:53:16 -0500
Received: by mail-lf1-f68.google.com with SMTP id 203so11991242lfa.12
        for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2019 11:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FUQ2/2y14kGrdFzEmai/f5XcF0XBbXHfSsnwS83pjeo=;
        b=RjRMdwbxDxgbb8CquZshQbJ6AAYUHh7eTW5adJAJ8nFsfZr2La9aaeJqdr4af/TrpH
         a/5ICEp2hm7VrpdA2yZlqAwli6j3yAWuT7362g3FRtSIDlTJLGjjvHd/nOcHbK0suON/
         q/iHRZjEmwjZa10Qpnn+ZLzJc9edFhGNxEUdSjSFt1Z+Yzt5Mv3+ggY8E1Y4tSsuiKDY
         /xbn+a/x7AvJwZrarK8uXAqpC8ybHQ1z9mcTdmlmJSAZyTEjk03ELGbIw9uIkT+sD0mu
         oH7mwQ3RVc82Md99lOFhG0/QGEhLPc9EKhsPleVAkbH2Ot/4dHZRpH+Oay6fULoMuZVV
         RVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FUQ2/2y14kGrdFzEmai/f5XcF0XBbXHfSsnwS83pjeo=;
        b=ZhnEQ+zNbWgFr5QXIQLC3OX0DyA2TjkKQFBXxRDhdrODjny9UlGfgcxZinsMxY2Ysh
         lGNFZqlh5VRtx/EfkrRmEMDjfEZbqHl8IiWltjlh2IOl02Nn9PTQ/KnnetMxWmZtR236
         7uQx/y6bDJE0cl/lpfvJfB3DF/3eIGj6WONgvZFXxxKwJeWMfyfVBtNvce6QP306Hhiz
         6Udv/hHUbsWhrSl7h1FOmsWWtawx4HhZQWWSU5xzbztaqC/hy45PBuSJ++ul1qOtJ2ze
         FDliwbPux5XQLZiSv0toW9/eLZW1Pvms2Y25KU4wV3dvKNml6wKNfgtkvgC4gr2WBAOx
         6BuQ==
X-Gm-Message-State: APjAAAW3944SiPXkSu0AbRaR+UZyaP+j1WOxbJ90yHV5WbyoDJ8wt+2J
        t7s4Fvs2iM3FZjPoiRAzhb/0cycjkCb7Pm6UNnOk
X-Google-Smtp-Source: APXvYqwLcFEQk1IhplLVibl3bWGeIc0tFAsUOU2N8Plupd9Si9oOjReL7MUpWhGcBIseCaRMfOwdQ59J3kcOxsxJN3s=
X-Received: by 2002:a19:c697:: with SMTP id w145mr17684203lff.54.1574711594456;
 Mon, 25 Nov 2019 11:53:14 -0800 (PST)
MIME-Version: 1.0
References: <20191122153057.6608-1-pc@cjr.nz> <20191122153057.6608-4-pc@cjr.nz>
 <87fticw5bx.fsf@suse.com> <CAH2r5mthG19J-vkMXDeNKcw_AdeWTHxKphTLzdacbO_GYSeFog@mail.gmail.com>
In-Reply-To: <CAH2r5mthG19J-vkMXDeNKcw_AdeWTHxKphTLzdacbO_GYSeFog@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 25 Nov 2019 11:53:03 -0800
Message-ID: <CAKywueQDLmWTH_RY47RSV2Dx8anTUKQMpoTfz0kqN+Zeq8UfFA@mail.gmail.com>
Subject: Re: [PATCH 3/7] cifs: Fix potential softlockups while refreshing DFS cache
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stable candidate?
--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 25 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3. =D0=B2 07:35, Steve=
 French <smfrench@gmail.com>:
>
> tags added - tentatively merged into cifs-2.6.git for-next pending
> testing (buildbot)
>
> On Mon, Nov 25, 2019 at 5:41 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> >
> > "Paulo Alcantara (SUSE)" <pc@cjr.nz> writes:
> > > We used to skip reconnects on all SMB2_IOCTL commands due to SMB3+
> > > FSCTL_VALIDATE_NEGOTIATE_INFO - which made sense since we're still
> > > establishing a SMB session.
> > >
> > > However, when refresh_cache_worker() calls smb2_get_dfs_refer() and
> > > we're under reconnect, SMB2_ioctl() will not be able to get a proper
> > > status error (e.g. -EHOSTDOWN in case we failed to reconnect) but an
> > > -EAGAIN from cifs_send_recv() thus looping forever in
> > > refresh_cache_worker().
> >
> >
> > I think we can add a Fixes tag:
> >
> > Fixes: e99c63e4d86d ("SMB3: Fix deadlock in validate negotiate hits rec=
onnect")
> >
> > Otherwise looks good.
> >
> > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> >
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
>
>
>
> --
> Thanks,
>
> Steve
