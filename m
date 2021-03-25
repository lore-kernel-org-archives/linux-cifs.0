Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E490C433C1
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 02:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2740D61A13
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 02:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbhCYCmj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Mar 2021 22:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbhCYCmi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Mar 2021 22:42:38 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0949DC06174A
        for <linux-cifs@vger.kernel.org>; Wed, 24 Mar 2021 19:42:38 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id m7so326484pgj.8
        for <linux-cifs@vger.kernel.org>; Wed, 24 Mar 2021 19:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WMLjpglaUAG7/3USm6zkvIGQ3Pz6p/kjTykBexJfLXc=;
        b=m4HurBSn0VxrWbDylJT8ZIKvlqO7BBBnfrPzRwCRlLVz8d5LY2TyyZ10AtqR/0geai
         0XcUWXheu4VmO++A5sejil1H/i/T32zEJ6vVtmsemhwjGvdOHds5J9sJoBkQXtkzj7pT
         S+QINLQclbluD9ITSwR3yEPkHkmE1Tz0Xvmg+vOWA4dJC/mFX/8Nb5P7qwZBPioJ49SK
         Q4IlG4xJuLFPmb04qfKv7FIvMJuuFKiQtSKL/azzpprR8APLV6Sl8+7qD9Drco64C1tp
         JNrv0m2oruEgQc1MswMWiHEz/N9REc1Vw2rNi6+jyEVOiSQe0iADWGuz7HMQmb4DnpUe
         eB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WMLjpglaUAG7/3USm6zkvIGQ3Pz6p/kjTykBexJfLXc=;
        b=Hx4oHaxrdpluZ+mkNvqmyPpZElY8mkLpHwGjFaKI1eRTiojDBEYlnSLTL8OmtcjGFs
         j6HBBzouoKOaonKSFbxudDOYkwBE6ubtH8Myb3NT0Vl5hHgKPqTlciUkO5oMtIv/USha
         l5C9cDBNhVd0WLIeRBKLjK8abooxXwFIGeqoOQnwNIgNO6RZPzRltpU46bddeNX1TCLu
         IPrQ5yjvmvkIEZvoQZN9mM3FXIIs1ISW5JQp6lcmrP3aTnCesr7Kx02rMe9bG2NvWQNV
         97zrZjzdZlVT7aeF3iGnMhtXb1lj21aSKiMOvtmUdEY4+4pkqZ+VzlLPaYdn1+N053fF
         KeIA==
X-Gm-Message-State: AOAM533K/cKqO6KEAkk2CFIPNuoHnp056gq9/k83raGzk7JxCJVTyhzG
        YaFYOwrQL0BmHr5dnLMSY03WhEYqyNT1P++6Z3o=
X-Google-Smtp-Source: ABdhPJxgEuq2cqv2g2KPgn8DMgMEnx3XysSyDpru/HoVJoOTYBHoeT6qLxcM5D0WP6K6OMCASsEtIg95zDzDLzUb5os=
X-Received: by 2002:a63:54:: with SMTP id 81mr5678324pga.410.1616640157264;
 Wed, 24 Mar 2021 19:42:37 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0Y1NeC0jNTOtjhTtGRt0sfyhyxC=wNfMu1eqibe6qJbwA@mail.gmail.com>
 <CANT5p=pFU=1OKiBA0m0_Pqms4Vsxz7omEgvfDDAb8U3M4-3qbA@mail.gmail.com>
 <461d79c3-1b32-b0f8-157c-b5d4b25507d7@talpey.com> <CACdtm0agzeVRiQg1zZjm=jFrf-gSQ-+YGc1Zm1xN1Pd9tJia4Q@mail.gmail.com>
 <49874720-dc76-2660-17e7-f7157a9725d4@talpey.com>
In-Reply-To: <49874720-dc76-2660-17e7-f7157a9725d4@talpey.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Thu, 25 Mar 2021 08:12:26 +0530
Message-ID: <CACdtm0Z5BfbHp8Y2nFLv0k854hDe6-j4xtYDP4oruKPOtxxz2Q@mail.gmail.com>
Subject: Re: cifs: Deferred close for files
To:     Tom Talpey <tom@talpey.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>, sribhat.msa@outlook.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

