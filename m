Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83875C46467
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Nov 2022 20:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiK0Uty (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 27 Nov 2022 15:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiK0Utu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 27 Nov 2022 15:49:50 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E33DF1F
        for <linux-cifs@vger.kernel.org>; Sun, 27 Nov 2022 12:49:49 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id c2so6009000qko.1
        for <linux-cifs@vger.kernel.org>; Sun, 27 Nov 2022 12:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0EcRsn3mpfYpm/vhZ/v7NRpfbut+cY/FRel9FddrnfI=;
        b=KBcUhnkE30+t44sLhT0QIA/TKDoVVcw2IDATdES6KfLCITZM1dINmG7lHKlIAtF5Bv
         XYen05Yj2oFW9mtHJEXYSDUF20MEYEfNCJOIA7Ao4ErgCMxXzNeUrFhRHU4n0UR5efBV
         NPgtVWwXuMjsplabdQq4ltrd1s/IVTuK0fB6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0EcRsn3mpfYpm/vhZ/v7NRpfbut+cY/FRel9FddrnfI=;
        b=GbYkHrXUNTUTE5mNWH1e7oQSL1Hl1o2GftzYo5G3t24Xsuxuek0KPptov7pjqqTVSx
         l4Au0IuWam150kjENmOcBWj1L3dtSzXAmSi7kI8UjA5SK/EbD21MKoEsJcMbCYbTIi7D
         vJNH9t8ZMMOzjR5RMrq0PMyegkwpby8Qn30UwApOvLy4LuEdKeVu5+mXegCMoHNQbLqn
         1jaSc26i30Nem8pIbhl02Ns3JGC4Woyn/jngPPAyWI5Jgpavn7+9zLDsiw9FKUoX+y9n
         S+D2xo2UlHSVpjnMzKYbHyccCg6X2Y8UqP2wpu+RSs/gss/hNiFH1ioxnGcDThO0QCn+
         N+UQ==
X-Gm-Message-State: ANoB5pnVMkqBAPRKmb24cq2F6plV3CsYBPU1V4YBkCOj4+rH10BKWxAR
        8c6pfPVSQYmRCXtmkR/Iyg6K+Acmypidew==
X-Google-Smtp-Source: AA0mqf4aHXE19aFWJQdQ1y1KyNCSnDdS1Bdqdkk/GGguJltJXQZG6fs/7L7qp2LeIjs/xIbkYwSSoQ==
X-Received: by 2002:a37:92c6:0:b0:6f9:f247:8864 with SMTP id u189-20020a3792c6000000b006f9f2478864mr26143645qkd.100.1669582188283;
        Sun, 27 Nov 2022 12:49:48 -0800 (PST)
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com. [209.85.222.173])
        by smtp.gmail.com with ESMTPSA id bl3-20020a05622a244300b00399fe4aac3esm5823944qtb.50.2022.11.27.12.49.46
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Nov 2022 12:49:46 -0800 (PST)
Received: by mail-qk1-f173.google.com with SMTP id j26so5985268qki.10
        for <linux-cifs@vger.kernel.org>; Sun, 27 Nov 2022 12:49:46 -0800 (PST)
X-Received: by 2002:ae9:e00c:0:b0:6f8:1e47:8422 with SMTP id
 m12-20020ae9e00c000000b006f81e478422mr43523021qkk.72.1669582186451; Sun, 27
 Nov 2022 12:49:46 -0800 (PST)
MIME-Version: 1.0
References: <20221117205249.1886336-1-amir73il@gmail.com>
In-Reply-To: <20221117205249.1886336-1-amir73il@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 27 Nov 2022 12:49:30 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgnnhUqO8mv4=0ri=Q8xYd9dpHm+_r61CTMCkQKj9fN=w@mail.gmail.com>
Message-ID: <CAHk-=wgnnhUqO8mv4=0ri=Q8xYd9dpHm+_r61CTMCkQKj9fN=w@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: fix copy_file_range() averts filesystem freeze protection
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ok, this is finally in my tree now. Thanks,

             Linus
