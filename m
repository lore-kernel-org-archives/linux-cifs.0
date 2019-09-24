Return-Path: <SRS0=4YGq=XT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D15C432C1
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 19:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F422820872
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 19:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pKGXrX3u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405681AbfIXTFs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Sep 2019 15:05:48 -0400
Received: from mail-lf1-f50.google.com ([209.85.167.50]:35308 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405389AbfIXTFs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Sep 2019 15:05:48 -0400
Received: by mail-lf1-f50.google.com with SMTP id w6so2256055lfl.2
        for <linux-cifs@vger.kernel.org>; Tue, 24 Sep 2019 12:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JPlUWQUG6T6b7/mjhcn8SHakwT87/jHqoBKsbybtezM=;
        b=pKGXrX3uy6MNZUyywqm7N36+k0ySHp2TrqkpW+SqpC6sK7fpv7FfeVG1EUHbfCu+85
         at9/Em9bMd0XLVmHzT6lzoWhL0o0SjkpNox08IRGc/GB6kAYQhffNp/SMixE/EO1MrbD
         NlDq2QPRgOOdgmaY+JiX0y2RR55pK7aj2eRNx/mIJorgFYVd4ONaUEqxCxJk/b5n8Zop
         C0d1aJQ6RptQat5DTQx0XaLo054CyILlWeVcJrss8CTJlpZeeupecH7gFSX+KKMWXmRu
         7IF8gQlq6tatY1lEoUtliQe+QtDeDfySDRTY5dUwNq3L4H4rV57ZNYb8b4JwyLE+1l8g
         Ke0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JPlUWQUG6T6b7/mjhcn8SHakwT87/jHqoBKsbybtezM=;
        b=qXJMl04HtWZbtw7Hh9vd+LiqASbJ5FXoIx7Wmrm72HVvLUxk8sbub2Yk12jPYHDriK
         W2cZNamJIUF5zo9R50lLKIBqZbvWQBa6Yv/riXGdq/GyCTCUKnITfTmIMleGOY9YiIbn
         dGtclTgr+BCDUF/QGqB2ik6Ogr8WWme4H0XgIyHov6AvObzneF1+Q5zV/vffHnOZD1p+
         zjlN1Qh9nMCsIs3yv1fgPHRGLtypsxDX2iuuJYi/aXHVIc628Fred9bx4aGQTjq8/2sQ
         5l18wVpameIp/zQwZi+QAQNZhQcEo5xoL5xjqoNJnqFty9fFKeY61LChxEhcgKHoSzet
         UH5g==
X-Gm-Message-State: APjAAAVZJhURJYvIkukwjRlmbLETIYmwPoi1mNmnmPVG8ictoG8L0eM4
        Op1uZXBS799k0SBme+OAddE+voDFk+FNd+1jdg==
X-Google-Smtp-Source: APXvYqyWG7c3kE/roLhSYrtGtocjTWRWvudbenVpQqxQr4ZwYJBqcDo3rDA53PRKK46QI2x+ktICze7SiUBf4nOz9uw=
X-Received: by 2002:ac2:4196:: with SMTP id z22mr2773948lfh.54.1569351946178;
 Tue, 24 Sep 2019 12:05:46 -0700 (PDT)
MIME-Version: 1.0
References: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
 <CAKywueT=hWCTM=Crsafrj-8P=1mD93DY73oK=Ub8JeWc5X85fQ@mail.gmail.com>
 <4a017b583eb0f5fab477ecbe0e43b3a1@moritzmueller.ee> <CAN05THR5FE80VsnbKfpBzvt+g5jPu3rtiOqWkzU5yKoKUkhkiA@mail.gmail.com>
In-Reply-To: <CAN05THR5FE80VsnbKfpBzvt+g5jPu3rtiOqWkzU5yKoKUkhkiA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 24 Sep 2019 12:05:34 -0700
Message-ID: <CAKywueTOjoP-Jh7WWCi5XJhfzgK+KZs3kvHKuVG_HW0fnYYY7A@mail.gmail.com>
Subject: Re: Possible timeout problem when opening a file twice on a SMB mount
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Moritz M <mailinglist@moritzmueller.ee>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Moritz for providing this information.

It seems like a new long-term bug in the client code. The client
requested a lease but the server responded with a batch Oplock value
(0x9). Since the mount is SMB3.1.1 the client assumes that the server
always responds with a lease thus interprets this as a Lease State -
0x9 matches in the bit mask only a READ lease flag (0x1). Later on
when the client receives an oplock break from the server caused by the
second OPEN, it looks at the caching level which is READ and skips the
OPLOCK BREAK ACK step (according to the spec). That's why the app
hangs waiting for the oplock break to be timed out.

In order to fix it, we would need to tech the client to recognize
Oplocks on SMB3+ mounts assuming that the server may return both
Oplocks and Leases in response to CREATE command.

Ronnie, what is the version of Samba are you using? It is up to the
server to decide if Oplock or Lease is returned.

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 24 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 11:12, ronni=
e sahlberg <ronniesahlberg@gmail.com>:
>
> That pcap shows a problem with the lease break.
>
> I just tried your python reproducer with the current cifs upstream
> kernel and the problem does not manifest.
> There were oplock related fixes in the cifs.ko module a while ago that
> might have fixed the problem you see.
>
> Which kernel version are you using ?
>
>
> On Tue, Sep 24, 2019 at 10:53 AM Moritz M <mailinglist@moritzmueller.ee> =
wrote:
> >
> > Hi Pavel,
> > >
> > >
> > > Could you please enable debugging logging
> > > (https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_=
Debugging),
> > > reproduce the problem and send us the kernel logs? A network capture
> > > of a repro could also be useful
> > > (https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Wire_Capt=
ures).
> >
> > see the debug output and the pcap file attached.
> >
> > Best regards
> > Moritz
> >