>>> Hi Rohith,
>>>
>>> The changes look good at a high level.
>>>
>>> Just a few points worth checking:
>>> 1. In cifs_open(), should be perform deferred close for certain cases
>>> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
>>> perform less data caching. By deferring close, aren't we delaying
>>> flushing dirty pages? @Steve French ?
>>
>> With O_DIRECT flag, data is not cached locally and will be sent to
>> server immediately.
>>
>>> 2. I see that you're maintaining a new list of files for deferred
>>> closing. Since there could be a large number of such files for a big
>>> share with sufficient I/O, maybe we should think of a structure with
>>> faster lookups (rb trees?).
>>> I know we already have a bunch of linked lists in cifs.ko, and we need
>>> to review perf impact for all those lists. But this one sounds like a
>>> candidate for faster lookups.
>>
>> Entries will be added into this list only once file is closed and will
>> remain for acregmax amount interval.

>I think you mean once the "file descriptor" is closed, right? But now
>that you mention it, caching the attributes sounds a lot like the
>NFS close-to-open semantic, which is itself optional with the "nocto"
>mount option.

>Because some applications use close() to perform flush, there may be
>some silent side effects as well. I don't see anything special in the
>patch regarding this. Have you considered it?
>The change to promptly close the handle on oplock or lease break looks
>reasonable. The rewording in the patch description is better too.

Yes, as the handle is closed immediately when oplock/lease breaks,
will there be any
silent side effects still?

>>> What happens if the handle is durable or persistent, and the connection
>>> to the server times out? Is the handle recovered, then closed?
>>
>> Do you mean when the session gets reconnected, the deferred handle
>> will be recovered and closed?

>Yes, because I expect the client to attempt to reclaim its handles upon
>reconnection. I don't see any particular code change regarding this.

>My question is, if there's a deferred close pending, should it do that,
>or should it simply cut to the chase and close any such handle(s)?

As the handles are persistent once the session gets reconnected,
applications can reclaim
the handle. So, i believe no need to close handles immediately until
timeout(i.e acregmax interval)

Regards,
Rohith

