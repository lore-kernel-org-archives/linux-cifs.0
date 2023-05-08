Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9EEC77B7C
	for <linux-cifs@archiver.kernel.org>; Mon,  8 May 2023 01:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjEHBH3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 May 2023 21:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjEHBH2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 May 2023 21:07:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF3735AE
        for <linux-cifs@vger.kernel.org>; Sun,  7 May 2023 18:07:27 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ab01bf474aso29204225ad.1
        for <linux-cifs@vger.kernel.org>; Sun, 07 May 2023 18:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1683508047; x=1686100047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M5UtACvJBcuZF7Pht4qG1VtEcBaFBtDu1h1lJmGKQB0=;
        b=SD0WYBqwI29OrLtQjTHyQZGc5qQIEcpxL46/rEgLwJlKcIE5t8bP66XNkxQUm4sgOR
         ACJG2zfZlaSi/r89X3h9hOtt50Flg3mpjn7aYDxnJ7zI6wr9T8jbfuhCKn2XpgxxqZcE
         R3AMG74xtbOkdBGMa9XDmy2XRRPfOP2gg3lg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683508047; x=1686100047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M5UtACvJBcuZF7Pht4qG1VtEcBaFBtDu1h1lJmGKQB0=;
        b=QOnLKdXOKK4OFt+IGYi+L0jygXcUTfdELKLtpJ9ILD4Pr/l6IhnZoUgbh1Uh3TtSc4
         iJikzGRvZLQCbIhnX7o7xi8jSL7tyLrwCTNFzx+5Z7Dr2VmfOs4f1DU2BHheaUsXfy0z
         TFVxDkfZAeEj+bbugiMbEqISVnuidU51RNW3TAPWKV6bbPWJcTIpuASqh8fUO7d9782j
         k3QDp8yWrJQ2Pv+J3TDaQsBiQkZSE5blU0ZeSSEc/IpABDOVcTMhQzKPcYOri/Fzr/VO
         fPS0Bjf5AkwZzj+Y98qeOu7AbaDIK7cBLd4Ee/juHTy3qQ8u4UzI2oeL9daA0P79Go1W
         RgDA==
X-Gm-Message-State: AC+VfDwqGXcUoURCOTLGXve9deS1IjUcf710PC+6wUC3lzDGtylBQJ1p
        CnHKa06/6uYf3ZMkOmb2j7M6YQ==
X-Google-Smtp-Source: ACHHUZ5YxCtAA/hg35byANT47L8C/vZRd2tWrT1JVyl/JdqjqveUJyxpMWQoB9NeZ67zKYSRO3LQcA==
X-Received: by 2002:a17:903:1205:b0:1ac:6d4c:c26a with SMTP id l5-20020a170903120500b001ac6d4cc26amr3465391plh.14.1683508046849;
        Sun, 07 May 2023 18:07:26 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902c18600b0019a5aa7eab0sm5746656pld.54.2023.05.07.18.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 18:07:26 -0700 (PDT)
Date:   Mon, 8 May 2023 10:07:22 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com
Subject: Re: [PATCH 5/6] ksmbd: remove unused ksmbd_tree_conn_share function
Message-ID: <20230508010722.GC11511@google.com>
References: <20230505151108.5911-1-linkinjeon@kernel.org>
 <20230505151108.5911-5-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230505151108.5911-5-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/05/06 00:11), Namjae Jeon wrote:
> 
> Remove unused ksmbd_tree_conn_share function.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
