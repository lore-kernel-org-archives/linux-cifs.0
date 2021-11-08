Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF505C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Nov 2021 15:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F8C610FF
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Nov 2021 15:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239219AbhKHPzV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Nov 2021 10:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239214AbhKHPzU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Nov 2021 10:55:20 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DE8C061570
        for <linux-cifs@vger.kernel.org>; Mon,  8 Nov 2021 07:52:35 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id v127so13369484wme.5
        for <linux-cifs@vger.kernel.org>; Mon, 08 Nov 2021 07:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=WNduTZHOe2mXkFpKf2NkhQKsLLDEQYBRS1E9uw4jUUg=;
        b=YGAGAwGquvSHgrHnc0nQzEnnKlI7QoCozWmBQyzQJ95kIpRL9aMxx4MlCMpgwscjN1
         hT53dq/Fd0br4w70ImWSZzUH5hJCajtZL03IAyPPf5QMUHi8hdC2zW2iXFw9Sis0H/9E
         7Beic7e9O/A2zBGu4gw3hfslq79CIBg4ta4eCnVNGI9hic8LCxMn03NUqYkfXSfaLyBS
         XbW/U0MXHrbJ6FPehZuQPDb9Kq/RGBYAjBrlFuswX5AIsfBNeI6R//u3x5CBxaBabLMe
         8lA9gvtqoo2jtMGC3fDn+xNh3Qnr2IHDpWY1HTo29kPurrgd8RC7vQB/UChtnqhwMld5
         CQ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=WNduTZHOe2mXkFpKf2NkhQKsLLDEQYBRS1E9uw4jUUg=;
        b=0KfmPtfVAs636tcZtdTLFn2n6wCWI5TMxPjpKuIXkM74bQeKzJjyrEBrHNT4sEXVR/
         u9IBT9GQkE5iT5YtomHxRLjxjQ8ptMzSy6HkeacNSQRTjRSSGMQBK7iDon+qF5Bos95h
         OXnti3/UH3sLKRGx+6dAjrWPxrsemKrLVr4cEI1sXkIAb1+VsRqeJgzv0Uk4P8ejsxE0
         LD9hFcNvzqFJCsbK9flvfWorxPh0tcOViO67lWXYG0FLk0qOcHtpyW76KVNS9HGsELoj
         RHrin5DGnhNmPagJnXEUULzlHmY310JCrLES2MaQWO7o1yIDFfbaycHGm+3K24jr3KUn
         8nzg==
X-Gm-Message-State: AOAM530Ik3gUCKOG6baxDYW7IBWZtIdgzx+deHrsVyVPHlUoFbKqZIVX
        F3eF8n4/dmrP+QQjzIK73nQ=
X-Google-Smtp-Source: ABdhPJzUyzycznvt3Bn7ztKLWQYQ7zqp58jp3w/7hV862mbm/jougNhp68X9aMOWgQQ5DoLPrrnKYQ==
X-Received: by 2002:a05:600c:1989:: with SMTP id t9mr328545wmq.24.1636386751872;
        Mon, 08 Nov 2021 07:52:31 -0800 (PST)
Received: from ?IPV6:2a02:908:1980:7720::7039? ([2a02:908:1980:7720::7039])
        by smtp.gmail.com with ESMTPSA id z15sm17582907wrr.65.2021.11.08.07.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 07:52:31 -0800 (PST)
Message-ID: <3c1d5ba0-74f6-d281-c50a-74046eb68708@gmail.com>
Date:   Mon, 8 Nov 2021 16:52:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Permission denied when chainbuilding packages with mock
Content-Language: en-US
From:   Julian Sikorski <belegdol@gmail.com>
To:     Jeremy Allison <jra@samba.org>
Cc:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
 <YYhI1bpioEOXnFYf@jeremy-acer> <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com>
 <YYhXjG46ZZ1tqpxJ@jeremy-acer>
 <5c25c989-1e58-fb23-810f-a431024da11e@gmail.com>
 <YYiCAcxxnIbHz4xv@jeremy-acer>
 <cd649ed2-60d3-72e3-e09a-9f0074af99cc@gmail.com>
In-Reply-To: <cd649ed2-60d3-72e3-e09a-9f0074af99cc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

