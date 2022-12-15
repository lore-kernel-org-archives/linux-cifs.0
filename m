Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C0FC25B04
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Dec 2022 17:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiLORcw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Dec 2022 12:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiLORcv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Dec 2022 12:32:51 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA55140A5
        for <linux-cifs@vger.kernel.org>; Thu, 15 Dec 2022 09:32:49 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id s186so5901791oia.5
        for <linux-cifs@vger.kernel.org>; Thu, 15 Dec 2022 09:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=05Zf0NXTHVXgPzdAvU0TFZksx81/kcsaCFl0GGhVfUw=;
        b=MTuKufN9w0DfqGZAe1WDG8a8fOcvVIfTm6N/TKaqAVSHmYhMd2pehgZKXZk6kyZf3O
         vZsCaOLOvQIr8X6p1FKK62Rhx564LH5SKMMypIIr0tpxQjt8KiuwzHMuiisSXOjO72vX
         AnJFc8pqupn92BVj6g3R0VKBVz11R2I8DXkC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=05Zf0NXTHVXgPzdAvU0TFZksx81/kcsaCFl0GGhVfUw=;
        b=dGMUOTKjHF+nYky8ad7XGk8ayv3D/voU3bFtu2rXudzDsVUSjQyY8RdimmVdXnw6bu
         9DTBQpvEjey2hYrfhx0O0BP7oF3puw1UUwsBXP9TNMhEAAryqiMvK37BeIwtmvHTE7QU
         dsbZNrUPAwlgloE0ixgZTIFBe3yLI3LYhvUVwqG4NptVyoeM4b24NEpnhS36BQ+4Mcaw
         uA+RxzrZ0Pa7oDGCkiL6VnUU7iX3tUtTnxdIfjYqgyHlOO1xSsenW76QjTC0ZUeoCbf5
         8moVaMMIjSrTez+qHKumqyGcUzPW3VecPG6q1gkh0xc7CqLMpX/4yCBx0MAt9PfipbzE
         S4+Q==
X-Gm-Message-State: ANoB5pkG+JveEhRYIQL200r5lrT1mgLjftJZ+85iTkcju4Xsa8XD6Qrt
        jeFIUToNuwcmjG3n4ERG5HY7Ry2P3Gy5Su9W
X-Google-Smtp-Source: AA0mqf7sdpukkjqj71SHkEdPgZdHvAx8jEB60Lk7uq0vfwMfWP0/YFDOvHkYsAHu0eROZBwtNPvLHg==
X-Received: by 2002:aca:1910:0:b0:35e:373e:6015 with SMTP id l16-20020aca1910000000b0035e373e6015mr13107262oii.58.1671125568592;
        Thu, 15 Dec 2022 09:32:48 -0800 (PST)
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com. [209.85.219.49])
        by smtp.gmail.com with ESMTPSA id bm18-20020a05620a199200b006ff8c632259sm10107371qkb.42.2022.12.15.09.32.47
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 09:32:47 -0800 (PST)
Received: by mail-qv1-f49.google.com with SMTP id c14so2306337qvq.0
        for <linux-cifs@vger.kernel.org>; Thu, 15 Dec 2022 09:32:47 -0800 (PST)
X-Received: by 2002:a05:6214:a45:b0:4c7:20e7:a580 with SMTP id
 ee5-20020a0562140a4500b004c720e7a580mr32788565qvb.43.1671125567413; Thu, 15
 Dec 2022 09:32:47 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvfH2Kn_h2z+NsCoOdN8eBNw9_6=fFmgPvFOejwnCJMuA@mail.gmail.com>
In-Reply-To: <CAH2r5mvfH2Kn_h2z+NsCoOdN8eBNw9_6=fFmgPvFOejwnCJMuA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 15 Dec 2022 09:32:31 -0800
X-Gmail-Original-Message-ID: <CAHk-=wikDs8v=Zk=Tdr7xRO3=9RWRa+2k068Upsk45uSx8r9nw@mail.gmail.com>
Message-ID: <CAHk-=wikDs8v=Zk=Tdr7xRO3=9RWRa+2k068Upsk45uSx8r9nw@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server fixes
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Dec 14, 2022 at 7:18 PM Steve French <smfrench@gmail.com> wrote:
>
> I can also send the client (cifs.ko) P/R tomorrow if it is easier but
> have been working on testing some important fixes which are not in
> linux-next yet, so not sure if it is easier to send the client fixes
> as two P/Rs, or wait and send the client fixes all together as one
> P/R later in the merge window.

I'd like to get the bulk early.

I'm traveling tomorrow (and to make this merge window *extra* fun,
Xfinity was messing with my home network yesterday), so if you have
the first batch that has been in linux-next ready to go, please get
that to me asap.

The less I have to look at while traveling, the better. I'm only on
the road for a couple of days, but then it's xmas week, so...

           Linus
