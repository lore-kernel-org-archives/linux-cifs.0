Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792546751;
	b=oQfbAYL5ZUHg+Rz6ZBtq1UEFOdYtG4HJCNvJN+xPWp0rLVLU99kem25ZEm+N3JHzRJsS
	 KCTtWad/3dmaQUQCvqFt1C00wYR4P8kLzqunf6YlHDMyD8KMEvpFS7OLnisNugHwkMZ+4
	 7Mkgz95kodWgYrN8Gd5j2+9DIdwt6ec/5OLM3tkIS17hXuoy/FJed8G8ZYilHvcxCGxWh
	 eD8EOsssuV0RbaldEJI2nkPIjYc5hN4c2uTYX20vvJlySGcx87ae+W883JHyHWZeTfIwQ
	 PaU82lud1tp1uPaXfTYvcP+0J6xh7IJw1WTJ/Ix1gRwFyu+Y0MQyOtVZb6TkCnGKW3Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792546751;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=WSiF9ZRHxfVHL6+d7Plpelwg9wUAXFen0DqgWRBIyYw=;
	b=A/+FdAc21RYr1oV77V0Qy6rIJnPYTdvcD9TCzMYf8DdzIbjz14op5MT30J/0/OetwdK+
	 SDf5hSrmlrl6yXmGeHrz8haxp7l0hCT6B8q741kY8zneayYFiS//alblB8uXC7IR1ybG+
	 D/17vMMD+WiUkLWDH7SSIzaHmINwLi5kkvuZ7yOPq1fs9qNc6Cj8VIh1AnMApMc4onZyu
	 lsYVl8xsPr52e0EILQZH6E9YVMxRPndpaD2u4kWS1saNOBHN6T38VsZatXT4XaK1QhQ81
	 Qo0ADEnyFgeKuH4cSYTko58piydLjl3YYDUgCi5sHu7MCAiG/NVnw1cyIEmXFBPpHTg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TPtde2Vv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.53
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6383D606A31A
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:39:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6383D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TPtde2Vv
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-97ca72f2cd9so161652241.2
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 18:39:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792546750; cv=none;
        d=google.com; s=arc-20260327;
        b=Uj/LZ1iKRo2ueGH6Bh0x8dhC5Ytn86Pw6QNMvQcpdUMuKzHPLbM0VblOtKFy7AMWbY
         3h1SlWX0UGqb3+nAo5NoK/64D9A7HpQI8HX+BrAyGOOHYBeepKv3kL+S4XIUSxdEF7y7
         MkzX7huciFKpwhrvicn7Cpg6T85E9SjLBx8EVHs4CExDLpImXFWR2DoozQtUFQS9mfzq
         dTBb1wGDI6aoXnShRgpkSvyxRaiQH4yCoWsQN5/LAtqwFKzAC13bdzcpFVqvsNDk5xVN
         jSFHH8YEMu0iFxa0bfckfM9AaOLK13Go6uUk4jEwlwb1IWSfLrCrpzhuTaYA+eTBMjbX
         G6/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WSiF9ZRHxfVHL6+d7Plpelwg9wUAXFen0DqgWRBIyYw=;
        fh=BeDyZzmfJH/08kwnYpjYRPPSj2AqmVUYNRCu5IBQv6M=;
        b=Ns18z/m8PWBa2AEVLAEcs2pX43U9QsCI7Db3U5rYaSmBk54U8c0FkQRrpnAxvhYaX6
         zkpN/QMVFfb1Eu+PKLIOO9C2DKYtJa7nQz9y+JMpYfmUmgl+vSen9IvhbO/oZU8oxTMh
         zfDkt4K+qjMBlUGWS6LxBsKygW5F2c/8xm5sQwLnn2g/r7dt+oMYXWbY+TsHQiwOrJB7
         qvMl3FO/57onsUO8j+f46M2M3wREUcA69WCMrE90Fy4+QFedpky0da+uouL5Y8WMLBDC
         aZGJPdi3CPXNGXqMatmS3s2UFNft3cajsZfiIL2APWwvwX7HEhgvuIlex6PxHaFbNmea
         hfoQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792546750; x=1793151550; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WSiF9ZRHxfVHL6+d7Plpelwg9wUAXFen0DqgWRBIyYw=;
        b=TPtde2VvTD7PwooR60Di3AsbDLb4lg4BC8fHExBeYqjwMCwWp/UlHc2MGatfpxQa2d
         Qs6FHPUlo1hYPlQ5Rvjf9zxohUN6pwipbJ4VtZxf/8i4isVQ8v/4pDE6Pxd0xxdTss2c
         AfyuX0xvSwN4xXLIWJOT67rN7Dn9YJB9uQu4xlJYPMxoUQOg2l0ALtqLKbsF6yxvK+ES
         Jdzi8dvqjc54rxALqxU15l4l65WruUXM+iRUsCQr7+ApIWib79LRRdYq+Z/HMCjHKkju
         bbZigOQGdtb56qq52cQndWxymtNk26j0wKIDp6vFC+RmZ5C3pSnKI/nNTaH8/NTSaPlm
         gLzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792546750; x=1793151550;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WSiF9ZRHxfVHL6+d7Plpelwg9wUAXFen0DqgWRBIyYw=;
        b=tOJnpZzybWdFju8bm2lQR0X5NKEB82bxgQgCDur2lr8WIzBdAGa78LpVi19T0se4mc
         ZhFDXkqM19rM5RKU+EFjl0ktAez/OXX89oFDX36C262K266PC05gu8nvuMz4qa7sia2F
         qkWirbxMQTsZ+nYKr3DPjkjZx64SxyZEYR4Zru/Xd89DFSKovrCt26su1jcV9iv1IpNt
         UWH5j2wTQ12PNkHpkoObx9vqVQVZZt+MKVZz9x5ON5jKKGHZK6IKWCwOwahLtH2YqVi9
         g/2pYD63Im9sq3XjwHtR2CR+lFg8IFQihl1Nseca8b92bHkAJE9lWuqtb1EOpCj+ujhY
         r3EA==
