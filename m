Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E204A21E097
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 02:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792375225; cv=none; b=rMlBlbU9DpRHnzTSohw3XIuNXYisHpHRsmMfD2AL41z8swTjAcbnaSKzoQv664jTL/WjtTjjzrt+Gg7eLbr+CeKMgpQlRH/9qYiPzesIcnhGZDZ6qIA6FVbFXjxnLriYxNnu+loZfEOV1K2Sk9EiZmPKpVw3eBOsGxSA2LqBRZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792375225; c=relaxed/simple;
	bh=DVXQyIhY8nkQwuh62aEFyosJMFXKwj2WMhrrf3agrn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q7TTfUXe54cOZW5avZeeumgwNGeHJfww2Op/dC+iKiP++pJ1N7G4dE4d2UmPVqFpgqlFUIgFzq/s47dKg+V/ApTgdG51PHMcTSMpBVSt5zspooAQURRGgU1kwS6C68rykQ9DgrfKnusYogG1kf2pLmMKkkc5NV/jRwAi1Plp0uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=egR9e4g3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egR9e4g3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6A31F000CB
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 02:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792375224;
	bh=KD7UwzXfOm4PXY6mh45NaHYnJinOcf0JwpEqw8Sab1c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=egR9e4g36blwGaj9ytpdJLm/LCvacoX+WXrb+uOgziAFEkSaKWKjgrA/+hD3Qs7CI
	 D/gkcqO/oK5YDBAptSDINhLyJqdCtcWRQD38/T5UiVcdoEEXMKDG8+NYR1jzCdB7iA
	 72AHuHQvhEKMaqUpqXu4zJyOoP/MBTnh30/HY7G4iok7izu3NiB/S4f15snVNvz6u8
	 j2xvDixmsqPuWIX6RY4VPhtPTsSQhXFy9H52ZsCxGJ0pBKv+H7jM4lIA9c1RX/gsvs
	 mIJHtNHXXa9DuoePyWIDx6LhzcC/2eFeC26A/QsPK4wsXJ7Rf2xVswrWR+gjzPT+AK
	 M3B6+UJflK1xA==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c445c95d553so31779866b.1
        for <linux-cifs@vger.kernel.org>; Sun, 18 Oct 2026 19:00:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx7leW58MgPwPf2t1t9MJl2RiEwQuoqQiPagV+AG3/6hOq+TpF4iTNAt7FnU9th9aeosaWaUdZvyqLc@vger.kernel.org
X-Gm-Message-State: AFq9FYJCThCtXcrRNJ2dqP/v+NkxQ5v/n0hkh4Lzy5dYtdwhbBSJfb2D
	GOHG9ONUMlhCnZA0gLGT9V9laulKL2m29z4YIJLg67lQz+VQimdi2HYdDmst6lDZ0Jpl9HNpli8
	ZzpvWgXl694fWUVzmm5izf82XJ8t0nbY=
X-Received: by 2002:a17:907:9494:b0:c3f:7270:10ab with SMTP id
 a640c23a62f3a-c419d34f17fmr473204766b.14.1792375223084; Sun, 18 Oct 2026
 19:00:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1792345559.git.jan.koester@gmx.net> <1861a1d193fc19a37cac28c3d3312046d69bf5bf.1792345559.git.jan.koester@gmx.net>
In-Reply-To: <1861a1d193fc19a37cac28c3d3312046d69bf5bf.1792345559.git.jan.koester@gmx.net>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 19 Oct 2026 11:00:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_PWD5+7P3H5mMpyhL+8fugriQxGLq3UjvdV2UZk0Oc7g@mail.gmail.com>
X-Gm-Features: AclHuK8A9hAbhSOIn70RmzLFuGS7zFENLkUdwmMvGTbHx6yjDB1UEMSEQxsLbQY
Message-ID: <CAKYAXd_PWD5+7P3H5mMpyhL+8fugriQxGLq3UjvdV2UZk0Oc7g@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: put the workgroup into the NTLMSSP target
 info's domain names
To: Jan Koester <jan.koester@gmx.net>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

---
 fs/smb/server/auth.c    | 41 ++++++++++++++++++++++++++++++++++-------
 fs/smb/server/smb2pdu.c | 21 +++++++++++++++++++--
 2 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 9a2a3c6a37..8639997080 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -376,10 +376,10 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_m=
essage *chgblob,
 =09=09=09=09   struct ksmbd_conn *conn)
 {
 =09struct target_info *tinfo;
-=09wchar_t *name;
+=09wchar_t *name, *domain;
 =09__u8 *target_name;
 =09unsigned int flags, blob_off, blob_len, type, target_info_len =3D 0;
-=09int len, uni_len, conv_len;
+=09int len, uni_len, dom_len, conv_len;
 =09int cflags =3D conn->ntlmssp.client_flags;
=20
 =09memcpy(chgblob->Signature, NTLMSSP_SIGNATURE, 8);
@@ -426,6 +426,23 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_me=
ssage *chgblob,
=20
 =09uni_len =3D UNICODE_LEN(conv_len);
=20
+=09len =3D strlen(ksmbd_work_group());
+=09domain =3D kmalloc(2 + UNICODE_LEN(len), KSMBD_DEFAULT_GFP);
+=09if (!domain) {
+=09=09kfree(name);
+=09=09return -ENOMEM;
+=09}

The patch is quoted-printable encoded. Could you send it as plain text
when you submit the next version?
