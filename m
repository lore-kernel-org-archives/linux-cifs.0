Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D644A762E0;
	Tue, 17 Sep 2024 21:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726607701; cv=none; b=YY7OkE1WUGNDrnbo63ORsFJeYabyoHRShta+XctWj7EiUyc2YYsgt7HtT5VpQBM0o4GIFaJfwmEVSpy5PS8a8GQHl9GHo0LjZfVBC7W9iDEJABDbNge54UYrlNJHnNoJrnpSVj4KZgYn3Jp5nl223AaRJUgcuJXFvyJUxyWGd38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726607701; c=relaxed/simple;
	bh=kJECOZCsW0bph0jwO/WiWvsCNSmNxOHaG+UK7d0vBJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mmZXNUKNT2g5QlPGSQUF3czgBEh+FZCN92VlLtV6J2qLoEXJwqp8oL7ea2F0w0zUWtUt69CUdo25GJv2/zGJRHXHprU+YLaZw06hkAmwFhwPTFLeW5A8/fp/AAcJHLCPtdIDx65q3t31UnNqYa+OuSPYljnMsOTPzI/s/mK92p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XQwqAPjX; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XQwqAPjX"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-535be093a43so7581329e87.3;
        Tue, 17 Sep 2024 14:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726607698; x=1727212498; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GNg6uisIstT3PKLiZhnOxCRwpJJd6ocjANF9dbenPCo=;
        b=XQwqAPjX1HAIyU0CMuWIJQXOC74dCXnhE9g+4q5+HnQNASzsXZAJbs8/Yu8jfjsGDd
         VhnB2J0WNs5hlAFe1VXV7y/mehWiM3pH0crnFqjK22J6kJ/PZF2RJCN6v/CGxxlTsQL+
         60zwnQuaIdXglppuUBPs2H1pFBmTTNGQmDaeFVwOx6lLobIXPbpozO90HQrtaPizEZXa
         XLgP5tvrYKOgY6br9M2Svv1ejFV3NR4jn7zJtoLLRwBwN+48ma/+Agk3NGVkAaqbmnaU
         dNC7hCtH7/EZArjzPxKtXTZ3lGrQBCwFnt7RDuaNZw44DP7V+0p6r7zubal0ckkGUGa1
         YszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726607698; x=1727212498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GNg6uisIstT3PKLiZhnOxCRwpJJd6ocjANF9dbenPCo=;
        b=vZ+b+frIfqRcZ0vwvG2RvbcmkHCp6VignrhMaurETdyk3cd6v9DLb/p9i3rpte9cFk
         h+e4B0HPPLadFJAvxUEQXn6Re1D8FCW5Pg/eyhXo6cHf1DuWjoZ0kxXYa+tdiQKPmBtA
         QHmguxP8shetYnlEkL32u4XsLzNbi4loY/D0/XBg7JBlvRhszwLxHsRFG9Yl+ixuLb/j
         ZuoxqiYm7DlVcvTzQYfC/iLpxvscn65jGogNay8R2eCF4bqgXwtTwT1tUPGEWKlmXfTF
         dui7hQhVF1XzWxjzaM4H87fvFg/caTOhgL78Nol16uTmxNtYxUYmAAueNsiCKx6iv301
         llCQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0KWyRpncaxUm5N9HSyb+o6GrtIHRPrGMs2W0fHs+OigxY97EzQzFQ++oIdJ4IN6cax5BAMtsPPtDqUyiR@vger.kernel.org, AJvYcCXdh/Dh4QIolxejczZT2Yk7vPtbPuiQ9tFLsP82/MMlM0bUzrOW59t33Bh+43nJxPs8Umy4Fe9Htui8@vger.kernel.org
X-Gm-Message-State: AOJu0YwObWMr+7cSr+sRetiVtnPcK5kPcRNUxg8vHF/6saOlBMjJNCiA
	ousc1auIfUixkWZmzMTaZRUzeatQ/NewpoakS7mfOjLDCTABntUkptc2JKsE2nAbyXxnLa3zrJS
	9fqhyZ8sxEIa1DQnxqkVVkoxRz9RJ3qS4
X-Google-Smtp-Source: AGHT+IFw62JFgbtc4EWdmaclsx9ONshsvHiY8ieUIwJLSe6BPrVbYk+kdvuTFThyJfKtnUzfw+gCOJqZJstndxIwADI=
X-Received: by 2002:a05:6512:31cc:b0:52c:d904:d26e with SMTP id
 2adb3069b0e04-53678fba511mr10018402e87.21.1726607697539; Tue, 17 Sep 2024
 14:14:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240913200204.10660-1-pali@kernel.org> <20240913201041.cwueaflcxhewnvwj@pali>
 <73552a5120ff0a49a5e046a08c6c57f4@manguebit.com>
In-Reply-To: <73552a5120ff0a49a5e046a08c6c57f4@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 17 Sep 2024 16:14:44 -0500
Message-ID: <CAH2r5mskTFRKF0sxjZ6qjrdtntCVHt1EfCR3o=3BuDa1PU=A+w@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL support
To: Paulo Alcantara <pc@manguebit.com>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2024 at 4:04=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Pali Roh=C3=A1r <pali@kernel.org> writes:
>
> > Paulo, please look at this patch as it is related to WSL attributes
> > which you introduced in the mentioned commit. I think that the proper
> > fix should be to change SMB2_OP_QUERY_WSL_EA code to not trigger that
> > -EOPNOTSUPP error which is delivered to userspace. I just checked that
> > this my patch works fine for Native NTFS symlinks and NFS-style reparse
> > point special files.
>
> Thanks for the patch.  The problem is that the client is considering
> that the entire compound request failed when the server doesn't support
> EA.  The client should still parse the rest of the response that
> contains the getinfo and get reparse info data.

Yes.  Agreed.

And on the

--=20
Thanks,

Steve
