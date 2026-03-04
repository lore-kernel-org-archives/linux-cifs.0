Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC56353EF9
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 02:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772593141; cv=pass; b=W6hx8XdEPploXwJ+TSOmcLz5tLL4fYykBDZQrV77EOh1xkgWvKGngyk1AmofWZiqJNUhibAer/Nl9uUAIv9NNV3ZlvUt4/PaPj1vIh6q0HsZaFQ7/1lb35qiqzPJsura9z5r9Eg39VHwmK4Y8SqJo95pQg8xU7w7zLJo98jEqR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772593141; c=relaxed/simple;
	bh=zKM6EuG/p08waYJ2nHV56Gzg4x1zITq/xxo+w01zNwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L/srD8yAtYsuDWpVyMmRZqZYGuXat7cxYYmY8EqBX5+Im4GmcfsrEGtkZk0T/tNpz7mokTRL2pdR/5+58VEwQ9JjpOrH1se3Pw5i811sOl05kUOkU28py+1TzllzGyOlkVq4JBZU4c4maEwxEQsia5WAFxRO9ur5BaRFuZe97PU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nHa3MaJN; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHa3MaJN"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5069b3e0c66so101394731cf.1
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2026 18:59:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772593139; cv=none;
        d=google.com; s=arc-20240605;
        b=ey0mZfWdAGy+tV0ObyHHIC2IDbeYeVygZPQ659aON9if08xZM7U9rAXnaWh3iZX2D0
         XLGj6vhvFRQlhKuNbTdK/llpdKKC9MgxX4y80kFpG+zEAjamU9aIYWDlJTw+fLu4Dl1D
         39RZs/jI8RIxCQyOeIFfEdZLkcpazp9dy9dB10mpWDquIceXaJWWD0qH3cTKnRe7FVY/
         bw4xIalhG1mn8DkaxLTIe2AsF5VUWrgPZcMgjrPED5QclMoxrFjflN2OoI9ECdcLcNRW
         wmlaJVy5EfJTudcA+BcPA8eGqTUMVbfXJSjayFeqwKCLHF56EUyuShz9Oza5vHh6gBPz
         4amw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HVj5WUNu9TPSYD5sj9qQF+48hWTkAcgHwSgxIiLsvcU=;
        fh=uLmZuXkavc/1xBYErE/kvwR8lOB3HSc89QM8xUEU4Mo=;
        b=MnqsWBQqZVzSg6jpIukYGi1DFfbymRCbWRiSmnZg+uznYMsrzGjme5IQNW7oO7YgO+
         56LEHRnLMw3PWxRkHXAxPiyb8NjAl/H6cYneU3bjdcdCh4wOkI7VVGCqMhzJg0A9yFY/
         2/0JPpA8S9kJ3Nh1i3jdrIY5GgQ34LjNUALXRplZnzqCGEXgm2/vqxxz2BUkSVZVAdNm
         kzcrBFZSq/NTLsgDVu/DW8KRGVHRtIbJKfZYgepsN1kDR0iY4y5/cap6yGSdGtbMfH2z
         CltkepW8kX5O8mdD2eV2W9+hNZgTt4xtSlbCBeoc2eehE3gnVT9LdPrwCJGliL0gugkw
         ioGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772593139; x=1773197939; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HVj5WUNu9TPSYD5sj9qQF+48hWTkAcgHwSgxIiLsvcU=;
        b=nHa3MaJNiZ39Xglg5yrpCr6keC9Z/LMxfDUcQmNRji6wi4dNI+g69hGo00U1iH9A9n
         EZDOnVN6aC/GBXJUzE+lSNhN/DFXjGQg8ll+uIODlg3mBKidI12cd+1Xc3ZQZxxMOb5T
         3pPm6O8vLK+2IScQ/R8BkhShR7/B9RuVnM9U8ZQ40+UsuVle6RZNd7ajCRDelErSX8il
         R4+w5F4M23s4oB9BX5XDV11Ue4SQkx8v5Wjz0RN5mC9DPtdm6arli389s7iSgm1COd3V
         n2TIWCku+ggntGuhnWKU2FvIUlGHs9qhPLcg6fCEg5ThhTSmfPI+SYAr2+yVRbEuX7IM
         Pbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772593139; x=1773197939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HVj5WUNu9TPSYD5sj9qQF+48hWTkAcgHwSgxIiLsvcU=;
        b=o8c/9NRtiRI4WR3qsqAoXoQ/0G/j1Zws0YOBXXyntzQm993+Gu8x7eIDeKc7UR9rzE
         97sPA2ruXuq3WLT3yvKYd3v7ZfiWZ3LOOEt8eoVWsi2+WDPL265AB+KnyIKsLvcMRMka
         5A5cO01FkpHBdOoywugEAbAvTqo/PRouyjvmXsukiEz/8Oc+qx/nj1+OLrE6AtMQi8Xy
         EP6dlCz/P8FxQ5TzEem0QREzif1K5ys/NkxiEuSmV19F3sm36gQWHmrMGTtmaqRZtQU0
         I0J+CUZg6MBeBr8zd3zKGGD91lAY/9P6q1P6wW4JuhcNvddQGRHG2rYHmNqz888xwwFe
         ePyA==
