Return-Path: <SRS0=COnU=XH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29007C49ED9
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 09:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0204208C2
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 09:07:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ADApmewO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfILJHF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Sep 2019 05:07:05 -0400
Received: from mail-io1-f46.google.com ([209.85.166.46]:34913 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730434AbfILJHF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Sep 2019 05:07:05 -0400
Received: by mail-io1-f46.google.com with SMTP id f4so52060736ion.2
        for <linux-cifs@vger.kernel.org>; Thu, 12 Sep 2019 02:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o41sqLIeJyqGlAGB6kekaxlMfKaSsg1MJUO+ExYEeuM=;
        b=ADApmewONOSpt+Sr/0TKnf3eKegNVD2MG38g1L7kVbAIu26lE8hDBXmdOHRYf3dnar
         DOhvPhZhL+lmvePyHALbuo71JbO1cR+Tqips6QUI9An/AiD6DfmClZ3lkH6YEKIJLD2H
         4+J94VTPp3sWDpJG0G1o7xWHOxBrt/oiRExzOR+DfTI9sV7WcFlHvES7xB2jVtxSqEJi
         tTkqjtow+NgOdNal6L9AyPIeV/C9fTNA632GCoGECYJMEC4xVKz2GE8HTZKpXT4bmxhq
         /sZpx+XbbhfI7fMNAOoFoH8FfEBUv3mMjOFz0eUBRv3yQUDENslp0S6FGIA2DB/zVptb
         KNGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o41sqLIeJyqGlAGB6kekaxlMfKaSsg1MJUO+ExYEeuM=;
        b=txmxy0fdmOU5BmxeAVZpgJU9mDyEgBM8qUxmVPnEz99BVhTEIpCzquDg8ZOSu4JK+S
         LwPxh6nNnL3YkRXHZb5zKndNO+3D4uK4zPI3FrrW5BTUdOlOvVoWPNp5uNgtQb2/SZIM
         U7WQnjWt4uiYBBdBcRhWAZ1hyqfiMKljQGKiARxUlVYDbA05l0xhWy2boOyLKmdh/r2W
         Ym5WHZSa7QTPV7XTGDGA071ODfD/NWQOKnFKGrHJMs8sekCbWRsGavMSa4C0Ol5AFetJ
         f3FbrNdtv+CxJUl/CrwLdkaxDFjgcbS3zIW0tOZZQcd5elg5UH3Q7RDrPgLf34iNLwf6
         u8lA==
X-Gm-Message-State: APjAAAVtaRaecUDX7fTPsc2jLve9rSEY7/r5d9q4YM6nhurnJqno/9NC
        eJxpWMgiqAUbhJSJk/skoGTalsTqnVxBasyhjmk=
X-Google-Smtp-Source: APXvYqy5/WnfdZYvKjUUIcZzFZvqiikFYYH9RpvNxsDdaxtbVTLfKmh61l1wYP5blfgdGq+xlNDHnh2qMGcmLj06LY8=
X-Received: by 2002:a6b:4404:: with SMTP id r4mr3072279ioa.159.1568279224082;
 Thu, 12 Sep 2019 02:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190909104127.nsdxptzxcf5a6b72@XZHOUW.usersys.redhat.com>
 <87mufdiw0u.fsf@suse.com> <CAH2r5mt9etVvg5jFk5jXRV6FadGz=qcqgG+JBhojKwVKmvRPZw@mail.gmail.com>
 <20190912084914.4hwfptpaqdod6f6k@XZHOUW.usersys.redhat.com>
In-Reply-To: <20190912084914.4hwfptpaqdod6f6k@XZHOUW.usersys.redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 12 Sep 2019 19:06:52 +1000
Message-ID: <CAN05THSw6fCjjDjPmNppRTpogvREQwLy_2BCOZiU+R-_Gj+agQ@mail.gmail.com>
Subject: Re: Are the xfstests exclusion files on wiki.samba.org up to date?
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 12, 2019 at 6:50 PM Murphy Zhou <jencce.kernel@gmail.com> wrote=
:
>
> On Mon, Sep 09, 2019 at 06:23:10PM -0500, Steve French wrote:
> > We have done a lot of work (with Ronnie, Aurelien, Pavel and others)
> > on xfstest automation.
>
> Kudos!
>
> >
> > As you might guess it is frustrating for two reasons:
> > 1) updated xfstests can be flaky (as the tests themselves are updated,
> > they add subtle required features, or regress from time to time)
> > 2) test automation can run into resource constraints (VMs trying to
> > run tests with less memory than might be optimal - especially those
> > run against Samba with "VMs inside VMs").
> >
> > But the good news is that we have VERY good data on which tests pass
> > to various servers (just as noted, need to update the external pages)
> > and we should have even more data as we go through two weeks of SMB3
> > testing events in late September.
> >
> > In general we want to test against all typical servers and have test
> > targets setup for
> >  - Samba (reasonably current stable) on ext4/xfs and Samba with btrfs
> > (which has various optional extensions enabled in the server)
> >  - Samba with POSIX Extensions
> >  - Windows (and against both NTFS and REFS server file system)
> > - Azure (Cloud0
>
> Thanks for sharing this!
>
> Besides server type, server configuration options and client mount
> options also make this matrix even bigger..
>
> How that is handled in the buildbot ?

We have several different targets, which maps to the local.config for
xfstests so for every single test we run
we also specify the different targets to run that for.

Here is an example:
all_tests =3D [
        [ "cifs/100", "smb3azureseal"],
        [ "cifs/101", "smb3multiuser"],
        [ "generic/001", "smb3sign", "smb3"],
        [ "generic/002", "smb3", "smb3sign", "smb21", "smb3samba"],
        [ "generic/005", "smb3", "smb21", "smb3samba", "smb3sambabtrfs"],
        [ "generic/006", "smb3"],
        [ "generic/007", "smb3"],
        [ "generic/010", "smb3"],
        [ "generic/011", "smb3"],
        [ "generic/013", "smb3samba"],
        [ "generic/014", "smb3"],
        [ "generic/020", "smb3samba"],
        [ "generic/023", "smb3samba"],
        [ "generic/024", "smb3", "smb3samba"],
        [ "generic/028", "smb3", "smb3samba"],
...


The first argument is which xfstest to run and the remainder of the
arguments are a list of which local.config.* files to use.
That way we can run a test against different servers and also
different configurations.
I try to keep the target names meaningful, so

"smb3" just means a basic smb3   windows 2016 server running in a vm
"smb3samba" is just a generic smb3 server with samba.
etc etc.


We started doing this upstream about a year ago which is when I
started setting it up
and now I am honest but since we do this for every pull request we
send to linus,
we have SIGNIFICANTLY increased the quality of cifs.ko.

We run quite a lot of tests nowadays and I always try to remind Steve
to "please put a link to the buildbot result in the pull request"
to bring awareness to our buildbot.

For upstream, here is the most recent test:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/bui=
lds/249

cifs-testing is the most generic test target. We also have specific
targets that are just for Azure, and other targets, but the aim is
that the canonical cifs-target tests will all pass before we pass a
pull request onto linus.


Please contact me directly if you want more info about the buildbot. I
have one setup internally at rh too that runs many, but not all, the
tests we run upstream.
Any help to maintain and expand the tests are super welcome.


Rant-off
ronnie sahlberg

>
> >
> > But would really like to add test targets for other common servers and
> > in a perfect world would like to be able to have external test
> > automation pull our trees periodically to run these (similar to what
> > is done for the six targets above):
> >   - Macs
> >   - NetApp
> > (and any others of interest to the community)
> >
> > Obviously xfstest has a few hundred tests which only make sense for
> > local file systems with block devices, but there are hundreds of
> > xfstests of value, and most should run on cifs.ko and we are working
> > through them but already have a very good set running.
>
> Agree!  Thanks!
>
> Murphy
>
> >
> > On Mon, Sep 9, 2019 at 5:50 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wr=
ote:
> > >
> > > "Murphy Zhou" <jencce.kernel@gmail.com> writes:
> > > > As $subject. Is this wiki being maintained ?
> > > >
> > > > Looks like the last update was in January 2019.
> > > >
> > > > https://wiki.samba.org/index.php/Xfstesting-cifs#Exclusion_files
> > >
> > > We have a buildbot running xfstests relatively often here
> > >
> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/
> > >
> > > Each group has slightly different tests run, you can see which one ge=
ts
> > > run by clicking on a build:
> > >
> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders=
/2/builds/249
> > >
> > > Overall xfstests+cifs is very finicky and frustrating to get working
> > > reliably. Not to mention long. So good luck :)
> > >
> > > Cheers,
> > > --
> > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnb=
erg, DE
> > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
