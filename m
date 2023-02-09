Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655B9C636D6
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Feb 2023 18:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjBISDn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Feb 2023 13:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjBISDn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Feb 2023 13:03:43 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C65643D4
        for <linux-cifs@vger.kernel.org>; Thu,  9 Feb 2023 10:03:38 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id b13so2999486ljf.8
        for <linux-cifs@vger.kernel.org>; Thu, 09 Feb 2023 10:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KlFs/0zoSWgjyvU76UyC7VIXtahmwS6cmAKflPNcPd8=;
        b=gjMe7T6EVffZUDBzTjL+ISQMNVQRGqcla/nG6gwNOj0olWqFhyRNRnL36GYWCRBdHV
         SWUmzsi1awQAyPjjQXSC/sathKbj44DEMiFDW9g/e3alafzUOTfJOl6nXyUlR7z9CEnj
         Vd+xVTdf/+ufGpC45841HERy3DFtZ2ss02ZHOwZ4FN/pFVjyKN+zcLLBCM1GVZFdX7LY
         W0soOuLNv3qMAYpbqlATN3wIUBm3VkoKW9sAbVK149vIBVm3BJg02r6ulUgbHYmCmVQi
         lcIC+WCx2YWh2F5YTtsXpldhfpemo5hLPQQs2k21fUTyFJwzItLr9LuEDm02FqwStwFH
         sgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KlFs/0zoSWgjyvU76UyC7VIXtahmwS6cmAKflPNcPd8=;
        b=WiPMd4MbYML5zKARR0gQizeJgWeatqiyNP9LdO9s+KSjko9uShUsp7imX4CrQDc0+U
         0IZpWFlbWiYCqUFPOK8vJM7gaveqX+T2DFfKStC+bjkQUpQDqrO+f+SQolj6KInC3e9j
         XyWTLAFaLDuJBWc8kZTSpS8CgJKRB9jew1QHdZ5HiQJe/AjbG4mIdIlBHogzMIE96DNk
         ALPFv04zds44KU11GmpYZPUKZ6IhnbmaoIe4KzepNBkYH1TZoN41+8edt2rCmXQn75av
         beNf/Wff9GyWnycxUDKdtWFO7wpEn9Qm0Ha805yXrrQDn4xiIXvOpI1M/O7SpIJaioAQ
         eT3Q==
X-Gm-Message-State: AO0yUKVGniFVDX3Q43HfRBErHmukTuzZ1SU8cG8ipIwhlFc+HuL+h4kC
        a+tN7W9WBoEfXI+ICKi53H0jTiTGK6Kxyx74MhUA7u+J
X-Google-Smtp-Source: AK7set98/c0ZiQ2sUr4HYvEZjUPcZlD23Mo1C9DVqx3v8sWuTgXsgnYH7mDrBWvv4MMK6uWOt61yNkV6Iqn053ULgAs=
X-Received: by 2002:a2e:141c:0:b0:293:2986:4981 with SMTP id
 u28-20020a2e141c000000b0029329864981mr1202141ljd.99.1675965816833; Thu, 09
 Feb 2023 10:03:36 -0800 (PST)
MIME-Version: 1.0
References: <Y+UrrjvGrOT6Bcmy@sernet.de>
In-Reply-To: <Y+UrrjvGrOT6Bcmy@sernet.de>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 Feb 2023 12:03:25 -0600
Message-ID: <CAH2r5mvwOO3-o+mf3ajLQDoOyJnF3-g_=m48iaB0QNUz8m9TnA@mail.gmail.com>
Subject: Re: Fix an uninitialized read in smb3_qfs_tcon()
To:     Volker.Lendecke@sernet.de
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

we also should probably go through all the places that we call
SMB2_open_init - various compounded cases and make sure that we
request leases when it makes sense (we are missing a few for directory
leases e.g.)

On Thu, Feb 9, 2023 at 11:50 AM Volker Lendecke
<Volker.Lendecke@sernet.de> wrote:
>
> Hi!
>
> Attached find a patch that fixes another case where oparms.mode is
> uninitialized. This patch fixes it with a struct assignment, relying
> on the implicit initialization of unmentioned fields. Please note that
> the assignment does not explicitly mention "reconnect" anymore,
> relying on the implicit "false" value.
>
> Is this kernel-style? Shall we just go through all of the oparms
> initializations, there are quite a few other cases that might have the
> mode uninitialized.
>
> Regards,
>
> Volker



-- 
Thanks,

Steve
