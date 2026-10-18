Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D3B430CCE
	for <linux-cifs@vger.kernel.org>; Sun, 18 Oct 2026 19:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792352854; cv=pass; b=SpS7JkKhHx4NNUdGbpw5iSjYRc2f60XUujcmOuFRtd8hrMI4I8ScUxsV14gU4CTc00ch3kPDQ1Koo9akigg5r3UreZR8zs4Xi9yYE7J4RRx3eldXUKgy8tGdkntDUcvvkeSQhdNVhLvaN5SYzAHvTANlTAR9mPBxk74+xklz5p8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792352854; c=relaxed/simple;
	bh=uSwsGj7z13o5NrJE21iC68UKNr7h5yOq6P5JpP5TNDM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/bcSyPxt62NLdYBfJgzcN7Hs7joe6LqFodeTjNaqnt3EZInXyI1THVLOYPUr7biJJxJfcnjKV0Nj1MblfAU1JzvswmXCPVAon0TX29Bk3+iEV1XvNNPdjTi5L3Pry8zuEtjQimIhB6Qp1WXWQLMO0ejdy64I0y0/NaBhxTiDaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=U61hr0Px; arc=pass smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="U61hr0Px"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3ab3b29a1d4so2793681fa.1
        for <linux-cifs@vger.kernel.org>; Sun, 18 Oct 2026 12:47:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792352851; cv=none;
        d=google.com; s=arc-20260327;
        b=gNgmzj6H6pJKc666wqrrUKT301N6TW2QWl07kfPAHd3FhSQ+kvWMjWr+gUcNae6klS
         RLgKm3Crzx0B/cwi5clmYrGVm0lvqm+zHopfjk1afnMbgTwqXmK6YJ1Mon7WkQAbO1er
         tticfLNROp2HL0WxrzqkV+NirOiibsYf/pCsVwE15w9s//I05KWix8BXxhziQ0IoGsMq
         8C4LsdCMfX2/E6InHW6A8F/uh1Lk06ySr5sBgOPGhafgOrFF/hBA8ch9TwHiqdSM7Ywh
         a5qUKMzlAjJdS1pT9FxpqcEZUkemlIpvxbe1BN4bzzeH+enPr4KZAZV3otVTkjT72l7g
         OVIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C9PTaRCgfnWLejuxwMwgHezQmSpb/Q49pSzLQ94ksTk=;
        fh=CN9YyqNgaHXXEag6i3eki4Y20tX4QFlpLuyZAGIVgjc=;
        b=MCQS2GK+Ug69VPQ/3mUNosTe1Cvvo87nTb7wG9TR8mefQ8z4hqhjMCb5N33HcNUkzS
         SXIQljV22Uru/6jj11rZ2mltCJqx4Jpkt9lxz1zNaPhQ9I+cSTG0kWsvQ+ciATwNW0FL
         IUooKHKjnWzEc8cy+KVw6qUbaPDqYFLeKzy57fj0xiz/GUnXa3zuWBmyxo4CDj3QOGu3
         dnUZt9ps8JQNF1I2pRFEl63dJSDy6L0EBMgyInD3RdiF69oGCo9r4ALc6PMfsAcaJWNe
         J4C2hD3E317fu08bFba4XT2PJCXF+QI+3DfZsKU/DuvpFpLwJ51/bLMyxRaMeE9qtWRC
         JjCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1792352851; x=1792957651; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C9PTaRCgfnWLejuxwMwgHezQmSpb/Q49pSzLQ94ksTk=;
        b=U61hr0PxGjsekFN/Peus8SSvsCkWL+X4cEShlWPsXJwFZsPSOlvUCsybYg9BgwgJRd
         4XnxIJgNM2UxnPRJ7LJ9ePNZaMA3S+v2khZQd28a3QJuiBcuUaNEpSAyegrHLGxeAQOF
         XWhhz9z4gvoj1jD71wUdmMg7TKUgBLlQEbfCfdSDreL0vc42Gwa+0w9MuT0mJeW9FjHk
         InbXbqmJqWqFBCaE7bhMzpyoImihsnstJokhn5vCptf2p7cb0uxL1CtKsrsoOoa51lXm
         tyklrtgAN7N7S853vG7iCSHElYqHLPGyLpCn9vrAZ76I1HHBL84qCv0LlLe1GVF1/qq2
         6Adw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792352851; x=1792957651;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C9PTaRCgfnWLejuxwMwgHezQmSpb/Q49pSzLQ94ksTk=;
        b=FVNeAYs8OmyFaHAtNY+yt22aFHn1w8P8DddldrQ3FJqwRmFcaGIYecKJbKDZONx7r2
         qSJ2nSf/dx0M+NaJErvLYUvtvFAAduieREeBVq/rrffXRedsuz02N6T/8iGEFSMcFZZm
         uu+wKR0wJ1Gpn62+aGtYppx4yBfpkQb2ZJ0R5sb+3F/OESbTlpb9sohG2ByBaEx9sVGJ
         2qLjoHPRVrsc5KgKJVZEuHKve9NfoekoKKeQHDg8FWdziLRgbW7HM+I6y2z/5xSBt9EP
         L7pyHQaIMFcLbjYNqlufluP6haqKDCsu0V/d8AR6Sux//uNdrx5a+t9vQnaljV0B5+a4
         MFGA==
