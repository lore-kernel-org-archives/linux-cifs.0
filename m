Return-Path: <SRS0=KOHi=R5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25406C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 19:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC47D2075C
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Mar 2019 19:58:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rb6ROm2O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732164AbfCZT6B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:58:01 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42521 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731755AbfCZT6B (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Mar 2019 15:58:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id p20so16134753qtc.9
        for <linux-cifs@vger.kernel.org>; Tue, 26 Mar 2019 12:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0IlFTip4CnNayrYmS7EnqnNHZvsWf6nCxAgS/K53wA4=;
        b=Rb6ROm2O7gq9bL/NZ1hMybP7reAdE2EYz6Aw89GSyzEEKYF1jIlZQA0g/TLBj7q5ur
         8wvAmaNlXHh1GktXNQuBAHKKdS/f/+1U52pKroKBRtfo+NokfAyHIK0FrPiz/veZTDvW
         vrj/A8ZWtu8SuQYX7iroObklGcEejn6sncQHAiBd6aJ8OIYcKGOWsrT8F0sebRWQIjRM
         cBFHLq9ng/8PJRWFgi4FOLWOvjnYARNC99malKy2lkurpK0IUWSGvYSV0ak6SunYqztL
         RK05Xn9BvcsIwtpqtECOe81i9TL6wcvLwVmaiC3DEZhirQKgkWd5yVhLjpj2ul7oPvIo
         x1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0IlFTip4CnNayrYmS7EnqnNHZvsWf6nCxAgS/K53wA4=;
        b=sW14Tvh1vit8jxgDY2ba9AalwdDlck6eZ5QjSBEIZx/CKDp11IsxByc+2RqDWZRira
         1fe8j+f5HAHVINW2ilo2L5pXEf34CZXYk0iEnsg78er/SWUZVWmv3kLeOuxprxNJrF8T
         Hl1PN3OU3hCyT2EClJ8RWginNrE8kBdEq+2zE+IMkjzfKmMDh9Cc9r9kbO5OFPKCif69
         gUjLzSi4RvTK7+M/Uvq2jbvgRYPu22QSuRs29GITZwkHWfCOZSeCxB758Xv0vMo2VdBH
         pYdFqilOvF6ClJ9v0oymZUuP3cUekIfuT4zKNDyWR62EdY4SdZNHcWpoEtbq+hHPm/bc
         mFDQ==
X-Gm-Message-State: APjAAAVD2pYqvvQqlZuxVBPeKK0Zu5kkBjYKLMaGCxbGjiar9OvwdBv2
        1TrRf2Qw0njv6OEueUi9pg0TKgZ5dpWTWmnXryk=
X-Google-Smtp-Source: APXvYqwdNFbP6Q9bZHcBKdyR251McUPxO+CALOlTRLoGAey0uBs+TolrRoEFQryU00qFAarY5d1uRtqZzgzGHGqqg/4=
X-Received: by 2002:a0c:9651:: with SMTP id 17mr12560716qvy.59.1553630280197;
 Tue, 26 Mar 2019 12:58:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms+oJ8PpAbsmTmRDqoS4C=dcNV=xYv3tMWnoigA5JqFsA@mail.gmail.com>
 <CAN05THRYrWBi9cSB5-gbV_y9cAf+0KTPn-2ogPc7SU2t9ob6UQ@mail.gmail.com> <CAH2r5mt4yFse7kmR2Oe6wWSrGCVO2aq=PF2iiC7kYJSY3e7xtA@mail.gmail.com>
In-Reply-To: <CAH2r5mt4yFse7kmR2Oe6wWSrGCVO2aq=PF2iiC7kYJSY3e7xtA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 27 Mar 2019 05:57:48 +1000
Message-ID: <CAN05THR3iNe3HopcqCmsVfEZ3tS-F3AD2K=LVEV3gxHb0JXbJw@mail.gmail.com>
Subject: Re: [RFC][PATCH] Track time spent in each command
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good.

On Wed, Mar 27, 2019 at 4:54 AM Steve French <smfrench@gmail.com> wrote:
>
> How about this updated patch - note how I now display min/max
> (although min in this case will always be zero since jiffies are
> pretty coarse granularity - maybe would be more helpful to run this
> example over a slow link, or I could just make the patch simpler and
> not save the minimum time for each command).  Note that the new stats
> begin with the line "Total time spent processing by command ..."
>
>
>
>
> $ cat /proc/fs/cifs/Stats
> Resources in use
> CIFS Session: 1
> Share (unique mount targets): 3
> SMB Request/Response Buffer: 1 Pool size: 5
> SMB Small Req/Resp Buffer: 1 Pool size: 30
> Total Large 38854 Small 1039857 Allocations
> Operations (MIDs): 0
>
> 0 session 0 share reconnects
> Total vfs operations: 272653 maximum at one time: 3
>
> Total time spent processing by command. Time units are jiffies (250 per second)
>   SMB3 CMD    Number    Total Time    Fastest    Slowest
>   --------    ------    ----------    -------    -------
>   0        1    1        1    1
>   1        2    1        0    1
>   2        0    0        0    0
>   3        6    1        0    1
>   4        3    0        0    0
>   5        95353    5163        0    12
>   6        95314    3012        0    1
>   7        2    2        1    1
>   8        4263    57        0    1
>   9        1101    33        0    1
>   10        0    0        0    0
>   11        16    0        0    0
>   12        0    0        0    0
>   13        0    0        0    0
>   14        121    37        0    1
>   15        0    0        0    0
>   16        56357    1100        0    1
>   17        16703    1089        0    1
>   18        0    0        0    0
>
> 1) \\localhost\btrfs-scratch
> SMBs: 72
> Bytes read: 0  Bytes written: 210729
> Open files: 1 total (local), 2 open on server
> TreeConnects: 1 total 0 failed
> TreeDisconnects: 0 total 0 failed
> Creates: 21 total 2 failed
> Closes: 15 total 0 failed
> Flushes: 0 total 0 failed
> Reads: 0 total 0 failed
> Writes: 11 total 0 failed
> Locks: 0 total 0 failed
> IOCTLs: 2 total 1 failed
> QueryDirectories: 0 total 0 failed
> ChangeNotifies: 0 total 0 failed
> QueryInfos: 22 total 1 failed
> SetInfos: 0 total 0 failed
> OplockBreaks: 0 sent 0 failed
> 2) \\localhost\btrfs
> SMBs: 269059
> Bytes read: 115059522  Bytes written: 87813235
> Open files: 0 total (local), 0 open on server
> TreeConnects: 1 total 0 failed
> TreeDisconnects: 0 total 0 failed
> Creates: 95304 total 14 failed
> Closes: 95277 total 0 failed
> Flushes: 2 total 0 failed
> Reads: 4263 total 0 failed
> Writes: 1090 total 0 failed
> Locks: 0 total 0 failed
> IOCTLs: 2 total 1 failed
> QueryDirectories: 117 total 0 failed
> ChangeNotifies: 0 total 0 failed
> QueryInfos: 56300 total 0 failed
> SetInfos: 16703 total 0 failed
> OplockBreaks: 0 sent 0 failed
>
>
> On Tue, Mar 26, 2019 at 1:38 AM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > Very nice.
> > But maybe min and max to each command as well.
> > I have all three of min/max/avg is very useful.
> >
> > At least avg and max will tell you if there are any abnormal outliers.
> >
> > On Tue, Mar 26, 2019 at 3:39 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > I created a small experimental patch (leveraging the existing code for
> > > the slow command check we already have in mid processing) to track the
> > > total time per SMB2/SMB3 command.   Seems like it could be useful -
> > > here is sample output (see below) from running seven xfstests to
> > > generate the stats (these stats require CONFIG_CIFS_STATS2 to be
> > > compiled as do the slow command counters).   I wanted to keep the
> > > patch small and low risk so this seemed like the best place to capture
> > > it.    This could be helpful in calculating average time per command
> > > (and perhaps help isolate performance problems, and isolate what is
> > > really causing slowdowns).   As with other counters: "echo 0 >
> > > /proc/fs/cifs/Stats" resets them.   The new stats counters start at
> > > the line "Total time spent processing each command"
> > >
> > > Thoughts?
> > >
> > > $ cat /proc/fs/cifs/Stats
> > > Resources in use
> > > CIFS Session: 1
> > > Share (unique mount targets): 3
> > > SMB Request/Response Buffer: 1 Pool size: 5
> > > SMB Small Req/Resp Buffer: 2 Pool size: 30
> > > Total Large 60864 Small 1165977 Allocations
> > > Operations (MIDs): 1
> > >
> > > 0 session 0 share reconnects
> > > Total vfs operations: 280236 maximum at one time: 3
> > > Total time spent processing each command
> > > cmd: 0 jiffies: 0 seconds 0
> > > cmd: 1 jiffies: 2 seconds 0
> > > cmd: 2 jiffies: 0 seconds 0
> > > cmd: 3 jiffies: 1 seconds 0
> > > cmd: 4 jiffies: 1 seconds 0
> > > cmd: 5 jiffies: 6212 seconds 24
> > > cmd: 6 jiffies: 3993 seconds 15
> > > cmd: 7 jiffies: 135 seconds 0
> > > cmd: 8 jiffies: 83 seconds 0
> > > cmd: 9 jiffies: 44 seconds 0
> > > cmd: 10 jiffies: 0 seconds 0
> > > cmd: 11 jiffies: 1 seconds 0
> > > cmd: 12 jiffies: 0 seconds 0
> > > cmd: 13 jiffies: 0 seconds 0
> > > cmd: 14 jiffies: 47 seconds 0
> > > cmd: 15 jiffies: 0 seconds 0
> > > cmd: 16 jiffies: 1890 seconds 7
> > > cmd: 17 jiffies: 1368 seconds 5
> > > cmd: 18 jiffies: 0 seconds 0
> > >
> > > 1) \\localhost\btrfs-scratch
> > > SMBs: 42255
> > > Bytes read: 25379425  Bytes written: 53689661
> > > Open files: 1 total (local), 1 open on server
> > > TreeConnects: 1 total 0 failed
> > > TreeDisconnects: 0 total 0 failed
> > > Creates: 14012 total 0 failed
> > > Closes: 14009 total 0 failed
> > > Flushes: 27 total 0 failed
> > > Reads: 41 total 0 failed
> > > Writes: 112 total 0 failed
> > > Locks: 0 total 0 failed
> > > IOCTLs: 2 total 1 failed
> > > QueryDirectories: 28 total 0 failed
> > > ChangeNotifies: 0 total 0 failed
> > > QueryInfos: 11312 total 0 failed
> > > SetInfos: 2711 total 0 failed
> > > OplockBreaks: 0 sent 0 failed
> > > 2) \\localhost\btrfs
> > > SMBs: 77
> > > Bytes read: 282  Bytes written: 94
> > > Open files: 0 total (local), 0 open on server
> > > TreeConnects: 1 total 0 failed
> > > TreeDisconnects: 0 total 0 failed
> > > Creates: 23 total 0 failed
> > > Closes: 21 total 0 failed
> > > Flushes: 0 total 0 failed
> > > Reads: 3 total 0 failed
> > > Writes: 1 total 0 failed
> > > Locks: 0 total 0 failed
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve
