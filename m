Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6555C6FD1F
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Mar 2023 16:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCNQgP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Mar 2023 12:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjCNQgB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Mar 2023 12:36:01 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A619FB5B4A
        for <linux-cifs@vger.kernel.org>; Tue, 14 Mar 2023 09:35:29 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id d36so20782945lfv.8
        for <linux-cifs@vger.kernel.org>; Tue, 14 Mar 2023 09:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678811727;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJ7j/HdIdX3B1vkN0CwdBely9s1XERZfZB+mCIsXuHk=;
        b=KdmDCpwtWdN7FwrBnTL4xvP+fSlb45HI5izNFH0YNWHO7dB//LSnEYozbSLcVMYokp
         h5+Xd8ZQmKB+VRqUY+RkIt8Qyma2P+8wfHQNxlUtx4GDddWERnxj6xk3LuOu5Trmj7KY
         0ipRzivPAqPiCaPqCNaiQh1A7PXnk/E9Dg5KUBCB5keBpB7BydUisybGerqoiHbaK48J
         IRHPlXlxbjG2/L9EI2q4aF9T+IXPN/9ebSmN74YArTxq06EzMRi7xnXA8VKRCqfwqsYi
         Gi2XSIJvIE4uTPTRqUYytt70NszE9VnQWz3h+qdk7SqtdfgXDgkBQ/d/UY9ggnuGtrQ4
         sUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678811727;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJ7j/HdIdX3B1vkN0CwdBely9s1XERZfZB+mCIsXuHk=;
        b=LfUWSMJV+zt86JOvnSIHJV/hJI6OCReCsYMXYKphEkSKQw3iTJKzcdRx1fJ6vffQYr
         phurlGcLd2jBj8U6I5tgCxhaqqvW2iXDNyLZKOFsg5EP/Ub+E/MKVMMLDEHHviI+4gGk
         9xA25HXdeJ0/JlkyV2Trc5t5tgw6lDvxK3OParEM1scAfhJPQP51pSsKC8N6ipKNjT+f
         Z+3CMOS/8IxNXURcrhx9t5gj/NydCGv4DCEi5bL/WNu7ycC10FbV/AUIvDmeWNYlpL0j
         lGbFWZ9UeJMaThTsh61i/KNnyeSRcJuoPKZy2TA0qEvAjaqp5jJHIZ2pBquAJsF2C6tA
         DgRQ==
X-Gm-Message-State: AO0yUKXnUieHKnSLJvyX+TdsiBWx0Pm/6v1PZAMqzSxcaS7MEK8GmedI
        RW5bpUrXUKzPci5ZRwyC3HSrULbbZaMSVd/p6kT6Kl2l
X-Google-Smtp-Source: AK7set+7xOpUM+08nNbkAWIMRdMsbRr0pOPebQ/JmkeTE462NITMXDivONVd1eFgL5utFEpu3HzFDV25nf7ls7VmHWA=
X-Received: by 2002:ac2:592e:0:b0:4db:1989:8d92 with SMTP id
 v14-20020ac2592e000000b004db19898d92mr972773lfi.10.1678811727100; Tue, 14 Mar
 2023 09:35:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muXQQn8gSOmTxRq2meiS22=Cx+DjMYa=Yv2oD7rL6yJag@mail.gmail.com>
In-Reply-To: <CAH2r5muXQQn8gSOmTxRq2meiS22=Cx+DjMYa=Yv2oD7rL6yJag@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 14 Mar 2023 11:35:15 -0500
Message-ID: <CAH2r5mvR__iyGuEZrwNr9Sxi758vKTz9A1AyqEAU925un7fJYA@mail.gmail.com>
Subject: Fwd: [PATCH] cifs: Fix smb2_set_path_size()
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Tue, Mar 14, 2023 at 11:34=E2=80=AFAM
Subject: [PATCH] cifs: Fix smb2_set_path_size()
To: vl@samba.org <vl@samba.org>
Cc: Volker.Lendecke@sernet.de <Volker.Lendecke@sernet.de>, Paulo
Alcantara <pc@cjr.nz>, ronnie sahlberg <ronniesahlberg@gmail.com>,
Shyam Prasad N <nspmangalore@gmail.com>


Volker,
I see your patch in the mailing list archive, but don't see it when I
search for it in email history for the mailing list.  Wanted to double
check that this version is current:

https://lore.kernel.org/all/ZA9BJaoO4TJfjh3C@sernet.de/2-0001-cifs-Fix-smb2=
_set_path_size.patch

And also wanted to see some examples of how you spotted this (because
it looks like it would help perf in a few cases)
--
Thanks,

Steve


--=20
Thanks,

Steve
