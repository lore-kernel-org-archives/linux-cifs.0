Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4308FC00140
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Aug 2022 04:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbiHLEHF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Aug 2022 00:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiHLEHE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Aug 2022 00:07:04 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D536A00F1
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 21:07:02 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id l22so23398833wrz.7
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 21:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9X2cAYIoc9Og/RNCdLokKfQJE7gwcPXXGxdm12hb2NQ=;
        b=JTaLYWcsdo1c1YKP8uFByb856MnAHsWxDtkGUjLefJdrG/4nN+HHV+Y3o51FMoUOTQ
         6QsfWQ7E67Z6dEbB6Fzg05s85VQwyFPcmchtBjEv0XmInq0bhf2Bw3+mgFxpSD88dF5o
         grUvbN8F9I3SrT1QMjk46ucp76wjCJQJs/Hz1ADGCiGnmr1rKYo+eRkSSHtsAu+7xBmK
         1vUqkAABUat0ZH7TCjxD+rujjQaKh1QzDUFzoBOYBVneg8B8ClQLgd6g6VDTqzvsa7O0
         b5mJnIkVi2GI9AMcuY5KNxt38nwV6ryroOnRb++JGi7K+QoYfTMYnAxhZ6gc4RIfyYU5
         pIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=9X2cAYIoc9Og/RNCdLokKfQJE7gwcPXXGxdm12hb2NQ=;
        b=6ju2WV0kvl/7i5F+A4eKT1Pea/lqHc+UXIOsBd7/upb3Nh/qu/3zkGYfY+fE7s/uIb
         T4rNgfRwFztK0f5iWnbji9kGMUQ9qzG+B+8JdhyRJbdD3a1Xqru8Y3z/um0LyQLDkE7y
         43j3y/95L4Uc6X2KBILwUsMKOeRIIVvwavPutYRdYt/AAO2/hxWAncmiCysc8i2CoPMH
         xw863w5YGNwaYbfryXiCpbpRxfslcNWmjdflnf/cKRn2WxvmFg/X0JPWYbPDk8Y1X2aN
         ZrNPptEVTVNNYh/6R8CDz5SFGFBhDGQIdipZ4xk2eMEuQ2vNjFwmyz+FrPb5Xl278YW/
         K5KA==
X-Gm-Message-State: ACgBeo2vVg8q3eJsR7+8NDYQSsDwVITMlo3Cz9i/cAqflvcMxAH3csA9
        QT9M++JKV0nHKfYr/vgoJI9QnVw0uipRsJ5K34SkSqMy
X-Google-Smtp-Source: AA6agR6F+sCphc5CsuhXuXTwyM/4sF0zfSBobt+ld7dOnBkBsiExonpNoIsdKtu6yWYwwpSgPYOMP1rVvzJnCSxzYos=
X-Received: by 2002:a05:6000:1b92:b0:220:7d86:2e30 with SMTP id
 r18-20020a0560001b9200b002207d862e30mr944574wru.530.1660277221054; Thu, 11
 Aug 2022 21:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msJ6=LfoyGWyi94o+Z1FcJFdxpcLyPRz9K9gK5SpvPCUQ@mail.gmail.com>
 <87zggasr6o.fsf@cjr.nz> <CAH2r5mviEtcCQa1Pbyf6OeQKQ8dzJrK+BQE61qaGk6rQUaGH4A@mail.gmail.com>
 <87wnbesql0.fsf@cjr.nz> <CAH2r5muf+h+tdR6k3wgyhY52hz9BUSBCs1hzC1V434ddt0ovxw@mail.gmail.com>
 <CAN05THSv+7C2J9yv2Ph0_KApS5wucE-GwPLzihQ+zU_68ceq2g@mail.gmail.com> <CAH2r5mvppBm7Of8M5YjLkxQQXnxEizGttLne-n2TQdvuhr-ULw@mail.gmail.com>
