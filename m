Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33614C433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 11:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiCALV5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Mar 2022 06:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbiCALV5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Mar 2022 06:21:57 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995C292D05
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 03:21:16 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id o23so14143954pgk.13
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 03:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AW2HyKKq52ANm9/IbqVIZWpzOE6vlTaVyxlfFqOV7kI=;
        b=OTII2P5p1DULKc6JplSWWPv3tDxpnYggH9Vod20mzDbGQsSw1SeGIu9p4T9dbaScKP
         DbUDy6QGfBnelnyzAgFVL0CJsEpCSMg6gfoO/Q8SzcknrS5AFLjmZadoa4FpmfzgiUAY
         veB8EemEQDQE0cMAsNc6sT+HsiJQS6pYJtGAw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AW2HyKKq52ANm9/IbqVIZWpzOE6vlTaVyxlfFqOV7kI=;
        b=ITY0YJ9rwjDVlUSWvzfwcKpuyahouH6fCFl4dZPETg87qC3vhY7r71GwydV0jCP1sa
         3fZNzZwDbnMEY5YEQ0TaqohiIrxTCkDmX6+HAY621ov7DOEhSOzFjJJrVMthyd4k/vra
         uqjmZcBdNN+60dvexKMCvBwHJoi2z/fkpp3pijTD1jfvX1rVVxF/e1cqaYKAF2UOS9/C
         k9SCjyDSMNKutY08r0MLvEcss7ZR0TLSja6jd54JeNk6Gck5qgh5IRexbTW9igzd2+8S
         rCqSX/obPeIst0yz7L23fdHfXwgbv4ojWulfJa0YAutL2f0L9bkR+GJ2eRtFwlG1EIg9
         mo4w==
X-Gm-Message-State: AOAM531SQFBT5vyg/feJFqCRYkvWKpZMr8SFhwFm0w2GsnZt6lBDGfDX
        hlOqx5jp7F+FyAuMcCRdLCbejA==
X-Google-Smtp-Source: ABdhPJw1ziPYnQQaOvZdIR2Lk8aWNVg0etiClrtnFTb84eRo6Xs07MNUEs0IQ3PcRoqJLP7f+D09Ew==
X-Received: by 2002:a63:1665:0:b0:378:ba21:ddb9 with SMTP id 37-20020a631665000000b00378ba21ddb9mr6666942pgw.268.1646133676073;
        Tue, 01 Mar 2022 03:21:16 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:58fe:72a2:6388:dcd2])
        by smtp.gmail.com with ESMTPSA id j13-20020a63594d000000b003639cf2f9c7sm12767123pgm.71.2022.03.01.03.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:21:15 -0800 (PST)
Date:   Tue, 1 Mar 2022 20:21:11 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        smfrench@gmail.com, hyc.lee@gmail.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/4] ksmbd: remove filename in ksmbd_file
Message-ID: <Yh4Bp6myHdG0tpoQ@google.com>
References: <20220228234833.10434-1-linkinjeon@kernel.org>
 <20220228234833.10434-2-linkinjeon@kernel.org>
 <Yh2dqrb6SrOlWL9t@google.com>
 <CAKYAXd-XKnNH264M+K91ecUXp7vKsPfxteBv98Ot8455dGQYPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd-XKnNH264M+K91ecUXp7vKsPfxteBv98Ot8455dGQYPw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (22/03/01 17:34), Namjae Jeon wrote:
> 2022-03-01 13:14 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> > On (22/03/01 08:48), Namjae Jeon wrote:
> >
> > convert_to_nt_pathname() can return NULL
> I can not find where this function return NULL..

Oh... Yes, you are right.

> Initializing NULL for nt_pathname is unnecessary.

Right.
