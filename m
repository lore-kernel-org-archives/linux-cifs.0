Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CE0C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 00:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67BD4610A5
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 00:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhKJA4z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhKJA4z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Nov 2021 19:56:55 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F8BC061764
        for <linux-cifs@vger.kernel.org>; Tue,  9 Nov 2021 16:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=pOpAn6ZXdXMxDlk2kQlIYGpqwdXcWbkNFTTihurcUBc=; b=QjBY5s/Pxpsca7ZJKV2tJTAWX8
        4h1riQ7ONUmAKlr39UJq45KpI3M89rjwtGG//KK0jCO7jJKuRjLbLghSISc/bWwo9wJf617qL2r3c
        aRjwVSaOSAZmAkiO3nBpiaCDKScAnxZYNBK4TDDfd82updloay8yFOaQW+T8Imjwn8GMw2eAR+5RG
        2iw+BMnbgiC8FJ5t5luveU0ajA1fqufECM/zvjqZMQxTP43vxuxodRdJlQoLY7Jd3D/XgbH00Kmbk
        hSn87JIoOYXdCnk5uP7xEmRuHeLhFxpaqWiiPUz2aHZukebNft7a6RhkjediKz3TZ6HAGYONLhxFu
        y9FR7p7omVtwBzl2Ew3RYWp8afaBrWDMKLRjQ59h4XXkv0GjlYLQagwar2SgnBcmpwv00lnGRKWhC
        w6+SNZKlxh4UpHGBDTuxzK6CNi6VIF+Ryo7dbBoXcZBDDO5+zc0FU4F3aDK1708V5j8E30um4VpS4
        dsiBAbF93/ANPXc2c+YzgUG6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mkbsL-006Hmj-DZ; Wed, 10 Nov 2021 00:54:05 +0000
Date:   Tue, 9 Nov 2021 16:54:02 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Julian Sikorski <belegdol@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Permission denied when chainbuilding packages with mock
Message-ID: <YYsYKvyevyXjHgku@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <YYhI1bpioEOXnFYf@jeremy-acer>
 <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com>
 <YYhXjG46ZZ1tqpxJ@jeremy-acer>
 <5c25c989-1e58-fb23-810f-a431024da11e@gmail.com>
 <YYiCAcxxnIbHz4xv@jeremy-acer>
 <cd649ed2-60d3-72e3-e09a-9f0074af99cc@gmail.com>
 <YYlUgc6UOyKfZr7d@jeremy-acer>
 <CAH2r5muWLJu_Yhx1pv0rCaTRPqeEd_8X8DP2cipUVaMekU9xFg@mail.gmail.com>
 <eadd8209-7dcf-30fe-2c8e-cc0fd7c823a1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <eadd8209-7dcf-30fe-2c8e-cc0fd7c823a1@gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Nov 09, 2021 at 10:26:59AM +0100, Julian Sikorski wrote:
>Am 09.11.21 um 09:10 schrieb Steve French:
>>Yes - here is a trivial reproducer (excuse the ugly sample cut-n-paste)
>>
>>#include <stdio.h>
>>#include <stdlib.h>
>>#include <unistd.h>
>>#include <string.h>
>>#include <fcntl.h>
>>#include <sys/types.h>
>>#include <sys/stat.h>
>>
>>int main(int argc, char *argv[]) {
>>char *str = "Text to be added";
>>int fd, ret, fsyncrc, fsyncr_rc, openrc, closerc, close2rc;
>>
>>fd = creat("test.txt", S_IWUSR | S_IRUSR);
>>if (fd < 0) {
>>perror("creat()");
>>exit(1);
>>}
>>ret = write(fd, str, strlen(str));
>>if (ret < 0) {
>>perror("write()");
>>exit(1);
>>}
>>openrc = open("test.txt", O_RDONLY);
>>         if (openrc < 0) {
>>                 perror("creat()");
>>                 exit(1);
>>         }
>>fsyncr_rc = fsync(openrc);
>>if (fsyncr_rc < 0)
>>perror("fsync()");
>>fsyncrc = fsync(fd);
>>closerc = close(fd);
>>close2rc = close(openrc);
>>printf("read fsync rc=%d, write fsync rc=%d, close rc=%d, RO close
>>rc=%d\n", fsyncr_rc, fsyncrc, closerc, close2rc);
>>}
>>
>
>I can confirm this fails on my machine without nostrictsync:
>
>$ ./test
>
>fsync(): Permission denied
>
>read fsync rc=-1, write fsync rc=0, close rc=0, RO close rc=0
>
>and works with nostrictsync:
>
>$ ./test
>
>read fsync rc=0, write fsync rc=0, close rc=0, RO close rc=0
>
>So is the bug in the Linux kernel?

Yes, it's in the kernel cifsfs module which is forwarding an SMB_FLUSH request
(which the spec says must fail on a non-writable handle) to
a handle opened as non-writable. Steve hopefully will fix :-).
