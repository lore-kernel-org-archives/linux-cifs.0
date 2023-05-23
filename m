Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6989C77B75
	for <linux-cifs@archiver.kernel.org>; Tue, 23 May 2023 01:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbjEWBCD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 21:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbjEWBBh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 21:01:37 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798251FFB
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 17:59:42 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-510d6e1f1abso499162a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 17:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684803581; x=1687395581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zC8RUZgKRRIeFzEm4HicM3NMEy9A1nX6MMx3jlb5aEw=;
        b=MgSu/+W7gpyExLKFQ4w1suZX0b+bub56fQ9zmpayVoSnY2H7CjEjlVI/wwPFR4SSK7
         3IprQ4TsMHVs/Y+aHrTU5p1Od4gvPPdwPCle1VSSKRDTC35roXn3Iyy/yIh4CH6/4Za7
         fZGwCcx4r4uqxrFTvTHgNt0o9cEHgZjGPdYevYXdu8YMYhckmX+RAeen1o1YjynJybQj
         KJPrdvb+M+Hv60rLPIHcqyRXL7GAaqAv7k2506t1uffdUZBUqlpwm02CB0PyrkvG9r+z
         WGGYAYCAgOIdhwLnpWLmxngKKtFcR8ymJIk+DGdsdP5ayadgL7NttWiXP8ZuUTN3fZo2
         VKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684803581; x=1687395581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zC8RUZgKRRIeFzEm4HicM3NMEy9A1nX6MMx3jlb5aEw=;
        b=gEZeut6hENwXwDGsWLlDgwZJJPHRe/FNiH9SlZPrit9nxg7OIhfuPEbjbylAivNhte
         TPedGitshtqHgkBGOuutTfFJK4VPF2Wtn3irxK5aC2pbJnULXbf6qOFYQ6iAzO4MIdzI
         Cbb95um9abLSYU8BnHzCJK8MGaUIDuRjnDvzqTAw/gVRwaevyoSuqX88JcklI5NKRPBv
         oYR2eGr5Nl093EjVcjjuSDitETWerCG+1SH33MAwA06FnFea31P4czoeBWZS6Ff6X7Cy
         TmPmh/WZjdRqm2QAtHyvgGxGHVjnPJu7GiEcoBPPsUBV0lRFb0k/+eIVnx+ApR+uEg8t
         sj7A==
X-Gm-Message-State: AC+VfDz2z0LNudQdakI3NYCg0BB5Tb7SyaYfdt9ETx4N3zbx3yHAvEi4
        7ECRGWq3jdhGJv2bfTQy1+15si9IZp7T4mUuGWrEerq5aeQ=
X-Google-Smtp-Source: ACHHUZ4E/Q+hF6zLfH2qPomFTnb9Boa9tvBQutstIPgyI6b5tlGfRbqVQfACikWiEb5qhe27+CbrtuwGRBLksbwQRLg=
X-Received: by 2002:a17:907:96a1:b0:959:bbda:fa51 with SMTP id
 hd33-20020a17090796a100b00959bbdafa51mr13297131ejc.41.1684803580650; Mon, 22
 May 2023 17:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com> <ZGuWhzP98U9Niog+@jeremy-rocky-laptop>
In-Reply-To: <ZGuWhzP98U9Niog+@jeremy-rocky-laptop>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 23 May 2023 10:59:27 +1000
Message-ID: <CAN05THRnHcZtTMLxUSCYQXULVHiOXVYDU9TRy9K+_wBQQ1CFAw@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     Jeremy Allison <jra@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yeah, I don't think we should surface these as xattrs.
Xattrs are already way too small for most of the usecases of ADS on
windows (file metadata for explorer etc)
and they are also just an atomic blob and not a proper filedescriptor.
Since ADS is still just a file, any application that in the future
will use ADS features should only do so via
a proper filedescriptors, where it is possible to
seek/read/write/truncate/...  so IMHO we shouldn't offer them an
alternative but inferior API. Because they might mistakenly start to use it=
. :-(

There are no real applications, yet, for linux that uses ADS but there
are many that potentially could use ADS or
become ADS aware. GUI Filebrowsers would be a nice usecase. As would
making 'cp', 'mv', 'tar', 'rsync', ... ADS aware.

So let's not do it with xattrs.
No one needs/asks for this right now so it would be code we will have
to maintain but has no users.


What we should do though is think about and talk with the NTFS folks
so that we make sure our aims and APIs will align with the plans they
have.
And once we have multiple filesystems supporting it (cifs.ko and ntfs)
then we can start thinking about how to encourage external users and
applications to use it.
There are really nice use-cases for ADS where one can store additional
metadata within the "file" itself.

regards
ronnie s

On Tue, 23 May 2023 at 02:21, Jeremy Allison <jra@samba.org> wrote:
>
> On Mon, May 22, 2023 at 01:39:50AM -0500, Steve French wrote:
> >On Sun, May 21, 2023 at 11:33=E2=80=AFPM ronnie sahlberg
> ><ronniesahlberg@gmail.com> wrote:
> >>
> >> A problem  we have with xattrs today is that we use EAs and these are
> >> case insensitive.
> >> Even worse I think windows may also convert the names to uppercase :-(
> >> And there is no way to change it in the registry :-(
> >
> >But for alternate data streams if we allowed them to be retrieved via xa=
ttrs,
> >would case sensitivity matter?  Alternate data streams IIRC are already
> >case preserving.   Presumably the more common case is for a Linux user
> >to read (or backup) an existing alternate data stream (which are usually
> >created by Windows so case sensitivity would not be relevant).
>
> Warning Will Robinson ! Mixing ADS and xattrs on the client side is a rec=
eipe for
> confusion and disaster IMHO.
>
> They really are different things. No good will come of trying to mix
> the two into one client namespace.
