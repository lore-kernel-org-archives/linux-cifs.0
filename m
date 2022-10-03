Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D49CC433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 02:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiJCCqK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Oct 2022 22:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJCCqJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Oct 2022 22:46:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D089436DFC
        for <linux-cifs@vger.kernel.org>; Sun,  2 Oct 2022 19:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6518C60F0C
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 02:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16E5C433D7
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 02:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664765163;
        bh=SL0CLS7xTrayuYH/ah2N13DC51aalL3DzkED6AB13P0=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=fF7mr8eTAvipEyVGAst5DIcd3twcJU/vQywANDcV7wM2GBrJjsd4Pk0FKU8kP3/lY
         702wC8nHYfskPrfS7zjGYdc02+B5tbIxVPJP6OzqH28cc6hYYhz8CFiw4NB7nYiD6E
         yEK6Wjkz+NDf92rJIWrWShHVTePYuTaryFxqAuYPJiMANbB/i25TlIsXBssg2qS0Md
         RTxSDy7v7PjLJBec6d2oYONQSNk2GGQuZkwwv1g1qct/4DmBNrw5M4lk0i0/gWvWeS
         EM0dfgMiGxPpth7tG72JHxroJjgoXKT/9Mq7bLSxabUW20VA7NLt3btCSCOYlqYQ0U
         2+CdQs3/N3XeQ==
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-131dda37dddso10614936fac.0
        for <linux-cifs@vger.kernel.org>; Sun, 02 Oct 2022 19:46:03 -0700 (PDT)
X-Gm-Message-State: ACrzQf1aB+EQl+CDtQf+fwWeCUbDiUG/RXesdEG1NpHZ0aacNwIpUwTT
        sRrHNViCw7o+LGRDN9mz763s/hJP2UMS1W/j6Q8=
X-Google-Smtp-Source: AMsMyM7QQwbRJ2DfaloKBbxD5cYk0oc8w1bp0TYEOL2y6mrz69Za6U1mxGLxr/mD/NDBCetznYj2cm0rBjwhFOFdYyA=
X-Received: by 2002:a05:6871:893:b0:131:84aa:5b80 with SMTP id
 r19-20020a056871089300b0013184aa5b80mr4681603oaq.257.1664765162901; Sun, 02
 Oct 2022 19:46:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Sun, 2 Oct 2022 19:46:02
 -0700 (PDT)
In-Reply-To: <20221002230934.367900-1-atteh.mailbox@gmail.com>
References: <20221002230934.367900-1-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 3 Oct 2022 11:46:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_DCSsO2iuMOd=VHdv1qhxPwj_-7BtyLi4C-ntMUR+WpQ@mail.gmail.com>
Message-ID: <CAKYAXd_DCSsO2iuMOd=VHdv1qhxPwj_-7BtyLi4C-ntMUR+WpQ@mail.gmail.com>
Subject: Re: [PATCH v5] ksmbd: validate share name from share config response
To:     =?UTF-8?Q?Atte_Heikkil=C3=A4?= <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-10-03 8:09 GMT+09:00, Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>:
> Share config response may contain the share name without casefolding as
> it is known to the user space daemon. When it is present, casefold and
> compare it to the share name the share config request was made with. If
> they differ, we have a share config which is incompatible with the way
> share config caching is done. This is the case when CONFIG_UNICODE is
> not set, the share name contains non-ASCII characters, and those non-
> ASCII characters do not match those in the share name known to user
> space. In other words, when CONFIG_UNICODE is not set, UTF-8 share
> names now work but are only case-insensitive in the ASCII range.
>
> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>
I agreed that Tom's review comments should be changed
ksmbd/ksmbd-tools together.
I will make another clean-up patches included Tom's comments.

For this patch,
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your work!
