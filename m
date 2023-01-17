Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EEA4C3DA78
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Jan 2023 17:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjAQRsC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Jan 2023 12:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbjAQRqP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Jan 2023 12:46:15 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8029658641
        for <linux-cifs@vger.kernel.org>; Tue, 17 Jan 2023 09:36:23 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id D92027FC02;
        Tue, 17 Jan 2023 17:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673976966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uPyl/wgKU60YkaUUsrvxfPk3JrPxCTW9mOhgbTb9QdM=;
        b=HIWQVdoBL98eBMpCUt4PCA6taEE97lMZx68TdI0sdZBnxhtZazV/nKo8q1YQkXpZZgVGQg
        eK3OiWw5JXTkMUDG6uIG1Oa+W/j5ywX+mj8Ak5ypR/Vju53Mxmh3R/ZtZqpdfE4Aw5JRvp
        09ItpCOrdmy7mj2MDNikhXGHNMRll1Um8/28sxCdL8MtpX4BnWmpmP/4t3xwPgtvsbDT3T
        VfYHOy9i2BsvDeJAInE4100yPpx4DGZKHL1C5Q/hSC5RULiNU2G4As6Q6E/MkN/IXiPTUk
        fqKE2ZAzpQcvJe7ODf8h7XSSrWKr4pe5VqQMtcrNKASoBNFitkK9BNnqaO0Jlg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     =?utf-8?Q?J=2E_Pablo_Gonz=C3=A1lez?= <disablez@disablez.com>,
        linux-cifs@vger.kernel.org
Subject: Re: [Bug report] Since 5.17 kernel, non existing files may be
 treated as remote DFS entries
In-Reply-To: <CAF2j4JG_w4XD=LzhPHWAMjA2yRqJ6A4K+x8XZ36d2zJOuZp4KQ@mail.gmail.com>
References: <CAF2j4JFp2=J41j3d7MU-QNmHWPbfidG9V86gGagzEm-e4sDRQQ@mail.gmail.com>
 <878ri2d446.fsf@cjr.nz>
 <CAF2j4JG_w4XD=LzhPHWAMjA2yRqJ6A4K+x8XZ36d2zJOuZp4KQ@mail.gmail.com>
Date:   Tue, 17 Jan 2023 14:36:01 -0300
Message-ID: <87y1q1ukqm.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

J. Pablo Gonz=C3=A1lez <disablez@disablez.com> writes:

> On Mon, Jan 16, 2023 at 2:02 PM Paulo Alcantara <pc@cjr.nz> wrote:
>>
>> J. Pablo Gonz=C3=A1lez <disablez@disablez.com> writes:
>>
>> > We=E2=80=99re experiencing some issues when accessing some mounts in a=
 DFS
>> > share, which seem to happen since kernel 5.17.
>> >
>> > After some investigation, we=E2=80=99ve pinpointed the origin to commit
>> > a2809d0e16963fdf3984409e47f145
>> > cccb0c6821
>> > - Original BZ for that is https://bugzilla.kernel.org/show_bug.cgi?id=
=3D215440
>> > - Patch discussion is at
>> > https://patchwork.kernel.org/project/cifs-client/patch/YeHUxJ9zTVNrKve=
F@himera.home/
>> > - Similar issues referenced in https://bugzilla.suse.com/show_bug.cgi?=
id=3D1198753
>>
>> 6.2-rc4 has
>>
>>         c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests")
>>
>> which should fix your issue.
>>
>> Could you try it?  Thanks.
>
> I'll still need to test it more thoroughly, but for now, this patch
> seems to have fixed all issues, including the "-o nodfs ones." Thank
> you!

OK - thanks for quickily testing it!

> Any chance this could be formally backported to 6.1.x ? I see it's
> only tagged for 6.2-rc for now.

Absolutely.  Will take care of that.
