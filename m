Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE4AC6FD1D
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Mar 2023 05:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCWFAO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 01:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCWFAN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 01:00:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC2B6EA8
        for <linux-cifs@vger.kernel.org>; Wed, 22 Mar 2023 22:00:12 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so843512pjz.1
        for <linux-cifs@vger.kernel.org>; Wed, 22 Mar 2023 22:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679547612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Dvfk03zAh6PCdU6Ch2hY2Ik//dQRVxj1BQOtVzMS7c=;
        b=JsLQ8RLjYLcZlaOxeVrZ2P25vt/et2RMm9y5gMc/EvCkM99YNS/P5sdgS0BXcejLDz
         dgsPk7fDsrFfMg+VNipbruZ+YmkxlS+E0nnZ4o1ewgarqEZ02TP8h+pgou/1hUONQPcV
         ontSsIVVszvACnxz/UEUaAzbMpVlnLBXiXQwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679547612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Dvfk03zAh6PCdU6Ch2hY2Ik//dQRVxj1BQOtVzMS7c=;
        b=SxfR9HxZTygb+tiIR8qZ1+6RmhoJcm8/CaK9Fcn777OJ8+oxNlJ5xlsNybTaYCZK6z
         i3mMV7pn+wsql6MMvJ6mmQGkLFHbGozL0wl7ummSort+PYzRO4xFSGqma2fesWVlYbTM
         MAUHJ4dRjKMfMG3Jq/DrkaT6HgPJAVys4zlPdpCVzVzXRy6w1DTSo2ozVGTjQtF1ex34
         4Ho4hxKYYV86hjoROabUKDbc82U6wiKLUIGPcvVTpXKQBfkNyzaWExJ/Nh6SSX3mE7AI
         7fHXViCg6A/Uq063BHJz1/zIiAsrjLcegrWPQOlQZGbeR0xldzCg0FSI+9MDXiAHLWWl
         fUmg==
X-Gm-Message-State: AO0yUKUgMwhmQ0Jp5n7BLyoZxngzXbhtCKoUJ6xuHs9VuMykE7VAZMkX
        nwzHdBZqfjG+zW6eI/CPFt8WOVu4fatAAJXvfYE4Jw==
X-Google-Smtp-Source: AK7set9ZoAZOS+ynynEnoEL8IM2Or1NXt61psAC+mDR+z+KbosdqhGNBdH5YO8dLgmElarhtx9pM/A==
X-Received: by 2002:a17:90a:e7cb:b0:234:b8cb:512b with SMTP id kb11-20020a17090ae7cb00b00234b8cb512bmr6715231pjb.30.1679547611944;
        Wed, 22 Mar 2023 22:00:11 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id l3-20020a17090b078300b0023f5c867f82sm380256pjz.41.2023.03.22.22.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 22:00:11 -0700 (PDT)
Date:   Thu, 23 Mar 2023 14:00:06 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com, Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH] ksmbd: return unsupported error on smb1 mount
Message-ID: <20230323050006.GB3271889@google.com>
References: <20230321133312.103789-1-linkinjeon@kernel.org>
 <20230321133312.103789-3-linkinjeon@kernel.org>
 <20230323025319.GA3271889@google.com>
 <CAKYAXd-PQFcVq=b_KNq6P5imBV-Y+PQ5LBZCzH-mH7dmZAav+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd-PQFcVq=b_KNq6P5imBV-Y+PQ5LBZCzH-mH7dmZAav+w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/03/23 13:10), Namjae Jeon wrote:
[..]
> >> +	/*
> >> +	 * Remove 4 byte direct TCP header, add 1 byte wc, 2 byte bcc
> >> +	 * and 2 byte DialectIndex.
> >> +	 */
> >> +	*(__be32 *)work->response_buf =
> >> +		cpu_to_be32(sizeof(struct smb_hdr) - 4 + 2 + 2);
> >
> > 	In other words cpu_to_be32(sizeof(struct smb_hdr)).
> Yes, that's possible too, but wouldn't this make the comments easier
> to understand..?

Maybe, but the comment says "-4 + 1 + 2 + 2", which doesn't match the code.

> >> +	*(__le32 *)neg_rsp->hdr.Protocol = SMB1_PROTO_NUMBER;
> >
> > 	I assume this should say cpu_to_le32(SMB1_PROTO_NUMBER).
> SMB1_PROTO_NUMBER is declared as:
> #define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)

Oh, I see.
