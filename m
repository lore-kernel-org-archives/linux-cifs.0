Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E57BDC43334
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 16:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiFIQmd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 12:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244761AbiFIQmd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 12:42:33 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A3026C2
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 09:42:30 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 3C2E27FD43;
        Thu,  9 Jun 2022 16:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1654792948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZCKFv+1HRaHWYd3zUe0SgKPVPBzKFIyI3F81tRFRvL4=;
        b=sI4VVzZc7WQziDAU3DeihamHmdB6IvLrjLgfrIAax6wCxOZupVmm/ePoFA9RJwhtlTQcCE
        X66lKcNIco+ZtL2yMxR1SQVAOGf6c/Tc6A4VxzvLcMD7RpUCy+TKyjoQS6rSBYi9ipP/+J
        All0KmV9UFLJTbR2BrWNQi5XKThkPPUOIT8OcyJQo2MoShHkINeJaQalLU0fboy+nHpoWQ
        kvRLcqdqZZlNLhj4FdcTJLKidJ+D/Biv2o7z1xca5XmFTLxohoMWMVEkhMQatejzPniWjz
        WVaIisNCmybldkuhSMA+od2AQNCMnXUL9njm0WpwsdtpkDmULlrXrA0rn1upKw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH 0/2] Introduce dns_interval procfs setting
In-Reply-To: <20220609161615.2g7ktgxa3repbsc4@cyberdelia>
References: <20220608215444.1216-1-ematsumiya@suse.de>
 <87czfhx50m.fsf@cjr.nz> <20220609151427.nolyifmbozaoxzzk@cyberdelia>
 <87a6alx3p0.fsf@cjr.nz> <20220609153046.pbb6pazfsnaweayv@cyberdelia>
 <877d5px2ej.fsf@cjr.nz> <20220609161615.2g7ktgxa3repbsc4@cyberdelia>
Date:   Thu, 09 Jun 2022 13:42:24 -0300
Message-ID: <8735gdwzyn.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Enzo Matsumiya <ematsumiya@suse.de> writes:

> On 06/09, Paulo Alcantara wrote:
>>Enzo Matsumiya <ematsumiya@suse.de> writes:
>>
>>> Currently, key.dns_resolver uses getaddrinfo() to resolve names, which
>>> doesn't contain the TTL for the record, hence *always* returns 0 to cifs.ko.
>>> This patch is just a way to provide some flexibility to the user, in
>>> case they don't want to use the currently-always-fixed 600s.
>>
>>It is not limited to key.dns_resolver.  The user is free to choose
>>whatever program he/she wants to be upcalled for dns_resolver key.
>>
>>For instance, some distros might still be using cifs.upcall(8) that
>>actually set record TTL, thus making it impossible for the user to
>>change default via /proc/fs/cifs/dns_interval.
>
> Ah sorry, I misunderstood.
>
> But this patch isn't supposed to allow the user to change the _default_ TTL
> value, but only to give them a chance to change the TTL value *iff* the
> upcall returned 0.

That was my concern.  If we expose it to users, they would probably
expect it work at all times regardless whether the key's expire time was
set or not.

> In case the upcall returns TTL != 0, dns_resolve_server_name_to_ip()
> will use that value instead, which, again, maintains the current behaviour.

Then it would start ignoring values from /proc/fs/cifs/dns_interval and
not telling the user why.

> But yes, if desired, I can adjust the patch to completely ignore the
> TTL value from upcall and manage it by ourselves always, either by
> procfs or by mount option.

That would work, too.  BTW, I'd personally go with the mount option
version.
