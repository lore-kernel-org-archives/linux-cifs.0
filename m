Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D806336895
	for <linux-cifs@vger.kernel.org>; Mon,  7 Sep 2026 23:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788822019; cv=none; b=jEqptdfw0E6bijYc5grIcItJSdNhONb9QuTtpkL4WA4HygKPlwStMaU3usRNkX8awaYGV+aC9XHG48y0612VNvSxWc7OYXa7V3Wlw7Kf7UMHKI8m1bD+YEVQ4rMfj1PjzqdQ7bBzAWfZHoCNESE0tqCSwoHVBt/NU4ekbfMpg8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788822019; c=relaxed/simple;
	bh=LAl4kP0EIKlfl5zzSSLqvsqH7L5V5krRf2vXXXOvupk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mIvxRx++nxKA/h1g0NHlBTojwooHfQXAts3N7MZpkjo8cklXFOu4GXCkMEOyS/1v/4NOdjC3V2jAaz6b+zFKtlzaHZ8wg5V6w1NKhlcVKBt94lNWzCGsLewtOuSdMAqj7ps7w9V3PXEoIgkxTEOgsScitlAzDiFSueTxxaIVm/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbEhDHs/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbEhDHs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE11C1F00A3E
	for <linux-cifs@vger.kernel.org>; Mon,  7 Sep 2026 23:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788822018;
	bh=xWL6hggeuM5eeHa9vvklWW/Gt5aWnBuf5JmY/Tusxyo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fbEhDHs/3fj3uzoDUJqKlYc0QCLvWDYN35eACt2bEpfiK8ZtOi68tA2gTuF7rqggb
	 vXQs4W/B1irgeOHnwp0uUpN9cloktt4AroZXlJThYKHrEn/E/Cf1N0JGsORwS012Pw
	 QZIeMUEvTv+mShlFGA6MzYICFk3w2tlPDQep6+PEMILqbHm0CFYXKmO4Yle5ThaKOK
	 4IE1zpj4HdSq6akjDd/Hht2M6IJIl24Opn4mlzDDOCLXdDNVu2yXIRrWpTfFJoFWCW
	 XQL2uXRHu2vE2iYwklE5PgJLLItbXitLE3rv5I7osLMiGBpQm+G2jBYz+zseLtewQu
	 HmVKsMgNGDB2Q==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f8694a7so45239266b.1
        for <linux-cifs@vger.kernel.org>; Mon, 07 Sep 2026 16:00:17 -0700 (PDT)
X-Gm-Message-State: AFuF++mBZS7UxeBndsCPI17wGyzkkrQ63B8aHlLqzm2kT+61teGbZU3f
	/RVCMgF46D6ePAFOHyrBmZPR4sqg2+2Um6JRFm5LDYDGrDfbEpjwk4Qeu9nInnA/QFls4+wBcxz
	F0DNvNH/TbgIVb/JVcHw4g5cztsuavoY=
X-Received: by 2002:a17:906:f597:b0:c26:3377:752b with SMTP id
 a640c23a62f3a-c29042b7343mr148355566b.3.1788822016616; Mon, 07 Sep 2026
 16:00:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260906200517.725015-1-pc@manguebit.org> <20260906200517.725015-4-pc@manguebit.org>
In-Reply-To: <20260906200517.725015-4-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 8 Sep 2026 08:00:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8VZxLKDt8r-tg7DWEXWV=kOqKot=PSafoYcWpOv-cR=g@mail.gmail.com>
X-Gm-Features: AcwNN1U545zolvnjOPnYuXOAZy_ZzNwywL3O497r_OFSvmYawzMuk1ocV4hvfcI
Message-ID: <CAKYAXd8VZxLKDt8r-tg7DWEXWV=kOqKot=PSafoYcWpOv-cR=g@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] smb: client: avoid using uninitialized SIDs in cifs_posix_to_fattr()
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 5:05=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> cifs_posix_to_fattr() ignores the return value of posix_info_parse().
> When a malformed POSIX directory entry is encountered (e.g. invalid
> SID lengths from an untrusted server), posix_info_parse() returns -1
> without populating the 'parsed' struct.  The uninitialized stack
> memory in parsed.owner and parsed.group is then passed to
> sid_to_id(), which processes the garbage bytes and passes them to
> request_key() to construct a SID string, potentially leaking kernel
> stack contents to the userspace idmap daemon.
>
> Fix this by checking the return value and skipping the SID-to-id
> mapping when parsing fails.  The remaining fattr fields (timestamps,
> mode, etc.) are populated directly from the 'info' pointer so they
> are unaffected.
>
> Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40mangu=
ebit.org
> Closes: https://sashiko.dev/#/patchset/20260906181540.647469-1-pc%40mangu=
ebit.org
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
