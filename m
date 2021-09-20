Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76312C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5385D6115B
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbhITQii (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhITQii (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 12:38:38 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7FDC061574
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 09:37:11 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id e15so31371109lfr.10
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 09:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q5qTWsOp/vvWOiapJWWjUvRwj5LnjEwpJTDdL1HsZHM=;
        b=XXprkHFKjLmr+jJf03VsNVwAyQfoUJQaI4bXB6eDWgaHE3xB6xTabQw0vceTsvaTVb
         RZES93TJbrsB+NVM1pEuAK5ZSHcA+ADp8gNTzeG+oyP0FvcOGhgpGlMukgQq6/y3OJjO
         AVqvZhAKDilU1iSDnX2QcS2ntNbxkzWHyVPf/174FSNn+udLmN0LjZLiP5DWtee/vFll
         sEX8iGT9l9EKsCUXFnNsGtT76/ocKSD0VUAxzY7YbNz7SUmbYWWA3/W4JJOigaN3YI84
         Qo4cX34g0Lj9E2wxrSJrW8a1I+zQNTTA8eiPvnQNOUV6sZk60/AOU0tozH1uyzG5LJ9j
         g3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q5qTWsOp/vvWOiapJWWjUvRwj5LnjEwpJTDdL1HsZHM=;
        b=CbfXFwvSH3gYq7vmR+RscszhT3eX+YYcnCQcnGCYlQM3EtU78R6nwtbDbyYNjjdYyX
         Te5BfYU+UqtKLm8UVSZYQVEAJ7pomK0gPJtCnIQH+Nq+H0HLF6CcYNXFB5b/Dx8RHuuw
         NwGK5HqcQAAjVaW7n37qDfUQv87jR3GeS/JZCBIaxQjvt5ic80y0poIWU5ddUcEgu8mt
         8ZKdHUp6b9zCren4oZ1p6UlRW8yB0FY5kDuCC1Az0AZYO/gnq2k4uM6qvkF7gGgADOQD
         b/EnSYeaR19Eoxyhj6wtzLCSnmxasaINKNWus+wVnvzUuhihIsA7LovljKPbNp6F6p5i
         rPkg==
X-Gm-Message-State: AOAM533UwpC1wW2oW8VSwrZ2VxZ8M/zrq1pSmwBUh26rI76ftMkIB9IU
        jsieYcmdfwyT9AcAwLt6Pqyu0NVxiKgXWBEBVpMKq8ixj7U=
X-Google-Smtp-Source: ABdhPJzEHgphtFhoyz33XWQv0Kznc3OmIG3/xzM6o26VBQnrDYkh1/SSuKiA2hWCX7Igri9DmoX0gVI8Gv8in7OJ1H0=
X-Received: by 2002:a2e:1652:: with SMTP id 18mr16876910ljw.23.1632155825482;
 Mon, 20 Sep 2021 09:37:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210918120239.96627-1-linkinjeon@kernel.org> <ac18e062-e835-b575-66af-72631df7ef7d@talpey.com>
 <CAH2r5msa4XeaLy=_HY9RrLpK0NyS9n3iMdYnvX7F4n2zNQNXgQ@mail.gmail.com> <2cf8a2d1-41df-eef4-dfe0-dca076e8db54@talpey.com>
In-Reply-To: <2cf8a2d1-41df-eef4-dfe0-dca076e8db54@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 20 Sep 2021 11:36:54 -0500
Message-ID: <CAH2r5msyrGTGTfq58yB70v2QJG4c596pPPHWgxqEHAW0nJ5ykQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add default data stream name in FILE_STREAM_INFORMATION
To:     Tom Talpey <tom@talpey.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Sep 20, 2021 at 11:08 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 9/20/2021 12:47 AM, Steve French wrote:
> > On Sat, Sep 18, 2021 at 9:06 PM Tom Talpey <tom@talpey.com> wrote:
> >>
> >> This doesn't appear to be what's documented in MS-FSA section 2.1.5.11.29.
> >> There, it appears to call for returning an empty stream list,
> >> and STATUS_SUCCESS, when no streams are present.
> >
> > I tried a quick test to Windows and it does appear to return $DATA
> > stream by default:
> >
> > # ./smbinfo filestreaminfo /mnt/junk
> > Name: ::$DATA
> > Size: 179765 bytes
> > Allocation size: 196608 bytes
>
> Ok, so the implication is that the default stream is indeed always
> present, if the filesystem supports streams. The language in MS-FSA
> would therefore be correct, but a bit vague. I agree that returning
> a ::$DATA for ordinary files is appropriate.
>
> > when I tried the same thing to a directory on a share mounted to Windows 10
> > (NTFS), I get no streams returned.
> >
> > So it does look like default stream ($DATA) is only returned for files
>
>
> My concern here is, what's so special about directories? A special file
> or fifo, a symlink or reparse/junction, etc. Is it appropriate to cons
> up a ::$DATA for these? What should the size values be, if so?

Here are examples (share exported Windows 10 NTFS) of files vs.
directories with or without streams, note that directories do not show
the "default stream" $DATA but files do, but both support adding
streams, and reparse points at least in the case of hardlinks to files
show the target's streams.  It is a bit confusing because the Windows
"dir /R" command filters out the ($DATA) stream returned on files even
though it is returned across the network.

# smbinfo filestreaminfo /mnt/dir-without-stream/


# smbinfo filestreaminfo /mnt/dir-with-stream/
Name: test_stream
Size: 19 bytes
Allocation size: 24 bytes


# smbinfo filestreaminfo /mnt/file-without-stream
Name: ::$DATA
Size: 24 bytes
Allocation size: 24 bytes


# smbinfo filestreaminfo /mnt/file-with-stream
Name: ::$DATA
Size: 17 bytes
Allocation size: 24 bytes

Name: test_stream
Size: 19 bytes
Allocation size: 24 bytes


# smbinfo filestreaminfo /mnt/link-file-with-stream
Name: ::$DATA
Size: 17 bytes
Allocation size: 24 bytes

Name: test_stream
Size: 19 bytes
Allocation size: 24 bytes


# smbinfo filestreaminfo /mnt/link-file-without-stream
Name: ::$DATA
Size: 24 bytes
Allocation size: 24 bytes

Note that locally on Windows "DIR /R" filters out the $DATA (default) stream

C:\shares\scratch>dir /R \shares\scratch
 Volume in drive C is OSDisk
 Volume Serial Number is 0AF4-9CC1

 Directory of C:\shares\scratch

09/20/2021  11:32 AM    <DIR>          .
09/20/2021  11:32 AM    <DIR>          ..
09/20/2021  11:16 AM    <DIR>          dir-with-stream
                                    19 dir-with-stream:test_stream:$DATA
09/20/2021  11:15 AM    <DIR>          dir-without-stream
09/20/2021  11:14 AM                17 file-with-stream
                                    19 file-with-stream:test_stream:$DATA
09/20/2021  11:14 AM                24 file-without-stream
09/20/2021  11:14 AM                17 link-file-with-stream
                                    19 link-file-with-stream:test_stream:$DATA
09/20/2021  11:14 AM                24 link-file-without-stream


--
Thanks,

Steve
