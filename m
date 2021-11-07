Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DCCDC433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 22:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00A3F6125F
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 22:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbhKGWSg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 17:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbhKGWSg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 17:18:36 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508A4C061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 14:15:52 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d24so23609819wra.0
        for <linux-cifs@vger.kernel.org>; Sun, 07 Nov 2021 14:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=xXwrrirbo47P1Dc32rpY3wgGbF8SdXEqpgy6ic5JuPA=;
        b=HY9BU0oAFu41OD3C8hCsm8ZThCb0rfo87roxRDJ4/R4zlZFgInxacWytO+P1bL9msg
         ROhYdHw7Nb6j2cBolhYfgXKcnwtluhczsvHRzEB5euuOYKndaJiqRo5/ShZyUXwp7GwQ
         po7XP0XrcHW692U4/HMMyQerxIGgseyfso0hn2SnhptKHu7BrZJ+xe+VxQyIm7C5r5gW
         NmwvMeSKj0vMunEuGa/jB5ws/7E5arwUK7ie+wTpQ4ql959zmN8mhuV1gCVgFx1mmLv4
         +pA5W7aMHyBLmEt5AmvoEYmYp75Ius2AODt+fs3aLKqnYqCUedRSedlU/WAOI81sbH11
         XtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xXwrrirbo47P1Dc32rpY3wgGbF8SdXEqpgy6ic5JuPA=;
        b=DM6zZmpp8HK1fY6VwTub1+XccDVW3por0iDoe5cGJNALQdLCnJ8MI2zVI7lIO+SfOZ
         t85tD2GrwQdWCRqsFnq2owtljlTBf3xTapK6gBkNIOhjTJhPLAhrVRCJZ+iK0mk4a9SY
         H9yHcXUYvx2Ws/nxFpxPobxuJwIELjHH7XEGZMWwWfJYc+dGQ4tvC75vJfj90LmOFWry
         EUV4O2r5QlK/ZiooQuZcwRzwW3rYh3vA7/21Xz1UoKoHkbwvdaWgJwXQagYfTSRHQ6P/
         fDgaa79IoGqu1L52Q2YcW3SkeZKpLAh0r8W14wUx4Biw3dRZJ/yTq4t/DytocYSFd5Js
         ID2Q==
X-Gm-Message-State: AOAM533KYLEZZvvcQMkaxVRkeA6cz4pyoXHT064R+8hzUpm89R7ZNBiL
        TzOBqUN9CdCoD5Fk/N1oxtPNzdaWAXsD1A==
X-Google-Smtp-Source: ABdhPJwj0YZlB/LvVvYRcAT81Q1gErXlI8S5EeS46u97wbvWZ4zz8NFHZA3oNvbeRfDhvUPlMDzWXw==
X-Received: by 2002:adf:e9c5:: with SMTP id l5mr74415013wrn.218.1636323350889;
        Sun, 07 Nov 2021 14:15:50 -0800 (PST)
Received: from ?IPV6:2a02:908:1980:7720::7039? ([2a02:908:1980:7720::7039])
        by smtp.gmail.com with ESMTPSA id 9sm18796892wry.0.2021.11.07.14.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Nov 2021 14:15:50 -0800 (PST)
Message-ID: <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com>
Date:   Sun, 7 Nov 2021 23:15:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Permission denied when chainbuilding packages with mock
Content-Language: en-US
To:     Jeremy Allison <jra@samba.org>, linux-cifs@vger.kernel.org
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
 <YYhI1bpioEOXnFYf@jeremy-acer> <YYhJ+8ehPFX1XDhv@jeremy-acer>
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <YYhJ+8ehPFX1XDhv@jeremy-acer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

