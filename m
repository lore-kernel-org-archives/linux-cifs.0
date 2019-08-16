Return-Path: <SRS0=NG9T=WM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB8BC3A589
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Aug 2019 02:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80EC92086C
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Aug 2019 02:17:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rfFm4WG7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfHPCR7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Aug 2019 22:17:59 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39072 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfHPCR7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Aug 2019 22:17:59 -0400
Received: by mail-io1-f65.google.com with SMTP id l7so3286824ioj.6
        for <linux-cifs@vger.kernel.org>; Thu, 15 Aug 2019 19:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5CWbRB+6lcdTEfnkfh1RmXwlqOJSO4GV0ObJiGlYZXc=;
        b=rfFm4WG7O1QvpeFYLJCL3C1JtX7BPMEEOCTIHq0Kjvc8t6HbicoED6oOtoQuqqagyx
         kMIHxQgn5VmnpdBYlQactrtDsjtWYGoYAJ+S61cuBfC+uDOx9y+88FijZO4zo+afkdMw
         GiPnJMQZZIZaGrksXrDCrliYFEv3Al5yheOMRep+0D0JyUfuU4d5Dzhqx/I3Rx7MFMir
         OuyNgypiSsFvTSxLzFUtr1H0W9DScC63yjUZTJNoXVtvHh+kI8/hp18pmX2DrLbKdlQY
         cxufeLI6Q5IacvVcFKNw5vsd8m+dS0py7Xx7JX2Yu9RsQmYDqVq4+vDDRIXIQpuNWZdN
         bDgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5CWbRB+6lcdTEfnkfh1RmXwlqOJSO4GV0ObJiGlYZXc=;
        b=ON95bJps9BwbiyqM/qiOgyBz2q9q6bBzbJ0mkycZUnlRrwsGsjUvSUKxeqUB/0Bp7b
         uIW43TTLkZC4z5F7QOmym2pmvxxmAb/R98HTYWeylWkn1miJo6Yn8pY0P0pdxfUegUKv
         AsOR+4GpDBpv3CNq/AHTPsLEADKoS0OY6cu3R6bMO0vaU9vMbflW8q6cDGeQqmWIZbwE
         rBflqwUnRxzj5dgHvCaoUXDmDz7nzfx1ClX82cjyrFVkW9UhZGAfrWf6cuIlx0CsIxo9
         NyLQ+Wsmdxd7iU6WdljnQLe+sfo8d/nIN3YSzi0qcNVQd5d2EoPERaKkTznGvw80aBmw
         xTxQ==
X-Gm-Message-State: APjAAAVysctpXB4JLPpZVksVui8OhUtVgv8RWD2wBuvQ8h2LVo/stIDc
        LI+Xtgytpam6nF4X1fJK3Y6dhREREFGCuZxtPHM=
X-Google-Smtp-Source: APXvYqx+pRYr+OKcAu3B2O+SehodFeARHrEPHJfu+rvM2kGKx+YFSfiI6otu9QISNiCdPKnjKCUAhzLSx8xfJ2Uo7BY=
X-Received: by 2002:a6b:641a:: with SMTP id t26mr8820905iog.3.1565921878017;
 Thu, 15 Aug 2019 19:17:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAN05THT0OkbAoNu8ZVSHF-xY7w0ZW4q4i-jTxjNManrnz0OMfg@mail.gmail.com>
 <MWHPR2101MB073136FE90E5C6FCD9F21CA8A0AC0@MWHPR2101MB0731.namprd21.prod.outlook.com>
