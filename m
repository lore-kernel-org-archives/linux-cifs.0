Return-Path: <SRS0=V1Ry=WY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079A4C3A5A3
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 01:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0D922173E
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 01:50:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=monash.edu header.i=@monash.edu header.b="LC096stx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfH1Buw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Aug 2019 21:50:52 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]:33332 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfH1Buw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Aug 2019 21:50:52 -0400
Received: by mail-qk1-f170.google.com with SMTP id w18so1063970qki.0
        for <linux-cifs@vger.kernel.org>; Tue, 27 Aug 2019 18:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monash.edu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W896+by6QhMvbfu+Jdq4FvASDKaG0g0/+flZG7ttaqA=;
        b=LC096stxHILydilVFmrI7NGwuJHF4kz83Et8Ggo2rSHqUJYxHrK9co57fj5f1jWvJY
         P4xcHlFGPMMaM8bepWd5GAjpO0/nyaRAOmXBmhgXv+rYbtcrj0EVhf+8b/UayHJy/CP/
         hyANOJAfYDbFYziXkLE+pXcy6tdl0JbDw7HXkJ3k7ylfgdN3zJb1+rl9OaVvFh/6qezz
         uUWzQSbzKqwHGS3Rhm0dMqOPjQUj3ei3lhlcqeEkHfrip6Pqwaqgbj1F7hoCCT/OS2EF
         rdN5c3Mf+Y+Qi1ZOEqVqJZWozdyyfC+J+E4cAWYaeXgRcRvR4zR34ByQDUu4rh0GWJmm
         7wuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W896+by6QhMvbfu+Jdq4FvASDKaG0g0/+flZG7ttaqA=;
        b=P/T+s2DnrQ+16V0Gli4SVBGxPwN4sO6UMHpPLoHZij9rj48mdAEIcYmZeLgKqSDVcZ
         /72I3PSL1sGeEg7I9XREeQEC51dTji2LK/zcHus9GiXFOOkAdSzVQnMBMRhl1tqxVX9O
         ZRTf5iaO5y9lk728KCjZKM/CIdWCWSLZOF6d99PkYDBQjjO3hng3XwHAyUUd4z4Wx4N6
         1wPrkAKyE9FSVEaiO32PvcmeR8KH5lDzcAoHqut0ZcA2YZElWR3Ney0ylxRFW6RGa1Vu
         9Ie8ciA0q0OrxnqaI5zWDyiyeCwzyPu8uvOLcrYNw6+sBnXxsm2eUsSOUNLSEn4hJWVT
         plEw==
X-Gm-Message-State: APjAAAVaw3zYHaDWGcuW3FwjEDFQzrZDZp3JO008HqoTaGCo+GnqkIa0
        56kF1s8D6fxTPAwVPcRyTfAyOY0GH3QUE7T74f7z34MvoBI=
X-Google-Smtp-Source: APXvYqx8q8DpXcsSKbjZ5J0kpFWLPHlTtr4Ual1L9XbkTR5FMbiyHdlbMcMZkzAwe59s0E6xSU4Iz1Kpi+omKhrps3E=
X-Received: by 2002:a37:4c87:: with SMTP id z129mr1688402qka.205.1566957051384;
 Tue, 27 Aug 2019 18:50:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAE78Er-YVBzqaf8jCBio_V_1J2kRiWZ_SH-HnHm7KG3t46=j6w@mail.gmail.com>
 <CAH2r5mu446ssSPrACP8q859Cs0ynUMpJopH0t5qAsR=sGrByFA@mail.gmail.com>
In-Reply-To: <CAH2r5mu446ssSPrACP8q859Cs0ynUMpJopH0t5qAsR=sGrByFA@mail.gmail.com>
From:   James Wettenhall <james.wettenhall@monash.edu>
Date:   Wed, 28 Aug 2019 11:50:40 +1000
Message-ID: <CAE78Er8ueueA3wj0Cr6VmL5qreScYcYxZkRBazMSuU9C5A9s+w@mail.gmail.com>
Subject: Re: Frequent reconnections / session startups?
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,

I just wanted to say thanks for the quick and detailed response - this
is extremely helpful.

It could take a few days before we can report back on which of these
recommendations was most helpful, given some challenges with
reproducing the problem.

We've been upgrading some VMs to Kernel 5.0 using:

    https://wiki.ubuntu.com/Kernel/LTSEnablementStack

and so far the results look very promising...

Cheers,
James
