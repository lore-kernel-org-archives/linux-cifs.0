Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532DB3368A2
	for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 16:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784652111; cv=pass; b=mMW80VhaDxU6VA5OZepTrIdzJ1uFgys2nIjZaJJFZj29PaMIxmx3mblOJgsxJylr9OqECOm3sNxD+rm4sPbivlR8ouIKTzvnwN+GpGdFzYYcDkwr7j43Jq9Ulk79JyubwIZWv0YYdkYkheEaUr1PvUqVwCmjIL5fv5EsvO6+91Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784652111; c=relaxed/simple;
	bh=kAtXvagChq3Rcl4LPfijVfpELrNt1HJpUNZPq366374=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NXQE28+GCLZaNsbP7XDhTeOnlIgR+UltSNm6bbiCPugwqymLG+wuJU4uB3O0Dxy0ja9oGsml575gCJO3sc2FpydxTteC1QHjupuwWzxmhtdCUp9EWyQuVnKO5Qx3+Le7JBc7ofVzWtrzns0nWKBbxZGYJ5c6Ehd33cq/Zdu4ygk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GRoPB3es; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GRoPB3es"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c05dcdf49so7353781cf.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 09:41:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784652109; cv=none;
        d=google.com; s=arc-20260327;
        b=NnTITBngi759p9V4CnHPrtEhk86j5bpY8AoC5+MMWyu1pN18pMqL2O9PGFi0eKkiQd
         I/HjlAgwr3MHOihLkI4sJnzNue8P+LTKEdv19AZugd23vShvkvBXVVj8qh+vqzzq/J1w
         nByz13R0ovAgMGzbHqMxgjjilu5c3rI2GmbJt6MglksxRz4tKBU/Wftfud9PnCQkfqGq
         jPpqMo+V8MSefdvAMiRPQNXUrJ+sV4mEzrxPb20MIjsG/JsK1PqYnRDsYAID6T42NBEd
         wi6bkWN7ZgBsaKMm8C6pkwWVUc2IPPK/igjungQTfGYBHT7fHIOkFyNtB7LwosdsoS7D
         Cz0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W17EjLvB5OjvPYrIy9CJ6rXuMee8loffJP5xKZwf/n0=;
        fh=0u1h1NGo1++gw7+ammvopozV9L/yAbQa1R5kpNEe/zY=;
        b=L3MdZgA9n082cXNJ+VT3a2mfKN10MZQJap5RE44a5UpbSST/CQ52QiL/sxStWPAodb
         cL+u6es3AKvE0C/5T7SIACinvc89MrzElPv6OehkFFoIbJFX4qZzl+I9FZpYfwp7pj1E
         +j+p9YxSpbDLyVTOrdTFcG0CtIPUa4Yi5oqrxpq0C/+rVwpI1jJdsCn2P53uRJSBRLmu
         N/4kU+kKm1QuL6+KudJmM1Y2zpjDkAgnXhJdMynEd/C5QF2w99plNFnXDDewTrSxKVKz
         dFZjxJiNy/EQZMuFCPbfSwpD1kIEakHNjZUo0CP+3HTClUx+AdTWJLJrxnWBj0Z97dmH
         Qrww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784652109; x=1785256909; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W17EjLvB5OjvPYrIy9CJ6rXuMee8loffJP5xKZwf/n0=;
        b=GRoPB3es2T6acGEYjpWOU9xuKhoi2ULPzNFEp0Sk/KYwjjnD780DqRTzXjBIRcaonp
         QMwV4ah1lkpqZSlEgdqNIosVcZL5y2fJv9ftZyFdcTWYtcMOLeYnypMy/ICm92ouTCPP
         +8qaCGRA833dPGQmd8ToBdOF96ht1jcEr0wWUY+jS+2MqSWVTj19WFA2kFDpvgM4t9dh
         xXGO9Cjaxn73MhBiilDEStfFDrbY2STPCew5wtw9t4DSL0Cq7EYIdf18d1O2Gd2R5gXL
         Jq/u2ouLLXPsdBalAOnqxYt8FxkzvgnGaaNM/Z52wgiJyj/Sx63tnYGUSkkUYKlHLXm2
         OosQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784652109; x=1785256909;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W17EjLvB5OjvPYrIy9CJ6rXuMee8loffJP5xKZwf/n0=;
        b=V4IC3wUrHtdc2UnVFn+S6SyYI7rFmP5QbLk9sShZhe+Yfo/uC4WBZjpGa2BB0RxQtK
         YdUZm0pqTIUgb9SWQktRkzJ4mgvaiCT24qBzev1ZnmTQpT5ombZuNQ0kbTd9TE5ETuIv
         2EFw5TunvYjLqXEcceM8L80eve9SJU0Lq7rt9F4KPkyFh2p0dNqgf7e7EbqiA5HCAefz
         TTNrMuk0kiG/BgPnp43YH53OTHYRlNhcWkh9g0RG7bJFBL864QErcVCNdlZ3uVH7VK9j
         ArqMGdTAS7tLeKwBrdVkumdX8QeuezM/qw2GjOQeMSNenmtIWuMtEuXM4mrC819LU8Hc
         852w==
