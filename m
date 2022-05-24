Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D11C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 24 May 2022 02:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiEXCCC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 22:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiEXCCA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 22:02:00 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B652656F
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 19:01:57 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id y141so1086703ybe.13
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 19:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jhcYe35XzY57rAzKk7SlIQHu6nI3TuAFgw5/wa07y78=;
        b=JxeT+RmwfOiC0C/S3D28eJBrw6MWmFG8gQav3KcgjoCK55WEKW4xNAECwljOZ4G2wa
         CkdRxC4CQaW6FtCQJ/pgJSft2MZ62r/WXIUqJ0EGG9gk8BmxBK9sSGHJ19RKX6chpdsH
         d7Ahn3G6s53gsoY3c7T3uIZiiT8Dt7efHixPu9qVhOPOXzdLqDpEVcOeUhUyqT5ssBkS
         tE2rRQWbudusNDjsNZ4zljOYZ/QWTbvdnf3z+cVLcjX3iDZkV5sAfKPPCtRvuw9JfolZ
         AVzBWKRoNFhPP76WGSjO6eU7M9xEZSkNfDL/vOJhwtMg1X+TYnvpftORMTBc4+yYj+9G
         kXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jhcYe35XzY57rAzKk7SlIQHu6nI3TuAFgw5/wa07y78=;
        b=hig0hwsLiQardtjsM7Foz+gQ+QaaMQKEEgOqKA7LhvFlcF1wPdmd6sL+sIIv4YN03I
         g1ob+53HDA05l8GVhiVFJsJ/93x/g1ysf1h/FwNiqqIelpX50/taC/iZMDifq/5CKIb4
         VU9rZ6Uexb7129807plXtNKohU0FBtKFusDfEBKE/C/t8gGbTlOBypx73PDHFVnoUg6W
         ZQrV93737cwc1z2w5G6D1T07WtyCdak2NyCJD1e2z9ch8PuVGSRYGJMiwRf9KYYMpkmn
         iw4dTst4AZvgQIQWDwbW8Fzq6Jykk7egr2T3M1vNbrvNltu6cBn51mH+axFVQaXTs08a
         +jtA==
X-Gm-Message-State: AOAM530Uaru5GU+SjFn0rXBGsTkmTE48lJWLPAkVST3YDRSR21d1gQvf
        sqZH1NwIWADrMKmZ/NvqS6vt4nyZqXx3irmvjVI=
X-Google-Smtp-Source: ABdhPJx8DV1VA21JQIzaXJ5IEexmcjzpBsqEmFBOoqigl2dihk7UcAFrosuGsrIVGaew4yGBuPj3aYkEWoWudUylMrY=
X-Received: by 2002:a25:8892:0:b0:64d:d0c8:2460 with SMTP id
 d18-20020a258892000000b0064dd0c82460mr23774689ybl.531.1653357716336; Mon, 23
 May 2022 19:01:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtJhnTEjv4dHN6Nf+oa1+k+W4hCMk_how3LdH+6BhMmcA@mail.gmail.com>
In-Reply-To: <CAH2r5mtJhnTEjv4dHN6Nf+oa1+k+W4hCMk_how3LdH+6BhMmcA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 24 May 2022 12:01:44 +1000
Message-ID: <CAN05THRx78kxvax9cKzHwPffNXTd7Az3k4PERLPEVPcOQwUeNg@mail.gmail.com>
Subject: Re: [SMB3][PATCHES] two patches for minor coverity warnings
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by me for both

On Tue, 24 May 2022 at 12:00, Steve French <smfrench@gmail.com> wrote:
>
> Fixes for two minor Coverity warnings
>
> --
> Thanks,
>
> Steve
