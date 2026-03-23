Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D97C3BE17B
	for <linux-cifs@vger.kernel.org>; Mon, 23 Mar 2026 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774280334; cv=pass; b=dYAJISJyCypag1DHCAqVsLU06P+N6dE5GEhB4J/xePuULRQ3uBmIhMMfzbhHB+ch5gv1r5DKG0zf+x/2SxHq5GaRTGKto/Uf5PtK/3lzn3PaRLaG+xrJD1h2zptZveItnx4nmqr2PiGekNlQQ4CmFv8w4xZ7b6p1kT+ZPWPvAj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774280334; c=relaxed/simple;
	bh=ZmWh/DuRvSZu1elnpeWrQV+U187fmJiYXIaGuwiNT00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ALi2YsCcMSPHUcnkngws8ans4rwiNcJvpupR5XM9XOGxFha6mfThIuF2oRAiXyiFujgX+qMRiKe5bpb7QWEt/CIOCeNFLrsbRXtCFcYBuDdSuusugetNbLgzjutMEhZkWsVU/91koHBghfyL0seBkd/tMRU/NDRYL62s000JPLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kyu4t2+T; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kyu4t2+T"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89a05955720so50235466d6.2
        for <linux-cifs@vger.kernel.org>; Mon, 23 Mar 2026 08:38:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774280332; cv=none;
        d=google.com; s=arc-20240605;
        b=IKaD3xOVJAHgPQr/WFNTHkz+VxiuIilKVDhyxW5pUNJdVuAr//akoTDqO7Lv7TwmX2
         oD4B/B2E57XEEJlkazNSffUIEv9a9EH+8jYHTGM1npnTKhuKGQRN2xbQ6EfsZiKiesXG
         UfohfmcF4eJLkVJX2/JYoWakICk6qCUT36Ys2EbD0aULd/dqps6rUBpMS+A55zWh0GYv
         yS4XcZGhYK0ZzBRlXmDVKderIq9C9qCp1tFVfh47bh0lIqn9ioKo47L7Mafxnz9zoUsy
         wyttB5LksZKHbMy+NR+kG0q7fELhoIWAyrDY7cHA6dHtJNienk/MXKGyin9wLnAkHV8/
         8a5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WzHQP2pHDPf8b/aNOBFwrKe9Fe+VkqE7R9SoZi1QpZg=;
        fh=DTb8pPzvp+TLrNsAlFTkuL1fMiA0GVG4SKAupMiIgfc=;
        b=QlMb8uoq8Nwc3F1fDvnoS4kCjqX2qVqewycocFW72Z6RKl07n81oRuZP7qW/QE5cRX
         CVuG+ZEqhCoCmGZXIb1fsnqcBltJxrYDB0fdssaMBdtOFSdV6DmW84MFnr/xJ6QZbm8X
         zHlhmJZXi0X5K52fPez8yG+sOTtXCWGSkb5VxXUGA3ipLzdnozw5FGcqLp+hRS4oBNJK
         h4v9y3NerIcnqaOHuyOPudoBZBCuOltIINdi6P7I/lDxsgoy+zslboV05VI7/+44W55n
         DNhXW3s5jAxFGelA7Ti0TvBpqwYf4IkBHwV8MFn5efoLNaiodaGaiLcUO7a1ELUM/e28
         fNlw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774280332; x=1774885132; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WzHQP2pHDPf8b/aNOBFwrKe9Fe+VkqE7R9SoZi1QpZg=;
        b=Kyu4t2+TvLRhO3qBKowGpfWLd4R7YxkDeWhm0SRSRCV472LUNS24z/BYINPtFUYp9J
         WK7o+V80H5Aj95Y4uPfn7HO5doXp9+/ofZHazI5vqnse5e9dWxWJZiFc/R85Vb2+QSJn
         5maBgVr6/uqyhA73NpRBmQn/TJ9Nt4cAza++x5cOeV5QVjsToiSDzA8P5q+s5wtCCPNZ
         L/RGtmFf2gvmDjV9ogw54iqXjjAwwYvoXk4fD4Gl/AuzAEc1QEMjeSBTCmcyH3OmOM7E
         L+0EMwevKqZALh0+2X3w7/ISJiGdRjBhoxPqZybUA8x/JcDPE5q5wYX8M0+4NBZyvq/2
         gIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774280332; x=1774885132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WzHQP2pHDPf8b/aNOBFwrKe9Fe+VkqE7R9SoZi1QpZg=;
        b=XG2LDJA/EC3XcOclmX4VoKiPnnDIZx8T0B39LKdiNR4sninQr3DSslkye3mNA8Ekhl
         daMFX9Fuw6OWVbMOqHJkVgRQDZ1b87caaSGaXr5/889BHitjpYjOV0OobtV++QvjzRHV
         0RoSQIP3lMxU8kTEz9TFbpuNp8i2Rvw03CnPryaSOTal5sww/CxEm0HlN0eqaKvFAGgc
         2PZNWEesVcmchy25TIc9YRVGFtj+1OhFkiur/Ixwo31mgdn3fGFWgroiVtqx7nISuMx9
         yy4tM8UhknP2oC2czabMZOkMqHmPLHZ8A5w+tNVEn6wokFYvEvG3PuKgxPgO7efAcgQo
         kOJw==