X-Forwarded-Encrypted: i=1; AHgh+RooCdM7j6dkLpSrXeDDdAiLEtkGINPcIN/kLgLktspzLbpSfuT3uEoA4jB2ugjDtxyg5YTMkiZ7SsyX@vger.kernel.org
X-Gm-Message-State: AOJu0YwnhAJ7PZYEnEzwn1NdCua3jmdtL0cgpJL/YkTgIqrhKF3lpPHR
	0/Ltw9nkBoWyXKyInyIfWn7/cPUIbrwfa/B4twEaLq5TWQDGeKucbwT071MHQdJwa+dC0hk06wa
	N6/imkLfHua6Il1cCh+PRtlFzwLbrPp/Cy8b4
X-Gm-Gg: AfdE7cmraytVM02Z5CPXO4fybgHe6SzA4sy6bDus5y1tEU1Z9268lL/m33skkivXmde
	L10Jmt0yOEd20XmxFtDCWWWM4pV67+QHw5JtXgnjgSLgnSBMCLAOWdg2996iFlD1Zo/EGqSYTIq
	4qlwh+VYL6li8hmQEXNn6/imGzRYhF6YGrOSanxgqMDDq9ep+9dTfMmFeLyRYBWVjw9rlV+xBgd
	Xu3kHgsLuVh+m/hlWELrM3E4IxRL2JcuxGkPBf4C8+d9CfYx1o8qj4uPRXofrGqavYnqdKoCrv6
	/LTYW0boTy8uK/7C5QyYmgkKSZqTTPn3bgTbBW1X5MkYsBc40Azn3iMSu/A0Ia4LhTQdCB6sxKe
	khIOaHDyNCAT6V7W2X5Z8lP9A/V99lhLBXJLrreZbeRqUMwU2W/Y+9D6Ge4xKpVyqxG26CuyV+e
	PU
X-Received: by 2002:ac8:7d13:0:b0:51a:8c86:bd4a with SMTP id
 d75a77b69052e-5213cdcd182mr186982861cf.71.1784652109235; Tue, 21 Jul 2026
 09:41:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1784258165.git.tanze@kylinos.cn> <846fec356d359126e64ea64cd5f6e80ce7de4b61.1784258165.git.tanze@kylinos.cn>
 <48439a79-aa0c-4f0d-b079-3b85de715226@samba.org> <5fa257a4-456e-4917-9249-bb3457952335@kylinos.cn>
 <3cef100e-48e6-4fdd-b7e3-a7f2ac2c02ce@samba.org>
In-Reply-To: <3cef100e-48e6-4fdd-b7e3-a7f2ac2c02ce@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 21 Jul 2026 11:41:37 -0500
X-Gm-Features: AUfX_myGyaWEUVeSRSGehAVuTTtF3afboDQIXMA4rXLc51HUq4fdSRQCVDDLsUE
Message-ID: <CAH2r5mubDD4rFZUVTMibVN+up=uNps5HeOv8ehLBXR8GHF3fXA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 6/9] ksmbd: support security.capability EAs
To: Ralph Boehme <slow@samba.org>
Cc: tanze <tanze@kylinos.cn>, sfrench@samba.org, linkinjeon@kernel.org, 
	pc@manguebit.org, sprasad@microsoft.com, tom@talpey.com, 
	senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jeremy Allison <jra@samba.org>, Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2026 at 8:48=E2=80=AFAM Ralph Boehme <slow@samba.org> wrote=
