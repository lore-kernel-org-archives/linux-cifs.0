Return-Path: <SRS0=NG9T=WM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C52C3A589
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Aug 2019 02:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A09902089E
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Aug 2019 02:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lP1Bhqq9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfHPCHk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Aug 2019 22:07:40 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:46451 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfHPCHk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Aug 2019 22:07:40 -0400
Received: by mail-io1-f52.google.com with SMTP id x4so3233702iog.13
        for <linux-cifs@vger.kernel.org>; Thu, 15 Aug 2019 19:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D+BOcO0ie6DDA+WmM/1m2EbRHhdvEKUXsLU9hpzSY9M=;
        b=lP1Bhqq9SBYAtVAr7Ti2/nQDrhq027eiwzB9s4IPDh6g1eEDDB+jd2psL/U77c7J+c
         DHf+A2CkAcfyT6qCDVjEvAY2lZDKmz3ZsXqWe4S2rvm0qMfOX2sgwJMOqN6Boajg1DBu
         /vIIFyqVJTvNv+VqXLF0f7B2hvXAmryWSGBnEAVKlYTscATxASy50GlgU9eIRmKYSlZy
         GZl6Lh9/4UQvNTFUeUBAtMmRL9SO5hM4E0r0WuaPNhUZeJ7DTDMBbv8rVSXsBvGpCNOj
         81GkqesHuue0R4dH4Xw5apZLqoe83ykcmAai80OtKU8fIFGoNAeYSmwyt1baJfNmyrMy
         +37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D+BOcO0ie6DDA+WmM/1m2EbRHhdvEKUXsLU9hpzSY9M=;
        b=R1t/MUQfb8rjNPpsJOT9AeErISG19Bw5mkpJfG40DRMXJ37fbw3xlPBGTUmG5ZtwTs
         buz1Jc7MYX33/9J5UQo1sJbFb9gZ3PjduxWAktbXe/GDC1XEWdOlPiOGZ0XyHBLfcbCV
         hPlGco/R84SdckyWhwy+2UdYh+8QmRBIeMpizEwnLpByg3JK3I9s5o/rBt1RclemIJQQ
         uq5HjJmK/LY3HbHu1rG0jcCt42oL29AbEqEl8HUkACTvJ/sX583Xlu1Fyuz3VeoORnUC
         M9LJr0fgmjbqVX1Db+SQoBBEgk2EqRTvAGlw8ANxe0sRiHwJsNwWxJxRglRezeGCO264
         oW1A==
X-Gm-Message-State: APjAAAWOFFSSgVV8q6UaSFyEc7yNJcKWp2yClXmWPZUEXrQI8N2JsAtA
        amcP7eR8u46xe4TvVT8t7iQwkJZq6zUXbjKXfMZFuA==
X-Google-Smtp-Source: APXvYqwwiN6/qyd4YXhesfatkQPF3LKjF9DJ44I8mW0kV9Twb68DAO3Gsi/LSV9w2Oks4UgtEG6RxNXji91tI0sTJ04=
X-Received: by 2002:a6b:641a:: with SMTP id t26mr8790838iog.3.1565921259820;
 Thu, 15 Aug 2019 19:07:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAN05THT0OkbAoNu8ZVSHF-xY7w0ZW4q4i-jTxjNManrnz0OMfg@mail.gmail.com>
 <20190815174854.05661672@suse.de>
In-Reply-To: <20190815174854.05661672@suse.de>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 16 Aug 2019 12:07:28 +1000
Message-ID: <CAN05THThHLkSF=oVBezJQBsre7QoH6eS=SLbxo3Z=w8M+fa=RQ@mail.gmail.com>
Subject: Re: FSCTL_QUERY_ALLOCATED_RANGES issue with Windows2016
To:     David Disseldorp <ddiss@suse.de>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Aug 16, 2019 at 1:48 AM David Disseldorp <ddiss@suse.de> wrote:
>
> Hi Ronnie,
>
> Is the file flagged sparse (FSCTL_SET_SPARSE()) prior to the QAR
> request?

Yes. The file is written to, the first 2MB.
Then FSCTL_SET_SPARSE is called to make it sparse.
Then there is a SET-INFO SET_END_OF_FILE to expand the file to 4Mb.
there are a few other commands
Then there is a GET-INFO / FILE_ALL_INFO and the sparse flag is still set
then a QUERY_ALLOCATED_RANGES which returns a single region from 0 to 4Mb.

The whole behavior is really odd.

I am happy to mail you the wireshark traces for this. Can I do that?
Just so you can look at them and confirm I am not crazy :-)
I cant send them to the list because they are 5Mb each and it is rude
to send such big attachments to a mailinglist.



> When implementing the Samba server-side I tried to match
> Windows/spec behaviour with:
>
> 702         if (!fsp->is_sparse) {
> 703                 struct file_alloced_range_buf qar_buf;
> 704
> 705                 /* file is non-sparse, claim file_off->max_off is allocated */
> 706                 qar_buf.file_off = qar_req.buf.file_off;
> 707                 /* + 1 to convert maximum offset back to length */
> 708                 qar_buf.len = max_off - qar_req.buf.file_off + 1;
> 709
> 710                 status = fsctl_qar_buf_push(mem_ctx, &qar_buf, &qar_array_blob);
> 711         } else {
> 712                 status = fsctl_qar_seek_fill(mem_ctx, fsp, qar_req.buf.file_off,
> 713                                              max_off, &qar_array_blob);
> 714         }
>
> ...in which case you should see similar test results against Samba. This
> also excersized via the ioctl_sparse_qar* smbtorture tests.
>
> Cheers, David
