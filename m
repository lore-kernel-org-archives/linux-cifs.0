Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792637632;
	b=lrA3lIvPzoYXlfw93LztzgWAx4qvJ9hoxRZlvXLjz4OdRSyh26f+5XDszCa9GFPXg8ib
	 Fqk8j5dGKVxog6NcTHH0bRAIAC1mJYO2h53gfpJLcbg7e5MEUKMCPJIFemeVuUnWa3yqf
	 AkbsmYCQECJ5GqiGhQz063A/qamPoSuspq3OTFFJiulxEygmObiUoZTlmNkKfSGsptxji
	 Q5Ql2nqNVEEuxykw1AHs1rCIQJDV/9mz6sxEpsJe5doOBbLYkwOAd++HO5jl67gE34vSl
	 QA1eyKE4ProlmgKmE3kgK8Y6j3dSiBy3SLj0NKSVdbSMov/dLOiSsWnTPhQBttIH2NA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792637632;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=NnU6rs3hrQM9btLPDOKgfodkMRYa3+dqaWM6BzIydXs=;
	b=wm+ZaIkgHNwECzi7yC8k0gNHlZj3v6XE2hiND/ERu8e5xJ77XmdvksAoOQG2df5gTM/N
	 ZyN37Ziyit2qZpo+R2bAMDLMNYSwxvR/EI0fuRKjLMhxKtMVIUPcbRIoIfoI3RV2l0Phd
	 RL3o32khVqETTbQHU7/PV+EjWG8M6LOstmeaXmOb5kyOsJJYoaery22a4xzx0kAA2RXi9
	 bXc0xoxvFARZtbOxqIbs2KC+9K2r3A0EletHmUzoXwN9RpICNkusSoIiJEvELu7MfTH74
	 aMumHKPmx7L7Zv4aBn71N2vLI6c3YaHVPaicqegpn3R4pR5EUxGhN53CkQoLy8FStLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="DTOI/Pek";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68539606A31A
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 02:53:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68539606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DTOI/Pek
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4395d31228so195847166b.1
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 19:53:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792637631; cv=none;
        d=google.com; s=arc-20260327;
        b=q6F19hyGnzH437q2XTR1zAvx8zRedoIh65+w6w0gmWGxh2P/f1F87FCYuzeXy4jqMn
         f2qWdQvUsng8B9jbsRkcLT082i76LuFroIxlVTK0MQGjKuvO48K6CFEaWjg9xUdirInF
         LeV1yaXQW95dx3XMa3aiL0gp5DVQY6zDhK8Vo+LRDbLcw2DKnCOi7xkYyctxeJbhNuDK
         tNImc6wZ8tNiUImDtFTtVggi/I+wgV4U1ryszZFb0pVyQJw+lY2b0f/J3xM+qioJyb21
         kyu2IhWf/Jp7ifvSqwtaL6N7L3D8PqJlRRj9pZBD7o0Agn1Z619gOkaTMjxqfOCduTnM
         9Yrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NnU6rs3hrQM9btLPDOKgfodkMRYa3+dqaWM6BzIydXs=;
        fh=WtsAggRbthgDpufiRM/YK0R+9+JDn+/ud08S5rxOJS8=;
        b=Eyor8JJGbYT0oO39VoljKbPrlqKPPeStdkQ/V37KwMMpTUPRDFKQbReOTxtBfe7q3O
         V4+0T+oRDSHkH8WBJyZaykfqzEPRke/GDpOR4MWvRf/Huv57tvmep9vz+ZygDM3umOj0
         MjdGJn/SUcm07G2KaL1RnjmGSxM7UgKOo1OfO/oMWih2V/6Goi1otmr4QvKxegdl5SN4
         YqLSAy0/5LpVV/z8tjDyv3g+zOVOHk6sYinNF3/n1els5Orj+H9nAq5oys/Lg99g/2W3
         bhPkbGO0tBVgVO1zXQiMy46RSMoPH+En0YHNIHPTdStigAu4gqwnzrFdkCpYsVVOCIcP
         QtNg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792637631; x=1793242431; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NnU6rs3hrQM9btLPDOKgfodkMRYa3+dqaWM6BzIydXs=;
        b=DTOI/PekpHCFwbCxS6btLnjWQNCiYVc9jJXCEYwAmPekEK8t/PxBNEKZNgCm5yMo5O
         ZHRqWqq6Sa4prnp5961iu97eKvO2fCe1P/oDhQUuXQyhe3en4gFePLH+ndAycKrOkdLY
         ZBtVPzCtW837QZIUsvIlXqXaajHAOKuqlnaym36x90uyaZGBsQGk0lDoH47TKDdTDSv/
         +bNghojo2jLNQuKI4CGPrg7pLnnWdQfj43K8C91aQyr5qb1zEo8L/J/KSRypGRSRs42E
         gu3hUif099K3NIyvd05k0+GuTWcbFOAPWaSRNh9N1gfC8G9MuampVJBqQHApn7d+PZp0
         CiAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792637631; x=1793242431;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NnU6rs3hrQM9btLPDOKgfodkMRYa3+dqaWM6BzIydXs=;
        b=TE/wjNNqqrrewP1aiAU1tSeYqwFG4o3DfLRQs205xaGaXkMAoE1tw5CB479Rrjo7bB
         8CJ9E5127OmthAkL3Vyp+UXJ55FG8y4J32UbqETSaLpf3fvd6bGxIzOsqhC2LlixwJQC
         BA88INyXXw8ADDk2rfRyGbY2nVzeXxw1yifmoN8w8avH+KZ9OCuKaeFjb2tsJ0hREBAL
         rWbK/PrvMXqzJTgyoSAasrA4/PXN+PJI7/oIT61TL3JqBDWsAxYTNK3qieONZxGpqRYq
         mrlwhzLeVRhjNeoemq9370TCsmEZilUPeMNIm9TCInIUD25aFXMc4d9V4a2vI3vCJOn8
         j4JA==