X-Forwarded-Encrypted: i=1; AJvYcCUabBxdoAHK/F8vkiiVWJXDm6Y1QDhOREFPu7+Qq7wBnAqVu9YcvRJ7hXWODRg0jdD093LahTt1cemu@vger.kernel.org
X-Gm-Message-State: AOJu0YxLUVAusVECDIf4bNGTEESKvbN+xJZbTCn6jCQviv0ypbTE0+A0
	zmg66rXeuInqEmMFi5lxbss8wvj+AwLyp2M/kZpCa/E7ohxOd43dlAOewuC2vfI4EzLBhDHy56F
	8IYU8cmByw/Eo+/34ioLKa/6nt39yzX4=
X-Gm-Gg: ATEYQzzQ5Z6fIA+YZmC6zdpRxek3STOmfjnYcJGd+rbixCzNSt2fR1YJvm+sTbRi7Y7
	dyPDO17DabFl+iof3Hf4x/hjwE75DCnw/wzGfUAFSM9bGM1vv7w/+Z4Sj2ETqM7aFwRCQHkf+vx
	+RhV2oTkO6KfZAHBp1dcTGbIEy7tq1aSULGLlBD8sAb2mgAvK3xnfk3dc1gUSvZo185A/WFfgg4
	sVXaq0xjWHJADndNyqN9HJaumHu1wp2VYBFK/Dz/N/lZsf21bKoTFvTPOoWyFFQSmScgjpnw9WQ
	yZc8Oj4qveLdObbNAm5JTbE+37ire+KZMY3/eKTqpPSL0i6PS1Q/ooDNIV+ixB3EnU4GVFmqYKq
	8RKA6xNztXmmKs0v2o17urBCwvCe0BqgNBzQRwiyo08fVde6penyI5XhCkGMuzFxBcQ==
X-Received: by 2002:a0c:f101:0:b0:89a:6f04:ac85 with SMTP id
 6a1803df08f44-89c85a9043fmr158483166d6.54.1774280332010; Mon, 23 Mar 2026
 08:38:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202603180118.ClDWNtId-lkp@intel.com> <b859bfa1-7844-4b23-91a4-bbd526ffc19b@samba.org>
 <CAH2r5mvvjWtJza+9YrLYvneysyEQa5rENhTYiFTAwrE+KhOy8Q@mail.gmail.com>
 <CAKYAXd_yLYLD5SsRUZy8d6u7vknTPuN8Cbe11HJt0Eq6bLzBBw@mail.gmail.com> <69c54f80-dff1-4c02-af97-08799fe59b94@samba.org>
In-Reply-To: <69c54f80-dff1-4c02-af97-08799fe59b94@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 23 Mar 2026 10:38:40 -0500
X-Gm-Features: AQROBzB9SG6sPgo5T8QjqxwVih72HS4tyEMWLFluaBLXGLnuGbVnDzT8w0i3o6U
Message-ID: <CAH2r5msADO+SbgJxwX0vNU0keHb5WScqOmrb+uszmG2uZt9Qrw@mail.gmail.com>
Subject: Re: [samba-ksmbd:ksmbd-for-next-next 11/12] fs/smb/server/smb2pdu.c:5723:3:
 warning: variable 'pntsd' is uninitialized when used here
To: Stefan Metzmacher <metze@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Asim Viladi Oglu Manizada <manizada@pm.me>, 
	kernel test robot <lkp@intel.com>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Steve French <stfrench@microsoft.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I agree - looks like a bug.  Should be setting the declaration to null

   struct smb_ntsd *pntsd =3D NULL;

since the initialization of ptsd is in an if clause, you could end up
doing kfree of uninitialized pntsd pointer on line 5801

On Mon, Mar 23, 2026 at 9:52=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 23.03.26 um 15:43 schrieb Namjae Jeon:
> > On Mon, Mar 23, 2026 at 10:22=E2=80=AFPM Steve French <smfrench@gmail.c=
om> wrote:
> >>
> >> looks like a simple fix to initialize it to null at declaration, right=
?
> > It seems this test was performed on an outdated version. The current
> > ksmbd-for-next already includes the updated one, so we don't need to
> > check it.
>
> For it still happens with the current state:
>
> 1ce4e48216b84385319da308f2262eb11ee7e459
> (smfrench-smb3-kernel/ksmbd-for-next) smb: smbdirect: fix inverted compar=
ison operator in negotiation log message
>
> And there it's likely:
>
> 6a0795e46296589d8eba6c194586e9e65974d73f
> ksmbd: fix OOB write in QUERY_INFO for compound requests
>
> With setting it to NULL the smatch warning goes away.
>
> metze



--=20
Thanks,

Steve