On Wed, Mar 24, 2021 at 7:50 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 3/22/2021 1:07 PM, Rohith Surabattula wrote:
> > On 3/11/2021 8:47 AM, Shyam Prasad N wrote:
> >> Hi Rohith,
> >>
> >> The changes look good at a high level.
> >>
> >> Just a few points worth checking:
> >> 1. In cifs_open(), should be perform deferred close for certain cases
> >> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
> >> perform less data caching. By deferring close, aren't we delaying
> >> flushing dirty pages? @Steve French ?
> >
> > With O_DIRECT flag, data is not cached locally and will be sent to
> > server immediately.
> >
> >> 2. I see that you're maintaining a new list of files for deferred
> >> closing. Since there could be a large number of such files for a big
> >> share with sufficient I/O, maybe we should think of a structure with
> >> faster lookups (rb trees?).
> >> I know we already have a bunch of linked lists in cifs.ko, and we need
> >> to review perf impact for all those lists. But this one sounds like a
> >> candidate for faster lookups.
> >
> > Entries will be added into this list only once file is closed and will
> > remain for acregmax amount interval.
>
> I think you mean once the "file descriptor" is closed, right? But now
> that you mention it, caching the attributes sounds a lot like the
> NFS close-to-open semantic, which is itself optional with the "nocto"
> mount option.
>
> Because some applications use close() to perform flush, there may be
> some silent side effects as well. I don't see anything special in the
> patch regarding this. Have you considered it?
>
> > So,  Will this affect performance i.e during lookups ?
> >
> >> 3. Minor comment. Maybe change the field name oplock_deferred_close to
> >> oplock_break_received?
> >
> > Addressed. Attached the patch.
> >>
> >> Regards,
> >> Shyam
> >
> >> I wonder why the choice of 5 seconds? It seems to me a more natural
> >> interval on the order of one or more of
> >> - attribute cache timeout
> >> - lease time
> >> - echo_interval
> >
> > Yes, This sounds good. I modified the patch to defer by attribute
> > cache timeout interval.
> >
> >> Also, this wording is rather confusing:
> >
> >>> When file is closed, SMB2 close request is not sent to server
> >>> immediately and is deferred for 5 seconds interval. When file is
> >>> reopened by same process for read or write, previous file handle
> >>> can be used until oplock is held.
> >
> >> It's not a "previous" filehandle if it's open, and "can be used" is
> >> a rather passive statement. A better wording may be "the filehandle
> >> is reused".
> >
> >> And, "until oplock is held" is similarly awkward. Do you mean "*if*
> >> an oplock is held", or "*provided" an oplock is held"?
> >
> >>> When same file is reopened by another client during 5 second
> >>> interval, oplock break is sent by server and file is closed immediately
> >>> if reference count is zero or else oplock is downgraded.
> >
> >> Only the second part of the sentence is relevant to the patch. Also,
> >> what about lease break?
> >
> > Modified the patch.
>
> The change to promptly close the handle on oplock or lease break looks
> reasonable. The rewording in the patch description is better too.
>
> >> What happens if the handle is durable or persistent, and the connection
> >> to the server times out? Is the handle recovered, then closed?
> >
> > Do you mean when the session gets reconnected, the deferred handle
> > will be recovered and closed?
>
> Yes, because I expect the client to attempt to reclaim its handles upon
> reconnection. I don't see any particular code change regarding this.
>
> My question is, if there's a deferred close pending, should it do that,
> or should it simply cut to the chase and close any such handle(s)?
>
> Tom.
>
> > Regards,
> > Rohith
> >
> > On Thu, Mar 11, 2021 at 11:25 PM Tom Talpey <tom@talpey.com> wrote:
> >>
> >> On 3/11/2021 8:47 AM, Shyam Prasad N wrote:
> >>> Hi Rohith,
> >>>
> >>> The changes look good at a high level.
> >>>
> >>> Just a few points worth checking:
> >>> 1. In cifs_open(), should be perform deferred close for certain cases
> >>> like O_DIRECT? AFAIK, O_DIRECT is just a hint to the filesystem to
> >>> perform less data caching. By deferring close, aren't we delaying
> >>> flushing dirty pages? @Steve French ?
> >>> 2. I see that you're maintaining a new list of files for deferred
> >>> closing. Since there could be a large number of such files for a big
> >>> share with sufficient I/O, maybe we should think of a structure with
> >>> faster lookups (rb trees?).
> >>> I know we already have a bunch of linked lists in cifs.ko, and we need
> >>> to review perf impact for all those lists. But this one sounds like a
> >>> candidate for faster lookups.
> >>> 3. Minor comment. Maybe change the field name oplock_deferred_close to
> >>> oplock_break_received?
> >>>
> >>> Regards,
> >>> Shyam
> >>
> >> I wonder why the choice of 5 seconds? It seems to me a more natural
> >> interval on the order of one or more of
> >> - attribute cache timeout
> >> - lease time
> >> - echo_interval
> >>
> >> Also, this wording is rather confusing:
> >>
> >>> When file is closed, SMB2 close request is not sent to server
> >>> immediately and is deferred for 5 seconds interval. When file is
> >>> reopened by same process for read or write, previous file handle
> >>> can be used until oplock is held.
> >>
> >> It's not a "previous" filehandle if it's open, and "can be used" is
> >> a rather passive statement. A better wording may be "the filehandle
> >> is reused".
> >>
> >> And, "until oplock is held" is similarly awkward. Do you mean "*if*
> >> an oplock is held", or "*provided" an oplock is held"?
> >>
> >>> When same file is reopened by another client during 5 second
> >>> interval, oplock break is sent by server and file is closed immediately
> >>> if reference count is zero or else oplock is downgraded.
> >>
> >> Only the second part of the sentence is relevant to the patch. Also,
> >> what about lease break?
> >>
> >> What happens if the handle is durable or persistent, and the connection
> >> to the server times out? Is the handle recovered, then closed?
> >>
> >> Tom.
> >>
> >>
> >>> On Tue, Mar 9, 2021 at 2:41 PM Rohith Surabattula
> >>> <rohiths.msft@gmail.com> wrote:
> >>>>
> >>>> Hi All,
> >>>>
> >>>> Please find the attached patch which will defer the close to server.
> >>>> So, performance can be improved.
> >>>>
> >>>> i.e When file is open, write, close, open, read, close....
> >>>> As close is deferred and oplock is held, cache will not be invalidated
> >>>> and same handle can be used for second open.
> >>>>
> >>>> Please review the changes and let me know your thoughts.
> >>>>
> >>>> Regards,
> >>>> Rohith
> >>>
> >>>
> >>>