In-Reply-To: <MWHPR2101MB073136FE90E5C6FCD9F21CA8A0AC0@MWHPR2101MB0731.namprd21.prod.outlook.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 16 Aug 2019 12:17:46 +1000
Message-ID: <CAN05THSViBXp5RTj_zv1FD_ELRn+ob9A63Gp7bprjEfXjv2TGg@mail.gmail.com>
Subject: Re: FSCTL_QUERY_ALLOCATED_RANGES issue with Windows2016
To:     Tom Talpey <ttalpey@microsoft.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Aug 16, 2019 at 1:15 AM Tom Talpey <ttalpey@microsoft.com> wrote:
>
> > -----Original Message-----
> > From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org> On
> > Behalf Of ronnie sahlberg
> > Sent: Wednesday, August 14, 2019 11:31 PM
> > To: linux-cifs <linux-cifs@vger.kernel.org>
> > Subject: FSCTL_QUERY_ALLOCATED_RANGES issue with Windows2016
> >
> > I am seeing issues with how FSCTL_QUERY_ALLOCATED_RANGES behaves
> > under windows,
> > in particular that it is inconsistent so we can't run certain xfstests
> > against windows servers.
> >
> >
> > The behavior can be triggered using the following command from xfstests :
> >   ./src/seek_sanity_test -s 19 -e 19 /mnt/file
> > (where /mnt is an smb share mounted from a windows 2016 server.)
> >
> > In cifs.ko we use this FSCTL to implement both SEEK_HOLE/SEEK_DATA as well
> > as
> > fiemap(). But since the behavior of this FSCTL is not deteministic it often
> > cause the tests to fail.
> >
> >
> > This is a test tool for SEEK_DATA and SEEK_HOLE. As part of this it performs
> > a check to try to discover if the filesystem supports sparse files or not.
> > For non-sparse files SEEK_DATA is basically a no-op and SEEK_HOLE just returns
> > the file size.
> > Later during the test, the result of whether the file is "sparse" or not
> > will affect what the expected results are. If this check gets the
> > sparse-supported wrong the test cases later will fail.
> >
> >
> > How the check works:
> > ====================
> > The actual check for whether the file supports being sparse or not is the
> > following snippet :
> >         ftruncate(fd, 0);
> >         bufsz = alloc_size * 2;
> >         filsz = bufsz * 2;
> >
> >         buf = do_malloc(bufsz);
> >         if (!buf)
> >                 goto out;
> >         memset(buf, 'a', bufsz);
> >
> >         /* File with 2 allocated blocks.... */
> >         ret = do_pwrite(fd, buf, bufsz, 0);
> >         if (ret)
> >                 goto out;
> >
> >         /* followed by a hole... */
> >         ret = do_truncate(fd, filsz);
> >         if (ret)
> >                 goto out;
> >
> >         /* Is SEEK_DATA and SEEK_HOLE supported in the kernel? */
> >         pos = lseek(fd, 0, SEEK_HOLE);
> >         if (pos == -1) {
> >                 fprintf(stderr, "Kernel does not support llseek(2) extension "
> >                         "SEEK_HOLE. Aborting.\n");
> >                 ret = -1;
> >                 goto out;
> >         }
> >
> >         if (pos == filsz) {
> >                 default_behavior = 1;
> >                 fprintf(stderr, "File system supports the default behavior.\n")\
> > ;
> >         }
> >
> > I.e.
> > 1, ftruncate to 0
> > 2, write 2M to the start of the file
> > 3, ftruncate the file to be 4Mb
> > 4, SEEK_HOLE and check if it returns 4Mb or no.
> > If it returns 4Mb then we switch back to default_behavior and we allow
> > the semantics as if the file is not sparse.
> > I.e. allow SEEK_DATA to behave as if the file is either sparse or not-sparse.
> >
> > Also note that if it looks like the sparse-file is not supported then
> > it prints ""File system supports the default behavior." which may help when
> > running the test tool.
> >
> > Strace for this check (when the check failed.)
> > =============================================
> > 18:22:14.949612 ftruncate(3, 0)         = 0 <0.011513>
> > 18:22:14.963725 mmap(NULL, 2101248, PROT_READ|PROT_WRITE,
> > MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe8d9f14000 <0.0
> > 00192>
> > 18:22:14.970334 pwrite64(3,
> > "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
> > aaaaaaaaaaaaaaaaaa
> > aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
> > aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
> > aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"...,
> > 2097152, 0) = 2097152 <0.002127>
> > 18:22:14.972620 ftruncate(3, 4194304)   = 0 <0.582491>
> > 18:22:15.557308 lseek(3, 0, SEEK_HOLE)  = 4194304 <0.012791>
> > 18:22:15.572457 write(2, "File system supports the default
> > behavior.\n", 43) = 43 <0.000318>
> >
> >
> > Example of when the check goes "Wrong". Capture seek_good.cap
> > =============================================================
> > The relevant packets here are
> > 1820, set end of file == 0
> > (1822/1823 update timestamps)
> > 2930, write 2Mb to offset 0
> > 3008, set the file sparse
> > 3010, set end of file to 4M
> > 3019, query-allocated-ranges
> >
> > In 3019/3020 the server responds that the full 0-4M range is allocated.
> > This is wrong since file should only be allocated in the first 2Mb at
> > this stage.
> > And this makes the test tool think that we don't support sparse files,
> > and sets default_behavior to 1.
> >
> > A different run when the check is successful (seek_bad.cap)
> > ============================================================
> > In the seek_bad capture you can see the same sequence in packets
> > 1869, set end of file == 0
> > 2990, write the first 2M of the file
> > 3067, set file sparse
> > 3069, set end of file to 4M
> > 3078, query-allocated-ranges
> > But this time, query-allocated-ranges report that only 0-2M is mapped,
> > which is the correct range,
> > and thus the test tool assumes that we can handle holes properly.
> >
> > The captures are ~5MByte each unfiltered so too big for the list.
> > Email me directly and I will send them to you.
> >
> >
> > So the question here is what is the actual semantics for sparse files
> > and query-allocated-ranges on windows?
>
> I'll try to get you an answer, but in the meantime just a question...
> Does the behavior change if the file is opened with FILE_FLAG_WRITE_THROUGH?

I will try that shortly.
There is a SMB2_FLUSH call on the handle immediately before the call
to QUERY-ALLOCATED_RANGES.
Would that have the same effect as the writethrough flag?

I am happy to email the wireshark traces to you to look at exactly
what goes on on the wire.
I have two example traces, taken a minute apart.
One instance QAR reports a range of 0-2M, the other the reported range is 0-4M


>
> Tom.
