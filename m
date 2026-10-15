Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71384C151E
	for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2026 13:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069859; cv=none; b=K85OlNiXMPkmFpd/p1vZJdjoI23Ka+ZUOnx9ZjYKPnr1nzV9LDuuCtO39OZ1qYmVTzI+mpX6hef863BUnHv7Pks8g+8Yf1GPN1E1YVPPfzAJ2TJx7tQoej0R0VKXJQUAGtwZblHQzG5afOC2UB+CspjgL4cF+AqOAFnPd2Wjn8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069859; c=relaxed/simple;
	bh=BNi8h7jubQ/bifQm6cdRhh2Zj6PUlorLVbNYTPdW4FU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IgUK7sDUU3FN6IvL5uP8clegbCwmBgHQy8bHRx5pOIO3Mi2XWRQUijEWYEIIYYiHrp5VGtu+Igy2BjWvyqevc9nl6qKqIU72i3Oxo+ky0cc8zF9ibti3CWhAkm3+bXF88Hvlyvv7UxDVA0bsvP2QKQs2FIEWN2mrsF8ohDCG6+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ncmnzvOr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ncmnzvOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF7F1F000C4
	for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2026 13:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792069858;
	bh=BNi8h7jubQ/bifQm6cdRhh2Zj6PUlorLVbNYTPdW4FU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ncmnzvOrzhvy0K4UCXZJfxc7kVmL2oHJix6MJRPCPyqcKHb4nkcVqz3qMU508gw/I
	 QZt0LsZZALS+eR4uiL6V6tdsVNIkd0PuZpCYhiJfjdacQj7TkUkR8Lhf7TQiBjmn8+
	 sumzi7+q93j7fnQE+oNg4RnJIwXyUpsDlkm37roYsqUCxzJjj78erFNGSmJ3bsSg1f
	 oDls5Ebs9bWPGSzUMGl9mISh2gSFkvstn4sSwvZfBxghLPzhfCfFpF3J7sBzEBBl3A
	 4RLKM5+qV6HbIEEq8oj8T31Ghgg9wM2Fzfp5R0gkyDIFFlo+HxTszNHVmYTdeNoRgP
	 LmAAr/bDlt9lA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2e5e090746so513825966b.0
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2026 06:10:58 -0700 (PDT)
X-Gm-Message-State: AFq9FYI22MyossMw3wgF99rTqcAOC6xGwltU6yD83AtfqklZ7FylRxwQ
	nhdhqSN16Efs8F6ITurWNUS2JPbP0jrD7jf7Y8xj9ux1v7wB0aVAjuLs9kEEWuPi4+fD0tgTXwt
	THEuvbc/4duJ2Y+LAQWzHPvLoEexvLeg=
X-Received: by 2002:a17:907:72cc:b0:c2e:3ed7:7d94 with SMTP id
 a640c23a62f3a-c31aa0d364emr1836713766b.37.1792069857338; Thu, 15 Oct 2026
 06:10:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANTrAmy-Py3s30cCJC8Z+fG-Kk0JY+ihHrawGMMJQsOJCoqn-A@mail.gmail.com>
In-Reply-To: <CANTrAmy-Py3s30cCJC8Z+fG-Kk0JY+ihHrawGMMJQsOJCoqn-A@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 15 Oct 2026 22:10:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8oh3xNWV+nnTmgudZeVTYzKCUQS9-CcDsOXXS6MDpLaw@mail.gmail.com>
X-Gm-Features: AclHuK8Vw4049E51lszOaD_u1tlvQSEZ9n58CetjaHY3ujm-HvWdCIVePhFpFrA
Message-ID: <CAKYAXd8oh3xNWV+nnTmgudZeVTYzKCUQS9-CcDsOXXS6MDpLaw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: reject FSCTL_SET_ZERO_DATA on a directory handle
To: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>
Cc: linux-cifs@vger.kernel.org, Stefan Metzmacher <metze@samba.org>, sfrench@samba.org, 
	Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 8:22=E2=80=AFPM =EC=9D=B4=EC=84=B1=ED=98=84 <ihopen=
re@gmail.com> wrote:
>
> Hello Namjae and linux-cifs,
>
> I found a remaining way to reach __kernel_write_iter() on a directory fil=
e
> object in ksmbd, through the FSCTL_SET_ZERO_DATA path. An authenticated
> client with a writable tree can open a directory with FILE_WRITE_DATA and
> issue FSCTL_SET_ZERO_DATA on that handle. ksmbd_vfs_zero_data() then call=
s
> kernel_write() on the directory's struct file, which has no FMODE_WRITE, =
so
> __kernel_write_iter() trips WARN_ON_ONCE(!(file->f_mode & FMODE_WRITE)) a=
nd
> panics on a panic_on_warn kernel.
Please send the patch to the list and me.
Thanks.
