Return-Path: <SRS0=lqiH=7Q=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B03C433E0
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jun 2020 05:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9229120657
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jun 2020 05:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WwA8qofL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgFCFKN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Jun 2020 01:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgFCFKM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Jun 2020 01:10:12 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEE3C05BD43
        for <linux-cifs@vger.kernel.org>; Tue,  2 Jun 2020 22:10:12 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id y13so401603ybj.10
        for <linux-cifs@vger.kernel.org>; Tue, 02 Jun 2020 22:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wdA40B87qIlTLHjc/7SlPikFb86EwXwVzDBpaa0aajs=;
        b=WwA8qofLmnGiR4SFOVFriwhsC/fPMbFUeWMIuMTKlJMU66mCwWk++8JO5JdNR3bz/G
         0KzlImFZf+RdA27uEiUiu8Eugpj3QUB5u+ieMBu1Ae3+0xgbEqz/bmK704nHCH4Bqq1f
         /4CdnTNkvxVOq12hIy7oR4uYx8aJpnPhNKFH1HXwOfe+Q9ZOWdTWgxTn14kPFrBR/Min
         l4rWjHRsIhjf1cqjsXO2/W5CZzkt84XICUyxpCdT/MD+32XFJ0D2KMXkibYMIUgz4mhU
         r74BOKd4L1ABRE/xbv2HPA1yCdMl2VsHgyPiezi7g6nwXT8YU5XWjEOevFOO6qvlPdFQ
         jMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wdA40B87qIlTLHjc/7SlPikFb86EwXwVzDBpaa0aajs=;
        b=qykxtJyhqK1n3kChkY33Adn5aDwcX6I3djrEyyx+QERMHSjbYxZKuS1PVpAr8Qn7qO
         DmN6A/cwPAKTVmL9EJ9g5EPyar/bHL566sCLixNSdGxeRiMsW+Ii0aMRxLhzccbUHTz2
         BEwOEOzWWXT0jz8Fku+bhjZXD/YN/u965T0WiBM4CZ5YYzc1XYBX7788yQ6bHYEnGxLp
         2rrvb0Xh9Jt75TsEU1wn05Nj0lD+18KNhHCmy66sb4n6Y7xVmx62Iub1By5bqxfzd+7c
         GmkJVWE6gE/3lmcK6FX7o5xgyaBoOuJIj/d56seQW7/D/ilMuqEd8/viJ5xb/1h1CDC/
         GigQ==
X-Gm-Message-State: AOAM533vl9f/hgzdiNU3lUBzRYea5Sfk9ucVZtm2BtZaDOcHBA1r+V1R
        Eftmuh8RSf41TM+4K1zrxjxDLX4GHgEU8MLgmrg=
X-Google-Smtp-Source: ABdhPJzOiAg4k8XZK9tqJyRr3FSdr0m2WX7g7BqTgrz2/jxir8fux/ViKv4anLjsFgkRr+hjo8c8rF61/S7rGGbCT6Q=
X-Received: by 2002:a25:ca45:: with SMTP id a66mr29122247ybg.85.1591161010301;
 Tue, 02 Jun 2020 22:10:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200602143205.23854-1-kdsouza@redhat.com>
In-Reply-To: <20200602143205.23854-1-kdsouza@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 3 Jun 2020 00:09:59 -0500
Message-ID: <CAH2r5mu=y3+R8uor-EWAvM=kTnoOhKA3uR9G09BvTp41sKgdeQ@mail.gmail.com>
Subject: Re: [PATCH] Print sec=<type> in /proc/mounts if not set from cmdline.
To:     "Kenneth D'souza" <kdsouza@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Roberto Bergantinos Corpas <rbergant@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is a good point. Iit can be helpful to see if we defaulted to
krb5 or ntlmssp in a particular mount - but printing sectype in mount
options when it is "Default" (ie unspecified) may be confusing.

I prefer that you change this to simply print KRB5 or NTLMSSP in
/proc/fs/cifs/DebugData so we know what is negotiated.
We already include whether "signed" or "sealed" (encrypted) and
whether "guest" or whether "anonymous" etc. so could add whether
NTLMSSP or KRB5 around line 368 of cifs_debug.c
e.g. after
                                if (ses->session_flags &
SMB2_SESSION_FLAG_IS_GUEST)
                                        seq_printf(m, "Guest\t");
                                else if (ses->session_flags &
SMB2_SESSION_FLAG_IS_NULL)
                                        seq_printf(m, "Anonymous\t");

Probably easiest to check the values of server->sec_mskerberos vs.
server->sec_kerberosu2u vs. server->sec_ntlmssp and print it to
/proc/fs/cifs/DebugData

It is more helpful to show in /proc/mounts what we actually passed in
on mount (or the default if not passed in in some cases can be shown)
- while /proc/fs/cifs/DebugData shows more information about what was
negotiated (not just encryption and signing but number of credits
etc.) - seems better to put this in /proc/fs/cifs/DebugData

On Tue, Jun 2, 2020 at 9:32 AM Kenneth D'souza <kdsouza@redhat.com> wrote:
>
> Currently the end user is unaware with what sec type the
> cifs share is mounted if no sec=3D<type> option is parsed.
>
> Example:
> $ echo 0x3 > /proc/fs/cifs/SecurityFlags
>
> Mount a cifs share with vers=3D1.0, it should pick sec=3Dntlm.
> If mount is successful we print sec=3Dntlm
>
> //smb-server/data /cifs cifs rw,relatime,vers=3D1.0,sec=3Dntlm,cache=3Dst=
rict,username=3Dtestuser,uid=3D0,noforceuid,gid=3D0,noforcegid,addr=3Dx.x.x=
.x,file_mode=3D0755,dir_mode=3D0755,soft,nounix,serverino,mapposix,rsize=3D=
61440,wsize=3D16580,bsize=3D1048576,echo_interval=3D60,actimeo=3D1
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
> ---
>  fs/cifs/sess.c    | 1 +
>  fs/cifs/smb2pdu.c | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 43a88e26d26b..a5673fcab2f7 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -1698,6 +1698,7 @@ static int select_sec(struct cifs_ses *ses, struct =
sess_data *sess_data)
>                 return -ENOSYS;
>         }
>
> +       ses->sectype =3D type;
>         return 0;
>  }
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index b30aa3cdd845..bce8a0137fa4 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1601,6 +1601,7 @@ SMB2_select_sec(struct cifs_ses *ses, struct SMB2_s=
ess_data *sess_data)
>                 return -EOPNOTSUPP;
>         }
>
> +       ses->sectype =3D type;
>         return 0;
>  }
>
> --
> 2.21.1
>


--=20
Thanks,

Steve
