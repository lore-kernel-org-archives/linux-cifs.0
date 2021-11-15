Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1226C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Nov 2021 03:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 824B961AA8
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Nov 2021 03:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbhKOD3G (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 14 Nov 2021 22:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbhKOD3C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 14 Nov 2021 22:29:02 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FF4C061746
        for <linux-cifs@vger.kernel.org>; Sun, 14 Nov 2021 19:26:07 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id e11so32321800ljo.13
        for <linux-cifs@vger.kernel.org>; Sun, 14 Nov 2021 19:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HRVRwjq91WpZj5BgAQaB8CB805cHzjNskKwmk7m2SXw=;
        b=OScTsDJ157gnnA3csXnKLLA30uAZGrwCC+JAb5+5/jo0iYG9K446z1CBWkW4XEulLA
         cdYNSpAzaSWprBHVStKxBfZ6IEPoRfpwIEoyJ1ycc48YdPFGFc42Ee7pCRrRjyPqEXiA
         KghmWFf6mVEop+L+g7AI9yPmTb3uxKef27sMmLP9dwjv0BLapRiNf4FwDrrCzLfvL+QR
         jEm8rVfXG1qLzDaSdB62S1m9umrAKiuLCWcAHczif/D5Wc3YQjFNgYWrXjDLRG2bPKka
         xrULK+EpbC4uo0hUp39Jt1Wo7DPQmbJJB9r1SA3jDubK537EyhB+w2bn9iWuRJ/FJw3k
         ExZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HRVRwjq91WpZj5BgAQaB8CB805cHzjNskKwmk7m2SXw=;
        b=hiV8b1TeRGEfs8yIh+4nu6fd6pkieKuCyPk65inSSBCWqqpo7lGdWCac1DgUBwdxtd
         v5bjqFVZd+M1O315zlizjkScSrjme7zrDn6Vj+HJBzoRwgWurK0CVAlvDzKsb4a56X5Z
         25Zp7zzrjpRh3TtxzWNLXDbObncGTRLEawoAjaRkLBrnXKi0/W4djSqyl1uPODb5iMbl
         xiG6upCuDqtDTxRPA/M0AjWZ/Hp1/OmruLav0UCkG/ONe6y6pM7luf9vEQXcApNHn3tc
         MkdoJcTzot7I34FTNxa4wHU4nEKQRc0hX0M6p3rzkmBi7CeZRHzVlI0KI5HAMaO7NhhK
         NsYw==
X-Gm-Message-State: AOAM530unM7EOAjsY0+9f2jLznxLn4RBJ/rbEe3CkLC/20fb+maTlkVo
        Bmj5xqqYvdTG+CKzDfNSDJ+v4Hor8CGApXXufo4=
X-Google-Smtp-Source: ABdhPJwLnKrXa1Rz+y1WN2/1uVR6sIYZkNe77nT+lChgMKLSnx7sZu9T011RFxBmWCmQbyNQOuoF+/WB90BDbyxmLjQ=
X-Received: by 2002:a2e:7c16:: with SMTP id x22mr7398648ljc.460.1636946765429;
 Sun, 14 Nov 2021 19:26:05 -0800 (PST)
MIME-Version: 1.0
References: <YYhI1bpioEOXnFYf@jeremy-acer> <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com> <YYhXjG46ZZ1tqpxJ@jeremy-acer>
 <5c25c989-1e58-fb23-810f-a431024da11e@gmail.com> <YYiCAcxxnIbHz4xv@jeremy-acer>
 <cd649ed2-60d3-72e3-e09a-9f0074af99cc@gmail.com> <YYlUgc6UOyKfZr7d@jeremy-acer>
 <CAH2r5muWLJu_Yhx1pv0rCaTRPqeEd_8X8DP2cipUVaMekU9xFg@mail.gmail.com>
 <eadd8209-7dcf-30fe-2c8e-cc0fd7c823a1@gmail.com> <YYsYKvyevyXjHgku@jeremy-acer>
 <CAH2r5mtNxiw8gOTPJe0GopBnkkMspHvsMD+0_K2+kc2VbrgdBw@mail.gmail.com>
 <c9af96be-bb75-9487-4f9c-1a53b41e9210@gmail.com> <65be73d3-b8c9-e919-3dda-240c0497efff@gmail.com>
In-Reply-To: <65be73d3-b8c9-e919-3dda-240c0497efff@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 14 Nov 2021 21:25:54 -0600
Message-ID: <CAH2r5mvPot1Xhsg6eVPz0h11-+FEL+cBrLL9ucLSUPrf_+7ywg@mail.gmail.com>
Subject: Re: Permission denied when chainbuilding packages with mock
To:     Julian Sikorski <belegdol@gmail.com>
Cc:     Jeremy Allison <jra@samba.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The patch is in Linus's tree, so you should be able to try it with the
weekly kernel updates for various distros which have download sites
for more current kernel packages (Ubuntu, Fedora etc.) or build kernel
yourself if you prefer.

To get it into stable we will need to send a followup email as
described in their process guide below:

"send an email to stable@vger.kernel.org containing the subject of the
patch, the commit ID, why you think it should be applied"

but some of the distros will apply it automatically (it is still
helpful to send the email to stable as a reminder)

On Sat, Nov 13, 2021 at 9:37 AM Julian Sikorski <belegdol@gmail.com> wrote:
>
> Am 10.11.21 um 12:23 schrieb Julian Sikorski:
> > W dniu 10.11.2021 o 08:56, Steve French pisze:
> >> Fix for the kernel client attached
> >>
> >>
> >> On Tue, Nov 9, 2021 at 6:54 PM Jeremy Allison <jra@samba.org> wrote:
> >>>
> >>> On Tue, Nov 09, 2021 at 10:26:59AM +0100, Julian Sikorski wrote:
> >>>> Am 09.11.21 um 09:10 schrieb Steve French:
> >>>>> Yes - here is a trivial reproducer (excuse the ugly sample
> >>>>> cut-n-paste)
> >>>>>
> >>>>> #include <stdio.h>
> >>>>> #include <stdlib.h>
> >>>>> #include <unistd.h>
> >>>>> #include <string.h>
> >>>>> #include <fcntl.h>
> >>>>> #include <sys/types.h>
> >>>>> #include <sys/stat.h>
> >>>>>
> >>>>> int main(int argc, char *argv[]) {
> >>>>> char *str = "Text to be added";
> >>>>> int fd, ret, fsyncrc, fsyncr_rc, openrc, closerc, close2rc;
> >>>>>
> >>>>> fd = creat("test.txt", S_IWUSR | S_IRUSR);
> >>>>> if (fd < 0) {
> >>>>> perror("creat()");
> >>>>> exit(1);
> >>>>> }
> >>>>> ret = write(fd, str, strlen(str));
> >>>>> if (ret < 0) {
> >>>>> perror("write()");
> >>>>> exit(1);
> >>>>> }
> >>>>> openrc = open("test.txt", O_RDONLY);
> >>>>>          if (openrc < 0) {
> >>>>>                  perror("creat()");
> >>>>>                  exit(1);
> >>>>>          }
> >>>>> fsyncr_rc = fsync(openrc);
> >>>>> if (fsyncr_rc < 0)
> >>>>> perror("fsync()");
> >>>>> fsyncrc = fsync(fd);
> >>>>> closerc = close(fd);
> >>>>> close2rc = close(openrc);
> >>>>> printf("read fsync rc=%d, write fsync rc=%d, close rc=%d, RO close
> >>>>> rc=%d\n", fsyncr_rc, fsyncrc, closerc, close2rc);
> >>>>> }
> >>>>>
> >>>>
> >>>> I can confirm this fails on my machine without nostrictsync:
> >>>>
> >>>> $ ./test
> >>>>
> >>>> fsync(): Permission denied
> >>>>
> >>>> read fsync rc=-1, write fsync rc=0, close rc=0, RO close rc=0
> >>>>
> >>>> and works with nostrictsync:
> >>>>
> >>>> $ ./test
> >>>>
> >>>> read fsync rc=0, write fsync rc=0, close rc=0, RO close rc=0
> >>>>
> >>>> So is the bug in the Linux kernel?
> >>>
> >>> Yes, it's in the kernel cifsfs module which is forwarding an
> >>> SMB_FLUSH request
> >>> (which the spec says must fail on a non-writable handle) to
> >>> a handle opened as non-writable. Steve hopefully will fix :-).
> >>
> >>
> >>
> > Thank you. I can confirm that 5.15.1 kernel with this patch applied [1]
> > works both with the test case you provided earlier as well as with mock
> > chainbuilds without the need for the nostrictsync mount option. Fedora
> > kernel-5.14.16-301.fc35.x86_64 was failing without it.
> >
> > Tested-by: Julian Sikorski <belegdol@gmail.com>
> >
> > Best regards,
> > Julian
> >
> > [1] https://gitlab.com/belegdol/kernel-ark/-/commits/fedora-5.15-cifs-fix/
>
> Hi,
>
> may I ask what the usual process of getting the patch into the Linus's
> tree and to the stable branches is? If it takes longer, I am going to go
> back to nostrictsync for now.
>
> Best regards,
> Julian



-- 
Thanks,

Steve
