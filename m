Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BABC678D7
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Jan 2023 13:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjAPNEZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Jan 2023 08:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjAPNDa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 Jan 2023 08:03:30 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA0912F0B
        for <linux-cifs@vger.kernel.org>; Mon, 16 Jan 2023 05:02:42 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id CD49D80267;
        Mon, 16 Jan 2023 13:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673874158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kk3BMglARKL6vEAu5kVzcvUIHJm39ONtDZYpuguyAiU=;
        b=mUJD0tWL37qaqWV34Ky5m2CTTyGeZYYMz0N84Hbss3/A79QHubeKd1k6TSyekZg+TzUBAy
        sEq5r99OlZMwI4qZqAAaSmvDde/rKXT1hUe/s/bNjBO1hiEJ4wcy+fSrrfhWoXTrBjtd3A
        51Fy/pVbYRsV3u84Qa3+pmgHU65zc4iQUCcH/eYWBZen7f5WeeViRJFiTv2TUHfJukD/Fh
        zy9o7ssOq+7I0p6U17DKJndD52f79PWS38+eSdPS1dzcDGpaJP7yR4embC9DdVQTmZc4CY
        DzPYVBsWRItvhHqHNbV9AZILCqYA8+WMaUZtoflHQ+daZC9a1j2Jox1CkiuzgQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     =?utf-8?Q?J=2E_Pablo_Gonz=C3=A1lez?= <disablez@disablez.com>,
        linux-cifs@vger.kernel.org
Subject: Re: [Bug report] Since 5.17 kernel, non existing files may be
 treated as remote DFS entries
In-Reply-To: <CAF2j4JFp2=J41j3d7MU-QNmHWPbfidG9V86gGagzEm-e4sDRQQ@mail.gmail.com>
References: <CAF2j4JFp2=J41j3d7MU-QNmHWPbfidG9V86gGagzEm-e4sDRQQ@mail.gmail.com>
Date:   Mon, 16 Jan 2023 10:02:33 -0300
Message-ID: <878ri2d446.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

J. Pablo Gonz=C3=A1lez <disablez@disablez.com> writes:

> We=E2=80=99re experiencing some issues when accessing some mounts in a DFS
> share, which seem to happen since kernel 5.17.
>
> After some investigation, we=E2=80=99ve pinpointed the origin to commit
> a2809d0e16963fdf3984409e47f145
> cccb0c6821
> - Original BZ for that is https://bugzilla.kernel.org/show_bug.cgi?id=3D2=
15440
> - Patch discussion is at
> https://patchwork.kernel.org/project/cifs-client/patch/YeHUxJ9zTVNrKveF@h=
imera.home/
> - Similar issues referenced in https://bugzilla.suse.com/show_bug.cgi?id=
=3D1198753

6.2-rc4 has

        c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests")

which should fix your issue.

Could you try it?  Thanks.
