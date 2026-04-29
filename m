Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B647A2F745C
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 22:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777501623; cv=none; b=ecBJ59tJQIWMhuUaJq0QuEpG/TUmPu2U2NOwLj9phbNoxDxc8vEVRH8OPwLCSWvoJCsqSRyjoIDYx9cbIlLLGmKUm9dkA5eNgxCDBZvQ3beq75sZ4YcqcS3MBaVBiOyQwIGIOtG+fAg74eh779CNuT+qRynfqILWA2z8dDtkvOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777501623; c=relaxed/simple;
	bh=7FLLuNiWW2NwTFYkSS2VB5lf5N9zJseWiy+ROo0ySpU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EOmSjCoqyTmQHLxrcJWwsAy9rt2FBJlmLq+2bNqIrdoX2eY5X9VD/TUsy0tu8ZTIwdv43MPErWMP3GnF9rtzhBwU2uXX+u9BUrMBrxc+Bm11ONhfK4O22u8WybPoRxq2dtRo5CTizXTTzb2PIGgVEL/AcfYj1lBwNUnkStNx9BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOivjC+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOivjC+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C4AC2BCC7
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 22:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777501623;
	bh=7FLLuNiWW2NwTFYkSS2VB5lf5N9zJseWiy+ROo0ySpU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oOivjC+RwP0V6ke89lBZ3ALGXss2S6XGVTYm5LLl1KDvA5TWWb5TtPNT3ybypeKsC
	 7kOAYq1OQVRMmXidf9qK1ur2lGDFMDVHfFyGo3cR7Gf6UVzFbhrbDCOrpcX0lQ+JIi
	 zUlLJcyF+rQ1/ZAgrNBnE0hcrUKrLlA5y77ORzUaxvkkgnGmMroWbTx2rHnDsYR9NI
	 DIWxO5JXg48/5ejjfsWcaXJ0xFrXZ0PmotUdqp9XVRe12f8RAz0HZNlP3Taa9AjoDh
	 CyAaDk2jQbEsws5AO6G0AHR9sHIV4W7QAak76ecM69uckLfPbxYk8Rj3VFfwPrlPCx
	 i1mTyLpTXOsTQ==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-671dad7cac8so377515a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 15:27:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8SVkUlUDG+wTPScGC7TQGYRVafDHkcBf+4J72TAFCYgWThFIJQf9uvyBR+6TC0R3PyaUV1V7I3+HGe@vger.kernel.org
X-Gm-Message-State: AOJu0YxgHXQuRMAmlwnHY4FKySwHpp4hGBRes4Vxjc3Sh3WrKo/ng3Ad
	/kMcdaUwRiM3GEdarEdEmhP4u8CW8zXCFQGm009M0J22RSWLiFH7P8wAp6rFKG0MqsfLtVwBR1N
	E8krZGV/XEaoJxZf6wlrUHkSpM1q7U3E=
X-Received: by 2002:a05:6402:21cb:b0:674:c412:6f8a with SMTP id
 4fb4d7f45d1cf-67b5d97d30cmr56078a12.26.1777501622155; Wed, 29 Apr 2026
 15:27:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428160020.226512-1-henrique.carvalho@suse.com>
In-Reply-To: <20260428160020.226512-1-henrique.carvalho@suse.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 30 Apr 2026 07:26:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9QWJFB8oPGZaDjWhEPYJXiDRmiKZgVUwmKKUjeQPDiFw@mail.gmail.com>
X-Gm-Features: AVHnY4K8WK4czdigv9g2niX9zZPkM8IDO740j4wwVHNNGNm6Sum_nBKSmA8ZRw0
Message-ID: <CAKYAXd9QWJFB8oPGZaDjWhEPYJXiDRmiKZgVUwmKKUjeQPDiFw@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] docs: smb: document SMB3 over QUIC setup for
 cifs.ko and ksmbd.ko
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: corbet@lwn.net, linux-doc@vger.kernel.org, linux-cifs@vger.kernel.org, 
	sfrench@samba.org, metze@samba.org, ematsumiya@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 1:00=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Add quic.rst covering setup for SMB over QUIC between the kernel SMB
> server (ksmbd.ko) and client (cifs.ko).
>
> Update index.rst to include quic.rst in the SMB documentation tree.
>
> Update ksmbd.rst feature table: SMB3.1.1 over QUIC is now Experimental
> (previously listed as Planned for future).
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Can you add to this document how to test with Windows clients?
Thanks.
