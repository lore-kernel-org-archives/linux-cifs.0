Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15514C85;
	Mon,  3 Mar 2025 01:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740963676; cv=none; b=YofLK4pKKGrax+9NACCVvrKvlwN8nuWontZe5xYIt9BlVxieHalJiFUX/2kc6WbuT0czRzL1nvkyL/lrWUC+tbToZff4kcMfYfURfyS6f072Nd3rKqo58UifuHewqKdSNnGMU7MuZ4aIh2GW33srpsAMphOGzwMHuJo9nd1muws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740963676; c=relaxed/simple;
	bh=Po9xG9WKX9OTMGJClcDRNvxjusCc1FMhgHLpR7y/5FA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WTn8XSKWVqRvyOH1/CaLusgaE3cSUTpMzCmX68/QA9OGNLh406HPTVTLjR9/JD43VQmx+LHB/wdex5wpTLuOiEEmja8WqaY7mMwxYaIZVkot6QiZVz8zMw708ROmnZgEK9MdOMtKJkgUBNNpQvuhr0cFKYehbUMOJJuuCel7oAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eRKP30R8; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eRKP30R8"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5495078cd59so2569252e87.1;
        Sun, 02 Mar 2025 17:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740963673; x=1741568473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Po9xG9WKX9OTMGJClcDRNvxjusCc1FMhgHLpR7y/5FA=;
        b=eRKP30R8uYU+tKnKqhC6jxjqbT3SLNomZkeuVMpdmfgoEZXc4ceW33qEXW5RfQu6xr
         MBPqTQ0YXiIjeZcmVYNij7myDUc7ogUY7mcfPK6Ky6liJzLfttnlacRWQ+KAkdxazibr
         FRxDIPwBrEtIygU3BO5Zll02gjLpa44eRuYlQ1vpFB1NzU0u7gd607/TLhUwW/A6nGqG
         McCVSJt5RBMIZwypGGdmwDHVlZGa5Or+D10uEEiRyzo9MV/cDh8JVLM9R7PsiXd4dOdr
         P1D1EboeW5lhT+IAPcWiSnKkEqi5OcoCXGnsTZXDjwdGOnMLYixecUP53nmKTzXbP2YG
         Tz4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740963673; x=1741568473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Po9xG9WKX9OTMGJClcDRNvxjusCc1FMhgHLpR7y/5FA=;
        b=FYBC6CwnVxW6ExuPNRKdIEdJlsoxk0wtCEEwhzt7f12IhSIq+ZWcV9sOgPmG6J7kop
         fEskscdhuCeBKYAh9FuTElSM8jKFxOKyPlVC0em+dK0pXtkazDQ/J1TneKHh0XG1fKTZ
         nOJKCx9ejmEJ1Fm7vB+M/OEtlvHgsGZPBRGyOJSiWiijDiVajhXi4dhTa+8GI+vumkCi
         rONzjtxvQR8SkICaeskY0bSeW4MR6zFCZ9KC/yv9YK67yG9dfUT5Fves3qgRgU6UQEZQ
         VZ7wQZWxSWs9B58SbvrmNntxDb/Hvw2JXEp4hso01dM0koQgnDc90hUip86Y/yYsEVix
         fJ9A==
X-Forwarded-Encrypted: i=1; AJvYcCXV+63JBFY0nWgRweLn/mhjMnWBIEspXRnEU6q0GHrxjlpiFC3FtNCMlvQSIFKyTYsRtoE0S7F+K0tr@vger.kernel.org, AJvYcCXyGRn357Ft8ju7f67pemPR+SCM46tXANBaU6eaIyq5woTCiE2igHN09SgkbDJzz+pYMyrlt6u2RPZFyjEK@vger.kernel.org
X-Gm-Message-State: AOJu0YzCd9VRiHpRIIJOwYYfAoAqNm1dOYJ0RrOx7+Hb2NhSuQsXhZD+
	G/Y5oJOX1OOQwtU1jRx3hPnh5zQgqTmfWdlJk0F6S5nSpA4/ei/xLlYd6Imjpuv2DnEUjy3nEis
	+JuMYY800DJ6cLLH9dZzdZtWmMr4=
X-Gm-Gg: ASbGncuB/AIOREP5jI9kYq6/KU+uO94LhBL94rmeK20xUaicYkdaAA/QlqJaYK6M62A
	uX2hp3Rv+rz8MRO9vA6JP3yUWYH9cXRHV3Ag8u2r6pAuSrlLOrHpa+K5KlPsczdoquKQGI779TR
	asMzws0fJCswOJLnAvKFEkexER3ZfHUbJ1VRkUnbkbYSMp8NsHnjn/octtVFc=
X-Google-Smtp-Source: AGHT+IEnYYiUTYhUxg7YSQ+WTYFU0qTRXKlzxdNz7IbJPrqNX6rwb4Jr5N6QTwE06HlWjhljpLb9IaA9VniiYQt1B8w=
X-Received: by 2002:a05:6512:3ca1:b0:544:ffbe:cd22 with SMTP id
 2adb3069b0e04-5494c38bd17mr4149185e87.46.1740963672470; Sun, 02 Mar 2025
 17:01:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241222145845.23801-1-pali@kernel.org> <20250223222306.plgy3bpy5mjojfve@pali>
 <CAH2r5mv_+ZarrSPEhDjgEYPzqkvdqL-K7NjDsE0sXtrhx65G7A@mail.gmail.com> <20250302122446.dpqd6hlpfmy3fo3l@pali>
In-Reply-To: <20250302122446.dpqd6hlpfmy3fo3l@pali>
From: Steve French <smfrench@gmail.com>
Date: Sun, 2 Mar 2025 19:01:00 -0600
X-Gm-Features: AQ5f1JpQ1ZOOH4tIfv5tSkoAPQF2Bd0zKiwL2k4g9xwbWWX_Mz-7cy_2TZf5si8
Message-ID: <CAH2r5muzB=R2TA2-=XM3juVD1dhic=Wb_JYu71LYr9YyS5cXKA@mail.gmail.com>
Subject: Re: [PATCH 0/4] cifs: Handle all name surrogate reparse points
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 2, 2025 at 6:25=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> On Sunday 23 February 2025 18:48:50 Steve French wrote:
> > On Sun, Feb 23, 2025 at 4:23=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.or=
g> wrote:
> > >
> > > Hello Steve, I see that you have merged first two changes (1/4 and 2/=
4)
> > > from this patch series, but the remaining (3/4 and 4/4). Is there any
> > > reason why 3/4 and 4/4 was not taken?
> >
> > Mainly because I wasn't able to easily test it, and didn't get test
> > feedback for anyone else
> > on those two who had tried it.
> >
> > I am ok with looking at them again - and thx for rebasing.
>
> Ok, when you have a time, please look at them.
>
> > There are some of the 41 patches in your updated cifs branch that do lo=
ok suitable or rc5
>
> There is "cifs: Change translation of STATUS_DELETE_PENDING to -EBUSY"
> which stops returning -ENOENT for directory entry which still exists.

IIRC - there were some objections to this if it could break any
plausible existing application behavior, but will need to dig into the
thread from earlier.

Tom or Paulo,
Do you remember if this is one that you had mentioned?



--=20
Thanks,

Steve
