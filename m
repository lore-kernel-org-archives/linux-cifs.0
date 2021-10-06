Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE686C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 03:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AACF56120F
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 03:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhJFDWc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 23:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230261AbhJFDWc (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Oct 2021 23:22:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 141026120D
        for <linux-cifs@vger.kernel.org>; Wed,  6 Oct 2021 03:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633490441;
        bh=9sYbDUYPstpa7TIYVtleokcE+qQ1bIZfjJKvb3MYJYs=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Dxg0H33/q+1oa9VWx0Jy0qHce0t5h4wbZp/qXYWcX1emgVSspoEsX3BLl/dWP3Qvw
         pV0zQufcNafA5295IZf7Zo+Kben7Jh71oJefMzzhoDg1Kx7/coMEe82MfjarRXUf+l
         nF8oBUOSYNrPZVOvXHBcNFYoodFa2XU9J3KbZ7cF7KZHw+anObk8Pvkjeh/XfzgHy4
         ncQkfMMpYhY/i+IX0MWliMobVfJXIQBUPiw5XyYh0M1C53C6iaqTWterLxgL9HRcFV
         RLVApvNGYrO73wgFa12jw3c8e6yIasmoum5KbWeDb8mjEvbONPQUJHNWweo34E84+E
         Y0UBZyDQVs6Zw==
Received: by mail-ot1-f54.google.com with SMTP id 66-20020a9d0548000000b0054e21cd00f4so1274458otw.12
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 20:20:41 -0700 (PDT)
X-Gm-Message-State: AOAM533g1sZbvVLSdtXBZNM8qRTjCwAYEy4BuihsjCqkmrtFmqjvLubZ
        BqLgjfkcF+TKohdEvpWmPizlwBsiAvg/sJ2dm10=
X-Google-Smtp-Source: ABdhPJwgllt8ECcooxS8ni/fYDATtFe1LibPIxchQ7bU8ftO3+7b6dYJ88bcLqn1acYN6Ht+nu0P3rprv3vZVVPCXWs=
X-Received: by 2002:a9d:67cf:: with SMTP id c15mr17546603otn.232.1633490440420;
 Tue, 05 Oct 2021 20:20:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Tue, 5 Oct 2021 20:20:39 -0700 (PDT)
In-Reply-To: <20211004124704.17616-1-ematsumiya@suse.de>
References: <20211004124704.17616-1-ematsumiya@suse.de>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 6 Oct 2021 12:20:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9d6UvqPeyKDdFwBZ58xNy9u3cUBv1mtuYFrHWYukOr9w@mail.gmail.com>
Message-ID: <CAKYAXd9d6UvqPeyKDdFwBZ58xNy9u3cUBv1mtuYFrHWYukOr9w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd-tools: Add ksmbd-tools.spec template
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-04 21:47 GMT+09:00, Enzo Matsumiya <ematsumiya@suse.de>:
> ksmbd-tools.spec should serve as a base template for RPM packagers.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Applied, Thanks for your patch!
