Return-Path: <SRS0=/Ffk=WL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB95C31E40
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Aug 2019 06:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38E4A2086C
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Aug 2019 06:31:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cONI0a3w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbfHOGbJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Aug 2019 02:31:09 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:46021 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729796AbfHOGbJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Aug 2019 02:31:09 -0400
Received: by mail-ot1-f52.google.com with SMTP id m24so3691840otp.12
        for <linux-cifs@vger.kernel.org>; Wed, 14 Aug 2019 23:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hLl0V+v0CBFiaOTChkifXK+5J0G0M11GkC8pAADHk5Q=;
        b=cONI0a3wY3czey16nepuZN8r33Gmk9q6rBtlOlX6SXr7hTh+DGcaZulP+kV94Wjx8+
         8n76ZUMgdJA82Yih03UsLjGc9Tp+iXnbjYwdHDKNd3GkvuXGil8XabAevSdTJpfzq/jv
         BoHZ4Hpi6a16Ej25Pz4zKUmfb045aDWqwY5XsdU7edteQryl4J2hvjSjGQP3w7jiDrg8
         AHW2GQYqH/w33ORP5iysc2lnJTawTMFCxqVB6R7nAvTogJPc+qyIyp4X/HtV0d2biwVv
         cQAA5CwdtfoMuVoRgck+J9hY16T2OI+dRk4//Kidn+nDTFrBEVD9ghkR5yZRrmh3KM96
         FoiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hLl0V+v0CBFiaOTChkifXK+5J0G0M11GkC8pAADHk5Q=;
        b=LFQ4pm+ycQSCkokrtFxO6C9/6SkEgfdFcGCJMhXVbq6aw/Ikr6SVG6J5WhhDJncGLB
         FRFBCcfz9ctrbYU8Go4ZMM/uR4fnPva3W3wDewSgO/xONPJFPWfqkoH4MeXRxR2ijjkN
         4ZikO9IDe4qlerE/lh9Jg98Vrjm7NhFfM/jF52vnJNtZNJCn3wjByrTWzXYp1AUWCkDI
         c8VNHAnxHr24s1lCp+xhLc5mJ6AwIdy7JKj3b9XcDVkGSXQp4VAn/QbyBvv+kKksNEwR
         zIXXHJ0s8aqWOmtwQoRifak6nThP5giL1GIe9cswm7NUpfN6sI/osafbf0QsFziwEcxI
         6GKg==
X-Gm-Message-State: APjAAAWc4D4XPKm9Y+Spvc4gmtLiNoJ3ENNXco/7qCujT2Sl+wgYl5vM
        uicthLGPReIumoHRGnd7O9/nCaa/iVot/2moo20JZbFK
X-Google-Smtp-Source: APXvYqwzciqf46SHd12pph6pi+wOW3usxd2JPuowkGoiQMlY+ZTT+l1gxT399jKdivMKlJw6vW8s09slryvhSLs6l48=
X-Received: by 2002:a6b:3883:: with SMTP id f125mr3943623ioa.109.1565850668082;
 Wed, 14 Aug 2019 23:31:08 -0700 (PDT)
MIME-Version: 1.0
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 15 Aug 2019 16:30:56 +1000
Message-ID: <CAN05THT0OkbAoNu8ZVSHF-xY7w0ZW4q4i-jTxjNManrnz0OMfg@mail.gmail.com>
Subject: FSCTL_QUERY_ALLOCATED_RANGES issue with Windows2016
To:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I am seeing issues with how FSCTL_QUERY_ALLOCATED_RANGES behaves under windows,
in particular that it is inconsistent so we can't run certain xfstests
against windows servers.


The behavior can be triggered using the following command from xfstests :
  ./src/seek_sanity_test -s 19 -e 19 /mnt/file
(where /mnt is an smb share mounted from a windows 2016 server.)

In cifs.ko we use this FSCTL to implement both SEEK_HOLE/SEEK_DATA as well as
fiemap(). But since the behavior of this FSCTL is not deteministic it often
cause the tests to fail.


This is a test tool for SEEK_DATA and SEEK_HOLE. As part of this it performs
a check to try to discover if the filesystem supports sparse files or not.
For non-sparse files SEEK_DATA is basically a no-op and SEEK_HOLE just returns
the file size.
Later during the test, the result of whether the file is "sparse" or not
will affect what the expected results are. If this check gets the
sparse-supported wrong the test cases later will fail.


How the check works:
====================
The actual check for whether the file supports being sparse or not is the
following snippet :
        ftruncate(fd, 0);
        bufsz = alloc_size * 2;
        filsz = bufsz * 2;

        buf = do_malloc(bufsz);
        if (!buf)
                goto out;
        memset(buf, 'a', bufsz);

        /* File with 2 allocated blocks.... */
        ret = do_pwrite(fd, buf, bufsz, 0);
        if (ret)
                goto out;

        /* followed by a hole... */
        ret = do_truncate(fd, filsz);
        if (ret)
                goto out;

        /* Is SEEK_DATA and SEEK_HOLE supported in the kernel? */
        pos = lseek(fd, 0, SEEK_HOLE);
        if (pos == -1) {
                fprintf(stderr, "Kernel does not support llseek(2) extension "
                        "SEEK_HOLE. Aborting.\n");
                ret = -1;
                goto out;
        }

        if (pos == filsz) {
                default_behavior = 1;
                fprintf(stderr, "File system supports the default behavior.\n")\
;
        }

I.e.
1, ftruncate to 0
2, write 2M to the start of the file
3, ftruncate the file to be 4Mb
4, SEEK_HOLE and check if it returns 4Mb or no.
If it returns 4Mb then we switch back to default_behavior and we allow
the semantics as if the file is not sparse.
I.e. allow SEEK_DATA to behave as if the file is either sparse or not-sparse.

Also note that if it looks like the sparse-file is not supported then
it prints ""File system supports the default behavior." which may help when
running the test tool.

Strace for this check (when the check failed.)
=============================================
18:22:14.949612 ftruncate(3, 0)         = 0 <0.011513>
18:22:14.963725 mmap(NULL, 2101248, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe8d9f14000 <0.0
00192>
18:22:14.970334 pwrite64(3,
"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"...,
2097152, 0) = 2097152 <0.002127>
18:22:14.972620 ftruncate(3, 4194304)   = 0 <0.582491>
18:22:15.557308 lseek(3, 0, SEEK_HOLE)  = 4194304 <0.012791>
18:22:15.572457 write(2, "File system supports the default
behavior.\n", 43) = 43 <0.000318>


Example of when the check goes "Wrong". Capture seek_good.cap
=============================================================
The relevant packets here are
1820, set end of file == 0
(1822/1823 update timestamps)
2930, write 2Mb to offset 0
3008, set the file sparse
3010, set end of file to 4M
3019, query-allocated-ranges

In 3019/3020 the server responds that the full 0-4M range is allocated.
This is wrong since file should only be allocated in the first 2Mb at
this stage.
And this makes the test tool think that we don't support sparse files,
and sets default_behavior to 1.

A different run when the check is successful (seek_bad.cap)
============================================================
In the seek_bad capture you can see the same sequence in packets
1869, set end of file == 0
2990, write the first 2M of the file
3067, set file sparse
3069, set end of file to 4M
3078, query-allocated-ranges
But this time, query-allocated-ranges report that only 0-2M is mapped,
which is the correct range,
and thus the test tool assumes that we can handle holes properly.

The captures are ~5MByte each unfiltered so too big for the list.
Email me directly and I will send them to you.


So the question here is what is the actual semantics for sparse files
and query-allocated-ranges on windows?


regards
ronnie sahlberg
