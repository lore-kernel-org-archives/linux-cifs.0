Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13120C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 18:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377106AbiEDSiY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 May 2022 14:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376976AbiEDSiD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 May 2022 14:38:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A1B4F9CE
        for <linux-cifs@vger.kernel.org>; Wed,  4 May 2022 11:27:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0E9FC210E3;
        Wed,  4 May 2022 18:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651688863; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eZ7ebMqZdPor6znyjNOEkhs/OZQR9urQLzgeaF77vE0=;
        b=Z+P7ycSjyRuij4usTjl30AwRniNBiPRGowV1fxl6cNAAB2JcBNbEvXQ5+PXzOBmAi1pOW0
        I+bwQ3MYwGtwkdLhTmjVvlmyUeHu6pFsxHHX/TFqsag30Tmb7OzoVe651uCD/IEOYs0u3f
        wbYMRnl/GVz0bN6AJzVcm3wfDWdnb1A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651688863;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eZ7ebMqZdPor6znyjNOEkhs/OZQR9urQLzgeaF77vE0=;
        b=GrcYMSF3Hl5i7S53QZcGUM7driSs2nujjYJIHQu4zX2UxHvKnDauGA5NnH2piZBOpWebEX
        uXfDjcuOz6tAKzDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 820F9131BD;
        Wed,  4 May 2022 18:27:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SuQ4EZ7FcmKDdgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 04 May 2022 18:27:42 +0000
Date:   Wed, 4 May 2022 15:27:21 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: cache dirent names for cached directories
Message-ID: <20220504182721.xywno7d3ihfxk5dr@cyberdelia>
References: <20220504014407.2301906-1-lsahlber@redhat.com>
 <20220504014407.2301906-2-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220504014407.2301906-2-lsahlber@redhat.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Just another nitpick

On 05/04, Ronnie Sahlberg wrote:
<snip>
>@@ -776,7 +791,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 	struct cifs_fid *pfid;
> 	struct dentry *dentry;
>
>-	if (tcon->nohandlecache)
>+	if (tcon == NULL || tcon->nohandlecache ||
>+	    is_smb1_server(tcon->ses->server))
> 		return -ENOTSUPP;
>
> 	if (cifs_sb->root == NULL)

This last hunk looks unrelated to the original topic. Could it be sent
as a separate patch please? This helps tracking when doing
backports/bisects.


Cheers,

Enzo
