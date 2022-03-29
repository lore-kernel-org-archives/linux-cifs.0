Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA7CC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Mar 2022 15:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239019AbiC2Pxo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Mar 2022 11:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238845AbiC2Pxo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Mar 2022 11:53:44 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572F215B06B
        for <linux-cifs@vger.kernel.org>; Tue, 29 Mar 2022 08:52:01 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 1BED17FC20;
        Tue, 29 Mar 2022 15:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1648569119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A9GiakZcHIhQn1h3vhw88irCEHMqeLcjIy5tn7Efjgw=;
        b=QP0CoIfzEhaNzxKAOZJgHMrJeNHmompu3eXmNCpQLBcVq88V9oYq6RmKINRjlbbEKlsHdA
        xR+DY2xB+3BAyd9BamOjkqKLeHNXgFJ0seC9El9wYmnUSLRU017eq84IYNTPZkOKEkHdcY
        y3sE6hqHUB5O93gloyhnhgzsiSE5z9brasWacoF9Sa7Ct3Os3ls1gifEk+fuurQtMiUO5m
        e7Pb20et4cn4iLVkx00rLfhHAvu5mapJ1ePzqjOtIrglhNqSk74Al9gZevO9oPEj2c7PEG
        b7iLlSAEhoW1GQACVlLAS7+L2qLfIw8H8XWrX/qu52xQ7zF8LThj1JrFQN06ZQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH] fix ksmbd bigendian bug in oplock break, and move its
 struct and a few others to smbfs_common
In-Reply-To: <CAH2r5mvDREEnghECdF3Okj6bwi1B6Dk=oM2tyxP=weYsZ7Am1g@mail.gmail.com>
References: <CAH2r5mvDREEnghECdF3Okj6bwi1B6Dk=oM2tyxP=weYsZ7Am1g@mail.gmail.com>
Date:   Tue, 29 Mar 2022 12:51:53 -0300
Message-ID: <878rsszrhi.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> Fix an endian bug in ksmbd for one remaining use of
> Persistent/VolatileFid that unnecessarily converted it (it is an
> opaque endian field that does not need to be and should not
> be converted) in oplock_break for ksmbd, and move the definitions
> for the oplock and lease break protocol requests and responses
> to fs/smbfs_common/smb2pdu.h
>
> Also move a few more definitions for various protocol requests
> that were duplicated (in fs/cifs/smb2pdu.h and fs/ksmbd/smb2pdu.h)
> into fs/smbfs_common/smb2pdu.h including:
>
> - various ioctls and reparse structures
> - validate negotiate request and response structs
> - duplicate extents structs

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
