Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795190318;
	b=3lOGdnPsOszkZ/OWftuhuA/7KBze6x3yGGDFe4f06bskiWr4McFOpMLwdnpd7pFdNvst
	 5vqylWY3hCzSCM7YJItqvizhffFRoqAtAB4GemxVqO8saJeRrDc5l+GhSPvGEegeODYGo
	 FKsuD9ReLmf3LAm9JNMKz7Vm7hn3+Zzj1fPrlomUYDOfrthIzNhC6YyS8fS9KG7Gzu9Tw
	 21ugiQ8SSep789qTqnSoMQXmQtZMYI8aHY5TKA+fwayb8lljfCFH5oXh7l63Uq+HE+FwE
	 PX1DQru07mq9YNqh08zV81khMvLb2npwMSjfUsNPSn8hjUZkPy2+aDC+82hVC3KF72Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190318;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6kM0KOtHeHKXYurgzFZtJQepqztK7z7Hv0tSSDFAXAE=;
	b=iCMV3GoFcE669zfb/5vY+tkkj4jOTS0N7VXTgfRPqcHmeCqTPYurjN1AtqjWZ9ZIsFTR
	 NXW4u8J7gNflVmF23jID0gIR74W7Z0N2JWgjlrOXmV9ULRxgTVuf6YyOfTbFWXZ/A2uVC
	 +F9N78p3sfmzlcF+fadC1IM8Curuy28elIBqaBleRftGi0FkZeyF0sMLHTsSiS52ybe9v
	 GiSLAODhbmgKkiQ5B0LNy2ZvAO5krA1IS7Vsn+dpq2+gGQ7S8hKLA0VnjJznr3vF211gA
	 imewRqheSVcpTkI2YjpbHwfHGSkuLN4KjT22AqvSSo6lqwiNvI1OmtvRBmM1v1Z+zPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eTc+eMp4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C0860A2615
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 15:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2C0860A2615
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eTc+eMp4
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b894d9a075so1219472a12.2
        for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 07:58:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795190316; cv=none;
        d=google.com; s=arc-20260327;
        b=nNYpjvd1eSoXFy6XbqbRp3zAmBwr7fIiTsbBf8+/M1ZDnCZt+q70g0GbWFDLk49oHo
         kviUTEwk/gQMJzo8wdN7sobQsqSMtrYIbik9Z+Y80woAaUjy/uX91MC08+MmFR+WH65G
         plU/kz8zriaypg4FmX21fOQUHbNZ35yYe2AeWKOdArn4DpeDmhIf8TrJRjI8iwYJD1Bx
         BDO3WoG6ep39z7Sb6u5Om+fERQuW+3CXfeq1OiUJ33we0EtNnQLxIk6Eza08cyU+ZWD2
         WeQp93h7vlc0IpqYCfDbEr1BZT3uuVuWAke+kBMnkYUiAVMWZwfO/7E7iwVKu9Flf2jb
         zk5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6kM0KOtHeHKXYurgzFZtJQepqztK7z7Hv0tSSDFAXAE=;
        fh=5sAQ27XJ7F8KuPKnJlYShknCH/RdrfwZLM2goSQsIoA=;
        b=rksEbYyJ8qj5vPmFZSLZRK81uJXFbEE0MVr+XFn/dfbqrL4bZ48O4Ilum/GfIuR9m7
         CMGY18sRPoYHaUVDDzs0z+4DF1khRBERTyDFzKbx82YH2KY/QTM/FaZUrouXWVcDd1Lw
         tl8pswbEpEd4BVyvsW1o3k4W4gGdOzv9G2T8NBBz9KZ0vgCtN6qaV8BThDUwToH4YCJf
         5cdQU773w7r02VtcfPN8lxaZn8W5mjN1xMEzB4CxDreGqKlkBJ7okw/99aETL3/W4gHI
         o3J4CfPWPRKEoNLZmLrpvo01Tb+mIl0aLXd5Yld7XRQtAJD5V4kB21+qYKcTlcoCq/nr
         EX0w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795190316; x=1795795116; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6kM0KOtHeHKXYurgzFZtJQepqztK7z7Hv0tSSDFAXAE=;
        b=eTc+eMp4bITMI7jgx5jM4l7NyEFh1c9lTC1VxvFXF9G+vcYBoZB53yLQdKfrQOpf6F
         Mtz8FTmSSTw6Ei7un/2M30yiLReetEhAe/lO4dm/xLE7CcivvqjbhlK/KCKhN5ARxijZ
         ChezPcoSYPSGA4dYvVLO7Yd9kb7uDyVuUiuKTqgzbCAKx1XbYJKzxg+Mx7ccVg34Vcwt
         Sq2087h5YZQNFE89KJ0Ys4A0dIfGzwnygs4zE++uxupxXjpFy9vZB08cycp+xBcweq9+
         96UTqALXMzvyeJr5t/bjHIhkmiHd4xvEUtcz6apgxXUf6gRVWrykVKb8LpEbPe+pU8hS
         b+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795190316; x=1795795116;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6kM0KOtHeHKXYurgzFZtJQepqztK7z7Hv0tSSDFAXAE=;
        b=QyjZ6iUPtl1+4FyCzWATPVxv6vDicEPIbQ2Tb6D768KfBHJVjJ4cl2pvEHtZlT4YMg
         qJjCGtN71DlPIrwq9OVP3FB+9emlPiNVXGfy2Nzrwqw0eqE33YMhTuahAj9MmUn/diuM
         yT/GBBFq+LRH+LJgMgKvzloUZjHl1+5DLERmBmn57H7wmzrsj3j2W4OI2Bsw8431H1wv
         xS9kMXDMtxII/efDphNR9Yv8A0RtAD+Q9m52zHprRZ6TNbAaNt/Ed+0++6VBot7nknmk
         rUSpfjnhaAbodO5Y5e4D/Zv1yHWsBmxCtEluspw+aCjMbhvw22kqYyTj1AkQgDCJfe1a
         ztoA==
