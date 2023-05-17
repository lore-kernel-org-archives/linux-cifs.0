Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB5CC77B7F
	for <linux-cifs@archiver.kernel.org>; Wed, 17 May 2023 11:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbjEQLDc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 07:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjEQLDa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 07:03:30 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1925BB3
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 04:02:51 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-643a6f993a7so423118b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 04:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684321338; x=1686913338;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M0rk/LdCtlhImPGekDPELu81weUeZQFkAqFPFSe53yk=;
        b=YthbOiG58Tbk98rRVQI7N7Y6kJbO/++r9w2miiF7xXebZRuJOqjap++GjHMRCTslJ+
         eJ229sWYp7YCfCxP6MVE2vf3ElBrLTfoEGbt5NDRneVvk/nc0ete/Hs4ygyoddCNwQ+A
         JPEK5FLQSnEvyXP4d9osiVSHTg2PD75W0c9tc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321338; x=1686913338;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0rk/LdCtlhImPGekDPELu81weUeZQFkAqFPFSe53yk=;
        b=ljXn0VK8TkBwL5XV+3KSaPItaltEy1EBQXy8MyFRMHH1EFTJyue/rMw80qzEDzzPBB
         mCyXAsP8yd0R/esGBj5GkwVoSf8Lrv9H6wD5qYAmOeDS/mqpY0euWduHUUdNn/W/QOsA
         zXqmw4yxJ1YkuVeFlnWGrsE8roxTz+JhZsO6ItcL4kRY05e9hcBenD9LepsRJXqXj4YT
         9fEbECZI6R7gpn0pQtewEimQcZdagnOZarVw075CHJfrMPbalfvvGX0BipmVMFiBttBx
         mp5cJuDQRtkZYQTTpMtJNea5SPaGxeRQ5reGNtH1okcjIbotUT7Ug9H7WFNl8Gij+qMo
         9cMA==
X-Gm-Message-State: AC+VfDx+F3amphvuhHQYWqDCNF8IqB4uoySTql9jz+hCYdk9tdRymg3s
        P+q03VJKh+anANLh9MLCWj9JhQ==
X-Google-Smtp-Source: ACHHUZ421S8EkAJ41CKUJ+99aXJ5jeWl3z+0O1g6UerWtWaXnhw94r3Q4EUMB0wsPs9z4tF4aCM8MQ==
X-Received: by 2002:a05:6a20:3d8a:b0:105:5caa:b49c with SMTP id s10-20020a056a203d8a00b001055caab49cmr17427072pzi.23.1684321338006;
        Wed, 17 May 2023 04:02:18 -0700 (PDT)
Received: from google.com ([110.11.159.72])
        by smtp.gmail.com with ESMTPSA id z16-20020aa785d0000000b00642f1e03dc1sm15472324pfn.174.2023.05.17.04.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:02:17 -0700 (PDT)
Date:   Wed, 17 May 2023 20:02:12 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     HexRabbit <h3xrabbit@gmail.com>, sfrench@samba.org,
        senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH] ksmbd: fix slab-out-of-bounds read in
 smb2_handle_negotiate
Message-ID: <20230517110212.GA20467@google.com>
References: <20230517095951.3476020-1-h3xrabbit@gmail.com>
 <CAKYAXd_V2RgWTHzrG-1A8kX+rpyyQ06=hX2s5AqwW8ERWaaE1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd_V2RgWTHzrG-1A8kX+rpyyQ06=hX2s5AqwW8ERWaaE1w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/05/17 19:17), Namjae Jeon wrote:
> > Signed-off-by: HexRabbit <h3xrabbit@gmail.com>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> 
> Sergey will say, "Do we still have a requirement that there should be
> a real name in SoB?"

:)   Thanks!
