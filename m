Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C236C47078
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 15:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02D786135B
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 15:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbhEUPn6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 May 2021 11:43:58 -0400
Received: from mx.cjr.nz ([51.158.111.142]:39754 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhEUPn6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 21 May 2021 11:43:58 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 00CD580BAA;
        Fri, 21 May 2021 15:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1621611753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tzSTdzMxSi8ba1vnSmPYOermBxlbegR9T0VSQb1f57k=;
        b=mC6OGjcEHH4DGPGx6A+EIlVo+nLGCg1nkmo7s/wmQjUFey7sjEZdE629IzdaspI/9uCZau
        qLxz9cirnCTx1wgS1iFHFZQ4HN4FrFFoDcNs+45+IUHbR/NLSGxKctPNb3lqATfz+pcY2x
        jVGFVVN6a7K6H2cUqSOtxcc3eyi0oSwwb4Vq12nwcMarRN8oBz+ZfTAqBI2gzv9i14a865
        3EavM6/CU9kik4P1ZAI1/ghO7ftpkAvhXX/IXkwOH47Vw6YOaYJvQ7wBAaUwBYPZmVi+pu
        pud8VW+er3pw9PehXfcqCCCxDGDCGkZlBgi96xkjEmRXAIlifyNuVCT0kpDOUg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, metze@samba.org,
        Aurelien Aptel <aaptel@suse.com>
Subject: Re: [PATCH v1 0/2] Change CIFS_FULL_KEY_DUMP ioctl to return
 variable size keys
In-Reply-To: <20210521151928.17730-1-aaptel@suse.com>
References: <20210521151928.17730-1-aaptel@suse.com>
Date:   Fri, 21 May 2021 12:42:28 -0300
Message-ID: <87tumwks9n.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> writes:

> From: Aurelien Aptel <aaptel@suse.com>
>
> This patchset changes the CIFS_FULL_KEY_DUMP ioctl to return variable
> size keys to userspace while keeping the same ioctl number.
>
> This version of the ioctl should be future proof if we ever add more
> cipher types or bigger keys.
>
> This also fixes the build error for ARM related to get_user() being
> undefined.
>
> I have tested this for AES-128 and AES-256.
>
> I have a separate patch for the smbinfo utility to make use of this
> new ioctl that I will send in a separate thread.
>
> Aurelien Aptel (2):
>   cifs: set server->cipher_type to AES-128-CCM for SMB3.0
>   cifs: change format of CIFS_FULL_KEY_DUMP ioctl
>
>  fs/cifs/cifs_ioctl.h |  25 ++++++--
>  fs/cifs/cifspdu.h    |   3 +-
>  fs/cifs/ioctl.c      | 143 +++++++++++++++++++++++++++++++------------
>  fs/cifs/smb2pdu.c    |   7 +++
>  4 files changed, 133 insertions(+), 45 deletions(-)

Looks good.

Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