X-Gm-Message-State: AFq9FYL2ljP6H+v0gjNSLXdS15xyrI7q7Njwz+zFL1dzlZriypBwGIHq
	2wpeKGGvl/R3sX45fkfaoC4UzpK3kbjTsX+y0cVVh1dtDS7AsfdDz7QikIT5DnqdTQkn0bOlY4z
	JIiudn3UnsetppbadsnyxtAnFUVFA0SW4d08njQZxoQ==
X-Gm-Gg: AYBFou12aiHOds4AUIiCrAuKmpi3JPdS5jiNi8Lbj3Rt6MpjttYzOfBh+v/Oy+/N0qg
	6mj+YyV8574gcZSdNfVktz5nDg/DFNadQUbpau7LiQHOLPKxGiwU7n+EVTa8kZz3fwCnk5alxrZ
	Nx9QDYR9DvgjNyAcDlytAWxkeSqu+zuAJsAH59tdvL+vnSw1G59ELhp7+bXDdl1DVZygJLYMtlP
	IdOp7y5dYpYDDmkvojvielg5yoGdAzrvDyAHkD2asgj3I/ava2LCYYH0yUSiSx36qdEb3zS5HoI
	dihow8Nj/8WEWEN3DKSjl30Xb1BzX/Fu6Ow31g7BL6PYbLqAY1K8dwWOcjdTPbjve/rOLfyXKLJ
	r2loHzXqdEUz95ALAVPaeLZBZ8G1YRnxSGa2B4RAiPEgxCmiGDNiicjMB1RMHeKiIUNn0Cc1vRQ
	P6rHkyPuHCj2lg
X-Received: by 2002:a05:6102:6898:b0:7bb:c382:2ff4 with SMTP id
 ada2fe7eead31-7cc926d09femr331804137.20.1792546750177; Tue, 20 Oct 2026
 18:39:10 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAO+rqLhpPvY0NLrAnZjFXz0gOXnA6zsXxK8xCgtA42XUkSsAeg@mail.gmail.com>
 <CAKYAXd9Otv_doQutE+gzKJ+Pp9Wi5mjCZpFdfobGJER5=hM4JA@mail.gmail.com>
In-Reply-To: <CAKYAXd9Otv_doQutE+gzKJ+Pp9Wi5mjCZpFdfobGJER5=hM4JA@mail.gmail.com>
From: mixalhs <mike.michalo@gmail.com>
Date: Wed, 21 Oct 2026 03:38:58 +0200
X-Gm-Features: AclHuK9RyFq7y8v2hFeW-t-2ocUmNLTtLtkJyT_1QOMCWXh_VqahldxvXMOXKCU
Message-ID: <CAO+rqLj3Cnhe6b1eF2OQ=ZSw4=WTiMDdfjvFPpMJycY1dqOmGA@mail.gmail.com>
Subject: Re: ksmbd: Kerberos login fails on 7.3 with released ksmbd-tools
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yup, will do.
WIll figure out how to make them both work for the least pain and send
the patch.

Thanks,
Michalis

On Wed, Oct 21, 2026 at 3:31=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Wed, Oct 21, 2026 at 9:39=E2=80=AFAM mixalhs <mike.michalo@gmail.com> =
wrote:
> >
> > Hi Namjae,
> >
> > Kerberos session setup fails on 7.3 with the latest released
> > ksmbd-tools (3.5.7), and ksmbd-tools master fails the same way on 7.2.
> >
> > struct ksmbd_spnego_authen_response gained a __u64 session_expiry field
> > before payload[] in 7.3 (commit a47634cd729b, not in 7.2), making it
> > 168 bytes; in ksmbd-tools 3.5.7 it is still 156 bytes.  ksmbd-tools
> > only gained the field on master on Oct 18 (4c0ca83), after 3.5.7, and
> > always sends the new layout.  ipc_validate_msg() requires
> > msg_sz =3D=3D sizeof(*resp) + session_key_len + spnego_blob_len, so any
> > mismatch is dropped.
> >
> > Tested with a local MIT KDC and smbclient --use-kerberos=3Drequired, sa=
me
> > realm and user throughout:
> >
> >                     ksmbd-tools 3.5.7    ksmbd-tools master
> >   7.2 (mainline)    login OK             NT_STATUS_INVALID_PARAMETER
> >   7.3 (ksmbd-next)  NT_STATUS_LOGON_FAILURE   login OK
> >
> > In both failing cases ksmbd.mountd logs "Authenticated user `testuser'"
> > and the kernel logs "SPNEGO_AUTHEN_REQUEST failure".  NTLM logins are
> > not affected.
> >
> > From the code, 6.6.y, 6.12.y and 6.18.y also require the old 156-byte
> > size, so a ksmbd-tools release built from master would break Kerberos
> > there as well (only 7.2 tested).
> >
> > Would you like the kernel to accept the old response size again, with
> > ksmbd-tools sending the new layout only to kernels that support it?
> > I'd be more tan happy to write and test the kernel side. :)
> Thanks for the report and testing. The approach sounds good. Please
> send the patch for this issue. Could you also update ksmbd-tools ?
> Thanks!
