Return-Path: <SRS0=CZtn=BN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB13C433DF
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 04:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 121A320719
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Aug 2020 04:42:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dIqPniJP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgHCEmo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Aug 2020 00:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgHCEmo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Aug 2020 00:42:44 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6648C06174A
        for <linux-cifs@vger.kernel.org>; Sun,  2 Aug 2020 21:42:43 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p16so19262714ile.0
        for <linux-cifs@vger.kernel.org>; Sun, 02 Aug 2020 21:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N38Pn4J9CycWsZX1TeoF5FHH9FlQEReI7jzAoV0JqIo=;
        b=dIqPniJP917TGPKfZ1qlS6vs3HGb9Y2VUdDLLGDrvIDCEK79neHCkquOjOm74VC8uk
         WitV9jSF0wqQWY4hbf8zEBOWOF4GJPXK87xiyNxT65Vr1WaYDBMBbRroYt0KRF9dheal
         d+H5ctGvlLsopltXb2Vx6dVyQD4c2I8K1oU06K5/B8zChMUhxTFKDI6A+CPxfcZBCLSa
         4fLjs0DJ4EM2X/gcrZ8xRqJtsszir0Wtq27PmZjdwL6OWSywkv8G+MltPKc0/gW5DNdV
         OMMyHMtg8ii8TX5vhTvJEmGP8shOJBUo7hFUzsUrBh1m90DcNLhw2CiBO513lpG/0+te
         PKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N38Pn4J9CycWsZX1TeoF5FHH9FlQEReI7jzAoV0JqIo=;
        b=P+PZ/xEUQ9km2AUFLBXxolBvYJO6fo+zCcALZMabsFSRGlkgXqV1Vp94huCfB4KYqA
         5XxaRDz0kc3s5e3xTZR+I+9oCG/kI7kh1oZ8wt2CGmKKHtpiZqNAWN8jtwsOLfz6mEY9
         tfov6o7+QguTu9biuiCmvd2lvbT5I1Mqh8SuqnA30uyYCpTHEWwZI8We6/dS7B3jfukc
         2R5KQSN26uBVQGsvtAIFi7QS+of5SVfUPDTKyxVJJ5XXAQ8K5TCSCaGPoNV5jr/kULqp
         j55s5bX/tXzcxVEogVj+JMZs0N7Wkp52ncyCF5bczORixvRxjR6hzlPTZjWkBgjRDB3M
         zY4w==
X-Gm-Message-State: AOAM531LddIRUBujukqP/V4qQ19WOq+5laAHjHPfJXJt5+hA8w7wFj6J
        O9k4yg28HMaUBcWEdzp1opGANmwkw4447JlSoYGbmLXp
X-Google-Smtp-Source: ABdhPJzGNLIXjeBm9kSSqwNRuM7XGVPZrw5G0x3bnsovTPZtAggJ4+j9dIbtwgX1/jkJ19OxfbEZz4pnWm1RF9DVcjQ=
X-Received: by 2002:a92:890d:: with SMTP id n13mr14718511ild.5.1596429762740;
 Sun, 02 Aug 2020 21:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <1119714633.44793917.1596421202774.JavaMail.zimbra@redhat.com> <506179292.44794805.1596422888744.JavaMail.zimbra@redhat.com>
In-Reply-To: <506179292.44794805.1596422888744.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 2 Aug 2020 23:42:32 -0500
Message-ID: <CAH2r5muWV2P75oHToSR4_LaVWETXC1Y0LbpEWfD-rF00jfFMFg@mail.gmail.com>
Subject: Re: fallocate can't change the cifs disk space usage
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Any luck trying the same thing to Windows and/or Azure to see if this
is possible Samba bug - sounds like possible Samba server bug but need
more information.

Are you using one of the Samba plug in VFS modules on the server (like
vfs_btrfs)?

What does the filesystem show (before and after) on the server side
(local file system not just the remote view that Samba is returning
for statfs) when you try the df -h?

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
