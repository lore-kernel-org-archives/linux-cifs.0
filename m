Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793189336;
	b=H/9QqCNzcPB2erUMriwc5TqZufDRAo4wi13Cr8i5PLGuC+6A9StLeOpmRzdTuqfvoV9h
	 bM77f6mvLY3SlzrDszCnPPlRYQsd3qMGdz+nD8nU0fnXGvnc4zCoyg7EmiLM7IHxDXnfY
	 iuulcMDDVFvyBb1hJC4sDu90FCC5r4SVYnsecYnvnp7V8+0xTIHt3F2kMJeWqOafwych2
	 9eS00OdEWYvYT+HauIVwF+4ADs7VHuVDkFCSKwbutE240TixZAuRvW8L7BRLCaQeGRR44
	 THzSA7CG9UgbNBPW2MLY5t0B0L9AFh/Ne9dsWvgDHNMikGQ92Jixn4i7ji2wPTs5sZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793189336;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=vDvbLXpvaLACtTQr5IIDsIwg9uV80hfj21Qtt2pIQwc=;
	b=iGhBFEQDuhh4Ur3g2xz9z5gSSegn9Y5DXnwHyAJO1Veo5lXGbG51LbF4uqNaHfIAI5mN
	 zQ0CHEE+yLCx5o5s9Br+bVYaHN42zPFDvD0uV0p+Ur6/KnatLxv3FBjnt2/rmKmwX9w1c
	 P5vNmtQUxuDroecuEhFYedmipA7pHqmFgrhhoukPPR4jssDecRE5SHN1F11y/FjaKTQv6
	 h4VLBrl3Zqkl1jv5rNo7+u+4R0jvKGS7bJuITqhj0L63ywaBmZhYU3b2KXz2fKhNfy+1P
	 Hrkm1W41GILocAeWfMbJXce3oV3s8Jej3YKPe6baDN/TLH8caagsBcZoAHt7FWFduuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jza8fDF3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F6A606A31A
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 12:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jza8fDF3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23001F01825
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 12:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793189335;
	bh=vDvbLXpvaLACtTQr5IIDsIwg9uV80hfj21Qtt2pIQwc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jza8fDF3nHzhfGbFhEZHdqrqCYZQNkA6+5UmfX9CZkobimlD/sBdocCM95ktnoFBh
	 EdO53hyGM1OEZCEJ3fshj4GpFnxsrBwiHzF9MidMyerKHPKqcnVSytOYxlQPz22TSR
	 o7CGcxAmpv6W1mQ4AaWWkXY5bnrcCyxtMcLcZ/Tx8rkjSFiZHFNQu/26uh5rvMg/6C
	 uGf4MDJd/9JLwmTNWNBwKCX9SBTBRby/T82vJjslHqGTnRAPDhzIaWXTudYxlIIMnu
	 mk2xQlPX8ySkFcq0E3ucjBogE0JjDZ4j+k5K/u+9F4dFy72xA/LkkrMWPd0d8HbjE6
	 jYH312oFP1XRw==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c3fd91337baso135135466b.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 05:08:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwzVEJolTX2P2+v2PlDwRCvsezcne4oiNt8z4z8edvnXvawZeoBbotL8ViJTPmtYbCT1PNJjCyZNTaT@vger.kernel.org
X-Gm-Message-State: AFq9FYJwxDG28IwrRkPIbVRvmgkgBQPdlW577TJpX7N+eEuRXHR57pgY
	2QkwmER/jjMRiDDivKKQpYXARSdmhLwuUEGJrGwe8fRWj9QCgY1MCLlUkPbzH4mASPsezvuOkH7
	hdW1U5NdfVcFhgH/UgrX1NkqJUktEwJg=
X-Received: by 2002:a17:906:4fcb:b0:c3f:98d4:dfe2 with SMTP id
 a640c23a62f3a-c49bdf00daamr206458366b.18.1793189334379; Wed, 28 Oct 2026
 05:08:54 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261025083450.212604-1-chenxiaosong@chenxiaosong.com> <20261025083450.212604-5-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20261025083450.212604-5-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 28 Oct 2026 21:08:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_ybS59mdiMBt4xAJb2gz-wAaoPtk7J5tu=mJPf9CZQqQ@mail.gmail.com>
X-Gm-Features: AclHuK_mHDz9jdvujfEpsidaRiUNE5gZHLcCwzxlRAA3xoD4EAAmkpJB6dr-6gQ
Message-ID: <CAKYAXd_ybS59mdiMBt4xAJb2gz-wAaoPtk7J5tu=mJPf9CZQqQ@mail.gmail.com>
Subject: Re: [PATCH v2 04/13] smb/server: support non-recursive directory
 change watches
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: tom@talpey.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> @@ -20,6 +21,40 @@
>  #include "vfs_cache.h"
>  #include "mgmt/user_session.h"
>
> +static const struct {
> +       u32 notify_mask;
> +       u32 fsnotify_mask;
> +} ksmbd_notify_mapping[] = {
> +       { FILE_NOTIFY_CHANGE_FILE_NAME,
> +         KSMBD_NOTIFY_NAME_EVENT_MASK },
> +       { FILE_NOTIFY_CHANGE_DIR_NAME,
> +         KSMBD_NOTIFY_NAME_EVENT_MASK },
> +       { FILE_NOTIFY_CHANGE_ATTRIBUTES,
> +         FS_ATTRIB | FS_MOVED_FROM | FS_MOVED_TO | FS_MODIFY },
> +       { FILE_NOTIFY_CHANGE_SIZE, FS_MODIFY },
> +       { FILE_NOTIFY_CHANGE_LAST_WRITE, FS_ATTRIB | FS_MODIFY },
> +       { FILE_NOTIFY_CHANGE_LAST_ACCESS, FS_ATTRIB | FS_ACCESS },
> +       { FILE_NOTIFY_CHANGE_EA, FS_ATTRIB },
> +       { FILE_NOTIFY_CHANGE_SECURITY, FS_ATTRIB },
> +};
FILE_NOTIFY_CHANGE_CREATION is missing here ?
