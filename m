Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D478C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 23 Jan 2022 01:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbiAWBNC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Jan 2022 20:13:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57302 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbiAWBNC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 Jan 2022 20:13:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC805B8091E
        for <linux-cifs@vger.kernel.org>; Sun, 23 Jan 2022 01:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA417C004E1
        for <linux-cifs@vger.kernel.org>; Sun, 23 Jan 2022 01:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642900379;
        bh=jt4kg33WuT8+D+okj7wcJ0fv5CrF5lVDdGSieHlQZrI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Gr6BoGv2EKixBZ7ImoMa1iKy+9fEQ+QWh8RayzlH0bH3W14cEJDCbnX5ObnqV3HlU
         4dahv2B6WNOS1JvDcSJmmKFGgHvAh0LzwlTLP7sVo3OzWjMdSWiRnuSqXu3vnA8HfI
         5f2DIyHklf8Mvyo2RPr9mxsvBjgWYY1xWgdjIPAjxfG4zifeUX4RwaCKYfxlIJ5tjr
         2X1tLmdvcR5Dyu1guff9QCinh4mPzGqIFlWo8OG0oabcNN8ymIIhjFPkqc+1NvYiOY
         bekIUEOR0gFfbiFClnze8j1HnNkdNkPt5hy4ERq3iUDFHIIw8bDyZHaqKF+H2piEkS
         sMAwZ14lK1DkA==
Received: by mail-yb1-f178.google.com with SMTP id k31so37860458ybj.4
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jan 2022 17:12:59 -0800 (PST)
X-Gm-Message-State: AOAM530kXouoVG/TKMY6AXK12vpjYlJEqop5Fcl/4OyVY+P4UYH/hJhj
        fU1i2bjRrssDk17YamOj0KIHV3yTUb4NkS9hZvQ=
X-Google-Smtp-Source: ABdhPJyQPTl4u6tptXTqfInDYBE6aYF/nfPYwhVH7DqRy9Ci2pyLNKGiI2nDctVhdApbScti05iuNc4bp5+CGDBUdYE=
X-Received: by 2002:a25:6d06:: with SMTP id i6mr14533839ybc.216.1642900378884;
 Sat, 22 Jan 2022 17:12:58 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:b08e:b0:127:3295:9956 with HTTP; Sat, 22 Jan 2022
 17:12:58 -0800 (PST)
In-Reply-To: <20220122173928.3979-1-ematsumiya@suse.de>
References: <20220122173928.3979-1-ematsumiya@suse.de>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 23 Jan 2022 10:12:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_GN3PL+JM7x7=xQg602R_d-FmniZenueCEMmWhWet-0w@mail.gmail.com>
Message-ID: <CAKYAXd_GN3PL+JM7x7=xQg602R_d-FmniZenueCEMmWhWet-0w@mail.gmail.com>
Subject: Re: [PATCH] mountd/rpc_samr: drop unused function rpc_samr_remove_domain_entry()
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-23 2:39 GMT+09:00, Enzo Matsumiya <ematsumiya@suse.de>:
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Applied, Thanks for your work!
