Return-Path: <SRS0=aqf3=AT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 539CBC433DF
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jul 2020 06:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F2420720
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Jul 2020 06:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gDM3EVIU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgGHG0s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGHG0s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Jul 2020 02:26:48 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A669C061755
        for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2020 23:26:48 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id s21so22971426ilk.5
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2020 23:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pn8GBY9u14vO9QMttvB/sazRKMemi09toHt6Pn/6lxs=;
        b=gDM3EVIU96pgNcvp3OIbo5CWJq5881dN1rOpdVcwNMDLXJHu6HE6fLTqjOylb4JbIm
         Iri5Ji4MIKAyfIvQL/Psjl1mfFpdNnmPfpG7qAvtFGqu1Yp/EE+XX6JvDVQdAAvlxf6q
         JP0FM+sYBHXJb2J4euUYk9+ZmCIonjDac6bqDcN4bY4sYZVPQIxw7LHcrvvwW9h4rANm
         OOFKvDL47KNiclZYqA9RdoxY9mGTO4Tl4CbDHONes6q6HWqzHdJ99E4P/g1m/dsvYgTu
         3N7aVBN0amm/IETceLdX+2txqsFzYdZsuNW8dWubAvOSjnX7lwGnaggRqvTr0m7TA7db
         1tug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pn8GBY9u14vO9QMttvB/sazRKMemi09toHt6Pn/6lxs=;
        b=eyDiOnE4qrmAmzR5uw4UXOI5NLCHiO1XR2Km3R6u8og4wkk2hGSfTnNQ/RUDRkoLGu
         o+nv6Fouy5IZScrYDlnt3uZnTouG1f9mXZCV9sdN3roLwXLpaTrhtljMECDu2qgvQCpN
         o+7Ye6YU8MZ0D08Ok7nJGpV2diTQkeC572XI5n1WXeDGiROYlilgqysp6qImkKo4Xaq0
         Uxd4k3nteARudwhgBqkcnDN5Trd7TF/HRj7dH7p0sFKeJvOgzs1VtSya/q3mexCtJj5M
         X6n9SOGf3B/sIqxd5CVWU+pcRmYeWSMszBoXR5QX0FQc0vhq5OEbifrDCLX3oG4cirdF
         ZBsQ==
X-Gm-Message-State: AOAM531mU1HgOvsCv8KN417vIWMkqdimfvSNePp3eoCg4Tok85kPejuP
        HzUAC3q6qFgRUZ3oN/3uKPdG3e/YvTYu2c8F6r2M8Q==
X-Google-Smtp-Source: ABdhPJxfj04SPXB1DDYPRBVeWXCKKxbaFDC09AYyU9TquwGDoQSJxit6ilpgvnPw6bz/ifTOPILfJkC/NwhWKcOtePs=
X-Received: by 2002:a92:5a16:: with SMTP id o22mr8403104ilb.109.1594189607777;
 Tue, 07 Jul 2020 23:26:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvVKZn0sNrB2yq-eYBbFN4yN2BCQJT84X5uyKaf=SZ6og@mail.gmail.com>
In-Reply-To: <CAH2r5mvVKZn0sNrB2yq-eYBbFN4yN2BCQJT84X5uyKaf=SZ6og@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 8 Jul 2020 16:26:35 +1000
Message-ID: <CAN05THRQTh6NA52p7L5OadgoOKGfhgOdnMoC_89H4BBdAg3O+Q@mail.gmail.com>
Subject: Re: [SMB3][PATCH] fix unneeded error message on change notify
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Wed, Jul 8, 2020 at 2:49 PM Steve French <smfrench@gmail.com> wrote:
>
> Fix the length check on SMB3 change notify
>
>
>
> --
> Thanks,
>
> Steve
