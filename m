Return-Path: <SRS0=Inbq=XJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442E0C49ED7
	for <linux-cifs@archiver.kernel.org>; Sat, 14 Sep 2019 00:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07AFC20692
	for <linux-cifs@archiver.kernel.org>; Sat, 14 Sep 2019 00:02:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l6Jhb1Ue"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388508AbfINACf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Sep 2019 20:02:35 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:35733 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388019AbfINACf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Sep 2019 20:02:35 -0400
Received: by mail-pg1-f174.google.com with SMTP id n4so16099538pgv.2
        for <linux-cifs@vger.kernel.org>; Fri, 13 Sep 2019 17:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZceXkaFbLfQDK/lAWSFZdIYxWI4w4Ch/WDpeA1zCMLQ=;
        b=l6Jhb1UedQAarHtqumJj5TeTRm71/UkPmzEad+oH+gM7Ek4qLQvlSQq9ZaJ+dnstQu
         Gwko0MIwNWccAp9nVELRGbAPCf3hKYANQ6uDTDC3FH5CAA4pyvmTITWrhk0RhJzT4szn
         dNFj5Tk/fz5UJwoDaAEYRFpWJ1QGtU1fJqGUgJxEgtUmWS+HLVfA2b7F7lNRtrcnrTG7
         VFF6Y1UEogDGsgxxPdUNEZl9rRBUwprakAEYBOR5sAlZzsVcItvQoDLUPxnO0OX3pPzv
         S4l0dZR13pdEcLkydoAKYM+PpUohin7ko2DpOd9g7cqILqAsjn1pgo9cH2yXthuhDwrX
         mHgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZceXkaFbLfQDK/lAWSFZdIYxWI4w4Ch/WDpeA1zCMLQ=;
        b=hcrgNOErOsKFQ9DVTAo2Fv/cc70haKQC0nCcqymCQtQ/YIWNblpm2sl7VeKw18kqLh
         UHExcKKguhxY7D1v+KzO1AMHBiBkLjYi14gDtK/KDAgFngrPhpNSoOIoqaUb4xslU1t2
         +x0i6c3rTSo1Y5GdO7n8jTGhCLBBk0HiJZzHMrASK8WVZ2le1OGddf1iFurpYK6vEhc3
         5iSuN5locp4Leptb5nJuEtN9yDvRwgI9X2HXXt00IyisQRC0hCCINQ/MXArIjuy1yH5w
         SEVOZRs+U+8ilpSWXy5yahoJbF7T6BaqFe22gTaB68bGCWvfyblnsYcY299TmrSgHSFy
         MAHA==
X-Gm-Message-State: APjAAAWjB7Oac97fZy0thNFvLv48BX/kBVn9C9oQK5xQjElB2HBo+SjN
        AVwTP4UEAx67zgM8+dLk4tM=
X-Google-Smtp-Source: APXvYqzL5w3l+xALAnkJo786Y++rfz3UjVuzyVBEyDv3wux+ju1cPsFH2DF91QRafri+hVOS8l1A7g==
X-Received: by 2002:a17:90a:d804:: with SMTP id a4mr8229339pjv.43.1568419354331;
        Fri, 13 Sep 2019 17:02:34 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u5sm30540276pfl.25.2019.09.13.17.02.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 17:02:33 -0700 (PDT)
Date:   Sat, 14 Sep 2019 08:02:25 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        Steve French <smfrench@gmail.com>,
        =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Are the xfstests exclusion files on wiki.samba.org up to date?
Message-ID: <20190914000225.raez7vcvl5wkhn3z@XZHOUW.usersys.redhat.com>
References: <20190909104127.nsdxptzxcf5a6b72@XZHOUW.usersys.redhat.com>
 <87mufdiw0u.fsf@suse.com>
 <CAH2r5mt9etVvg5jFk5jXRV6FadGz=qcqgG+JBhojKwVKmvRPZw@mail.gmail.com>
 <20190912084914.4hwfptpaqdod6f6k@XZHOUW.usersys.redhat.com>
 <CAN05THSw6fCjjDjPmNppRTpogvREQwLy_2BCOZiU+R-_Gj+agQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN05THSw6fCjjDjPmNppRTpogvREQwLy_2BCOZiU+R-_Gj+agQ@mail.gmail.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Sep 12, 2019 at 07:06:52PM +1000, ronnie sahlberg wrote:
