Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D517DC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Dec 2021 03:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbhL3DfM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Dec 2021 22:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhL3DfL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Dec 2021 22:35:11 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C94C061574
        for <linux-cifs@vger.kernel.org>; Wed, 29 Dec 2021 19:35:10 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id h15so25203677ljh.12
        for <linux-cifs@vger.kernel.org>; Wed, 29 Dec 2021 19:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=E7Rtz0J6jAjUhvMhTzQM6UsVVV2uTRgNaJnqPj8HHuw=;
        b=WCPlR9eL+CVtxWjgfbmR1K/zLHuw5EDdTMb4oSK76gFVtINWxc5H9PtXKLus169s3O
         Pd9ZjgFz/Oxzq/clxNv7w6abkf01QS7O3xOLnYkBEIPi4PfS/JNDveh4SNh7LvrtD+9X
         uLYjZ7k3Lmh8lbzt5rF3lV9sdnsGQsOgmwxDDqLMeV5wBF5ilYsIw1r+IWcSZRQdWBgb
         IazOz/d/yDLELzmq983eGiZDrY3m19hZ6ErTpCd1LvkYAUVzAvLKBBda8yceB1OsNdN5
         t72T1q3hlJ0lasAw761MPNZoDfZvwV25SDlq/4EqxRCS2xq4fnZgb3rA7D/IPv7TTdlq
         3uhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=E7Rtz0J6jAjUhvMhTzQM6UsVVV2uTRgNaJnqPj8HHuw=;
        b=X7HNVSvOHCybk8ZC4bKIvu5ONCc64A8oqorOrZkRwkiTCXBW7hN2nJwjKI92WDC/hO
         oRRwgDHLq5m4hz7u2cBj0xlAxZ0K5DqCbESsZsIpHBj2XH7xxImCrMUWwmHeq7F7xVFI
         WkH9mrTmAZ/jIEJ9b/6+s30rJkFei1xwFUwtoyYl8u/d/UWLEa3EcJ/LmuBzz53qbuMo
         K0lh/cX1dccIlVzA2eYgUUE5z7ZT+ogPY3NhmJlvA4xHBiXkfBuh+uvJ92fu8J1MFy4v
         LjaJAUxorvnQwT6x8vaahG7ubmK0yCWczaLV0q+bmnZhS/L1olDn7p20u1ik4e8ezX5w
         tGdQ==
X-Gm-Message-State: AOAM530HlVAeA3A17xiF+Ktp9Ww7L9Pwr0+rBr2pJqLQxIUcHAd51x5L
        tsaDC3MfTzpuENeyWGcJmsGdj+eO5fvj4b16+F3P1WjjB7Y=
X-Google-Smtp-Source: ABdhPJw0hut2qqlf4yYHC05S9yN/EASYFQXLTKh7pmdMF3+p5HjIq7DcUfNRzfaEOyuy/r25NpRWEulY82ScIHojDfE=
X-Received: by 2002:a05:651c:1505:: with SMTP id e5mr17759443ljf.398.1640835307465;
 Wed, 29 Dec 2021 19:35:07 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvC84qghZH+296BV8f2QWh3w3q=LMbUOE6PHHFLHvKKnw@mail.gmail.com>
In-Reply-To: <CAH2r5mvC84qghZH+296BV8f2QWh3w3q=LMbUOE6PHHFLHvKKnw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 29 Dec 2021 21:34:56 -0600
Message-ID: <CAH2r5mtHQjZTLVNMxjDKMSuBxLCeONKETTsK6LTFv1VbXpHk1A@mail.gmail.com>
Subject: Re: First 5 of the multichannel reconnect patch series
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

FYI - passed Azure mchan test group with the first 5 patches applied

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/11/builds/148

On Wed, Dec 29, 2021 at 6:40 PM Steve French <smfrench@gmail.com> wrote:
>
> Tentatively merged the first five of Shyam's multichannel series into
> cifs-2.6.git for-next, pending more review and cleanup.  Comments
> welcome
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
