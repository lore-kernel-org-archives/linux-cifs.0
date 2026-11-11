Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404337;
	b=qWlyyLl1BF4ENATEKpNNPWJefojO8x/bemJKE2fA5AqKtjGpPYbQgQPLvJp3aWnjD0BN
	 5wzva4gAPW2fna92QNxCgUHckvXN274xT0XQZx8EgcEUKpAKEQdR+OF21j+F4IVKxOH7A
	 I2O6KYdBPkIODwy1QRm2bIK459xGQdCEboviBLJz7bof+5I0a2CB/mzjvrzqtmlHE9o+B
	 ltExyreEOdWwR8SGNv9OirO5DUrxOF9nEYVXSybLUpqv7/aCdu8uduXJsuead+o+BFaa8
	 /gM9kG7MFqtTYOaVxYjNONPuv/AYLbK8N1gOPlsgproPKqL65FC9HZ1nhgjPHRi6Whw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404337;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=rfbv9bhVSLEGgYsnEU6dwbEphMUQAD1S6pv/+5EeMhQ=;
	b=ZjqEa+vg1FWcrvoq4OSY9upbFY6CmhNvSi2lnvQbjHiKl9BCa/nb8VrHHBEHDkyl9N9d
	 KxCb3vMURUM5wLWJ8nW1x95FovYMDI9Ab43p4r9Nj5yvqG2GNeZLOCS0/8s/0YEZYUtvF
	 ze9OC28FAVDBMAkcqY6T988mV0df86y94mS+M9rEFrmTQtSrJsT+XuXp7KxWhv/YN2NBS
	 U/ZsjXjVIK3M7E3hpPShk2/aJvT/Pih3YzCTWCba3SOW8n0lKXTQmifqcUfvziLmZesCc
	 JxaqgKmZ6CHj7ffLZgNNQi1wrzxmeYnLuQeCELdYOCrdIGrbtRAy4kQ0+/4vi3TaeHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X4i7mr6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF33606A31C
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X4i7mr6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4C01F00A0B
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 13:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404337;
	bh=rfbv9bhVSLEGgYsnEU6dwbEphMUQAD1S6pv/+5EeMhQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X4i7mr6gPSSF2E/Ve4zdudovA2+iCNE9re0m77iQC5MgPhHgIIQsqa2fFfJKKPUPA
	 d3oM8TeZUWahg1Sa1GWwgC5kGhE2cNosbRkHSoQVk1EFc2HMOWLcQ6rIJyUehoDeVJ
	 lewNK43vv+T29g0Y/GOhSol5AfZ6eIafXxkPRKhWWZ8qNAGxtm/jVoX50KinM0Mfp1
	 sBcn0/WoeJGDHje7l5fb0trsolW8vfBLdrQRrYBsJOONTdjDi1+SCRcCikA7ItsqI2
	 OWB2RVTbyOTPJ9miX3Hx/tXwu64JByL/E0TVD1K3orPLiyzLmP6+oZ+GnL/v54VXCV
	 em66wWrKhrosw==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b596569640so5092379a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 05:38:57 -0800 (PST)
X-Gm-Message-State: APuU4Z9Yoq3aDFSiL5d73RzzkYnzsBVoN7j+qqE5X2sF5l/1aenZyPGe
	xqV0xJFgOJTgoWRtiZotf7YHwTFeSUhJXNG5mot95bB8pD0WgqotneRygrbr4d+3P/F2EsPOWLX
	9MtCgvRODFr9THW0dvcg7uAX/UcT1gbk=
X-Received: by 2002:aa7:c84e:0:b0:6b5:8297:f44e with SMTP id
 4fb4d7f45d1cf-6b7773e79d1mr1475665a12.5.1794404336330; Wed, 11 Nov 2026
 05:38:56 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110225412.3937476-1-pc@manguebit.org> <20261110225412.3937476-2-pc@manguebit.org>
In-Reply-To: <20261110225412.3937476-2-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 11 Nov 2026 22:38:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_1=BdBt=+8+vgSn+jp80rEZpaK=daTL4=oXmhTA36=1w@mail.gmail.com>
X-Gm-Features: AclHuK-YZTIwe_wwVHJtgeyyjssQUcMYI0SsUyaMmENMvRZ1g5dI1wTXRrM69hI
Message-ID: <CAKYAXd_1=BdBt=+8+vgSn+jp80rEZpaK=daTL4=oXmhTA36=1w@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: flush deferred handles of other names
 before a hard link open
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 7:54=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> cifs_open() flushes an inode's deferred closes before opening a different
> name (hard link) of it, so the open can take a fresh lease rather than be
> reissued without one (see "smb: client: retry a hard link open without a
> lease").  cifs_get_hardlink_path() only triggered that flush when a cache=
d
> handle had the same open flags as the new open, so a differently accessed
> name - written then read, say - skipped it and opened without a lease.
>
> Match on the name instead: flush when a cached handle for another name of
> the inode is open, so those opens keep lease caching too.
>
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Looks good to me:
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
