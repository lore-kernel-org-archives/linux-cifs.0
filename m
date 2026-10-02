Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDFE306D2A
	for <linux-cifs@vger.kernel.org>; Fri,  2 Oct 2026 13:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946461; cv=none; b=Xbs7VDlYqUtv/06nYT8qv0SvOZaff6uoPVDwYuwCHrVMe9LxPLzg+2eK75kGRRk9lWZ5W5YlikkM0D7TpVcQIU366LUdD4Cra0NOYRGFqseJsttPxKyUM9wa4e4NyGAbOklwpdbI1rix9QDRZJAJ+sF4k2qZGG2x2uM2uSG4GIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946461; c=relaxed/simple;
	bh=rRqSxYBVDs5G95Y3/oR5AALYIw2h3V5XgBraBQoZiHs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l9zCpPhOS2EC5zm9BTCpWn3tAsf9FiUcA3CqjeLP+SI1Jz5yn94i6O+wILAfiesItEFN9fVUHXSb0RzUsuf6zpUgNJDo8KVEcfBbGhC3cLvIw5y/+rDnq2GsV0XTE68P3kBgIdJPhRa8/pz5qBFIKfNgHPVWu8javOwQKj6Igzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=huZ9La6K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="huZ9La6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6FE1F000FF
	for <linux-cifs@vger.kernel.org>; Fri,  2 Oct 2026 13:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790946453;
	bh=rRqSxYBVDs5G95Y3/oR5AALYIw2h3V5XgBraBQoZiHs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=huZ9La6KceihRkBl0hF+DMK2BM60t3Oe38MKnoLIQBTb8bAj2AXF8wYMfjWwb8fgD
	 qeDBj/9e6wRBy5O1xpAZaL3H2IMUbKTMXNTMhWyBU8gdamoAQI4lx+tf7MCrXCNCaf
	 /7hxQYp/eYnEdw52L75J3zeGFFHRFhAP0aQwt7IZHCDxtzL9brIqxWSJFdgmEFpZci
	 YTcpSv8cL+3Xi5ulMm32EQwu9ImTEsIGWjYchFtc1rfltLz3IpIySNBZTNmOSTV0Up
	 7jkcbd9GsoW6o7KVuZ6vxGvUIQKKq/qx6K8Vjaz1VEnlwuXP3P4ktwKYW4vaPvvkn3
	 unxeyzcteSWNw==
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e0b486d91so172766b.2
        for <linux-cifs@vger.kernel.org>; Fri, 02 Oct 2026 06:07:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxgjNmwPqhNZQMNCcnh0Wv8gvOikzjtmbPgy8qJZJHxVAiwb+ZpDxqo8HQJyguWpkdXLNjdcM8y/AV7@vger.kernel.org
X-Gm-Message-State: AFuF++mFhwjZndGz+jkgP9rquKSV1TJoVB68ifBwAbW+mM8zR4ZcZA3+
	hLv7vpjvwlDGubO3hlVTDyugLGrRRYTyY2snFq7IAaAan0zsdriCSp9BrJqXBFsIJmmIYP53Vfg
	y4rKIsdSNa8LDYWt7z22Bcim4hZGyESY=
X-Received: by 2002:a17:907:6eac:b0:c2d:f050:ad4a with SMTP id
 a640c23a62f3a-c2e4a8ba934mr222524866b.5.1790946451229; Fri, 02 Oct 2026
 06:07:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930183758.32342-1-3058704216@qq.com> <tencent_464A86FF7A38FD3620EBF1C6062745316307@qq.com>
In-Reply-To: <tencent_464A86FF7A38FD3620EBF1C6062745316307@qq.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 2 Oct 2026 22:07:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-fV0zP0wM+zcKtMcQv6DtMuZ9rwDC+zr0Q3KiktycXSg@mail.gmail.com>
X-Gm-Features: AclHuK987g3Vt_LWQapWiNtYD7Ot6aXK1r7jw7bgFxA4oWETAGLY1lxDqDJS46I
Message-ID: <CAKYAXd-fV0zP0wM+zcKtMcQv6DtMuZ9rwDC+zr0Q3KiktycXSg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: use clear_and_wake_up_bit() directly
To: Daijiamu <3058704216@qq.com>
Cc: sergey.senozhatsky@gmail.com, tom@talpey.com, 
	chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 2, 2026 at 12:06=E2=80=AFAM Daijiamu <3058704216@qq.com> wrote:
>
> clear_and_wake_up_bit() was introduced by commit 8236b0ae31c8 ("bdi:
> wake up concurrent wb_shutdown() callers.") to replace the open-coded
> clear_bit_unlock() + smp_mb__after_atomic() + wake_up_bit() sequence.
>
> Replace the sequence and drop the now-trivial wake_up_oplock_break()
> wrapper, calling the helper directly at each call site.
>
> Suggested-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Signed-off-by: Daijiamu <3058704216@qq.com>
Applied it to #ksmbd-for-next.
Thanks!
