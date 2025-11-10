Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BAB849C
	for <linux-cifs@vger.kernel.org>; Mon, 10 Nov 2025 04:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762749454; cv=none; b=hefW8RgyjTXVmhLXSldR0VCNQV6mHYLSl/y848YwbNhcfnNGABC0prBmMpISLmdOujm/YyA9HsFFwQ/2lEtkj7WceuwFF48cn41fVrQYuA8nFBux7KsJhlRilY4av5XXrbvJKq8nPlvjEaLEfh+vCrEdXiwni6Ipa8PmE0tAIVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762749454; c=relaxed/simple;
	bh=XWZmHbd21ylsvjXqeK0wqH5w8NzRBj7Bz0403aRaBIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vGIH6RHF9c1MlmSBQ7nKew6M4P0OpvrfksXIYPvlB+IU3ODHWEJlcw9ksj4ZKPlXf8VSniHNlOkT8mVFO9Up6yuscTzUuXeYHTgv8KaD7C2MAj6UjzbQXgcQvh8UD2JpBD5Mf97pl21a2zkOqMoVCKTd2eW0KzWS9pXTqiWuk9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UkKKvq5+; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UkKKvq5+"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b727f452fffso436475366b.1
        for <linux-cifs@vger.kernel.org>; Sun, 09 Nov 2025 20:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762749451; x=1763354251; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OiJloGhPDrr8GLvwcF1TR0t/9mGxlSJaz6CbhgT5pWg=;
        b=UkKKvq5+hetusejKAtHaewp9AG6FK5YC0n2r4hbYiTr+8TQxHqgkOWFbAdXNSHf961
         3Q2E2yMZ0iqFLmBHRwRpRzHmvaoB0elSrns/Gr1GpUgUXpiKtPdWKNRaPACJTHLV+fb9
         23klGc6SSMsZBGABip5HvbpKk7N+PdbsvkxhgOJVMDqZE/up6JYy9tCH5BxJU+yBJ3kL
         FY8Q/4mPRjoXvZLnj9Uy/olE4Ryb7MSPOVcdSAj82PaFvClmxXgqQjQKUemmK/JTCZjC
         ekDPRdyQPZuKhXFpNqToNXxc/kgrXbvfEA7eZq872tjltXRItP8+Meomt3LHeaRkk4rx
         2y2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762749451; x=1763354251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OiJloGhPDrr8GLvwcF1TR0t/9mGxlSJaz6CbhgT5pWg=;
        b=CJAfk8i/OR+ev6rTl3604ESAR7D3HPJsGQWPDtLesBfhWPrvyMQH7Qf6fpv7Baz6/h
         M63MWPKrQO6M9aIqghs5k4mu4pFNIyXp0StPisKOI27/ucUMbps/roYKnLu5oUuCAzxY
         K6vsOwquDWNkWSP6+4u7hM/HmPg/mm52ufqJllDSNTlJ911wLYeZC7MkcXm5Zg6nFRZI
         /HPja0X+nqrsfHQjGDJejBKDrkfQ9GUnR71pARD1MZwsgQcWUz5QeawSvh0kSeTHCkPF
         ResgCflYzsA4YpQwdLSe3efAnueyacedJBhZtMS1kL6Jm4eVKyWuTFbGUlYpyidEwJA9
         rlkA==
X-Forwarded-Encrypted: i=1; AJvYcCXxSsx5c/ptmhizmMdtEArwVP7YvI8UJsxnAp0P/lfidcZ2rULgJWyjZnz1Hc1Ofo0Vo9Rlh3hTVTrl@vger.kernel.org
X-Gm-Message-State: AOJu0YybvmhmD0Zp3BPYq6qJMAwjHh5MhK5FarjmEpDDUIviS0hSv+J9
	J1mf10C0CLHmLYVNrRLL+IaF5YNASz09SwXaZkMs89oR+yxi/TEyFKqvjY123JqWo0x9YdsTQIZ
	97vLUJId6a4xQDq3Rgx2yvs5mfR/oW/4=
