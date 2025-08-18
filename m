Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0EC212D83
	for <linux-cifs@vger.kernel.org>; Mon, 18 Aug 2025 21:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755552969; cv=none; b=iHGQDW+AM9pjCu72q0cX0fIAQ2bbEf4FAnqrXSMR/4XoW1v4GCXaDg2/vxHtOfclxLY2HpGcPVRl9mXuRSDEMWWs+HvaEncyE3j3N/H8ditHjU0PurzfbquFDHm8SSkA6FEI52cwqmFMpbxOVuhUOcXPzVuU+HihCqzBvxoBvwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755552969; c=relaxed/simple;
	bh=dWQRQ4G5D1AgRped0ijjh0w8xHjtRo/0tl+3G4fKW+U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WcLttDhDXy801Jy8XwEKs3HZ2t5854YbQ66RRWg+nmZbsuIz0Oj0DKFzZxZQ0TnlxCFY6Cq9s+UnqobvlK1JnOrmkCQ91Ju8wBfnElDHmfLulofB3QObU8F9YQuqIavmza4g7S1LQkIUJPvP7AV63+uCTnP8RToArkyxYvH3pEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CCaTI3Zx; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCaTI3Zx"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7e87031323aso488264485a.0
        for <linux-cifs@vger.kernel.org>; Mon, 18 Aug 2025 14:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755552966; x=1756157766; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G5mC/vEOmShR27O6wi76fydoZyaSh4/O0s70DRwKZfc=;
        b=CCaTI3ZxpLY5PmgfAQ9pAM14/F+nOfira9e1nKy04Rw3lNcPOEYfUsT2DSpxBlFuP6
         UNQrHRMwngFteUc8GKOiRZMvLfmOiham9r4MWe2ogXJ4fz2rP1L0NCyCTD6eliDgKXGG
         ShcF9nlFHTG8elyWElqPMQBX0Q/z1OG4yn0CJHyG7FEAV8aCxpJ+g0wRTuXHEpXlCBk9
         PULbcAGBv+LPl5+YkJZwAVp51xL0biYhVSPmc0WGdIU0P6DZtAx5HaydK52oyNTPshQr
         KUIOaVlf8lvhCTemKwVMq/afMpgGxoeF7ApTgo2grVL8QIAQFMvtn0drBtyn+PuZlfqq
         JzYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755552966; x=1756157766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G5mC/vEOmShR27O6wi76fydoZyaSh4/O0s70DRwKZfc=;
        b=HtFkKhsb8qFkpAyvceXp7N4eoh4ik2+dREUiM0jnPwqfY6tCcbIm86Lzld+HwO9/zE
         uhmHMx2+pA9GLNMfA9O9z2M9Inmul6CZOwwu3Uld5FU7fJEjFQw9DWkDAMJ7cMr8rFIW
         MExf1mdWDLJVWfrsH0crQsuKj+9nZQRBAoYh792iUwbUPbmnYsxO02r9PaBrkuRMtgGO
         ImGAtJRKH+LyJwhpk22XbCeDDvG512mS+vCkei4dmyqDhasQoUAKKl25gSO1wy4qkDl+
         ap01f6cAeE+yDIyapXG3j31ExFIV7o+6yLRGwYAezU83frVg21gEMwlaIdpBVS0pLQZJ
         +K9A==
X-Forwarded-Encrypted: i=1; AJvYcCVuCI96vVlviM0g5zLGZuyPLKvGqE8onc3kkpEIksxUcGdewRNDAWZMfRGlZ/bHYVDDb0/5PXQD7pZJ@vger.kernel.org
X-Gm-Message-State: AOJu0YySktUnYaQUOJRXLso7Qde2x5MA8QfrTs5yczZSpp+UzJy4gg7R
	qAzzlZ/CgdY4lQ8g0zUwE1Vpsaim6BNNHEQ2TtuQI/xI+94qUcsy2hrw7MN1HNKEjsC9MfbYIec
	/xqGhp5m7E62jf3vWTq6dOhDsdPBkPz8=