W dniu 07.11.2021 o 22:49, Jeremy Allison pisze:
> On Sun, Nov 07, 2021 at 01:44:53PM -0800, Jeremy Allison wrote:
>> On Sun, Nov 07, 2021 at 10:10:17PM +0100, Julian Sikorski wrote:
>>>
>>> but it is not really clear _why_ is the access being denied. Any 
>>> ideas where to look? Thanks!
>>
>> What debug log level are you using on th server ? To debug
>> something like this use log level 10.
>>
>> fsync failed: Permission denied
>>
>> is strange. I need to see what access mask the fsp is being
>> opened with. If it's a directory, it might be running into
>> this (from smbd_smb2_flush_send()):
>>
>>        if (!CHECK_WRITE(fsp)) {
>>                bool allow_dir_flush = false;
>>                uint32_t flush_access = FILE_ADD_FILE | 
>> FILE_ADD_SUBDIRECTORY;
>>
>>                if (!fsp->fsp_flags.is_directory) {
>>                        tevent_req_nterror(req, NT_STATUS_ACCESS_DENIED);
>>                        return tevent_req_post(req, ev);
>>                }
>>
>>                /*
>>                 * Directories are not writable in the conventional
>>                 * sense, but if opened with *either*
>>                 * FILE_ADD_FILE or FILE_ADD_SUBDIRECTORY
>>                 * they can be flushed.
>>                 */
>>
>>                if ((fsp->access_mask & flush_access) != 0) {
>>                        allow_dir_flush = true;
>>                }
>>
>>                if (allow_dir_flush == false) {
>>                        tevent_req_nterror(req, NT_STATUS_ACCESS_DENIED);
>>                        return tevent_req_post(req, ev);
>>                }
>>        }
>>
>> as 'man 2 fsync' on Linux doesn't show EACCES as a possible return
>> error from fsync.
>>
>> If this is the case, then the client redirector is relying on 
>> Linux-specific
>> behavior. From 'man 2 fsync':
>>
>> NOTES
>>       On some UNIX systems (but not Linux), fd must be a writable file 
>> descriptor.
> 
> If this is actually what is happening, Samba is implementing the
> Windows semantics, and not the Linux ones (as we should). From
> the Microsoft MS-SMB2 spec:
> 
> https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/026984f6-38af-4408-8200-50557eb0a286 
> 
> 
> --------------------------------------------------------------------------
> 3.3.5.11 Receiving an SMB2 FLUSH Request
> 10/04/2021
> 
> When the server receives a request with an SMB2 header with a Command value
> equal to SMB2 FLUSH, message handling proceeds as follows:
> 
> The server MUST locate the session, as specified in section 3.3.5.2.9.
> 
> The server MUST locate the tree connection, as specified in section 
> 3.3.5.2.11.
> 
> Next the server MUST locate the open being flushed by performing
> a lookup in the Session.OpenTable, using the FileId.Volatile of the
> request as the lookup key. If no open is found, or if Open.DurableFileId
> is not equal to FileId.Persistent, the server MUST fail the request
> with STATUS_FILE_CLOSED. Otherwise, the server MUST locate the Request
> in Connection.RequestList for which Request.MessageId matches
> the MessageId value in the SMB2 header, and set Request.Open to the Open.
> 
> If the Open is on a file and Open.GrantedAccess includes neither
> FILE_WRITE_DATA nor FILE_APPEND_DATA, the server MUST fail the
> request with STATUS_ACCESS_DENIED.
> 
> If the Open is on a directory and Open.GrantedAccess includes
> neither FILE_ADD_FILE nor FILE_ADD_SUBDIRECTORY, the server MUST
> fail the request with STATUS_ACCESS_DENIED.
> --------------------------------------------------------------------------

Hi,

thanks for responding. I am using loglevel 10. I have uploaded the logs 
to my dropbox as they are too big to attach:

https://www.dropbox.com/sh/r4b7q7ti2zmtlu9/AACqFY0FW2oW41Vu8l3nLZJSa?dl=0

The problem happens around 15:45:48. Do the logs show what access mask 
the fsp is being opened with you requested?
I am using quite an old samba server (4.9.5+dfsg-5+deb10u1) due to the 
fact that openmediavault is based off debian 10 and there are no samba 
backports available. Having said that, this configuration can work, as 
shown by goffice/goffice-0.10.50-1.fc35.src.rpm rebuild and the fact 
that it was working before for months previously.

Best regards,
Julian
