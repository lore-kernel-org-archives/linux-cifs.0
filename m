Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D70CC433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 19:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E813661176
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 19:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhEKTm0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 15:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbhEKTmZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 May 2021 15:42:25 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88413C061574;
        Tue, 11 May 2021 12:41:17 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id c15so12092442ljr.7;
        Tue, 11 May 2021 12:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HVr2DKzjDUvg6iI48ECjEOWh6boU9GbSOxTfWJJZK0Y=;
        b=SrBrA3B6qq8fGEw0A+TQxItFg5gUkOHSzKw9zaf7iHNY4gl0Fynubs80reJ3emOLTp
         fFG4EMroSHYjdQQ7AgFHumyzTlhdJ+Uy03sjxQ0hVDc1RWp5ZOjiSholOKpC1oG+DG6/
         zXu0MJfGabpuR44C62D+NMmxx+P1Qwv71cuPWUNs/KPD/ULvAmk3fAT4gqjppSBmNgSS
         L1DuXFrA2GuF4p6BDNl31AbD4PUubWSAAPLsCqayuVGShb09a4QGrk2XI8xcxe72pYbk
         x6wqvyYg9T1BGghMIeIGvj+UodGKN5G7FIvZQIWpFH1hmRq/okgC6ynE60130R6JCc7u
         3gvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HVr2DKzjDUvg6iI48ECjEOWh6boU9GbSOxTfWJJZK0Y=;
        b=gdfzl/N/KWtAJFPDMFV8opv+d3UIi67/0ep4Io5/FO4IN2W2FTb5EbY8SDBHNJO9kM
         QIkK1bUVBE0MwnLL6E5BwBMgMh4bjkN7iNE8tQoTUE8GR+ekFiI74/N58YO83Zk2/z1v
         hecESmaIiCpUTSLHSzM5D2AmY2cliSeiK+M3iyZP+1Xw6JpLWcLAvkWPh7w+24z/OPtP
         9Zaj9Y2ezRfmsmk8HDWNZb8v8AsHqC0NdQJNx68XwJni1iVIqzAf6a2sCXspPq0b/xQP
         P4nAfq/zRkU1UGVzA7skgw9v12Tg6vsbqYhLEvpYfWImb/ksp3wXlUdkd5Hn/Gk9GWy2
         KpLg==
X-Gm-Message-State: AOAM532OWF0plkF5UCNANtnHqp1vJ0OU0cdltRlkrwZ11i8XsL2AwyzE
        raj8bQbcTJ5PFxNNgi8uF/0+ByFPm1Q7lz85HIPofkF262R3mw==
X-Google-Smtp-Source: ABdhPJx5mBeTavK+lpzaSmDRTejD+ebf6MDgj00Xr7oUwPP206a1yW7DFgwrQ0EyVAN3Hu3R2Xzt2aP/V5u8I/APUok=
X-Received: by 2002:a2e:7819:: with SMTP id t25mr4730550ljc.406.1620762075981;
 Tue, 11 May 2021 12:41:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms+NL=J2Wa=wY2doV450qL8S97gnJW_4eSCp1aiz1SEZA@mail.gmail.com>
 <2509400.1620738202@warthog.procyon.org.uk>
In-Reply-To: <2509400.1620738202@warthog.procyon.org.uk>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 11 May 2021 14:41:05 -0500
Message-ID: <CAH2r5mvkFBkVv7ur_VietcR7xCaRTFboD7+KdZ=MvkW6QC-KTw@mail.gmail.com>
Subject: Re: Compile warning with current kernel and netfs
To:     David Howells <dhowells@redhat.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, May 11, 2021 at 8:03 AM David Howells <dhowells@redhat.com> wrote:
>
> Steve French <smfrench@gmail.com> wrote:
>
> >   CC [M]  /home/smfrench/cifs-2.6/fs/cifs/fscache.o
> >   CHECK   /home/smfrench/cifs-2.6/fs/cifs/fscache.c
> > /home/smfrench/cifs-2.6/fs/cifs/fscache.c: note: in included file
> > (through include/linux/fscache.h,
> > /home/smfrench/cifs-2.6/fs/cifs/fscache.h):
> > ./include/linux/netfs.h:93:15: error: don't know how to apply mode to
> > unsigned int enum netfs_read_source
>
> Yeah - that's a bit the checker doesn't know how to support.  It's meant to
> make enum netfs_read_source-type struct members take less space.  I think gcc
> and clang are both fine with it.

Looks like sparse has been recently updated to fix this.  I pulled
from their git tree and rebuilt sparse to:

$ sparse --version
v0.6.3-341-g8af24329

and it works - no warnings  (other than the "Skipping BTF generation
one - which is unrelated, see https://lkml.org/lkml/2020/11/16/1452)

make: Entering directory '/usr/src/linux-headers-5.13.0-051300rc1-generic'
  CC [M]  /home/smfrench/cifs-2.6/fs/cifs/fscache.o
  CHECK   /home/smfrench/cifs-2.6/fs/cifs/fscache.c
  CC [M]  /home/smfrench/cifs-2.6/fs/cifs/cache.o
  CHECK   /home/smfrench/cifs-2.6/fs/cifs/cache.c
  LD [M]  /home/smfrench/cifs-2.6/fs/cifs/cifs.o
  MODPOST /home/smfrench/cifs-2.6/fs/cifs/Module.symvers
  LD [M]  /home/smfrench/cifs-2.6/fs/cifs/cifs.ko
  BTF [M] /home/smfrench/cifs-2.6/fs/cifs/cifs.ko

-- 
Thanks,

Steve