> On Thu, Sep 12, 2019 at 6:50 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> >
> > On Mon, Sep 09, 2019 at 06:23:10PM -0500, Steve French wrote:
> > > We have done a lot of work (with Ronnie, Aurelien, Pavel and others)
> > > on xfstest automation.
> >
> > Kudos!
> >
> > >
> > > As you might guess it is frustrating for two reasons:
> > > 1) updated xfstests can be flaky (as the tests themselves are updated,
> > > they add subtle required features, or regress from time to time)
> > > 2) test automation can run into resource constraints (VMs trying to
> > > run tests with less memory than might be optimal - especially those
> > > run against Samba with "VMs inside VMs").
> > >
> > > But the good news is that we have VERY good data on which tests pass
> > > to various servers (just as noted, need to update the external pages)
> > > and we should have even more data as we go through two weeks of SMB3
> > > testing events in late September.
> > >
> > > In general we want to test against all typical servers and have test
> > > targets setup for
> > >  - Samba (reasonably current stable) on ext4/xfs and Samba with btrfs
> > > (which has various optional extensions enabled in the server)
> > >  - Samba with POSIX Extensions
> > >  - Windows (and against both NTFS and REFS server file system)
> > > - Azure (Cloud0
> >
> > Thanks for sharing this!
> >
> > Besides server type, server configuration options and client mount
> > options also make this matrix even bigger..
> >
> > How that is handled in the buildbot ?
> 
> We have several different targets, which maps to the local.config for
> xfstests so for every single test we run
> we also specify the different targets to run that for.
> 
> Here is an example:
> all_tests = [
>         [ "cifs/100", "smb3azureseal"],
>         [ "cifs/101", "smb3multiuser"],
>         [ "generic/001", "smb3sign", "smb3"],
>         [ "generic/002", "smb3", "smb3sign", "smb21", "smb3samba"],
>         [ "generic/005", "smb3", "smb21", "smb3samba", "smb3sambabtrfs"],
>         [ "generic/006", "smb3"],
>         [ "generic/007", "smb3"],
>         [ "generic/010", "smb3"],
>         [ "generic/011", "smb3"],
>         [ "generic/013", "smb3samba"],
>         [ "generic/014", "smb3"],
>         [ "generic/020", "smb3samba"],
>         [ "generic/023", "smb3samba"],
>         [ "generic/024", "smb3", "smb3samba"],
>         [ "generic/028", "smb3", "smb3samba"],
> ...
> 
> 
> The first argument is which xfstest to run and the remainder of the
> arguments are a list of which local.config.* files to use.
> That way we can run a test against different servers and also
> different configurations.

This is smart. :)

> I try to keep the target names meaningful, so
> 
> "smb3" just means a basic smb3   windows 2016 server running in a vm
> "smb3samba" is just a generic smb3 server with samba.
> etc etc.
> 
> 
> We started doing this upstream about a year ago which is when I
> started setting it up
> and now I am honest but since we do this for every pull request we
> send to linus,
> we have SIGNIFICANTLY increased the quality of cifs.ko.

/Thumbs up!

> 
> We run quite a lot of tests nowadays and I always try to remind Steve
> to "please put a link to the buildbot result in the pull request"
> to bring awareness to our buildbot.
> 
> For upstream, here is the most recent test:
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/249
> 
> cifs-testing is the most generic test target. We also have specific
> targets that are just for Azure, and other targets, but the aim is
> that the canonical cifs-target tests will all pass before we pass a
> pull request onto linus.
> 
> 
> Please contact me directly if you want more info about the buildbot. I
> have one setup internally at rh too that runs many, but not all, the
> tests we run upstream.

Sure! Have replied to you. Thank you very much for sharing!

If anybody resting cifs or I know that the expected setup and result of
every tests for you developers, it will save much time of investigation
and report false alarms.

After several months working on cifs, I've got a feeling that cifs is
much different from other Linux filesystems. Maybe because of Windows
or the SMB protocols. I'm wondering that xfstests which is a typical
testsuite for Unix/Linux filesystems, maybe is not that suitable for
cifs. I agree with Steve that there are hundreds of tests suitable.
If, only if, :) if we could know how MS testing NTFS or SMB protocols,
would that help or more suitable?


Thanks!
Murphy


> Any help to maintain and expand the tests are super welcome.
> 
> 
> Rant-off
> ronnie sahlberg
> 
> >
> > >
> > > But would really like to add test targets for other common servers and
> > > in a perfect world would like to be able to have external test
> > > automation pull our trees periodically to run these (similar to what
> > > is done for the six targets above):
> > >   - Macs
> > >   - NetApp
> > > (and any others of interest to the community)
> > >
> > > Obviously xfstest has a few hundred tests which only make sense for
> > > local file systems with block devices, but there are hundreds of
> > > xfstests of value, and most should run on cifs.ko and we are working
> > > through them but already have a very good set running.
> >
> > Agree!  Thanks!
> >
> > Murphy
> >
> > >
> > > On Mon, Sep 9, 2019 at 5:50 PM Aurélien Aptel <aaptel@suse.com> wrote:
> > > >
> > > > "Murphy Zhou" <jencce.kernel@gmail.com> writes:
> > > > > As $subject. Is this wiki being maintained ?
> > > > >
> > > > > Looks like the last update was in January 2019.
> > > > >
> > > > > https://wiki.samba.org/index.php/Xfstesting-cifs#Exclusion_files
> > > >
> > > > We have a buildbot running xfstests relatively often here
> > > >
> > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/
> > > >
> > > > Each group has slightly different tests run, you can see which one gets
> > > > run by clicking on a build:
> > > >
> > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/249
> > > >
> > > > Overall xfstests+cifs is very finicky and frustrating to get working
> > > > reliably. Not to mention long. So good luck :)
> > > >
> > > > Cheers,
> > > > --
> > > > Aurélien Aptel / SUSE Labs Samba Team
> > > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
> > > > GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
