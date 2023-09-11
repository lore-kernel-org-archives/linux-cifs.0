Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FB0CA0ED0
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Sep 2023 22:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379659AbjIKWpS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239950AbjIKOcP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Sep 2023 10:32:15 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DA5CF0
        for <linux-cifs@vger.kernel.org>; Mon, 11 Sep 2023 07:32:08 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9a6190af24aso565937566b.0
        for <linux-cifs@vger.kernel.org>; Mon, 11 Sep 2023 07:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694442727; x=1695047527; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X2TihwGINu5DoRymnNJ/s1Yh529aoY7ZW/KszO73tVU=;
        b=eU5Lf3ZGoiAzvfCaSS6nKaAD6AIbWWdHYjCf0GFKZN3Nl0nfOZBZ5m0jkWSNO4XIcu
         Z59yPlCMgVsTL9zw+h+XNlJkfYeyRaqQnOwsJ+cFzYCFtLZ4yKSaG5Rbb2W+kgR4NbsE
         /Sfa2Eau5/jii6IU1UnLhe8qnf9DKaFXC8OF8Oxz/7xVrLEgZsHuMP2PxstoEBLKyYip
         7Nresykbwd2dJh51MnKxLFhA9BLLDZordPXsQOY7nWNHN0+Lv7ewMK8ulPbrm/eueZGJ
         nB+LYYg79jat66Cdn7kiJ/2OnImKkQvDJhLunpAoY37VviNnIeQMadD2esxl7JcwYslq
         Szvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694442727; x=1695047527;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X2TihwGINu5DoRymnNJ/s1Yh529aoY7ZW/KszO73tVU=;
        b=LDj6dr77+rXwFKi6FpTbf2Xp9PdWKWwHxF+igjH2RDAoaqhBDmrLNmyyQcTth8eiFh
         LVuVQkFclMcWulS4eFW+Q6JNsQfn+djWX+qxXs8Covkmkx5zSpBA9t1cL2LhjeIYisaa
         6MHVy6/+jNz32Rs8kSRIneXP0K5W3dRQDFvXdM7sSlVE0INr8JFQ4jeN3hu/xvHXeFS8
         Wwd1mfR3NGf61xzT04+T545JoVrLTj8FtVYGXqXVVeaHku+1L9ZbRHsAHQWgGaG+VmfO
         SWrtL/mGgZoaY7e9zOQosCBs2DLocnmyezMpBa1ZJ561k5fDBW/jAT+IvyHpVPhtOOMt
         k8aA==
X-Gm-Message-State: AOJu0YySE7kVqYRX+rlgNKg5ReBiZtRh5HqmKCuA1zmGe9B0lyBaiEia
        +qn8ayDvOkw1p0BHz0jEO5SU/A==
X-Google-Smtp-Source: AGHT+IG3SwpGQs2oNHfpIbYrFfZSrsdnjTTpYWloR6055YpbSP/93k8b3roWh/idKn7TRbLqtq0LSw==
X-Received: by 2002:a17:906:cd1:b0:9a1:ff2f:28f1 with SMTP id l17-20020a1709060cd100b009a1ff2f28f1mr8364537ejh.40.1694442727143;
        Mon, 11 Sep 2023 07:32:07 -0700 (PDT)
Received: from localhost (h3220.n1.ips.mtn.co.ug. [41.210.178.32])
        by smtp.gmail.com with ESMTPSA id o6-20020a17090611c600b0099cf9bf4c98sm5501961eja.8.2023.09.11.07.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 07:32:06 -0700 (PDT)
Date:   Mon, 11 Sep 2023 17:26:40 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     stfrench@microsoft.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] [SMB3] send channel sequence number in SMB3 requests
 after reconnects
Message-ID: <64897822-3af9-49ee-98a5-97858b594d6b@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Steve French,

This is a semi-automatic email about new static checker warnings.

The patch 09ee7a3bf866: "[SMB3] send channel sequence number in SMB3 
requests after reconnects" from Aug 24, 2023, leads to the following 
Smatch complaint:

    fs/smb/client/smb2pdu.c:105 smb2_hdr_assemble()
    warn: variable dereferenced before check 'server' (see line 95)

fs/smb/client/smb2pdu.c
    94		shdr->Command = smb2_cmd;
    95		if (server->dialect >= SMB30_PROT_ID) {
                    ^^^^^^^^
Unchecked dereference

    96			/* After reconnect SMB3 must set ChannelSequence on subsequent reqs */
    97			smb3_hdr = (struct smb3_hdr_req *)shdr;
    98			/* if primary channel is not set yet, use default channel for chan sequence num */
    99			if (SERVER_IS_CHAN(server))
   100				smb3_hdr->ChannelSequence =
   101					cpu_to_le16(server->primary_server->channel_sequence_num);
   102			else
   103				smb3_hdr->ChannelSequence = cpu_to_le16(server->channel_sequence_num);
   104		}
   105		if (server) {
                    ^^^^^^
The existing code assumed that server could be NULL

   106			spin_lock(&server->req_lock);
   107			/* Request up to 10 credits but don't go over the limit. */

regards,
dan carpenter
