Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF64EECAAA1
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Sep 2022 00:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiIPA0M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Sep 2022 20:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiIPA0L (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Sep 2022 20:26:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29B548EB6
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 17:26:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61625B82312
        for <linux-cifs@vger.kernel.org>; Fri, 16 Sep 2022 00:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FCCC43143
        for <linux-cifs@vger.kernel.org>; Fri, 16 Sep 2022 00:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663287968;
        bh=uIcPDFKCEDeXhYPbL3txLz+7D2MC1I1vA1I7W9NaN/E=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=EZN2KdSmHoqZTOPrzGKeM5JB9Gc/dvYPYq5iDNMIFP8ID9KyRv7FjUNnhpAuq5b71
         PFZs2AZhMson4G0V4dbWeznmv9jc3b3UH29UKnB6EtuwBZK6WHtCLT4QCZTwUeVRkk
         v5JCVOGQEjh4cThO75Xlg89lxBWUtbvsV65ozzkh4ObC93U7yktX4wlRMP3oko/Osa
         dh5wmbhX85CkZUEgeI3tRF80T1+zA6mHrtB0vc8T1bnWECEdO0/+mwN0PJoGLlQcRE
         4JqTHh0cqh/s2+wvOvYmExClYVfHkYdsm/jpNNvvwsO8lJqb+97Brd0RUzMAYV499S
         kO3HPMxJ54daw==
Received: by mail-oi1-f182.google.com with SMTP id n83so4291742oif.11
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 17:26:08 -0700 (PDT)
X-Gm-Message-State: ACrzQf0N3oSCQVFQRMslQojfVBjG56J80pwhl0NUNOdetWHgM8TK5skf
        ItSlvSQ9sg4qD2qJ/eYaPDTGQzqstIzfyLis33w=
X-Google-Smtp-Source: AMsMyM4PIXp6afOkVktFBQT/bjay+KO7ksXXIK57skclUSPTbtMvgNstYOuHdIAuudj/4QOQcMUQzcuPMIKzrZE6C3w=
X-Received: by 2002:a05:6808:23d5:b0:350:4f5c:143f with SMTP id
 bq21-20020a05680823d500b003504f5c143fmr1239159oib.257.1663287967086; Thu, 15
 Sep 2022 17:26:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Thu, 15 Sep 2022 17:26:06
 -0700 (PDT)
In-Reply-To: <20220914021741.2672982-4-zhangxiaoxu5@huawei.com>
References: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com> <20220914021741.2672982-4-zhangxiaoxu5@huawei.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 16 Sep 2022 09:26:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-g8E8wpJDPSdiW7W_0JGudxUTJj6wr7C5wcnBUUTZF0A@mail.gmail.com>
Message-ID: <CAKYAXd-g8E8wpJDPSdiW7W_0JGudxUTJj6wr7C5wcnBUUTZF0A@mail.gmail.com>
Subject: Re: [PATCH v6 3/5] ksmbd: Fix FSCTL_VALIDATE_NEGOTIATE_INFO message
 length check in smb2_ioctl()
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, rohiths@microsoft.com,
        smfrench@gmail.com, tom@talpey.com, hyc.lee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-14 11:17 GMT+09:00, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>:
> The structure size includes 4 dialect slots, but the protocol does not
> require the client to send all 4. So this allows the negotiation to not
> fail.
>
> Fixes: c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock break, and
> move its struct to smbfs_common")
NACK. I am still thinking this tag is wrong.

> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Cc: <stable@vger.kernel.org>
> ---
>  fs/ksmbd/smb2pdu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index b56d7688ccf1..09ae601e64f9 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7640,7 +7640,8 @@ int smb2_ioctl(struct ksmbd_work *work)
>  			goto out;
>  		}
>
> -		if (in_buf_len < sizeof(struct validate_negotiate_info_req)) {
> +		if (in_buf_len < offsetof(struct validate_negotiate_info_req,
> +					  Dialects)) {
>  			ret = -EINVAL;
>  			goto out;
>  		}
> --
> 2.31.1
>
>
