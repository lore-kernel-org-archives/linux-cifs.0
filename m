Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E60C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jun 2022 20:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbiFFUdq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jun 2022 16:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbiFFUdf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Jun 2022 16:33:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49657A81C
        for <linux-cifs@vger.kernel.org>; Mon,  6 Jun 2022 13:33:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 83C2021AED;
        Mon,  6 Jun 2022 20:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654547612; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=blq4PBTYTKbamZMRsRUGEhqWYJmdwJQ1BHX80abupZs=;
        b=Qkzv3NxZZg2yoP8qHW5El3PL347ESECcyKnh4XMEX/yLgjZkhDxWSr7s0K5D9Z/AjGvMM8
        L7UImw2JEVB3k6oDtKb3hP1VOCaACpEthnAcE32dOwUZSfCMB24DoNrnc3WpDVMw5rCsiU
        ZhZFdWP7DyEF/iyFc6J0Z9A+byA21SM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654547612;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=blq4PBTYTKbamZMRsRUGEhqWYJmdwJQ1BHX80abupZs=;
        b=iz+eV5GeosXSK9dnTTyWQbQEVnAA7dC9F1wyezfifWk/n+pBHOHgoH9yuddxLXUZfkbOWa
        1qtpfqpwXwXVOwBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 01E5D13A5F;
        Mon,  6 Jun 2022 20:33:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uXQZLZtknmIXUAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 06 Jun 2022 20:33:31 +0000
Date:   Mon, 6 Jun 2022 17:33:29 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: return errors during session setup during
 reconnects
Message-ID: <20220606203117.hbpv3i5na5v2abdw@cyberdelia>
References: <CANT5p=p24djme0_rDzVHTJAZWEqnQRQXkXFf6hNAaLORDp-MfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CANT5p=p24djme0_rDzVHTJAZWEqnQRQXkXFf6hNAaLORDp-MfQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 06/06, Shyam Prasad N wrote:
>I think we discussed this fix in the past, but never got to actually fixing it.
>It looks like we missed this validation for when negotiate went
>through, but session setup failed. Please review this change.
>
>https://github.com/sprasad-microsoft/smb3-kernel-client/commit/c0bad5b3c5eec5c612723b404e619cac4b370bb8.patch

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>

Cheers,

Enzo
