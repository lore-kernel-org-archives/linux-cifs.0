Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E17C54EBE
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Jan 2023 00:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbjAQAPD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Jan 2023 19:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbjAQAPD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 Jan 2023 19:15:03 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3758A234FA
        for <linux-cifs@vger.kernel.org>; Mon, 16 Jan 2023 16:15:02 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id z190so14056376vka.4
        for <linux-cifs@vger.kernel.org>; Mon, 16 Jan 2023 16:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=disablez.com; s=google;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S+ptlJDzIR5Coz6xxWEZWcJphawxkcBS4ECUziZDL7w=;
        b=GAJr+/tzGilSYoqzkDYavhuaMYA3gHjmfegFCE1QKnCa4MC7pb6tcCRbDO0Hyo2Q5T
         DcBk+kUErspFlQzlDsrE3yfWwtI+TryH4mwSoKnEiEmdU1ku58h31wg5n/ap+6Co4+19
         /2LnXY686gB86p/L4/0NK6I0QYLlJQGq5UP2k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S+ptlJDzIR5Coz6xxWEZWcJphawxkcBS4ECUziZDL7w=;
        b=THjNQ7BttcQX9+v1QjMz55Zfrg0KU/5ngMn8Br1ACs6K5NBXZHh5eOJX1+mytNUO5W
         7evyZC5FwXyeNT/f5xHu+YtMRPLAzDa6HDD3SlpcrzaO0tU2tssDmnSUGFZUom8o9o9B
         osAh8d7sezx0/fjr1zonOfGLQByOgBdEEMyhWAvRzpZXwysJ6FGB08JoWMsZD/tdN6+2
         4dyfYcNM1ueBuyVZNKeYTm/DsMvsUe0GePXuku3cPsR8OcZ5ZItyaCyJwYJ6Do8ZvVvQ
         xKyTXGekmZ7Dj+kprlgZAD8/uptNPh7lhXwHFl5C6snEoqbzKRnMza8gb8vJrmjQREN3
         y/tQ==
X-Gm-Message-State: AFqh2kqixW0U4xgkVP6dP7e+bdnNujiRDym7YZ+iBYYnQBOYlUcU5N/k
        jw13s3QMm2zorFcS/3cciJrjVBO0ne8/8e5hQJpWpg==
X-Google-Smtp-Source: AMrXdXveKgkbMmMhnKr/r4LdJ2vkjbDGANhAVQhq/DRr/G5tx1nNaiTLlcMpAGOF/OCZ4AN/mKM8d53sjpMhDd2Umiw=
X-Received: by 2002:ac5:ca1d:0:b0:3da:de55:ba68 with SMTP id
 c29-20020ac5ca1d000000b003dade55ba68mr132243vkm.38.1673914501306; Mon, 16 Jan
 2023 16:15:01 -0800 (PST)
MIME-Version: 1.0
References: <CAF2j4JFp2=J41j3d7MU-QNmHWPbfidG9V86gGagzEm-e4sDRQQ@mail.gmail.com>
 <878ri2d446.fsf@cjr.nz>
In-Reply-To: <878ri2d446.fsf@cjr.nz>
From:   =?UTF-8?B?Si4gUGFibG8gR29uesOhbGV6?= <disablez@disablez.com>
Date:   Tue, 17 Jan 2023 01:14:49 +0100
Message-ID: <CAF2j4JG_w4XD=LzhPHWAMjA2yRqJ6A4K+x8XZ36d2zJOuZp4KQ@mail.gmail.com>
Subject: Re: [Bug report] Since 5.17 kernel, non existing files may be treated
 as remote DFS entries
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jan 16, 2023 at 2:02 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> J. Pablo Gonz=C3=A1lez <disablez@disablez.com> writes:
>
> > We=E2=80=99re experiencing some issues when accessing some mounts in a =
DFS
> > share, which seem to happen since kernel 5.17.
> >
> > After some investigation, we=E2=80=99ve pinpointed the origin to commit
> > a2809d0e16963fdf3984409e47f145
> > cccb0c6821
> > - Original BZ for that is https://bugzilla.kernel.org/show_bug.cgi?id=
=3D215440
> > - Patch discussion is at
> > https://patchwork.kernel.org/project/cifs-client/patch/YeHUxJ9zTVNrKveF=
@himera.home/
> > - Similar issues referenced in https://bugzilla.suse.com/show_bug.cgi?i=
d=3D1198753
>
> 6.2-rc4 has
>
>         c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests")
>
> which should fix your issue.
>
> Could you try it?  Thanks.

I'll still need to test it more thoroughly, but for now, this patch
seems to have fixed all issues, including the "-o nodfs ones." Thank
you!
Any chance this could be formally backported to 6.1.x ? I see it's
only tagged for 6.2-rc for now.
