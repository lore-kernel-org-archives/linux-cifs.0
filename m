Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBC0C7EE2F
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Mar 2023 18:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjCBSAT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Mar 2023 13:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCBSAS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Mar 2023 13:00:18 -0500
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E13D34F52
        for <linux-cifs@vger.kernel.org>; Thu,  2 Mar 2023 10:00:17 -0800 (PST)
Message-Id: <5c24171d8c7fa2891e5521969f8bc27f.pc.caranguejo@mail.manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677780015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tWFXf3B8XjUu3LAXUKcrCU/eHPb+KPFdnDVNTuTa4fQ=;
        b=Y+6Vhrzo5vGWd4wEWCshArlq2Fgxfz+0K9+1NgGdIiIQRoq0gLJX2E8ZDQl/i8ZUUXvPak
        zopn1dy+/Z3i49GoS/cBsocnlNAxAH0kEpUAWtTB+Ilu8pUTBDnareYpxlDV4IEFYBtUeK
        ltEjuCQQfsNHdw/wwBx0Bw2cDq3sXA9AddPqS1T5b9I3MvfnEruqH9D44UfA3Gtp/+rS9n
        nwAHQdw5It4RAsZGzSzlRyDP2yvSn7DBG3ngwUwFiDikuAc8YjE0GPf/e1sdtXqsiwYQWW
        GuIvTkgcM4+SF6mjv5DIhWzwSvOPhTn829iXr1G5Gs7Pg0fv2oCwNYY2OKeMeg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1677780015; a=rsa-sha256;
        cv=none;
        b=jA8gu2FTK/IjmupKiAirqIiGqLW3mObAY4WaQM/2wJ6WBFwlOAe5oYtHj5H8AMo2t+0KNd
        76SYjawBDHgxKIRXP58VyCkYeA26O2fQADdIy5FSCpjLbQFwPhMtowjJeWyxDairRC4igC
        tzfT4Pa+LH6i1q5mG/a9C+1DC8cCph9nBf3BfDJ0jOa58kQKNAVKdUuD2l+BV6Tr3r5ww1
        v7N/9tYkAV/OqEjsc6yIXCIHw7JWywbjs525sFKNVjPofISuViBuPpLW8+Bt4PI4cpDhTC
        uYCojOVlksIbbCSNep9YK1w3fOSpsdP7aHdA5cox31OLcZ2DK+xUq5c/emwPCg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1677780015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tWFXf3B8XjUu3LAXUKcrCU/eHPb+KPFdnDVNTuTa4fQ=;
        b=D3tZqvFBMxGZsLrRbmC9AVQNxaFFXUDluyXOlZadquBMhwuG/IoeXfgZAJ9tNjFrtMNmMs
        empG59h1B52r2KDbwiyvbdC1ZAG10J41XpfW38S0Rhi5ElT9XS1+VxEYr/yzgDnNk1nOAW
        sD1svfcD0f8uQe98T7swc1p8KUOLVvs1L7xOv5RFUogCzYQJOEadqMq770Pn4PrNEALnrE
        YD0aHd+aS8v+5g7kxTIi2h5M1ZoKskDSvQ7jRv7oFAvwQk5/ePkQUECkM8gh2OaA5yTGZv
        4N19TRStlpY8rJZm5oElv3tSx8Xk9yKiT8U2fGaIzhjRVFoM3Qi4jVWBciLlfA==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Andrew Walker <awalker@ixsystems.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: Nested NTFS volumes within Windows SMB share may result in
 inode collisions in linux client
In-Reply-To: <CAB5c7xrdKSO4YE_vUQ6tg+p=WwxEdquj+VrRpwKxi8Jd0vPyAQ@mail.gmail.com>
References: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
 <514a3d90d263bd8422e9d13bd4c6e269.pc@manguebit.com>
 <CAB5c7xrdKSO4YE_vUQ6tg+p=WwxEdquj+VrRpwKxi8Jd0vPyAQ@mail.gmail.com>
Date:   Thu, 02 Mar 2023 15:00:09 -0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Andrew Walker <awalker@ixsystems.com> writes:

> On Wed, Mar 1, 2023 at 5:37=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>> Did it work with older kernels?
> I only tested with 5.15 kernel. Was there a different algorithm in
> older kernels that's worth testing?

Not that I know of.  Probably not worth testing anything older than
that.

>> Perhaps we could conditionally stop trusting file ids sent by the server
>> as we currently do for hardlinks when we see these reparse points as
>> well.
>
> Maybe fail chdir with EXDEV unless mount is with noserverino?

That could be done, yes.

I'll try to follow your steps to get something set up on my Windows
server and see how both behave.  That will be useful for buildbot
testing as well.

Thanks for all the info.
