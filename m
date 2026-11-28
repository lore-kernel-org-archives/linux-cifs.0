Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795828627;
	b=YORMHxkHnW5B9r477c8vodNrzxR/boPIzQFEBBuNOOGb2De0mZFHcGVEQm61sK6hwK1F
	 cSz15borK1oFY5a8AxY3b2AwoUJjS/s86fw6Z+S0Z4Fold9aSuJIYpNvdO32mjy72Gp5J
	 Y5L1P7Dl5JSsuciVwz4ymTNitg/1tOzagRe3Z3EJ+PNURix+G136VHmWFyFZLdjxnkVi5
	 KoUqj/6vWZ0xD+tz45wK1l3/Gmxdc7zHCLCncFP15KCekqUmI6ztZy8+WAkKVcyVXSnu1
	 YYzqyIhRmqQ3Kw1aXIuKTpEV6MT7iFamzwZIhrX01TFxlBWW+wy8UlDq0FHBgOF7ETg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795828627;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=xToZB00hPDnFX+N6Ws3rv7y38Xp1+GHEYFSDyMJapVU=;
	b=GvI5AYO4ZWzE+d90GolFSTrpEpCsE2/SXLisnEyVwZOSOwQ4XEdXMEt7Yx8htoU3S47X
	 pTZanURYgT5vBK4ShsVhuUsR9Vth3benF1PQaHfSQlADDh/7vSUGwpIDd3H3pfuxdUXsk
	 9PpFYouEoH+WFE7pRAaDX2/cxP5Pzjzig/h5PmNSBTwhhX5uE12oVi51Le0l6vCUjJo6x
	 9XOVr+LCN/rZU/1CMWf35g+VZizroLOGmsJqXWFgM1zP+nPIpXaPpQOsCbXskTRzJVteN
	 4n62Vye2VTfMMfVUYfJxWFQyKL4SztgCKf2vJBg8bLas1byFkVKmL8H7RG27X/PUkVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gBhsJ1vG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7749C606A321
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 01:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gBhsJ1vG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB011F00899
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 01:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795828627;
	bh=xToZB00hPDnFX+N6Ws3rv7y38Xp1+GHEYFSDyMJapVU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gBhsJ1vGx5CUDFWV63vdt2oxveq1D6BKn1cQ3c7DnMCskNhYgbehSUfl1d7GC9iSy
	 Sgum1EPIlOn/ig26WwNQuW+F1UGmdZISTe49vorWeoEBP3gmpWrrXsK21cecm2MXUX
	 3dTNwCsSczBpEELWPkhdjZBFpbFsCpd0LpCTAM/mDHdylxNqgzG+xcbKgJFKkH6iND
	 ydG7s+a076mEN3olUTS6v24bpCls0qgB1ibB3ConIf3yP4RC3JsapS0b0jrEsVFKKs
	 bMH1VFPg3zLVAGd3jpxC2H1dQJpEsYsTkjq2kZK18kSsSqNA7fiTDBkLAWNPpHXHjV
	 JvQeqmu5LMEbQ==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c505b2e1cb9so1547755266b.2
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 17:17:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEjAYlmYCNgDxdpF1Nw9a1tAkrxFfGfyfpYDBm758z42fB08VH1mlkWGZ4uLP+ugCdD7fWLn+q3pZsH@vger.kernel.org
X-Gm-Message-State: APuU4Z8s33W03sa5z0zp3+etg5hjDpxcpudxSSei8OI05owZNCiHTK01
	0f828HluuOabeXlSbSrTTHGdjsq3VNfRyBKmJ0lzzsGM6/CUjiyLjLTS8dYfgKaHAOEQR23IIRX
	C0xRpDTKDWE/VyUbfUg4Q8xi9in9ouK0=
X-Received: by 2002:a17:907:fd15:b0:c50:f1c5:f815 with SMTP id
 a640c23a62f3a-c513ab49777mr2134433666b.31.1795828625787; Fri, 27 Nov 2026
 17:17:05 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261128005905.1687065-1-icb@fastmail.org>
In-Reply-To: <20261128005905.1687065-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 28 Nov 2026 10:16:52 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8iAUam4t7dAEThYj6Px3THraX-LzUU595OHah-YxFwCQ@mail.gmail.com>
X-Gm-Features: Aa3M54rpDriwixDmOJoBfXvL2-W_hkN6DZb2wRHlg65gC1YKfXFG1UkYIA1H4VA
Message-ID: <CAKYAXd8iAUam4t7dAEThYj6Px3THraX-LzUU595OHah-YxFwCQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fail an open whose stream cannot be created
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 28, 2026 at 9:59=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> When smb2_set_stream_name_xattr() cannot store the xattr of a new named
> stream, it logs the error and returns success. The open then succeeds
> with FILE_CREATED, although the stream does not exist. This happens,
> for example, when the caller cannot write the file. Return the error
> so that the open fails instead of reporting a stream that was never
> created.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
