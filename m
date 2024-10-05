Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A75615DBD5;
	Sat,  5 Oct 2024 18:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728153148; cv=none; b=TBGEJ9n9E/K4oiSpMEf75b3SmSN2geiZE2yF6WSlhgzKwCfkeFLx/6Kc8y74btpWpwxSRb3UCaCOlSkNv8I3al8ISGu3A32bhLnjz8QJJwLyiJIiwlE1kjaFBqTue4estl8ok5+v0lyIILbKs6lWfdPwIVsCKlJhGDa+uCfdd44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728153148; c=relaxed/simple;
	bh=ZkRTmO13misSKYHLA8WqddFnVMCMFoQiKD0dAnP8Bqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EVh8eINyy7AczDKkfbrDopKQNSdQ7aq9GpL+1VFk2KVyVePAOyauW/tLCceUtfhi7fjuwcuOtUGP4oSIJBmuCN4zmYuhTdsXih6p7gX+cXx2ZcynliJeaW0YBN+DhDNHqdYSk4E8wPpH5+WCrrB0mF5gww4lGLyGnz8IqRhoKTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=inQ9jLc4; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="inQ9jLc4"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5398939d29eso3919557e87.0;
        Sat, 05 Oct 2024 11:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728153144; x=1728757944; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=95HHUC7EFXuBzOd0zVd+AhrmvfhhpjfboAFysRBt1zg=;
        b=inQ9jLc4nPW9SeBWRw7Yqz8ij2BPWo9Vgso3Hc10zsz+eJZ3Hp6nWqOUMali2Flvy+
         NmIKY02Gqr7D6Aqz855sbxE+o/ax18W3m2F2bexLFeEJAemcfVrzZumvJusByuUVeUok
         9ChEP4RTHMR4H4neRZ2zK7TL8Vc5lTA9Aiy0/V8e8Df9alf2EB8+/iO9H+TeE71ej1HT
         YH1OqlJmwnSLqesolL9KhXt1Mr3JkakdDDUD50jnopghBxkDAcLyVTQHQ4cHgxCRXSEv
         YYNHOXYchTnmqT2WINCuETIPjtTTccl2bDVk+da2viUYlx0uKsDFAel+JaCY5XRqjYZ2
         ClXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728153144; x=1728757944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=95HHUC7EFXuBzOd0zVd+AhrmvfhhpjfboAFysRBt1zg=;
        b=oP6S10vrBs0RdzTibIi9EcQWYxv7/1gHsoiIrK9vV0ij7nzM9n5CZZrRnlbGrPq7xB
         N7Xcn206mquT1Xr5rMExlEgLCsYDOSZzytwFzdpAx2vvaNX0/LmwohEfemeNRWDLig5d
         gVkxHG2e7pvTZa2tpsWNsFfk06BFG8vBl/j4VtOWLlyA+dz3kMPvKRNx9Jneln3sVhDK
         u/3VlNEsj2vb/oX8tMncpSoKaMW6ScZutCYN27uHIPErZkxD70rt/3wUIEnnekiIF4bv
         8WnJRaYB6DsrniUAhww+/FgA8kIyZZReItW0G0TTkaa4lvhYoCkfzt8yXLu+PTjpQUnU
         qYEw==
X-Forwarded-Encrypted: i=1; AJvYcCVam/sDQQQpKfjm9JbxrRZJQg2VoZ4l5ZoeEumu1O2kBAlP+bVE7SZeC2FIzz1sXej8V5mybgwVame7T8Kx@vger.kernel.org, AJvYcCWmrwWuMJx3EWsLFic3NICIv0+p2U16Nt/7zw4r6N0fBx+QW2kWRsBq+tR/6ducJRZutrH88of3vH1R@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8SUb/dXOoAtLLF7BOdTjKr2e3aCvNBHRRtcsbIy8y6IUiwhWU
	zXSdWkZCe5nf4t7BnW5UT+TKRj+scGuRQJjs32xjP2m1gALAjREFQLlf/JsS4lNn7oDBN6BJSOZ
	f7NvEg9ckyk3Rxxri+eaR5E2C668=
X-Google-Smtp-Source: AGHT+IFHbb0fsXFJqB7tlNHdJBbwMrZDFLVYhd+su7G7RrwWVXckBepKb5wdK+T44aUIkcoN/ghhklLBhlaPtnCL+D4=
X-Received: by 2002:a05:6512:12d3:b0:535:69ee:9717 with SMTP id
 2adb3069b0e04-539ab84a7cfmr3611151e87.3.1728153144007; Sat, 05 Oct 2024
 11:32:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241005160826.20825-1-pali@kernel.org>
In-Reply-To: <20241005160826.20825-1-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 5 Oct 2024 13:32:12 -0500
Message-ID: <CAH2r5mtvp74nnU7ueqiyVrNLurM3ubQmBSTP=HcFqti=ZsWaNQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] cifs: Improve access without FILE_READ_ATTRIBUTES permission
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The obvious question to check is whether this would lead to any issues
if desired_access is not passed in in oparms in any cases (ie if it
ends up 0), and also that this would not hurt any cases where we want
to keep the handle cached (deferred close) but don't have sufficient
permission for it to be usable by the subsequent operation (e.g.
revalidate or stat)

On Sat, Oct 5, 2024 at 11:10=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Linux SMB client currently is not able to access files for which do not
> have FILE_READ_ATTRIBUTES permission.
>
> For example it is not able to write data into file on SMB server to
> which has only write access (no read or read attributes access). And
> applications are not able to get result of stat() syscall on such file.
>
> Test case against Windows SMB server:
>
> 1) On SMB server prepare file with only GENERIC_WRITE access for Everyone=
:
>    ACL:S-1-1-0:ALLOWED/0x0/0x40000000
>
> 2) On SMB server remove all access for file's parent directory
>
> 3) Mount share by Linux SMB client and try to append data to that file:
>    echo test >> /mnt/share/dir/file
>
> 4) Try to call: stat /mnt/share/dir/file
>
> Without this change the write test fails because Linux SMB client is tryi=
ng
> to open SMB path "\dir\file" with GENERIC_WRITE|FILE_READ_ATTRIBUTES. Wit=
h
> this change the test pass as Linux SMB client is not opening file with
> FILE_READ_ATTRIBUTES access anymore.
>
> Similarly without this change the stat test always fails as Linux SMB
> client is trying to read attributes via SMB2_OP_QUERY_INFO. With this
> change, if SMB2_OP_QUERY_INFO fails then Linux SMB client fallbacks for
> reading stat attributes via OPEN with MAXIMUM_ALLOWED access (which will
> pass if there is some permission) and OPEN reply will contain attributes
> required for stat().
>
> Pali Roh=C3=A1r (2):
>   cifs: Do not issue SMB2 CREATE always with FILE_READ_ATTRIBUTES
>   cifs: Improve stat() to work also without FILE_READ_ATTRIBUTES
>
>  fs/smb/client/cifspdu.h   |  1 +
>  fs/smb/client/smb2file.c  |  1 -
>  fs/smb/client/smb2glob.h  |  1 +
>  fs/smb/client/smb2inode.c | 71 ++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 72 insertions(+), 2 deletions(-)
>
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
