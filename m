Return-Path: <SRS0=GFFJ=XG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8A2C49ED9
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 03:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2F5D21D7B
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 03:20:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jDPU4ZiT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfIKDUk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Sep 2019 23:20:40 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39635 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfIKDUk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Sep 2019 23:20:40 -0400
Received: by mail-io1-f65.google.com with SMTP id d25so42565779iob.6
        for <linux-cifs@vger.kernel.org>; Tue, 10 Sep 2019 20:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Az3OkAQGhhyJjtqX77ZM8fMiOrfNV+qTXjdbD6raROs=;
        b=jDPU4ZiTxgGFjLdWWz5Tt4uu/snwNzWUGcrdlSm0q7EL9UtpxjSP0atXVDV73z+rVR
         6+odAK+a02kM8zE14toB4rE6x22TImB1d01Vcs75eEg9PIQWoK6xgKbmFzicqQfdlL57
         T7Q9LO296xHchfLjyNdTup+hjcRzkxAXi6NzsjiAFTFP/qMpZi8SypFVdoAeBK5hKAi5
         sOfewCW3t3Hk1n05loGCjxKft7lNAzPLWsDNeGO89vquYcN4SVzuAr568dX+uO4M71UG
         +dvT+QWQ+UvcqwVt70J/GFi6lcc6H/3lXB/vx/Yzl3DGz/X4+vKAwBY8HuLAove/KQWw
         4+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Az3OkAQGhhyJjtqX77ZM8fMiOrfNV+qTXjdbD6raROs=;
        b=jxMJQ/qZdqdLz7egHmI6kpAvWGcudqtwgKFk8Nppfe8Kigqy2IXzwz7sydgdAcThKZ
         8axeXI2kybLJDaSDsZzC5j3sl8eZt8MLHTGgXg9yL7rHVmh1K8pvtEnbzfcSm9LR4aHy
         BSCrcRR9kp5dV4odEtrCveWC9DdMU0CAR+FncQhgCEVb1ompbeJZNYioNS/cAOEYGt9d
         bKmn0vHPrfOkbLHRNZ+ahIgm40fRVXmygioSG7QqCZYeYRPxeACEOhcQJQG/HA0nwfC4
         65dgTx5JgYNscGCzAjeshSN1mbzPn0Y2MiRGc6IloxEnuqbQEu7khgypfY8kFmIQA4lw
         wW2w==
X-Gm-Message-State: APjAAAWcyaO8YFtffGVMLU8cTOBU5VKAoOKY//pcL1uKOHQQtXWs4qy0
        48yuaXMRvmrxw0LKUcJVh4PjLRrXBO5r80eaK6U=
X-Google-Smtp-Source: APXvYqztgTJwTtyd4MuBMiJZI/eVSZepj4gBlseBF6GsYVAGhHDhXI888GQRhfm5GBbF796AJ+mPB5HF2O+3BcCDB1E=
X-Received: by 2002:a02:7f49:: with SMTP id r70mr35860365jac.85.1568172039173;
 Tue, 10 Sep 2019 20:20:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtcHR2BpthaubPNgC8fO4uu2d7QkYraMAK3cFOciR9g2Q@mail.gmail.com>
 <CAKywueS3S_DPfFzENhHDQqTQ+aazbAPMdwVQX4nzDG63tuHsdg@mail.gmail.com>
In-Reply-To: <CAKywueS3S_DPfFzENhHDQqTQ+aazbAPMdwVQX4nzDG63tuHsdg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 10 Sep 2019 22:20:28 -0500
Message-ID: <CAH2r5mvNTgLHWKoxqmNW0US_9xQvNnRUqfMbfq9Pzx2U-P=U1Q@mail.gmail.com>
Subject: Re: [PATCH] Display max credits used at any one time for in flight requests
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixed this - and also partially updated the decrypt offload patch

On Tue, Sep 10, 2019 at 11:46 AM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> server->in-flight is the number of requests in flight, not credits.
> Even for multi-credit requests (READ or WRITE) we only
> increment/decrement this value, so the following change line should be
> updated:
>
> + seq_printf(m, "\nMax credits in flight: %d", server->max_in_flight);
>
> with 's/Max credits/Max requests/'
>
> The description of the patch and the title need similar changes as well.
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=B2=D1=82, 10 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 03:42, Ste=
ve French <smfrench@gmail.com>:
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
