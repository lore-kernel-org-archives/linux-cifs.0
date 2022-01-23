Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35214C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 23 Jan 2022 01:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbiAWBMh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 22 Jan 2022 20:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235160AbiAWBMh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 22 Jan 2022 20:12:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2161BC06173B
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jan 2022 17:12:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59AF7B80924
        for <linux-cifs@vger.kernel.org>; Sun, 23 Jan 2022 01:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3A3C340E0
        for <linux-cifs@vger.kernel.org>; Sun, 23 Jan 2022 01:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642900353;
        bh=q14P4r+WtCI7bkqEpIL7FYrZEYf8fub+WxPNCOfqJwM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=k+qRpfpzZr7Cg0ybF3hmhQlquVnqJrRhHDXfQroks13miX6cyyB2KYYk7CtyJwNam
         FrQzzbzNAAoHGy1tzNo54Zyo5VnvYezormQBCAWXmKOuBx41J4RV8Q6OTLBlCNJFj0
         ZM1n/lsyaJUz3h+udDS7Z56ZZETe7Sh/3I/nOVbcpMzq7+oQ4WoxtX/UOzRWqVhptB
         1QM1f/Y1L+vze7FnxrJfeLzdax/Hosq6fj3NSungOuGUdGN5uqFKABrOYeliXsJbQF
         zcmFAb2edM6XRHBQQtoRR4T5mn0HkXxluAprKq4NaCu7PQG1scLtzgWhkQS7FeLwIM
         4PIDw+A29nFtg==
Received: by mail-yb1-f172.google.com with SMTP id o80so39488223yba.6
        for <linux-cifs@vger.kernel.org>; Sat, 22 Jan 2022 17:12:33 -0800 (PST)
X-Gm-Message-State: AOAM531KIJTMLA/nUHzvifE5vF/n4l2TRa9/c/SSkNE5QFysk2BSDAfK
        26BGbXgbfQ0hUs3GejkStWTsKlgQYBcYEKkpswA=
X-Google-Smtp-Source: ABdhPJzCud+lAY3LRoGL9B4SClD+etGteWW3q5X4zxmaGoBl1ApKhsRJh3KWKQ5iI+sOGZsqcj/VyGdcB6da02xGhtI=
X-Received: by 2002:a5b:244:: with SMTP id g4mr15651116ybp.507.1642900352997;
 Sat, 22 Jan 2022 17:12:32 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:b08e:b0:127:3295:9956 with HTTP; Sat, 22 Jan 2022
 17:12:32 -0800 (PST)
In-Reply-To: <20220122173915.3894-1-ematsumiya@suse.de>
References: <20220122173915.3894-1-ematsumiya@suse.de>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 23 Jan 2022 10:12:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_cW7beJy3GOH954+dW1t=EENznd2j-RodegzQS+VDkxA@mail.gmail.com>
Message-ID: <CAKYAXd_cW7beJy3GOH954+dW1t=EENznd2j-RodegzQS+VDkxA@mail.gmail.com>
Subject: Re: [PATCH] fix return-type warning in usm_handle_logout_request()
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-23 2:39 GMT+09:00, Enzo Matsumiya <ematsumiya@suse.de>:
> Also put_ksmbd_user(user) before returning.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Applied, Thanks for your work!
PS: added prefix in subject.
