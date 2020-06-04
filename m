Return-Path: <SRS0=WzOu=7R=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC827C433DF
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jun 2020 15:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8949420772
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jun 2020 15:43:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bv8YrBea"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgFDPnW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Jun 2020 11:43:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52525 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729346AbgFDPnV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Jun 2020 11:43:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591285400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8vsaP/NRzaXpjdLAT1ge7zdLFHq51cWj97fdTakoLD4=;
        b=Bv8YrBeaooywKdF3oqYBbkg9RFGrZkUTrF8PtDnGy68OUTkM7y7okXnp8WYRtaaeOFayQX
        pTuwmnKcjdpfbiqN+HK2AdWT5RAHk4ObCIsGbgeQWh/cg7SveAhZ2LX1SYzqJuhVWbBvib
        xXxkwAAxF8cNfowrswaQMK87sP1ee1M=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-LsYuFGBQM7Gt5mbS-2DNWA-1; Thu, 04 Jun 2020 11:43:18 -0400
X-MC-Unique: LsYuFGBQM7Gt5mbS-2DNWA-1
Received: by mail-qk1-f197.google.com with SMTP id a6so4938753qka.9
        for <linux-cifs@vger.kernel.org>; Thu, 04 Jun 2020 08:43:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8vsaP/NRzaXpjdLAT1ge7zdLFHq51cWj97fdTakoLD4=;
        b=U0cvg5p+5wc1m+6FfFv2XNtyQ5WNfnzh3TtwqSNuOYdoj4hbLD6MrdjNBugYo7eb6j
         bRV/8+2gZ03mMjBK+iAxD2nlEmDJWNaPCfA2tvsYT7fFa0NMvGRuc793RV+pUMD4sFuK
         R/HDP74bTaZ5o9kKsDp554nDf1M5mkUMccoi0kXGjc2OqJMZgIbZGUuZrziwS0x2H81K
         AKAHkXihQ1a2dy52YmS2+hhyyAE0BpZDfBTNotlli9u43eOwKAYHBSlJraaKi6KIxnBk
         33ZfpH/MA1YjPU2U3l/hyO/GQoeReQCleskiVIvSWgHHNZgiYHXNQnfMdiNjCt0rFeIk
         2gmw==
X-Gm-Message-State: AOAM531+uSNr+5awc/Y4Zj1+E68YX/LJMq+Oj370mHdcouKXoFyP3rQj
        Q8p45yIe0WdRAYzODCFgCv2o4w9rakyT9nt9mdaY8EzjJzzgA0xLk1uWfrFDCizx98lr1T3dhUv
        3f2pp+lWWXYFm6sHp9EeRkxRiHO8SqpubVAPg3Q==
X-Received: by 2002:aed:21af:: with SMTP id l44mr5377961qtc.124.1591285397708;
        Thu, 04 Jun 2020 08:43:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaxo15F6h44MjuaJ7ZaOmJJ5OB1wKKRvzpliwISwvohRRsTjMVeEmIme9KzKvT1AYxl2n1/e3dNgoDZYGI/tM=
X-Received: by 2002:aed:21af:: with SMTP id l44mr5377938qtc.124.1591285397396;
 Thu, 04 Jun 2020 08:43:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200602143205.23854-1-kdsouza@redhat.com> <CAH2r5mu=y3+R8uor-EWAvM=kTnoOhKA3uR9G09BvTp41sKgdeQ@mail.gmail.com>
In-Reply-To: <CAH2r5mu=y3+R8uor-EWAvM=kTnoOhKA3uR9G09BvTp41sKgdeQ@mail.gmail.com>
From:   Kenneth Dsouza <kdsouza@redhat.com>
Date:   Thu, 4 Jun 2020 21:13:05 +0530
Message-ID: <CAA_-hQLON2e-AWeavDv=2b3PHLsSd=ha+pAEjr2Oy14qSNYPOQ@mail.gmail.com>
Subject: Re: [PATCH] Print sec=<type> in /proc/mounts if not set from cmdline.
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Roberto Bergantinos Corpas <rbergant@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Will send out a v2 patch to print Security type in /proc/fs/cifs/DebugData
This would help end users to know with what security type the share is moun=
ted.