:
>
> On 7/20/26 3:06 PM, tanze wrote:
> > Thanks for your question. When the CIFS client accesses user.EA, the
> > name transmitted over the SMB protocol is simply EA instead of user.EA.
> > ksmbd then prepends user. to convert it back to user.EA. If we pass
> > every attribute name directly to the VFS unmodified, other types of
> > extended attributes will return -EOPNOTSUPP due to missing handlers.
>
> yup, but I guess that's exactly what we want.
>
> If I get that right your proposal is
>
> Client        Network       Server
> -------------------------------------------------
> user.foo      foo           user.foo
> system.bar    system.bar    system.bar
>
> This seems wrong (user namespace not prefixed, others prefixed).

This approach at least doesn't require changing the protocol. It
shouldn't regress existing servers and clients who are sending "foo"
across the network (without the prefix) for the most common EAs


> What we might want to do instead is send the namespace over the wire in
> all cases, but in a separate protocol field (expressed by splitting the
> dotted string into two words seperated by a comma):
>
> Client        Network        Server
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Linux:                       Linux:
> user.foo      user, foo      user.foo
> system.bar    system, bar    system.bar
>
> FreeBSD:                     Linux:
> *1, foo       user, foo      user.foo
> *2, bar       system, bar    system.bar
>
> *1: EXTATTR_NAMESPACE_USER
> *2: EXTATTR_NAMESPACE_SYSTEM
>
> This way we have a clear way how implementations can map their namespace
> to the protocol, and server and client know exactly what to do.
>
> Thoughts?
> -slow
>
> >
> > The current workflow works as follows:
> >
> > Client request                                 --user.EA
> > =E2=86=93 CIFS client strips off the "user."
> > prefix SMB EA layer receives:          --EA
> > =E2=86=93 ksmbd adds back the "user."
> > prefix Server filesystem layer:         --user.EA
> >
> > After ksmbd finishes mapping to the underlying extended attribute name,
> > filesystem compatibility checks, value validation and all related
> > operations should be delegated uniformly to |vfs_setxattr()|. This
> > mapping logic is not meant to duplicate the full set of xattr namespace=
s
> > supported by the VFS. Instead, it filters which SMB extended attribute
> > names get parsed as native Linux xattr names.
> >
> > I will revise the patch to enable native namespace mapping only when
> > both of the following two conditions are satisfied:
> >
> >    1.The request is sent with POSIX extended attribute parameters;
> >    2. The mapped server-side user account is root or an account with
> > administrative privileges.
> >
> > Thanks!
> >
> >
> > =E5=9C=A8 2026/7/20 14:57, Ralph Boehme =E5=86=99=E9=81=93:
> >> On 7/17/26 5:39 AM, Ze Tan wrote:
> >>> +static bool ksmbd_is_posix_ea_name(const char *name, size_t name_len=
)
> >>> +{
> >>> +    if (ksmbd_is_security_capability_ea_name(name, name_len))
> >>> +        return true;
> >>> +
> >>> +    return false;
> >>> +}
> >>> +
> >>> +static int ksmbd_map_ea_name_to_xattr(bool posix_extensions,
> >>> +                      const char *ea_name, size_t ea_name_len,
> >>> +                      char *attr_name)
> >>> +{
> >>> +    if (posix_extensions &&
> >>> +        ksmbd_is_posix_ea_name(ea_name, ea_name_len)) {
> >>
> >> why the check for allowed namespaces via ksmbd_is_posix_ea_name() at
> >> all and not just pass through whatever the client sends us, pass it
> >> down and let the xattr subsystem deal with it?
> >>
> >> Still wrapping my head around this so I might be missing something
> >> obvious. :)
> >>
> >> Thanks!
> >> -slow
>


--=20
Thanks,

Steve
