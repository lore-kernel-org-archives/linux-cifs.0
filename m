Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C6222F74A
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 14:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780755531; cv=none; b=gA/vRwIWhRGG0MuPyNT0Cp/9FhDM2BmDFfoj4/QymyOV/ijKijtJJqkP3krvzKVawi2p2VYtfUISvw30dpsc9ctpdHmkg/cdgN6L2RQ8xPVwj1DFTBjBbKom48B/BFzsp1jm/YMg32svvPnC/Ncd9DcuKfIqr4ibJp8T5cuZ8Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780755531; c=relaxed/simple;
	bh=1S0TJEf+mjTHKBL32nnH68AZaI+NdhcA8Rn0zKV0jiI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Oh8WzXM38jFNcFHKrJZOEVHNTZjEmUwUqScXlv4pU5pxgFIoNsNiBH8Ne2NwG7dVC5P04l+b+MsK9RiZM/tuzUG8B4qZHEnaOIqRoBydoTM8SOZDK8Fm/LgBjCppExulIqTKYIuhJxPMiNiMUbJT73v1u2lh9b6hw6kThPP2OtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUPae6oh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUPae6oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4B81F008A0
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 14:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780755530;
	bh=1S0TJEf+mjTHKBL32nnH68AZaI+NdhcA8Rn0zKV0jiI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SUPae6ohfE8IGPxpSt6tFvxve+4zVM2lygOU/W861rvM9ckx2wm29U8Y+Du66LPdP
	 mE6Egbs9gQYgy8byZdclM7WxDyr0C1/Oh75D60wyB7youTCW6agW1UU2ftr+n8FqWz
	 RS1G3u1MlEZnV+hnFctvwfypXEors5xhIwxuKFwyLrItAVDdOXt/q64pXsmykQlkss
	 Rr9yPhfYOpobBSPxG4S1QYwuDvnveNgCWG5BqyYMYzHkM2zpCM0nmcLP2hxMKFwcE1
	 MzfpqrKtuDrRNWyGXyT3rkc77lnkSSZxzfsuC5piCn5dtMeV+xARFkgAR+1EaavhiK
	 jIPbNZXgVFc0A==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bef1e6423e7so283745766b.1
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jun 2026 07:18:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+XUo+8r3uTG5tTWtCgU+on7Umb/ZALBLyd3BNPbgLpieBLsKrF8hjmfPQhJpOvvqO4jJKb6L9XW2vL@vger.kernel.org
X-Gm-Message-State: AOJu0YxRW/P8Fp+QfAnSk1np0V+C5QxmADVYmloIPRpZC1bh0cqMlxGH
	fy48O1JI5U9NSFL7MoQ6XSFVGCVj7Oa94WhoHZ09a+lW3D9l99BHc2SB+mdw2Gxh5JOLlWqv66A
	gOHvFRDm53t7wbXcwJpPQoa+AEi27KuQ=
X-Received: by 2002:a17:907:8b9b:b0:bec:894d:dd3f with SMTP id
 a640c23a62f3a-bf37164d6demr421150966b.14.1780755528628; Sat, 06 Jun 2026
 07:18:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-2-chenxiaosong@chenxiaosong.com> <CAKYAXd-inU4rYZ=P0SmLUwDdL-x=QtJuBPdSg2DRKZMF-KuLDg@mail.gmail.com>
 <a4502395-735d-4c90-a116-754a3e91137b@chenxiaosong.com>
In-Reply-To: <a4502395-735d-4c90-a116-754a3e91137b@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 6 Jun 2026 23:18:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-H6PoLQ+4CTMFg0UvRB7m8V+UinVQRcCB1yk-icB0rrQ@mail.gmail.com>
X-Gm-Features: AVVi8CdEm_EVQOLoYN-b8BkIiYvOPvFTMdnxTbb7tu1OHhaUfDqYo679bJPPc6s
Message-ID: <CAKYAXd-H6PoLQ+4CTMFg0UvRB7m8V+UinVQRcCB1yk-icB0rrQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] smb: move compression definitions into common/fscc.h
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 6, 2026 at 10:51=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Please see MS-FSCC 2.3.67:
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/77f=
650a3-e3a2-4a25-baac-4bf9b36bcc46
What does COMPRESSION_FORMAT_DEFAULT mean? default?
