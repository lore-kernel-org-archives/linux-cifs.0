Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F64C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Nov 2021 18:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B14B9613B3
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Nov 2021 18:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhKHSVd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Nov 2021 13:21:33 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:39298 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbhKHSVd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Nov 2021 13:21:33 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DCB43218CE;
        Mon,  8 Nov 2021 18:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636395527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rfFz6UseHajVr1jsNODyJ6hcfJ1Wt17XsIc07mY8rPo=;
        b=tu5bcpWapN7+QTEeyoPXvOasOZ5cBA/BLeeNdxalYcrQ0+V7ppmH2017IZecacBMVRLR4/
        XVUrVh7OeCrlEEK5l71zpDJKThbPPqjZg1YhV3aAb7tY+y7n09kZx7/fhoo3DqsEyczp5Y
        PkvVLs3F7HQHJMi+VcFU2f+TxJZ02+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636395527;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rfFz6UseHajVr1jsNODyJ6hcfJ1Wt17XsIc07mY8rPo=;
        b=QPSOqaUR9UJE9laqFdZtiKFP8c/yC9lkqJk5TWiXLCxrOEGL3duc5Jgz8VwwVzeoxoYlGl
        MomS16q6FUxGGGCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 35DA913BCB;
        Mon,  8 Nov 2021 18:18:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0ZjiAAdqiWG1GQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 08 Nov 2021 18:18:47 +0000
Date:   Mon, 8 Nov 2021 15:18:45 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: Updated version of
 cifs-send-workstation-name-during-ntlmssp-session-setup patch
Message-ID: <20211108181845.xjpb76zwcvmxgydf@cyberdelia>
References: <CAH2r5muJyT4whZyrcn-WvMm3ESE_t_uVgkKum789-QCe5ecYfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5muJyT4whZyrcn-WvMm3ESE_t_uVgkKum789-QCe5ecYfQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 11/08, Steve French wrote:
>Shyam's ntlmssp patch, lightly updated to include review feedback, attached.
>
>Tentatively merged into cifs-2.6.git for-next

Looks good.

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers,

Enzo
