Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B87EC04A95
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Oct 2022 03:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJYD4i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Oct 2022 23:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiJYD4h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Oct 2022 23:56:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CE2DEF3
        for <linux-cifs@vger.kernel.org>; Mon, 24 Oct 2022 20:56:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B9A2DCE1ACA
        for <linux-cifs@vger.kernel.org>; Tue, 25 Oct 2022 03:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA27CC433D7;
        Tue, 25 Oct 2022 03:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666670192;
        bh=NWrJHgRgLbMaymvumlJnxyud3D+qBvCe7Tgo7vxOCTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wbr+aCpVtJcR9FQTfE5mzJyHixm/BzfrYlw9GpyH54xtHjB+CLlwvRleijXiqAEQa
         CVtMAE9MpZA0fb9LSThtOg8ZzE34/SAIAhDGN8rCsAp57RuKJwIsLRkXKO32ptsTIy
         O1ir5HpFPNXpmm+DtzlU0f24PJ0UmC39Qg8OdE2MrZNx9vQGUBIRdnc8Jk4x6JBpQk
         71ofP7w6s8v01kEK9yepClr1UF+Usa8s/2WVUQ2UYCzP01o0YXSU3Wdo94wF57b3aq
         6ihpn1He3rYC1uigpS7GdToYraLwWLg2a1DDi5U4qketVj9eg8SkbxtAyeHCtEI4bc
         Bu1oxoRHcyxxA==
Date:   Mon, 24 Oct 2022 20:56:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: new statx extensions
Message-ID: <Y1deb+K15rKghuP9@sol.localdomain>
References: <CAH2r5muLCRn1O31yCJ=pemuYBY5JpW3NhOBeRpDDE5=-jcLLpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muLCRn1O31yCJ=pemuYBY5JpW3NhOBeRpDDE5=-jcLLpQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

On Thu, Oct 20, 2022 at 10:24:22PM -0500, Steve French wrote:
> I saw this patch series relating to exposing DIO alignment information
> mentioned in lwn today
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=825cf206ed51
> 
> Do you have any ideas of whether any network filesystem could support
> this?  There are lots of features about the server filesystem and
> preferred i/o sizes etc. that can be sent over the protocol (for
> SMB3.1.1).
> 
> Looking at 6.1-rc1 - it looks like this was mainly for xfs and ext4
> but is there any reason that it would be beneficial for cifs.ko - and
> if so is there more clarification on what information would be needed
> from the server to set this value?
> 

STATX_DIOALIGN can, and should, be supported by any filesystem that supports
O_DIRECT.

Its scope is specifically direct I/O alignment restrictions.  It doesn't include
anything about the preferred I/O size.  Note that the existing field
"stx_blksize" is already documented to be the preferred I/O size.

If you have any more questions or thoughts about this, please bring them up on
linux-fsdevel@vger.kernel.org.  That's where all the STATX_DIOALIGN stuff has
been discussed.

- Eric