X-Gm-Gg: ASbGncvZl1e+IfiDzOOTKumdGhdSHox62dR3YrCFZs0wHAbjeUG55Hd3F8eT8w1ZTgx
	Ujxovbm+PeL30YcRHKbuPt60mfnueZ2rB2a2R7S6deTIGDckAs7edyx6SNPzRfoSFq7ZIg8WgE9
	Qmp9MH5/3xDltABtES0iPGYPEStd3gc8jk2GcKiyutC1Qc5YfRGROkMqNTTjiytLz4GcTW72iLb
	gotcgHu3QavXK+yz/Zz7l7gGqGQTfPhpguDVQnjWkH3uCiSKEwenIWKmGqNcoyjgaoKGA==
X-Google-Smtp-Source: AGHT+IEH1Ty7xvZKwOEY769RN6XRp++BsCvvaRg+JeEO9TOVgbmPP5K16Ub5UlF3Xj9rIkVFEDr8Sv3UXsK+0wMdeVI=
X-Received: by 2002:a17:906:fd86:b0:b70:b9b6:9a94 with SMTP id
 a640c23a62f3a-b72dff17c63mr646514766b.23.1762749451023; Sun, 09 Nov 2025
 20:37:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
 <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
 <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop> <CANT5p=r=QgseACdUQySq2MCxycMsG-EvHCx-wwUPWo+xkSRVXg@mail.gmail.com>
In-Reply-To: <CANT5p=r=QgseACdUQySq2MCxycMsG-EvHCx-wwUPWo+xkSRVXg@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 10 Nov 2025 10:07:19 +0530
X-Gm-Features: AWmQ_bkOGF1gFLwSwA7TzLwObldE_nxPMnKrzJvI8FrFYr-ts7AmFTifK7E1zTU
Message-ID: <CANT5p=qMoEMMM_f8Qn8C6hK2pBDLJ6HhqRY80ORrC23CD8i18w@mail.gmail.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Mark A Whiting <whitingm@opentext.com>, Steve French <smfrench@gmail.com>, 
	"Heckmann, Ilja" <heckmann@izw-berlin.de>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	"henrique.carvalho@suse.com" <henrique.carvalho@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 7, 2025 at 6:24=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.c=
om> wrote:
>
> On Thu, Mar 27, 2025 at 6:39=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.d=
e> wrote:
> >
> > Hi Mark,
> >
> > On 03/27, Mark A Whiting wrote:
> > >>This is the fix we used (rebased on top of v6.6.71 tag):
> > >>https://git.exis.tech/linux.git/commit/?h=3Ddata_corruption_v6.x&id=
=3D8d4c40e084f3d132434d5d3d068175c8db59ce65
> > >
> > >I tried following the link but it gave me a "502 Bad Gateway" error, I=
 also tried the link on my personal machine at home in case it was my corpo=
rate network blocking things, same result. I don't know how big the patch i=
s. Any chance you could just drop it in this thread?
> >
> > Yes, sorry about that, I'm having problems on that server.
> > Patch is attached.
> >
> > >>@Ilja @Mark could you test it with your reproducer please?
> > >>@Steve can you try it with the reproducer mentioned in the commit mes=
sage please?
> > >>
> > >
> > >I would be happy to try it out.
> >
> > Thanks, I'm eager to know the results.
> >
> >
> > Cheers,
> >
> > Enzo
>
> Hi Enzo,
>
> I reviewed the patch from my end.
>
> I think you missed the test for non-dirty folios in your change.
> -           if (!folio_test_dirty(folio) ||
> -               folio_test_writeback(folio)) {
> +           if (folio_test_writeback(folio)) {
> I think this is why Mark and Bharath saw the WARNING with this patch.
> This happens when there's a clean folio in the extended range. With
> your patch, it will add such a folio to the batch as well.
>
> I also did not understand the reason for setting stop to false in these c=
ases:
> +           if (xa_is_value(folio)) {
> +               stop =3D false;
>                 break;
>             }
>
> +           if (unlikely(folio !=3D xas_reload(xas) || folio->mapping !=
=3D
> mapping)) {
> +               stop =3D false;
> +               goto put_next;
>             }
>
> It looks to me like it's a bug if we're hitting either of the above
> conditions. i.e. file mapping should always match and the folio should
> always be a pointer in the file mapping.
> Won't we end up in an infinite loop if ever something causes these to be =
true?
>
> Rest of the changes look good to me.
>
> --
> Regards,
> Shyam

Hi Enzo, David and Steve,

Can we please review the above and send out a final patch to stable?
Without this patch, this is a serious data corruption in the affected
kernels.

--=20
Regards,
Shyam
