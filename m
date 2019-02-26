Return-Path: <SRS0=zR3V=RB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0B5C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Feb 2019 22:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E37E220863
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Feb 2019 22:08:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fw9RPrQV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbfBZWIj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Feb 2019 17:08:39 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:32828 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbfBZWIj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Feb 2019 17:08:39 -0500
Received: by mail-pg1-f181.google.com with SMTP id h11so6873881pgl.0
        for <linux-cifs@vger.kernel.org>; Tue, 26 Feb 2019 14:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AwKD/4czDGgiJESh0jrByYUU6BF9oL3le52/81ZopU8=;
        b=fw9RPrQV+e/F9UYTtVJIREnxAbmoJAjCVJEFrSE/9/DkHu4uZ3HlWWUt7xy++T4vaQ
         YpyEG6NDEcd5hstt+K+1sSwqsihkIFOLtH76gadQdfUylu5um5RNasyMgksmlamQA6if
         CcKeZZaq/B6PlRKIp8h2KVI4euDoZGtVaE2SQihfauTzguHqTVvjyj6wMoKojSR9nxcN
         PDvOgbsCPqUwe+dSuVp5iZ0bd8iTYb+3LY+9O1ZdTthU9uFEbLc52B/lOgA5DzCMU/Gm
         ouOnziTio2uLEjXxuCs7NM7ZXws7F56zQ+GRgBJSuRa9bzZ8Q6cs2SEsDEv0QpHLRJ6j
         L4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AwKD/4czDGgiJESh0jrByYUU6BF9oL3le52/81ZopU8=;
        b=Xs/xZ2rWw+pTX0WrcFBlYfOX7HwuRG8Jael6gCyWrVHmx0uVe7ONhsyN45u8jZPmbp
         j0lI9w4UjeTJs+tSMJBAnQ89cf1tUkosxAvJhW9+zb+LrJTvj+X/7+k/zoql5vQpHwjE
         Wgw7WY76F2xUrvssu8d0TRyLEBDgMoui6a4J8nqFtkk2KCYpApGo3SC9b5+QQRWmBZm8
         plE4c2RWAgDgvz/FJ9sbwTrct0XrV+VItTw/lKZzn2z7F/9LDnQlr6V8yEDFfJKKcpbM
         g3Ch1fwGXfcNXseyqdglnODhoabukl7enk9VUJVVNMKJTpBpj1pAYY1DeKeUgo0TLQsi
         uvxQ==
X-Gm-Message-State: AHQUAuaJItY6c4RO8wPPrkQSRJTSzbZHaxuSiSEnDrEuCQ2FIoCd0Eba
        rDyyhRY7B6FYGa5ZBPyk7uRvfWjs7aiIb5Jg/TM=
X-Google-Smtp-Source: AHgI3IZNXqyxWsm2xa/DANzrmrVN0JNp7Njjo+q4yiPnjf7F1COA9STfLxIM4v5fcIkpYh3LRvD07o5FmQ1XkzmDQvY=
X-Received: by 2002:a63:2312:: with SMTP id j18mr26647628pgj.344.1551218918031;
 Tue, 26 Feb 2019 14:08:38 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtPFfn+wi1LEfe=po+DYMFO51w+ZVtOAiY2Ex7CJMxdug@mail.gmail.com>
 <CAN05THSue2W3VzjZAf5oz7G=+SSGF8uQ4PPbqhqPeFdfUjMo0Q@mail.gmail.com>
In-Reply-To: <CAN05THSue2W3VzjZAf5oz7G=+SSGF8uQ4PPbqhqPeFdfUjMo0Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 26 Feb 2019 16:08:25 -0600
Message-ID: <CAH2r5mtSDtPVaDy51P_Z_yEdrd0FpaLSGVE3J1eY1tvZF0a5tg@mail.gmail.com>
Subject: Re: Updated ftrace patches for read/write/query_dir
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I don't have strong opinion on the two different trace points for rc=0
error no more files ('query_dir_done') instead of collapsing that into
a 'query_dir_error' with rc=0 - but seems a little clearer to not log
an rc=0 as an error

On Mon, Feb 25, 2019 at 8:32 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> In the first patch, do we really need different tracepoints for done
> rc==0 and err rc!=0 ?
>
> Othervise, for both:
>
> Reweived-by: Ronnie Sahlberg <lsahlber@redhat.com>
>
> On Tue, Feb 26, 2019 at 6:53 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Sample output (from "trace-cmd record -e  smb3_query* -e smb3_read* -e
> > smb3_write*")
> >
> > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> > #              | |       |   ||||       |         |
> >               ls-25909 [004] .... 91084.368421: smb3_query_dir_enter:
> > xid=8 sid=0x45a21759 tid=0x821ad8fd fid=0x50da7b4 offset=0x0
> > len=0x4000
> >               ls-25909 [004] .... 91084.369413: smb3_query_dir_done:
> > xid=8 sid=0x45a21759 tid=0x821ad8fd fid=0x50da7b4 offset=0x0 len=0x8
> >               ls-25909 [004] .... 91084.369530: smb3_query_dir_enter:
> > xid=9 sid=0x45a21759 tid=0x821ad8fd fid=0x50da7b4 offset=0x0
> > len=0x4000
> >               ls-25909 [004] .... 91084.370020: smb3_query_dir_done:
> > xid=9 sid=0x45a21759 tid=0x821ad8fd fid=0x50da7b4 offset=0x0 len=0x0
> >               dd-25915 [004] .... 91101.999225: smb3_read_enter: xid=0
> > sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x0 len=0x400000
> >            cifsd-25891 [005] .... 91102.010600: smb3_read_done: xid=0
> > sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x0 len=0x400000
> >               dd-25915 [004] .... 91102.015131: smb3_read_enter: xid=0
> > sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x400000
> > len=0x3d0000
> >            cifsd-25891 [005] .... 91102.026541: smb3_read_done: xid=0
> > sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x400000
> > len=0x3d0000
> >               dd-25915 [004] .... 91102.028261: smb3_read_enter: xid=0
> > sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x7d0000
> > len=0x1000
> >               dd-25919 [006] .... 91121.554908: smb3_write_enter:
> > xid=0 sid=0x45a21759 tid=0x821ad8fd fid=0x402ee709 offset=0x0
> > len=0x400000
> >               dd-25919 [006] .... 91121.556448: smb3_write_enter:
> > xid=0 sid=0x45a21759 tid=0x821ad8fd fid=0x402ee709 offset=0x400000
> > len=0x3d0000
> >            cifsd-25891 [005] .... 91121.559831: smb3_write_done: xid=0
> > sid=0x45a21759 tid=0x821ad8fd fid=0x402ee709 offset=0x0 len=0x400000
> >            cifsd-25891 [005] .... 91121.561798: smb3_write_done: xid=0
> > sid=0x45a21759 tid=0x821ad8fd fid=0x402ee709 offset=0x400000
> > len=0x3d0000
> >               dd-25931 [007] .... 91161.643194: smb3_read_enter: xid=0
> > sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x0 len=0x400000
> >            cifsd-25891 [005] .... 91161.650859: smb3_read_done: xid=0
> > sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x0 len=0x400000
> >               dd-25931 [007] .... 91161.655470: smb3_read_enter: xid=0
> > sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x400000
> > len=0x3d0000
> >            cifsd-25891 [004] .... 91161.663517: smb3_read_done: xid=0
> > sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x400000
> > len=0x3d0000
> >               dd-25931 [001] .... 91161.664921: smb3_read_enter: xid=0
> > sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x7d0000
> > len=0x1000
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
