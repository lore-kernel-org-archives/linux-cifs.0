Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82876C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Nov 2021 06:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CA1F60041
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Nov 2021 06:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbhKHHCi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Nov 2021 02:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236228AbhKHHCi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Nov 2021 02:02:38 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4283CC061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 22:59:54 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id w29so13472392wra.12
        for <linux-cifs@vger.kernel.org>; Sun, 07 Nov 2021 22:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eSQoeDSXMMzLY6iODEPniszxO3pN2Bx/5/cHRWgFuhs=;
        b=Qccck73yUS4yZMZ/s21r7Hn6EHyZG+VFkxl2zBCgrjK8e12lxBrx/b3ud8i6c5yK3k
         BrHlHh2Yfix3h2yboJ7KlY9jO86Ulu15gbpLAia5zDbrLkm38d1DAPkuU2Sy5qiDh82n
         TwFaIuVkJnP3lCZTiberHvy5YIb0lMzCL/+mLQO3D+1Wu1tb+nAUt7KANTL1YfbzxcFh
         1tjrTwSdvwoHtqNYqZRJHe9sjfAXGa3oXf/3uW9g0qvpskPaRSTDoLMTUPEbgJ2Yvh8e
         Kd0AhcK04iWjvVLEsgD2wq1y/QnqDEL7WbYNxrt4Ui2EaT2oueKKoERbnU6lqICFd+xB
         KIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eSQoeDSXMMzLY6iODEPniszxO3pN2Bx/5/cHRWgFuhs=;
        b=isIiDq4XcxWVxmXMzW3LsrRSmpMOCARqh/a98yMZDX9GfIcAJkA+fGTuhqp2Zilk15
         GG++2Az3bPw7lmgJMTyJOP7JeiV9HAKTC7Ct7RzVcf71VD9XjKtFDxR14uvbC798CvxR
         H8KIbcLg06gFsfVBOK+dJG05ehawelRmRdQaZJk0Mo1GGm1ewePQsdGjKH0xpGwRP39x
         VHrmPbAJZXLeCBtFVHoOlgXENy1+e5cZfcC2udAIPmeUfkGoUPchg/YxdDhnidY8cWqD
         Bf+lTYEzMiITk5nEnS36LbfvLeX2m00qLRlm8BA2JH9MBXqsmxgTgmw1DBnGaf7aWeX+
         j9AQ==
X-Gm-Message-State: AOAM533AQxjuaxWrxl0wKfU/neuXJ4XuBhwt7oNGR+Hp1HTUjFaq1Rx5
        U5J+Xy2DWnMT5POcHA6oYqa7L6eXal+veA==
X-Google-Smtp-Source: ABdhPJzHGI+5f++puQBYQjA/FuZPwDlNkoi3WWXtl/Rp5RlInlQWFuahTaixEvOgwV/0awLsvllaeQ==
X-Received: by 2002:a5d:648e:: with SMTP id o14mr46544982wri.141.1636354792843;
        Sun, 07 Nov 2021 22:59:52 -0800 (PST)
Received: from ?IPV6:2a02:908:1980:7720::cf8b? ([2a02:908:1980:7720::cf8b])
        by smtp.gmail.com with ESMTPSA id e3sm15511144wrp.8.2021.11.07.22.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Nov 2021 22:59:52 -0800 (PST)
Message-ID: <cd649ed2-60d3-72e3-e09a-9f0074af99cc@gmail.com>
Date:   Mon, 8 Nov 2021 07:59:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Permission denied when chainbuilding packages with mock
Content-Language: en-US
To:     Jeremy Allison <jra@samba.org>
Cc:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
 <YYhI1bpioEOXnFYf@jeremy-acer> <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com>
 <YYhXjG46ZZ1tqpxJ@jeremy-acer>
 <5c25c989-1e58-fb23-810f-a431024da11e@gmail.com>
 <YYiCAcxxnIbHz4xv@jeremy-acer>
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <YYiCAcxxnIbHz4xv@jeremy-acer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