X-Forwarded-Encrypted: i=1; AKwUvByh15kjHmGtOzuYL8UpLm/xr/WgKmUyhI++/ZClFphqlbUM9+pM4Gd6JjPaMcaI7ovV5xGUWQft/wx1@vger.kernel.org
X-Gm-Message-State: AFq9FYKSF23jR8z1mi8Tcd188WrKFElKisfbmsC0/BRBrmlc6Md+tUGg
	CHybR6GM3hBi19Ni6uwJWK+6yOtqeNqnjJ2Ln4YZu3K7DDvOPaqh84POhfNsSL1PWMHwIIRd6Fd
	X+eqggoEN8Y8UJiTOJUU4u3d9T7kgQtyLciqAMLQR
X-Gm-Gg: AYBFou2iOOO5FHJ8TwZG/paFZCc88KyFmNOtVllO9q26Qs4CzPWmMS7AjCE7fUOyen7
	xSxY6/H5LSBzMRoEBCA6rMJzsvEu8tLDkOWugArNRd50XJtI5LqBEJ1Vl+6ygDdP5Gp5BjhoNbj
	49uiEYa2tiCs/7Chuz03An+mArrV1eZViBk6AcZiCuEp3nwMfEg3yTlRE+bdsrCUnmwkkQWGM2d
	DkKBr76yHR8jExW4mBaJqs4eeojN25pfAT/pzCeDLC2ji5bZWYOIDP4paPa361ZpIB672RXQqDl
	ozLq1xg5jn319EF7uVbUDC5KSByKQ7pX9FtCPQwIlFTVvM4SQ1Xh
X-Received: by 2002:a05:651c:3614:b0:3ab:1639:9a79 with SMTP id
 38308e7fff4ca-3ab292b7375mr9897881fa.15.1792352851051; Sun, 18 Oct 2026
 12:47:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1792346472.git.jan.koester@gmx.net> <9c17a1f7f82b953e6f4d9e17f4ca19d5220d7f2b.1792346472.git.jan.koester@gmx.net>
In-Reply-To: <9c17a1f7f82b953e6f4d9e17f4ca19d5220d7f2b.1792346472.git.jan.koester@gmx.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 18 Oct 2026 12:47:19 -0700
X-Gm-Features: AclHuK_TjVvADO7YV_Of3nNvklGJn7yisT4mnRNh7189wUPwvl6Zlkl0ZNpg8pA
Message-ID: <CALCETrUjRpHSTBzO65uU-YaEj4espqnwDSaSLcXu653xJyooHg@mail.gmail.com>
Subject: Re: [RFC PATCH 09/41] uidgid: let kuid_t and kgid_t hold a UUID or a GUID
To: Jan Koester <jan.koester@gmx.net>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jan Kara <jack@suse.cz>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Paul Moore <paul@paul-moore.com>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, netdev@vger.kernel.org, 
	audit@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 18, 2026 at 11:10=E2=80=AFAM Jan Koester <jan.koester@gmx.net> =
wrote:
>
> Make kuid_t and kgid_t (and vfsuid_t and vfsgid_t, which share their
> layout) tagged unions: a classic 32 bit id, an RFC 9562 UUID, or a
> Microsoft GUID. KID_LEGACY is 0, so zeroed memory still holds the root
> ids, and KUIDT_INIT()/KGIDT_INIT() keep building classic ids, so the
> bulk of the kernel needs no change. The member is renamed from val to
> legacy so the compiler finds code that peeks at it directly.
>
> Semantics of the new ids:
>
> - They are not in any uid_map or gid_map: they exist in the initial
>   user namespace only. kuid_has_mapping() is false for them in every
>   other namespace, so no capability in a child namespace gives
>   privilege over them, and from_kuid() and friends give -1 (the
>   overflow id when munged), exactly as for any other id without a
>   mapping. Anything that can only store or report a 32 bit id thereby
>   already treats them safely.

Why?

>
> - Idmapped mounts map classic ids; UUIDs and GUIDs pass through them
>   unchanged, as long as the filesystem itself is in the initial user
>   namespace.

Okay, so they pass through but don't work.  Sounds unfortunate.

> +/* Like kuid_t and kgid_t: a classic id, a UUID or a GUID */
>  typedef struct {
> -       uid_t val;
> +       u32 type;
> +       union {
> +               uid_t legacy;

Linux is Linux.  small numerical uids are not "legacy".

> +               uuid_t uuid;
> +               guid_t guid;

I'm at a complete loss.  Is guid is only unique on Earth but uuid
unique in the entire universe?  Even Microsoft admits that GUID and
UUID are two names for the same thing.

I realize that Microsoft colossally screwed up years ago with their
little endian uuid idea, and I sincerely hope that this is not some
endian thing.
