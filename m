Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1F022E3E7
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 01:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765417081; cv=none; b=s7mCz+3hpnLsxMXNZNyre/Td36lloDyecu4moTsBmOQEl9IyRp2vMSCM02EocSlOycgGv+U+MW9KQ1zrvoErH5paq6nV8GVOUeg02uNs3Js0z/paZa5k6U1Vd15cZMEJEi23My6xaJsvcwf84W7Ueel7eqI+ge+zHB03CJhQc0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765417081; c=relaxed/simple;
	bh=tZu5vbLY3ZjIHrWSnO/LiB84Zc0T3BIwkwE6LmQuO7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LCTWRFctsapMjb/jXi3KspkTBklhO1NW/bP63dro6VzSQWCCJLvEdAdFM7bXDhwGPan0GKN3j/vn9p7i7Uz5PAortmYmTkRARdq3xxAsBEHCeTr4PxN1xpD2McMTDiV2eYjbp1eVj59KWcMcu0QUSbZaoaJHmtsFo8zqr9O7uu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcyxiHFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcyxiHFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8399DC113D0
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 01:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765417081;
	bh=tZu5vbLY3ZjIHrWSnO/LiB84Zc0T3BIwkwE6LmQuO7g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fcyxiHFIZa4zSN+V7V+ENSAkyl8YCK1Ce4eciyByQyX5SCOLRwXr8ciROFhLyDuNq
	 GQJ64Ol1W827IFQc6F1V/VYudipUNGeMyjBtfUMN82kITeNNbRitCrHt2A/EfZe/A0
	 WYH3x9Iy56wjkAC2XwbTATnjD+SI5X/Af/n77K8wWLv99rEj/nPv6ZrUS9gAAkm+hZ
	 6LFPVCiONYeNRMDsM39cndVzTPurlBfcVY1AI8IUU2yvp7OVZzdaonKQGUQ8jsHD84
	 YD+AXdfXAyCEPYjrK2icDZvFKmslNwyRKLcTtHZIGKiIKxdaZpEZ2Mw2VDVzIs+wf8
	 Xdz1vOSQX41hA==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64198771a9bso961808a12.2
        for <linux-cifs@vger.kernel.org>; Wed, 10 Dec 2025 17:38:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVbgmWtKoaFisNVBLZXcYQPZAPol/jkjP6UkSJqzPk5mx1BNIkCjsZS/OdrejrSInhz/h2wNDSkbv47@vger.kernel.org
X-Gm-Message-State: AOJu0YwU3jKOmjaPlmf04oOjfDzQT2kJxzSWR4NFnLOttMHA6sjgiz1+
	36ILzD5nhSPq7AXCHtmYuvjyJPabG8cS+a7XnhMQknMxPRAtNoVRgKc7uBjAj9l3uVwSBq4q9wo
	b9T+p8CJIFL1hZYBXxonYW3cMzhrrva0=
X-Google-Smtp-Source: AGHT+IGl3ket0qWWzyDfyZxZ0ZMbL0rJyicsgD3zzpXXcvcITRr2ZIJGmrEdOuZwhTI2JSP5BnMiqL7vqfhJKkXk0pc=
X-Received: by 2002:a05:6402:1468:b0:640:cdad:d2c0 with SMTP id
 4fb4d7f45d1cf-6496d5cacc8mr3979211a12.25.1765417080018; Wed, 10 Dec 2025
 17:38:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210135149.10837-1-a.velichayshiy@ispras.ru>
In-Reply-To: <20251210135149.10837-1-a.velichayshiy@ispras.ru>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 11 Dec 2025 10:37:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-fadJV1vJrKMyDwJ9=Mho50vU5VM1uhBYGq6pY99boTQ@mail.gmail.com>
X-Gm-Features: AQt7F2oNvrf6NvfqzaA8UbFeuMblAUKMz7zdXzUuanGN477KeypXjYVzbVfx-Bw
Message-ID: <CAKYAXd-fadJV1vJrKMyDwJ9=Mho50vU5VM1uhBYGq6pY99boTQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: remove redundant DACL check in smb_check_perm_dacl
To: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 10:52=E2=80=AFPM Alexey Velichayshiy
<a.velichayshiy@ispras.ru> wrote:
>
> A zero value of pdacl->num_aces is already handled at the start of
> smb_check_perm_dacl() so the second check is useless.
>
> Drop the unreachable code block, no functional impact intended.
>
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>
> Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Applied it to #ksmbd-for-next-next.
Thanks!