X-Forwarded-Encrypted: i=1; AJvYcCWAX8q5/Ko75+owEM9ZMyLdxwAHbblpe0h9MtmrkJ6whm8QzDcpEn5+EBgvPMJTzbOMkV4K4D90xBWc@vger.kernel.org
X-Gm-Message-State: AOJu0YwE373U9tPEoTv/7VCbNOCdrGE8PmqPjqKCrOOpWE1tdPoXhYSP
	bn67PktzvKjq1rg3VzPejzV70FkOPS9/9HvvBOew5jKmhm0WAC/iVCc3IY5DeWtdc8xBGyUBPaQ
	b5c3w7y8wmKC86Mb1B3NQfmkjPglv55E=
X-Gm-Gg: ATEYQzyT20kYohR37Dcei6poBGbZgtmmRlGehFDizC/ZJnzXZpXSukv613gsPril188
	fmxExD1j/lxZ0btM1okzpUy2bhz/GxmuSPQZRCHwVfWtg+ooQKOoRcV1pdX7FrY5EWF+b7R2Pi1
	7JP07iKPAW7ynxhapIYZntqsXLeUA9fe36tY5I0fj6/rfuIfHAoAqu1DHRViwHWYQlDVfWo5Vad
	fzPQ7fGvNLxSIM6rJEN0Gup6kez8POfm7NLFUOnGu5hhF+NLZ9R4AH5SOpWAUBIun3V+fAYZIMm
	P3/aO3ZcogmegOQiX/WhPZoBNFJAgEXR7OSqKQ3VmkrsglEW/nWN7wZQVesF2MwfrhB63qfNTXt
	J+CVzMuqyssUvoNjgT3ElHYuKgh2OW+QSmQSsp0Hp3mhvoow2N06yflQqSYatF6I6OJbWCyDSn7
	jM211TNx/5BBCExey+h5TLPw==
X-Received: by 2002:a05:622a:53:b0:501:46b7:401b with SMTP id
 d75a77b69052e-508ce9b1e9cmr50583111cf.15.1772593139466; Tue, 03 Mar 2026
 18:58:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260218042702.67907-1-ebiggers@kernel.org> <b3b9f12347367ea4f0ab1f255e79cf35@manguebit.org>
In-Reply-To: <b3b9f12347367ea4f0ab1f255e79cf35@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Mar 2026 20:58:47 -0600
X-Gm-Features: AaiRm51JuVXJWtCFDs_Tw4S5B-GhRlIEkDR479pURfiq3nh76oTAjTjCjs4_wiA
Message-ID: <CAH2r5mu+VkO8rSL+CWWDR55aKRLaiAxFp_G5PAfQsssK-Erm-A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Compare MACs in constant time
To: Paulo Alcantara <pc@manguebit.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	Shyam Prasad N <sprasad@microsoft.com>, samba-technical@lists.samba.org, 
	stable@vger.kernel.org, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Tue, Mar 3, 2026 at 10:24=E2=80=AFAM Paulo Alcantara via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Eric Biggers <ebiggers@kernel.org> writes:
>
> > To prevent timing attacks, MAC comparisons need to be constant-time.
> > Replace the memcmp() with the correct function, crypto_memneq().
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >  fs/smb/client/smb1encrypt.c   | 3 ++-
> >  fs/smb/client/smb2transport.c | 4 +++-
> >  2 files changed, 5 insertions(+), 2 deletions(-)
>
> Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>


--=20
Thanks,

Steve
