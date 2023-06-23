Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA94C001B3
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jun 2023 05:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjFWFAx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Jun 2023 01:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbjFWFAq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Jun 2023 01:00:46 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FA4268E
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 22:00:40 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-3a0423ea74eso152760b6e.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 22:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687496440; x=1690088440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dO3MpsG2FPQPtCv7mlnZdFOdJg6cQkJoBs2wodZ0qFE=;
        b=ENvITiWl82bmXDiJLimeWRzeEHEf1ln05ugojEWad/Js1Nz+uQeXK4+Z/WAHbfGqf0
         rbiZjOjv25tD2F25726CThGsOrX7cjuRALOeDCps5H4nNIGerVZwbj1vVhY3/sSEADjE
         sDPIoUgnhiRkd7WT4A5eCGBO1kfJKKDsJOXg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687496440; x=1690088440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dO3MpsG2FPQPtCv7mlnZdFOdJg6cQkJoBs2wodZ0qFE=;
        b=K1h8gl944zcKnFYmvXn5viaaH5OpOUp7EnK/7G4ux50ThHIJtgACH8lbcxlIOdUYnM
         iw/LUitOawEB480K7F4FNvPbH6PA5E3RC4TKG1SJLwe3u6Tn5y6ADkR6t0ZptBHHUrIK
         bMKaBDLepBKzNq1EC0uhZQVR7uBXBUqlZ0aMj1LKHHQt47GSzfq/ccL9jtDXwU1zQRMo
         MSjGR3WdAjSfOGnt4EHTlcQyQ13+Txk/G/YKfly5v1OYvruvgBa00vkVW9oFHqYV6I1n
         joCLwi7kUK95czLblKK71PD1fjKafnrnN0SSvxgoyNGtACV+FmYaNY3kux/Ip3CMpzt6
         PxTg==
X-Gm-Message-State: AC+VfDy9Vlt3gAUyr8bXPSy9MNzruqaUlFlaaia1vqJ2rsve+LHQ6/cM
        rgl/rQpIutxXtgpz7rkDjuomRQ==
X-Google-Smtp-Source: ACHHUZ4QrKXVokRHjUt66Kft/IMDEJ80EeRHZoEf3iPCaC97ad3S8FSVewv0YRPDVlMlg0KPF7Pzaw==
X-Received: by 2002:a05:6808:abc:b0:3a0:3685:874a with SMTP id r28-20020a0568080abc00b003a03685874amr9412504oij.21.1687496440211;
        Thu, 22 Jun 2023 22:00:40 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:3383:b451:fa2:1538])
        by smtp.gmail.com with ESMTPSA id b6-20020a17090ae38600b0025c07d07e54sm524952pjz.50.2023.06.22.22.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 22:00:39 -0700 (PDT)
Date:   Fri, 23 Jun 2023 14:00:35 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] smb: Replace one-element array with flexible-array
 member
Message-ID: <20230623050035.GB11488@google.com>
References: <ZJNnynWOoTp6uTwF@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJNnynWOoTp6uTwF@work>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/06/21 15:12), Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct smb_negotiate_req.
> 
> This results in no differences in binary output.
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/317
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