Am 08.11.21 um 02:48 schrieb Jeremy Allison:
> On Sun, Nov 07, 2021 at 11:51:37PM +0100, Julian Sikorski wrote:
> 
>> Thanks, this looks promising. Do you have any guesses as to why it 
>> works for goffice-0.10.50-1.fc35 but not with goffice-0.10.50-2.fc35? 
>> Race condition?
> 
> No clue, sorry. I'd need to see comparative traces - but all that
> will tell me is that it isn't doing the fsync on a read-only file.

I will try to generate a log for the working case later. Having said 
that, the question becomes: why are some files read-only but others are 
not, when they are generated by the same software in the same folder? 
The permissions on both folders are exactly the same:

$ ls -l 
/mnt/openmediavault/kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35/

insgesamt 15360

-rwxr-xr-x. 1 julas julas  864488  7. Nov 23:53 build.log

-rwxr-xr-x. 1 julas julas 2443249  7. Nov 16:39 
goffice-0.10.50-2.fc35.src.rpm

-rwxr-xr-x. 1 julas julas 2051776  7. Nov 16:39 
goffice-0.10.50-2.fc35.x86_64.rpm

-rwxr-xr-x. 1 julas julas 2195483  7. Nov 16:39 
goffice-debuginfo-0.10.50-2.fc35.x86_64.rpm

-rwxr-xr-x. 1 julas julas  967394  7. Nov 16:39 
goffice-debugsource-0.10.50-2.fc35.x86_64.rpm

-rwxr-xr-x. 1 julas julas  339221  7. Nov 16:39 
goffice-devel-0.10.50-2.fc35.x86_64.rpm

-rwxr-xr-x. 1 julas julas    3050  7. Nov 16:38 hw_info.log

-rwxr-xr-x. 1 julas julas   37268  7. Nov 16:38 installed_pkgs.log

drwxr-xr-x. 2 julas julas       0  7. Nov 16:39 repodata

-rwxr-xr-x. 1 julas julas  301702  7. Nov 23:53 root.log

-rwxr-xr-x. 1 julas julas    1710  7. Nov 23:53 state.log

-rwxr-xr-x. 1 julas julas       0  7. Nov 16:39 success

$ ls -l 
/mnt/openmediavault/kernel/results/fedora-35-x86_64/goffice-0.10.50-1.fc35/

insgesamt 15360

-rwxr-xr-x. 1 julas julas  864469  7. Nov 16:34 build.log

-rwxr-xr-x. 1 julas julas 2443099  7. Nov 16:30 
goffice-0.10.50-1.fc35.src.rpm

-rwxr-xr-x. 1 julas julas 2051631  7. Nov 16:30 
goffice-0.10.50-1.fc35.x86_64.rpm

-rwxr-xr-x. 1 julas julas 2192839  7. Nov 16:30 
goffice-debuginfo-0.10.50-1.fc35.x86_64.rpm

-rwxr-xr-x. 1 julas julas  967236  7. Nov 16:30 
goffice-debugsource-0.10.50-1.fc35.x86_64.rpm

-rwxr-xr-x. 1 julas julas  339086  7. Nov 16:30 
goffice-devel-0.10.50-1.fc35.x86_64.rpm

-rwxr-xr-x. 1 julas julas    3050  7. Nov 16:29 hw_info.log

-rwxr-xr-x. 1 julas julas   37268  7. Nov 16:29 installed_pkgs.log

drwxr-xr-x. 2 julas julas       0  7. Nov 16:30 repodata

-rwxr-xr-x. 1 julas julas  301199  7. Nov 16:34 root.log

-rwxr-xr-x. 1 julas julas    1665  7. Nov 16:34 state.log

-rwxr-xr-x. 1 julas julas       0  7. Nov 16:30 success


The other explanation could be that the software (mock) runs fsync on 
some of the files but not on others.

Best regards,
Julian
