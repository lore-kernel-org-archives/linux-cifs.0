Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402A7C48BEA
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Aug 2022 17:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344022AbiHWRLx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 13:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344980AbiHWRLa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 13:11:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15C914C1C9
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 06:38:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6DA921FA73;
        Tue, 23 Aug 2022 13:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661261921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hDaQsBTUWEkkehsddUTs6KnXw/aHNGcJbqwIl/FuaWQ=;
        b=lL+XcKG+IUsyKRcvVHEqRHUbiODHzANsCfqSVaa21TfXzpzk1tIAbGxQzrCM6fjVwzTIWG
        xpeLivFI+7X70kjSlVGvaBiWBAHhkl9ctkbsrNfolaOsuQEVoL4S9EvbxEgai9jbDVOlPP
        mj2JCydRFDNUOZnLOmuNqKYCefsm2D4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661261921;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hDaQsBTUWEkkehsddUTs6KnXw/aHNGcJbqwIl/FuaWQ=;
        b=IOJY6z0GIW5ue3P9z7omq9PGruESnRGkFXfA42roq5H2ix17xBAzLjrEvfgWSkiWCoYeaM
        wsBnbBo9D4ernDAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E3FE913A89;
        Tue, 23 Aug 2022 13:38:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id O1BnKWDYBGNLaQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 23 Aug 2022 13:38:40 +0000
Date:   Tue, 23 Aug 2022 10:38:38 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH][SMB3] skip extra NULL byte in filenames
Message-ID: <20220823133838.3egvvzarknwtwbfp@cyberdelia>
References: <CAH2r5msk4Jc1HM=3ynEAYOAYYZZtM90Z9_c4myDeDbrQ3ecmCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5msk4Jc1HM=3ynEAYOAYYZZtM90Z9_c4myDeDbrQ3ecmCQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 08/23, Steve French wrote:
>Any comments on Paulo's recent patch below?
>
>    Since commit:
>     cifs: alloc_path_with_tree_prefix: do not append sep. if the path is empty
>    alloc_path_with_tree_prefix() function was no longer including the
>    trailing separator when @path is empty, although @out_len was still
>    assuming a path separator thus adding an extra byte to the final
>    filename.
>
>    This has caused mount issues in some Synology servers due to the extra
>    NULL byte in filenames when sending SMB2_CREATE requests with
>    SMB2_FLAGS_DFS_OPERATIONS set.
>
>    Fix this by checking if @path is not empty and then add extra byte for
>    separator.  Also, do not include any trailing NULL bytes in filename
>    as MS-SMB2 requires it to be 8-byte aligned and not NULL terminated.

Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>


Cheers,

Enzo

>--
>Thanks,
>
>Steve