X-Gm-Gg: ASbGncuwQd/sToV2XVMaoYBeUmDuwqzMwnro+bmrJ3w7F744VlRDDhXdmOCOs6TBHhd
	Vrsq/LBry2KPwKEvAZi57T1EPnu6g098Uf6fThOL+I//JyqHXL7i63yMg8gopQ2QuLXw0QxeS3W
	zEyXMoCUghKxAusyAHlrG1WuZD5puysNYvRuju+L+IR31xiaqIJK/b4mhj3fiJ5kt6ZrkWFXltJ
	tyYqsX9s3bpu4OKoVSOKu8CeCkdEAlTmAFUJA+b/mHPLXERn1A=
X-Google-Smtp-Source: AGHT+IFCD3fWR6YXHpR5xA57y6bIdD9fhdz9RgOmb8Z6skSFYDLwFSNjuIkAJ87UjM5aKAWJSNhWFgEp2B4u2BOAPCw=
X-Received: by 2002:a05:620a:4611:b0:7e3:495a:2982 with SMTP id
 af79cd13be357-7e9f3203f7fmr63800285a.0.1755552966242; Mon, 18 Aug 2025
 14:36:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <05881546-b505-4c0e-8d95-ee1c24f01fc8@samba.org>
In-Reply-To: <05881546-b505-4c0e-8d95-ee1c24f01fc8@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 18 Aug 2025 16:35:54 -0500
X-Gm-Features: Ac12FXzK3WWfQv2gjrTiA0fcG00Vz4ufIVuhRMAmLI28fp22yC7mEdm-rlI9xWE
Message-ID: <CAH2r5mtkB_Tbb4Pzba_msMfPs-Tz3ff4udKBRiR1d=f0TTC-PQ@mail.gmail.com>
Subject: Re: Common smbdirect debugging/loggin/tracing...
To: Stefan Metzmacher <metze@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>, 
	Long Li <longli@microsoft.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	Samba Technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 3:31=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi,
>
> after the move to common smbdirect structures I'm wondering
> what I have to keep related to the debug counters on the
> client side, e.g.
>
>          /* for debug purposes */
>          unsigned int count_get_receive_buffer;
>          unsigned int count_put_receive_buffer;
>          unsigned int count_reassembly_queue;
>          unsigned int count_enqueue_reassembly_queue;
>          unsigned int count_dequeue_reassembly_queue;
>          unsigned int count_send_empty;
>
> And the their use (and more) in cifs_debug_data_proc_show().
>
> I'd suggest to remove this stuff and later add some tracepoints
> instead or if really needed some stuff under smbdirect_socket.statistics.

I lean toward keeping the smbdirect debug info that is already shown
in /proc/fs/cifs/DebugData,
it doesn't have a performance penalty, and "if it was useful before"
for debugging
to display smbdirect related info for a mount, it is it is likely
going to be useful in the future.
I don't mind changing this in the future, after there is more
information about what
additional smbdirect info would be most useful to add to display for
the client mounts.

> Also do we need to keep the log_rdma() based message in the client
> and the ksmbd_debug(RDMA) messages on the server as is?
> I guess we want some basic logging for the connect/disconnect handling
> and the rest should be tracepoints...

I am not a big fan of old style (static) kernel debug messages but it
is probably fine to keep
the existing ones (unless code changes that would remove a few of them,
that is fine), but typically the only ones that are 'required' are
cases that are always on
logged (for connection errors e.g. that the user needs the additional
info in dmesg to understand).

And yes, the majority of logging should be eBPF friendly dynamic
tracepoints (Meetakshi may
have some ideas on tooling that she can extend to make them easier to colle=
ct)

> Is something like logging module parameters and output
> written in stone or can this be changed to be more useful
> and in common between kernel client, kernel server and later
> userspace?

They can be changed (logging module parms) in this example, but I
wouldn't be in a huge
hurry to ditch it, since there are VERY likely things that are client
specific logging
for smbdirect that we would not want to to turn on for both client and serv=
er.



--=20
Thanks,

Steve
