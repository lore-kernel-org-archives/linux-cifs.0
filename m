Return-Path: <SRS0=S2FA=RS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B458C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 01:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 500132085A
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 01:10:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sAQVCc3e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfCOBKL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 21:10:11 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:32878 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfCOBKK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 21:10:10 -0400
Received: by mail-pf1-f182.google.com with SMTP id i19so5077763pfd.0
        for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2019 18:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g80qxo55rZCXH/vh+fiHeA2pmv+jdO5j/7HuFafbNes=;
        b=sAQVCc3eTGwl+2UyLPr4u4Pc6JWnLuKPQ99N/azXql4G2M4g4lA/Vl1kfYLM7ADjc/
         1Pr6dTZeuVgaeP8CrCu+t4W4WC16uKXVNhiiGmwduVk0a4oWB3ffKWYfJnVtrQKeHxhy
         XmHGb95cdG0TUPAKtepN/XuN1Ah5yVZAAaNu1qJ3dYYFET0Wu5+YY28L4IzrYu8aOOpd
         xdX1QwDBoihM9zHPo51YGK3omjJZYZoLbJcRPpIkGMh5e1ouI39yrtnvOqeCIZiBHVbP
         0qWCYGlihaF5W8nXgFTIuz17rF09GMRTeMj6iOFqKiKLHukRlwSlhUM89HErEtbvo0FW
         guJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g80qxo55rZCXH/vh+fiHeA2pmv+jdO5j/7HuFafbNes=;
        b=jPl+Far9aKj0sJhNSP88jwHd4Vl8pFeTv7lhbr9oMNXH7ET5WLTXDrlOLPYX/TXi/A
         XH8OHp84k/2pYzonKM3s0tMaMKyZYRHvTmaTit3iNU4AZjWJYjlAT5knPCH6x0GhjSTO
         fd8QZTeEFSeT6xq0f1f94EcIn1lwF/OX+dD7nabXRo5Du+QePgQLoJG+HgewVTmnXUh2
         fm59BQpjApYfd3BQXPgb+g+NXLz8bYbxvw613GaKBHO4c8XVHMbyw9SDs2cBQxvy/ahK
         dBsatdd+2sMhcflhPOo1xkI/x16/ggZB4ZnObf7/wSPwukb9130tr2Vmjq0h/Spl1sc6
         UiHw==
X-Gm-Message-State: APjAAAWq+/chM8DurRxG8ErdtAjqMtDOTmKf0oA5vh40XLN2Svz5RTv9
        qAnNqcf3/e7TzEg791kKKDyXBpLp2zuHgPD4iF5JyQ==
X-Google-Smtp-Source: APXvYqxlpJWnuYEkOtkJx/SgdrPiGNBx+/ElfVN6LtjXQXuxGPFZCsibDTRrxF4vdpZuR4n7UT4/FZ7IvfgWABxMGx4=
X-Received: by 2002:a63:1053:: with SMTP id 19mr812730pgq.55.1552612209839;
 Thu, 14 Mar 2019 18:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms=Mb8Ogx2+5jdzXOkTwfexKB0Xn=ukb6LroBbq2F+Q=Q@mail.gmail.com>
 <CAN05THRPnkQd2ANuQtHJYVY7ViuTk8y4jo0kbM37gv-Wj9pn6Q@mail.gmail.com>
In-Reply-To: <CAN05THRPnkQd2ANuQtHJYVY7ViuTk8y4jo0kbM37gv-Wj9pn6Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Mar 2019 20:09:58 -0500
Message-ID: <CAH2r5msJmCOYAviUc0u=3ObSoOpz9Yddc8PjtBgWyh-p86dJPA@mail.gmail.com>
Subject: Re: [SMB3] [PATCH] Pass through FSCTL for tools like smbinfo
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I think this is going to be very helpful - there are many examples
where I have needed to write a quick script to query debug information
or metadata only available via FSCTL

On Thu, Mar 14, 2019 at 7:42 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Note that we pass NULL as indata for SMB2_ioctl_init() so for the time
> being we can only use this for those ioctl/fcntl that does not
> write data to the server. But there are very many of those.
>
> We can start populating smb2info.c with handlers for this and once it
> all looks good we can add support to also write to the server (which
> will be easy to do but it would make the patch bigger)
>
> On Fri, Mar 15, 2019 at 10:21 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Forwarding Ronnie's patch to the broader list
> >
> > For debugging purposes we often have to be able to query
> > additional information only available via SMB3 FSCTL
> > from the server from user space tools (e.g. like
> > cifs-utils's smbinfo).  See MS-FSCC and MS-SMB2 protocol
> > specifications for more details.
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
