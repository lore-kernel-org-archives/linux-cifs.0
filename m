Return-Path: <SRS0=r/yF=XE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C43DC4740A
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 23:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE89520863
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 23:23:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bRvuBpza"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbfIIXXX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Sep 2019 19:23:23 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:39064 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389986AbfIIXXX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Sep 2019 19:23:23 -0400
Received: by mail-io1-f42.google.com with SMTP id d25so33114794iob.6
        for <linux-cifs@vger.kernel.org>; Mon, 09 Sep 2019 16:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U3vK5q3syyMym5e2mUwckINzGgbMb35z6bQYvvL3G74=;
        b=bRvuBpzaXCYnc9FUWTITGTbW+DnSztbn4hVcPQaouxKpHPkeDi+YBqT/xyXdUXaRnE
         INJWF70fQkZA5KjaJJy+xeEo2TK0xSa7UTkzzLpFgvuA5fsQc+NEbTWab5V/Is1QPFAB
         DKR6LrDCOGI1I3wHML2B98H+e3qlSNSaaNuN7RdN3rDPG0/C5eNr+OZU++KVCgvcyj2T
         SSY8h9rulYXnSbRWr03Awx+xCFy94Tfd4c79l/49j/JtCwVvDF0a0Bc1puwagWe6s4Xh
         BMoI8NpiAV1XOEYSxC1uCdB6jzpkwYd4p5QbUfekir3WrBYGx2LCoYz6ZYu/wmHjJAMp
         HMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U3vK5q3syyMym5e2mUwckINzGgbMb35z6bQYvvL3G74=;
        b=T/F+ClGpBJj/gkoHieV8aorG3ZaUEwsLfm4cL7/uksHl7zpx15axt2SjQktjwMzGTW
         zakPLCsXaafj0tVbFHF+3Azrq8LeTbwv3U6y1GfGJVJZW1LivK5weBnKeDJWuvdj7OzJ
         W9c28xbN/JNIkr/OfVHkP+xtPWf1j+TUkG7oKN/WquA9QPPhRVxRgmMy6SC90cGiS05t
         kFgNJ8QRZoaAmUANdwq+MfIpVmb+Z/CDK+UW3WquWQhT2wqqM5NBCkONiwnzCPpmSBwg
         2d3ux29mseu+Wh7fh335BO0ilqBcOv+Cns2qTVu4Kn/oR+ohpuoLY15UP9WLx6tQNgwW
         5ciA==
X-Gm-Message-State: APjAAAVnc5m1b6RIheELkQbPgNX/UdDO2BIQKjDp/w6KnHNreOtxTSG1
        zdpEllg8VNXwSga8KfbF6K7TRGtVBMueqQmrc/gXbT+X
X-Google-Smtp-Source: APXvYqz778FzVUai5+ElRsn1CLAG+B6E+Jc+JBJTCd1K7Uh95Pro4FNyPCx9KsCca42anED6WqcZ4cfkucp+qeM31hE=
X-Received: by 2002:a5d:89cd:: with SMTP id a13mr1353465iot.272.1568071402381;
 Mon, 09 Sep 2019 16:23:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190909104127.nsdxptzxcf5a6b72@XZHOUW.usersys.redhat.com> <87mufdiw0u.fsf@suse.com>
In-Reply-To: <87mufdiw0u.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 9 Sep 2019 18:23:10 -0500
Message-ID: <CAH2r5mt9etVvg5jFk5jXRV6FadGz=qcqgG+JBhojKwVKmvRPZw@mail.gmail.com>
Subject: Re: Are the xfstests exclusion files on wiki.samba.org up to date?
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We have done a lot of work (with Ronnie, Aurelien, Pavel and others)
on xfstest automation.

As you might guess it is frustrating for two reasons:
1) updated xfstests can be flaky (as the tests themselves are updated,
they add subtle required features, or regress from time to time)
2) test automation can run into resource constraints (VMs trying to
run tests with less memory than might be optimal - especially those
run against Samba with "VMs inside VMs").

But the good news is that we have VERY good data on which tests pass
to various servers (just as noted, need to update the external pages)
and we should have even more data as we go through two weeks of SMB3
testing events in late September.

In general we want to test against all typical servers and have test
targets setup for
 - Samba (reasonably current stable) on ext4/xfs and Samba with btrfs
(which has various optional extensions enabled in the server)
 - Samba with POSIX Extensions
 - Windows (and against both NTFS and REFS server file system)
- Azure (Cloud0

But would really like to add test targets for other common servers and
in a perfect world would like to be able to have external test
automation pull our trees periodically to run these (similar to what
is done for the six targets above):
  - Macs
  - NetApp
(and any others of interest to the community)

Obviously xfstest has a few hundred tests which only make sense for
local file systems with block devices, but there are hundreds of
xfstests of value, and most should run on cifs.ko and we are working
through them but already have a very good set running.

On Mon, Sep 9, 2019 at 5:50 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> "Murphy Zhou" <jencce.kernel@gmail.com> writes:
> > As $subject. Is this wiki being maintained ?
> >
> > Looks like the last update was in January 2019.
> >
> > https://wiki.samba.org/index.php/Xfstesting-cifs#Exclusion_files
>
> We have a buildbot running xfstests relatively often here
>
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/
>
> Each group has slightly different tests run, you can see which one gets
> run by clicking on a build:
>
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/b=
uilds/249
>
> Overall xfstests+cifs is very finicky and frustrating to get working
> reliably. Not to mention long. So good luck :)
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
Thanks,

Steve
