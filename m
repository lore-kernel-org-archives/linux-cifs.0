Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E382BC6FD1C
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Mar 2023 04:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjCXE26 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Mar 2023 00:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCXE25 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Mar 2023 00:28:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C1CCDFE
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 21:28:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6F9F6292C
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 04:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEEBC4339E
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 04:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679632135;
        bh=1FfQfKlPnWoA0NPNOai7HMlDRSEZTiFKXW/6zX8BThw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Qkw9TbyLLGCVGXwmcg0Wak9JccIrih6e+b2YIN5W4q4/CjQ/SR0xSlPSjG/FbVtE1
         URjPwL82nCnoCnm9QuXfRhOCGkmOYSOAi0oPMCytOAyoGt/ffm1LM3ogiTZfIzs45u
         acZDItooLO8TUjOmHyhZBXfkW1c4LItkx1KeqwmcjxCd5dPqYkakM15vbu5TAZ3ToL
         KSOftKqXT0jjZ/3nTb5aAskmJ9Dg+z2HfTFS4JEqZ+KFoG5y+pnIQH1ulcYfolqhNc
         saZWiJza5vmoGY7wiQyRCs655Cj2i/Da1Zmh7xu5A9v3CeBeEpDA9ALsDgQ0/DHj5O
         UFugLt1CTqD2g==
Received: by mail-ot1-f41.google.com with SMTP id p11-20020a9d454b000000b0069d8eb419f9so335063oti.4
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 21:28:55 -0700 (PDT)
X-Gm-Message-State: AO0yUKURQUQBSesGfigoE4/32M2n6hUZD4CtxVOi6UCVzXZWORnpLiLN
        ooqrs2B0C8DlM8PcxTCuduPZAfS9dmHLkLXym/I=
X-Google-Smtp-Source: AK7set/rgaeq4jv7ueO+4hsMdiJLMJBkYMUBArCY33msQ4p3RRftC/aKieaWe3HGIvum4mzRxW4moD7axaPhYT0v38k=
X-Received: by 2002:a9d:744f:0:b0:69a:b32c:9882 with SMTP id
 p15-20020a9d744f000000b0069ab32c9882mr477125otk.3.1679632134460; Thu, 23 Mar
 2023 21:28:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:774e:0:b0:4c8:b94d:7a80 with HTTP; Thu, 23 Mar 2023
 21:28:53 -0700 (PDT)
In-Reply-To: <20230324035000.GD3271889@google.com>
References: <20230321133312.103789-1-linkinjeon@kernel.org> <20230324035000.GD3271889@google.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 24 Mar 2023 13:28:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_y+xh_2Rp9RLi1xWfrsgYSBvQENMkE0uS=W1Wnp6Espg@mail.gmail.com>
Message-ID: <CAKYAXd_y+xh_2Rp9RLi1xWfrsgYSBvQENMkE0uS=W1Wnp6Espg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: don't terminate inactive sessions after a few seconds
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com, Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-03-24 12:50 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On (23/03/21 22:33), Namjae Jeon wrote:
> [..]
>> @@ -335,14 +336,23 @@ static int ksmbd_tcp_readv(struct tcp_transport *t,
>> struct kvec *iov_orig,
>>  		} else if (conn->status == KSMBD_SESS_NEED_RECONNECT) {
>>  			total_read = -EAGAIN;
>>  			break;
>> -		} else if ((length == -ERESTARTSYS || length == -EAGAIN) &&
>> -			   max_retry) {
>> +		} else if (length == -ERESTARTSYS || length == -EAGAIN) {
>> +			/*
>> +			 * If max_retries is negative, Allow unlimited
>> +			 * retries to keep connection with inactive sessions.
>> +			 */
>> +			if (max_retries == 0) {
>> +				total_read = length;
>> +				break;
>> +			} else if (max_retries > 0) {
>> +				max_retries--;
>> +			}
>> +
>>  			usleep_range(1000, 2000);
>>  			length = 0;
>> -			max_retry--;
>>  			continue;
>>  		} else if (length <= 0) {
>> -			total_read = -EAGAIN;
>> +			total_read = length;
>>  			break;
>>  		}
>>  	}
>
> By the way, ksmbd_tcp_readv() calls kvec_array_init() on each iteration.
> Shouldn't we call it only if length > 0? That is only if the most recent
> call to kernel_recvmsg() has read some data.
If length == to_read is equal then it is not called. And in case
length < to_read, we have to call it which reinitialize io vec again
for reading the rest of the data.
>