X-Forwarded-Encrypted: i=1; AL+hErGarkPMTA2PUtUptZ9+wlbQfe7XmgvzlyYihT2LLtIM9/nsjgnXUygs53KKGDbFqWqeD8bYRGESqBIJ@vger.kernel.org
X-Gm-Message-State: APuU4Z+Z6hbnabn4w/LEH5ri24h0BiKyYxyDWQLoUWou0hxD8o2Q2nx3
	YDnBRF/l/IMPnTvk+M12d3Y5Os5D1Z8tccgP1PMHaj9IKPP3DhFuz+6eMwHORRoZE3aYp32nm3/
	Fra6bWvwD6djoQLAFNKeDm1blj8VvnKg=
X-Gm-Gg: AZFdTZfJmFGoXhFp3FFAM2RudyoeZmzE0dSoCqlDVg1rVqnDkkzdSEtwF61nfjl7Xoc
	9biDNfPu4PEwfd5PkNRhNWzf84h6rg28rS5j1EOtv7G5JjP/2GUgQ1CMz/T/oEVW4Rct0XCTRcD
	Knq7qI4s9b15kJ3gqgR2F7n5FfFztU8VI62sc+DP2T1VaVbS5GwuedZ92UKCZmeCX5rhyXKKFbI
	eKU0Co+H+nSuqPbqwHepbXq/IkbyOd1eLwblg0YP/tMAjPo/fZ/lbeWF/EJmI6DQa589kufpAV4
	qAVIK7ryrWniCqjtwpYIBAgtXdw+TLUEEJyxZXrwHZ1wKYVciVZPfrswH0/4siCxFOJLLy5Gdxt
	UyXdI1Yz/PuRXOq0Cd1BuxEkF1FCxIkfLeFMudetgYkrD6oHNGwh0AMZgY8vdddlwZUerog==
X-Received: by 2002:a05:6402:52c8:b0:6b8:5aba:6c06 with SMTP id
 4fb4d7f45d1cf-6ba37d652f3mr2090064a12.14.1795190315774; Fri, 20 Nov 2026
 07:58:35 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-4-koray.fra@gmail.com>
In-Reply-To: <20261115180343.576773-4-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 16:58:24 +0100
X-Gm-Features: Aa3M54pideZA7GJITw5PojgxjktVU6GBxKullq4dSyaJ0XYgg1VLGv1zO6-iMnU
Message-ID: <CAOQ4uxjdEiuJMQxtSL8XrPYHSamtfMh+BM8kS1wj_PVME4JynQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 03/10] ntfs3: make crtime user-settable using ptime
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Since NTFS supports user-settable file creation timestamps, map
> provenance time (ptime) to NTFS file creation time (crtime) by using the
> newly introduced ptime API (in commit "vfs: add provenance time
> (ptime)").
>
> To do this, update ntfs_fileattr_[gs]et(), ntfs_getattr() and make it
> persist to disk in ni_write_inode().
>
> The timestamp is now retrievable by using file_getattr() or statx(), and
> is settable by using file_setattr() with the FS_XFLAG_PTIME flag.
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/ntfs3/file.c    | 20 ++++++++++++++++++--
>  fs/ntfs3/frecord.c |  8 +++++++-
>  2 files changed, 25 insertions(+), 3 deletions(-)

Please don't change the unmaintained ntfs3 driver.

If you want to include an ntfs patch work on the new fs/ntfs driver.

Thanks,
Amir.
