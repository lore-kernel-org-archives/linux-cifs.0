Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C025EEB64DC
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Jun 2023 03:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjFXDuA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Jun 2023 23:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjFXDt7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Jun 2023 23:49:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9392226A0;
        Fri, 23 Jun 2023 20:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58C9661B9C;
        Sat, 24 Jun 2023 03:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E75C433C9;
        Sat, 24 Jun 2023 03:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687578596;
        bh=aQPtQfX+vTNM9nJygU5Fyd3Ey+a/BTH7D16Cf3wXHIU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=VDqdfb90lGZQLOpWplRjYuHoa6j77VqeuTRCpasruJM/zutx8BgY0g+8T7OnJTWpF
         YCJn86SRSCWmjHS9V83Whr8DWJKegmh+742kYpV3MIWpSH3Uwy4t2UQqM3fh5fn4dR
         a2IwQR2cVAYnWGS6xrtN48r5JHiNGWi69bUE9qvHeE6k9kIIKn1BISs0oUjctH2q5C
         aRcYvSv7DSXWB2YXlW91ViSBHALfaMi8N3YTQfQdcQMhnYC3CYLGUtmQMgF+2F4RNh
         KA8liMCNlNq7Nw8yw0I1TqWVPCNy0ROl0vWtWeS1Le/nzKos4lkAmXeUwvOhJrOxRC
         8a9iNZ51fbAxg==
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-560b56b638eso976902eaf.0;
        Fri, 23 Jun 2023 20:49:56 -0700 (PDT)
X-Gm-Message-State: AC+VfDwPoi+Cd1tLTODFHRSB75ZtYlnsc30tTcC718Zea2Km1sihsxef
        u7tTgurJxD8HKBaw89pozOOrNFsXT0fYxPfDE9o=
X-Google-Smtp-Source: ACHHUZ5n3pvo2wJUTlDwdgugjI8xKaFqEGHY/4TudLoGYYUiX8prwI+W4ZabPuF6XrDBCC4FFZn4FkDZB62dmVYGNAs=
X-Received: by 2002:a4a:e904:0:b0:563:16bf:4f9e with SMTP id
 bx4-20020a4ae904000000b0056316bf4f9emr1424051oob.3.1687578595836; Fri, 23 Jun
 2023 20:49:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:5e18:0:b0:4df:6fd3:a469 with HTTP; Fri, 23 Jun 2023
 20:49:55 -0700 (PDT)
In-Reply-To: <ZJNnynWOoTp6uTwF@work>
References: <ZJNnynWOoTp6uTwF@work>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 24 Jun 2023 12:49:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-tjowbv83M4PFqFSfzkOOU4RFAFB8AATcoyx8Rfg5tXg@mail.gmail.com>
Message-ID: <CAKYAXd-tjowbv83M4PFqFSfzkOOU4RFAFB8AATcoyx8Rfg5tXg@mail.gmail.com>
Subject: Re: [PATCH][next] smb: Replace one-element array with flexible-array member
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-06-22 6:12 GMT+09:00, Gustavo A. R. Silva <gustavoars@kernel.org>:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct smb_negotiate_req.
>
> This results in no differences in binary output.
>
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/317
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Applied it with reviewed/acked-by tags  to #ksmbd-for-next-next.

Thanks.
