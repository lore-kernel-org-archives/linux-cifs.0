Return-Path: <SRS0=frs6=XI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C24C4CEC7
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 16:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 635F7208C2
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 16:35:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="smkKSz8V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390379AbfIMQfk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Sep 2019 12:35:40 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44222 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390435AbfIMQfj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Sep 2019 12:35:39 -0400
Received: by mail-lj1-f196.google.com with SMTP id u14so27698521ljj.11
        for <linux-cifs@vger.kernel.org>; Fri, 13 Sep 2019 09:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wSTtpNyd4ixnxl6k5Rs1Lj8wR/L962wxBzJUYqKZ9nM=;
        b=smkKSz8Vhv0CPEl7rrz2VmQuZidJ1y/EvBomPlBVf52gmk1fuAQW3f3Y0Hh63+Dkxo
         BQe0WSvMxY0n1vewjKvS0YiCUxXZFohBg/o1+DwtPteNYA/LCfWD6nTxtSHolI8NVFA5
         hgmpIEwPdKcvLKec3qsbEo1fysTySIWk8TVgB5Iih0rG18o+emGhQvrxFOLxLItZulY2
         8HZvBKeGrvaTijZ7WAHRrQZj4+dlMwLs4rE2AdewMRsdJ03mxYHvNSvJpGFMuEDbgZ06
         hC1OFXMaZUzgnlljECAtXyXBYz9+0zXA6c5OOir2u/8ZpYr+Z3+1WNGsE99L2PruRvmZ
         DagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wSTtpNyd4ixnxl6k5Rs1Lj8wR/L962wxBzJUYqKZ9nM=;
        b=F0QhVSobS6wl0jzWg6PP8tNxmPmX3geZzOzrE9T0GpQEkvqExmLjQaf3duruSIAAdo
         LkYZiT5PE4P4X9eyFA3OT6eZ1tcLBwD8Snd9uQUX84UcZtzTCm40ek/YV0pIgKH/m0Ke
         KB9epMZA3qNgdFFCa3j6FJaBmFRa5GKDUbgTXsxkB10JX9CWTN0pOuJ3xupVuNsG3USp
         5y9zZYGspPLwCeAktFIMB1xIumfVXwQYyzyJDTcK37kdlvG/TGrXenety9QpBJmQn+dZ
         RMyLcEtykLXP/wcgypUuXHtsGz88jRgbl9NjYBvfadsL+Q+QVVnUJsvVWj3QjRcnP0u+
         WHmA==
X-Gm-Message-State: APjAAAWToq0XBpuOUu+faoihz+swY8ejsXP8ojTSYGUUGGDhm3MnR3oE
        zZ+M2LYChRC+DRqPyHmbaJJoKGHzxyYf6E2pYw==
X-Google-Smtp-Source: APXvYqzs4kKdqAzbxv4JVZ+Ul3t9/loDGdVwXZgaPS8bTf2RP5l54F3+XIHmAQF7IjkVZT1/S+pjgyTCQlltJC+J+vc=
X-Received: by 2002:a05:651c:113c:: with SMTP id e28mr6960397ljo.184.1568392536292;
 Fri, 13 Sep 2019 09:35:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtpx88bvKPDZs24ipxH+pm_82ug_w2QPKpB+9Z0xjAYiA@mail.gmail.com>
 <875zlwig4t.fsf@suse.com> <8736h0i7p4.fsf@suse.com>
In-Reply-To: <8736h0i7p4.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 13 Sep 2019 09:35:25 -0700
Message-ID: <CAKywueSsNF+j+s0=+_UbsESTaz-K1Oj48LNK3SvBvXQTZE-PXQ@mail.gmail.com>
Subject: Re: [PATCH] smb3: fix unmount hang in open_shroot
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Agree. Both SMB2_open_init and SMB2_query_info_init should exit
through oshr_free to avoid double unlock.
--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 13 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 07:36, Aur=
=C3=A9lien Aptel <aaptel@suse.com>:
>
> Aur=C3=A9lien Aptel  <aaptel@suse.com> writes:
> > Good catch. Since the compounding changes it is SMB2_open_init() that i=
s
> > triggering the reconnect -> mark_open_files_invalid() code path so it
> > looks good to me. Might be worth updating the comment to
> > s/SMB2_open/SMB2_open_init/ before you commit.
>
> Ah it seems you also need to make SMB2_open_init exit via the oshr_free
> label otherwise you the mutex gets unlocked twice (see Dan Carpenter
> automatic test email). This smatch tool is pretty nice...
>
> Cheers
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
