Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5D4C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Apr 2022 09:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236291AbiDXJ5C (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Apr 2022 05:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237588AbiDXJ5C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Apr 2022 05:57:02 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4481F644F8
        for <linux-cifs@vger.kernel.org>; Sun, 24 Apr 2022 02:54:02 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id bv16so16874949wrb.9
        for <linux-cifs@vger.kernel.org>; Sun, 24 Apr 2022 02:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=PcnLo2ZjkPEzVs6ib0TY9iY3U327dNI+ekq4lJHhKmE=;
        b=ITRhOWxT0EzndKoub5QjUtx+4bMU/HqghN7hr9Sfeb3yZTJN4ZUrnCHOSA40vwW+Da
         U6FSQx+zmmTuRKPOnyN4yo5hzaNZSaGyfL8s69ZToi3Z7bZc3bUCWA8zVXQ7tnMF2Fiu
         m1SBLUZmIlzt8rI1o97s7q4uvb/YPYc7htQAz+QK19WKiCaL3BaY+xlcGnkX+MtTx0o2
         la0Z8T6DIQTHcSpTNfx54o4/auKms4BET4inRL2RW4SVt36PIdsyjbu3dKZDkMLJAE5x
         04QfUlT3V1bPxkp++b2pXIaCV1876UCwUyRnlC7PkdlwuGD5HHkIIKvlUpaAUCStsTrJ
         B0Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=PcnLo2ZjkPEzVs6ib0TY9iY3U327dNI+ekq4lJHhKmE=;
        b=Ur6xHenbj+v+W98FCI1TDyPKGn3mPKyyeSKPJDnsnJiIpbxyjirM327/HFOFWUEd9n
         Vq+jbYV7lo9P3JhlhSfX1okokbv88v/kAgKq2OzrLKxHPcWfDzBy9nWO33dK/3mH4Ig1
         RSNX4su0jUgDeXDSpIjUc+vxCh8N5yUW/Ab/7pVsqmCCWCjA7FuU9WSczjmnVeT73Yan
         ArYwf0Rj1yq27DBQrjtroa/xo3NBzoOIkeHui+orTKVlqop9UiLl8nUwuo5w62/CDr5C
         HBeWqghZnvZV1B68SyUA0Rp5AVwSXsD92YmI0BsvRhmiNygEJC1Fr6y9R3/3ekorg195
         3JkA==
X-Gm-Message-State: AOAM531yqwqqVQfUeq0xqd6GSZlvjBO/QuVBGmnRBBTgHr66RxxLjdlv
        6pgOPKSWJkLw0ZL1AGrJaOE=
X-Google-Smtp-Source: ABdhPJz3WtBia9lsYiNtP36ly6C5/Spq+H8YUwiJhjB8D2sUUWuQU9zyuKAz/2H82/3raStSnz0L6A==
X-Received: by 2002:a5d:6d8b:0:b0:20a:97c4:bdc6 with SMTP id l11-20020a5d6d8b000000b0020a97c4bdc6mr10055827wrs.156.1650794040804;
        Sun, 24 Apr 2022 02:54:00 -0700 (PDT)
Received: from [0.0.0.0] ([95.179.233.4])
        by smtp.gmail.com with ESMTPSA id r6-20020a1c4406000000b0039229d3c4eesm5993941wma.12.2022.04.24.02.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 02:54:00 -0700 (PDT)
Message-ID: <0663e8e2-8c09-eee4-159a-f82c67eba80e@gmail.com>
Date:   Sun, 24 Apr 2022 17:53:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:100.0)
 Gecko/20100101 Thunderbird/100.0
Content-Language: en-US
To:     Steve French <sfrench@samba.org>
Cc:     kinglongmee@gmail.com, linux-cifs@vger.kernel.org
From:   Kinglong Mee <kinglongmee@gmail.com>
Subject: cifsFileInfo leak when doing cifs_atomic_open on a symlink file
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi steve,

Recently I've started running LTP tests with mfsymlinks mount option.

The LTP test "fs_racer" triggers the cifsFileInfo leak when doing
cifs_atomic_open on a symlink file.

After testing and umounting cifs mount, there are some files exist in
/proc/fs/cifs/open_files as,

#cat /proc/fs/cifs/open_files
# Version:1
# Format:
# <tree id> <persistent fid> <flags> <count> <pid> <uid> <filename>
0x2 0x94c08 0x8401 1 1554873 0 11
0x2 0x94b5f 0x8401 1 1554808 0 7
0x2 0x947cf 0x8401 1 1554365 0 0
0x2 0x9470a 0x8401 1 1554339 0 0

and the tcp socket also left,

# netstat -an |grep 445
tcp        0      0 192.168.123.123:38050    192.168.123.124:445 
ESTABLISHED

and the cifsd left too.

# ps -ajx |grep cifsd
       2   34030       0       0 ?             -1 S        0   2:20 [cifsd]

I found the fs_racer cause cifs doing cifs_atomic_open on symlink file,
but the symlink file does not contain a valid i_fop setting, it means,
the cifsFileInfo allocated for the symlink file never be un-referenced.

I'd wanna know, is cifs_atomic_open on symlink file allowed?
If allowed,  a cifs_close for symlink file is needed.
Otherwise, cifs_atomic_open needs return error for symlink file.

Any comments are welcome.

Thanks,
Kinglong Mee
