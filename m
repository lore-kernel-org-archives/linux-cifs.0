Return-Path: <SRS0=Llk7=DC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BEB9C4363D
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Sep 2020 09:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 245A420738
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Sep 2020 09:29:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LI//GL0E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgIYJ36 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Sep 2020 05:29:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:45566 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbgIYJ36 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 25 Sep 2020 05:29:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601026197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rf+ADsETQPxtUBFxemVlyzFi2DjhK4OmkHkQUxXsGn8=;
        b=LI//GL0EpbAKsJdBc6P82sHLyuO+huA60PYaNpvIaqRJ02O+XnUe8VynAMb91pqAOyjt9Y
        iOh4rCYoDgv/nQpuz5Ews7N30uVs9UCbLkNqlwR0vkxVi/c6N4lsPomz+uufaLXi/JTLvE
        8N6oTlZGH6bZIQ9gi2qPECfbfkqNxqw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9040EB190;
        Fri, 25 Sep 2020 09:29:57 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Martin Schwenke <martin@meltin.net>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] mount.cifs: ignore comment mount option
In-Reply-To: <20200925113200.371db298@martins.ozlabs.org>
References: <20200925113200.371db298@martins.ozlabs.org>
Date:   Fri, 25 Sep 2020 11:29:56 +0200
Message-ID: <87o8lujjaj.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
