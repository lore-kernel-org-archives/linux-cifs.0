Return-Path: <SRS0=wT+4=BO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9FCC433DF
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Aug 2020 17:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCE5621744
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Aug 2020 17:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="avHdCiQy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgHDRj7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Aug 2020 13:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729760AbgHDRjz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Aug 2020 13:39:55 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CB1C06174A
        for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2020 10:39:55 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id c16so23134828ils.8
        for <linux-cifs@vger.kernel.org>; Tue, 04 Aug 2020 10:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u9w6VnTdh/5ZFN/l7HycjZcL6C2zt8bGnYSAZFgkaUo=;
        b=avHdCiQyhqckD4ncwbLHeVbuBrphAdFdSXhf225SxF4NLEcbKcX33Bji3rhrGRUbJ4
         n/C5Mp8xjQvxHpMfrhgm3IKd7Cz3O5FMZ384Y7cWqgFIbmdZCqAoE67Xn6u7tZ5NlWtp
         vgzaFORu19dX2kAGrAHtBzWWAgzY81mVbchKAybCu4iwWLXfH6/juAdiuNKvRXS6bO3H
         EpdWn4IwgWu9nWJFGxczDqJcKNN3eAXwZSkK8R7DMxEZF5XOnJouWLXEsa3ZUGzOl1/x
         Wg8NzBlip85DmXfP37nkZVc0wkYPXtDFlaCwIRSd+2x1H7MsEtJkx9xpvi1XwM0sP2Bm
         vwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u9w6VnTdh/5ZFN/l7HycjZcL6C2zt8bGnYSAZFgkaUo=;
        b=E234GyzbLmLcAoV58AMmfV0r6IELQvxOStAjHKykaYBzju8htRjxvB3FjAarleFSuu
         7uXkTI1PkbAERfGP8FaWObRw6qtx1u2mTaEB4/vjoV7IK+LhxJ0ABNqKuwOIM0bPUynn
         slUleIB21vkqq7VSwsv/nPDoaXc0CTtHSp3gQUgX0mFnWprFHeDP5bi8rhtRO0/qoQ6g
         Cri/0zszW4zLm5duXQAGWnRySKDk9SFrJoBgxNkkbX0nGLX1EAFH7KsOrcEoh9cDAbIj
         dEkw+Xa+YRs9fa7GVoxc3LrahQVsGjCFUp4795UrJvu/ssELXaBoEpleoqxy3reICbmJ
         j0YA==
X-Gm-Message-State: AOAM5318kKBKBqeJvAvWCr0mgslILMtDKmnBu4HrMVQflBU7i6JEnTYH
        +17aHh/+QBeqIdl8IOXvBhe6kfgi+poWfUs4FVjrCbdP
X-Google-Smtp-Source: ABdhPJxJRdwULtXoRz2qPWri3TuNWieCA3yesGfC+FloDbpXe/lbY2lcRDWueJwyGovDTrs+szxOzURwCd2xf+VZRV4=
X-Received: by 2002:a92:890d:: with SMTP id n13mr5730347ild.5.1596562794956;
 Tue, 04 Aug 2020 10:39:54 -0700 (PDT)
MIME-Version: 1.0
References: <1119714633.44793917.1596421202774.JavaMail.zimbra@redhat.com> <506179292.44794805.1596422888744.JavaMail.zimbra@redhat.com>
In-Reply-To: <506179292.44794805.1596422888744.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 4 Aug 2020 12:39:43 -0500
Message-ID: <CAH2r5mta2ueBhd=raxXvCDAaKe27Qay+Wr42KfP-W2RrmBs8tA@mail.gmail.com>
Subject: Re: fallocate can't change the cifs disk space usage
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I was looking in a little more detail at tests 213 and 228 ... and I
see 228 passing to all servers I tried.  Did you see a problem with
that?

With 213 I see it working to Windows, and to Samba test 213 also works
but only if "strict allocate =3D yes" is set in smb.conf (I just
verified it on the buildbot)


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
