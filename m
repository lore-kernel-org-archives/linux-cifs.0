Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27F6C77B7D
	for <linux-cifs@archiver.kernel.org>; Mon,  8 May 2023 01:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjEHBGm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 May 2023 21:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjEHBGl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 May 2023 21:06:41 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936FE100C1
        for <linux-cifs@vger.kernel.org>; Sun,  7 May 2023 18:06:40 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a5197f00e9so27150825ad.1
        for <linux-cifs@vger.kernel.org>; Sun, 07 May 2023 18:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1683508000; x=1686100000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=djBNmFkBuUywGxCFNsE3nSy1sJ821VkwlkCLP+BSlnw=;
        b=l5aV+rshsNX+ii9j9hOP9zfBiED0qSXmjECMKbTJapXgW9YOFoaVGq0pTOT026xiAc
         K3X0X1RRsS4V+laQv++BVxVZw45jqTPUe0rEbaak4QBtJneSZayxKABMMU+zGvESDE/U
         lr74LYmN7WkxGBwkZ2W/++iIE/k/oI5FHY17E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683508000; x=1686100000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=djBNmFkBuUywGxCFNsE3nSy1sJ821VkwlkCLP+BSlnw=;
        b=Gzn9+xsq8yiwxNzsEsgCJFq64uuEgZyvxjA2BsamyBSLGBd8dAO+ewg6mCdanjtEvE
         HfRkrswvOSy90iEWZI9LKPnGnlFMFETpJj2Skc44xJ5SLHlOB5M6K2PgjUMuEe80LWRc
         FvDe0s7afE0BhSGwm07RYtk6zYu440q67qh8d/iPPd7nE9ytwhzMXX/y8WM/MrmwqnyG
         OPa+ZnbvJLsKLKMh0XTJ0g6uP2cZNq9VEG/7VfHdLyi+9dxitdoYJ7G0b+s+ZPEUUEFt
         83GxhxTt0VJffXiQ43rVTbAc7FoB10F5mgYMyYBtvdbgFGiN6v7N74imQ/o++FrhF0/i
         5GlQ==
X-Gm-Message-State: AC+VfDyK9AID5nwHlgJKPq8VsDtcjgI5HROf6FZomgl5RfITTKVcGHbT
        XmNxRbsWfvtKuCB2Vql1pDTcgw==
X-Google-Smtp-Source: ACHHUZ5zWvQbwkpgrqIpKwTFt8llIcQPOAh9sw9Fm5iLRZWgfu9Mb1p7uDya4lOkMiOuilctx/6yFQ==
X-Received: by 2002:a17:903:64c:b0:1ab:107b:c127 with SMTP id kh12-20020a170903064c00b001ab107bc127mr8002169plb.59.1683508000105;
        Sun, 07 May 2023 18:06:40 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id x14-20020a1709027c0e00b001a24e2eec75sm5739870pll.193.2023.05.07.18.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 18:06:39 -0700 (PDT)
Date:   Mon, 8 May 2023 10:06:35 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH 6/6] ksmbd: use kzalloc() instead of __GFP_ZERO
Message-ID: <20230508010635.GB11511@google.com>
References: <20230505151108.5911-1-linkinjeon@kernel.org>
 <20230505151108.5911-6-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505151108.5911-6-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/05/06 00:11), Namjae Jeon wrote:
> Use kzalloc() instead of __GFP_ZERO.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
