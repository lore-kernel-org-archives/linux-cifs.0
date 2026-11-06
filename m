Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793967216;
	b=CNLukJzbU886DD4FoS7AG9Zwvl7GmsjlP5P7pwIN74zhA/2wtJXrPR8Yejkc9+/iFcMD
	 rDsARWXavm3Muzi05U5fxzHrspzsAHgfZUT3XoKSgcBoT8iP2WBXHu49bh8lyx0Rz8ZLe
	 vqJ6qg83QXi+rg7HZEkIzbNUJp6/hQYWDJ0LdtB7CH29pOMpuHDoc/+ONTFvCCOiKk9aJ
	 u+vetf9dtvDPexbz2XiDuwuexSJuVBFvChmZpDzPLkvlgcBsLURPAyoXuel131NDt2jb+
	 0sfX7pUX03SFExP6NgK7XJk+EnaFhHN5XV76POPC6JJZGfcmWOy0xyRE9m2X4cJ/Agg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793967216;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=w0ggjq6I/XXbHR0zS8tnrBfiWpgxIQRt/7sxrjM/4G4=;
	b=JBsQMhFcxceUAKKsW/QsVLMonA3MKCsbVrH8cFindx+z/Rz3GyxWZfYuF5nz2GD8Rwci
	 ctUOr6LoHA4DMVwloqNzA7m9+WjsYAKQOnZI5PryTy59+35ko1dCjOZGwoDj9hu94Zj+m
	 DXqwBGerwtBjukmpJkBBiggEEM7mS+AyeShWGYvcaOZ12E/lQr6Bx+IC1QY3Rui7Ql3cZ
	 nTriQRAnbYCl3DlxsjFBEqvHwbwwuRuHKz5SvvoUOdNF+mPbe0nrb9vCXllemwq2AwVRe
	 fbhTdLaOe/XWpGDKcLdBC9OruVDM+UoDrnDfQCsQTRsUfVw5g5R+ACs9zMXs1WCBGwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=C0rGGYaz;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=H2q7wvJY;
	arc=none smtp.remote-ip=103.168.172.155
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399B4606A32D
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 12:13:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 399B4606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=C0rGGYaz;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=H2q7wvJY
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 547F514000B0
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 07:13:30 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 06 Nov 2026 07:13:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1793967210; x=
	1794053610; bh=w0ggjq6I/XXbHR0zS8tnrBfiWpgxIQRt/7sxrjM/4G4=; b=C
	0rGGYaz/wVylknO+nVJvF1oguMGaQ5I7/5A8Ljhe9ZuCCsbJ27ChSzMZl6c5ztFx
	030n35VIumqHL8yMUOAh1dumlg5/Gp/0FJRYAq6Qn40tiqGpL4nmZyL4uB831U1i
	ZKZGurhV3qWs/iVOD1xUg+7/pkgstOHf8AXA+dAmSaK5d1sI9bmLiA8AFTvHoiHh
	HDpBJ28+r+HAmp9ouabhTJ4ePp5MccOerB238s3ZHoPLHVYxlvplamleyuBz3RQg
	u6D6GHWwh9StF9wNrtJiejHZt+rle19jSgA9C6uXwTYZTaJAAmPldEREuFKzns/G
	gb50v0+GMPRUacxlM75TQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1793967210; x=1794053610; bh=w
	0ggjq6I/XXbHR0zS8tnrBfiWpgxIQRt/7sxrjM/4G4=; b=H2q7wvJYFw8Za4Apv
	KjOrMGtl2fd2nkSJDf7zlK5LUconWoIE15GVDg8Bhp8vkBmVPiMyi68h0P7eHWFE
	/4iHYan9tnixIhGVxyK9Gbgfr1nnapVdaxclpPlDmF8QM3FLgnlxUqyMSJNGu3IM
	l/xWc/o2Y/0zLd52Fm7yZEZE9mhdojBsQzZhy2BxZUjN7KgC4kblvjI7mLazxkra
	HjSQmISsUbYaTQIYU9fRrszpDyK5irX9UtJEH57oS7gQBlKdS3Hsfo11P1BPI4XX
	+DwlSnjqASZIGsoOq0BFiNFmLrfPKuasb/631dtwl8LfktTOip8NYBLN5p28hQWA
	o8gjg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793967210; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:BalxE0wIaFXiEPJnZSFXrFRgKNFJRmcN2bcBPv6YUq9XKOZ
	AOrPZoFh53vIHo063ZG3pWh7E1tZGxunvA4w1oxz6YYs0SvQaGqrWnOLh2eyt80G
	HIwVim4r39Lwz013LOWlVtmWDbG+bcHQGD0NmJEh21uJnguV2SedCEuIbYfqFnCI
	UFyZ77HHfQ0kcBFhwTZCoPCbWHqznjQD0WjkIUYt5ekuNQCaiXGIUGuPhAr1X4tb
	xdZUnYgFYfB/frbNg+/i6dsv4T6JlsCU3zT1ZA/gaSJfKD5PcIpOHuJBmFgl/9+E
	YTYJ7VrZPpuh/sobQa/syEFQLQBx41vokSChDcQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:lmL6gQqKZQSmUe7cC6wzm6Ps82i2lmjovLO7dhUrS/s=:w0ggjq6I/XXbHR0zS8tnrBfiWpgxIQRt/7sxrjM/4G4=;
