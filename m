Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D7DCA0FE5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Sep 2023 15:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjIAPZS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjIAPZS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Sep 2023 11:25:18 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7598A94
        for <linux-cifs@vger.kernel.org>; Fri,  1 Sep 2023 08:25:14 -0700 (PDT)
Message-ID: <ca2f166ed7f54e22d07b07c4b43b98a6.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1693581912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VdcUQrzsfHMlflQASDuM4vwmjXSugC4vR+QC9/2IIiY=;
        b=RvDNhvtwfv2LdaE7K+yaZb0U5GdfYfil0MNiNHX7kdpMVMsjinXzZ+hNnqb8IQh+qB/Ygi
        A8CcCdorDWdqJ4hhZ15rejENjqNgJfamUBy0wiy2GJhQUekYtPjwK9VXGp7cGg+bVD9RM8
        nZC5Mv2DQnRcKPe0Y60SrBWd43uUrs6T+5SAPpJkTJT7F6ogc4UVtKsVT9GFIRky538oBX
        2VzjnzHoeNycMNRGX1f0D7KOPkfUD2Ktwsr1zk+j/Ecu/LootjAZ+3koJPiNXZTtWBT75V
        xXxBRldR35452AJRsCvixtAP+qS0JNBxD2AkC6tmKgv79IxwV3p6aZdPeXsp0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1693581912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VdcUQrzsfHMlflQASDuM4vwmjXSugC4vR+QC9/2IIiY=;
        b=cWUGEPY6C1YqoGJtz3elTqTOADF+wZACWf0rIUPI9No66iJ0dX1RLJutRjuhUjftCMjkX8
        FYxPnmISiSi90UBBJDyd+maeUEhX5ugnz7eLBkrGh01vX83B/MTZ26CeiIDloLtpFbh3t4
        Fvem9AnYY4OiRAKj8HD0uYJr2gECy1zeIoSlQ+TkgKsUgtPNJpenBWKVMAAS91SFkZOlzm
        LMwecV2xTUYOtZURcw1f3O50OxJUbySPLdx9SfrSHlZhjciMO6JNTK9Vg1V8clzbCaVJf7
        AyzJ6YMsd0IwJRwB1jh9PFLQnDF/bGTnSwlJ1lY8/jR1MAJRdgrfulq6Bs5O/w==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1693581912; a=rsa-sha256;
        cv=none;
        b=pTxn4+eLbM7Inamh4+PO/CQbKMLkCPp7L9VzILJVEZU7S+fII4P/mz7U+LiEiACIDiFij8
        dkObXxlYW42sY/HCzpIhhz+6STZthGzW7tsHcnYYpzk5lyCH2n/BG5fV+nnK2Z9fgQY7+Y
        dX7tiQWYNUzn4zHBJq8V6U00XlHI2lXMl4rCWVStvG5namJ5JjoLm5RMjEsyP3wIVavs+O
        mlfamIn4tg0gpbUwNbM+wHD4yvyWIcsOkmXoy7p146YoKOKhywqo9EAgKabQE84uQy+yK1
        gYyosHzRyGqvJHQG27gHvB+iydR5sVrQnglj1PQr2e0fKXKoiVE8jkZ9Z/hXvg==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        zhangxiaoxu5@huawei.com, sfrench@samba.org, smfrench@gmail.com,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com
Subject: Re: [PATCH v2 2/2] cifs: Move the in_send statistic to
 __smb_send_rqst()
In-Reply-To: <20221116031136.3967579-3-zhangxiaoxu5@huawei.com>
References: <20221116031136.3967579-1-zhangxiaoxu5@huawei.com>
 <20221116031136.3967579-3-zhangxiaoxu5@huawei.com>
Date:   Fri, 01 Sep 2023 12:25:06 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Zhang Xiaoxu <zhangxiaoxu5@huawei.com> writes:

> When send SMB_COM_NT_CANCEL and RFC1002_SESSION_REQUEST, the
> in_send statistic was lost.
>
> Let's move the in_send statistic to the send function to avoid
> this scenario.
>
> Fixes: 7ee1af765dfa ("[CIFS]")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/cifs/transport.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)

Could you please pick this up?

Thanks.
