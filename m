Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA8CC48BC2
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Jun 2021 03:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7E1A61C39
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Jun 2021 03:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhF0EA7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 27 Jun 2021 00:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhF0EA6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 27 Jun 2021 00:00:58 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F37C061574
        for <linux-cifs@vger.kernel.org>; Sat, 26 Jun 2021 20:58:34 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id a16so19234247ljq.3
        for <linux-cifs@vger.kernel.org>; Sat, 26 Jun 2021 20:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=4ABtkD1s9mAEhA4NtrP4gst8wve3z0WbTksMxezz37k=;
        b=iDGDari5aZDe+ofldE9/HMedBGvwLAdNvqjIPPRhLg7ei/GqNHNYCPqnMKkkbQ5kVi
         nmAYYgRX6N/Wp/01nZnrsdf3UycTnt40fzPNje/MYrJDPkrxKEIZ/3bnSYjNNCz0k4YJ
         aVmHZ9RW8rOwGkOFFkZSV0DH7Wv/G0zifSu5z2MlYy7/xaSaB8PryEPfKreKv82ujFLv
         2smE+SjWH+2XLnsnFVAF73c1EfklI+o8JeEubz0hBSbuK9xEXaoL1ZS99MSKPydI79bU
         7WNp1B7c92fHjdNaeCtIGadXmB+jO0d4AsBUuUXSLOeEN3ziOLuo41tDZ7osd0k2O0e9
         /eEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=4ABtkD1s9mAEhA4NtrP4gst8wve3z0WbTksMxezz37k=;
        b=giMXVZPzrIo4oZcQRDlTubB4q4pRlJotZxwoR+Npo98rjbhttfc13SPK3IsLx6pQyb
         OXTtdVc/RZl2iny/J/qTR2lPbOMHG8k53yQDqq5PiXdMMfk7mP+4LVkVsbToxWebqPVs
         PsFuX4/oyLOjLNT4thzFIS4NIiK+IJ3Pvg2Ah7ZDh1fxmkosggY/faa91RjIwro/wZhk
         rtQ13RzLXT06BUrCyu3ZIQmQDWbPKxdE3PwhUca01Ci9PlUFLgYGsphZJTX29Y5PiA8h
         gJcA6gWyJd9crDrOWaG8S92Y1sVgb6lrbjVxiqpqm5Qy3w6H0+eAWWpZeHCPKr+BOkUY
         BkfQ==
X-Gm-Message-State: AOAM531quc5iRaEYB1Kj7eoeMihJqwQKYdOKFqfl7NHEksDHOOkPJaCM
        kf5IYp9CfTy3PrEPw8JfcmCtXPiX3L48yLZ9Pzo=
X-Google-Smtp-Source: ABdhPJyXFFm4c+x9ws7IHF3jOqekc3Yvrx5bdS7TgIqYaI1tkzK5xnIdgaN+eUXwFi2mRd/XHkocKpfy7OvmK6Q7CAs=
X-Received: by 2002:a2e:a7cd:: with SMTP id x13mr14401178ljp.218.1624766311810;
 Sat, 26 Jun 2021 20:58:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms9kX=kzHneUkRXOQ-McbRxEck4uBVOQmjHq6q0rhGTCg@mail.gmail.com>
In-Reply-To: <CAH2r5ms9kX=kzHneUkRXOQ-McbRxEck4uBVOQmjHq6q0rhGTCg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 26 Jun 2021 22:58:21 -0500
Message-ID: <CAH2r5muDsZJ+VVuBWEfdtSCn8-ryn-A3B_XqEMQVqS0n8D=iLg@mail.gmail.com>
Subject: Re: Signing negotiate context
To:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The problem turned out to be that Samba was stricter than Azure server
in alignment - I changed it to 8 byte alignment for the new signing
negotiate context and Samba did not error out (although ignored the
context).   Azure was ok either way.

On Sat, Jun 26, 2021 at 11:48 AM Steve French <smfrench@gmail.com> wrote:
>
> I tried an experiment to Samba 4.13.3 and also to Azure sending the
> new signing negotiate context during negprot.   Azure ignored it as
> expected, but Samba server rejected it with "STATUS_INVALID_PARAMETER"
> (it wasn't obvious at first glance what was invalid about it but
> perhaps Samba wants different rounding than Azure).
>
> Has anyone tested the signing negotiate context (e.g. newer Windows)
> to Samba server?
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
