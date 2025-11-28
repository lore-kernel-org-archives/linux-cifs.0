Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE260233704
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 18:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764353753; cv=none; b=IRccSuqqoGtWZOPMZJqzRm2v1FkTba+bM5Y8CRTn1E20tI6RyzNv1UDx40oFErwYlU6tB/fK1r0EK5tSHs3OyeMQdiTBQnH8KO4HslQ5IEgqc1KWIonO1zzy5XrBQbJ7+r4GZCCdn24lxKFnUseEg0/C2z2e9Sqn7MMoibTReDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764353753; c=relaxed/simple;
	bh=SqI8TCDc7OOTCCa7heGL9zWZ7ia+IX118+OO8se+vm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ttYJvFexov0XwK7dGDWf7ny+iwuXw5weoSNn+PsoBhkZwUqOWgXVIXHBjVCaysfG6IMgcz3xO345ThBrbrwpo0LDM+OwmswX3MVeCKbuFoxGjxbiAndiWfxfS1zEfp88ggm5pLn6zgbaXW0YpeaH84vNHzRrXw0q2BBuYIlixsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KVG8r2YA; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KVG8r2YA"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88242fc32c9so24625816d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 10:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764353750; x=1764958550; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZTIeWEHxWvpkpyW8zQyc1Jsar/PDd4x9z0vn2oJCh8=;
        b=KVG8r2YALFjxfuRIY4pS0bUzCXR6fGcmiw6RCyT7whQkaSXPQs903bE/uJ4NIrSf5C
         KlgV0JQi8733u5I5V7pF3uO1nktirfhF00s26KqlUbaWOGwJSRh2YCl3jvFiQ0NjN1C7
         FuJbsQI2tvTZuGZGRlqc7IC6TxSEcTBGrxQjGLF8hop1+27bhTC8bexx8q6/m5g2T5Cj
         NSwx3J/I/ez4rbCRIrDC24tLfNaCXjzz9O1Z33J4LkP3JCjl3GS5LztfN0lIhS4UgSbN
         Sg56FPq9vd/3IRfvvlr8WRwd+Ks3B7lzQYzs+WvlX6txAeVzUcRpvrQsuJYIzu4AUvC+
         KrZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764353750; x=1764958550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mZTIeWEHxWvpkpyW8zQyc1Jsar/PDd4x9z0vn2oJCh8=;
        b=PogeGg/eK7RUlICqpNYh4/odGLlkWCwgQsriDywH7JwucJ7jDEvo+wgcur7B9QogUQ
         VmE/57kQb1tq8Jm/GXEIfzYTlyqqI9oX+7DAFEoXojtY6GHGAK3VyzzgxN0TPAhR8LV1
         FT/NpSsp5RWYkaUGPLPoGZXZ7XzdPxL/7RKyEdZC5PB8Q+sCLpHeDx5OIIBg4dw0NpEX
         AI94ZkiWOgopo9MAZ2wB9xkIZsUAgTuSprxRQ0GntRvClNG/z4Kd4Zqn8ky1qKaw8zqo
         D6RKgkYbPthOqxJ4a63qjpabztAYe0EdSrXZKmeP1fCtCL0qwVPL9PlQqNsOaj1BJblh
         5l8g==
X-Gm-Message-State: AOJu0YzUE/u9Wf4GZzlBuFJbFboI1ZowJzzIP8dGvLDXOV9a4jev+Lk3
	FiIanQHcjdg56sbFRWY5NbluhAQ1l67O44eoHVHX8kYteqg5Ia8rLdvlwGj37VI11zBSMy5NYzQ
	FQ1DN+mS3NQyDJOuqnZG0TJzl+oMZb4qxCk/h
