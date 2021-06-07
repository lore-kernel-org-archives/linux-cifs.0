Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,MAILING_LIST_MULTI,MONEY_NOHTML,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC518C47094
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Jun 2021 15:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D248761164
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Jun 2021 15:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhFGP3w (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Jun 2021 11:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhFGP3v (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Jun 2021 11:29:51 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F07AC061766
        for <linux-cifs@vger.kernel.org>; Mon,  7 Jun 2021 08:27:46 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id g12so9017378qvx.12
        for <linux-cifs@vger.kernel.org>; Mon, 07 Jun 2021 08:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oHbV3Y7l7uoNK6hbv64je8rSkWHPyCic5O4iy1tk7yk=;
        b=nLB9HdEsm20ZvKOPKS6s0B79gfNuRoQU3nqTpxyLguopVGOWNzrutVZQxt/mW9Fjwz
         GBsrHRuu3CKi5QZJf85yrW8srKqsFQmJrBrQr330H0e5MsZnUez1mm9wroa1SvkDLEgf
         pZQYgG296WEbmLGWVFQ6LBlDSmM38kkwew44Ha2+JMHQ4bBQVILqi/VnG72nVDaEeiKy
         a2b/gG4/uEC8zNsIMDi9DBR0INRsUWrASCekSn+HJtUP+19TQJpO+yop0AfHuY9/ImaS
         ACuzb8mTmlJn+6qYTvcX9NvmnnS4FbG8KImFetXd1mL4F26siVtKZVWu0JPs6UkWEDBI
         13Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oHbV3Y7l7uoNK6hbv64je8rSkWHPyCic5O4iy1tk7yk=;
        b=He9v8gR++5zpvwCR8bUAVoPUQhv+zIB6gJztF8EdhGEhKvkXezTb1CfLe9zVsgLy1U
         cIprB3iVocBC4Xk02p3+zknjq4GxChUnbsC34tQMGwGKGnEz2bNfx5orhNFbe68+SUqv
         Na3k8ZvITs13IMyBpo1WMjKHGEb4ak9qK6du3oZcWKlyl7gccgXd41npuzbfJSeP8bp6
         C86SlAnspDeGoQy2faUXEnwvI40k11NC8zaW21zuOiV3BKawpIxo9V5Er+4HkIDlbf6u
         XWPxf3u9xEBqM011JDQRlGzL8h/rCqJ2wSUkOoq7PyqXiSSyUHRbhsfenN78uvgPvWJ3
         I2dg==
X-Gm-Message-State: AOAM532I3p8Dj644aL+F4N9CIqch/87v+muU/SX+JTUTklFQYlT9YmBo
        Jg2x+yEls+sTje4jCoqwyzk=
X-Google-Smtp-Source: ABdhPJzGEUvX9HIuo47u7H+IKcN5MuykHvNEozWDnGrNDISF7OgosAgHWLLtK7OvAXjgmcG5Mb1VCw==
X-Received: by 2002:a0c:e601:: with SMTP id z1mr18702326qvm.62.1623079665670;
        Mon, 07 Jun 2021 08:27:45 -0700 (PDT)
Received: from nyarly.rlyeh.local ([179.233.244.167])
        by smtp.gmail.com with ESMTPSA id i10sm9887486qko.68.2021.06.07.08.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 08:27:45 -0700 (PDT)
Date:   Mon, 7 Jun 2021 12:27:40 -0300
From:   Thiago Rafael Becker <trbecker@gmail.com>
To:     =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org,
        samba-technical@lists.samba.org, tbecker@redhat.com,
        jshivers@redhat.com
Subject: Re: [RFC PATCH] cifs: retry lookup and readdir when EAGAIN is
 returned.
Message-ID: <YL467HEHQoTR2eEC@nyarly.rlyeh.local>
References: <YLplrk3FQiUtVoWi@nyarly.rlyeh.local>
 <87v96qrpdt.fsf@suse.com>
 <YL4lsBT8Amy4Nh87@nyarly.rlyeh.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YL4lsBT8Amy4Nh87@nyarly.rlyeh.local>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The following capture for a run of ls after running close-smbsession on
windows and clearing the caches on the linux client running the upstream
kernel.

    1   0.000000 client → server SMB2 410 Create Request File: dir;GetInfo Request FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
    2   0.004586 server → client  SMB2 274 Create Response, Error: STATUS_USER_SESSION_DELETED;GetInfo Response, Error: STATUS_INVALID_PARAMETER;Close Response, Error: STATUS_INVALID_PARAMETER
    9   0.024997 client → server SMB2 290 Negotiate Protocol Request
   10   0.033179 server → client  SMB2 566 Negotiate Protocol Response
   12   0.033578 client → server SMB2 178 Session Setup Request, NTLMSSP_NEGOTIATE
   13   0.041297 server → client  SMB2 368 Session Setup Response, Error: STATUS_MORE_PROCESSING_REQUIRED, NTLMSSP_CHALLENGE
   15   0.041792 client → server SMB2 434 Session Setup Request, NTLMSSP_AUTH, User: \user
   16   0.047307 server → client  SMB2 130 Session Setup Response
   18   0.047832 client → server SMB2 174 Tree Connect Request Tree: \\server\root
   19   0.057075 server → client  SMB2 138 Tree Connect Response
   20   0.057586 client → server SMB2 172 Tree Connect Request Tree: \\server\IPC$
   21   0.062169 server → client  SMB2 138 Tree Connect Response
   22   0.062273 client → server SMB2 410 Create Request File: dir;GetInfo Request FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
   23   0.069050 server → client  SMB2 570 Create Response File: dir;GetInfo Response;Close Response
   24   0.069943 client → server SMB2 316 Create Request File: dir;Find Request SMB2_FIND_ID_FULL_DIRECTORY_INFO Pattern: *
   25   0.079125 server → client  SMB2 3842 Create Response File: dir;Find Response SMB2_FIND_ID_FULL_DIRECTORY_INFO Pattern: *
   27   0.081926 client → server SMB2 156 Find Request File: dir SMB2_FIND_ID_FULL_DIRECTORY_INFO Pattern: *
   28   0.093209 server → client  SMB2 130 Find Response, Error: STATUS_NO_MORE_FILES SMB2_FIND_ID_FULL_DIRECTORY_INFO Pattern: *
   29   0.093743 client → server SMB2 146 Close Request File: dir
   30   0.099034 server → client  SMB2 182 Close Response
   
Similar pattern for stat.

Best,
Thiago
