Return-Path: <SRS0=lfdc=RT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F98C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 16:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D96DC2186A
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 16:46:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vV8ixdBi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfCPQqQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Mar 2019 12:46:16 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35415 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfCPQqQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 Mar 2019 12:46:16 -0400
Received: by mail-lf1-f67.google.com with SMTP id h6so8928005lfc.2
        for <linux-cifs@vger.kernel.org>; Sat, 16 Mar 2019 09:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wEphyL49kbRkw7MSmy1dG5xknBWOd/2Be2hTM34VGQg=;
        b=vV8ixdBitOQV4q9hrTsT/Li/VLgjqZdD9jB9mdDaYyA993hkHcuqWdkNYCTFlclAXY
         KFfFLa4IMRTJJvde8uR11yh17NUg3cjkfefXJs2j93toyoKWuur7DA3VmZGZKuTgBOtP
         4h4mO/JwJzvWS7Xutj9iWp76Hv7vCQLfu8fbmAJUh3+rSwuwFO8H0s+5FD7USkAsuR6j
         eNoKH5EayUYpo3jb71BwDrhweGMvrYwJwJXLkcceYvVxbKWmyULLpts6tELR/9oi8FHB
         IGqm10WemNBExtxXT4hChk5pcVmkfABYS4iXjDtosgbDw2QOrjGgM0nGXNnbxhiRFvNq
         ApXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wEphyL49kbRkw7MSmy1dG5xknBWOd/2Be2hTM34VGQg=;
        b=mWI71jD/hJzGpId0J/PPqKGjhwcmU6Yla7oiA2MMe9DgdD2g4H86c76iLB0VkIXhE2
         CaOGdGA4sOTrZ+ygqK/hC/2ZoSEIVikcGb57sVWgm6aTWJkKHWGCjxX3AP22L082juvP
         YuGpfigvLgdKTVTxpTxUfJGa+p4TxkQuRXNGpH+HKy/dsz5XauLQg4hFT2yOWz1CY5dT
         PkAF5udolVnZOlqDRJkoqM544ARj7tumqrfNHvt1fcmD/HsU2FgjKrBCfWv31VhebRZN
         NSPOo3S4Sdm6Xv0gT3I0YJGwBAPy4T8vU9+L5ILTX4+xN138WOHA82VLM1btT4T6ZufH
         6yHA==
X-Gm-Message-State: APjAAAWoY892+NW/zOn/YXOQP1eCJ8x0IEm9/+rFePxl7xyzbGZ/AVXz
        nN4yfEgflD1ZzM5jQeJRA+x008ccTVe/poWvTw==
X-Google-Smtp-Source: APXvYqwvvfY+pzOYuJzxuU7azDhlTRatw//4sUvggsWn4wwTsawJ8DclqacPvQtGmVELrVlGCO3kPrbl10YU5/8Sif0=
X-Received: by 2002:ac2:55ad:: with SMTP id y13mr5546046lfg.97.1552754774083;
 Sat, 16 Mar 2019 09:46:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190316041154.27619-1-xifeng@redhat.com> <CAH2r5mv=WVFgrPAg1LkUYgnsk0z4X94wv2o40Kz0As2aSdqgeA@mail.gmail.com>
In-Reply-To: <CAH2r5mv=WVFgrPAg1LkUYgnsk0z4X94wv2o40Kz0As2aSdqgeA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Sat, 16 Mar 2019 09:46:02 -0700
Message-ID: <CAKywueS_pSZMcNXf97nPOyr=QbP5awET4TMDhL7LhQdTMM+jRQ@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: fix that return -EINVAL when do dedupe operation
To:     XiaoLi Feng <xifeng@redhat.com>,
        Xiaoli Feng <fengxiaoli0714@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 15 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 22:39, Steve Frenc=
h <smfrench@gmail.com>:

>
> updated and tentatively placed in for-next - running the automated tests =
now
>
> On Fri, Mar 15, 2019 at 11:12 PM XiaoLi Feng <xifeng@redhat.com> wrote:
> >
> > From: Xiaoli Feng <fengxiaoli0714@gmail.com>
> >
> > dedupe_file_range operations is combiled into remap_file_range.
> > But it's always skipped for dedupe operations in function
> > cifs_remap_file_range.
> >
> > Example to test:
> > Before this patch:
> >   # dd if=3D/dev/zero of=3Dcifs/file bs=3D1M count=3D1
> >   # xfs_io -c "dedupe cifs/file 4k 64k 4k" cifs/file
> >   XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> >
> > After this patch:
> >   # dd if=3D/dev/zero of=3Dcifs/file bs=3D1M count=3D1
> >   # xfs_io -c "dedupe cifs/file 4k 64k 4k" cifs/file
> >   XFS_IOC_FILE_EXTENT_SAME: Operation not supported
> >
> > Influence for xfstests:
> > generic/091
> > generic/112
> > generic/127
> > generic/263
> > These tests report this error "do_copy_range:: Invalid
> > argument" instead of "FIDEDUPERANGE: Invalid argument".
> > Because there are still two bugs cause these test failed.
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D202935
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D202785

Hi Xiaoli,

About https://bugzilla.kernel.org/show_bug.cgi?id=3D202785: which kernel
version did you use for testing?

There is a fix merged recently that fixes a similar problem:
https://patchwork.ozlabs.org/patch/1052067/.

--
Best regards,
Pavel Shilovsky
