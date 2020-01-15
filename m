Return-Path: <SRS0=xi6A=3E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9ABBC32771
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 21:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBA5724671
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 21:11:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l8BeeMUR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729721AbgAOVLd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Jan 2020 16:11:33 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45095 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729801AbgAOVLd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Jan 2020 16:11:33 -0500
Received: by mail-io1-f68.google.com with SMTP id i11so19340604ioi.12
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jan 2020 13:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OGT85vWY7CcIotZ06Ag4hKMAmZ/VML5LmbXfRtHoYLE=;
        b=l8BeeMURnenSztmnkdaZs60zTKsNKfrlaP9M+I801z8MpsxhfXgNyH1m/CE8mci2Cj
         4ps3vuJEFAU6Cuu1k43/rI8EMGUk/NV+ecoFMxaH/APzxa5SYMd/n9QfbrXQpEujsFbn
         bUsc6jrjCtfop0xtnMRJt6ARlHVMt2Ndq3Hk4Yp1gRziS9Qp5FDamiLSrz5KBmhVYvs5
         36+l0o6Eqs0HCPDyN3P8Z1VCpORyLQIEZXV2MDTTD30bhebnO+zPD2vTrkwQi+Yrk6lC
         s8RmSUq67cETGo5eb/wWmnVpRcI0z8U0r54b0S5DWt0H2Dt5RLS+jIjcax2HgzbsaUT4
         wvWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OGT85vWY7CcIotZ06Ag4hKMAmZ/VML5LmbXfRtHoYLE=;
        b=KxiS2OL1sGJzUYZQooHxhLw+QaSunDG6axke8ylN0iNDLwQT7QzhHtn5XX66DjNAh0
         vxKcRdqrFDDC56DlQOi7siinoVgo8ICAilZLwTvM3qI3y+ljjw4GtvQXsJqzdInB9z7v
         BLj93Obztgm92zNu2VIwxWLrwgq8lv3OS0PzhYOp889ZK09nM2S4/ifnq+/UhTqL/9t1
         ZA++tEuveeO1tFW9NJ0M+lqP/lsXxHxMwgikAGadE8xX2GmdC4dBNxIliqgU2TWY2QbG
         OPoXaIIRPft9PLBknmlcy3jajSXSV25X03J9m8+6EfI3Tq6JB1s3a5DG+igRhgdwSGTI
         YkWg==
X-Gm-Message-State: APjAAAWZYk1MFigg5ZpzrDk5t+yVRNWYZvO+4mvLCtbnxkrMXocKwExU
        1TCVKXfoi60wlrMDShcBzmvbhWVtAE9/LsF1rKs=
X-Google-Smtp-Source: APXvYqzst7EGyV6O4/aLhQ+z7Xd8VB4r5dw1U5CZbDlTWz3T2ycp3AbSanIw2ZPHaU8V0TqhnHA6MWy7vJrsMUrWzac=
X-Received: by 2002:a5d:84d1:: with SMTP id z17mr1938596ior.169.1579122692304;
 Wed, 15 Jan 2020 13:11:32 -0800 (PST)
MIME-Version: 1.0
References: <20200113204659.4867-1-pc@cjr.nz> <CAKywueSnatSmp-=w1J7Jf=9dab70SjV8JgfFoys37-sgGqOD_Q@mail.gmail.com>
 <87y2ubxdo9.fsf@cjr.nz> <CAH2r5mtyxzekdLNDhs=SNWjAW+KZG=AYJVWHoCN7QWbJ1K+69g@mail.gmail.com>
In-Reply-To: <CAH2r5mtyxzekdLNDhs=SNWjAW+KZG=AYJVWHoCN7QWbJ1K+69g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 15 Jan 2020 15:11:21 -0600
Message-ID: <CAH2r5mtz5D=ZpngBuNPCjrMDsvt091q9Y-vOufFa95td1LY2qg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix memory allocation in __smb2_handle_cancelled_cmd()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated with reviewed-by and cc:stable

merged into cifs-2.6.git for-next

On Tue, Jan 14, 2020 at 1:23 AM Steve French <smfrench@gmail.com> wrote:
>
> I can update - it.   Check back by Wednesday - I plan to add a bunch
> of the work for next release into cifs-2.6.git for-next (including
> this patch)
>
> On Mon, Jan 13, 2020 at 3:13 PM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Pavel Shilovsky <piastryyy@gmail.com> writes:
> >
> > > The patch 9150c3adbf24 was marked for stable, so, this one should be
> > > marked too.
> >
> > Ah, good point. Thanks!
> >
> > Should I resend it or Steve would take care of it?
> >
> > Paulo
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
