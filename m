Return-Path: <SRS0=foj0=DW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6700DC433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 03:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05D7A22226
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 03:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HCa6bYLp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgJODVQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Oct 2020 23:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgJODVJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Oct 2020 23:21:09 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091F2C061755
        for <linux-cifs@vger.kernel.org>; Wed, 14 Oct 2020 20:21:09 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id d3so1719503wma.4
        for <linux-cifs@vger.kernel.org>; Wed, 14 Oct 2020 20:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EMEZR9DIMM9xOqUTlFJ8Peou4zcks8qocAVmdBfQokg=;
        b=HCa6bYLpohm1iW/naB5sIP7A3ZGW2r1jeeSMhPhwUn6de9CQO6P+NhBHCgnyV1Tw83
         3l37l7YV8sS/jOZJdWIa1LK+4pEpipCPETIrTNG1toszi9cF0fyIdukF//m69/BIGV/i
         +Tv5TgP+v3BbWeJxMrclmLtaODrpbiHUIb0kDV2droglpoqzOczokt6N7yMMk8dvtZ1U
         kFOPaBY54MR2YNBwshmBDfKQuust8vqCmaw8BLw421gdrAD+XSQx7gGioHXWiwfHwdwf
         upHI8PjJvTD3joxhM/DT11fdESXVO88UyrYJYBIN+Iil4HzKmfASveH+KAYY/hXC2Dk8
         kJqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EMEZR9DIMM9xOqUTlFJ8Peou4zcks8qocAVmdBfQokg=;
        b=sOOFR22ZGikYMiq1UGQLZymRtEtx21kkeT/uh5kl0DGYVFsNgmOSDWZx4sB+SPrQ8p
         4mgsBa/h1roFRK9wlGbvKP+o1/kLKUd0f7sKkglB81iPYG57RDeobgJgmYXqiZDPRHFF
         s6TBOOpLiKmlFM861pnbd3tvRqoqDo1GigIQZ9bfjOA1OuTdCVBTRoIPkfOa/qPQv9f9
         gWDx66pzxqqYN4U6zWL38Wd07Pj8OfMe+DYzeK5mIEdXG7HHVc/ZolHzzUsVfhPR954T
         dNutLdhqGbk1rX/iwLR+gQGBlq4eLE9O7xkpHpusnYsdpIUGh8XqVkn7iRKLmEfe63d8
         /dgw==
X-Gm-Message-State: AOAM533et2KIH/Nl3F7DoiZ3h9uWeQ6HZbRYAwu8YdtcXtWC6n7VKxdN
        sXOlnq7iZpWL5gIvVgrwLGfsx7WCpW4AxyjjJHE=
X-Google-Smtp-Source: ABdhPJyKc79ompTF47CgS+tbE6OOnoLN1CGknCsOYTrA19R0NqxF04H4LRbkaTQ7A5AfqGoSGJNJUidZy0We+7VKIsU=
X-Received: by 2002:a7b:cf04:: with SMTP id l4mr1672036wmg.33.1602732067659;
 Wed, 14 Oct 2020 20:21:07 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
 <CAH2r5msodNEQPFO7fwY1wpy=qUNPTH+8iPDxZSvMrjg+SkJHEg@mail.gmail.com> <CAKywueR8u8DHUF7s9WXiowN5s2e_jmT5CqRBNS3qfewmmBcJhw@mail.gmail.com>
In-Reply-To: <CAKywueR8u8DHUF7s9WXiowN5s2e_jmT5CqRBNS3qfewmmBcJhw@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Thu, 15 Oct 2020 08:50:56 +0530
Message-ID: <CACdtm0Y7mFEbF0FtUR2+M54mWnPpMtR=QOESUu=a4HKgEzfTPg@mail.gmail.com>
Subject: Re: [PATCH] Resolve data corruption of TCP server info fields
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Pavel,

In receive_encrypted_standard function also, server->total_read is
updated properly before calling decrypt_raw_data. So, no need to
update the same field again.

I have checked all instances where decrypt_raw_data is used and didn=E2=80=
=99t
find any issue.

Regards,
Rohith

On Thu, Oct 15, 2020 at 4:18 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> Hi Rohith,
>
> Thanks for catching the problem and proposing the patch!
>
> I think there is a problem with just removing server->total_read
> updates inside decrypt_raw_data():
>
> The same function is used in receive_encrypted_standard() which then
> calls cifs_handle_standard(). The latter uses server->total_read in at
> least two places: in server->ops->check_message and cifs_dump_mem().
>
> There may be other places in the code that assume server->total_read
> to be correct. I would avoid simply removing this in all code paths
> and would rather make a more specific fix for the offloaded reads.
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D1=87=D1=82, 8 =D0=BE=D0=BA=D1=82. 2020 =D0=B3. =D0=B2 13:36, Steve Fren=
ch <smfrench@gmail.com>:
> >
> > Fixed up 2 small checkpatch warnings and merged into cifs-2.6.git for-n=
ext
> >
> > On Thu, Oct 8, 2020 at 9:40 AM Rohith Surabattula
> > <rohiths.msft@gmail.com> wrote:
> > >
> > > Hi All,
> > >
> > > With the "esize" mount option, I observed data corruption and cifs
> > > reconnects during performance tests.
> > >
> > > TCP server info field server->total_read is modified parallely by
> > > demultiplex thread and decrypt offload worker thread. server->total_r=
ead
> > > is used in calculation to discard the remaining data of PDU which is
> > > not read into memory.
> > >
> > > Because of parallel modification, =E2=80=9Cserver->total_read=E2=80=
=9D value got
> > > corrupted and instead of discarding the remaining data, it discarded
> > > some valid data from the next PDU.
> > >
> > > server->total_read field is already updated properly during read from
> > > socket. So, no need to update the same field again after decryption.
> > >
> > > Regards,
> > > Rohith
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
