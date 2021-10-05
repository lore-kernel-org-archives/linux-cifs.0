Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5757AC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 07:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4050B61186
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 07:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbhJEH3K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 03:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232108AbhJEH3K (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Oct 2021 03:29:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 363AC60F59
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 07:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633418840;
        bh=8G3A8NTTJmSVjj6NTu6d8yzd+ETTMp2hQuG+Bxg8GiQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=kTE4auWNfiVU2bG7CInYE9eb8i5T36zYUgPDxTvah5ao5aGV4rFsNljjRLfhq0Jir
         AGsl0pdBodvjbHh1hs3A0F0bOFr2/5nv1w594h4O03s1+1kaGDC5/eN9d5bhZb9y1l
         IWlLODfcBHH6Dh5scaDRsQtPPyHW5vG+E4B4/CgRqRAWFyyVrI1lESkvrHm1QHQ9lr
         ptIfXTUqVwEbeoReH48ujZdyD+2wADNmj0pcwrtNUlDAhULfPc8mKKAXs3L7I/mWzl
         k0gzclxvMtL3bT5XRdu4bPibmbAdLCp4MZM2lyLWgRUzHpjJs93KO9Y/b4IitLrCan
         EZkSuyas5uAEw==
Received: by mail-ot1-f49.google.com with SMTP id 97-20020a9d006a000000b00545420bff9eso24789867ota.8
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 00:27:20 -0700 (PDT)
X-Gm-Message-State: AOAM530m4299xfFQT+eC80Ow3jNyaXTBEm/tNDXptqhQZS3FUHwFRqo7
        FtrCAxm7LDLxBvF9XOqhGNT4WzZj0zgtyg8CMTI=
X-Google-Smtp-Source: ABdhPJy7+2W8wvqR83ahSsxNZSy+LlRtGmpaZ1XP/AIIJ5pratUe9dUY2YcmlPIMeP2K2O4CR94Bk3reeZ1uFB+gkr8=
X-Received: by 2002:a9d:67cf:: with SMTP id c15mr13056393otn.232.1633418839644;
 Tue, 05 Oct 2021 00:27:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Tue, 5 Oct 2021 00:27:19 -0700 (PDT)
In-Reply-To: <20211005050343.268514-3-slow@samba.org>
References: <20211005050343.268514-1-slow@samba.org> <20211005050343.268514-3-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 5 Oct 2021 16:27:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9E-UKDr+LRJf+q=-b4FSFHevVuk9MdSpGs_RaRGq5Rkg@mail.gmail.com>
Message-ID: <CAKYAXd9E-UKDr+LRJf+q=-b4FSFHevVuk9MdSpGs_RaRGq5Rkg@mail.gmail.com>
Subject: Re: [PATCH v7 2/9] ksmbd: use ksmbd_req_buf_next() in ksmbd_smb2_check_message()
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-05 14:03 GMT+09:00, Ralph Boehme <slow@samba.org>:
> No change in behaviour.
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Ralph Boehme <slow@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your patch!
