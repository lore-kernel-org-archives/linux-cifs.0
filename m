Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF2FC6FD20
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Mar 2023 03:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjCXDo7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 23:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCXDo6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 23:44:58 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8DC12860
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 20:44:57 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so3889308pjt.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 20:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679629497;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K05++/GesOA6gZZMT2sIylIy0zCTHOHk9HpB77+MAnk=;
        b=eVRhwoRWiCoxcIyflmRADLuEOqLWGaW8hrSLm5k0+CBrYnlnMztpkDnpcxAF2TeS6A
         gb/OPkTEp14jpOtG3AxibZmaT8lq8yqf4yP77lguc30AQC5bDGxlOdHjLn8tTQIDIpfp
         btANKnK+h4DwU9H37MJUvdGVcLl0AMKe5wSoc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679629497;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K05++/GesOA6gZZMT2sIylIy0zCTHOHk9HpB77+MAnk=;
        b=nGcVEuQxXdupFt8K6Rs+AFsNTxN/XhUYdXQan2K5BJrMsQj7OYwSxuTW/Go+vUFm9O
         oiXSyopaVsSdBeOFhf9XSjSyUfiOObkdJgTX09KrepZPEj1JBF47OEhpj1bTtLLeIebA
         clmWvgyQlyRZP6GabG33gtt7/n3HaTW+DYswyTspSixuRrrVsplNpymeNIDpgYYfpo7c
         M9fw+lvbXsXC7BaAJg0JUNn97D6o426NHQQ3/HxhW64aqzgj6u28FFpa7e5qMgVnCBIN
         Gr8kH3zV/4Pdvd4ed/aV4WL2a2BUWDebstcd+cy7vC9MJzQVfxC2qu9hAJK5Of4dMbBm
         Y1FQ==
X-Gm-Message-State: AAQBX9e1VF8mLuTlTuU/rasWyMggAcrhBrhup1nHP98eDC6BsFfppcR5
        1GPSYagjMh1o2Ibtzh7aFsz3OQ==
X-Google-Smtp-Source: AKy350ZgNm2LgmqMWvrP90Zj1NGFDAPvdYN925plpGzfaRXlYZF2ZE9Mi5I6EStS9g75MQrrWnc/2g==
X-Received: by 2002:a17:902:e5d1:b0:19e:4bc3:b1ef with SMTP id u17-20020a170902e5d100b0019e4bc3b1efmr1270625plf.64.1679629497100;
        Thu, 23 Mar 2023 20:44:57 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902b40f00b001a1c2ee06e0sm289154plr.15.2023.03.23.20.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 20:44:56 -0700 (PDT)
Date:   Fri, 24 Mar 2023 12:44:52 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH v2] ksmbd: return unsupported error on smb1 mount
Message-ID: <20230324034452.GC3271889@google.com>
References: <20230321133312.103789-1-linkinjeon@kernel.org>
 <20230321133312.103789-3-linkinjeon@kernel.org>
 <20230323025319.GA3271889@google.com>
 <CAKYAXd-PQFcVq=b_KNq6P5imBV-Y+PQ5LBZCzH-mH7dmZAav+w@mail.gmail.com>
 <20230323050006.GB3271889@google.com>
 <CAKYAXd_GK_Tpk8cP-L-BjxenMFpBjGwrZ3E_6xHMVoLUfYNnjg@mail.gmail.com>
 <CAKYAXd-r_r3fmd=Xv92bpO4fz3T8aSC9YAsrYpF=NoXV+56k_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd-r_r3fmd=Xv92bpO4fz3T8aSC9YAsrYpF=NoXV+56k_A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/03/23 14:17), Namjae Jeon wrote:
> ksmbd disconnect connection when mounting with vers=smb1.
> ksmbd should send smb1 negotiate response to client for correct
> unsupported error return. This patch add needed SMB1 macros and fill
> NegProt part of the response for smb1 negotiate response.
> 
> Reported-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
