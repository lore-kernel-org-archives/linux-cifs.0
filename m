Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31973C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Nov 2021 08:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E4BB6112F
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Nov 2021 08:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241413AbhKIINS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Nov 2021 03:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbhKIINS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Nov 2021 03:13:18 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1242C061764
        for <linux-cifs@vger.kernel.org>; Tue,  9 Nov 2021 00:10:31 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id i26so34656687ljg.7
        for <linux-cifs@vger.kernel.org>; Tue, 09 Nov 2021 00:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MOvvlZkNXDcbuWNWuyT78f985Xf3OQiN8hb2h6npZ70=;
        b=m7XChK3p5LX3NLkCuMOKBrWTL6kuHzVHmsb/vdpRDAdGkWyPAidnTeTqZ01yJTgM/7
         F9zSP0yXjRPUsabRTm158eg8FGaKkSVvzp4pybeQ8cF7pWbviwbv7FRJbSoqI+4KetHX
         QrzDFWHq2bFTsnGVjz+GuhGVyXLXo0vDGBo2lYSuLBI/IpTJQpEYDZlu/wIspDRh6dMl
         IIzf2XhX2s1yM87WRnjP5wLdXruJV37zJkmN2Swb7Tz420YxbAIm5zfBJqPpJQimO+QR
         9WxQm9FhvGA686BzX0aJhNt5dA8Dkfy4whRFcsjSA47Gd7aF6Sbser7t4hOCu0xmOAen
         aBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MOvvlZkNXDcbuWNWuyT78f985Xf3OQiN8hb2h6npZ70=;
        b=c60wRSLoWjWrQEqi6kJ2sQQd963RKoChv4gRsmnjVTOA+GCtHPcYgfa0elryx2b5Jv
         MweOsSN6EZKHJPkoQIXW3fQhieVSABt5fNiaIPXVNn3S7gpTGLPECVy/hsX5uRq8AzSe
         G4X08dG8QyQDr5bsJqqYY7Z1kqK1WgQ1aLUEY0NQaeL8jz+YCrrtQaod0u0LAMewJyRn
         OsjkuQw2pQd+fz6HEBlXENyTB1b3g6DNiPCx/Eai9SnRtm5qKH8ZxamCJB5GCouvoFrG
         hnwXjoC3unT/FKddJaCJbsyuH+UOklNcFDGHSicWCc5b32oM/T8eBt9HyktxKdPkP4Vs
         t9+w==
X-Gm-Message-State: AOAM530CiCwfmPbKqmNhKV/47f0RmfGG1sPTb72uNWn8yIvJaR3tHA8V
        R18COx44GMMWDozdzJXtg/joaLdG+c3URcUe3Uc=
X-Google-Smtp-Source: ABdhPJzkBY8QNt+OGQ/RhpgjAuf150dAf6jZgo8Fc3VBk8UYjuLvGpp9CuZqgpUOamMt0dgiHrHHZn8qzJTZl0wrwPs=
X-Received: by 2002:a2e:a44b:: with SMTP id v11mr5392123ljn.314.1636445430217;
 Tue, 09 Nov 2021 00:10:30 -0800 (PST)
MIME-Version: 1.0
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
 <YYhI1bpioEOXnFYf@jeremy-acer> <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com> <YYhXjG46ZZ1tqpxJ@jeremy-acer>
 <5c25c989-1e58-fb23-810f-a431024da11e@gmail.com> <YYiCAcxxnIbHz4xv@jeremy-acer>
 <cd649ed2-60d3-72e3-e09a-9f0074af99cc@gmail.com> <YYlUgc6UOyKfZr7d@jeremy-acer>
In-Reply-To: <YYlUgc6UOyKfZr7d@jeremy-acer>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 9 Nov 2021 02:10:19 -0600
Message-ID: <CAH2r5muWLJu_Yhx1pv0rCaTRPqeEd_8X8DP2cipUVaMekU9xFg@mail.gmail.com>
Subject: Re: Permission denied when chainbuilding packages with mock
To:     Jeremy Allison <jra@samba.org>
Cc:     Julian Sikorski <belegdol@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes - here is a trivial reproducer (excuse the ugly sample cut-n-paste)

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

int main(int argc, char *argv[]) {
char *str = "Text to be added";
int fd, ret, fsyncrc, fsyncr_rc, openrc, closerc, close2rc;

fd = creat("test.txt", S_IWUSR | S_IRUSR);
if (fd < 0) {
perror("creat()");
exit(1);
}
ret = write(fd, str, strlen(str));
if (ret < 0) {
perror("write()");
exit(1);
}
openrc = open("test.txt", O_RDONLY);
        if (openrc < 0) {
                perror("creat()");
                exit(1);
        }
fsyncr_rc = fsync(openrc);
if (fsyncr_rc < 0)
perror("fsync()");
fsyncrc = fsync(fd);
closerc = close(fd);
close2rc = close(openrc);
printf("read fsync rc=%d, write fsync rc=%d, close rc=%d, RO close
rc=%d\n", fsyncr_rc, fsyncrc, closerc, close2rc);
}

On Mon, Nov 8, 2021 at 10:47 AM Jeremy Allison <jra@samba.org> wrote:
>
> On Mon, Nov 08, 2021 at 07:59:49AM +0100, Julian Sikorski wrote:
> >I will try to generate a log for the working case later. Having said
> >that, the question becomes: why are some files read-only but others
> >are not, when they are generated by the same software in the same
> >folder? The permissions on both folders are exactly the same:
>
> It's nothing to do with the permissions on the files. It's to
> do with the open mode the client uses when opening the file.



-- 
Thanks,

Steve