X-Forwarded-Encrypted: i=1; AKwUvBycQQdmKJjV8/NlWgXCQrODWfMwVVqoTN3/7ZmFcNbN/7lRPclTHoSYiuhDYxBGhjrXMACPyKnnEoD5@vger.kernel.org
X-Gm-Message-State: AFq9FYKpjTcqJONeA8WaIm9fQFu1jFg/YCG0CzI0lrZRUKPDD5hzD6/Y
	hQ+YZvOX97QP553lTiIOam3idQ42elk11SkAWtL3gh6ZIn/xyFRi781kU5YJW6WYyZjpsq220Th
	QevsuevYo3sfVabBBbnCEMuCzXtr6XUY=
X-Gm-Gg: AYBFou0vUKDNuHIMpVC2Bn2dnSzMgLfDnyq7/lmrjubpLLBbn2W7jZq+dyxiXVuW+3w
	Sg6xbsPN+mwMGDWnkOOurP22Ee4r+SnjqjVPqWhJe1C7JcEBtD9EKz3NIos0uDYOZQHRsCq+o3l
	ADFmUKdFLe/hp9XcRCwzlgsQjdBfr5zvgX+L0lDJsK105NSOufxIOGaZAce2ifHxHRnFuJ3cUoc
	RkEB8m32GfTvEcBgztwKA88zftahC7Bzv/kgKBFmppS8ytOV1T36kj0lGzlc4GH2rEFRkowCfFo
	rE76FXgdHFKy5eP/v2ZjZGGPGLuj9WlNyILbQCfqQwDeQydX+3k+Wppq/iZ+4H+Edm16wVROm0d
	LGnlZ+6iWqzxQTzpxrgShgc+a0hRoVrAwgvSVt6OmdKbKRLkKPNtRVX9YUg==
X-Received: by 2002:a17:906:ba84:b0:c41:8e21:4d60 with SMTP id
 a640c23a62f3a-c46791326c1mr341731966b.1.1792637630664; Wed, 21 Oct 2026
 19:53:50 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1792552161.git.jan.koester@tuxist.de> <f444dffc8e6bf98bf44c02456adc2de40e4ecd95.1792552161.git.jan.koester@tuxist.de>
 <fd20b840-350e-469c-9fd2-008fa0ded62a@slotpi15m67>
In-Reply-To: <fd20b840-350e-469c-9fd2-008fa0ded62a@slotpi15m67>
From: Takeshi Nishimura <takeshi.nishimura.linux@gmail.com>
Date: Thu, 22 Oct 2026 04:52:00 +0200
X-Gm-Features: AclHuK8zMCY_XzKvgZWVeEW29rK2WIKSmZA1a7YbTdfyZ3EtSnPZJ1CNUxd7pQ8
Message-ID: <CALWcw=FYKcDNXeArpsabHiQOAL+cWkF=L3stL6MB0OvVaHei1g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 40/41] nfsd, nfs: carry UUID and GUID owners as
 their text form
To: Chuck Lever <cel@kernel.org>
Cc: Jan Koester <jan.koester@tuxist.de>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>, Jan Kara <jack@suse.cz>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Paul Moore <paul@paul-moore.com>, Arnd Bergmann <arnd@arndb.de>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, netdev@vger.kernel.org, audit@vger.kernel.org, 
	keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 7:44=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
> On 10/20/26 11:16 PM, Jan Koester wrote:
> > Encode such an id as its text form -- "xxxxxxxx-xxxx-xxxx-xxxx-
> > xxxxxxxxxxxx" for a UUID, the same in braces for a GUID -- in both
> > directions on the server and the client, and take such a string (it
> > has no '@', so it can't be a user@domain name) as that id again.
>
> A bare UUID in an owner, owner_group, or ACE 'who' string is a new
> owner-string syntax for NFSv4, one that only Linux would recognize.
> Thus it isn't interoperable with other NFSv4 stacks as proposed
> here.
>
> RFC 8881 Section 5.9 says a string without an '@' that is not a
> decimal number means no translation was available and the receiver
> "should not use that string as a basis for translation into its
> own internal format." RFC 8000 Section 6.1 forbids bare numeric
> ids in multi-domain deployments because they collide; the same
> applies to bare UUIDs, and more so to GUIDs.
>
> If you are serious about pursuing this, you'll have to start by
> raising the proposed wire format on nfsv4@ietf.org before the
> Linux kernel's NFS stack commits to it.

I recall rumors of MS wanting to stick Windows SID in text form into
the NFSv4 protocol.

THIS proposal is even worse, in every imaginable way:
Stuff an unreadable 128bit blob everywhere. I am sure people having to
debug that in the kernel will LOVE the idea (compare blob a with blob
b as human,YAY!), and admins facing the 128bit hexdump will send
marriage proposals to the author, for making their lives even more
heartless and miserable.

NAK, -1, for the whole patch series.
--=20
Internationalization&localization dev / =E5=A4=A7=E9=98=AA=E5=A4=A7=E5=AD=
=A6
Takeshi Nishimura <takeshi.nishimura.linux@gmail.com>
