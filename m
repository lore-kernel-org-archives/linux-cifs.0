Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0B43368A7
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038351; cv=none; b=RTTprYiFp/YrFFWC/T/6PsJZRJjH3qDfIRNtk8HX3L6iIzac++gwf2tmB/ueK2k+WWehfH1IicPfP6koBIQ+THJtXPWonJOFJ3JsHLE7+5AAqUXbI3bFr1f+WKjcZxvIdKCshIAUbeDAMS6LYkvbcO0q0LYfKH9rwFjH47iytoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038351; c=relaxed/simple;
	bh=gWVKoELc41Q4ODZB1q8SMDrSdFTmOOLGWTN6c1AFAtU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E1P3NtiZyAWMAbFRNvSzrbLg11ePq/pelctqdsp98ZkUcRooKlEEhJr+doBzgohiy4F85yLikwaNq02IWNU3p/OU6CGlh6VGiPf74rPIdgzIvvfn2vZ1iIhYnx8Iqa8lwWlpG8Rnv10zlKN62glbm1k3ow3BsBUFJ0ok4km+qoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=na3h10R2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="na3h10R2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9882F1F000E9
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787038349;
	bh=e/55hTSdvUMsXq7z6LxDTJi6siRoDAYgW8jGyft10fM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=na3h10R2b5vozIoca5z+mguPGClZ4AanuATliEWV1y8lk0nN+ZVg7XybohUPZiNZk
	 NZyKCi2Toi70dsWp8svlBPRRGkDn4nN3Qey6pKb75KjfNCnWmGeWKTIwq6vqdOUWO0
	 Umw1NdlGJqFgMO8F4vyMfA/oiNcQmYnDpeGCDUc2M2yi1Nhck+kQH1NDNSDcY4G2C9
	 IQl9GyUdlAxhHbP3cDGLNgnsr16Yia0pZh7DEKoXRXXLl0YweuSiwTh3lbxGlqLPzP
	 WuTLDoXKeEMYWNDs8bKsCkk9VUB5oS11fb5+N4g0UJ7ojrkhTJaPtmj+8HJGao8Du3
	 +Q4JRb9YVscAg==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a1a546a6bbso6465411a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:32:29 -0700 (PDT)
X-Gm-Message-State: AOJu0YwWhXsSqOb9WFp+Y6RY4dgB1VLZ74b0CnK/jMpFGUGJf5Bnnr3V
	k5odi4YdYyA4snh7XdYeZbPxI0jZ9ml7GkgJtg3uSKtUADso+afGCRE//xnBZkpsHJNL41SxNe1
	K4b76gn7bw3n9sesAofR9b5qZr3pIcp8=
X-Received: by 2002:a05:6402:4345:b0:6a1:29ca:681e with SMTP id
 4fb4d7f45d1cf-6a38a927f6dmr13487735a12.7.1787038348259; Tue, 18 Aug 2026
 00:32:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260817171651.212730-1-sorenson@redhat.com>
In-Reply-To: <20260817171651.212730-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 16:32:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-5mhDQ=2VYkvcE8KRiiMBJXSFiiYwTY9DNNVdsMaF3=A@mail.gmail.com>
X-Gm-Features: AcwNN1UTgT6BGES4hWTDWJFq783w-ccGdA01bNHp2__GkFQ2Cu9_UCmwahtbntk
Message-ID: <CAKYAXd-5mhDQ=2VYkvcE8KRiiMBJXSFiiYwTY9DNNVdsMaF3=A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix ALIGN() overflow in symlink_data() error
 context loop
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, stfrench@microsoft.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 2:17=E2=80=AFAM Frank Sorenson <sorenson@redhat.com=
> wrote:
>
> The check added by commit 7d9a7f1f96cd compared the post-ALIGN length
> against the remaining buffer, but ALIGN() itself can overflow: for
> ErrorDataLength near UINT32_MAX (e.g. 0xFFFFFFF9), ALIGN(x, 8) wraps
> to 0, so the subsequent bounds check passes, and the loop advances by
> zero bytes leaving 'p' pointing into stale data.
>
> Fix by checking the raw ErrorDataLength against the remaining space
> before applying ALIGN(), then checking again after.  Since raw_len is
> bounded by the buffer, raw_len + 7 cannot overflow, so the second check
> is an exact post-alignment bounds guard.
>
> Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Will appy it to #for-next with Paulo's acked-by tag.
Thanks!
