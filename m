Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02179CD37B4
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Sep 2023 16:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbjIQP7k (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Sep 2023 11:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235690AbjIQP7U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Sep 2023 11:59:20 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB5FF7
        for <linux-cifs@vger.kernel.org>; Sun, 17 Sep 2023 08:59:14 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2bffe2840adso8663451fa.2
        for <linux-cifs@vger.kernel.org>; Sun, 17 Sep 2023 08:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694966353; x=1695571153; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AX+/4IfNegxcCqPGfjBqjz3hp/DyFuhaPETtk0jsZk8=;
        b=mAuJAQiAhA80Tkcx82ZbU0VmTpdmNsh2ucF0sbBKZ+36uD0Sjo3ziV8mEiPT1JXsVg
         9cDrpS+0+mT00vlS2OFbd3LfzgXqOoymuKGezqYd6dKsWXxMAAqpi+dc6roN+Gvl65G4
         Te0lcXVykphr3ZOH5WUXLby+UC2HlPoy0hs9P0aWvpb/nOGwv0EhHOKNzPHkpZbyX//S
         9h61whLzklB6tPKPpBfKvbScxx6XwEC/lAjtPlAZ7cGwEFLBAy9GsrmcRe9oa0HQLG1K
         S58NlG5a588WmBEOP8yGUQlq4+jmrcaQSA2V/5jDADejPah5qISnVgWWOLjTvXq/cZsj
         SSGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694966353; x=1695571153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AX+/4IfNegxcCqPGfjBqjz3hp/DyFuhaPETtk0jsZk8=;
        b=e0zdgZ0lTdhimghK5eDpP41yyuLAudW5wzU+Mf43PnvS3IdhiNbcFiiMTu6ZMkmlRO
         p8sdftOP6CN5PLfD7uiUgh2fkzPmaTccPjBfdni5buWgKJObdWIX/ataL7WsQMRcQr0i
         Ij8EbH6Imf2IEO1wXaqVrvsbD0y0gUgzCji3s5YY+bWamvEMtc3YbaaW3ScHnQx1nRb8
         tCD3dHZB5a9i13fXnMjVC5A+pSdzURPg6N42qp7nGxrCkQhgKfa+qRhfppjwr8YrNEaf
         OcjpQ4NnKU1KV03HXagVBi0RD2vREbKqqTgRezXVVz5wzm9u+wH7M/rEsv/PFRsnH02H
         e0UQ==
X-Gm-Message-State: AOJu0YxBDYLB7Kc7JfR9K5qEiAW7VbeXZUc0KjLV/frqMOrtXJpdsyJJ
        PIvt0N+zVrA6sr7Pj2lHuXqq5mOTT+6h5we7ThXo5ZK8rW6X4A==
X-Google-Smtp-Source: AGHT+IHxJ3WkP0hYjNFLUhyMJ2jOQw8cxMLQJNRwBmPpP1gJGvbBStKSW5otb40lwqzthaBTlzkeu4H7JhiZlAkFcls=
X-Received: by 2002:a2e:8201:0:b0:2bb:c212:5589 with SMTP id
 w1-20020a2e8201000000b002bbc2125589mr5399178ljg.17.1694966352453; Sun, 17 Sep
 2023 08:59:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mucC=YxgaQV5nAPCfduAmjyEyxYw+XdToOwELezqe=e0g@mail.gmail.com>
 <CANT5p=rHdWmD_wtQtKU615LAWmXx4UQxHORf0HDqgYNksddvEA@mail.gmail.com>
 <CAH2r5mtRJtNiN128kJTSknv_F4Q6uPDsETcKH7Pjkfk0Fco6zg@mail.gmail.com> <CAH2r5muiUG59xVxPr+2y1U9jGbwLvOVvMnE+FsmRHdVf0Wxeig@mail.gmail.com>
In-Reply-To: <CAH2r5muiUG59xVxPr+2y1U9jGbwLvOVvMnE+FsmRHdVf0Wxeig@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sun, 17 Sep 2023 21:29:03 +0530
Message-ID: <CANT5p=ovAMDi6xzkvDdkw4dt7Cfuook8Oxx-LWdp_QEO7Ryn2w@mail.gmail.com>
Subject: Re: [PATCH][SMB client] send ChannelSequence number after reconnect
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>,
        Bharath S M <bharathsm@microsoft.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Aug 30, 2023 at 7:36=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> There is also an smbtorture case in the samba test suite for this
> (replay.c) we can take a look at that.
>
> On the channel sequence number question - there is interesting
> additional information (although probably not indicating a client
> change) on channel sequence overflow at source3/smbd/smb2_server.c
> line 2944ff
>
> On Wed, Aug 30, 2023 at 9:02=E2=80=AFAM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > we could do a follow on with your suggestion, but seems like without th=
e replay flag would just look like a new write to the same offset (which sh=
ould take precedence over an older queued write to the same offset that has=
 a lower sequence number)
> >
> > I will code up a follow on patch to do replay operation patch
> >
> > On Wed, Aug 30, 2023 at 8:56=E2=80=AFAM Shyam Prasad N <nspmangalore@gm=
ail.com> wrote:
> >>
> >> On Fri, Aug 25, 2023 at 10:09=E2=80=AFAM Steve French <smfrench@gmail.=
com> wrote:
> >> >
> >> > The ChannelSequence field in the SMB3 header is supposed to be
> >> > increased after reconnect to allow the server to distinguish
> >> > requests from before and after the reconnect.  We had always
> >> > been setting it to zero.  There are cases where incrementing
> >> > ChannelSequence on requests after network reconnects can reduce
> >> > the chance of data corruptions.
> >> >
> >> > See MS-SMB2 3.2.4.1 and 3.2.7.1
> >> >
> >> > Note that (as Tom Talpey pointed out) a macro  "CIFS_SERVER_IS_CHAN"=
 used by this patch is confusing (has a confusing name) since multichannel =
is not supported for older dialects like CIFS.  I will fix that macro name =
in a followon patch.
> >> >
> >> > --
> >> > Thanks,
> >> >
> >> > Steve
> >>
> >> Theoretically seems okay. Although MS-SMB2 says that replay requests
> >> need to be indicated as replay in the header, which we are not doing
> >> currently.
> >> I don't know what maybe a side effect of not sending that could be.
> >> Will this patch without that make things worse?
> >>
> >> --
> >> Regards,
> >> Shyam
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve

I was doing some more reading up on this today. And it does look like
our ChannelSequence operations should be okay.
The spec recommends that each session for a given server maintains
it's ChannelSequence. We use the channel_sequence_num on the primary
channel. So we are good that way.

However, a few other things that I observed about what the spec says
about how the server implements the ChannelSequence (3.3.5.2.10
Verifying the Channel Sequence Number):
1. The ChannelSequence need not be incremented on each reconnection of
any channel. It needs to be incremented only when all the channels are
down. I can create a follow on patch for this.
2. If the server sees that the ChannelSequence for a request is not
the latest, then it may return STATUS_FILE_NOT_AVAILABLE. The client
should be prepared to handle this by replaying the request again.
3. If we carelessly increment the channel_sequence_number, more
requests can start failing with STATUS_FILE_NOT_AVAILABLE. So #1 and
#2 become more important to implement.
4. >> which should take precedence over an older queued write to the
same offset that has a lower sequence number
I'm not sure that this is the correct assumption. Based on the spec,
it seems to me like ordering of the old queued writes need not be
preserved if the replay bit is not set. If the replay bit is set, it
looks like conflicting writes can result in the later one being
returned STATUS_FILE_NOT_AVAILABLE.

--=20
Regards,
Shyam
