Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F1512E1E9
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 15:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707234741; cv=none; b=CqELXEDK8YXvpGvkmdK4hotxky58v5IKi6E4B+fIkceA8hmsogDcZOZS1d27wMTVXD/CKsPojNRhEZF4uobSlzol43MBvUSNt9CNBGyHapm2REE7JYnvB1+EVngdaixlz+Qg2GaALfNDgUJ3Adn2GD7Ep2rmjlIcZirOUc7AB4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707234741; c=relaxed/simple;
	bh=EyzKzp31K2DLJgkgPucCqPcSywD6rk7682dkXuh6EXU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bsj3F5NGHPiIQ0iQgEF4Ed3oi9Hj/16fsbWlVpg3iG/QOCAo9KA6ziQQVx7+209HLKRymw1DtsjSiZz+1bGezEW6nvL5DAFB6IpdDR4/iThHKBfLl6tdDf09v76vQFeDnmsYcbVFnGTJh9QYHAYAGw8go/VYtsrnZdb8Rre4D4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lz+jCJEw; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lz+jCJEw"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-511490772f6so3310028e87.2
        for <linux-cifs@vger.kernel.org>; Tue, 06 Feb 2024 07:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707234738; x=1707839538; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MO8sR5XMuM/jakBgNii/ev4VHeU4IK+hXVzOZhB8DO4=;
        b=Lz+jCJEwrJahuKkyRoFKj33H59So5e6UsDKfDfnFRggDdqKYJ4oempHA7ETa2NcHlh
         1Lb91f9tYQX2AWG8bwrEr+1b2Rk/w6GxgyMluB1Qee2lB3r3x3+G2DQNwqyg2UCOQg4C
         Mf1LKhWBMUKpMJ092uBPez29g8uP8eOsi3BTcPDv1bFBfA0ECkHIp8KX3Ogyj3jj4hKo
         WP8OeTsz5orrC3s0V2zlxmOSR498wF1YnZhrW+/p2AUfluMJkKWpU/m1M1mG5E7mNb4L
         Rh6Wsp8Mz3TAhQMM86bcAElNCzD97fKCHDZPrMkq3t1roDNNarvlAgLriZBkten4uxod
         x1Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707234738; x=1707839538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MO8sR5XMuM/jakBgNii/ev4VHeU4IK+hXVzOZhB8DO4=;
        b=ez24OyaG2DjtzTFU7PqiUFZAWskpFpdMOAOjk6bpn8eBzZccrTjh4+AmdqiYd2v2jH
         NdNi+XzMINmTn1SNpd7ddjXTuYyZ7kGDFoAu//48UaX0AOmF8/iDfAgR/as2LZcPUIzL
         QaYzoSpxAPix0UuAjBRxMCYtkg+iG9oZxhKnVaAC22gcICJ1/N4/GZig6QbK1oUthA4w
         F/eYmxbiFg/9Ej7th/SfqHonXEpQ3fgTXy5cZX+cPn+89bkb7Jrm1qizxSs9/pqaw1RG
         ewDtObT7GMKSGGd5bzYcrGD80ig/317b4CoEUYwkmWtZMKQaeGpAOc/zBaAjtqmsqk9+
         XKyg==
X-Gm-Message-State: AOJu0YxgYewYLaBAdQpFPMXagzHzrYC8qusZi2nfd8PJK2Hm0dOidpIf
	opAjYXxiqZ3v9LqKzkFhjxyssZE3XmwJ0DQYTFXoiAUC8BrMusFYrmyXf85e3ivpSq910R2sgrV
	9VQ2LZPqHSQMNtRCbJXTIpQCE45U=
X-Google-Smtp-Source: AGHT+IFO+2Ahgh69ZpIZiuEdx2Ygv9grx+TRfltQzmbPbrcY358vsUmpRtiiXblTdVDXqgFblQntkMOC/lpbyhfd7+M=
X-Received: by 2002:ac2:5207:0:b0:511:5008:2b94 with SMTP id
 a7-20020ac25207000000b0051150082b94mr1856812lfl.19.1707234737557; Tue, 06 Feb
 2024 07:52:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <262547e6-72e1-436f-8683-86f7a861f219@rd10.de> <3003956.1707125148@warthog.procyon.org.uk>
 <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
 <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de> <3004197.1707125484@warthog.procyon.org.uk>
 <3113886.1707204762@warthog.procyon.org.uk> <a384b6e0-b32f-43b4-be09-99a919d78f91@rd10.de>
 <3114515.1707207719@warthog.procyon.org.uk>
In-Reply-To: <3114515.1707207719@warthog.procyon.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Tue, 6 Feb 2024 09:52:06 -0600
Message-ID: <CAH2r5mswELNv2Mo-aWNoq3fRUC7Rk0TjfY8kwdPc=JSEuZZObw@mail.gmail.com>
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
To: David Howells <dhowells@redhat.com>
Cc: "R. Diez" <rdiez-2006@rd10.de>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My best guess so far is that this change caused the regression:

$ git show ab7362d04d7
commit ab7362d04d7c14923420c1e19e889da512a65cd7
Author: David Howells <dhowells@redhat.com>
Date:   Fri Feb 24 14:31:15 2023 +0000

    cifs: Fix cifs_writepages_region()

    Fix the cifs_writepages_region() to just jump over members of the batch
    that have been cleaned up rather than counting them as skipped.

    Unlike the other "skip_write" cases, this situation happens even for
    WB_SYNC_ALL, simply because the page has either been cleaned by somebod=
y
    else, or was truncated.

    So in this case we're not "skipping" the write, we simply no longer nee=
d
    any write at all, so it's very different from the other skip_write case=
s.

    And we definitely shouldn't stop writing the rest just because of too
    many of these cases (or because we want to be rescheduled).

    Fixes: 3822a7c40997 ("Merge tag 'mm-stable-2023-02-20-13-37' of
git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm")
    Signed-off-by: David Howells <dhowells@redhat.com>
    Link: https://lore.kernel.org/lkml/2213409.1677249075@warthog.procyon.o=
rg.uk/
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5365a3299088..ebfcaae8c437 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2893,8 +2893,9 @@ static int cifs_writepages_region(struct
address_space *mapping,

                        if (folio_mapping(folio) !=3D mapping ||
                            !folio_test_dirty(folio)) {
+                               start +=3D folio_size(folio);
                                folio_unlock(folio);
-                               goto skip_write;
+                               continue;
                        }

                        if (folio_test_writeback(folio) ||

On Tue, Feb 6, 2024 at 2:22=E2=80=AFAM David Howells <dhowells@redhat.com> =
wrote:
>
> R. Diez <rdiez-2006@rd10.de> wrote:
>
> > > Out of interest, are you able to try an arbitrary kernel?
> >
> > I'm afraid that is beyond my Linux Kernel abilities. I am just a user a=
ble to poke in some configuration files, and maybe fight a little with Syna=
ptic / APT.
> >
> > But maybe the Ubuntu guys can. You can reach the guy doing some extra t=
esting here:
> >
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2049634
>
> No worries.  Steve can probably try that.
>
> Thanks,
> David
>


--=20
Thanks,

Steve
