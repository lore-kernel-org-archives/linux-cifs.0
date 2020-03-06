Return-Path: <SRS0=AX+W=4X=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32EAC10DCE
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Mar 2020 16:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A63A02072A
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Mar 2020 16:46:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="haLFqb4+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgCFQqi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 6 Mar 2020 11:46:38 -0500
Received: from hr2.samba.org ([144.76.82.148]:63678 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgCFQqi (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 6 Mar 2020 11:46:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:Cc:To:From;
        bh=joklBKTU4AJlQN18azZ/AbaYXY+TVwUDagcgxGgFm0s=; b=haLFqb4+dckuZuWquG6jAVg5Cf
        RCWhSux454d8N2BfUrKEuYukJ7IxZXm4+4vc1pIwqGvAQFOT42zhRv908tOE7sF6ez5BIIuH6w6Gw
        nx/NGyU1udEh3PennfiIuik61imoaeBB0cLqDqcyQEBhMvG19otbPAA7S8gahzOGo2PsumAP7sdBO
        4ueN9hFFq2G66Ww3W7Tb6C2ndGx323+7iVfR6E7zjauuYb/yhtvuMjAyVZDSgGV0hN8qsXXbyNBI4
        M7N87ZDqoWeT5QDg0qZkzYicP/Q9gHH1IF34jfFxhvAFmBnJxcdTDX3CVrbjFrnpJs5WE4EdkvA//
        cp0OmK0OPgWsYWg54qAx1QaULD4tpsegO5l1xl7HMOjM7Cvpu+T6jf8HqFSYFLicarZCd0Q/9Kz4a
        hTdzt/l3fLg3RHs4y0iKVaYasf/0HQ0UKV0xT+WxeGwHeBAdvfETVBJtpkAKM18qIqCkUwlElWSxA
        fCSXPxfssVxSkKvh5DnonMDD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.2:ECDHE_ECDSA_AES_256_GCM_SHA384:256)
        (Exim)
        id 1jAG7P-00086S-U0; Fri, 06 Mar 2020 16:46:35 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@samba.org>
To:     Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v1 05/13] cifs: merge __{cifs,smb2}_reconnect[_tcon]()
 into cifs_tree_connect()
In-Reply-To: <20200224131510.20608-6-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
 <20200224131510.20608-6-metze@samba.org>
Date:   Fri, 06 Mar 2020 17:46:34 +0100
Message-ID: <878skde8id.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This one LGTM but doesn't apply anymore.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
