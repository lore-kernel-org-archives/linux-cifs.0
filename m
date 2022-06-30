Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBCCC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jun 2022 16:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbiF3Qrs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jun 2022 12:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbiF3Qrr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jun 2022 12:47:47 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A573B3EAA1
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 09:47:45 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id fd6so27337540edb.5
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 09:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=eWhlUAODLliCaPdkAJ6yvBfMxEMIJrmIDhYvvoZuKnc=;
        b=n9aabjHb2U96BjQLmUUdvOJvCbEppbD/i1OvIt883kjuVfx2NFxuuTOhUVqyCkJJMz
         UxRDWIvFWXSDXakcuIDRX1PeLEtPQm0hi9NMZNMeGM6ZblTeRLT7AoW7g7cMprGeSqne
         LY8Q2KXO/V9Cx1tGhookxufhVJrKN4p1mHKmSf1E4YHsJEZLZDwo2js3z/DeuZ1BQMLt
         YgPKLHFdOh3emueV0bH0Ij7yxCJi42aa2BYvdQtThEvO3A/7aR8oWHH1NOsEYdBKm64f
         FpG3MP32oI9vJjgGesqpZ5lNrUCSDGCmUbCE14fC+VnTGwKWMh29Dt5aUyuFu5Gnkg4a
         AwSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=eWhlUAODLliCaPdkAJ6yvBfMxEMIJrmIDhYvvoZuKnc=;
        b=xfjuVfV08VLWRRAxLbEp+cRI8biqqgaoOjhQuEAhPyGIjPYuFDVcwfI4dVEp7/o1VG
         Ikj1NBlcUsR0zMLwNkIo0JjJaQzZTl9l2ep4unyKjZq1lSUmj3qIY/We/8w1/2x6nM8D
         uub7vdYVjGktA9UArxtnqKaM4Jz/LFZzYC/r1lJd4U7mlpydP83us6XMaP6+rKWCHIHM
         wsA5o0SWRHfV3UCsUZpNr9aOJUClYDUaPfFg7o8zH6gJHOqMKbZP+CGfgjE1xVBuFPPm
         x9PnQHqcKiu1+fl9NR1Fuv/Y+cf+WM1wMX0JY8NzuTkkkCgLcJp8xQEIpJEZAHOMRgNe
         4qag==
X-Gm-Message-State: AJIora96QtBEw0esi2IUtwQqlRM9II4d/asOmm22TOP/EudXywlrea58
        /RA804207P8PcojjgR5iiG1EJN0oBfRzNg==
X-Google-Smtp-Source: AGRyM1urVcFbyGBI4o50jRk1nxcoLEu91BwSl8mqOKdKwNvMw7uEpHKmEFaIWxRuuDvW9EYogVbeiQ==
X-Received: by 2002:a05:6402:3220:b0:435:8b50:e995 with SMTP id g32-20020a056402322000b004358b50e995mr13083019eda.293.1656607663945;
        Thu, 30 Jun 2022 09:47:43 -0700 (PDT)
Received: from ?IPV6:2a02:908:1987:1a80::a7fd? ([2a02:908:1987:1a80::a7fd])
        by smtp.gmail.com with ESMTPSA id h1-20020a1709063c0100b006feec47dae9sm9260245ejg.157.2022.06.30.09.47.43
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 09:47:43 -0700 (PDT)
Message-ID: <211885e7-1823-9118-836b-169c7163d7c2@gmail.com>
Date:   Thu, 30 Jun 2022 18:47:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     CIFS <linux-cifs@vger.kernel.org>
From:   Julian Sikorski <belegdol@gmail.com>
Subject: kernel-5.18.8 breaks cifs mounts
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi list,

it appears that kernel 5.18.8 breaks cifs mounts on my machine. With 
5.18.7, everything works fine. With 5.18.8, I am getting:

$ sudo mount /mnt/openmediavault/
mount error(22): Invalid argument
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel 
log messages (dmesg)

The relevant /etc/fstab line is:

//odroidxu4.local/julian /mnt/openmediavault    cifs 
credentials=/home/julas/.credentials,uid=julas,gid=julas,vers=3.1.1,nobrl,_netdev,auto 
0 0

Is this a known problem?

Best regards,
Julian
