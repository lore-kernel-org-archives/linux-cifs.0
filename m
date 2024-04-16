Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C673436E
	for <linux-cifs@vger.kernel.org>; Tue, 16 Apr 2024 00:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227334; cv=none; b=ZrnEszUghgd8R6w60RebQQl9nuaCILjFtpOwhPZaHxFONpVYqHEjsuUSn3FzuP6lWArMXIyCcpkU8NslkPTBKWHXvN8WGGiXyBFf473/dPd+LnOUvyu7l74JUUorz+t8OiQXWEnOvWfcGvZ+ZBVIXwfEIGh75yXynYc2wZPAppI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227334; c=relaxed/simple;
	bh=R2at1VyBpUTFVHVAwQTUAeEMu9H4iwF5swJRAN+QyMg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GLG7r7VB+dgaJbDM3LIkkZzhZNqiNfHVSgKUMK6id3CpUaEg6GjWAqN+NCYGrlNTUiu8o0F216H0z3xl/7dNkuUbdEBlSootnXNbnnth21P8CxzkU5y0mxuoukJTOzEewlLR9jdB2Cg8LllO2siEVmhxDXg14z+pcsyL1AlEGAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eJ0O+gNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eJ0O+gNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F76C32783
	for <linux-cifs@vger.kernel.org>; Tue, 16 Apr 2024 00:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227334;
	bh=R2at1VyBpUTFVHVAwQTUAeEMu9H4iwF5swJRAN+QyMg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eJ0O+gNYDB9eaf2vvRtbzxodo6u+8KwG5MiL/kSksfWPtUSYJmo56oEFxJJyTuOzh
	 UtZ5RErnZ43fxLxHsQnn+PYNgl5O4Rn538mpkqw0ptefzsj3kzGgGmWMZbsxBQTKkK
	 JR8QbV+/jpwuI+ZOaGv6tHX4o1TiQ9MpfwVctAk2GX8fbNRLPJhiIWGrsb2gAo4pd8
	 XuLSBmKGS1JsOF5oeIYBXJUbW/vfSxVxQaWna4Q/Fknyg8WlUBV4bb7q7KvgILnwr0
	 kAtNS6ZWsa/eyXAwaJ4XK35ntBZgQAqbTIbeff4uv9l3wTAkwtdDLN3ewu9JA0VCgo
	 XslYHAPvErPoA==
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-22ed075a629so2325693fac.3
        for <linux-cifs@vger.kernel.org>; Mon, 15 Apr 2024 17:28:54 -0700 (PDT)
X-Gm-Message-State: AOJu0YyxUbJULZN1xtwAMk+/BZ201iicx2RZyg9hkm2fKFGyNcmOaJGc
	v96RvcQu4srvAoFIwBv5mYmVDiFyv8uDurZZ+GNMV6yhX8h4cv16eei0baIZkn3M4JxxlSUvSwj
	EXghgC9gV56gnHF2EcSyjCJXgONw=
X-Google-Smtp-Source: AGHT+IGHbmG7IqkstwyLgOdAb3XeBSVIgmOiLeUy6inVpnWQ5YydAYhBsfvKhsavzx6ZVXCcl5kFnOPpACRl9cwYQ8c=
X-Received: by 2002:a05:6870:a195:b0:229:ec87:cc29 with SMTP id
 a21-20020a056870a19500b00229ec87cc29mr15860308oaf.49.1713227333970; Mon, 15
 Apr 2024 17:28:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5ms7EWvNFVJ7_D7QXWOyj+oViKDJD2EuoY3n=w1c5wLTKQ@mail.gmail.com>
In-Reply-To: <CAH2r5ms7EWvNFVJ7_D7QXWOyj+oViKDJD2EuoY3n=w1c5wLTKQ@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 16 Apr 2024 09:28:42 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-gN2uQ4B9UvUdvCM_A+qnrMuCHGQO7irfFozbjKBxpZA@mail.gmail.com>
Message-ID: <CAKYAXd-gN2uQ4B9UvUdvCM_A+qnrMuCHGQO7irfFozbjKBxpZA@mail.gmail.com>
Subject: Re: current ksmbd
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 4=EC=9B=94 16=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 1:54, S=
teve French <smfrench@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> We are up to 221 fstests run vs. ksmbd, and buildbot tests pass with
> current ksmb (this is with 6.9-rc4):
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/=
10/builds/52
>
> There are lots of minor features (and some fixes) that should be able
> to be doable to increase this number even more.
>
> Note that Samba passes some tests that are skipped when run to ksmbd
> that should be investigated:
> e.g. generic/022 ("xfs_io fcollapse") and generic/351 ("xfs_io
> fsinsert") and also generic/021 and 031 ("fallocate: Invalid argument)
> and generic/525 ("pread: invalid argument") and generic/568 (which
> looks like fallocate bug)
Okay. I will check it after sambaXP.

Thanks for your check!
>
> Samba fails two tests that pass to ksmbd generic/286 ("create sparse
> file failed") and generic/591 (splice test) that also should be
> investigated.
>
>
> --
> Thanks,
>
> Steve
