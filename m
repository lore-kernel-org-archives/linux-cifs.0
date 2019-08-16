Return-Path: <SRS0=NG9T=WM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33373C3A59C
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Aug 2019 04:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECE142064A
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Aug 2019 04:36:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M5t6y+Px"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfHPEgp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Aug 2019 00:36:45 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:43328 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfHPEgp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Aug 2019 00:36:45 -0400
Received: by mail-io1-f42.google.com with SMTP id 18so3764290ioe.10
        for <linux-cifs@vger.kernel.org>; Thu, 15 Aug 2019 21:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=myz1lxytKvHeVz82ZGaTLAn0cZnCqJ/9ItRgaichYv0=;
        b=M5t6y+PxHM72jNk0cVtV7KKSd8UMZv4zDJqCOxyUzjmdAT0Trgd8CSvGg4DGrM87dB
         KyxGeCjawwAmFo9jNZbYOmUshkmY0xjctpmfzvoZTxEb69hBBD25SwZshbS8x5+N40sI
         M2XkvL0UGRj1z8BI9GqpDxUBFH+WZOY85L/+wt6/AwA/aTn5GZJxs4RFU/1TZvkxz+I1
         YHc9lPBWmKkIMsdtQ6TlDOTIpR65+Not67Qz9Xhh5mHPX/6lP1Vu7Hho041vllXK/raJ
         Ah4f2dExCeGwu5YEMKOd5eYmWT885bkw+paRDuvB1cUC4JVz/htuzGsivtebA/X0jx9j
         YYiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=myz1lxytKvHeVz82ZGaTLAn0cZnCqJ/9ItRgaichYv0=;
        b=OdAZ2Pc819ANm+zKk60ROLAYYDxOtCeFdoNAQjUJrQ1nxXsOmz1LYL3JYsk4EBf4Qs
         f/KkgGeObG0qqMIG3nqAWlcNKOPBZlMl+w7mEsJ+BPcgopMmBS2KKBdfyN6BPiWu4EqO
         NEhkoHz6i6EBI19SfjJvnR5sa69YXBZYeqI5aVxxFUP1oz6sPpTWfd8W0FrmhKCzbcc0
         sDKHywqLEJgQbZd6sU/nR0MgCPpR08/bx+QynP3sn/5uciaZCX/v/doTZm5mMLCqSMuB
         EYsCyXZiTAnxTutkWNIQ82b9VzoQf7WE3x0xXACzpZcsCAZYeieBnxJHvIgYpSrrIwu3
         7u2w==
X-Gm-Message-State: APjAAAV1VEyjdxtn1LNDTRUMbAUO7Ud1FfsKD9BgroKU6Be67uPmq0ja
        KF0YeMaL/8CrYrj8pZj7qHTopUKRv7v5nAHWnDs=
X-Google-Smtp-Source: APXvYqw9qhPDVCAfImsePsQAk50knsvFRyrNSZLFb8GT2kl/Xb8AvwFRa/9yQhHcHSVlC6hID3wwgqJWN2uAQU5qssc=
X-Received: by 2002:a02:5246:: with SMTP id d67mr9119467jab.58.1565930204496;
 Thu, 15 Aug 2019 21:36:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAN05THT0OkbAoNu8ZVSHF-xY7w0ZW4q4i-jTxjNManrnz0OMfg@mail.gmail.com>
 <20190815174854.05661672@suse.de> <CAN05THThHLkSF=oVBezJQBsre7QoH6eS=SLbxo3Z=w8M+fa=RQ@mail.gmail.com>
In-Reply-To: <CAN05THThHLkSF=oVBezJQBsre7QoH6eS=SLbxo3Z=w8M+fa=RQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 16 Aug 2019 14:36:33 +1000
Message-ID: <CAN05THT3NF+eAd=H+gpmZQp0SWBQ0iFe32TT0VB5_rmibcN2Cw@mail.gmail.com>
Subject: Re: FSCTL_QUERY_ALLOCATED_RANGES issue with Windows2016
To:     David Disseldorp <ddiss@suse.de>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

So to recap. Win2016 server in our buildbot.

We write to the file and populate the first 2Mb
we set the file to sparse using FSCTL SET-SPARSE
we use SET-INFO and file-end-of-file-info and set the new end of file to 4Mb
we use set-info and file-all-info and update the timestamps
we use get-info/file-all-info and the sparse flag is still set. **
we flush the file (we always destage all dirty pages and flush before
calling qar)
we call qar and sometimes it returns that 0-2Mb is allocated.
sometimes it returns that 0-4Mb is allocated.

In both cases, in ** the sparse flag is still set.

Just looking further down in the trace.  A few packets later after the
QAR  we re-open the file.
In the SMB2-CREATE response   the Sparse flag is still set.


At this point I just consider "sparse flag is just advisory, a hint.
if you expand a sparse file using set-end-of-file the behaviour is
undefined. it can either allocate the new region  or it can just leave
it unallocated."


On Fri, Aug 16, 2019 at 12:07 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Fri, Aug 16, 2019 at 1:48 AM David Disseldorp <ddiss@suse.de> wrote:
> >
> > Hi Ronnie,
> >
> > Is the file flagged sparse (FSCTL_SET_SPARSE()) prior to the QAR
> > request?
>
> Yes. The file is written to, the first 2MB.
> Then FSCTL_SET_SPARSE is called to make it sparse.
> Then there is a SET-INFO SET_END_OF_FILE to expand the file to 4Mb.
> there are a few other commands
> Then there is a GET-INFO / FILE_ALL_INFO and the sparse flag is still set
> then a QUERY_ALLOCATED_RANGES which returns a single region from 0 to 4Mb.
>
> The whole behavior is really odd.
>
> I am happy to mail you the wireshark traces for this. Can I do that?
> Just so you can look at them and confirm I am not crazy :-)
> I cant send them to the list because they are 5Mb each and it is rude
> to send such big attachments to a mailinglist.
>
>
>
> > When implementing the Samba server-side I tried to match
> > Windows/spec behaviour with:
> >
> > 702         if (!fsp->is_sparse) {
> > 703                 struct file_alloced_range_buf qar_buf;
> > 704
> > 705                 /* file is non-sparse, claim file_off->max_off is allocated */
> > 706                 qar_buf.file_off = qar_req.buf.file_off;
> > 707                 /* + 1 to convert maximum offset back to length */
> > 708                 qar_buf.len = max_off - qar_req.buf.file_off + 1;
> > 709
> > 710                 status = fsctl_qar_buf_push(mem_ctx, &qar_buf, &qar_array_blob);
> > 711         } else {
> > 712                 status = fsctl_qar_seek_fill(mem_ctx, fsp, qar_req.buf.file_off,
> > 713                                              max_off, &qar_array_blob);
> > 714         }
> >
> > ...in which case you should see similar test results against Samba. This
> > also excersized via the ioctl_sparse_qar* smbtorture tests.
> >
> > Cheers, David