X-Gm-Gg: ASbGnct05vO3p4PmPpb31stJ7dweYDZwoCeP0PqVSBSeSEUK5yqyHWrahdNRctbQyTT
	VR22Nv/x1ovwH79VSpx8DsV/jZapLDP58Z0s9jg7/LyeXTXxQFwMYUKHKoy3oPpeJADh6otzEgm
	LesiJk4uWA8KOk/GCxhEwyUVSnb2VHQ4YS/BDfN08UTBQTuMtiTPwYMhATnNLKk8FQFKeBUkLaw
	qdNQBn2tVXYFVndBbP2wii+HVkOKFHhTwckzHiKvwmRQszmA51eizjbPVJD82f+UJV7+RiAFfJP
	4NaqX6SSA9+RdT2X9C+OUKa6GYsdAvqYWMesyPB7diIOo0TwsQxOYfbHzfLomTfH15feuWusO2a
	aOW8H64VGR7OKMg1xvGD8VSprNI5ifefD0acjW04narfyIqUH894H3+TVyPcu9jYeR772Cf85Fs
	FayBcHNP/c8w==
X-Google-Smtp-Source: AGHT+IFjZm2IALZTfr2r0HH8NVAw9QPhgPyPuPScN2UoA3MmVEUJkVMahBdATHHTVrvSKz7wGv8tpcC+l0ZP4vlJ62o=
X-Received: by 2002:a05:6214:4018:b0:880:4c02:c49 with SMTP id
 6a1803df08f44-8847c49a3ffmr409125566d6.23.1764353750384; Fri, 28 Nov 2025
 10:15:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128134951.2331836-1-metze@samba.org> <CAH2r5msBaRVPNkaMy0iQKPq9COR+p5+UUNf-B-Fh6=v7zKNRnQ@mail.gmail.com>
 <7ff0bc80-f94c-4cc9-b85a-0ddc1393c9a1@samba.org>
In-Reply-To: <7ff0bc80-f94c-4cc9-b85a-0ddc1393c9a1@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 28 Nov 2025 12:15:38 -0600
X-Gm-Features: AWmQ_bmMzsc2MS9A-4YrCOJ5K3gfWJknTRFJD0eS0aLXiIhIJeugFTTf6WZHc0g
Message-ID: <CAH2r5msAQ7JZvOksSWJiW9SrZmX85yzcbHJ1Zb7r=P9yU+p5Ew@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: change git.samba.org to https
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ok - this change seems harmless.   I also want to look at way to add
you to MAINTAINERS to make clear you are "expert" at RDMA/SMBDIRECT
and either reviewer or co-maintainer for smb client/server/common more
generally.  Wanted to look at a few other examples in MAINTAINERS and
compare

On Fri, Nov 28, 2025 at 12:00=E2=80=AFPM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Am 28.11.25 um 18:48 schrieb Steve French:
> > On Fri, Nov 28, 2025 at 7:49=E2=80=AFAM Stefan Metzmacher <metze@samba.=
org> wrote:
> >>
> >> This is the preferred way to access the server.
> >
> > Are you sure that is the preferred way?  75% of the entries in
> > MAINTAINERS use "git git://" not "git http://" but ... I did notice
> > that for all github and gitlab ones they use "git http://"
>
> It seems a lot of them were created long time ago.
>
> > But maybe for samba.org there is an advantage to https?!
>
> Yes, the admins of git.samba.org prefer that clients use https://
> instead of git://
>
> I also checked what linux-net uses and it also uses https most of the tim=
e:
>
> $ git lo -187 linux-next/master  | grep 'Merge branch .*\/\/'| grep https=
 | wc -l
> 178
> $ git lo -187 linux-next/master  | grep 'Merge branch .*\/\/'| grep -v ht=
tps | cut -d ' ' -f2-
> Merge branch 'main' of git://git.infradead.org/users/willy/xarray.git
> Merge branch 'master' of git://www.linux-watchdog.org/linux-watchdog-next=
.git
> Merge branch 'master' of git://git.code.sf.net/p/tomoyo/tomoyo.git
> Merge branch 'next' of git://linuxtv.org/media-ci/media-pending.git
> Merge branch 'docs-next' of git://git.lwn.net/linux.git
> Merge branch 'master' of git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>
> metze



--=20
Thanks,

Steve
