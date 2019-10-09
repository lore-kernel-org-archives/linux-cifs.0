Return-Path: <SRS0=5iq/=YC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A2DECE58C
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Oct 2019 23:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CDFF206C0
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Oct 2019 23:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HUAl2VqC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfJIX3U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Oct 2019 19:29:20 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34312 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730815AbfJIX3U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Oct 2019 19:29:20 -0400
Received: by mail-io1-f67.google.com with SMTP id q1so9486922ion.1
        for <linux-cifs@vger.kernel.org>; Wed, 09 Oct 2019 16:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xu+h7FmcB09D1gMbxjXEwlGdWJOKZfuPdrp8Y//hdbU=;
        b=HUAl2VqC0wtNTEsh/9mx148IZ6zBOf31pCJgVP+SU7Y3iTxeZjTzuYhuh8A3yUt2Dd
         M76oKqQZACzincCSV91Bxi2mcxuxyAYaKawuPmj24S/VqQzZw8lOF9yO0UZmMzFNWQAa
         Z+og+E1wi1dobIPBc7lNub73slJFEWZsai5awMMgM8sJdeWUVyaRCNeAIGMJcRlF3OFs
         pigB/R+q4+i/A4h6Rn1s135lF9jImWxoJ7zZT4y/5KxmZqjbymnBG+Mfz9Kq/kR3d1vp
         aFAiYIjPLbI23DbcGt/jOlRH+DSUZyMvhQWGptPgqJo/OcYQ6Q2uAiYLjKdFJKCGd4ts
         s5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xu+h7FmcB09D1gMbxjXEwlGdWJOKZfuPdrp8Y//hdbU=;
        b=LBJiafcf1t3LVqjxHTjEJpoVTJEEPJ1+Syi4xWwfvo/lBuAAmdYfsJGR+dH9XwuYrc
         +q2tTlMabPKxn08aQjW9ljqvx74zYTIu8/EGLYn69Y3h3enQE60daI4amYO/lpnWQMjk
         Sur5nbTjPS5XToeqBOzJ9ldpc1LvDAGyP236tFV3H+H2UEphwKcOIYNaaDloomvse+t4
         V1eOPOHJz7nkBm1y5I42MW+Hm9yccJgkBZEJOOR/DxA4RtRI11G3ZDHdEpVSVM6FpRZ+
         /LRCHHRo7EA609IOvlp2l1yLZUsnvIUXEdh9ky37liKkx+3GNXWYOjJsRq8GeQOHg3ch
         h36Q==
X-Gm-Message-State: APjAAAVF3xt5pcd/ANDXU0Jnq79E/q424QTIZZk/9w7uDXURM2zvY12d
        vapVvORbkQV4WcSfulGngUBHf8BpyvAOh0Uc55Y=
X-Google-Smtp-Source: APXvYqyrbiwmqdfn27l6ntcP3zaq3fntUnqJAgyTvMlTq+aS3vZNF8BKEiASQ7x9C5RV36ffEtd3g6eUuybmxkp+da4=
X-Received: by 2002:a5d:8f8e:: with SMTP id l14mr3671923iol.3.1570663759526;
 Wed, 09 Oct 2019 16:29:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190924045611.21689-1-kdsouza@redhat.com> <87o8yqf4f6.fsf@suse.com>
 <CAA_-hQL8MpS9YEcaQpuiQnbsuJwerutnbxWhE-Fyk1X4jpvwcw@mail.gmail.com> <87k19ef0si.fsf@suse.com>
In-Reply-To: <87k19ef0si.fsf@suse.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 10 Oct 2019 09:29:08 +1000
Message-ID: <CAN05THSfA9e1DP9+nM=CkgU-mKRnUeJp2p96umrOA3aBiWe9Gg@mail.gmail.com>
Subject: Re: [PATCH] smb2quota.py: Userspace helper to display quota
 information for the Linux SMB client file system (CIFS)
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Kenneth Dsouza <kdsouza@redhat.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Oct 10, 2019 at 12:33 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
>
>
> A general comment on the script I have which I should have mentionned in
> my first email:
>
> Do we really need a separate script for this? I like that we have a
> simple python example do this kind of stuff as an example and reference,
> I think it's useful, but installing it makes it yet another utility with =
an
> unconventionnal name instead of a new smbinfo subcommand.

I think it would be good to have these tools as part of the actual install.
They are in python so they are imho much more useful to the target users
(sysadmins) than a utility written in C.
(I kind of regret that smbinfo is in C, it should have been python too:-( )

Maybe we just need to decide on a naming prefix for these utilities
and then there shouldn't be
a problem to add many small useful tools.
The nice thing with small python tools is that it is so easy to tweak
them to specific usecases.

I think they should be installed but perhaps be called:
smb2-secdesc-ui.py
smb2-quota.py

regards
ronnie

>
> For reminders, we already ship:
>
> - mount.cifs
> - cifs.upcall
> - cifscreds
> - pam_cifscreds
> - smbinfo
> - getcifsacl
> - setcifsacl
> - cifs.idmap
> - secdesc-ui.py (not installed)
> - smb2quota.py (not installed)
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
