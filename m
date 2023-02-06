Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D5DC05027
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Feb 2023 14:41:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjBFOlV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Feb 2023 09:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBFOlU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Feb 2023 09:41:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25BE19F2B;
        Mon,  6 Feb 2023 06:41:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D8B1B810BC;
        Mon,  6 Feb 2023 14:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C42C433A0;
        Mon,  6 Feb 2023 14:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675694477;
        bh=Invyop0Vrpy/4vxCSmZxsYv+TgKBo2QnqpiBYoPic34=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=UDenQ/1xR20pNM4tdtspyaPqh1ygIs0ikoHxP6OKxpi9N32JyFmqSZIvpmvdwPq7v
         9s0vKlWqzFT0Vtca2asxrLRhTpfgkUtA5og21uYnTa0oBshHPhGKJJXKqBi3SkcTre
         tXF/cV4Tpy0y6n/iHydyrgqZvl9eQRPdn8J9gkFyQxQYbyCEHN63cWGpeHI/+wSIgF
         UERu09fRwhB7PBCq0SVlqql+E9UFkMnyM1GiwQwO3RfkqvTMkcX206a/mBR07AQX7X
         QkoeBDKKXByVjn5LYjNIWuZ5WuGTNxobib+SWp+cDdQEuTuSH+wss0XrNjUWbX54/2
         Dth1likDitVGQ==
Received: by mail-oi1-f171.google.com with SMTP id j21so9902176oie.4;
        Mon, 06 Feb 2023 06:41:17 -0800 (PST)
X-Gm-Message-State: AO0yUKVtoD45jl4lBppUidV8b3xYK9ToiA/RT4FpwSwcVb3C4Zy4Rm3y
        TDBA8ThThfDzvu9NxixGKP5gAGcjT741TqIvZHs=
X-Google-Smtp-Source: AK7set/Qoh4TNeUFC9Qi0w4HHSS1qD+DeLvrQ8kDsLnVYywPxUZ+Ieog0V2J50KHxzmuJWM/knIUTqTQUE3eEg7tNTY=
X-Received: by 2002:aca:6547:0:b0:363:a539:4f with SMTP id j7-20020aca6547000000b00363a539004fmr1272324oiw.189.1675694476392;
 Mon, 06 Feb 2023 06:41:16 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a8a:355:0:b0:4a5:1048:434b with HTTP; Mon, 6 Feb 2023
 06:41:15 -0800 (PST)
In-Reply-To: <20230206072029.32574-1-jiapeng.chong@linux.alibaba.com>
References: <20230206072029.32574-1-jiapeng.chong@linux.alibaba.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 6 Feb 2023 23:41:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9AwBLzGrkXpea-CVszJtbKwLD+Sd=UDvaiJgCQ-AG08w@mail.gmail.com>
Message-ID: <CAKYAXd9AwBLzGrkXpea-CVszJtbKwLD+Sd=UDvaiJgCQ-AG08w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Fix parameter name and comment mismatch
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-02-06 16:20 GMT+09:00, Jiapeng Chong <jiapeng.chong@linux.alibaba.com>:
> fs/ksmbd/vfs.c:965: warning: Function parameter or member 'attr_value' not
> described in 'ksmbd_vfs_setxattr'.
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3946
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks.
