Return-Path: <SRS0=CZtn=BN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBC3C433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 15:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08FF620825
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 15:59:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VouzNYDT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgHCP7r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Aug 2020 11:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgHCP7r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Aug 2020 11:59:47 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F06AC06174A
        for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2020 08:59:47 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id z3so21305326ilh.3
        for <linux-cifs@vger.kernel.org>; Mon, 03 Aug 2020 08:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wi3h8O0dH6bSSmaXYkQ7INJCJCStX2v8Ef0p6Q7rMFw=;
        b=VouzNYDTxotjvmsS07W71+Tq1ix6bQyDry1RA8tdtmjFRpwct9aY+UUPFjYBCwOfsD
         AZPCPHXFLDk8amtysy6lJUiAq/4eSLGqrjlHG3EQnXC+rJlVf/pPFR5NZUDMOs8FWG4/
         pvjf5qL+BIrQLn21SqsehUFUUSmBhq43RoCesuQ9V9VwCLL94pR6pKrfzksfLMAk8A8y
         ZBnhu3RgSGbPZMs6PlsKbgMj5hUWsPR5ve8PNir0Vqvkqd2wFjbN1FEfcmudJGRViH1e
         hLbCv6AWGPmGq0UTqif6QNqAr7xNRDYVA97QdMRC5uECP6PhkujzNxfbkJyhZdlDPzdL
         5jVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wi3h8O0dH6bSSmaXYkQ7INJCJCStX2v8Ef0p6Q7rMFw=;
        b=QgBNlBYxOEyilLYIYOQaJ3QxQ10lnOGQhMTMlPQin575rKJOfpCCaBFdZZpdpRd8mt
         qeBvcUMtS5JXtDEHnVJ+V3xEz+b3WP7VAmk1RZ2t2B+hF3OdK8auTchBeMCQrk9HFY00
         tCEUkpWtoLtkC2FmFAhW0rspIjZzYi1qJSWnRs4+NQTdI/Hs+34TF03Api9eotqsT8wy
         amywQh3bRMvME7m1JdwnCfjIhanivOo7KnCmEPW7U0i1sOvDgVeFbE6iDxm69PXdMy4v
         CRlKoFYYDL55yLCLF7bHwrYEok8ItavHYBJTAuQCXOBah1mY22tYjlSKCMmk7w1Mvn0k
         r4mA==
X-Gm-Message-State: AOAM532TnLuXA9e9UDhZ1uUoUOy/xrX8JFoSpvoZFpnjGMXXbByh5/Bd
        6XIryLsTzqi3w9h7rjPz2reLVTPrRE3gTE4m6Dw=
X-Google-Smtp-Source: ABdhPJx7IpKjwkGRYII7Y0ajChU5KHQwWsdUrusH81/0tCjGR2hWVhLX5z3xK0PgT0KPkCNo+iG4+O5CrdZEiEHVd1M=
X-Received: by 2002:a92:6e05:: with SMTP id j5mr5762ilc.169.1596470386602;
 Mon, 03 Aug 2020 08:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <1119714633.44793917.1596421202774.JavaMail.zimbra@redhat.com> <506179292.44794805.1596422888744.JavaMail.zimbra@redhat.com>
In-Reply-To: <506179292.44794805.1596422888744.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 3 Aug 2020 10:59:35 -0500
Message-ID: <CAH2r5muKciTKUjMa6o62J28Tvq=qaQryOGvfC8NRWkV29yiDaQ@mail.gmail.com>
Subject: Re: fallocate can't change the cifs disk space usage
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

So locally on xfs this works, but Samba when receiving the request
remotely apparently isn't doing the fallocate.  Would be curious if
this works with vfs_btrfs and btrfs filesystem on the share - or a
Samba server bug.

On Sun, Aug 2, 2020 at 9:55 PM Xiaoli Feng <xifeng@redhat.com> wrote:
>
> Hello all,
>
> Recently when I'm investigating the xfstests generic/213 generic/228 fail=
ures for cifs.
> Found that fallocate can't change the cifs disk space usage. Comparing xf=
s fileystem,
> fallocate can update space usage.
>
> My tests is in 5.8.0-rc7+. I also file a bug for this issue.
>   https://bugzilla.kernel.org/show_bug.cgi?id=3D208775
>
> # cat /etc/samba/smb.conf
> [cifs]
> path=3D/mnt/cifs
> writeable=3Dyes
> # mount //localhost/cifs cifs -o user=3Droot,password=3Dredhat,cache=3Dno=
ne,actimeo=3D0
> # df -h cifs
> Filesystem        Size  Used Avail Use% Mounted on
> //localhost/cifs   36G   23G   13G  66% /root/cifs
> #  fallocate -o 0 -l 2g /root/cifs/file1
> # df -h cifs
> Filesystem        Size  Used Avail Use% Mounted on
> //localhost/cifs   36G   23G   13G  66% /root/cifs
> ]# ls -l cifs
> total 1
> -rwxr-xr-x. 1 root root 2147483648 Aug  2 21:57 file1
>
> Thanks.
>
> --
> Best regards!
> XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
>


--=20
Thanks,

Steve
