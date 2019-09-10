Return-Path: <SRS0=ZOHs=XF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F42C3A5A2
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Sep 2019 10:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B61E20872
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Sep 2019 10:40:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l9yhmoUp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfIJKkG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Sep 2019 06:40:06 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:40160 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfIJKkF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Sep 2019 06:40:05 -0400
Received: by mail-io1-f68.google.com with SMTP id h144so36272664iof.7
        for <linux-cifs@vger.kernel.org>; Tue, 10 Sep 2019 03:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=739aN517totnZvFMQ6XAVr+frRixZW6CWhH9QjfuMjk=;
        b=l9yhmoUpS5TPuYjLhG36Z8n2++VvYQmrE8qtGwf8zVexwyvrMR4/RQQgcZPUoP8uIQ
         LoCq34mPQl/ucklj834/ClhqZsPRrZTn6WGkrHumt38hAf7c6u9lwVwiyWK9FR+mjwcV
         AWJRtQJpEsHHyZrNtkCuAaGb8GC9shBm4xMGr9I0aWUfQgi+cbk9GKg2bJ6buSMIb/Wu
         O7l85Pq+siXDDEPWPAVxTvbdbQuqKEfacra5fBfwIQTZu1YzN4fj63bZ9HZr1Jrfzsoi
         TMAA9vt/qKHwg3FIRFS6nn5koOjAlISSyIVyJ3iM21sdyFaFFBDj5I0/nZN5NtwimBSd
         pMxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=739aN517totnZvFMQ6XAVr+frRixZW6CWhH9QjfuMjk=;
        b=rF6d73F92Bbt2+qFPjyBXh+qbQ3c1HyyORT8A+Rsu04jBrzZhRsHlEWhGfo/KYdk8k
         bnRgUZQR4nuLTqooYkETnnVaHZEKmsUnAFt24rMqYJU/P+7pZGHd4hyefAK/vzwKQKcP
         vJO9ZEqpc0DJFQuzBcVvGseHcFtVal4lleEBoSM8+LRARgNc8wZ/56gUMHkQBN1aHeuB
         UD21xuZ6PZN1+kPFTCbzCDBRt3qegpjResoJbs1gj42Ixywv6MDMYQ7vEWzZVDonA4ai
         xO2N7fmxhBf+1g1/Bez3U5+7IDukubV0D3mtFYH5AzOeYrXMH0wWAQMcHIDU8sOojegU
         ZHeQ==
X-Gm-Message-State: APjAAAWMIlgEOknkfHpAZDa2+0sg5jS9nfN8g3O5bgdit/WIKwEYbJKY
        mxkz4K8APFIlVIzf4VVDl3wtJ7ltJ9qBk/g+mQ4=
X-Google-Smtp-Source: APXvYqzltWiy2GQKyodCcrA5wWt5uO5JyX0hftgTJgmdl21l3zlOEGXDM52gXKZPQLYD4P0aZ/bIzcGu9KFlz+m4VSk=
X-Received: by 2002:a02:7044:: with SMTP id f65mr31811784jac.37.1568112004863;
 Tue, 10 Sep 2019 03:40:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190909104127.nsdxptzxcf5a6b72@XZHOUW.usersys.redhat.com>
 <87mufdiw0u.fsf@suse.com> <CAH2r5mt9etVvg5jFk5jXRV6FadGz=qcqgG+JBhojKwVKmvRPZw@mail.gmail.com>
In-Reply-To: <CAH2r5mt9etVvg5jFk5jXRV6FadGz=qcqgG+JBhojKwVKmvRPZw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 10 Sep 2019 20:39:53 +1000
Message-ID: <CAN05THREAX12uBdWULEQnP+Ko52uDzTjry3dYKM3ZFiB2cYaJw@mail.gmail.com>
Subject: Re: Are the xfstests exclusion files on wiki.samba.org up to date?
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Murphy Zhou <jencce.kernel@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks, good post.

I think the OP is right. The wikipage is obsolete and IMHO we should
change it to just point to our buildbot
as being the canonical truth of what tests we expect to run.
(we used to have the outdated wiki, then we had every developer having
private, secret scripts with specific subsets of tests,   and we had a
lot of regressions every release until ~5.0 or so I would say.)

At this point, the tests we run on the buildbot IS the canonical set
of the tests that are expected to work and that all of us targets.
Maybe we should look into surfacing the list of tests we perform
better. I.e. what tests do we run against windows/samba+btrfs/azure
and why?

Lets get rid of the list of tests from the wiki and let the buildbot
be the single canonical source of truth.

Regards
ronnie sahlberg


On Tue, Sep 10, 2019 at 8:23 PM Steve French <smfrench@gmail.com> wrote:
>
> We have done a lot of work (with Ronnie, Aurelien, Pavel and others)
> on xfstest automation.
>
> As you might guess it is frustrating for two reasons:
> 1) updated xfstests can be flaky (as the tests themselves are updated,
> they add subtle required features, or regress from time to time)
> 2) test automation can run into resource constraints (VMs trying to
> run tests with less memory than might be optimal - especially those
> run against Samba with "VMs inside VMs").
>
> But the good news is that we have VERY good data on which tests pass
> to various servers (just as noted, need to update the external pages)
> and we should have even more data as we go through two weeks of SMB3
> testing events in late September.
>
> In general we want to test against all typical servers and have test
> targets setup for
>  - Samba (reasonably current stable) on ext4/xfs and Samba with btrfs
> (which has various optional extensions enabled in the server)
>  - Samba with POSIX Extensions
>  - Windows (and against both NTFS and REFS server file system)
> - Azure (Cloud0
>
> But would really like to add test targets for other common servers and
> in a perfect world would like to be able to have external test
> automation pull our trees periodically to run these (similar to what
> is done for the six targets above):
>   - Macs
>   - NetApp
> (and any others of interest to the community)
>
> Obviously xfstest has a few hundred tests which only make sense for
> local file systems with block devices, but there are hundreds of
> xfstests of value, and most should run on cifs.ko and we are working
> through them but already have a very good set running.
>
> On Mon, Sep 9, 2019 at 5:50 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
> >
> > "Murphy Zhou" <jencce.kernel@gmail.com> writes:
> > > As $subject. Is this wiki being maintained ?
> > >
> > > Looks like the last update was in January 2019.
> > >
> > > https://wiki.samba.org/index.php/Xfstesting-cifs#Exclusion_files
> >
> > We have a buildbot running xfstests relatively often here
> >
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/
> >
> > Each group has slightly different tests run, you can see which one gets
> > run by clicking on a build:
> >
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2=
/builds/249
> >
> > Overall xfstests+cifs is very finicky and frustrating to get working
> > reliably. Not to mention long. So good luck :)
> >
> > Cheers,
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
