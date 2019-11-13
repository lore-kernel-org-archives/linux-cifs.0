Return-Path: <SRS0=3kj9=ZF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FB1C432C3
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 22:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6948206E3
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Nov 2019 22:15:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bt/lldns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfKMWPy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Nov 2019 17:15:54 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28095 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbfKMWPy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 Nov 2019 17:15:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573683352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6jmw4dUCAd0KIxRuhxrtSeQlvzKuPrWQkOEZFVofPy0=;
        b=bt/lldnsBUevSWGhQC+7EsknL6rq4NWOsjTXwRAVYAhVFoL1jRT0L3NSd0gTyDB3Un08Js
        tQJWix01j6AJ1zcP1dRJrLvvHxAAJc8SGX57XxkSqhVK1VjDQPnePiTRBTDDeSDlaOZeN7
        /yAzp7asLLbcpvz0Ov0trky9VRFkqco=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-JgBpBIXPM--hlqE8d9Qplg-1; Wed, 13 Nov 2019 17:15:49 -0500
Received: by mail-yb1-f198.google.com with SMTP id n9so3224905ybd.5
        for <linux-cifs@vger.kernel.org>; Wed, 13 Nov 2019 14:15:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zDdlp0oUejibPVqcPILeNjroLMFyNQO2b+ipdDuldnE=;
        b=hpPctLqQnut4yuGAUY+PNYHEEK8AH1sEs7/dkBckZ8diISXIF6OAbsBrFEkswUkZ6n
         mh5RJz7AGuvWHVARylK1AtBVAhowD2JRtLeQNVLFhIp9fAkZtgHZymmoq3PwpdM904Wv
         f81J4N4Np0bZDcz7e6UZ4VPODt/MsFy9WqOEdebZeCN7r0Yef2vxd1FcDeKgimd0ELc0
         U/JSCdpcaULm2AexRc14vSoiDQ8SVUJKfk1RORWwfNAHvuRys25e3I3zU4WtLxRwYnqq
         FI5+mIP7d5TUfpqJlpUstlhcxlM4bw/nE8O7Rzowfa+Lq7O6D9BaSY+iXBspLV0iesrO
         uybA==
X-Gm-Message-State: APjAAAUPBxDy9NJd5ClEFaiZTBuxaY3C/EaEDt56x34mddWoCUA03IOe
        gLyxm7w4jT21Ny1OId6JTcNKiYM/2Gpkef4nukihvcn0VJek4Y/gIlt7VlLb5EKjb6K7scGh+5d
        Dz11xbXi0zVG+SGC6z7odaw==
X-Received: by 2002:a0d:f042:: with SMTP id z63mr3512407ywe.490.1573683348836;
        Wed, 13 Nov 2019 14:15:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqxUFw3wrcvx/c0MD1q9KlIOi1O0czmWTiSDPB9NoAPymPeY7t2099ToTedDNi/p3EvboEheAQ==
X-Received: by 2002:a0d:f042:: with SMTP id z63mr3512378ywe.490.1573683348451;
        Wed, 13 Nov 2019 14:15:48 -0800 (PST)
Received: from hut.sorensonfamily.com (198-0-247-150-static.hfc.comcastbusiness.net. [198.0.247.150])
        by smtp.gmail.com with ESMTPSA id z139sm2445351ywz.32.2019.11.13.14.15.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2019 14:15:47 -0800 (PST)
Subject: Re: A process killed while opening a file can result in leaked open
 handle on the server
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
References: <0326b8d9-d66c-1df0-2d04-91b9a861c10f@redhat.com>
 <CAKywueQ4nx2=V889Ty40QZOfoVij7Wp4dmhuhHV4A6mhGpgYAA@mail.gmail.com>
 <579288007.11441637.1573622351338.JavaMail.zimbra@redhat.com>
 <81694688.11451093.1573627786969.JavaMail.zimbra@redhat.com>
From:   Frank Sorenson <sorenson@redhat.com>
Message-ID: <9195bac2-e271-537b-e1a0-8736efc80771@redhat.com>
Date:   Wed, 13 Nov 2019 16:15:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <81694688.11451093.1573627786969.JavaMail.zimbra@redhat.com>
Content-Language: en-US
X-MC-Unique: JgBpBIXPM--hlqE8d9Qplg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 11/13/19 12:49 AM, Ronnie Sahlberg wrote:
> Steve, Pavel
>=20
> This patch goes ontop of Pavels patch.
> Maybe it should be merged with Pavels patch since his patch changes from =
"we only send a close() on an interrupted open()"
> to now "we send a close() on either interrupted open() or interrupted clo=
se()" so both comments as well as log messages are updates.
>=20
> Additionally it adds logging of the MID that failed in the case of an int=
errupted Open() so that it is easy to find it in wireshark
> and check whether that smb2 file handle was indeed handles by a SMB_Close=
() or not.
>=20
>=20
> From testing it appears Pavels patch works. When the close() is interrupt=
ed we don't leak handles as far as I can tell.
> We do have a leak in the Open() case though and it seems that eventhough =
we set things up and flags the MID to be cancelled we actually never end up
> calling smb2_cancelled_close_fid() and thus we never send a SMB2_Close().
> I haven't found the root cause yet but I suspect we mess up mid flags or =
state somewhere.
>=20
>=20
> It did work in the past though when Sachin provided the initial implement=
ation so we have regressed I think.
> I have added a new test 'cifs/102'  to the buildbot that checks for this =
but have not integrated into the cifs-testing run yet since we still fail t=
his test.
> At least we will not have further regressions once we fix this and enable=
 the test in the future.
>=20
> ronnie s

The patches do indeed improve it significantly.

I'm still seeing some leak as well, and I'm removing ratelimiting so
that I can see what the added debugging is trying to tell us.  I'll
report if I find more details.


Thanks for the help.


Frank

