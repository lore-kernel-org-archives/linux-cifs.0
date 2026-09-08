Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBCA318EC1
	for <linux-cifs@vger.kernel.org>; Tue,  8 Sep 2026 01:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788831893; cv=none; b=QpRb4XFtuTahUKT9xvfbTBswU315kquDG4s7KwwqTCjotuXmAg+ey7hXjoXVSCcRttcDxmJba3yd11o2KXL3utTOwdS14MN8TfuTsRsG+LFSHbawKln/oPTGj5BAeKoj3OpCePb3ZWpbI+Xj4MbTM75AhhD0KGE/iaD451r9Yrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788831893; c=relaxed/simple;
	bh=/lNzL6LhhyMOeckWrw9zQffDuZMucxHXHdt6rpNPtoI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LcKVyWwk11d36DkzGBRMs5OPzD96pKQDF2txEz0dpJ7cQF1tr08LUc7N5Z3NRqMfSIwXWSIWntYQvgfH0MYycfbj1KXABehA04JN0gMU6wk86TcKeshTqxLimGmTA/kQb8z3CL7QKsVRlZPADV/ApOVMEQs3lujU4ScO3RNmnRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TrAFH3N2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TrAFH3N2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B0D1F00A3A
	for <linux-cifs@vger.kernel.org>; Tue,  8 Sep 2026 01:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788831892;
	bh=3eK0bf8a1JZWcRTunA+iwtbfBwY6iPMl68z8OPPeZA8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TrAFH3N2KcdUCQ0CjH0Jr8qWgtlyvjvaaih0f6+9yxxBPatOfpE37Xeg8kN7zm3Wf
	 nrtXcX81tIq7IIgc6XcIYTmrcuT1lT7zYd0gZZIr8EvKqtkLfu5oLNNbVUidWqaz9O
	 vmEJuxwB1xMV2Q1CcEK9FXC4RhfaOeutfEXTxG5OSkgu8YaUwMosBYrclKXMJY6rJ/
	 cghw3xaj/n4kztsgwn/MDAF5u5Mh3fzaHUYvCTNEScR0cYqwtlxbwyKMAoB7l0ReyC
	 /PeZTXqmZAYb1PZSVpxRk/XmbwIJKNbNdEXQMkrtfdMR7JZp2+pP3RtoVVMU34cKGC
	 Y6titcQDXmtIw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c197e7e4e94so657880266b.2
        for <linux-cifs@vger.kernel.org>; Mon, 07 Sep 2026 18:44:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwFagVKl8erG7e0IYFlMlThyImTT/IwEMKL2p7/7eOvsQ43tNNFCqU1DyjWcCTI6X8tgx+kEF2SDw8c@vger.kernel.org
X-Gm-Message-State: AFuF++kzx1EtNXY6I9NKAHPlZQWNbIsnzfsHbwJeCv9KyRN7d7jLMur3
	Q2sykvLV+ZiG8OVgmCgRF4ojZjFQMsHKnNk526eU5h/P6b8BG3mnUsPYAe4rrmPYGf7rXfW41Cv
	H4wWbt/MN2jurNFgsWe8o0gUmMmNnwr8=
X-Received: by 2002:a17:907:e143:b0:c26:2751:3da4 with SMTP id
 a640c23a62f3a-c26275144e5mr457244766b.13.1788831890673; Mon, 07 Sep 2026
 18:44:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <AS8P251MB000193FB2931EC2E2363F2B9C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
In-Reply-To: <AS8P251MB000193FB2931EC2E2363F2B9C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 8 Sep 2026 10:44:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8N6iFo_uvzyCzGE3QXYfwd0ysG2f_JsNfu5O5yQ=hL=A@mail.gmail.com>
X-Gm-Features: AcwNN1UtN7XfeFU-oUnD5LZvYF2AJHTicwkgnecMYN4rPVC3fbkD91cDFnfO-1s
Message-ID: <CAKYAXd8N6iFo_uvzyCzGE3QXYfwd0ysG2f_JsNfu5O5yQ=hL=A@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix empty DACL handling in smb_check_perm_dacl()
To: Aamir Ahmed <elb12345@hotmail.co.uk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Steve French <stfrench@microsoft.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 1:31=E2=80=AFPM Aamir Ahmed <elb12345@hotmail.co.uk>=
 wrote:
>
> smb_check_perm_dacl() does not properly enforce an empty (present,
> zero-ACE) DACL. Per MS-DTYP section 2.4.5, an empty DACL grants no
> access to anyone except the object owner's implicit READ_CONTROL and
> WRITE_DAC permissions.
>
> The current code has two problems:
>
> 1. Non-owners requesting only READ_CONTROL or WRITE_DAC are allowed
>    access because the code does not check caller identity before
>    granting these permissions.
>
> 2. When pdacl_size exceeds sizeof(struct smb_acl) (trailing bytes
>    after the zero-ACE DACL header), the condition
>    !(pdacl_size - sizeof(struct smb_acl)) evaluates to false, and the
>    function returns success (rc=3D0) regardless of the access requested.
>    This means trailing bytes after a zero-ACE DACL bypass all access
>    control.
>
> Fix both by moving the uid/sid resolution and is_owner determination
> before the num_aces check, then denying all non-owner access and
> restricting owners to READ_CONTROL|WRITE_DAC.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
This patch is same with "ksmbd: deny access for an empty DACL instead
of granting the request".
It seems like only the patch titles are different. Which one should I check=
?
