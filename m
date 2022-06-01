Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953E5C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Jun 2022 00:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348306AbiFAA4Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 May 2022 20:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiFAA4X (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 May 2022 20:56:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DCA939A3
        for <linux-cifs@vger.kernel.org>; Tue, 31 May 2022 17:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D809BB815F6
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 00:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98940C385A9
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 00:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654044979;
        bh=lJ7kHz/QNEK/pbEvKlFQzlAcFBG7GYmezdq2cRtSsOc=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=OBWQRZXkclWLz4BENLdAkwQp/q0MTqlmscRZ7YHX14lzVX7refRKzM27bTLEIS3gJ
         ItflNEeF9PmvTuOs3MJWHkaYBYCJzqoL3torF9t1mMQ3sJhkOU/DLmbiRDGa2lzW4t
         XD63GnSD9yWxhr5rJgyjomwjk/4LV+SwALOah+1UO1p7AdcW6YffZ7ydmx04tlnXb6
         H9yrmzLCwYpZbzNiP4nOPJk3uHPikkRSky+sWeiRSECSFBe6poFcgJkWtwEU9qL2aW
         vFmbUEgu5ZWZ8ue0N8klcGJiyduAzspS4zl5s6S70jA626nuuVBV9+/XMuRZS9k+x0
         VzW0OBK5zKBOA==
Received: by mail-wm1-f51.google.com with SMTP id p19so121944wmg.2
        for <linux-cifs@vger.kernel.org>; Tue, 31 May 2022 17:56:19 -0700 (PDT)
X-Gm-Message-State: AOAM530hGIbreOKZu5w0mSzD9F5InhCHIBb1rzb5ESLEJYVCDtwsAOql
        /EQ0tx2vpx4jErQUqG8txJUOTYM0eRN5g4XOYfE=
X-Google-Smtp-Source: ABdhPJw4RJ7WiWtTftPZv5ye9QRRW+6lV3uYM9sPTC1xnwAPQSkAwAgqjOzjT0E6PZBAqcAVQ5kL69lFB9vE7bWPvc8=
X-Received: by 2002:a05:600c:3b05:b0:397:54ce:896 with SMTP id
 m5-20020a05600c3b0500b0039754ce0896mr25933495wms.3.1654044977855; Tue, 31 May
 2022 17:56:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:ee4e:0:0:0:0:0 with HTTP; Tue, 31 May 2022 17:56:17
 -0700 (PDT)
In-Reply-To: <833010.1654031136@warthog.procyon.org.uk>
References: <833010.1654031136@warthog.procyon.org.uk>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 1 Jun 2022 09:56:17 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_9jw69iKPBvuE4DxdpwcH2H90h3NQDQ7nyxzbTnEcirg@mail.gmail.com>
Message-ID: <CAKYAXd_9jw69iKPBvuE4DxdpwcH2H90h3NQDQ7nyxzbTnEcirg@mail.gmail.com>
Subject: Re: ksmbd threads eating masses of cputime
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-06-01 6:05 GMT+09:00, David Howells <dhowells@redhat.com>:
> Hi Namjae,
>
> Steve says I should show this to you.
>
> My server box that I'm using to do cifs-over-RDMA testing is running really
> slowly because it has about 30 ksmbd thread hogging the cpus:
>
>     PID USER    PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+
> COMMAND
>   19993 root    20   0       0      0      0 R  14.3   0.0 910:06.02
> ksmbd:r5445
>   20048 root    20   0       0      0      0 R  14.3   0.0 896:19.22
> ksmbd:r5445
>   20052 root    20   0       0      0      0 R  14.3   0.0 901:51.52
> ksmbd:r5445
>   20053 root    20   0       0      0      0 R  14.3   0.0 904:20.84
> ksmbd:r5445
>   20056 root    20   0       0      0      0 R  14.3   0.0 910:39.38
> ksmbd:r5445
>   20095 root    20   0       0      0      0 R  14.3   0.0 901:28.48
> ksmbd:r5445
>   20097 root    20   0       0      0      0 R  14.3   0.0 910:02.19
> ksmbd:r5445
>   20103 root    20   0       0      0      0 R  14.3   0.0 912:13.18
> ksmbd:r5445
>   20105 root    20   0       0      0      0 R  14.3   0.0 908:46.76
> ksmbd:r5445
>   ...
>
>
> I tried to shut them down with "ksmbd.control -s", but that just hung and
> the
> threads are still running.  I captured a stack trace from one of them
> through
> /proc:
>
> 	[root@carina ~]# cat /proc/20052/stack
> 	[<0>] ksmbd_conn_handler_loop+0x181/0x200 [ksmbd]
> 	[<0>] kthread+0xe8/0x110
> 	[<0>] ret_from_fork+0x22/0x30
>
> Note that nothing is currently mounted from the server and it is getting no
> incoming packets.
Okay, How do you reproduce this problem ? Did you run xfsftests
against ksmbd RDMA ?
>
> Looking at the loop in ksmbd_conn_handler_loop(), it seems to be
> busy-waiting
> - unless kernel_recvmsg() is doing that?  In the TCP transport, if
> kernel_recvmsg() isn't waiting, but returns -EAGAIN, it will sleep for
> 1-2ms
> and then go round again... and again... and again - and all 30 threads
> would
> be doing that.
Okay, we need to add maximum retry count for that case.
but when I check kernel thread name in your top message, It is RDMA connection.
So smb_direct_read() is used in ksmbd_conn_handler_loop().
I'd like to reproduce the problem to figure out where the problem is.
Can I try to reproduce it with soft-iWARP and xfstests?
>
>
> Btw in:
>
> 		ret = kernel_accept(iface->ksmbd_socket, &client_sk,
> 				    O_NONBLOCK);
>
> that should be SOCK_NONBLOCK, I think.
Ah, I found that normally it is O_NONBLOCK but there are different
value for some arch.
I will change it. Thanks for pointing out:)

/include/linux/net.h
#ifndef SOCK_NONBLOCK
#define SOCK_NONBLOCK	O_NONBLOCK
#endif

/arch/alpha/include/asm/socket.h
#define SOCK_NONBLOCK	0x40000000

>
> Also:
>
> 	[root@carina ~]# ksmbd.control --shutdown
> 	Usage: ksmbd.control
> 		-s | --shutdown
> 	...
>
> that looks like it doesn't handle the advertised long parameters.
I will fix it:)

Thanks!
>
>