X-ME-Sender: <xms:acTtas44LQpMt8W3HaPXt_Omz-xvXm2Z4THQfYe7-gIHWZmhiASuaQ>
    <xme:acTtaumx4Yaa8nXDw_sYCutdtnTlQft55SEzkSd_1a57jEmoJ3AEPlyEvHfBXYdoR
    2B5nUvT8lkWTYynJEsz6-qE2obVjiOGhql6f7h4qWu8v3Dcal3cIuFR>
X-ME-Received: <xmr:acTtaprqcIxrI5Jm66F0qQEaTHgZb8J2BZRq3Uod3mjEGztDAAXttmwK4Bmp2y1C>
X-ME-Proxy-Cause: dmFkZTEBZQxQOvt8UiBAEprFZdlC8N3sasoObC5yyrRcViWdd1no+hwMz5vd/VH62K+5h/
    mWiWnUnhg10vQA3hDEtmCyFK4JRUSU/JuRYWgxyEiW0vZihpbJHKbuBP7w72JVsJXvRwGx
    zQqhJUXOxvbBNJaPYhToUx+TVHIeZ6RAgbmwzBJuIae0pP1T/9bLzqKSYmoYul574iw1f3
    0Oa2iai3P3D97WfO+6wMu/0AWvLyMjmwOVnbwYTy1rQkuiNMK5zIoODZ46+RuNvHrZdQwp
    FbdLn311Hfm3yB0t3swBNlbVznGxqzQIytmX5cu6hNnJRMbDsS5zUpOhxyoqNXbqV03LH6
    h2Bm6APrQ7At/9wOC1GTvPu8GGrUiIZaJB0yLfMNzm7l+e08PTN72sRWFRPuBkLlxFABAN
    6Muy/v3Jbt2tWPvOpNunnTdJguA/W8hPcwefuPdNPqlrGD6tRX1we3BqMBM1Wh4uNPxmW5
    pRAl07e9iPBhsznmE4izXOesA/0KxvZBRS2olVL8sa/CTk+9qIWqqWR9ei3z5e68xanVye
    UlReblfGerysOPxuQHCFzirTz0gKrzG6JQsr61/sB1jtmsXIjrgXW+Vob2aXFY6hn4ZylK
    b1410rGdkoQX0RBQPxWEsvLjAtGQWdNxChG0/pvdoiyZSkzn9SB7aP04KNWQ
X-ME-Proxy: <xmx:acTtalufH2NT3HVrvOFzjnoNDuACnqoyE4WV_Tfgjt3R07zDQjD9BA>
    <xmx:acTtamH3YOPhZqZ8LKCjDO2HF4OvQrZDCyN0z5aOOhirWou8jzFkCA>
    <xmx:acTtamZ1X6iUy64JF18po_Ras4GRar4h1747Jq3Ybq0eue3ZPM1sCg>
    <xmx:acTtamVes7VYElFzVDCmAnklw5D0ET8ivPxLSqcqi16sJ85loe5J9g>
    <xmx:asTtaoXedvKhQtk8GZttMILtXOwAYpjr_k-fhhgyEEwA62C3l1xd0gIv>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 07:13:28 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH v2 0/2] ksmbd: exclude metadata-only opens from sharing checks
Date: Fri,  6 Nov 2026 06:13:16 -0600
Message-ID: <20261106121316.979438-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAKYAXd9fstqtRHh8+Y1zkr47oq4F4nf99uU2tTuMcP0peXwnCQ@mail.gmail.com>
References: <20261106035345.728454-1-icb@fastmail.org> <CAKYAXd9fstqtRHh8+Y1zkr47oq4F4nf99uU2tTuMcP0peXwnCQ@mail.gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Namjae,

Both issues are older than this series. A test that runs smb2_open()
on the base and on v2 gives the same results for each.

The first is about the earlier open. When an open overwrites or
supersedes the file, or creates a named stream, without asking for
FILE_WRITE_DATA, a later open that does not share write is still
checked only against the earlier open's requested access. So it is not
refused, also in the window before the earlier open truncates. v2
counts the implied write for the new open, which is the case you
reported on v1. For the earlier open, v2 uses the implied write only
to decide whether the pair is checked.

The second is about attribute-only stream opens. Such an open that
creates or overwrites a named stream is still skipped against opens
that are not attribute-only, as before. The series keeps that rule
unchanged. In the stream delete check, the base already refused every
stream open without FILE_SHARE_DELETE, so patch 2 gives this open the
same result as before.

So both look like real bugs, but they are separate from what this
series changes. I'd argue that they should be dealt with in separate
patches. But if you prefer, I can look into addressing them as part of
this patch series. I suspect the fixes won't be small, though.

Thanks,
Ian
