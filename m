Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF44C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 07:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 337EC2063F
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 07:20:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="izA55sgu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfCNHUF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 03:20:05 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40227 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfCNHUF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 03:20:05 -0400
Received: by mail-pf1-f195.google.com with SMTP id y124so3228501pfy.7;
        Thu, 14 Mar 2019 00:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ugOOPlTFRgUc0dPFg2PyX5U2PNiJO93N55npz7c+UJo=;
        b=izA55sgua6WVfa/6GcVkOVHcrkvzZVFeZ8/7TY5Q3EhVgaTXilRTdDcYZ9piYPF0RR
         fm6d9Mc5Q4mc6b6wxWwDLFbcb2Wd9PDeYBqlYtS/Ga/BIKtCWsPeqLIaMOg9afcrMAfd
         A+Bg9Rm3JqRljn+OTM53plVWUaAJrFBrmFkxN79SgbCbNK9fPBWBdRWEZvPc33S4Gmym
         5gy/1ZUNv2Kw/ns+a1/7MMOFPfu9kb87j7pp7MFbsLQ8BV0XWZ0vr3i7cLqsuJ3gXRGm
         xs4IXGLXmGAE0R6I31QcTs/SWcbZQFCDyIu8OAoBvPd+hlGttQDjqTjr8EFiqxMBcc4Q
         kObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ugOOPlTFRgUc0dPFg2PyX5U2PNiJO93N55npz7c+UJo=;
        b=rC7cew6kNCtMXQP6n49fXn2htGTlbrdFGk1PJ/Y+omA9UdwOUEaxLrnFNt9Mr4oLwb
         ckVOhJD+X8HpMiKE2Mz8pCUOOZHRJKzjD7y9FbJvrgqDk4/D634swU82BtuS/Yznq53K
         1E6cBnq4ZEv/OUyMJ+yWWsz04k0KK6IjB8E4JE7iz/4hEY/2Xr3oBwaXam7VvB4p+Hov
         xeCWmlVi/+xim+qykHOzeTh1hcT07NmPOGhFpmQIncPZIU2HCLKv4rIlp8MWRScC7WKE
         FSLceXgORpf9dN9GtN0eQkBBpe9Wr8LnhF8BtyN+56kV4r1oydbv+JFBJjnCjzuG7IDF
         fpgA==
X-Gm-Message-State: APjAAAVrFAIMrWmSFNB/1l/bhdXR9zYNyq+O4DmcUdGinpxQoF7OaZyN
        H+qcc9Bfe3ckhLjR5tDe8fWRfI1G0LdmOcywVm0PAA==
X-Google-Smtp-Source: APXvYqxA2lh828czlvuZPQdxIx7kNWsEpY+ypB2dh7X6EOhNjKtEfH9QPpZoHBGJBDpSBiIPG/aROKCkNDrVlt1zVZY=
X-Received: by 2002:a62:b2d9:: with SMTP id z86mr48161518pfl.255.1552548004863;
 Thu, 14 Mar 2019 00:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190314061716.19892-1-sergey.senozhatsky@gmail.com>
 <CAH2r5msYG4H19GK1Fmnqb1dNCcp2qahULc_t4v9qdJ=OOZmGXg@mail.gmail.com>
 <CAH2r5msCs5ks3FUi_GhV2REsUR8t2h1=ybgLS6FyBEyka7Qb9g@mail.gmail.com> <20190314071245.GA2001@jagdpanzerIV>
In-Reply-To: <20190314071245.GA2001@jagdpanzerIV>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 14 Mar 2019 02:19:53 -0500
Message-ID: <CAH2r5ms3sdFx864M4se0V1eCAj_x8_3xyyRxoxqS52_UQNNjaA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: remove unused status severity defines
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

All of those uses of __constant_cpu_to_le32 apparently (at least
according to checkpatch) should be changed (someday) to cpu_to_le32
but I didn't research why the change from __constant_cpu_to_le32
--->   cpu_to_le32

If it has benefit - and checkpatch is right (it warned about
__constant_cpu_to_le32 being no longer preferred) ... perhaps would be
worth a followup patch to clean the rest of them up?   If you have any
context on why kernel code has moved away from using the older format
of __constant_cpu_to_.... would be useful to know if any benefit to
the change

On Thu, Mar 14, 2019 at 2:12 AM Sergey Senozhatsky
<sergey.senozhatsky.work@gmail.com> wrote:
>
> On (03/14/19 02:04), Steve French wrote:
> [..]
> >  #define STATUS_SEVERITY_SUCCESS __constant_cpu_to_le32(0x0000)
>
> Does STATUS_SEVERITY_SUCCESS still use __constant_cpu_to_le32?
>
> > -#define STATUS_SEVERITY_INFORMATIONAL __constanst_cpu_to_le32(0x0001)
> > -#define STATUS_SEVERITY_WARNING __constanst_cpu_to_le32(0x0002)
> > -#define STATUS_SEVERITY_ERROR __constanst_cpu_to_le32(0x0003)
> > +#define STATUS_SEVERITY_INFORMATIONAL cpu_to_le32(0x0001)
> > +#define STATUS_SEVERITY_WARNING cpu_to_le32(0x0002)
> > +#define STATUS_SEVERITY_ERROR cpu_to_le32(0x0003)
>
> Otherwise looks good.
>
>         -ss



-- 
Thanks,

Steve
