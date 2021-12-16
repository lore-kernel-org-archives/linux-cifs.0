Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED17C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 01:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhLPBiQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Dec 2021 20:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbhLPBiP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Dec 2021 20:38:15 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD06C061574
        for <linux-cifs@vger.kernel.org>; Wed, 15 Dec 2021 17:38:15 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y22so10264419edq.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Dec 2021 17:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2G4etLmn+oKpsjVbl7vh/fJTshn3VOPmhWgMmIY383I=;
        b=TEdT7GZFexhJ3v1w/oXcjVw3foQUc4XQLl57JoSU+aFyMxI/Gu1m3NqxhNVm7smPKp
         dnv4C/Ji6aYR9ZYAMBD4SZj3HTtSLDkXVISGZJrMXWUXbOWrkYh7kLqp7YuJFgZo2/G/
         j7IjPTpDB9W+sEqC2QBXlmZKNhNbmq4TpEKZs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2G4etLmn+oKpsjVbl7vh/fJTshn3VOPmhWgMmIY383I=;
        b=kb3GfdpnO/Nb2yjyXZ3r5mT1cpmHm48NWoWF/SY5grA0yIrcqplpP4yTMu63VBgOcG
         I34znEFNPszkls1uQ4Uq61o25fQzz3WPBZJy+x2d52OusM4rBRKkkkgvgCoWyoBgsnwh
         J03aK/dttLwk2PqD9TzsRKhpoYNvjBFdjRc2fQkOIM2iNAyQMYSXxIQFUj8iRyigp3kr
         6JD8T3dATPrgrSdsUj1SsdVXFxuuDT++g+9aCBA/8fBMRD6aiQOmwkTjWMx8rHoQPNJz
         8qaCMGlQMUtQeGDT5opHqV30tv5YlQuZLUXNNfzirPgtCXIYHozyZ9ENhFL9X8al0f2m
         LYnw==
X-Gm-Message-State: AOAM531Xcp6y0XWw9ujQobI/MBsZr5sZdonBJ0bsgbPWEPBkZYJcZor6
        HUEcy5xT0OJ0Bif+wYVnkLlCaW7HJII1iDNlWIknJQ==
X-Google-Smtp-Source: ABdhPJxPIIaCCjchnD5G5NgHnRB/LVvI1RaGNnLME8zPEcFPqotCEfbgyje/5BjHU1FRPt/CTRZM8i1gxm4dwfQSRBY=
X-Received: by 2002:a17:906:9bf9:: with SMTP id de57mr13539739ejc.439.1639618693772;
 Wed, 15 Dec 2021 17:38:13 -0800 (PST)
MIME-Version: 1.0
References: <20211130184710.r7dzzfhak4w3eoi6@cyberdelia> <CAKYAXd9b0Pji2+Ek9ZcRjN0SfZd4jzyNtDLKwzySh4WCjmSYkQ@mail.gmail.com>
 <20211215150008.u26snbaml5amlaep@cyberdelia>
In-Reply-To: <20211215150008.u26snbaml5amlaep@cyberdelia>
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
Date:   Thu, 16 Dec 2021 10:38:02 +0900
Message-ID: <CA+_sPao7zLjEpwsM7i96Mrohe8Uqpd=qzAq+ykw=K0NWjtLxYA@mail.gmail.com>
Subject: Re: [RFC] Unify all programs into a single 'ksmbdctl' binary
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

On Thu, Dec 16, 2021 at 12:00 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> Any feedback on this proposal? Should I focus on polishing + splitting
> into meaningful commits?

I haven't gotten a chance to look at it yet, but in general I have no
objections to the "git-way" implementation.