W dniu 08.11.2021 o 07:59, Julian Sikorski pisze:
> 
> 
> Am 08.11.21 um 02:48 schrieb Jeremy Allison:
>> On Sun, Nov 07, 2021 at 11:51:37PM +0100, Julian Sikorski wrote:
>>
>>> Thanks, this looks promising. Do you have any guesses as to why it 
>>> works for goffice-0.10.50-1.fc35 but not with goffice-0.10.50-2.fc35? 
>>> Race condition?
>>
>> No clue, sorry. I'd need to see comparative traces - but all that
>> will tell me is that it isn't doing the fsync on a read-only file.
> 
> I will try to generate a log for the working case later. Having said 
> that, the question becomes: why are some files read-only but others are 
> not, when they are generated by the same software in the same folder? 
> The permissions on both folders are exactly the same:
> 
> $ ls -l 
> /mnt/openmediavault/kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35/
> 
> insgesamt 15360
> 
> -rwxr-xr-x. 1 julas julas  864488  7. Nov 23:53 build.log
> 
> -rwxr-xr-x. 1 julas julas 2443249  7. Nov 16:39 
> goffice-0.10.50-2.fc35.src.rpm
> 
> -rwxr-xr-x. 1 julas julas 2051776  7. Nov 16:39 
> goffice-0.10.50-2.fc35.x86_64.rpm
> 
> -rwxr-xr-x. 1 julas julas 2195483  7. Nov 16:39 
> goffice-debuginfo-0.10.50-2.fc35.x86_64.rpm
> 
> -rwxr-xr-x. 1 julas julas  967394  7. Nov 16:39 
> goffice-debugsource-0.10.50-2.fc35.x86_64.rpm
> 
> -rwxr-xr-x. 1 julas julas  339221  7. Nov 16:39 
> goffice-devel-0.10.50-2.fc35.x86_64.rpm
> 
> -rwxr-xr-x. 1 julas julas    3050  7. Nov 16:38 hw_info.log
> 
> -rwxr-xr-x. 1 julas julas   37268  7. Nov 16:38 installed_pkgs.log
> 
> drwxr-xr-x. 2 julas julas       0  7. Nov 16:39 repodata
> 
> -rwxr-xr-x. 1 julas julas  301702  7. Nov 23:53 root.log
> 
> -rwxr-xr-x. 1 julas julas    1710  7. Nov 23:53 state.log
> 
> -rwxr-xr-x. 1 julas julas       0  7. Nov 16:39 success
> 
> $ ls -l 
> /mnt/openmediavault/kernel/results/fedora-35-x86_64/goffice-0.10.50-1.fc35/
> 
> insgesamt 15360
> 
> -rwxr-xr-x. 1 julas julas  864469  7. Nov 16:34 build.log
> 
> -rwxr-xr-x. 1 julas julas 2443099  7. Nov 16:30 
> goffice-0.10.50-1.fc35.src.rpm
> 
> -rwxr-xr-x. 1 julas julas 2051631  7. Nov 16:30 
> goffice-0.10.50-1.fc35.x86_64.rpm
> 
> -rwxr-xr-x. 1 julas julas 2192839  7. Nov 16:30 
> goffice-debuginfo-0.10.50-1.fc35.x86_64.rpm
> 
> -rwxr-xr-x. 1 julas julas  967236  7. Nov 16:30 
> goffice-debugsource-0.10.50-1.fc35.x86_64.rpm
> 
> -rwxr-xr-x. 1 julas julas  339086  7. Nov 16:30 
> goffice-devel-0.10.50-1.fc35.x86_64.rpm
> 
> -rwxr-xr-x. 1 julas julas    3050  7. Nov 16:29 hw_info.log
> 
> -rwxr-xr-x. 1 julas julas   37268  7. Nov 16:29 installed_pkgs.log
> 
> drwxr-xr-x. 2 julas julas       0  7. Nov 16:30 repodata
> 
> -rwxr-xr-x. 1 julas julas  301199  7. Nov 16:34 root.log
> 
> -rwxr-xr-x. 1 julas julas    1665  7. Nov 16:34 state.log
> 
> -rwxr-xr-x. 1 julas julas       0  7. Nov 16:30 success
> 
> 
> The other explanation could be that the software (mock) runs fsync on 
> some of the files but not on others.
> 
> Best regards,
> Julian
I have now generated the logs from the working case:

https://www.dropbox.com/sh/9ucxoeia727xu3k/AABYiTQ0aBqCqnNL9Vz3Jch8a?dl=0

the moment at which failure would have happened is around 16:46:11.

Best regards,
Julian
