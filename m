Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BC0C7618A
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Mar 2023 19:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCSTt2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 19 Mar 2023 15:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjCSTt1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 19 Mar 2023 15:49:27 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B508418A8F
        for <linux-cifs@vger.kernel.org>; Sun, 19 Mar 2023 12:49:22 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id y20so12486598lfj.2
        for <linux-cifs@vger.kernel.org>; Sun, 19 Mar 2023 12:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679255360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWVnfwqorRHrPNfr54tLTcucfAQGK6KzzxW2VNcbWB4=;
        b=dJYcCPkdWCgILeCRpgbtNJQyPc8vycxmVFH0iV/RL9q2Gh4Gh3gJqhSiYxFZnlVCLx
         NrhTqZIrFbnxpS9w5UbZkmJepMifEQ45pCnpx4uyU3SbA+733fvyQ++6So6uzyTZH5X3
         ZFymyKnDboWnr0jn/4BY9j+bFexAhmzWKGzIxR15RxeZPhnnrip7WTmcOzxEs1BoSKMr
         9JVfDoQ0SItRvOCxjPDPKSglKWYyACJ8UCew3uMl5aWUqR+i1BjML3lVPp8n7gNWNYVD
         nkvi+DJpIASsryEZ4bBDO6V5payhtycibBQ6a4R7X40cbV3k8i/v+tqsF0Lhelb5JRkQ
         r8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679255360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWVnfwqorRHrPNfr54tLTcucfAQGK6KzzxW2VNcbWB4=;
        b=CIOSoAIx/oguufUEXsLcgjVd4aP8ow9F6fnPLExBxHgUB3cVkcjP+KybfI0OI+Vabz
         ygtE/S+kc2zNnEilFxwOx1flBhRH2NY8VqZwods6rPQScy6TLS1lQQdwIWVlVrb1ZoLV
         X5oUU8xnOcnGI5poPsAYLRZZ7Edi0DdUu3shl9H+IGhekphsnxpzCm91CCJPdq7sonxh
         EjgY5EtFtRi1zQTy8u93umCoQ//YCvv1SrxvK3p2J5AP/9s62Yz/rpY9JDc6l6j/NiVD
         PPMIoyJENLNywCfnGQNLK2q0skFWLm03kP+C1qd8Z4B6J8TrctWxk2LH9erQTFzmTCg/
         0HDw==
X-Gm-Message-State: AO0yUKVP1WAFlIPRbAp2BM4QZ9RygFPcc4fA4tYn/+iG//modCgrCjcT
        SwXaGu0eWBB25lBF0dV6lxtF57LQoSndCNSP1/cy+oo29pg=
X-Google-Smtp-Source: AK7set8NCz2L9c2R5YPRG7s9Ji9stUAY/Ebr9R3Zjnbev0HR9OVFSvcgSBTj9py4S5B46XlwoNNZzLGkr/L2fFLKi2c=
X-Received: by 2002:ac2:5df9:0:b0:4db:2554:93a2 with SMTP id
 z25-20020ac25df9000000b004db255493a2mr6234295lfq.10.1679255360377; Sun, 19
 Mar 2023 12:49:20 -0700 (PDT)
MIME-Version: 1.0
References: <ZBdgHL3J+UVViuOI@sernet.de>
In-Reply-To: <ZBdgHL3J+UVViuOI@sernet.de>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 19 Mar 2023 14:49:09 -0500
Message-ID: <CAH2r5mtHRUUYCeb8SMPQhHunJvEm15EiVJcXFb+6DTsY2w4zMQ@mail.gmail.com>
Subject: Re: Helper functions for smb2 compound ops
To:     Volker.Lendecke@sernet.de
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

My main worry is that it is relatively large (which can make it harder
to review, and harder for Ronnie and Paulo et al to backport) but if
it is the cleanest way to solve various problems, then it could be
worth pursuing.  Otherwise, I prefer cleanup (unless relatively small
and reasonably easy to review) when it is related to fixing other
problems.

The biggest problems I would like to fix are:
1) using compounding in more places (plenty of benchmarks or simple
examples like gunzip, tar, rsync, to go through to look for places
where network traces show compounding not being used)
2) optimizing compounding better e.g.
    - "ls -l" of directory with mfsymlinks sends multiple compound
requests for every mfsymlink when only need one
    - "ls" sends an extra roundtrip for 99% of cases, to send the
final querydir (which gets no more files rc ...). We should be sending
"open/querydir/querydir" compound not "open/querydir")
3) ) we need to fix a few cases when we open a file in compound ops
when we already have an appropriate one open
4) we request leases where appropriate for compounding sequences (e.g.
open/querydir) e.g. when open sent but no close and reasonable
possibility of benefiting from deferred close.
5) we set the parent lease key where possible (quoting from MS-SMB2:
"The client MUST search the GlobalFileTable for the parent directory
of the file being opened. The name of the parent directory is obtained
by removing the last component of the path. If any entry is found,
ParentLeaseKey is obtained from File.LeaseKey of that entry and
SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET bit MUST be set in the Flags
field.")
6) we need to make sure we are always requesting handle leases (e.g.
RWH or RH) - we have one case (cachiong directories) where we request
"R" instead of "RH" and we need to make sure that we close any
deferred opens (or cached dir opens) when we lose the 'H' on a lease


On Sun, Mar 19, 2023 at 2:19=E2=80=AFPM Volker Lendecke
<Volker.Lendecke@sernet.de> wrote:
>
> Hello!
>
> This is not a formal patchset, more a request for comments.
>
> In fs/cifs when doing compound operations I see a lot of fiddly
> boilerplate code. Attached find a little patchset that introduces a
> struct smb2_compound_op capturing most of that boilerplate code, along
> with a few sample uses.
>
> Is that worth exploring further?
>
> Thanks,
>
> Volker



--=20
Thanks,

Steve
