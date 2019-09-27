Return-Path: <SRS0=ovf2=XW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E94C4360C
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Sep 2019 06:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8751E217D7
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Sep 2019 06:39:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vr8iCUUn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfI0Gjt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Sep 2019 02:39:49 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:35591 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfI0Gjt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 Sep 2019 02:39:49 -0400
Received: by mail-io1-f49.google.com with SMTP id q10so13545679iop.2
        for <linux-cifs@vger.kernel.org>; Thu, 26 Sep 2019 23:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=YcAfvLPy/pxT4ppeidkfafwRUndj54+MRWsrMKkiHAI=;
        b=Vr8iCUUnlwhWtQOljuexwHzRvzj7QWCOOd91gmkjdqVtaCHr/x8eTnKuL8XfQ+lPzK
         C2c7y4nOGS5B1nRQlKj/iKlKI45ik80ZFP9/JckxPfrzGTCH7YKy/9UVe8CKNzFhNTwN
         sx0xQxIf9gE+YrBGRnHUNp+Sk/zLALe9VCP567OiLFkZyd436fljClHJNkx5pD1E+AxV
         v53gHouSiz0kqGoFis/KIqKr+Dx6gzG/NCbnRo4j6SfGuoCxcVT1nJKwMVewWKkd4t2+
         cgPh6FeQx+wXc22Y1cFym8Q7nwmw8qqM4UREhjWuvncaTQSOAzIjykhGOj8b8MC5Lhtq
         BIHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=YcAfvLPy/pxT4ppeidkfafwRUndj54+MRWsrMKkiHAI=;
        b=JOv9a/y7kpYThXwD45vjXEeuhrO/zrxrZ+Fe2dX2RpQiEejMQT+/COWgz4ECsRUaFB
         82CTPIg8RweHD7b6Vom+lSFg0AfMUFO49F09Qn5a63pL3xbAGT5eV7WfalLylF4QnJOE
         Rt8N4R+IzOrweVSfLjMNKvZsyJk8NnDSJyMC2Z9/Op9Us7agppXjZ3mn24ydcTPRYwVU
         zXbaIQfh+xEXv+2jBRPV1jcu96M9IPhPCX+57Vf65vFLLjOJO3zzp8F49oYMwm4QooRU
         t8RDOB/9qObddmCNUvBS5TfZEzNTuXtuw8dvtTIIIar+TMKDS4v9UdFaU2o9Bs8ui7R3
         Kykw==
X-Gm-Message-State: APjAAAXLsY7KYq2eVMZJzWiu8ROYgDzhGc9g+wTpf0n0lTI0YHI2XaCQ
        dKsuAtf1snQToPQQRfwfTUWW7m/c0nmsnqLXW3OBIQFWMBQ=
X-Google-Smtp-Source: APXvYqwSwsmHDb02MjyWRngpxmOTIbX3Yk914OYbmkp8U7NE767Y87BptXWCKJX4MRMdibF6msnHNvsAu9fRj7zzJ6s=
X-Received: by 2002:a92:d641:: with SMTP id x1mr3033237ilp.272.1569566388391;
 Thu, 26 Sep 2019 23:39:48 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 27 Sep 2019 01:39:37 -0500
Message-ID: <CAH2r5mueOCtAsWjOc3n2OgnygSMmj22uycsvfNKPAiqhx68xsg@mail.gmail.com>
Subject: Getting the SID of the user out of the PAC ...
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Is there a way to get the SID of the user out of the MS-PAC through
Samba utils (or winbind)?

This would help cifs if when we upcall as we do today to get the
kerberos ticket, we were also given the user's SID not just the ticket
to use to send to the server during session setup.



-- 
Thanks,

Steve
