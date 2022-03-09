Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D098BC433FE
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Mar 2022 18:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbiCISkP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Mar 2022 13:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbiCISkO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Mar 2022 13:40:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF688B7D8
        for <linux-cifs@vger.kernel.org>; Wed,  9 Mar 2022 10:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646851151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TU5GSQcUsGsLm0QedmIo4Msii85jhaXsQwdtUQuJMSQ=;
        b=VZZiYWZf9hLa/81sh3aCS22+YFCVU6+XIUExDiFMVr9S1cE0THWv/F22FloPEvwU2Uof1Y
        lLdbzIHIUrxMFuoOz8Pf4bTCzw3DmSQcWsLgLMUQvANrsZyrYmTFy9MToRJPuXBOWMZqJ4
        EPf2eTxGwIXTcSxlUY/tVxn1otxIkwI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-L7T76UizPTSUn1Q9VckvUw-1; Wed, 09 Mar 2022 13:39:10 -0500
X-MC-Unique: L7T76UizPTSUn1Q9VckvUw-1
Received: by mail-qk1-f198.google.com with SMTP id m123-20020a375881000000b0067af33d4ac1so2212751qkb.4
        for <linux-cifs@vger.kernel.org>; Wed, 09 Mar 2022 10:39:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=TU5GSQcUsGsLm0QedmIo4Msii85jhaXsQwdtUQuJMSQ=;
        b=DVBPWC0JXO43DHFC7gueBBZd0OL5DjfvN82ILF6kGv913BqgJm1WiqTXJJvZLB1Ih4
         HgPm6y6fWLZxQwTBobD+sDN+eRb1jel3+U4DZeserqfVuO7WYeOavTmT6bUvar6mJufz
         svzRhrqSMAj7pF4JpUTI8D8M/o59SiXTMEic82dM/19bf+cE2PEF6zvIZRpdcly02Ynh
         n94xC+vHeyw2qBwZX2heUPEGr8dD4zYAyOkT6bLqmfw0gyxD9JJWB0phynII3NJemA7s
         LjK61x/KCz7A9Ta1pl/ILPcqvRoT2kVhLftGmkqvewjDd9ocKnDNVbijL5dDZ+PB7aQr
         x6ig==
X-Gm-Message-State: AOAM530u9GKhX8aI44NHwrW8fkBgPih+uajdsr92Tas5DKBsMY3pKUzW
        QybqQVgo2ShDLJh72SeM7dGSbwgGwr7Sd/IvBWqv0IbXulxrXq6RyAuduxAxJsSOOmqCY1agIoT
        9UtfFihN5/SFqu6P3rAfqVg==
X-Received: by 2002:a05:6214:d44:b0:435:b8fd:b1d7 with SMTP id 4-20020a0562140d4400b00435b8fdb1d7mr808163qvr.19.1646851150315;
        Wed, 09 Mar 2022 10:39:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzICtIC42Xa9GHFyHP+MaqIARsvCbO2mnHxe/nMuAl463CulcS9BHk/JL6v+PefmyNOF/kr8A==
X-Received: by 2002:a05:6214:d44:b0:435:b8fd:b1d7 with SMTP id 4-20020a0562140d4400b00435b8fdb1d7mr808157qvr.19.1646851150152;
        Wed, 09 Mar 2022 10:39:10 -0800 (PST)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id t7-20020a05622a180700b002e0ccf0aa49sm1829549qtc.62.2022.03.09.10.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 10:39:09 -0800 (PST)
Message-ID: <737c8db7461567ec04d5e2a7dbec58b699f8f16c.camel@redhat.com>
Subject: Re: [PATCH v2 02/19] netfs: Generate enums from trace symbol
 mapping lists
From:   Jeff Layton <jlayton@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        David Wysochanski <dwysocha@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 09 Mar 2022 13:39:08 -0500
In-Reply-To: <1712592.1646840957@warthog.procyon.org.uk>
References: <c2f4b3dc107b106e04c48f54945a12715cccfdf3.camel@redhat.com>
         <164678185692.1200972.597611902374126174.stgit@warthog.procyon.org.uk>
         <164678192454.1200972.4428834328108580460.stgit@warthog.procyon.org.uk>
         <1712592.1646840957@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 2022-03-09 at 15:49 +0000, David Howells wrote:
> Jeff Layton <jlayton@redhat.com> wrote:
> 
> > Should you undef EM and E_ here after creating these?
> 
> Maybe.  So far it hasn't mattered...
> 

I wasn't suggesting there was a bug there, more just a code hygiene
thing. With macro names as generic as that (especially), it'd probably
be good to undef them once you're done.
-- 
Jeff Layton <jlayton@redhat.com>

