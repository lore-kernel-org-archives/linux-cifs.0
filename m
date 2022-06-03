Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CEEC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jun 2022 00:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240278AbiFCApn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 20:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240105AbiFCApl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 20:45:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EA4344E6;
        Thu,  2 Jun 2022 17:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8293B821B2;
        Fri,  3 Jun 2022 00:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC55C3411D;
        Fri,  3 Jun 2022 00:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654217124;
        bh=Y4FmSZHWkPlbTR8VMvDXLRT0HAOf+Tiqs1InPKQ4ipQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=cKfSeFpoidVkm8H1jXAn71pK5aCeEb2Yp6mU1XHRz8netC1hN61fr0dvm0mFqb8Ai
         edJwYll/1IJszxGoxa5Y2AkNWrrf4DP6+ggENFDYS/h/Y1mRR9LDO4L8zCWVagHsyH
         5OT6Bxv/YgChw4/Q6h0cKwtTQqxZZSCVe51DOKePEqSv6os93o0vPPzcz9yHD56Z49
         V9q869OP60ltzqbXBheODSj56RlxCGVNXTiNrE13v21hiod+JumA4D8fo7dTq7Oos1
         1tJ7yNUzRUk9Yo4mIDAgeyImgQI46Siv1GEq1gdBHbniIhAvmZYH6+0nAX5XQ8Ceql
         YKypzlb8qkJOA==
Received: by mail-wr1-f52.google.com with SMTP id p10so8441679wrg.12;
        Thu, 02 Jun 2022 17:45:24 -0700 (PDT)
X-Gm-Message-State: AOAM531KppSHX9rvzbq8DNaPKy8MS3by7jzdHUpj7Slzsjf9YvFEnNuQ
        yCg+vxOiCq1oxzG0Lmr3unmcOHI+s4EPcMp66Nw=
X-Google-Smtp-Source: ABdhPJyNkmByYStAWv2iXVaJhQGCqWNDJ/hZsgjX8zQSW34mPdOILNL3XL6YHslfUazyP+vqmXiV+nuR2V+PB1fH+UA=
X-Received: by 2002:adf:d1c4:0:b0:210:1935:3dd8 with SMTP id
 b4-20020adfd1c4000000b0021019353dd8mr5819972wrd.229.1654217122720; Thu, 02
 Jun 2022 17:45:22 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:ee4e:0:0:0:0:0 with HTTP; Thu, 2 Jun 2022 17:45:21 -0700 (PDT)
In-Reply-To: <20220603001021.GL2168@kadam>
References: <YpiWS/WQr2qMidvA@kili> <CAKYAXd_=x-uT8U_2tdbmVxbhyg_pDY03NKP9zzDwQZmm0TxQmg@mail.gmail.com>
 <20220603001021.GL2168@kadam>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 3 Jun 2022 09:45:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9zSCd5d9K2h9EvTbbXea1zMBcDU5Ryi6o5=GRGFQ97ag@mail.gmail.com>
Message-ID: <CAKYAXd9zSCd5d9K2h9EvTbbXea1zMBcDU5Ryi6o5=GRGFQ97ag@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: clean up a type in ksmbd_vfs_stream_write()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Steve French <sfrench@samba.org>, Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-06-03 9:10 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> On Fri, Jun 03, 2022 at 08:18:19AM +0900, Namjae Jeon wrote:
>> 2022-06-02 19:51 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
>> > @@ -428,9 +429,9 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file
>> > *fp,
>> > char *buf, loff_t *pos,
>> >  				       fp->stream.name,
>> >  				       fp->stream.size,
>> >  				       &stream_buf);
>> > -	if ((int)v_len < 0) {
>> > +	if (v_len < 0) {
>> >  		pr_err("not found stream in xattr : %zd\n", v_len);
>> > -		err = (int)v_len;
>> > +		err = v_len;
>> Data type of ssize_t is long. Wouldn't some static checker warn us
>> that this is a problem?
>
> None that I know of.
>
> To a human reader, the cast isn't needed because when a function returns
> ssize_t the negatives can only be error codes in the (-4095)-(-1) range.
> No other negative sizes make sense.
>
> On the other hand, the "if ((int)v_len < 0) {" line really should
> trigger a static checker because there are times when sizes could be
> over 2GB.  I will write down that I need to create that checker.
Okay, And there is a similar type casting in ksmbd_vfs_stream_read().
Is it not necessary to change together?
>
> regards,
> dan carpenter
>
>
