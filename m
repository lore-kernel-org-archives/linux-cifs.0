Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3402C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Mar 2022 02:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiC2CGg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Mar 2022 22:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiC2CGg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Mar 2022 22:06:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2786557B25
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 19:04:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2A48B81218
        for <linux-cifs@vger.kernel.org>; Tue, 29 Mar 2022 02:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7614EC34110
        for <linux-cifs@vger.kernel.org>; Tue, 29 Mar 2022 02:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648519491;
        bh=oTTYfbPo8OqFN+B6VdFdWktfA4HFlEodPPjJ1kB4S84=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=AF1Ed9c1j9N1P2Dvj0fF1WwuV0USXZ+fbP6l9GkK+CxHFhIY2sKE9RGwR7KHTZNAk
         g7Crmnuyd6LUk2dSst7swVGpV7c8Ba7QZCp2c6EMiifhumu6/z6i5g420xbQU2ZakM
         kevTJOtSJvh82+Oq7bB89NcfUTGXT/HaIqWzE7zXdJKsqV9LNtHa6Yj6YrQI57pvb/
         oSB34xRMGgNVjshuUSgGlCWfUC0+jQEut2hD0Nf5xmjQX0KVuXvaBlCgopV7c67z+Q
         7ylJj4r9/A1tZdxqmA2b6nl6Jgu7XFtVhmt5AT/F+E6vWf8ETgIRtdNq59qr2UemFH
         M5x2o6Hx3Pk2A==
Received: by mail-wm1-f47.google.com with SMTP id r7so9397208wmq.2
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 19:04:51 -0700 (PDT)
X-Gm-Message-State: AOAM532jNOWSqxp6hQqII/2PHIwetIjkiTj3FJTk1DlPmSRxp3EISobx
        iYB9AuVnsroiMHbZmFipM3u5s4h581Pl3iyrdYc=
X-Google-Smtp-Source: ABdhPJwgIxq4IdCmZmHLX9/ZYIZ7O1duyDb0mzhZxS6YYMxRhDqqPZ0baTTnIFEVZNI/rF4d3reqkDJ/AKNsrfCTlGE=
X-Received: by 2002:a05:600c:214a:b0:38c:aa5d:1872 with SMTP id
 v10-20020a05600c214a00b0038caa5d1872mr3254948wml.9.1648519489667; Mon, 28 Mar
 2022 19:04:49 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:2c1:0:0:0:0 with HTTP; Mon, 28 Mar 2022 19:04:49
 -0700 (PDT)
In-Reply-To: <CAH2r5mvDREEnghECdF3Okj6bwi1B6Dk=oM2tyxP=weYsZ7Am1g@mail.gmail.com>
References: <CAH2r5mvDREEnghECdF3Okj6bwi1B6Dk=oM2tyxP=weYsZ7Am1g@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 29 Mar 2022 11:04:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_qFQRr79=AX=oF4Qi1x4+gC6wijhJzL3CG3yo1mMnUCg@mail.gmail.com>
Message-ID: <CAKYAXd_qFQRr79=AX=oF4Qi1x4+gC6wijhJzL3CG3yo1mMnUCg@mail.gmail.com>
Subject: Re: [PATCH] fix ksmbd bigendian bug in oplock break, and move its
 struct and a few others to smbfs_common
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-03-29 8:04 GMT+09:00, Steve French <smfrench@gmail.com>:
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
>
> See attachedcifs
Look good to me:)

Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
>
> --
> Thanks,
>
> Steve
>
