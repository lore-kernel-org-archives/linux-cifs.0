Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795673114;
	b=wRRCQjNp9BqX9N1OvzqwxzR1Rn/QmygQxSaZOhqeK7OmeapXiT0T3E59k3XyfMlG4E+1
	 N1eHJjuT0dVnC6C+JDbKtWvgdtPq/C4dJXkYIO4+bkUWI72dd8TaEFY5cEgzhcslHikCT
	 QcNPxMWUOq12NjbZZNXm2RdhCXx/kR72a43L07tLlOXsG6g9F4zbLvzdhHOkN75FDg6ER
	 qUaRW6GlkWb5zWTHGKwrEQpO+qvCkEv8q0Zc3hurh9Upahbr4LgzzecrHoeiy2NMuP08i
	 JAr/w6wL7DXV8LzeZPxdPh3pOYjj+UKxkHizX0Qe3tkIFHKRlvqhWLMzheiYVqcyqOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795673114;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=fp5UQOF20iIgG32Nd6Jb8zt5azf0XQvs2GSN4VCnhXE=;
	b=e+E3j5D2B2rKyhg+L5+VA6Bxq5JA6mw+mPjEJaG+AfIcsubFFa+WRHA7a0dMaf3txbps
	 O0jWM93BPGA9owsoTxiBVTY9lZ+7WxX1cp4DA+C5QzHS5N5qi/q4lbJIYEB9geRlGUWtd
	 EcJ7fo7rB845VcrYf0n7AxpVBG3iQSwaTDfgJ/NaC8cOsZcwNMxf6DgydDwEU3EofzPGl
	 hps5GQYmbQ3WboQ1SmyAYUIUJtJXG4NkfTsaHmv3/m7MSb2KzH1X0oNSZPQZC3xhgwfS+
	 QokF7JsubtKr9G+/d00Ulrc0EDNmJuWwsxa8PSOuP6GNEvUj1hG/yulJ8jQ7PkfQ6XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QsJmL8vg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D50606A31C
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 06:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QsJmL8vg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9155F1F000C6
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 06:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795673113;
	bh=fp5UQOF20iIgG32Nd6Jb8zt5azf0XQvs2GSN4VCnhXE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QsJmL8vgJJwEBGOZNbcBEkXOJOjE/LQWVmUabXEPeg+CbnHwMD3PYUGGAPfjUfQrv
	 aJ/tZj/R50X35bXYRFTNbQGieRa9Jdfy8Ouimn1KCYGgtVymsOH+qCWyjU72VWAjXf
	 a1Z1mAsCmjKj//9tIKdgayKe4VzHVvJSSVnzIP9TmBGNyyH6tdwvJlhQWGSN9y58IF
	 ks508guJ8QPg8aLITV+986xRXdmOyDAR7Fnc0tISZBY4JZ4+ZUg0eH3VoAY19iHN5i
	 5TstmmKqqsVUzmYycEBUCw6YAnq2i2ejm7CDijfhi/RF+eG6WwwdixwoyfdqmfMk8D
	 K1iKyfdTh4dnQ==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso984359766b.3
        for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 22:05:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEuHSK8BAgc6RUrKvwwnjEPBzSUhDDOX/54qXBLzvNaL7bKxOoxrQoQ2/xE5EqTQfaR1byJ4VshTIjs@vger.kernel.org
X-Gm-Message-State: APuU4Z8LVRg8u2sGXauWJYWCPpK5eL5d86s97bahDr0OLCAb7nzeSImn
	ikurr9XdwtIhb5J0+YNhP/a9R9IHB2f22V2xxGUdWPMz5fIgZd8wNuLzqL6xF5b7LsemjOKm/PY
	G2BQsoAFn2utYa2EGJ1ZG/dNJ5qQS+Ls=
X-Received: by 2002:a17:907:a890:b0:c40:5ee3:8698 with SMTP id
 a640c23a62f3a-c513ab0efcbmr1720679466b.31.1795673112262; Wed, 25 Nov 2026
 22:05:12 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261126053456.1412092-1-icb@fastmail.org>
In-Reply-To: <20261126053456.1412092-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 26 Nov 2026 15:04:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9NSCsBsX3diAiKez1zE221+pZ62X+fcQZRxYx2xmwCvA@mail.gmail.com>
X-Gm-Features: Aa3M54ogQlP4cPAp8vIqenwADF_lE6DVevfG2T2Fy5EDRn98R8-NS_CIZCWV2Ck
Message-ID: <CAKYAXd9NSCsBsX3diAiKez1zE221+pZ62X+fcQZRxYx2xmwCvA@mail.gmail.com>
Subject: Re: [RFC] ksmbd: rework the DACL access check?
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2026 at 2:35=E2=80=AFPM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> Hi Namjae,
Hi Ian,
>
> Now that the security descriptor codec (encoder/decoder) is in
> ksmbd-for-next, I'd like to rework the DACL access check in
> smb_check_perm_dacl().
>
> Since April, 15 fixes have changed this function. Five dealt with
> bounds checks that the codec now handles. Ten changed what the function
> grants or denies. Some were about the DACL walk itself. Others were
> about how the DACL and the POSIX permissions combine. ksmbd has no
> single rule for that. smb_check_perm_dacl(), the inode_permission()
> calls in smb2_open(), and ksmbd_vfs_query_maximal_access() each decide
> a part of it.
>
> I propose one access check for an existing file, built on one formula.
>
>         granted =3D (DACL rights | parent rights) & POSIX rights
>
> The DACL rights come from one ordered walk of the stored DACL. The walk
> would use the uid and groups that ksmbd installs for the request and
> would match SIDs exactly. A file without a current stored DACL gets
> every DACL right, so the POSIX rights alone decide. The parent rights
> are DELETE and FILE_READ_ATTRIBUTES from the parent directory, as
> MS-FSA 2.1.5.1.2.1 describes. The POSIX rights are what the mode and
> the POSIX ACL allow, checked once for all the rights a request needs.
> WRITE_DAC and WRITE_OWNER need ownership of the file. A read-only
> share removes the write rights from a MAXIMUM_ALLOWED open. An
> unreadable DACL would still deny access.
>
> An explicit open succeeds if the request is a subset of the result. A
> MAXIMUM_ALLOWED open and the maximal access reply both get the result.
> The app instance takeover and the hide unreadable listing would use
> the same check. The series would also settle how delete-on-close opens,
> overwrites, and the read-only attribute fit the same rule. The same rule
> would also decide creating, renaming, and linking a file, where today
> only the POSIX permissions of the target directory are checked.
>
> Would you be open to an RFC series along those lines?
I agree. Please verify that the relevant ACLs-related smbtorture tests
pass after implementation.
Thanks for the work!
