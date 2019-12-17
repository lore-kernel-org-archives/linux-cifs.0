Return-Path: <SRS0=5M6x=2H=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D14C43603
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Dec 2019 22:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66A3121835
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Dec 2019 22:36:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gm4AYiF4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfLQWgq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:36:46 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36658 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfLQWgq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Dec 2019 17:36:46 -0500
Received: by mail-lf1-f68.google.com with SMTP id n12so199812lfe.3
        for <linux-cifs@vger.kernel.org>; Tue, 17 Dec 2019 14:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b/cVbHK0TqEE/VHcEO5YVVYnt7ASKfWDZpZ81aU25to=;
        b=Gm4AYiF4m5ApR76Z83Xj2CQ4kXQfh2mYjNHqJCNoHt2wSVyZMfnFTysGULYq0hFtcE
         HpwNon+IwqLYepXJ66zWH4Oy54ECXM9qssCewiiKyIYaGV3iZC+H0vxCHgCU8bal99De
         zA0P1pPlmpjTO6wEXsNjVwqi+A9SEAvWtkEue4AfDg60nLfsaLlFsrvIeea5jkcAA2o/
         MgltE/xByuOWQIC+gjrSOuw6yPdZB3OUYt0pP3KLwjg0kGJvfhpE2x0bGxKNZYfr6QFj
         88TQ+HepwL2zBZsXLADN/lXGexOKi+hjH67+ffkBVf04oe6EOjSWzJR04eMuUOE2XjF4
         VQ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b/cVbHK0TqEE/VHcEO5YVVYnt7ASKfWDZpZ81aU25to=;
        b=boEOG/RMqlutqA0UfPv8TJguM8rH5iIsngegzMLOZy1KUNYGSlAofLqIormoJzJ9fE
         qbykBKJXdXiXGcjGKBzzHILcQsOF72uND530i6MvrojucEi3f9KHO66qMUar/r6V4a4m
         01F7uAbezkj72PCr7pRJrOjHr48MvqOb2jiR+ZJHvM85T12TPcaslP/sPeJ4IjsZaarA
         DZQqbRKbJS6boRnNmfggCmORL1JPl8ZH+T50ypAFbVMiklM/SpGxaS/nn6mDv3rkG5Bj
         lEMCT6WuuWoPAgKTlPl60uWkH/EvJTbQs1cop/gJTZm0V0GaCwQt7HF4p2BnczI7gY1n
         pw8g==
X-Gm-Message-State: APjAAAUjA5wklan9RhvU4ome2HmM0v4dlNG8GcI+NF75QfyjviXy/nk9
        Fs5ScW+VdF6fKtPVU4pKbYEj2d7R5hAXoA72FczZlcU=
X-Google-Smtp-Source: APXvYqx43dF6TSfhxoZVSPwYFb9xgsPB5RjRRTAubPcEG3dVa2PZpKjPAyH0qL0Q3RC6DLazdjJKRqZkMstfYbqUwvY=
X-Received: by 2002:ac2:57cc:: with SMTP id k12mr4442171lfo.36.1576622203883;
 Tue, 17 Dec 2019 14:36:43 -0800 (PST)
MIME-Version: 1.0
References: <20191014170738.21724-1-aaptel@suse.com> <CAKywueRKp_-AdguE2DNdUZFQ-_FXstMoA0Cd4iUWWOdwQGdZqw@mail.gmail.com>
In-Reply-To: <CAKywueRKp_-AdguE2DNdUZFQ-_FXstMoA0Cd4iUWWOdwQGdZqw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 17 Dec 2019 14:36:32 -0800
Message-ID: <CAKywueS86YwS7B1LRMP7oNwdacYdDquinDsQ91fFBek7-jTCSA@mail.gmail.com>
Subject: Re: [PATCH 2/2] smbinfo: rewrite in python
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Kenneth Dsouza <kdsouza@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 12 =D0=B4=D0=B5=D0=BA. 2019 =D0=B3. =D0=B2 16:33, Pavel Shilo=
vsky <piastryyy@gmail.com>:
>
...
>
> I am planning to merge this for the next after next release since it
> doesn't add new functionality but also bring some risk. So, we will
> have time to catch possible regressions here.

Tentatively merged:

https://github.com/piastry/cifs-utils/commit/b7bd342c6d4dc794dd29760d1417e8=
a87849b531

Btw, I noticed differences between the current smbinfo help output:

$ smbinfo
Usage: smbinfo [-v] [-V] <command> <file>
Try 'smbinfo -h' for more information.

and the new one:

$ ./smbinfo
usage: smbinfo [-h] [-V]
               {fileaccessinfo,filealigninfo,fileallinfo,filebasicinfo,file=
eainfo,filefsfullsizeinfo,fileinternalinfo,filemodeinfo,filepositioninfo,fi=
lestandardinfo,fsctl-getobjid,getcompression,setcompression,list-snapshots,=
quota,secdesc,keys}
               ...
smbinfo: error: the following arguments are required: subcommand


We should probably keep the output the same if possible. I personally
like the original version better because it is shorter - for more
details the user may type smbinfo -h to get the list of supported
commands. But no strong opinion here.

--
Best regards,
Pavel Shilovsky
