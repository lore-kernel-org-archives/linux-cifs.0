Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE83C4332F
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 12:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D10A760FD9
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Oct 2021 12:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhJGMxC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Oct 2021 08:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233158AbhJGMxB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 7 Oct 2021 08:53:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1183560FD9;
        Thu,  7 Oct 2021 12:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633611068;
        bh=hGb1JlSq3PyDNYIwuBLjqtVcvfwVEJsqNcLLoxwPxrA=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=JQlRXG6uQElZuNBU25HjOW2Z50lvgIaIFzqH99ISbjZ5ul3yX1dvICAyukffAbirD
         lpNyGolcbqpZx+B9GYw1ZVFPPQe96WlxX6676eMc3ckSPcGTOJ9Gm/L2BrZzuCnbGo
         NRJY5hvH18zGgGBvXPR8hWAgLAp55z1CkMyeFEBvgkNmYNcC6UDl/BikQ16ngjnN1p
         udPsi2QFDIzAQ/Aafy50txU+4l7BuqBfOWoj4S9tgycrCxHW/QI6NS7uFHQxY/4/Lx
         2tB2dBRPhPugwOgEkl6r1SMgOduKZXmmbdUpbFkeV0i/kL2QVd8NoQBmt3a0ceYwkj
         kUZ8xgKRMVBhg==
Received: by mail-ot1-f42.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so7327637otq.7;
        Thu, 07 Oct 2021 05:51:08 -0700 (PDT)
X-Gm-Message-State: AOAM532CMfuLo71tXHsAGnXEAbPlB8vR9TTVJaMuBffD7FuACxyB8rxo
        C5+Qr3OBHg8mGN4lXTox3w1oLucEdbJZPA1Sx7A=
X-Google-Smtp-Source: ABdhPJysCr3QF8C/JF361ORGGTB9ixnldGaFIvfP0+9SIYfPx+0S7pLuGcrcyoeRLUI1m7x4UFkPwcN4/Kt196fqhaQ=
X-Received: by 2002:a05:6830:1147:: with SMTP id x7mr3435144otq.18.1633611067465;
 Thu, 07 Oct 2021 05:51:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Thu, 7 Oct 2021 05:51:06 -0700 (PDT)
In-Reply-To: <CAKYAXd_aOawm4MkBtkTxnLfeEk+F5VgrJHjyH8GSaeHjQbLtGQ@mail.gmail.com>
References: <20211007114716.13123-1-colin.king@canonical.com> <CAKYAXd_aOawm4MkBtkTxnLfeEk+F5VgrJHjyH8GSaeHjQbLtGQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 7 Oct 2021 21:51:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Mm_X_xhhB5ivk-n7zYySzxKSGkp5VYiaMRMo2GH_5zA@mail.gmail.com>
Message-ID: <CAKYAXd9Mm_X_xhhB5ivk-n7zYySzxKSGkp5VYiaMRMo2GH_5zA@mail.gmail.com>
Subject: Re: [PATCH][next] cifsd: Fix a less than zero comparison with the
 unsigned int nbytes
To:     Colin King <colin.king@canonical.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-07 21:37 GMT+09:00, Namjae Jeon <linkinjeon@kernel.org>:
> 2021-10-07 20:47 GMT+09:00, Colin King <colin.king@canonical.com>:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Currently the check for nbytes < 0 is always false because nbytes
>> is an unsigned int and can never be less than zero.  Fix this by
>> using ret for the assignment and comparison and assigning nbytes
>> to ret later if the check is successful. The fix also passes the
>> error return in ret to the error handling path that caters for
>> various values of ret.
>>
>> Addresses-Coverity: ("Unsigned compared against 0")
>> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> I think that this alarm is caused by 	b66732021c64 (ksmbd: add
> validation in smb2_ioctl).
> Fixes tag may be not needed. Because b66732021c64 patch is not applied
> to Linus' tree yet ?
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>

I found one issue in this patch.
if ret is -EINVAL, Status is changed to STATUS_INVALID_PARAMETER from
STATUS_BUFFER_TOO_SMALL.

static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
                                        struct smb2_ioctl_rsp *rsp,
                                        unsigned int out_buf_len)
...
        if (!nbytes) {
                rsp->hdr.Status = STATUS_BUFFER_TOO_SMALL;
                return -EINVAL;
        }

>
> Thanks!
>
