Return-Path: <SRS0=mIXx=TJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF71C04AB1
	for <linux-cifs@archiver.kernel.org>; Thu,  9 May 2019 17:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E0B620850
	for <linux-cifs@archiver.kernel.org>; Thu,  9 May 2019 17:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dfLZroKH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfEIRHl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 May 2019 13:07:41 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:35363 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfEIRHk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 May 2019 13:07:40 -0400
Received: by mail-lf1-f54.google.com with SMTP id j20so2115027lfh.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 May 2019 10:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ccuUjvqwjXsoxUAdSyfJoJrgHdED3kp31agICZqVa/o=;
        b=dfLZroKHNnMXLvcIL2eHWP3ITe5bGFM86Go3jQmHm9ccVpUeAw4BO+idIC4vL0giNn
         fyS0DHMkeRraV9ZZFWTUPPLq4Yy+R/JdOP5g7jRhYxnOI35YNBzMFqsF04t5XED6LLhO
         g8VN/DmaUvb0F9xehwOY1KguCfSwnR53CgOoMPzpVrpTh7kZvOxi2dDx57tasbaP9443
         pgOnBXS0zZA1cPUR/YV5iD3uwj21zgA31659szcJ5gZJi55bY9k7J2EKRbKonXtyjAer
         R2EKGybrUIwvkHUbFoQ4B7M3weFEKbYDGjxGqHO/wW2pxmHk/5WpaInIvtPPRFqCQ88z
         FFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ccuUjvqwjXsoxUAdSyfJoJrgHdED3kp31agICZqVa/o=;
        b=BVROKT6+5AOo66U2vxuMTAogNcuGCwoCgBdn6KNqd3TOT6O5PNaeBewQT2RrheFBtm
         c3vvO/Xeo3j4hCM7dFML3JDTQRTaWpTZ5Tg4/JuIwF7LABGsaofwE96KvxTqrutVP+Gq
         JJA35FvA2/XTy5/q5+Eo9ejZVnSwJeNap2JvIX6Z8U8O9eMJBsTqv1h+srbX6EMOAgw1
         iNfjzv9JOQ/u/avTpCrk059xgQKcQCSRJTmKcMBVCx4bHwnd32vB1U6dTbywpsrV+Qz8
         kIuAtWJemxg2AYid2whZYPTGwh9BQYkWRvZ/KB811VM/+uqdhIiTRl0fq57PfFWpVLnF
         RUyg==
X-Gm-Message-State: APjAAAU6bvWJ62vyu5Yx2L5Lmye9fx+zBEQAA1bfBSHFOItDfoeqE0Ig
        AhHiohjpT+2TYIat+4GduXGCxQl1dYF94CoHVw==
X-Google-Smtp-Source: APXvYqxSrP3koZO3FLl/CO4L1KBbzZYGwKx0RTJVZuOC+y5olnkHCe7H5ooI/J5TV5g1sSFwm5avOEFRCyqR6oZ79QQ=
X-Received: by 2002:a19:385e:: with SMTP id d30mr3136877lfj.119.1557421659013;
 Thu, 09 May 2019 10:07:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtP-mPWTO0gCHraUg6m=V5WNH0u1dOnd=k4114Z8AVE6w@mail.gmail.com>
In-Reply-To: <CAH2r5mtP-mPWTO0gCHraUg6m=V5WNH0u1dOnd=k4114Z8AVE6w@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 9 May 2019 10:07:27 -0700
Message-ID: <CAKywueTkEw0n_n5naYDtyG_U_ie+xAX_MWWhgC3VgpLEvnLnpg@mail.gmail.com>
Subject: Re: [SMB3][PATCH] Display session id in /proc/fs/cifs/DebugData
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 8 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 21:37, Steve French =
<smfrench@gmail.com>:
>
> Pavel noticed that we don't display the session id in
> /proc/fs/cifs/DebugData yet it is important.  Patch to add this
> attached

Could you make it hex to align with other IDs we are printing in
DebugData or open_files?

--
Best regards,
Pavel Shilovsky
