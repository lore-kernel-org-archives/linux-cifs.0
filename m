Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51199C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Apr 2022 13:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344315AbiD1NPt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Apr 2022 09:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346509AbiD1NPs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Apr 2022 09:15:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DBDA1E3D8
        for <linux-cifs@vger.kernel.org>; Thu, 28 Apr 2022 06:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651151545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RZeU/He+6khomoWAT8bo7Pq7shtJeaFymOMgng/v7Ac=;
        b=eP5MFgGjWhox5OorwqNKWtMHzNaI2OTk4r+FW5zCd36fJpTaLA8tdzGIsT3mXx46Nz5dah
        VGR5StAJsrnlq2x+NwrawHsejSODx/5gi76V2jSPF97frMywt9Z8hMfomnYC2ZFdQmHAip
        99J5XQq0uITKjeKF4wPlGxdzPtxjUK8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-J3_3mlHVNZafp6bmVgwNdQ-1; Thu, 28 Apr 2022 09:12:23 -0400
X-MC-Unique: J3_3mlHVNZafp6bmVgwNdQ-1
Received: by mail-qk1-f200.google.com with SMTP id o79-20020a374152000000b0069ee7515f53so3156810qka.14
        for <linux-cifs@vger.kernel.org>; Thu, 28 Apr 2022 06:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=RZeU/He+6khomoWAT8bo7Pq7shtJeaFymOMgng/v7Ac=;
        b=nShpxgPUsB1NLeMK5aTz18oCu2FN2s5TX4xry9E7jMe4OGQsGga+Dg6zHy+C76OkDi
         Zzb0T341x4+Je9VgjGZZC+2OOxYjmmCDaSaj8HavIunjCvxz850Ozw6AJDi8K/63KKWg
         OqcTMaCHBbDQD/j+hpJPBMl8r7QED8Qf8kdHmnJMbNyOUenBWkI6n+9iUzjR/fV+pUrv
         unEDkx0stntDscTkdUCeW9+uoNCPoJhUKuy2XVxwpiHLu1gchTPcEdH/qXAqPq2qX8L5
         K0ar+7RJhdQHn4lEHCCIGwEay7+PMHZt4thUcXWSRYJpJdjZxzTFRa6TS8VrHZvhb1UE
         n+Yw==
X-Gm-Message-State: AOAM533Ub+wJ9lidMO8VQYvA248sdn14Uti0Jo7gMYcsEusmRHKeu8/H
        niidZWiMH+VbNJwV6VQtd84MoaF5yGfNijtAP0hzqDJU6dWSr5HKg2cfvHghzmovGqcTQndtExh
        aXK1452+/ZJtcHhuHQdUotA==
X-Received: by 2002:a37:9f14:0:b0:69f:9b05:cc81 with SMTP id i20-20020a379f14000000b0069f9b05cc81mr3834552qke.697.1651151543184;
        Thu, 28 Apr 2022 06:12:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwclu7EAK2/mxyXFVpKaxBff3R40ELe9mhnqEe6rK0Ij+NdFcfcxKZjuAeW0OVNqLZCq92GlQ==
X-Received: by 2002:a37:9f14:0:b0:69f:9b05:cc81 with SMTP id i20-20020a379f14000000b0069f9b05cc81mr3834518qke.697.1651151542901;
        Thu, 28 Apr 2022 06:12:22 -0700 (PDT)
Received: from m8.users.ipa.redhat.com (cpe-158-222-141-151.nyc.res.rr.com. [158.222.141.151])
        by smtp.gmail.com with ESMTPSA id o21-20020a05620a0d5500b0069c59fae1a5sm9282786qkl.96.2022.04.28.06.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:12:22 -0700 (PDT)
Message-ID: <089628513e1cadc0d711874d9ed2e70bb689e3f1.camel@redhat.com>
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
From:   Simo Sorce <simo@redhat.com>
To:     Boris Pismenny <borispismenny@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>
Cc:     ak@tempesta-tech.com, linux-fsdevel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 28 Apr 2022 09:12:20 -0400
In-Reply-To: <068945db-f29e-8586-0487-bb5be68c7ba8@gmail.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
         <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
         <068945db-f29e-8586-0487-bb5be68c7ba8@gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-3.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 2022-04-28 at 11:49 +0300, Boris Pismenny wrote:
> On 18/04/2022 19:49, Chuck Lever wrote:
> > In-kernel TLS consumers need a way to perform a TLS handshake. In
> > the absence of a handshake implementation in the kernel itself, a
> > mechanism to perform the handshake in user space, using an existing
> > TLS handshake library, is necessary.
> > 
> > I've designed a way to pass a connected kernel socket endpoint to
> > user space using the traditional listen/accept mechanism. accept(2)
> > gives us a well-understood way to materialize a socket endpoint as a
> > normal file descriptor in a specific user space process. Like any
> > open socket descriptor, the accepted FD can then be passed to a
> > library such as openSSL to perform a TLS handshake.
> > 
> > This prototype currently handles only initiating client-side TLS
> > handshakes. Server-side handshakes and key renegotiation are left
> > to do.
> > 
> > Security Considerations
> > ~~~~~~~~ ~~~~~~~~~~~~~~
> > 
> > This prototype is net-namespace aware.
> > 
> > The kernel has no mechanism to attest that the listening user space
> > agent is trustworthy.
> > 
> > Currently the prototype does not handle multiple listeners that
> > overlap -- multiple listeners in the same net namespace that have
> > overlapping bind addresses.
> > 
> 
> Thanks for posting this. As we discussed offline, I think this approach
> is more manageable compared to a full in-kernel TLS handshake. A while
> ago, I've hacked around TLS to implement the data-path for NVMe-TLS and
> the data-path is indeed very simple provided an infrastructure such as
> this one.
> 
> Making this more generic is desirable, and this obviously requires
> supporting multiple listeners for multiple protocols (TLS, DTLS, QUIC,
> PSP, etc.), which suggests that it will reside somewhere outside of net/tls.
> Moreover, there is a need to support (TLS) control messages here too.
> These will occasionally require going back to the userspace daemon
> during kernel packet processing. A few examples are handling: TLS rekey,
> TLS close_notify, and TLS keepalives. I'm not saying that we need to
> support everything from day-1, but there needs to be a way to support these.
> 
> A related kernel interface is the XFRM netlink where the kernel asks a
> userspace daemon to perform an IKE handshake for establishing IPsec SAs.
> This works well when the handshake runs on a different socket, perhaps
> that interface can be extended to do handshakes on a given socket that
> lives in the kernel without actually passing the fd to userespace. If we
> avoid instantiating a full socket fd in userspace, then the need for an
> accept(2) interface is reduced, right?

JFYI:
For in kernel NFSD hadnshakes we also use the gssproxy unix socket in
the kernel, which allows GSSAPI handshakes to be relayed from the
kernel to a user space listening daemon.

The infrastructure is technically already available and could be
reasonably simply extended to do TLS negotiations as well.

Not saying it is the best interface, but it is already available, and
already used by NFS code.

Simo.

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




