Return-Path: <SRS0=2csP=X4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBDEC10F14
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Oct 2019 18:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9F0720862
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Oct 2019 18:57:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O7PPsQ4z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbfJCS5m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Oct 2019 14:57:42 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35608 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729355AbfJCS5m (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Oct 2019 14:57:42 -0400
Received: by mail-io1-f68.google.com with SMTP id q10so8101962iop.2;
        Thu, 03 Oct 2019 11:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aa6r931Rjp1NE7cgnIGCkHLvHKb0A2CYSfJ4m7AK8VA=;
        b=O7PPsQ4zo2sfTl6NOOpE5XsVzE5RNltNIJ3BWIjoP92YjkqCBcz4qI/eBObiEFXHxG
         KRCWmXU5E6KeddHOB8UC3E5e2kPXWnfMhDspqFWqDTx4jTXTKFnfflDpMxlSj8QQ1ljS
         fmuw1vNpa3Srq0SIWXs3Yi8+CZ2o1gSYFOzL3TWpH9CYIiygn++HYMB4hX9sctCfrbeo
         ATuEaJcaYLvYIjB/e6/PErOcfUZWKWlgQTRbvjxOQIFhwAhCJj5WwHA7nqs0A2i372Ra
         1nwpkJ3rEVH8ssU/VgHToN77qu95pjftoLb/trkIUAcWvXG3cECeieEVc2QRbCNL+uR/
         qKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aa6r931Rjp1NE7cgnIGCkHLvHKb0A2CYSfJ4m7AK8VA=;
        b=JNBm0G4oj6/+NQ4FoSknnwoZYj3/trQ5BoY91o6CSf22ajjNNv7KN7jRSG+Cj0tVwW
         A8C4IXl/QAtkMHfLXjAFpbGRw/GgWzpsCr515jsZ0cJ2Sul8KuX6YclYfr7YUy9u9Ln0
         V3Wwjm2EnNgQN2damUB8Z5I+rMLUM7Rho9CHpqqhRvco8wg9zfrwjcQrlxGweLKTXLcF
         4bJ0v/00rlBb+JcsqUXYH54hpyu0ggmpNJJusxksSSLxWBp2JvKbIQ//jhmdi0JnZ4WS
         fnD9S0d3SfvTNQk/5INLOw+sF7QH1djJaGBUUEoT+93lhApQEUe1OYG0qPoLUnDORzA0
         NYTQ==
X-Gm-Message-State: APjAAAXZp2PF22JgOfnvlpct3c3eo1Dsm0Qpweq+x6oOg/g6eeSpBbS5
        RC1tU7mVs2dtwHqbFnN38cquOoQWtTkvQtFomzI=
X-Google-Smtp-Source: APXvYqw5LZFI0OlAdzJ3Zi5QgTBf3yzfeslOKU0JWKwjHyMto7VKmPhcOSlsE1S3BTxGJi0w5yQ/WHCyiK/fEHdewQE=
X-Received: by 2002:a92:1657:: with SMTP id r84mr10980876ill.5.1570129060851;
 Thu, 03 Oct 2019 11:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20191001073413.GA51148@LGEARND20B15>
In-Reply-To: <20191001073413.GA51148@LGEARND20B15>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 3 Oct 2019 13:57:29 -0500
Message-ID: <CAH2r5mtx3OWKv4ZDM=Nob9nRi7ahRW-DK2nY9LP28urQ6NBvFw@mail.gmail.com>
Subject: Re: [PATCH] fs: cifs: mute -Wunused-const-variable message
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Oct 1, 2019 at 2:34 AM Austin Kim <austindh.kim@gmail.com> wrote:
>
> After 'Initial git repository build' commit,
> 'mapping_table_ERRHRD' variable has not been used.
>
> So 'mapping_table_ERRHRD' const variable could be removed
> to mute below warning message:
>
>    fs/cifs/netmisc.c:120:40: warning: unused variable 'mapping_table_ERRHRD' [-Wunused-const-variable]
>    static const struct smb_to_posix_error mapping_table_ERRHRD[] = {
>                                            ^
> Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> ---
>  fs/cifs/netmisc.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index 49c17ee1..9b41436 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -117,10 +117,6 @@ static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
>         {0, 0}
>  };
>
> -static const struct smb_to_posix_error mapping_table_ERRHRD[] = {
> -       {0, 0}
> -};
> -
>  /*
>   * Convert a string containing text IPv4 or IPv6 address to binary form.
>   *
> --
> 2.6.2
>


-- 
Thanks,

Steve
