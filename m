Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061EDC433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 21:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF5B361076
	for <linux-cifs@archiver.kernel.org>; Sat, 18 Sep 2021 21:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbhIRViQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 18 Sep 2021 17:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232932AbhIRViP (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 18 Sep 2021 17:38:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99CA461076
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 21:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632001011;
        bh=U6GWh3Q/GXK7mEd0YhLxeVzEH7s6uwX5nVMe8d7AMPY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=tKrRct0P69wgs6ThQ1F+ZMnU9xe4fRsvwTIr3MgMFsLWUGSH+RgHAj3cww1SjpgUh
         QaCnvlNU/wYbPxyyZE7+9H73Dj3ZQm9VLMqGM5BLZDFcNEACrY7jZY1XOCO/U12anl
         AG0/hKsnOIHpSxPPNdjvJGnPY3lj3BrvXW2cT28Pdhce3UurYUfkihB7nQAqm6LTAn
         80vzusBQRdxf7pymDLfUUDMLI3GpT4DSUUqVDOp6FGHvsYJQNnKt7d2EaWinhRhp/h
         JOMuzHzmpdbG1NJX8KrQXUMLGucNh+WgPEALiTG4NKHIv2x6I1sbSZMYQpc2A9513S
         yJqAmM91xy0CA==
Received: by mail-ot1-f44.google.com with SMTP id 97-20020a9d006a000000b00545420bff9eso11005609ota.8
        for <linux-cifs@vger.kernel.org>; Sat, 18 Sep 2021 14:36:51 -0700 (PDT)
X-Gm-Message-State: AOAM531H+MvR/ohXAljPSgQ5RQFPBw5NdgIEscPjzm+Tu7ana9GlEroQ
        c1riN6cz20Avu6AzYMrEfFmNq6Ooypx5J9gl3Nw=
X-Google-Smtp-Source: ABdhPJya0I8EUttR/E79+ZRblxEPvRlvMTBmYS7VmZZsFFs35mTQMgDBoZBmoaFNoOs5ghWnL3ln2F4e0kc1BOw8raU=
X-Received: by 2002:a9d:36d:: with SMTP id 100mr15020251otv.237.1632001010858;
 Sat, 18 Sep 2021 14:36:50 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sat, 18 Sep 2021 14:36:50
 -0700 (PDT)
In-Reply-To: <ac18e062-e835-b575-66af-72631df7ef7d@talpey.com>
References: <20210918120239.96627-1-linkinjeon@kernel.org> <ac18e062-e835-b575-66af-72631df7ef7d@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 19 Sep 2021 06:36:50 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8kcZY_BbtOeKXR2ycH+tOSjYkNev=yhznH6Hbx-QEKMg@mail.gmail.com>
Message-ID: <CAKYAXd8kcZY_BbtOeKXR2ycH+tOSjYkNev=yhznH6Hbx-QEKMg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add default data stream name in FILE_STREAM_INFORMATION
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Tom,
2021-09-18 21:39 GMT+09:00, Tom Talpey <tom@talpey.com>:
> This doesn't appear to be what's documented in MS-FSA section 2.1.5.11.29.
> There, it appears to call for returning an empty stream list,
> and STATUS_SUCCESS, when no streams are present.
As I know, Specification doesn't describe all windows behavior. So
smbtorture testcase test such corner cases.
>
> Also, why does the code special-case directories? The conditionals
> on StreamSize and StreamAllocation size are entirely redundant,
> after the top-level if (!S_ISDIR...), btw.
As I know, default data stream(::DATA) is for only file, not
directory. And streams tests in smbtorture pass, Please see:

$ ./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234 smb2.streams.dir
smbtorture 4.10.6
Using seed 1631969885
time: 2021-09-18 12:58:05.268099
test: dir
time: 2021-09-18 12:58:05.268848
teststreams\stream.txt:Stream One
(../../source4/torture/smb2/streams.c:248) opening non-existent directory stream
(../../source4/torture/smb2/streams.c:263) opening basedir  stream
(../../source4/torture/smb2/streams.c:279) opening basedir ::$DATA stream
(../../source4/torture/smb2/streams.c:295) list the streams on the basedir
time: 2021-09-18 12:58:05.313561
success: dir
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.dir" exited with 0.
0.11s$ ./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234 smb2.streams.io
smbtorture 4.10.6
Using seed 1631969885
time: 2021-09-18 12:58:05.357178
test: io
time: 2021-09-18 12:58:05.357884
(../../source4/torture/smb2/streams.c:335) creating a stream on a
non-existent file
(../../source4/torture/smb2/streams.c:355) check that open of base
file is allowed
(../../source4/torture/smb2/streams.c:362) writing to stream
(../../source4/torture/smb2/streams.c:377) modifying stream
(../../source4/torture/smb2/streams.c:387) creating a stream2 on a existing file
(../../source4/torture/smb2/streams.c:394) modifying stream
(../../source4/torture/smb2/streams.c:431) deleting stream
(../../source4/torture/smb2/streams.c:444) delete a stream via delete-on-close
(../../source4/torture/smb2/streams.c:476) deleting file
time: 2021-09-18 12:58:05.422830
success: io
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.io" exited with 0.
0.09s$ ./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.sharemodes
smbtorture 4.10.6
Using seed 1631969885
time: 2021-09-18 12:58:05.467364
test: sharemodes
time: 2021-09-18 12:58:05.468186
(../../source4/torture/smb2/streams.c:592) Testing stream share mode conflicts
time: 2021-09-18 12:58:05.521840
success: sharemodes
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.sharemodes" exited with 0.
0.10s$ ./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.names
smbtorture 4.10.6
Using seed 1631969885
time: 2021-09-18 12:58:05.565595
test: names
time: 2021-09-18 12:58:05.566433
(../../source4/torture/smb2/streams.c:869) testing stream names
time: 2021-09-18 12:58:05.626686
success: names
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.names" exited with 0.
0.12s$ ./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.names2
smbtorture 4.10.6
Using seed 1631969885
time: 2021-09-18 12:58:05.671829
test: names2
time: 2021-09-18 12:58:05.672704
(../../source4/torture/smb2/streams.c:1160) testing stream names
time: 2021-09-18 12:58:05.751656
success: names2
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.names2" exited with 0.
0.08s$ ./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.names3
smbtorture 4.10.6
Using seed 1631969885
time: 2021-09-18 12:58:05.796248
test: names3
time: 2021-09-18 12:58:05.797156
(../../source4/torture/smb2/streams.c:1288) testing case insensitive
stream names
time: 2021-09-18 12:58:05.835048
success: names3
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.names3" exited with 0.
0.10s$ ./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.rename
smbtorture 4.10.6
Using seed 1631969885
time: 2021-09-18 12:58:05.879226
test: rename
time: 2021-09-18 12:58:05.880108
(../../source4/torture/smb2/streams.c:1379) testing stream renames
time: 2021-09-18 12:58:05.938765
success: rename
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.rename" exited with 0.
0.11s$ ./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.rename2
smbtorture 4.10.6
Using seed 1631969885
time: 2021-09-18 12:58:05.983358
test: rename2
time: 2021-09-18 12:58:05.984182
(../../source4/torture/smb2/streams.c:1504) Checking SMB2 rename of a
stream using :<stream>
(../../source4/torture/smb2/streams.c:1518) Checking SMB2 rename of an
overwriting stream using :<stream>
(../../source4/torture/smb2/streams.c:1548) Checking SMB2 rename of a
stream using <base>:<stream>
(../../source4/torture/smb2/streams.c:1559) Checking SMB2 rename to
default stream using :<stream>
time: 2021-09-18 12:58:06.048102
success: rename2
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.rename2" exited with 0.
0.10s$ ./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.create-disposition
smbtorture 4.10.6
Using seed 1631969886
time: 2021-09-18 12:58:06.094196
test: create-disposition
time: 2021-09-18 12:58:06.095203
(../../source4/torture/smb2/streams.c:1666) Checking create disp: open
(../../source4/torture/smb2/streams.c:1680) Checking create disp: overwrite
(../../source4/torture/smb2/streams.c:1694) Checking create disp: overwrite_if
(../../source4/torture/smb2/streams.c:1712) Checking create disp: supersede
(../../source4/torture/smb2/streams.c:1732) Checking create disp:
overwrite_if on stream
time: 2021-09-18 12:58:06.148406
success: create-disposition
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.create-disposition" exited with 0.
0.10s$ ./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.attributes
smbtorture 4.10.6
Using seed 1631969886
time: 2021-09-18 12:58:06.192777
test: attributes
time: 2021-09-18 12:58:06.193624
(../../source4/torture/smb2/streams.c:1810) testing attribute setting on stream
time: 2021-09-18 12:58:06.256161
success: attributes
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.attributes" exited with 0.
0.09s$ ./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.zero-byte
smbtorture 4.10.6
Using seed 1631969886
time: 2021-09-18 12:58:06.302540
test: zero-byte
time: 2021-09-18 12:58:06.303431
(../../source4/torture/smb2/streams.c:512) Check 0 byte named stream
time: 2021-09-18 12:58:06.353826
success: zero-byte
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.zero-byte" exited with 0.
0.21s$ ./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.basefile-rename-with-open-stream
smbtorture 4.10.6
Using seed 1631969886
time: 2021-09-18 12:58:06.397700
test: basefile-rename-with-open-stream
time: 2021-09-18 12:58:06.398478
Creating file with stream
Writing to stream
Renaming base file
time: 2021-09-18 12:58:06.565832
success: basefile-rename-with-open-stream
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.streams.basefile-rename-with-open-stream" exited with 0.
>
> I'd suggest asking Microsoft dochelp for clarification before
> implementing this.
I'm not sure I'll get the answer I want from the dochelp quickly. I
vote we can apply this patch to fix existing issue, and parallel
contact the dochelp and update the code if there is some points.

Thanks!
>
> Tom.
>
> On 9/18/2021 8:02 AM, Namjae Jeon wrote:
>> Windows client expect to get default stream name(::DATA) in
>> FILE_STREAM_INFORMATION response even if there is no stream data in file.
>> This patch fix update failure when writing ppt or doc files.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/smb2pdu.c | 8 +++-----
>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 49a1ca75f427..301605e0cbf7 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -4465,17 +4465,15 @@ static void get_file_stream_info(struct ksmbd_work
>> *work,
>>   		file_info->NextEntryOffset = cpu_to_le32(next);
>>   	}
>>
>> -	if (nbytes) {
>> +	if (!S_ISDIR(stat.mode)) {
>>   		file_info = (struct smb2_file_stream_info *)
>>   			&rsp->Buffer[nbytes];
>>   		streamlen = smbConvertToUTF16((__le16 *)file_info->StreamName,
>>   					      "::$DATA", 7, conn->local_nls, 0);
>>   		streamlen *= 2;
>>   		file_info->StreamNameLength = cpu_to_le32(streamlen);
>> -		file_info->StreamSize = S_ISDIR(stat.mode) ? 0 :
>> -			cpu_to_le64(stat.size);
>> -		file_info->StreamAllocationSize = S_ISDIR(stat.mode) ? 0 :
>> -			cpu_to_le64(stat.size);
>> +		file_info->StreamSize = 0;
>> +		file_info->StreamAllocationSize = 0;
>>   		nbytes += sizeof(struct smb2_file_stream_info) + streamlen;
>>   	}
>>
>>
>