In-Reply-To: <CAH2r5mvppBm7Of8M5YjLkxQQXnxEizGttLne-n2TQdvuhr-ULw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 12 Aug 2022 09:36:49 +0530
Message-ID: <CANT5p=oCKutTp=mfLEiVpPX=DbeWK09CWTGTT2ShTZf-1Ukqqw@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] allow deferred close timeout to be configurable
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        Bharath S M <bharathsm@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Aug 12, 2022 at 6:50 AM Steve French <smfrench@gmail.com> wrote:
>
> I am planning to document this (one reason I made the mount option
> name a bit shorter, and tried to make the defaults a bit more
> intuitive)
>
> We have workloads where we need this (e.g. cases where they want to
> read cache files more aggressively, but safely - but the app closes
> the file)
>
> My main short term issue is how to separate it from actimeo which is
> unrelated (and somewhat unsafe).
>
> I do plan to update the man page for mount.cifs, but we definitely
> need to be able to configure this.  Remember we recently had a bug
> where it would have helped investigate it.
>
> The main example I can think of is apps that do:
>
> open/read/close, open/read/close, repeatedly with other clients
> occasionally reading or writing the file.   Currently we only cache
> the file for 1 second after close. Windows for longer.  Our goal is to
> allow this as a performance tuning recommendation for advanced users
> until we can pick an optimum value (probably pretty long).
>
> I am fine with documenting this.   My intent was to document it
> similar to the following:
> - indicate it is an advanced tuning parameter, and its default is fine for many
> - indicate that if your apps open many, many files, you may want to
> consider setting it smaller if your server is resource constrained, to
> put less load on your server (especially if your apps do not
> repeatedly reopen the same files over and over)
> - indicate that if you have a workload where you want to cache files
> for long periods safely, and these files are only occasionally
> accessed by other clients, then consider setting it longer.  We have
> some example workloads that we were asked about this e.g.
>
>
> On Thu, Aug 11, 2022 at 8:10 PM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > On Fri, 12 Aug 2022 at 03:17, Steve French <smfrench@gmail.com> wrote:
> > >
> > > The "jiffies vs. seconds" in comment was the only suggestion I didn't include.
> > > See updated patch v2 (attached), I made minor updates.  Added the
> > > Suggested-by from Bharath. Moved the defines for default/max to
> > > different name with SMB3 (and in fs_context.h) since it is an smb3
> > > feature (so not confused with cifs).  I increased the default to 5
> > > seconds (although that is still lower than some other clients - it
> > > should help perf.  As you suggested, unconditionally print the value
> > > used on the mount.
> > > for some workloads).
> >
> > nack.
> > The problem with this is that it is a mount option that is impossible
> > for a sys admin to set correctly.
> >
> > If we need this as a mount option we need documentation on it too.
> >
> > 1, How does a sys admin determine that there is an issue and that
> > changing this value will  fix it?
> > 2, How does a sys admin determine what to set it to?
> >
> > To me it seems this is an option that can only be used by developers
> > and thus it should not be
> > a mount option. We have too many ad-hoc mount options that end users
> > can not use correctly as it is.
> >
> >
> > >
> > > On Thu, Aug 11, 2022 at 11:16 AM Paulo Alcantara <pc@cjr.nz> wrote:
> > > >
> > > > Steve French <smfrench@gmail.com> writes:
> > > >
> > > > > Will fix the typos thanks.
> > > >
> > > > Thanks.
> > > >
> > > > > There are a couple of minor differences from Bharath's earlier patch e.g.
> > > > >
> > > > > "closetimeo" rather than "dclosetimeo" (I am ok if you prefer the longer name),
> > > > > and also this mount option is printed in list of mount options if set.
> > > >
> > > > Both look good to me.  I personally don't care much about naming,
> > > > though.
> > >
> > >
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

While I understand the concern that having too many options can be
confusing for users, these are the most fine grained tuning knobs
available to us.
Anything else today (procfs entry, module parameter etc) are not at
the level of each mounted filesystem.
As Steve said, this could be configured by advanced users, based on
the workload. The default should be good enough for regular users.
The patch looks good to me.

For the number of mount options the user has at his/her disposal, I
feel that we should work on a profile=X mount option.
Based on the value of X, which describes the user workload, we could
internally decide on the values of multiple fine tunable mount
options.
We should have a smaller set of values for X, based on different type
of workloads, and the default values of other mount options based on
this value.
Thoughts?

-- 
Regards,
Shyam
