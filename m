Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A39C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Nov 2021 19:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31E0D61208
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Nov 2021 19:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243179AbhKIT23 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Nov 2021 14:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243162AbhKIT23 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Nov 2021 14:28:29 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D820BC061764
        for <linux-cifs@vger.kernel.org>; Tue,  9 Nov 2021 11:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=qygfyLEN4eaVE+Sw02Kp6H3CXjcndNGpsSpaATuZiSs=; b=wOic78eoyy/9hZ/D+2Bv2kQdnb
        VTPc3BmMwDY7fhqDMGbhYp5u0O/0gELqxjXymSPdleaM90GRPlJucAF1u4TeLzDNabO7lRt43Ow40
        y8hJPdheYuDB/N7ltw6fAU4bq6hGkmRFInUkp52TIsI+WK7uLhnEEekoowUPFTed3wUKi0VkBRZIK
        7sIsRp7+gOPiCkS7oE8njJHGZDERs9eyaF+5eyT1DrRMJPR//2xf0jbEEpDUaLO5tDAAHfyOAnkS8
        xa/Q+okERf+r6G7Acw5Rtw08A5BBoDkLo8SphJ89FiFy4lUdDhxFszXpr9bSya5coPVdY8YmQwvre
        fOnHWhPpDK4pILaoP/HotzLjst22DIG++iNfCmFooLiVatMubQg8wx4EZC3HqBDCLvahCBYGEyjo5
        202POEAmyRSdxf5e9eObjzMcorD406UvqzKjVbeXUFKNrq9FuBpWdfrHBBTKOgzAiOODO2h8ifoq+
        NgAtFHEn3KbcQir6k6OPhiGj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mkWkV-0068UZ-Qt; Tue, 09 Nov 2021 19:25:40 +0000
Date:   Tue, 9 Nov 2021 11:25:37 -0800
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Julian Sikorski <belegdol@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Permission denied when chainbuilding packages with mock
Message-ID: <YYrLMdUQccK+8IQc@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
 <YYhI1bpioEOXnFYf@jeremy-acer>
 <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com>
 <YYhXjG46ZZ1tqpxJ@jeremy-acer>
 <5c25c989-1e58-fb23-810f-a431024da11e@gmail.com>
 <YYiCAcxxnIbHz4xv@jeremy-acer>
 <cd649ed2-60d3-72e3-e09a-9f0074af99cc@gmail.com>
 <YYlUgc6UOyKfZr7d@jeremy-acer>
 <CAH2r5muWLJu_Yhx1pv0rCaTRPqeEd_8X8DP2cipUVaMekU9xFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5muWLJu_Yhx1pv0rCaTRPqeEd_8X8DP2cipUVaMekU9xFg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Nov 09, 2021 at 02:10:19AM -0600, Steve French wrote:
>Yes - here is a trivial reproducer (excuse the ugly sample cut-n-paste)
>
>#include <stdio.h>
>#include <stdlib.h>
>#include <unistd.h>
>#include <string.h>
>#include <fcntl.h>
>#include <sys/types.h>
>#include <sys/stat.h>
>
>int main(int argc, char *argv[]) {
>char *str = "Text to be added";
>int fd, ret, fsyncrc, fsyncr_rc, openrc, closerc, close2rc;
>
>fd = creat("test.txt", S_IWUSR | S_IRUSR);
>if (fd < 0) {
>perror("creat()");
>exit(1);
>}
>ret = write(fd, str, strlen(str));
>if (ret < 0) {
>perror("write()");
>exit(1);
>}
>openrc = open("test.txt", O_RDONLY);
>        if (openrc < 0) {
>                perror("creat()");
>                exit(1);
>        }
>fsyncr_rc = fsync(openrc);
>if (fsyncr_rc < 0)
>perror("fsync()");
>fsyncrc = fsync(fd);
>closerc = close(fd);
>close2rc = close(openrc);
>printf("read fsync rc=%d, write fsync rc=%d, close rc=%d, RO close
>rc=%d\n", fsyncr_rc, fsyncrc, closerc, close2rc);
>}

Yep, I expected such. cifsfs needs to keep track of
open mode and silently eat fsync calls on non-writeable
files/directory opens.
