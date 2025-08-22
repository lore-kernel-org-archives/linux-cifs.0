Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C140212576
	for <linux-cifs@vger.kernel.org>; Fri, 22 Aug 2025 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755878041; cv=none; b=GRWuosXeQy5TnKNE/xP7yluU+gaZIKKMpx6oehRyMay9b2UHchGDnEi3in+Sy5RTiYMV7RmyZGfwDbuVjTS/w7WHJguu0E0G+VCkODJ+kAHk8Sw4WqJPJMICgeiGMJkLJ2WDXxkR1bf/MM3PozHR9ZBdBD/ZI3jDAFEaKhTUG/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755878041; c=relaxed/simple;
	bh=sAZ+cQcqUCqmqi8K0hO7WDTHG2Q0d8FoUUTPdwNLWSs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jC8HDmOk4fuuLiGPxXp4unnbjpg5FrKzBuKmussa1E+GtyetuGcRjir4E17LY9aSyCCdBsVaxGO/EtVS5mdA3MPe0dQT4/B4fzjGK/HfGgCME7XEyBrMVEO+6xESf8FRHAStjIDpQH8dnIFks2mjoKi+7l+0gjc6f7Inh/yI9cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aaFaZ900; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aaFaZ900"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-70d814d0f98so19447906d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 22 Aug 2025 08:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755878039; x=1756482839; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sAZ+cQcqUCqmqi8K0hO7WDTHG2Q0d8FoUUTPdwNLWSs=;
        b=aaFaZ900TKWMnQJ3G8pZDsttwqkOFpeKRwlH3ClRPFBtI6VBLBuAD0FG3KhnP97ADF
         zm0fj69vXdpj9ZgyYyjXm605vuxlHs0gnmezaIW9OlMlq5ahK75gjohig9+N5lz7McB2
         Cf/k8JGozpYa0kkwgG4M4o5RWuHERpWbMGh0wWNcWkexXnTjsgfmexvE/zbMCiEG3YlW
         3fK5DlgI57iaecZJ37qMG8fbLL4qc3zh70OIVq4Uw0Da1IJjWnTlbgqmYo5t8t5t53+d
         yqxfuQIFLQlFUOjByRFZsYYJpjWnJIHolMvV7hb0BwKwFfmFFmq9GtiYn59Z5DzLYiEb
         aIwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755878039; x=1756482839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sAZ+cQcqUCqmqi8K0hO7WDTHG2Q0d8FoUUTPdwNLWSs=;
        b=prQK8b7ApA3cC9PHIfQQc4oIcmyOnP0l13dlEZGH7FvI0hOxbsy+qZFgQZ9fk0y3+1
         ltSl7JNgyJlDsr8uAgTpnB+fUa63pIQJE76r9QoHeFyAVMuhbSrW86mM9HQpT2T8vi2J
         qqxXgQipVZA59NBfMVIRt53/3a253E+wndoRAPuPESIhLleR2X2ER08JHf04TeGPDC7U
         I7hTZv3H4iroZlq3VO+LGOe2XyFYm8no9fFGCVV1wUdG3vUYo9TJTa/nKHnYyDYL76Et
         VGLbWjf3vOZ8N5gTZOD7swZebH6prRoR5Or6iTwTKYBHKUiKzYvZmg14kd3F5eEIrjI1
         0bJA==
X-Forwarded-Encrypted: i=1; AJvYcCUl6gLt9qh5wlQD2KyJSESq6MVGGQsQDhOpN9kMVT08mko3Nk2n6bWHY1hZsoMRhYeFvZSkWzKi21bL@vger.kernel.org
X-Gm-Message-State: AOJu0YyLeXdD+I2KnH4/8KbpMKLofyDsjC3M4HNJEl+dtWpgaQZdiWF8
	9yXh0XQ+xwHvDETfAZzyowF0K/6HtEyXCbQHyu2jRisFXmtaP/n+0P0jCYlKUiq2ddMlXEcZsoU
	Wc3IlW4FgYXBgvGEKsdQ8YIdrMm5YPRM=
X-Gm-Gg: ASbGnctvqGS3GJ9efAvaS0OOELr+sf8FWIYLS1X9mfBnnt7H9PRaXDB9zfmpVpb7IRT
	8C7yvHltBZ5OHycx1d/0joyCnzWOHNAUmi4NVkB4m4ZbCTwTr0DegtLX9MAUdQYaevV0SMX/FE3
	DaeoUPtAkDDLudXqssRbn2QkFajmZIeOqcqC5iqvqC6rGU8+xyp/5LLIesrTA2PsN+UdI2XaVxH
	TU/6pPMRRJyb3rrhP+a292/Nhz/pvC5HsxlwFAOjwtBR2YLuY6Z+oXkUhswtt/X8X1oR4f8MeBS
	BgmCfKA+xd427HPliHo8vg==
X-Google-Smtp-Source: AGHT+IEvc7DfOpEVc+oppTtjkQmp96M4VlDaMe0nUOyRAPOE+w5AKnmsOikowDEm53b+mCiRQzM78rNXs72qB6OJL2Y=
X-Received: by 2002:a05:6214:4114:b0:707:bba:40d4 with SMTP id
 6a1803df08f44-70d970b2a71mr41984446d6.11.1755878038877; Fri, 22 Aug 2025
 08:53:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c2d9d516-d203-44ff-946d-b4833019bfd5@samba.org>
 <CAH2r5mu_Nm49VaLDvBA_n16MivzUojBBZHwQgS-JNbvL-UsMOg@mail.gmail.com> <bff94baa-f71f-420b-b679-b4466e3d3c2e@samba.org>
In-Reply-To: <bff94baa-f71f-420b-b679-b4466e3d3c2e@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 22 Aug 2025 10:53:47 -0500
X-Gm-Features: Ac12FXydVgoz463ob875Dtv48Ug17rHtdLrw3qFGCWY9wDda7Dgc2j2Jw8zJnd0
Message-ID: <CAH2r5msdfD=edFz_9EHh6C=Ya8MdGi+G6nLX3Zx5MaSYuxVWVw@mail.gmail.com>
Subject: Re: Current state of smbdirect patches
To: Stefan Metzmacher <metze@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>, 
	Long Li <longli@microsoft.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	Samba Technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Done. I have updated cifs-2.6.git for-next (ie client changesets in
linux-next) to remove the pending smbdirect ones and also from
smb3-kernel ksmbd-for-next (ie server next branch).

I will let Namjae update ksmbd-for-next-next

On Fri, Aug 22, 2025 at 9:57=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi Steve,
>
> can you please remove my smbdirect related patches, which were in
> for-next and ksmbd-for-next-next in the last days.
>
> I'll post new patches (most likely) on Monday.
>
> I'm currently at the point where struct smbd_connection and struct smb_di=
rect_transport
> are only used in very few places...
>
> metze
>


--=20
Thanks,

Steve