Example:
# cat /proc/fs/cifs/DebugData | grep -w "Security type"
1) Name: x.x.x.x Uses: 1 Capability: 0x8001f3fc    Session Status: 1
Security type: RawNTLMSSP

On Wed, Jun 3, 2020 at 10:40 AM Steve French <smfrench@gmail.com> wrote:
>
> This is a good point. Iit can be helpful to see if we defaulted to
> krb5 or ntlmssp in a particular mount - but printing sectype in mount
> options when it is "Default" (ie unspecified) may be confusing.
>
> I prefer that you change this to simply print KRB5 or NTLMSSP in
> /proc/fs/cifs/DebugData so we know what is negotiated.
> We already include whether "signed" or "sealed" (encrypted) and
> whether "guest" or whether "anonymous" etc. so could add whether
> NTLMSSP or KRB5 around line 368 of cifs_debug.c
> e.g. after
>                                 if (ses->session_flags &
> SMB2_SESSION_FLAG_IS_GUEST)
>                                         seq_printf(m, "Guest\t");
>                                 else if (ses->session_flags &
> SMB2_SESSION_FLAG_IS_NULL)
>                                         seq_printf(m, "Anonymous\t");
>
> Probably easiest to check the values of server->sec_mskerberos vs.
> server->sec_kerberosu2u vs. server->sec_ntlmssp and print it to
> /proc/fs/cifs/DebugData
>
> It is more helpful to show in /proc/mounts what we actually passed in
> on mount (or the default if not passed in in some cases can be shown)
> - while /proc/fs/cifs/DebugData shows more information about what was
> negotiated (not just encryption and signing but number of credits
> etc.) - seems better to put this in /proc/fs/cifs/DebugData
>
> On Tue, Jun 2, 2020 at 9:32 AM Kenneth D'souza <kdsouza@redhat.com> wrote=
:
> >
> > Currently the end user is unaware with what sec type the
> > cifs share is mounted if no sec=3D<type> option is parsed.
> >
> > Example:
> > $ echo 0x3 > /proc/fs/cifs/SecurityFlags
> >
> > Mount a cifs share with vers=3D1.0, it should pick sec=3Dntlm.
> > If mount is successful we print sec=3Dntlm
> >
> > //smb-server/data /cifs cifs rw,relatime,vers=3D1.0,sec=3Dntlm,cache=3D=
strict,username=3Dtestuser,uid=3D0,noforceuid,gid=3D0,noforcegid,addr=3Dx.x=
.x.x,file_mode=3D0755,dir_mode=3D0755,soft,nounix,serverino,mapposix,rsize=
=3D61440,wsize=3D16580,bsize=3D1048576,echo_interval=3D60,actimeo=3D1
> >
> > Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> > Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
> > ---
> >  fs/cifs/sess.c    | 1 +
> >  fs/cifs/smb2pdu.c | 1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> > index 43a88e26d26b..a5673fcab2f7 100644
> > --- a/fs/cifs/sess.c
> > +++ b/fs/cifs/sess.c
> > @@ -1698,6 +1698,7 @@ static int select_sec(struct cifs_ses *ses, struc=
t sess_data *sess_data)
> >                 return -ENOSYS;
> >         }
> >
> > +       ses->sectype =3D type;
> >         return 0;
> >  }
> >
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index b30aa3cdd845..bce8a0137fa4 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -1601,6 +1601,7 @@ SMB2_select_sec(struct cifs_ses *ses, struct SMB2=
_sess_data *sess_data)
> >                 return -EOPNOTSUPP;
> >         }
> >
> > +       ses->sectype =3D type;
> >         return 0;
> >  }
> >
> > --
> > 2.21.1
> >
>
>
> --
> Thanks,
>
> Steve
>

