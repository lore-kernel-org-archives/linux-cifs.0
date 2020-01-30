Return-Path: <SRS0=B7dF=3T=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D742C2D0DB
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jan 2020 17:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3315E20661
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jan 2020 17:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aHt2mXM/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgA3RrC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jan 2020 12:47:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55865 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727263AbgA3RrB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jan 2020 12:47:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580406420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U5faISZ00T/kU+d88dUlGQmBHfl3Fc8Bn1yPunkgFRM=;
        b=aHt2mXM/nOUKc9eMEo1xtZxv+uMuOPDiV4A3KjqlhWuV7MB0LV3idBaYIr6k8ghH7u2zGr
        5s/BbtmyCAlhMfbPN5AAQeadUtrQGeHfjqQZMb2Q+1roROo4Gi0iDkivvGMDKOaZwRWzmc
        eEr8zdUykfXvMOZffM1LtUaUFMYrsXI=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-LyNbu-NOOEKyJQhlIlabhA-1; Thu, 30 Jan 2020 12:46:59 -0500
X-MC-Unique: LyNbu-NOOEKyJQhlIlabhA-1
Received: by mail-pf1-f198.google.com with SMTP id z26so2258464pfr.9
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jan 2020 09:46:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U5faISZ00T/kU+d88dUlGQmBHfl3Fc8Bn1yPunkgFRM=;
        b=tQUYUtJGL2XuhbJzM7izACzcVIujOu904YWN7pAfclBuu5nBKggu5E5PLb5/yD2vYm
         FgrgNKW1zbY8wBqw9As/tyTr5wr9MNqoIkVfnlHuqZYTJZ0UxMdtgpROoaeo4DcMf+dB
         dL16ubCAIQsKDTDx4uP0UdPuwirjlD/j/X3g0m4Qmpqf4pC2RC5c6GJSD25NWEjV44m8
         dqoenuiylf+Y7uSlotl+wxS9g9JZ6v0LJifpdynNg0AdTKuYhaIUZNgwK6OtZnaSe7Dr
         vsnDggIN8FFi+ep3/dbD7LN9SdwG6TuoCG3e+SxoE6eaLn1Ynk6V0jQXvP6m0CqALrmN
         A/4A==
X-Gm-Message-State: APjAAAUdbHHwwQuUxGAdohGjnL42YjrqAoKX3/in60SqVNiOnVqUiPmS
        0pjb9evbThwghNC0d7s7pdWoPVWtTg6muEFPR5LRp4ShMj7VXcOak8FCsBkSkd8DpxvO7bMO4ij
        WySmTDUBln8RFID1It0C7IY+CTTG1YNR8hVWZeA==
X-Received: by 2002:a17:90a:d205:: with SMTP id o5mr7328501pju.46.1580406415510;
        Thu, 30 Jan 2020 09:46:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqwvZLRwp57N5NCTybxmna0CVj7zruyyZqMM7N6kIQMOaDMfS1q6PWDzno7Pd6OWFnxx6mYa0JoRdDc66gcG1H0=
X-Received: by 2002:a17:90a:d205:: with SMTP id o5mr7328460pju.46.1580406415040;
 Thu, 30 Jan 2020 09:46:55 -0800 (PST)
MIME-Version: 1.0
References: <39643d7d-2abb-14d3-ced6-c394fab9a777@prodrive-technologies.com>
 <87png0boej.fsf@cjr.nz> <5260c45c-0a31-168d-f9db-83bb6bd4a2cf@prodrive-technologies.com>
 <878smoqouf.fsf@cjr.nz> <VE1PR02MB55503665681374E805CA7815F53C0@VE1PR02MB5550.eurprd02.prod.outlook.com>
 <87k16417ud.fsf@cjr.nz> <VE1PR02MB55502AA359141C1D29B2AB82F53F0@VE1PR02MB5550.eurprd02.prod.outlook.com>
 <87y2uh264k.fsf@cjr.nz> <3ddf0683-0213-1c43-bcc7-cfc3cb8bc28b@prodrive-technologies.com>
 <871rs8eq3j.fsf@cjr.nz>
In-Reply-To: <871rs8eq3j.fsf@cjr.nz>
From:   Jacob Shivers <jshivers@redhat.com>
Date:   Thu, 30 Jan 2020 12:46:18 -0500
Message-ID: <CALe0_75hsoemi1-du=-YO=xO_gR7-41RKirwNrnU+L753Ycrhg@mail.gmail.com>
Subject: Re: cifs.upcall requests ticket for wrong host when using dfs
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Paulo,

I ran into this issue and noted that I can reproduce this 100% of the
time with a Samba SMB target. I tried with Windows SMB targets, even
when they are not part of the direct DFS namespace, but I have so far
been unable to reproduce that way.

Hello Martijn,
Would you mind stating who the provider is for the impacted SMB target
in your environment?

Thanks,
Jacob

On Thu, Jan 9, 2020 at 8:06 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Hi Martijn,
>
> Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
>
> > Yes, so far so good. Thanks a lot for the quick response! Not a trivial
> > patch as far I as i can judge.
>
> Cool! Thanks for the confirmation. Just sent a patch with this fix, BTW.
>
> > Also the machine we have running with your other DFS patches is running
> > for 8 weeks now and survived several relocations of our dfs shares and
> > adding/removal of DCs!
> >
> > Is there any news on the acceptance of your [PATCH v4 0/6] DFS fixes?
>
> I don't have any news, but I'll talk to Steve and Aurelien about them.
>
> Thanks,
> Paulo
>

