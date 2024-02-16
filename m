Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E2714A8B
	for <linux-cifs@vger.kernel.org>; Fri, 16 Feb 2024 00:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708044776; cv=none; b=W8u1tDF0U8XSuH/NN4i52JlRZQOtU0S3D6MmR5d+lQoiY61pOU7lFo8NI7IgII9MaZii4GM4s4J8CmMnqiGOR8qXeu1pDKZlluiuJI6ZRBcSD1EpPIQqriSvIAgUfGlMWnDU+2LYdw6SSe9MNi33BBnNXXJ5NCwZlupj3V5g0AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708044776; c=relaxed/simple;
	bh=IbMYBt2S3G4CrJ49lc1opGouEoBIc/Bw7NDLYV0Cvbs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bJK6azWlDyWQjfpicBzV3N7yiupqgitfhlF89YwuUi52WS3x9skAz4zny+1/BWlLP9hVbsm7Xq+3B+p3LrxSU0T+3/eTZyCLENJAKYl4+1V/0bqS5dPTm+A0maoNviMZHzyY5qC75YmIGEihnCYJCVwzucvO2M8ra0UDQ4lZ+RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NurOnveS; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NurOnveS"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2d0f7585d89so2589861fa.3
        for <linux-cifs@vger.kernel.org>; Thu, 15 Feb 2024 16:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708044772; x=1708649572; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A2d098e00MjE5O4BB27Z4uB5HVxslffyQJSq7EYi5Fs=;
        b=NurOnveS7jz85wcjy5OLYvrAQ4hpEHylMjAzLUMAH4PI158blSMfFqdbxJ7Y0HTZvD
         s3cvUqkWznFLrrvVH+TfPwOeBQdCTrIrgv5E8nAlvwzY8FyUw4K1wAGrpoj3Xvd8OEx8
         1jSGb7ka9V0w5ld4xuJ+ftlfls26JEwdw+OH0By8uB0swhznpxnaKex9nLxkUZxG6HHT
         JkJn4LJra17x7UYjGYiL/WS6mp9AOuyWLH6HqM8KXvDndXHajchrH/ndj1B9emX4xENw
         DeY04hxm+C39NjhnYQvnB56n6zMlLzJohJfSKuHnyIaBdIRa4+tW4xGJjmnUcvlGiJ+e
         e5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708044772; x=1708649572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A2d098e00MjE5O4BB27Z4uB5HVxslffyQJSq7EYi5Fs=;
        b=Thuv/SAdUSeLRmXmDKdN6nt5S+zLmepKaKxGzQ+9gMz1d9vnkzDW1K7zr+UrmlqxXz
         Zp5+9Sxf5HDaZdt+NPDqt2eGGGj6dppEWX4TA6EamlFdCNkjiJ35KJLK8WVbtsVSFrVP
         mQtD7mUyE/FsB3EBJXaUS0hTb0aL1avP4ivdpOOryWKuNnSVhqcFbx5W3g5zgD2i5o0J
         lu5Muy6Bu6lwrQYE/A2Gdq+XJTMBx79lCYBRvFcc2yvJHqzVaHkgiC9w50Uz7dJ2qUR1
         qj1eHsvm4r3E+3GljrFgla/7ZfVyCQiTJzbgOLP4t36jCoFlzHW5S5ODeKT/Cv77zshr
         80WQ==
X-Gm-Message-State: AOJu0YyWtMj4X+sWs29i993hdgbUYRTUUbGkhgxd47INcnhPdB+R1FzZ
	TFznpIX9R6ZmBqC3nFFa+KWJGwLKGKwNrSO9bktuvUJxzclZkkF5GXwOcpWJvID28903clAi/8B
	KivFm1xkwj/nfXYoBYquC1yBqqUM=
X-Google-Smtp-Source: AGHT+IHyv7PKfnEL8ag3c+/Wt7xhqmUFfrqiuCzvvCTt8nqfV5j9LkGBJ3IsRTA89gC+ZW0n6SNClPoNL3MlXfqUf0I=
X-Received: by 2002:a2e:9952:0:b0:2d0:7fea:2920 with SMTP id
 r18-20020a2e9952000000b002d07fea2920mr2574039ljj.37.1708044772280; Thu, 15
 Feb 2024 16:52:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtUnLDtwbW7or=Uc+AXkzLpHsJoPuoLE7yyjPVYjvZCow@mail.gmail.com>
In-Reply-To: <CAH2r5mtUnLDtwbW7or=Uc+AXkzLpHsJoPuoLE7yyjPVYjvZCow@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 16 Feb 2024 06:22:39 +0530
Message-ID: <CANT5p=oNRF9BAgybCX7dE+KvYj=k2G3tERa+fMJOY6tsuZ00Hw@mail.gmail.com>
Subject: Re: [WIP PATCH] allow changing the password on remount in some cases
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Bharath S M <bharathsm@microsoft.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, David Howells <dhowells@redhat.com>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024 at 12:23=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> cifs: Work-in-progress patch to allow changing password
>  during remount
>
> There are cases where a session is disconnected but we can
> not reconnect successfully since the user's password has changed
> on the server (or expired) and this case currently can not be fixed
> without unmount and mounting again which is not always realistic to do.
> This patch allows remount to change the password when the session
> is disconnected.
>
> This patch needs to be tested for cases where you have multiuser mounts
> and to make sure that there are no cases where we are changing
> passwords for a different user than the one for the master tcon's
> session (cifs_sb->tcon->ses->username)
>
> Future patches should also allow us to setup the keyring (cifscreds)
> to have an "alternate password" so we would be able to change
> the password before the session drops (without the risk of races
> between when the password changes and the disconnect occurs -
> ie cases where the old password is still needed because the new
> password has not fully rolled out to all servers yet).
>
> See attached patch
>
>
> --
> Thanks,
>
> Steve

need_recon would also be true in other cases, for example when the
network is temporarily disconnected. This patch will allow changing of
password even then.
We could setup a special flag when the server returns a
STATUS_LOGON_FAILURE for SessionSetup. We can make the check for that
flag and then allow password change on remount.

Another option is to extend the multiuser keyring mechanism for single
user use case as well, and use that for password update.
Ideally, we should be able to setup multiple passwords in that keyring
and iterate through them once to see if SessionSetup goes through.
It'll be a bigger change than this though.

--=20
Regards,
Shyam
