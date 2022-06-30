Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D690AC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jun 2022 17:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbiF3Rlx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jun 2022 13:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235297AbiF3Rlw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jun 2022 13:41:52 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8561107
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 10:41:51 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id fd6so27520850edb.5
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 10:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Mz06cxuqRyA18PQi5xxL2t6h6NKLMBru2esXD9U91Jw=;
        b=NPrVoK7pwEuAXMJekQRi2e/HhUewgX6smUvnSQ8vFMMHN3ZS/gEKIZmB1UoucxQNY+
         Vh9Ecwgony6y/nKtZkfiQ2nC8OuLNryRFr5xbRL84tL/zYUPPfViwTFZ4c1JmMRkH2po
         JJk1khiZrGpeUF400VIrNbKj/LI+IzGeEwlnob8txIGIcekkeV9rooRMqbqapt5u6yLE
         Up94WE/HBh4q0G5pBhpU5u0D0RP3GHt0c3KbBDoi5jzOxcif0uVkDwupJIX66erTkwO3
         b5a53bGWWfISLrh9eaBVjNfGScGzx+u1247C+i/tAq6HJZ7pzTbISxoYRZuk+/hv77k/
         exkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Mz06cxuqRyA18PQi5xxL2t6h6NKLMBru2esXD9U91Jw=;
        b=ivp2y0AkGDBDO/vPhB/y9GHW42V0UxXIoLJ6m7iGhAMNHln0a0IVAXgsHDkksreUMw
         Af9HjY7G6t8SRL8Rh1tXQISIwqH9LrACvWvr4vMXi5Fi4YCpHhgK3iagb/c/AWQaGL+f
         RnnFfy+Cmhp2u3FY3BDU0kLL1pwgj9J2j6+aWg7zaFmP7uFXnIEUs9V4YIVmXE7iB85h
         vGpzNSt6wyPmD/0m1I9yAg5W4AnJ3s3obIwXp01koAkCLOKdcH+mgzEwJcZ4JeIFC4Uz
         76tgRAFer0tpWXbfwDqC/OaaAm6PimHJkDV8w6lnDPFMLkFDLYQzjEpSY/+8U+gnp18g
         Qo3Q==
X-Gm-Message-State: AJIora/LIEJeCX+c+iwDbw4PAFNkodo84FzYzdI/MVSbxswg5jmt2dC2
        4wAAO4TYIGxsTL9zsogIIWA=
X-Google-Smtp-Source: AGRyM1v4JitN1mPLnsAXL4eO+akGa7MFJRyfi30MaH3CY5zf3gOwxZ25S6j45K/mE7JQ7bxQSNr5MA==
X-Received: by 2002:a50:ef0d:0:b0:435:6829:e980 with SMTP id m13-20020a50ef0d000000b004356829e980mr13436626eds.192.1656610910256;
        Thu, 30 Jun 2022 10:41:50 -0700 (PDT)
Received: from ?IPV6:2a02:908:1987:1a80::835b? ([2a02:908:1987:1a80::835b])
        by smtp.gmail.com with ESMTPSA id el3-20020a056402360300b0043585bb803fsm13256404edb.25.2022.06.30.10.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 10:41:49 -0700 (PDT)
Message-ID: <fee59438-7b4a-0a24-f116-07c2ac39a3ad@gmail.com>
Date:   Thu, 30 Jun 2022 19:41:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: kernel-5.18.8 breaks cifs mounts
Content-Language: en-US
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <211885e7-1823-9118-836b-169c7163d7c2@gmail.com>
 <CAN05THTbuBSF6HXh5TAThchJZycU1AwiQkA0W7hDwCwKOF+4kw@mail.gmail.com>
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <CAN05THTbuBSF6HXh5TAThchJZycU1AwiQkA0W7hDwCwKOF+4kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



Am 30.06.22 um 19:02 schrieb ronnie sahlberg:
> On Fri, 1 Jul 2022 at 03:00, Julian Sikorski <belegdol@gmail.com> wrote:
>>
>> Hi list,
>>
>> it appears that kernel 5.18.8 breaks cifs mounts on my machine. With
>> 5.18.7, everything works fine. With 5.18.8, I am getting:
>>
>> $ sudo mount /mnt/openmediavault/
>> mount error(22): Invalid argument
>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel
>> log messages (dmesg)
>>
>> The relevant /etc/fstab line is:
>>
>> //odroidxu4.local/julian /mnt/openmediavault    cifs
>> credentials=/home/julas/.credentials,uid=julas,gid=julas,vers=3.1.1,nobrl,_netdev,auto
>> 0 0
>>
>> Is this a known problem?
> 
> What is the output in dmesg ?
> 
Not much is there:

Jun 30 18:19:34 snowball3 kernel: CIFS: Attempting to mount 
\\odroidxu4.local\julian

Jun 30 18:19:34 snowball3 kernel: CIFS: VFS: cifs_mount failed w/return 
code = -22


I tried reverting 16d5d91 as it was the only commit referencing smb, but 
it did not help unfortunately.

Best regards,
Julian
