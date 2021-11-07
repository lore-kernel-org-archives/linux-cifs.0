Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D05FC433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 22:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74844613A6
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 22:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbhKGWyY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 17:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhKGWyX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 17:54:23 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C91C061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 14:51:40 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id o29so7758064wms.2
        for <linux-cifs@vger.kernel.org>; Sun, 07 Nov 2021 14:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FL2M/6fpwgxfP75702tqMKZn3JYvqBRV1o4PDTABw5I=;
        b=RZ2nGym/o7OnawzM9Xjokn0Ec/LzBM69EVqfNYgZZMeWAh/fFM/R6GW+wnQMccc/Vl
         qagpdshWPHajlBgjfPKtj4uGLuHD7FENvF0oM/2pXGWEd9LGsjTI9PFdIGYsGlc0QU8X
         esYMogo3nEByN9ubFXW3ibdzGiCwVdrx6z4pUR9Rd1aC9mwqZPCvfXbmyw2Sg8ypsitg
         sjzXRdju4M+l/x1AnMfVa0HQDlJ1LRMVandl8pai6yb1ScMHs3wf0/ZdhuW50RNN6ulY
         M/zLhjGtpBqm80rLt3/D0+z+SjhdS6T7IOjB1TtTU9+SunLJTyL2IEX3z0oJXhaFOX+c
         24QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FL2M/6fpwgxfP75702tqMKZn3JYvqBRV1o4PDTABw5I=;
        b=WVAowy/18gp1yTXKGlpPJyhOG9nlhAY854wMZKbNJowgr1pzntwh+ibyuOBp32p8V7
         1A8s2yX38GIOhq7grqk0oSowuAaHc/f/unfoq2hhfmiWqjsedKbGiTZQ9hq8h3yCJPmH
         4Hp/L9unvIF2bpkhQbFU11mDjyT3MneGMMyoVF0L8B2z7p1jUucoJM6kivWC/9LMT2zM
         V/0kLUTZU27uSY5z1AZQ2CJl8J86KbU5dyGTZbRbz2CAQ+/2bHtuD08xPMsi04w84FA6
         A3wwq0G1ELzTndQjsegSDKsbiQRkwAuCabCxm0IbuX9nlyJb3P91ThGNSkOv5DfwFgGf
         sqCQ==
X-Gm-Message-State: AOAM530wvsk+nCiQ2keFdDpNWfVUe3pzdlHBa3pYQV2kkBqQAwVOfYC6
        0jyB8kOBRc65+IqAUzgPkMc=
X-Google-Smtp-Source: ABdhPJwavKge/4F3HMPpszKKPKJVYqbdLwYfcZAZpVzwLBFb78gQk0sBoIosEhT3ZWPcVEE9b7dsbg==
X-Received: by 2002:a05:600c:b52:: with SMTP id k18mr47598557wmr.167.1636325498136;
        Sun, 07 Nov 2021 14:51:38 -0800 (PST)
Received: from ?IPV6:2a02:908:1980:7720::7039? ([2a02:908:1980:7720::7039])
        by smtp.gmail.com with ESMTPSA id 9sm18878087wry.0.2021.11.07.14.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Nov 2021 14:51:37 -0800 (PST)
Message-ID: <5c25c989-1e58-fb23-810f-a431024da11e@gmail.com>
Date:   Sun, 7 Nov 2021 23:51:37 +0100
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
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <YYhXjG46ZZ1tqpxJ@jeremy-acer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

W dniu 07.11.2021 o 23:47, Jeremy Allison pisze:
> On Sun, Nov 07, 2021 at 11:15:49PM +0100, Julian Sikorski wrote:
>> Hi,
>>
>> thanks for responding. I am using loglevel 10. I have uploaded the 
>> logs to my dropbox as they are too big to attach:
>>
>> https://www.dropbox.com/sh/r4b7q7ti2zmtlu9/AACqFY0FW2oW41Vu8l3nLZJSa?dl=0
>>
>> The problem happens around 15:45:48. Do the logs show what access mask 
>> the fsp is being opened with you requested?
>> I am using quite an old samba server (4.9.5+dfsg-5+deb10u1) due to the 
>> fact that openmediavault is based off debian 10 and there are no samba 
>> backports available. Having said that, this configuration can work, as 
>> shown by goffice/goffice-0.10.50-1.fc35.src.rpm rebuild and the fact 
>> that it was working before for months previously.
> 
> The error is occurring on the file:
> 
> /srv/dev-disk-by-label-omv/julian/kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35/goffice-devel-0.10.50-2.fc35.x86_64.rpm 
> 
> 
> this is a regular file, not a directory
> opened with ACCESS_MASK: 0x00120089
> 
> that is:
> 
> SEC_STD_SYNCHRONIZE|
> SEC_STD_READ_CONTROL|
> SEC_FILE_READ_ATTRIBUTE|
> SEC_FILE_READ_EA|
> SEC_FILE_READ_DATA
> 
> so indeed, this is being opened *without*
> SEC_FILE_WRITE_DATA|SEC_FILE_APPEND_DATA
> so smbd is correct in returning ACCESS_DENIED
> to an SMB2_FLUSH call.
> 
> Looks like this is a client bug, in that it
> is passing a Linux fsync(fd) call directly
> to the SMB2 server without checking if the
> underlying file is open for write access.
> 
> In this case, the SMB2 client should just
> return success to the caller, as any SMB_FLUSH
> call will always return ACCESS_DENIED on a
> non-writable file handle, and according to
> Linux semantics calling fsync(fd) on an fd
> open with O_RDNLY should return success.
> 
> Steve, over to you :-).
> 
> Jeremy.
Thanks, this looks promising. Do you have any guesses as to why it works 
for goffice-0.10.50-1.fc35 but not with goffice-0.10.50-2.fc35? Race 
condition?

Best regards,
Julian
