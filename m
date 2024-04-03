Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14A8146A91
	for <linux-cifs@vger.kernel.org>; Wed,  3 Apr 2024 15:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712156586; cv=none; b=ZzGUveQl9DTm9JPKfMsQOKD5wSPiCibbp/3tNLNC7mpmZUIx/cNh7g7k1xfM8YW+KNUXFPxJOQA8HUGKPoEdOD4wYdFEtUiBXhXk6To7qIMCJiuxSPTEykX1p5BChyEhC9lj2urew0YMa5NFU9xqr7J1RvBSZ570ot+WMWkCYW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712156586; c=relaxed/simple;
	bh=a7mNqaALJyPq3YdKVXicKQwMMqVLcFYOt4aFmY79KZk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WHw9ZFAJNp45wf0AJnDOaL8Sor+eCcT/9CYRUwI8rDSSvV8PnG3AsT7y+X4CWkyQSoaFivKnWacNuJZxtbV2sQXETqeN/GEixieGI5CRPC4VgyocsKS/ZdPp6H2gX0mDLeeHmObuF/x5uKFBdHqn3BMey/RCRWTKLiNtN/4Zso4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=GMcWIfYr; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="GMcWIfYr"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-db4364ecd6aso6218743276.2
        for <linux-cifs@vger.kernel.org>; Wed, 03 Apr 2024 08:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1712156584; x=1712761384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oB/QZCIJNsw+4xmf5zobnrRWsDWTsJXOON4ReH8dtVg=;
        b=GMcWIfYrscgAst0DD1198oNQcsFMfoJUezrKRuFuSkBeRfUlhe12r/FugLlhXrhjeu
         kVcDqPEqIJjtPihBsbmlxgtpqxFdeAS8D2EFqLTdvi+V/MTKMlJFWDTV+NxXb3Urstno
         uHlDgkqMs9Py7j+iWmqbI7uTWyplzVeREnbJSH/hzqEUBusyomTt1uikCuT7VIIC2d1J
         ZCOhc352kmpbiZNf+/IPd5HgyMPOcDEEBP5Ki7v8Y8I4K8j8jgs25mAVXv6c34bMHG31
         D8MOcddtf/gRfQB4MxTLnLUarjmPwHenM+wRP/AlZk1tMTTjjU6rrOrdnN3EQr7ZMfpD
         Y9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712156584; x=1712761384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oB/QZCIJNsw+4xmf5zobnrRWsDWTsJXOON4ReH8dtVg=;
        b=i5s/lupyIobbAWu6bwNDgPn/3tvcErPXZeYAicK/I8VxuY0jdd+GeKkPlOXaDOdVO5
         WwDLuWFLGFhQiCA8JvJ77hNV7A4XvDa7xH1YlD/XlQhdZt5WHoMuq77rZgtd33EM0LpB
         q1HHfNVYSSOGq69LPix9jO38NYXLPPDYbt74ldWqvw/NPBpAIK9VNbIeBtkkL8D7ONrt
         wJ5vBTt8Qxxfj/PnRKkZJ+2FavaxR4y5GU3NMe1eZafs0pthXqIZRWX8vGr+DZgLURkZ
         msTS7gY7CnPo2huvoEWZdI3a3Nan38fdyfqNY9RMAlbGNJ1o9R3yhC4OvzXeRb0piaTa
         XDhg==
X-Forwarded-Encrypted: i=1; AJvYcCXSw0dd0FQPW4KSp4BauUFoy3BdJkUPk20NJM3nkVerNivKH6U7pfe71Sp6iYsJEjfTJ2mDiTeRWaHqYH5AdJaNTWTL5vuFn69a9Q==
X-Gm-Message-State: AOJu0YyRj2bPyZ50UQoBc02uFJPJ46iFrbVHdP+KOFzBYyRJXcXC3qe8
	4uRn7f6c+75+bfLajrsGd+tKlfLV6nQwm2PkhcaktruCQBhZGUdIXYljsfklL+96g4WPwAOR1W6
	t6V9Go8yzUROuzvOma0fFVssNmzHYU0Un/vj9
X-Google-Smtp-Source: AGHT+IFT4d6bpRvDAVa07rux2sG1s5ZKLWz6hKyaoKXTEtvPIEVh93oEV7NIJATmjfw8W0YvP4+xkMNiV5GnCLoztN0=
X-Received: by 2002:a05:6902:2b87:b0:dca:c369:fac8 with SMTP id
 fj7-20020a0569022b8700b00dcac369fac8mr3635102ybb.1.1712156583732; Wed, 03 Apr
 2024 08:03:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403090749.2929667-1-roberto.sassu@huaweicloud.com> <6d3b9d8a5f5a2ca010a5a701d7826e47912fec89.camel@linux.ibm.com>
In-Reply-To: <6d3b9d8a5f5a2ca010a5a701d7826e47912fec89.camel@linux.ibm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 3 Apr 2024 11:02:53 -0400
Message-ID: <CAHC9VhQjcvRBo30Y346p5Tbo3pspxnnmrLj6nvv1g=e_52SQUg@mail.gmail.com>
Subject: Re: [RESEND][PATCH v3] security: Place security_path_post_mknod()
 where the original IMA call was
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huaweicloud.com>, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, jack@suse.cz, jmorris@namei.org, serge@hallyn.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-integrity@vger.kernel.org, pc@manguebit.com, 
	torvalds@linux-foundation.org, Roberto Sassu <roberto.sassu@huawei.com>, 
	Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 3, 2024 at 9:11=E2=80=AFAM Mimi Zohar <zohar@linux.ibm.com> wro=
te:
> On Wed, 2024-04-03 at 11:07 +0200, Roberto Sassu wrote:
> >
> > However, as reported by VFS maintainers, successful mknod operation doe=
s
> > not mean that the dentry always has an inode attached to it (for exampl=
e,
> > not for FIFOs on a SAMBA mount).
> >
> > If that condition happens, the kernel crashes when
> > security_path_post_mknod() attempts to verify if the inode associated t=
o
> > the dentry is private.
>
> This is an example of why making the LSM hook more generic than needed di=
dn't
> work.  Based on the discussion there is no valid reason for making the ho=
ok more
> generic.

I agree, I think we all do, but I don't think we want to get into
process discussions in the patch description.  The description
explains the original motivation for the buggy commit, the problem it
caused, and the solution; that's enough IMHO.

--=20
paul-moore.com
