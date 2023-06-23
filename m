Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE892EB64D7
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jun 2023 05:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjFWFEH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Jun 2023 01:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjFWFDn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Jun 2023 01:03:43 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A72E268A
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 22:03:42 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-5440e98616cso1007145a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 22:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687496621; x=1690088621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PDo3MywNwQbl7iqfZb964ASJUvrMf42evsnlBRBIz08=;
        b=OI2qzFjaTLyAIPV9ppUNzkTmREPPSH6496HI5As09/hOE6tg96PqV36VtmqBDNEaZq
         6i32T4VJOCaiiXkzgq68rgZlCDEy5SsvuI7FGdOLU4uyh2q+XBGvgdqAU1twLO4hHwNe
         0eoBXGQce8lEG9I5+8rmeBPMfExXx8nTmhDcA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687496621; x=1690088621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PDo3MywNwQbl7iqfZb964ASJUvrMf42evsnlBRBIz08=;
        b=ZiAJ453Vow7TmbYrxRczSB4z3cPEZl5HR9+mwKpKxZQY/rSYabunWXjgBug+QIbEC9
         ipTOh6sNQnlNVUehG3Txq/dfhHlrREfNhzoNPVTRut95pmAt0Wl412+sqK0KI3RQMxm5
         I+wE+EzCjxOrZQYZWJ+FYGUYbKD97jlYjPSK1QsuUnlhD0ZwA3wa0BFwQDI1ViyFzmpm
         e2s/vKdI03/8W4/lu/vMv7TDR1CJi4Pc/w8xJippmJVTflCjdmziMzFoPF/3VC/ntyZV
         Hk+eJHhqLg9LG+HQsxXX8RhJCx7+8mZPtBklRu1hkiFzIrCzrLDlLhVtmgM+h5EiOoWe
         zJig==
X-Gm-Message-State: AC+VfDyIIlw+nDB5h+mWaCaNbLrF0TSNNochdJ7WvZAJgOm2O0q5bVDk
        jgFABipCIyyoK3m8lkzIErJ5/w==
X-Google-Smtp-Source: ACHHUZ5IBBvTRJJglgqFaQ+r5YeQ+2kgevBN570xdtq7R+7V0PmvfhDNPyADkaSe4ckj8E92hxlHsQ==
X-Received: by 2002:a17:90b:2291:b0:262:a89a:b0c1 with SMTP id kx17-20020a17090b229100b00262a89ab0c1mr303242pjb.0.1687496621259;
        Thu, 22 Jun 2023 22:03:41 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:3383:b451:fa2:1538])
        by smtp.gmail.com with ESMTPSA id s3-20020a17090ad48300b0025eb5aafd3csm551911pju.32.2023.06.22.22.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 22:03:40 -0700 (PDT)
Date:   Fri, 23 Jun 2023 14:03:36 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Steve French <sfrench@samba.org>,
        Paulo Alcantara <pc@manguebit.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 62/79] smb: switch to new ctime accessors
Message-ID: <20230623050336.GC11488@google.com>
References: <20230621144507.55591-1-jlayton@kernel.org>
 <20230621144735.55953-1-jlayton@kernel.org>
 <20230621144735.55953-61-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621144735.55953-61-jlayton@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/06/21 10:46), Jeff Layton wrote:
> 
> In later patches, we're going to change how the ctime.tv_nsec field is
> utilized. Switch to using accessor functions instead of raw accesses of
> inode->i_ctime.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
