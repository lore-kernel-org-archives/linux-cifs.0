Return-Path: <SRS0=V1Ry=WY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D20B7C3A5A1
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 06:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2A0A22CF4
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 06:11:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjAnoCnY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbfH1GLq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Aug 2019 02:11:46 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:42045 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfH1GLq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Aug 2019 02:11:46 -0400
Received: by mail-io1-f49.google.com with SMTP id e20so3575790iob.9
        for <linux-cifs@vger.kernel.org>; Tue, 27 Aug 2019 23:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d5I83Yu4emkqqrdUQR70uSz9+0r5+S4bmGNS9QdQl/o=;
        b=SjAnoCnY3lv4ImT0x6EF1MH0LQaceA/WYl4PL0bldOlfTckboNeUoUMA1Utz3M9NAj
         ZUHqPyyrHDyF8QyfrdPkSwHOx1MYKqHAqI2z0gDpbuWji5ELTystk/JjxQBcVZVCwTGj
         dIRhGSibuH122BHrCm62a2LEo0QZcsNfe+ZJ0mEJN7JLITFzJTFC49RQYNGdtj37rFqL
         qb2Gf7MgpB76EWJdiG1oo/AGA25BHrufVzcXp5g8Fy9gZ8DnNZbr0jOe/lUGrwdz4TZ2
         ROl956GWVk6ezHXvKumVw9DurUD5KSEz2Qgtig8VKuK/V2CNANxGOoa24QQrzin6HmM1
         Q2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d5I83Yu4emkqqrdUQR70uSz9+0r5+S4bmGNS9QdQl/o=;
        b=D4x78DeuwtQXxiG2GF2DVtFzrlsvJQEmhs54JzX5wJgTv94bZyhuPZoqySWA3R4+tZ
         5vOM6XyuCMPh6+vm171tQNpREpiXu1OqQVt17p2wQBk8ov3uhdirgiBJ/KPxpX/9ZT+i
         jX051aqITuZt3s809eDDXNdQdzhOWGoT7czhQxM3NrKfw81wq6TSRN46dR7GkZ7LA3VC
         x+kaH77XKlB1N50tLcX2kKbsw6IL3uowncXQe481JB7IWNYb2qsBzmZauYPUtAQ6oSwp
         hXcl9Gt50SJ2WQ171v4B1Lqw2kQThnJwgLdZ0mWvTPlLLH3jwVke6T0yiaeeUtXVdiZ4
         gYSg==
X-Gm-Message-State: APjAAAVxeeUd73LwiGRBt0+M4dLgmzXuoQ4fRkE8gcp2RIy0SeAPTM9f
        lh/24g+qSwoADPjpQtvjLkxgYLaF5vAGTswvMjI=
X-Google-Smtp-Source: APXvYqwwL0Qg4Akc3fuJLylQ4NZXj7X3rHFJm1fMQ3ArI76MDWLYZQ3vcrUYwEZKTzrQSwaZOjDseJciscNe5YmE7s4=
X-Received: by 2002:a5e:c113:: with SMTP id v19mr2388202iol.219.1566972705171;
 Tue, 27 Aug 2019 23:11:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu_koRUCV9snYu_A6at8r+kJ85DgFszG4=seEEn+qb0LQ@mail.gmail.com>
In-Reply-To: <CAH2r5mu_koRUCV9snYu_A6at8r+kJ85DgFszG4=seEEn+qb0LQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 28 Aug 2019 16:11:33 +1000
Message-ID: <CAN05THRQrrXKYzbF4_mRrDF+77KMV=EvLodKFjhMUpCpB5uKyg@mail.gmail.com>
Subject: Re: [RFC][SMB3][PATCH] Allow share to be mounted with "cache=ro" if
 immutable share
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Aug 28, 2019 at 3:04 PM Steve French <smfrench@gmail.com> wrote:
>
> Increases performance a lot in cases where we know that the share is
> not changing

Good idea but we can do it without adding a new mount option.
Instead of "cache=ro" I think we should look at the WRITE bit in the
tree connect response access mask since this should tell us if the share is
read-only server-side or not.

If the share is thus read-only we should then have that reflected in the
"ro" mount option.

I.e.
* use TreeConnect/AccessMaks/WRITE flag to enable this more aggressive caching
and not a mount option.
* Probably also fail the mount if the WRITE flag is clear and the user
did not specify "ro"
as a mount option.

ronnie

>
>
>
> --
> Thanks,
>
> Steve
