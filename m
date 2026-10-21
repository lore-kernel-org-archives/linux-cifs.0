Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792545382;
	b=YXe+R7G/N4fvzCBoeWyoidVWf7HhXs9PVOS7TgeYaTrz2iFaiEAVnvfM/VMt0+jBqc7G
	 acGuz5OVY0gCTfIoiVZSN8lYCXWiBe/PENttVE5gT+KViwZVdAW0geytFuPydLXzIffPA
	 wuY3IF/pDySlD6mW71ah8LGBkqhhEKWnKBtK3048NStT2Hm/5S70YgPExPVyn/xVUDxKc
	 XGmUY2bMxUUCE6HBMQFGQ+CFsltBiiQCoKBIXa9G+T088EdaPLoSSwQHTa8Pd9PvvTQPf
	 YxBEVFV3CobvaSD59SS34N7oPHw94XCI5oXeZhS9CFE5iG1LOiI775ErpfCVymlmdlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792545382;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=C1Zu3q/4M5YlSjRAdHqHcdQCF5W+Ve8rWmucPgH6fQo=;
	b=rSA8bZ3/OnVK7RIyXnWzaFAWeCD4yQ8ahJDazBgy9kjrMw+Et/5X7OgLUj6ptGAG85Nx
	 8+Qrx/bOKMcjIjAU9jIUUXqcE3iSJkK693ZEFoTy+nD3SPdFJOyNy5xMzucdEsVceT5KS
	 BJ3woe8QN8rTIGDdMcsn4X3MRH4AxQ6tvE9AYAdLfhPP/IDTnB20jivo/ucmBJgGPkxFG
	 Xf3NnmYTENXvvqWkvz96gqnUAOLoaFIoi/Mo1K7huFuOOEoMY7eyoPaDXb/+hTgjtbxpY
	 tNSV+fJImRFAOsBOm+35IsmmgJvMlpYkkWLBmPVCDkiRDTbChmT6Zz08GYKqgm0qRIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=auQXPbrU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D876B606A328
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=auQXPbrU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B8B1F000D1
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792545381;
	bh=C1Zu3q/4M5YlSjRAdHqHcdQCF5W+Ve8rWmucPgH6fQo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=auQXPbrU+d46QzeWedty92gQ+SaltsQDpo/cHuW/EfBdR5ovAWkyqbhGuwnAMuOCB
	 Wa17lUnp/5lGrN9vHgFYNDtp21pbY6+Upty4W4/5hVWwI7Qd8jibYcbn2Gi1O/G/o1
	 97/L6Ga1ZqCwr7iew6JG37AkKbEle/vIXynv+gue3Qdy1Q4RJ3vKmK2WMjXdignRJ4
	 o4en5OlJwsyQe4GHmjFik4wCG1ihs2QDiDbMJt3CHeXlWMCzNw1HKU86dxRpe/KAfH
	 zrynH2OiYcTuoWil19SLb8aQGlY+mz+0UXiOYjpK1A4x91M0nJvehtbXZcwNHsyOA1
	 ieUCPZCpbO/kg==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6aa9164072cso209263a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 18:16:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx9HQqx2wmuMRPecCPMPZ0H0edki6eWq5ZPq+uZv+lRlP3OsHYtP70N20f6CfnWTqxPyOAM5sxQYC0y@vger.kernel.org
X-Gm-Message-State: AFq9FYJXeaOXQ3znxjefPgnzu5W3fwfZeKhfzWARq4iCmzmHQi5ut3D2
	4GnTPii9SDN9NX8TattbKmWyh8ocg05gfhK3b8Pe/Jn8v2F5Ll0Q7g9bNaYeywQftD46NKb/QvM
	pFqdP3OpR4bUQ+Gw2yGKoqZqoxrj82fk=
X-Received: by 2002:a05:6402:d0e:b0:6ac:765e:def2 with SMTP id
 4fb4d7f45d1cf-6b408ee816dmr216752a12.41.1792545380073; Tue, 20 Oct 2026
 18:16:20 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261020190351.9445-1-mike.michalo@gmail.com>
In-Reply-To: <20261020190351.9445-1-mike.michalo@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 21 Oct 2026 10:16:06 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8Y_+soRjs8s+EupSURydcLoXfwgrrU+LjxYAakzPMbEw@mail.gmail.com>
X-Gm-Features: AclHuK8arYULqtYMW9gfJfd5c06hmRFBXIgTLGP7s0acrXJOvgNIfJ5Q1906mRM
Message-ID: <CAKYAXd8Y_+soRjs8s+EupSURydcLoXfwgrrU+LjxYAakzPMbEw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: reject FILE_ATTRIBUTE_TEMPORARY on directories
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 4:03=E2=80=AFAM Michail Andreas Michalopoulos
<mike.michalo@gmail.com> wrote:
>
> Setting FILE_ATTRIBUTE_TEMPORARY on a directory with SMB2 SET_INFO
> (FileBasicInformation) succeeds: ksmbd keeps the attribute and, with
> "store dos attributes" enabled, also writes it to the DOS attribute
> xattr.
>
> MS-FSA (FileBasicInformation) says the request must fail with
> STATUS_INVALID_PARAMETER when FILE_ATTRIBUTE_TEMPORARY is set on a
> directory, and Samba rejects it too. smbtorture's
> smb2.create.dosattr_tmp_dir checks this and fails against ksmbd.
>
> Return -EINVAL, which is sent as STATUS_INVALID_PARAMETER, when a
> directory is asked to become TEMPORARY. Do the check before any
> timestamp is changed, so a rejected request leaves the open file and
> the inode unchanged.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Assisted-by: LLM
> Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Applied it to #ksmbd-for-next.
Thanks!
