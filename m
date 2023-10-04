Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C75EE7C4D5
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Oct 2023 15:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243181AbjJDPoa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Oct 2023 11:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbjJDPo3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Oct 2023 11:44:29 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA5698
        for <linux-cifs@vger.kernel.org>; Wed,  4 Oct 2023 08:44:25 -0700 (PDT)
Message-ID: <9062eefc4114f9c9162a19f98a1b820c.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1696434263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n6fgb2RMvliaVSodPyJtJYH1uPbFVcaqdW9j3Vxlkec=;
        b=oEpWru7GGeILHTXTJehZt7ZBpRbRxHYtdw1S3hOnIc+msfgOtX8E8m3yjgT+wNIhSgestx
        kTcVvwKC8ovn86QuzMNV4UNA9gXtzzfp+Wbd8zqKwL7ujcQrzvsgLpMG+hF1oblVTP7YJo
        9TgwXTP8C8P2m7blpLiuFiECuwUkKYcjpOteyPclpL9nQWmjSee/zvDO/QbKxV7a7IRCTB
        u1T/vRbrT/hw2/hDK1gJb8+SG9rZGQumS1/rhfj3EcLNWXao2aqt7E/SWs2uF7suowHFjI
        fIvJV14FO1WFTOtznCEICZZwYGTUB4OlL9CIIqpvS6xvvm3nK2bZjlkkUUWVvg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1696434263; a=rsa-sha256;
        cv=none;
        b=r2t6q73eS7si+yynyGzDwlYPlWscm7oBlzB3MInbodXEDnjY5uU41VT2Gjwh9BrKVVL7F9
        Z9pc+wbbQ0awp9TgQ/mplfGHkzhqe175JCKo1NmWH+5TcMDNGf6ZVjfKPWqWh/hnRC3KnI
        +GuxQyLd0yCWmdid7T21xRxYCJcnq5h6A1vYngwQnrdFvcCa/KyRA8YjwIZzRkWSu6AzLy
        AV9ZaV/DFjteV9iMk59TxLy6GlCqa+0Jve906wObehCHSTn/Yi16gxiLi6ZiD4n3bOZki6
        FcAOdrQxMDAVHPK7BI7GcLN/hMjjcR4kPyq4UKwaD6uR7dLffkzFdfTwQNAYbA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1696434263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n6fgb2RMvliaVSodPyJtJYH1uPbFVcaqdW9j3Vxlkec=;
        b=rHYrLG642VQyHL7NbYE7JobixAQUE1ML/L6urT8Hjb6UnAK/MvaK6pA1P4+v30ctDr+akI
        w6frp+wVjxTjOzBTFhlYNvHYSU3mTazEz6sa8HQOMLVJXCtMYXqTANiWdCSoFf9DBZ0x+l
        Cn3ixqXmxxSvcjWU5kkO+IQa/Bqp/YGwugZSXDaW7WbCTjg01NV7i4ba8S1sqiq5niqGWn
        JzWyXgVxajfLIqEecdBoh05SD5+LLVMEpRdTSVzgoemx8boKxICy0WbeIC2KVkr+IPMdk8
        78GEBBk7FPFX5ouYwTPZCAR6I1TpPUUZwi9ii8ZilQVsXil4dG85TSGCsh4XYg==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Jordan Rife <jrife@google.com>, sfrench@samba.org,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc:     Jordan Rife <jrife@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] smb: use kernel_connect() and kernel_bind()
In-Reply-To: <20231004011303.979995-1-jrife@google.com>
References: <20231004011303.979995-1-jrife@google.com>
Date:   Wed, 04 Oct 2023 12:44:17 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Jordan Rife <jrife@google.com> writes:

> Recent changes to kernel_connect() and kernel_bind() ensure that
> callers are insulated from changes to the address parameter made by BPF
> SOCK_ADDR hooks. This patch wraps direct calls to ops->connect() and
> ops->bind() with kernel_connect() and kernel_bind() to ensure that SMB
> mounts do not see their mount address overwritten in such cases.
>
> Link: https://lore.kernel.org/netdev/9944248dba1bce861375fcce9de663934d933ba9.camel@redhat.com/
> Cc: <stable@vger.kernel.org> # 6.x.y
> Signed-off-by: Jordan Rife <jrife@google.com>
> ---
>  fs/smb/client/connect.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Acked-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
