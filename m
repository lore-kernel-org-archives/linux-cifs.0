Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809FCC00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 04:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiHAELG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 00:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiHAELF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 00:11:05 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A3FDE8E
        for <linux-cifs@vger.kernel.org>; Sun, 31 Jul 2022 21:11:03 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id n15so4955117vkk.8
        for <linux-cifs@vger.kernel.org>; Sun, 31 Jul 2022 21:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TJJcCF+5PJ/hQy71SZtMMnkoWXrCNgITyqwgnNe75EQ=;
        b=ijsuyOoNvL89gLQfh8L12I2puG9UXMYrm2vJo1mc8osOrFVQHt2Xjlp5Mw8SCktWDu
         mj+9gBf7INnmdNrb2dBYGhgrwtt4DcbjL+I+I1yHShmp2jSBwsv9sKiK5hO6a3LZbiaU
         lmEyEMi83oB2VgMqbmewPle3XQjwxkTLTSxA18yp3f+rukNamk05JayrLwgX4hQtRxcL
         8X5sut/lsl1WcVGNu0BZIIclzmRLrzz0eFQLcrZbYul8snpUm3TQ5Yjb5cDb2yUey5I3
         weQI1sZjoWFp/I3q5JO/pdq0//PbGIaf1KhzAXn5yzRzwe4GwtrGdnskvqEdNHJ7LFMk
         PykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TJJcCF+5PJ/hQy71SZtMMnkoWXrCNgITyqwgnNe75EQ=;
        b=j+4M4v/hCJRLzCx5Cyz02krQ7pTiEn5ESrgbb6ZwO46cCrEFqVh4zb4brUN8+cKh0X
         3YIWSX5EbOcSpg8hMoxewJQ+Wm3D2XZ6XWsokpgT7L3lReCUkEMh/9TMm4M3DDOukuC6
         f+8qgW8xMNOdo1FPwwK3VhlQll0Ucyg/L54TL/T0xnXW0PZdMipcTHpcXVEK4WmoxXh1
         Uw2kzzpmVi/hs22r9acMSBwlvEyuLqGEBa8PYgFSGlL6kBqCJ/UlhJqK4gmTgkCcBMeK
         PP84lki+XGq/FoAmyDsm+iB1gbdmwUR96OSIl6bZhQT6UwjvGaRkCsCIxSvNA3MoocOK
         azzw==
X-Gm-Message-State: ACgBeo1LBDro1/+JA1Y47oOOvBmDHceIhQXxBZ42YABUHb/T5g3LZAIJ
        ha/eHNLDiXsuVOVyqALCtq1X6cOpR3QmfbmL8CM=
X-Google-Smtp-Source: AA6agR4eUfJ03HfTFfnmgmVPFSBNmMAmzPKv1NuFhkL68fRD6OrF1FEyNN3moOO5k1tynswZaKQpa5x7/F6LmIyXKPI=
X-Received: by 2002:a1f:9407:0:b0:377:668e:c2a0 with SMTP id
 w7-20020a1f9407000000b00377668ec2a0mr1168542vkd.38.1659327062773; Sun, 31 Jul
 2022 21:11:02 -0700 (PDT)
MIME-Version: 1.0
References: <774233f766bf26976c0d923cc1dc53c7@polymtl.ca> <705265ea-37a3-6029-362a-572bbaab6639@gmail.com>
 <0371d16e831be9cd9595c443d142e5fc@polymtl.ca>
In-Reply-To: <0371d16e831be9cd9595c443d142e5fc@polymtl.ca>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 31 Jul 2022 23:10:52 -0500
Message-ID: <CAH2r5mu187eVH3pH=Ltzf8ZKaumydYEbMTjz5jxa2BdkoWYoaQ@mail.gmail.com>
Subject: Re: pam_cifscreds, tmux and session keyrings
To:     Nick Guenther <nick.guenther@polymtl.ca>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Adding Shyam to this discussion - interesting questions worth investigating=
.

On Thu, Jul 28, 2022 at 9:50 PM Nick Guenther <nick.guenther@polymtl.ca> wr=
ote:
>
> July 22, 2022 2:38 PM, "Mantas Mikul=C4=97nas" <grawity@gmail.com> wrote:
>
> > On 2022-07-21 23:45, Nick Guenther wrote:
> >
> >> [...]
> >> I see in this old thread https://www.spinics.net/lists/linux-cifs/msg1=
8249.html that you actually
> >> want to go the _other_ direction, and isolate your sessions even more:
> >> multiuser SMB connections should also be initiated per session, same l=
ike the
> >> keyring. Currently the cifs SMB connections are accessible also from o=
ther all
> >> sessions.
> >>> That needs to be implemented indeed.
> >>
> >> but that doesn't sound like it would make my users happy. In their per=
spective, tmux should be the
> >> same environment as ssh or as the GUI, just more persistent. And I ten=
d to agree.
> >> Anyway, I hope this isn't too intricate or confusing for you. I would =
really appreciate a second
> >> opinion, and maybe a consideration of that patch, if that patch is act=
ually the right answer.
> >
> > As another user, I'd expect the keyring search to be done recursively -=
- start from the session
> > keyring as now, but follow the link into the user keyring, which is usu=
ally present (and isn't that
> > its whole purpose?)
> >
> > Then pam_cifscreds could be told which one to insert keys to, allowing =
it to be used both ways
> > depending on needs -- just like how Kerberos or AFS can also have eithe=
r isolated credentials or
> > user-wide ones.
>
>
>
> I've figured out a workaround, but I'm unsure about it and I could really=
 use some advice from people with more insight.
>
>
> I said before that my servers (and yours too) have
>
> # cat /etc/pam.d/sshd | grep keyinit
> session    optional     pam_keyinit.so revoke force
>
> And the problem shows up when I detach tmux, **log out**, log back in and=
 reattach tmux; then I see
>
>
> p115628@davis:~$ keyctl list @s
> keyctl_read_alloc: Key has been revoked
>
> The word 'revoked' was the obvious clue I: just to remove the 'revoke' op=
tion and the problem goes away:
>
> # cat /etc/pam.d/sshd | grep keyinit
> session    optional     pam_keyinit.so force
>
>
> This keeps the session-keyring(7) working even after reattaching. Because=
 it's the **log out** that is disabling the keyring; per pam_keyinit(8) [1]=
:
>
> >   revoke
> >           Causes the session keyring of the invoking process to be revo=
ked when the invoking
> >           process exits if the session keyring was created for this pro=
cess in the first place.
>
>
> This change seems to have solved the immediate complaints from my users. =
But I don't like overriding the default like this; I assume there's a serie=
s of good reasons for using 'revoke' that I don't understand.
>
> Would there be interest in switching to KEY_SPEC_USER_KEYRING? Would it b=
e a good idea? Can I assume the kernel CIFS code would need a matching chan=
ge?
>
>
> [1] https://manpages.ubuntu.com/manpages/focal/man8/pam_keyinit.8.html



--=20
Thanks,

Steve
