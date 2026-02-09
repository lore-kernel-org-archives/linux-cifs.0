Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75CF320CA3
	for <linux-cifs@vger.kernel.org>; Mon,  9 Feb 2026 07:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770622154; cv=none; b=swLfaKND6+h/p/TMFMPCvuIP/d5J676djkrSrNloiTVemOsCZnLmgwHMP52SbW+4HOaq1o/DnihIM+0AXhBeAV4tUygU8Nedo2PRFPK39Lu0Z75solPoMcqAQI7wN/7Q1rRlSZ12IZdeoEwuJzOYSoN+JPgrx9ERuxofkhKnKHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770622154; c=relaxed/simple;
	bh=lMlg2Lc2iG61fAma4HD0Yc+l6+RfbTy5uNCq5BB35Ok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RsrzAH9BNEkwY4C0i9wqm6eg6lB7mPbmivJrc1vhGLqQNlH7A0YjmaDhtmWAdMYQtf5vhKhbDJ1X2+vbS7b9fesMKIVM0eAyTznPCqQ4rA0XsHmmFL6qUGSOu0PBA6fQE37rnYs2ITpaCQXdmyrFAbwX+905B5qc0zgvhY5h/5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbGzAEdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbGzAEdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AABC116C6
	for <linux-cifs@vger.kernel.org>; Mon,  9 Feb 2026 07:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770622154;
	bh=lMlg2Lc2iG61fAma4HD0Yc+l6+RfbTy5uNCq5BB35Ok=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RbGzAEdh//6RcRkQKvg2AxK6Fd07opjC2yeWLnHQk352HtrkS7XSo5vDYX7cOhs2k
	 tnCHosWfK8fiaFo2RfO6cU6AH5/dcznjtJfXVv40Zx6UEsLzYXKDH5crvIX1o3YMkd
	 IiqB3XV7E3U3d+SBbcCEaRzqAZ0sB1eWRjruRj77nKuh/PDDLBFTq3sIYkqKsWw7js
	 wbV8dLw1JxWeTZcVm2y9taZ3239aTZqMe//mGin7Wh2mKA1ANJmNEd2Zl6FjPRZRmt
	 KwA+Plg5b5sVLLj7A8e2/Wwvx8y0FkoHyt5DMsXTbdrA6lJn1+cFeXHutoLk+qk7ds
	 B8/6JJ5WFQXxQ==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6581327d6baso6058826a12.3
        for <linux-cifs@vger.kernel.org>; Sun, 08 Feb 2026 23:29:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUjvEnUCgMCIcTOsSkeFLyLKYP/GhzJwBvyG5K376MVh1a4wLba1+REYmxci6gzig+a4F68S0ZxIzNM@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx9gcI109uMOzXMt3R/x/dIhv0F7tp2es2rQJCILODenWPx4Il
	/dZl5KmCmSbSNKk5f7fp9IVK1j1d3/DdieRsDFDe7kwgKsgjDgGWpYnwbTltIAU8A4JALYfflsZ
	eG6L/++IbcH/Kif5ceLJk0G4XCZJTpEc=
X-Received: by 2002:a17:907:e107:b0:b8f:b8e:4ad9 with SMTP id
 a640c23a62f3a-b8f0b8e6405mr198350166b.10.1770622152924; Sun, 08 Feb 2026
 23:29:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770311507.git.metze@samba.org>
In-Reply-To: <cover.1770311507.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 9 Feb 2026 16:29:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_CqpqXnh+k19NVdgQdDAnp6k5NbPqcyd0anocBJrGd_Q@mail.gmail.com>
X-Gm-Features: AZwV_QjvCwr3PRkwkiJWe2uAvfWzUiSxF6wOGGdKQeTE1gVyRU47M1Qv5xoxMBY
Message-ID: <CAKYAXd_CqpqXnh+k19NVdgQdDAnp6k5NbPqcyd0anocBJrGd_Q@mail.gmail.com>
Subject: Re: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"

>
> I tested with with mlx5_ib, irdma (roce) and rxe.
> There's still a known problem with iwarp.
Let me know what the known problem is.

>
> So far I can't see any regression compared the
> state before these 144 patches.
>
> Namjae, can you please test in your setup?

Is there any reason to print the log below by default?
ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
called from smbdirect_socket_shutdown in line=650 status=LISTENING
ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
called from smbdirect_socket_shutdown in line=650 status=LISTENING
ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
called from smbdirect_socket_shutdown in line=650 status=CONNECTED
ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
called from smbdirect_socket_shutdown in line=650 status=CONNECTED
ksmbd: smb_direct: status=ERROR first_error=-ESHUTDOWN => -ENOTCONN
ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
called from smbdirect_socket_shutdown in line=650 status=CONNECTED
ksmbd: smb_direct: status=ERROR first_error=-ESHUTDOWN => -ENOTCONN
ksmbd: smb_direct: smbdirect_socket_schedule_cleanup(-ESHUTDOWN)
called from smbdirect_socket_shutdown in line=650 status=CONNECTED
ksmbd: smb_direct: status=ERROR first_error=-ESHUTDOWN => -ENOTCONN
ksmbd: smb_direct: status=DISCONNECTING first_error=-ESHUTDOWN => -ENOTCONN
