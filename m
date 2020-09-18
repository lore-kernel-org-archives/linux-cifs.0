Return-Path: <SRS0=kqF3=C3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5383C43464
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Sep 2020 06:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49EBA20771
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Sep 2020 06:20:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oqwkg5nw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgIRGUu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Sep 2020 02:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgIRGUs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Sep 2020 02:20:48 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF26C06174A
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2020 23:20:48 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j2so5647915ioj.7
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2020 23:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ow1PmgvtDy0O+F6XzVp/9iPFGbpf068boDygZBZxOM4=;
        b=Oqwkg5nw20cOYutG9HyCHElov2W/xP1bZ4ApwsOC9pmfcYDHoaSOW/Cw+w6CsPIeE8
         ej4Y9kax7+tfZ8eJSuXV8S0vqtdk8S1qLmMusTjdkgI7VqW6TcCHTbe5f7jYgv+lgoS2
         5IUHInnhevC9S9Xwwu8rXrRGIZLXfDVoVV6IMzJt+ByJF+iH7yWV8uRIDS+yh4s3f4AU
         Upz2Wyaik0CmoA6G2JZbwkjEs9owlRzUcOe2bCUdXbYkQczWqaNtEgDZgIzRSx6y8YUC
         z+MWI+x3KPFHe7t7t5/EBX59nkvwkFHfqpybp4Y/ZnAtqUEfLIV7tx7D89uxJds8WHYX
         lLDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ow1PmgvtDy0O+F6XzVp/9iPFGbpf068boDygZBZxOM4=;
        b=eO41VuuHCb7hGYtra3EqZXwHL30Q5N1UjjICygkwvkkpJbjksJXUObjHlqn73IiEQf
         yaK9Wmaix6ztgftU35LOoIA62z3lB9Rj73ioPm0/Br+4mk1IdIxcsOqsDPz8Az7W7Hbq
         aIrVZG39jjrlhjZoMZaDQxjwZohjB+GWghZRGDdtaCLxfOp9gIieFS6LgXXlvLMsLzkv
         MYvZMdr6KO8NpiE3GFfMdrTACgqHIlm+90pSlCW4XU8UtLn+aOhdDP6tDVuxdCLL8iW4
         flshEKu0CeweZf+k+SntLJe+zF3WE+mCpZ3VqIZoc8ifdQ9ZCWhBaWs5Xz2uCzUw3Vad
         K77g==
X-Gm-Message-State: AOAM531R482HStwzqXUjvL6J5H+8DTYaUanlupfzItt5rBXCZseW23p5
        cnQs7rUsbNCuAM8Yf0y1ttuAFma1LqAyQAhzLRF99a+A
X-Google-Smtp-Source: ABdhPJwiosHQXIUHVdGHnKaAxxreUX4ncAIUZZH5Axzg54HDtJ8edcpFZgLffVC0xLmYPuQGOf4lGq6H+x6HfesT4oU=
X-Received: by 2002:a5e:9613:: with SMTP id a19mr25784622ioq.116.1600410047541;
 Thu, 17 Sep 2020 23:20:47 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YSSsH=MOX6BTimj=uppBDxO66yJWK5ikkyd+knhBXKmw@mail.gmail.com>
In-Reply-To: <CACdtm0YSSsH=MOX6BTimj=uppBDxO66yJWK5ikkyd+knhBXKmw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 18 Sep 2020 16:20:35 +1000
Message-ID: <CAN05THShczOiSTD_bbRfPqHkOfOBLgNiaiibMu6GB+RzXsgK4A@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Handle STATUS_IO_TIMEOUT gracefully
To:     rohiths msft <rohiths.msft@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Sep 18, 2020 at 4:08 PM rohiths msft <rohiths.msft@gmail.com> wrote:
>
> Hi All,
>
> This fix is to handle STATUS_IO_TIMEOUT status code. This status code
> is returned by the server in case of unavailability(internal
> disconnects,etc) and is not treated by linux clients as retriable. So,
> this fix maps the status code as retriable error and also has a check
> to drop the connection to not overload the server.
>

Do we need a new method for this? Wouldn't it be enough to just do the
remap-to-EAGAIN and have it handled as all other retryable errors?


> Regards,
> Rohith
