Return-Path: <SRS0=lRaz=QW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F76C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 01:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D47C821934
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 01:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfBOBHM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 20:07:12 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43140 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfBOBHM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Feb 2019 20:07:12 -0500
Received: by mail-lj1-f193.google.com with SMTP id z20so5909254ljj.10
        for <linux-cifs@vger.kernel.org>; Thu, 14 Feb 2019 17:07:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/jDmhPeDSIfBSPbhb3A+NuxGFC9KhEqgGXm3Js1K3PQ=;
        b=rbbiY4+y/L2H3NvwXZwVQh4Pe4JjMHXE85j8zO4Glq/XTX4nk+TDbk9i2f6aBYbgLB
         lXWUDpIqhXuM+SQDFvnHcWvEJKEzX6pJSvpSH96K9rm0PpL8YImKy7HI5WGxgzoV2pMG
         njPbCKK6IaZcypC6ted2VSwyECUackLWCfdigE6vGGahulmsOrAOuwJz0hUsFrNQqoS9
         KQyD6iukvg861Q1i2YjzwW2fNoHmuF2L33y9lDGFEgjkoRYLv1wRlCgVwsJkWTXCH4mn
         Bchgsd4/f2amR/Pb1QABFRa65zFSgolPtkzfN5OyovRF8GcAW2OK8ZKgb2iqXxwCCjls
         1txw==
X-Gm-Message-State: AHQUAuZbVhyrxZj+xJcQHV53lUGqAfEpxjiJY37RZCtdbVJ2Q2LUJoAB
        OLWBI7qdMhb2pI52dixUZsxtOqG3Hz/BrmcpJU1lcH8zjOs=
X-Google-Smtp-Source: AHgI3Ian8f/O1JZqKsjVjTUJrPkCpiFbcFfDM7oGRuZQ7asTEKTxBvsQ4LPBTItKDP8oxMyt/nes3wq2wjYGI7MK7f0=
X-Received: by 2002:a2e:9c83:: with SMTP id x3-v6mr3667684lji.178.1550192830089;
 Thu, 14 Feb 2019 17:07:10 -0800 (PST)
MIME-Version: 1.0
References: <20181124134707.15993-1-kdsouza@redhat.com> <5C0036FE.8040002@tlinx.org>
 <CAA_-hQL=ipFp8haDc0CvkCCt1pt0PcYfM3CiNU-x0g250CBMxQ@mail.gmail.com>
 <CAA_-hQ+PBaN4V1zz7vhXFYT3N6SPUndi2vfw-4UUPhOaGWmM8A@mail.gmail.com>
 <CAKywueTiO4yYxRdaq0YTbgGuN_rQPm3CHqU5ctKbO7V9CLMGKw@mail.gmail.com> <CAKywueSBfyX3e_g0sjfv3KetsceZKWCy20YVTvk2R8U5t4xpTw@mail.gmail.com>
In-Reply-To: <CAKywueSBfyX3e_g0sjfv3KetsceZKWCy20YVTvk2R8U5t4xpTw@mail.gmail.com>
From:   Kenneth Dsouza <kdsouza@redhat.com>
Date:   Fri, 15 Feb 2019 06:36:58 +0530
Message-ID: <CAA_-hQKCRH-CKhBd4EXeaJe3rs7mjT2363SzYkcnq=-roNoXpQ@mail.gmail.com>
Subject: Re: [PATCH v3] Update mount.cifs with vers=default mount option and SMBv3.0.2
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes, will send shortly.

On Fri, Feb 15, 2019 at 6:35 AM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> пт, 30 нояб. 2018 г. в 11:29, Pavel Shilovsky <piastryyy@gmail.com>:
> >
> > There is a mix of proposed changes in this thread. So, yes, please do.
> >
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > пт, 30 нояб. 2018 г. в 07:39, Kenneth Dsouza <kdsouza@redhat.com>:
> > >
> > > Pavel should I send a V4?
> > >
> > > On Fri, Nov 30, 2018 at 9:02 PM Kenneth Dsouza <kdsouza@redhat.com> wrote:
> > > >
> > > > On Fri, Nov 30, 2018 at 12:29 AM L. A. Walsh <linux-cifs@tlinx.org> wrote:
> > > > >
> > > > > On 11/24/2018 5:47 AM, Kenneth D'souza wrote:
> > > > > > +  - default - Tries to negotiate the highest SMB2+ version supported by the server.
> > > > > > +
> > > > > > +  If no dialect is specified on mount vers=default is used.
> > > > > >
> > > > > ---
> > > > > Should that say "the highest SMB2+ version supported by both the client and
> > > > > the server"?
> > > > >
> > > > Apologies for the delayed response.
> > > > Yes, will send a V4.
>
> Hi Kenneth,
>
> Are you still going to submit V4 of your patch? If yes, please rebase
> on top of "next" branch before sending
> (https://github.com/piastry/cifs-utils/commits/next).
>
> --
> Best regards,
> Pavel Shilovsky
