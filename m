Return-Path: <SRS0=S2FA=RS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE01C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 14:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABD1F21871
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 14:29:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jnbkgcBx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfCOO3p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Mar 2019 10:29:45 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46223 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729241AbfCOO3o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Mar 2019 10:29:44 -0400
Received: by mail-pg1-f194.google.com with SMTP id a22so6567969pgg.13;
        Fri, 15 Mar 2019 07:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4jF0JNP0GEqFOCSeN3PTMsB/S2NPfTdpmeL7nyzg8d8=;
        b=jnbkgcBx5qjzYQYNsGJD9AfeYBhtS8woMivA6lfEb9oJoIsH2B0Vuhzz+uhKwsXqFK
         pCIDGoXueOhzRXMdbmY7YWaCxGBTb4+6aBtjoQyWb8XLLDAOsbRXfyQKBh+ZArI3bN+T
         HRaaBWmR17SnPSOvmYRxtv7r8R3CKPSEFcJq0uM/PNlsILDQD9RxDGj0lEpUId0LqcT6
         RjaQxxFAkjZN7+lW2oQEBLEBL8SXb7zsPO1/Y2IrJoNu55qQGTgzDDKpe5gvc4pCOW3H
         GxewOdt95fVQHdqAhUO2eMt1tuTRDhJo6y3PsiyYVBLzTOsaRFQessz0AsdPi4bmGGPz
         gJ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4jF0JNP0GEqFOCSeN3PTMsB/S2NPfTdpmeL7nyzg8d8=;
        b=Ii99lzNmB6zqUpyesxF2uj8udsAfEMnJk/882//+oWdFUum2UQxIqfTqZCY7Blvggb
         uwgHLtthYEtnQwGAmRVNinajUXqD9QxGkqKfguWglI8SPQJzrZVanUaE9s6yYVMTTKPD
         Pz5/2Mnr/bkcblZECu5kRG2SUZ/vvnmFmChePgksoATLNYG/aZXm0902S3KKvGvVC0HN
         vzYn2mdWsh6LLJ312ewWBLaQXcmVvGR5tZAkNJkWIurBNKQmEhwGc+8I/zLpqYv2slkz
         RNIeFB5REXv6zs9br9lVnvpqBPIIL3Hj9boZp0+yrlzZtQGSLtF5hRZwXdqlLP+ORWDy
         Fuaw==
X-Gm-Message-State: APjAAAXM8cNi5am70fFNbKGm5d1dkSVa+hAyW41ILuYR1YerSbaVTd4Y
        i/UigJ11FzX6MrZToPXygJA=
X-Google-Smtp-Source: APXvYqzgF09sr9Zx7QYz3ctV43TClDZ//0dgxZz4aYiRBzeNEM7oxmeRAvXtAxMdPw16yK1yQcxv5Q==
X-Received: by 2002:a65:424d:: with SMTP id d13mr3720798pgq.203.1552660183557;
        Fri, 15 Mar 2019 07:29:43 -0700 (PDT)
Received: from localhost ([121.137.63.184])
        by smtp.gmail.com with ESMTPSA id m3sm2639905pgp.85.2019.03.15.07.29.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Mar 2019 07:29:41 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Date:   Fri, 15 Mar 2019 23:29:38 +0900
To:     David Laight <David.Laight@aculab.com>
Cc:     'Sergey Senozhatsky' <sergey.senozhatsky.work@gmail.com>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 2/2] cifs: don't use __constant_cpu_to_le32()
Message-ID: <20190315142938.GA32256@tigerII.localdomain>
References: <20190314061716.19892-1-sergey.senozhatsky@gmail.com>
 <20190314061716.19892-2-sergey.senozhatsky@gmail.com>
 <757dbafbdadb45f6a3de728ecfd05c5d@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <757dbafbdadb45f6a3de728ecfd05c5d@AcuMS.aculab.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (03/15/19 12:31), David Laight wrote:
> From: Sergey Senozhatsky
> > 
> > cpu_to_le32() is capable enough to detect __builtin_constant_p()
> > and to use an appropriate compile time ___constant_swahb32()
> > function.
> > 
> > So we can use cpu_to_le32() instead of __constant_cpu_to_le32().
> 
> Unless any code tries to use them as case statement labels.

What is the problem?

For compile time constants cpu_to_le32() should do the same thing
as __constant_cpu_to_le32().

There seems a whole bunch of cpu_to_XX compile time constants which
are used in case statement labels

include/linux/sunrpc/xdr.h:#define      rpc_msg_accepted        cpu_to_be32(RPC_MSG_ACCEPTED)
include/linux/sunrpc/xdr.h:#define      rpc_success             cpu_to_be32(RPC_SUCCESS)
include/linux/sunrpc/xdr.h:#define      rpc_prog_unavail        cpu_to_be32(RPC_PROG_UNAVAIL)
include/linux/sunrpc/xdr.h:#define      rpc_prog_mismatch       cpu_to_be32(RPC_PROG_MISMATCH)
include/linux/sunrpc/xdr.h:#define      rpc_proc_unavail        cpu_to_be32(RPC_PROC_UNAVAIL)
include/linux/sunrpc/xdr.h:#define      rpc_garbage_args        cpu_to_be32(RPC_GARBAGE_ARGS)
include/linux/sunrpc/xdr.h:#define      rpc_system_err          cpu_to_be32(RPC_SYSTEM_ERR)
include/linux/sunrpc/xdr.h:#define      rpc_drop_reply          cpu_to_be32(RPC_DROP_REPLY)
include/linux/sunrpc/xdr.h:#define      rpc_mismatch            cpu_to_be32(RPC_MISMATCH)
include/linux/sunrpc/xdr.h:#define      rpc_auth_error          cpu_to_be32(RPC_AUTH_ERROR)
include/linux/sunrpc/xdr.h:#define      rpc_auth_ok             cpu_to_be32(RPC_AUTH_OK)
include/linux/sunrpc/xdr.h:#define      rpc_autherr_badcred     cpu_to_be32(RPC_AUTH_BADCRED)
include/linux/sunrpc/xdr.h:#define      rpc_autherr_rejectedcred cpu_to_be32(RPC_AUTH_REJECTEDCRED)
include/linux/sunrpc/xdr.h:#define      rpc_autherr_badverf     cpu_to_be32(RPC_AUTH_BADVERF)
include/linux/sunrpc/xdr.h:#define      rpc_autherr_rejectedverf cpu_to_be32(RPC_AUTH_REJECTEDVERF)
include/linux/sunrpc/xdr.h:#define      rpc_autherr_tooweak     cpu_to_be32(RPC_AUTH_TOOWEAK)


net/sunrpc/clnt.c

2479         switch (*p) {
2480         case rpc_success:
2481                 return 0;
2482         case rpc_prog_unavail:
2483                 trace_rpc__prog_unavail(task);
2484                 error = -EPFNOSUPPORT;
2485                 goto out_err;
2486         case rpc_prog_mismatch:
2487                 trace_rpc__prog_mismatch(task);
2488                 error = -EPROTONOSUPPORT;
2489                 goto out_err;
2490         case rpc_proc_unavail:
2491                 trace_rpc__proc_unavail(task);
2492                 error = -EOPNOTSUPP;
2493                 goto out_err;
2494         case rpc_garbage_args:
2495                 trace_rpc__garbage_args(task);
2496                 break;
2497         default:
2498                 trace_rpc__unparsable(task);
2499         }

	-ss
