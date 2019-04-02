Return-Path: <SRS0=Apod=SE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F2AC4360F
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 23:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92A3C2084A
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Apr 2019 23:56:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XXAbFTHt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfDBX4B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Apr 2019 19:56:01 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:36284 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfDBX4A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Apr 2019 19:56:00 -0400
Received: by mail-qt1-f169.google.com with SMTP id s15so17496753qtn.3
        for <linux-cifs@vger.kernel.org>; Tue, 02 Apr 2019 16:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U6BJnWQhfL5iXiiCB9gb88pyXhkH5H3efBOaSuScaLg=;
        b=XXAbFTHt29rhLCIsTPSFg7a2wxb1ZXs7lW9QsTyIxHmCr3dFjPfZsdt9SKU8ja9dFd
         X6o+k1EtQ3sC0cZxCfmTWOu2R6FrT2dmnE1bb54Y8OVjpQgWOl6ZiUDf1MJ2cR8dnXjk
         xj5DwlEgI6mXSumAntqe4ULRvwR8y5tvEQLM/I6bdr5du77diFfrkan1kPFYe/s2K+iC
         GuhzEMp+fUEg7NgqdxyRKsqfhiBfHndwqEx2iFENwvFUnWAI/ckF21moLpCyEqh+BiXD
         o3WxXpiPd7Qe9Ldw949s2hlt20yi39OfbiQ12K/4akXMbCWghqeGj+hXI+ZTZ2u4bQ8L
         +CEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U6BJnWQhfL5iXiiCB9gb88pyXhkH5H3efBOaSuScaLg=;
        b=g7hOQcsyOb53z7+ldEbtQtt2wk5GGjAQ93Azmn9ZXFxwhZRbLwq81RcM9iNx2LYU1E
         5ZDqKMLUpI+5RQ6mp0Q2MxuIAHgGv9/Io0irSa7mOzPyawlKJMLXHT8ssfW/4gnsY6Ig
         Rn1eDus1HOVVLRC86mwZoqshvm1j5PJoxecuH5qbmMU/A7ykcyObtcejn0dgY9OeeYV5
         TRYtBI0bSpSKElHV6eBW+ZYsSda3WK6U9C3Wm6yrrcFM4plgtAuwkkIVxhpXuA9Dpeal
         cVc3vUzhOEFdRB7OwOTcti0DKAkMWAXzCZWa6CSOsCCltgabA/K4kGlCGimzpD6Xvbr5
         GVdw==
X-Gm-Message-State: APjAAAU10SnlHAxEcO4gxSrZUmBy59cpoWe1ZdTzmHtJutA5xq/cSats
        imNS+LKh4Q5bh5sa7gfEX8X60T1b+TkxquhZ7Ic=
X-Google-Smtp-Source: APXvYqw/gOiO1zAYVvNqfwPTJnMt17AxCRfFdXZyb6saCmkmPK1z9Za4BcNRSlHVk19hd0j8UklgPnwaUDINxyiNsSk=
X-Received: by 2002:a0c:d196:: with SMTP id e22mr58632519qvh.181.1554249359730;
 Tue, 02 Apr 2019 16:55:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mt7UjqRRCcdRt6Hw-VxLibasFuRWVAXzgWO+L4AD=FzVw@mail.gmail.com>
In-Reply-To: <CAH2r5mt7UjqRRCcdRt6Hw-VxLibasFuRWVAXzgWO+L4AD=FzVw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 3 Apr 2019 09:55:48 +1000
Message-ID: <CAN05THS2KwNL6CZz1zmNA9bnmLv=7tZDHyvwe9JM1gGe1PoZqw@mail.gmail.com>
Subject: Re: [PATCH][CIFSUTILS SMBINFO] Do not convert snapshot time to local
 time zone
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by me

On Wed, Apr 3, 2019 at 9:25 AM Steve French via samba-technical
<samba-technical@lists.samba.org> wrote:
>
>     We  get snapshot times in GMT time, but need to convert them
>     to DCE time (SMB time format) without changing the time zone.
>
> --
> Thanks,
>
> Steve
