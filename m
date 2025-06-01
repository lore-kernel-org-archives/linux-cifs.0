Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD7A2DCC1E
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 14:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748788271; cv=none; b=j8sRH2xiSHL2SvJnK6BQzRkKCzwfTPSBPdiuZqjmA34EgjD/qD7LWU/am5yLvUwjB8EyDAcftYQrM+i3ms5D/y7XJMVWihPRDrRVK0S4QHcMQPWFVfTVZvh011NP+RLYy5Wpl0jNuj615ey2SKsRrjqfuBl605HYLtE1fleFx08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748788271; c=relaxed/simple;
	bh=41RDBcCdaeVsf7h3L7tNDuc7CPEzoPSLdIsM/LTqlWE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PMi1zpaNB4tZo1U1HefF9TfamM+W14UdJRksdJcG3wnABxXVucLLXWQ08VwYJE9pr9z9wjOKjljQ3rGuhUjwh8uuFfI7cz2cqdz/V8hzZf5CKPKerej2dJ5EImXV3hXsZD+WfjbP5rOarYD2N6jiX4EbcDQOa9c8r8g5LpeC//g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iF3zUNRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iF3zUNRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D3CC4CEF2
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 14:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748788270;
	bh=41RDBcCdaeVsf7h3L7tNDuc7CPEzoPSLdIsM/LTqlWE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iF3zUNROECR+epL+12G+fYPofBXeaqRqTf49UZQh54xtyxgpZxIPlJos1FsGRim6c
	 p62GcOQDaxuJipcGRbRVq1L1HA5VQcTJVkoZzpYJWo+h4Pge9TPrCv96Lz8EsybnRN
	 i02Oni4OcWDSzBgJQS84BTS3X8k/GgWm0lcn6yyjJJC1AwySlWXVFJ0xlXCpL4mME+
	 POl7x9PUFMM53qqbs8gKFyd+6zSlkKRxU967MF1H427Chuum7vkDlYQJF4UXd3KfGk
	 mizPo0CAFPgb/YiZPErzn2Ym6x5ZPY0CVIivmVrxnCG4W9AXDhrBl5OfN9a8ry6FpI
	 vND3IRDHg7bQw==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6055f106811so4563293a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 01 Jun 2025 07:31:10 -0700 (PDT)
X-Gm-Message-State: AOJu0YyhcNRfpKXR+Oo6XBfn1x4I2YS1lwpKpcw2yN+ijFLaQ2koFWlv
	cIlEKKVKSgPsMFj6eM8wGnE2oKXvBj/2aX54JuSVuUUIP1ybi5EAuGb3rMKm71WgmlQDXbOwvBM
	N69fKh3175wKtkZDcRUNXkwNNxBdIglg=
X-Google-Smtp-Source: AGHT+IEVs1K5d4tPyrZIgvkgNJcTTljNQWLNR+lTQ2cf2aU0ejl8OSMREcMERjTi0lkLpP+mFlUVcl4xAtPqAU/HDBE=
X-Received: by 2002:a17:907:7290:b0:adb:156e:990b with SMTP id
 a640c23a62f3a-adb494c51a3mr471115366b.30.1748788269472; Sun, 01 Jun 2025
 07:31:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
 <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
 <CAH2r5ms-v=UwFzXZpZ-5KBgiRPkvSqQyJnLBhxP5YaAuqMAG5A@mail.gmail.com>
 <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com>
 <4fb764ff-f229-4827-9f45-0f54ed3b9771@samba.org> <CAKYAXd8FJcfFpGBkevgZaymcHiicJgs-time4r7fbD6n2hBg7w@mail.gmail.com>
 <CAKYAXd9BPqg=0QKrpsOHaVDQkM8=Q6fragLmpTPve=pJdNjovw@rx2.rx-server.de> <4195bb677b33d680e77549890a4f4dd3b474ceaf.camel@rx2.rx-server.de>
In-Reply-To: <4195bb677b33d680e77549890a4f4dd3b474ceaf.camel@rx2.rx-server.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 1 Jun 2025 23:30:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9OQW9oOfjUDWSGmh+b7QtHSc7M=rHhCW6QEsFpEkVFVw@mail.gmail.com>
X-Gm-Features: AX0GCFuW2pFFS00HzfW9XuPAGT7M1DQ1nHX-LGjkUMzaxLkHtw--XWc7Xw6WI1c
Message-ID: <CAKYAXd9OQW9oOfjUDWSGmh+b7QtHSc7M=rHhCW6QEsFpEkVFVw@mail.gmail.com>
Subject: Re: ksmbd and special characters in file names
To: Philipp Kerling <pkerling@casix.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	=?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2025 at 6:47=E2=80=AFPM Philipp Kerling <pkerling@casix.org=
> wrote:
>
> Hi!
>
> 2025-05-27 (=E7=81=AB) =E3=81=AE 11:57 +0900 =E3=81=AB Namjae Jeon =E3=81=
=95=E3=82=93=E3=81=AF=E6=9B=B8=E3=81=8D=E3=81=BE=E3=81=97=E3=81=9F:
> > On Mon, May 26, 2025 at 11:24=E2=80=AFPM Namjae Jeon <linkinjeon@kernel=
.org>
> > wrote:
> > >
> > > > It's been part of the spec since the beginning. You can find it
> > > > here:
> > > Right, I found it.
> > > Thanks for your reply.
> > > >
> > > > https://gitlab.com/samba-team/smb3-posix-spec/-/releases
> > > >
> > > > POSIX-SMB2 2.2.13.2.16 SMB2_CREATE_POSIX_CONTEXT
> > Philipp,
> >
> > Can you confirm if your issue is fixed with the attached patch ?
> >
> > Thanks!
> I can confirm the following behavior after applying the patch:
>  * Path with "&" is not accessible with mount.smb3 and default options
>  * Path with "&" is not accessible with mount.smb3 and "nomapposix"
>    option
>  * Path with "&" is not accessible with mount.smb3 and "unix" option
>  * Path with "&" is accessible with mount.smb3 and "unix,nomapposix"
>    options
> Perhaps "nomapposix" should be the default for the client when "unix"
> is enabled? Tough call though, might break some backwards
> compatibility.
I agree that "nomapposix" should be enabled along with "unix" option.
You can try to submit a patch for this.
>
> Furthermore, in the last case in which the file is accessible, I can
> only access the file as root. This is because enabling the "unix" mount
> option leads to the origin UIDs and GIDs being taken over from the
> host, which do not correspond to anything on my client. I usually set
> "forceuid,forcegid,uid=3D...,gid=3D...,file_mode=3D0640,dir_mode=3D0750" =
on the
> mount but, for whatever reason (might be intentional? might not be?),
> these options do nothing at all when combined with "unix". I can sort
> of get around this by setting "noperm", but it does seem odd that I
> would have to disable any and all permission checking just to get
> special characters in my paths working.
Please tell me the steps to reproduce it.

Thanks!
>
> Thanks,
> Philipp
