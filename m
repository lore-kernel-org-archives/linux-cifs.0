Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795761091;
	b=Wz624mM6ka7VQzpAlcNrvCWswO9wl6t3wqJvVLsEtRrMVTeZXG1od+Jc0EPzkAYuP40R
	 ObgQ18fvA+BMX9BF2ujx78mjusRrN4EczQn89ULMNbkcsanZtil6WcAVWkVMZGMvCbvZc
	 P/Y60jcXddJqIqsZBOipa4A96v4JROIVAPfp36Uo4A/8z2/9HOnaomNwveIriypOF70ws
	 XuFFsjDjBBzg3q8FDDyN6LaUnhzOII0MwLtvopMB0E3FjbW9uV9n9/4TQHWZtRkcTTL+Y
	 QkxIHB5W2YWUh1HhOvYTkzDZNAv5Lp7Pu6Vu8jo6kE5w3X8/BSoRHjd1BK5Uin2SdvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795761091;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=BeRsL6AzbZ36nw/0drQ4YnJsfDPR0a/ZUPY7k/qg89E=;
	b=GUvLb+8kWH5MM0oLOTTcsiRg/NdFXA7oDcnT362bvIAocK5MyLLW+Yox412lqA2hVqUz
	 ZoSHjqp/w4f8f3Ek5aAobsH1rmXfKvSdq7v1dGsqKmGxfj57jqoUbS54atx43H6ZpF5LG
	 gO3/+BMshdanVUCLMH5O+EPJoHQC7uBj8FaI524kqxHaqydUTsfq5xLLNHkK6qvzyPi5Z
	 zr3GMoE0ajV2AJedD9WFCQQv12DXmPvGJ7gvxefjXybfHAy566qRvJNQlnEXiX5Cp2zkk
	 g+mRLKuPm3B8I8HCmNChZXws/4C5PEELV6YzGuP0XIsFGcL9OVbCP/0MTa9HDn5a+Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uyh1xXMc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D26606A321
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 06:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uyh1xXMc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5885D1F00893
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 06:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795761090;
	bh=BeRsL6AzbZ36nw/0drQ4YnJsfDPR0a/ZUPY7k/qg89E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Uyh1xXMc4tvO4uJvheK7e8oyPbdceXFlKWU33lnj9cZaygBOc79itESkYNAcq6SVL
	 52zqFZr4qbItylRre3fr40YcvihZWQZbE1W67WQxjqqfwnn/TBkH5UJPZOeJ3tERL8
	 P3XaEHgrbLWVP37XgXVRyPcNX9lu4rkE8KsbT8+d6WHNge9m/0J0lWvyUEMze1aywz
	 g6/BFYXgAs6F67mHXFOwDfxptV4SCtHSz4PzBIbsJBmjoljCXMBHJi2AqHWFgmvOvX
	 05+pbWPT25xgW8fURewi6gqmSMv7AoRcJe0wwEGxfGJYPg/Wa2tiwrPagefbkbfTsA
	 w7vgGYaRF4DUQ==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b87a1a2babso15196042a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 22:31:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFKzVi6cJ2VdVb/LZAZu4s2273AN1Qp2E0fKSYOnlvUkjk+p631QG8xb52WxbYIrGrlGEOGwIGzszgI@vger.kernel.org
X-Gm-Message-State: APuU4Z+OJNyuRkpk0wCbbEeH9zGSiu0qblFaBjvrTjxNuMFDcxlMqIE/
	yoayxP6q1N400sdbRAbVCKwZrbovXYVSKVMsxOVPomRfw+d8LHIvFVmuLQHmK5q3iEYD8hIEYTV
	q9okG5MBjRMWrSEVD1DG9Cdi+D9TNTLI=
X-Received: by 2002:a17:906:f47:b0:c3e:2224:1b86 with SMTP id
 a640c23a62f3a-c513a3a5357mr1479793166b.2.1795761089023; Thu, 26 Nov 2026
 22:31:29 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119103805.29514-1-research@rootsys.at> <cover.1795701726.git.research@rootsys.at>
 <f2f8d65edd82bfe84b80335ef0992e7726af3d7b.1795701726.git.research@rootsys.at>
In-Reply-To: <f2f8d65edd82bfe84b80335ef0992e7726af3d7b.1795701726.git.research@rootsys.at>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 27 Nov 2026 15:31:17 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_1Xoywi4+8sovA27_aTqzQtVYv7P0UzyX9cM6mniO1eA@mail.gmail.com>
X-Gm-Features: Aa3M54oywPNqAbJJIbTDxAmjNd6K5FPMP3khxJFVtVXEhI7Kj3txhpNP71kFt5s
Message-ID: <CAKYAXd_1Xoywi4+8sovA27_aTqzQtVYv7P0UzyX9cM6mniO1eA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ksmbd: reject plaintext requests on sessions that
 must be encrypted
To: RootSys GmbH Research <team@rootsys.at>
Cc: Michail Andreas Michalopoulos <mike.michalo@gmail.com>, Ian Bridges <icb@fastmail.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	RootSys GmbH Research <research@rootsys.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> @@ -371,7 +387,22 @@ static void __handle_ksmbd_work(struct ksmbd_work *w=
ork,
>                                                 rsp_hdr->Flags |=3D SMB2_=
FLAGS_SIGNED;
>                                 }
>                                 goto send;
> -                       } else if (rc > 0) {
> +                       }
> +                       /*
> +                        * Before the tree connect is looked up, so that =
a
> +                        * plaintext request learns nothing about its Tre=
eId.
> +                        * A CANCEL is never answered (MS-SMB2 3.3.5.16).
> +                        */
> +                       command =3D conn->ops->get_cmd_val(work);
> +                       if (ksmbd_plaintext_refused(work, command)) {
> +                               if (command =3D=3D SMB2_CANCEL_HE)
> +                                       work->send_no_response =3D 1;
> +                               else
> +                                       conn->ops->set_rsp_status(work,
> +                                               STATUS_ACCESS_DENIED);
For the response path, this jumps to send before __process_request()
validates the message, so the MessageId is left unconsumed. It also
skips credit settlement. If this ends a compound, credits from earlier
commands may not be returned. Could we validate the request and call
ksmbd_set_failed_rsp_credits() before sending the error response?

> +                               goto send;
> +                       }
> +                       if (rc > 0) {
>                                 rc =3D conn->ops->get_ksmbd_tcon(work);
>                                 if (rc < 0) {
>                                         if (rc =3D=3D -EINVAL)
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 5a7842264b98..a133437b94ab 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -2419,8 +2419,10 @@ static int ntlm_authenticate(struct ksmbd_work *wo=
rk,
>                         !(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
>                 conn->ops->generate_encryptionkey(conn, sess);
>                 sess->enc =3D true;
> -               if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION=
)
> +               if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION=
) {
>                         rsp->SessionFlags =3D SMB2_SESSION_FLAG_ENCRYPT_D=
ATA_LE;
> +                       sess->enc_required =3D true;
The guest path above sets SMB2_SESSION_FLAG_IS_GUEST_LE and skips NTLM
session-key setup, but still reaches this block. In mandatory mode,
the existing assignment overwrites it with
SMB2_SESSION_FLAG_ENCRYPT_DATA_LE. The new enc_required flag also
marks a guest session.

> +               }
>                 /*
>                  * signing is disable if encryption is enable
>                  * on this session
> @@ -2525,8 +2527,10 @@ static int krb5_authenticate(struct ksmbd_work *wo=
rk,
>             !(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
>                 conn->ops->generate_encryptionkey(conn, sess);
>                 sess->enc =3D true;
> -               if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION=
)
> +               if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION=
) {
>                         rsp->SessionFlags =3D SMB2_SESSION_FLAG_ENCRYPT_D=
ATA_LE;
> +                       sess->enc_required =3D true;
smb2_sess_setup() treats SessionId =3D=3D 0 as a new session and clears
conn->binding, but this condition still uses the request=E2=80=99s BINDING =
bit
directly. With SessionId =3D=3D 0 and BINDING set, the new session can
skip encryption setup and leave enc_required clear. Could we validate
this flag/SessionId combination before authentication and use
conn->binding in both auth paths?

> +               }
>                 sess->sign =3D false;
>         }
>
> @@ -3052,6 +3056,12 @@ int smb2_sess_setup(struct ksmbd_work *work)
>         }
>
>         if (authenticated) {
> +               /*
> +                * MS-SMB2 3.3.5.5.3: the response to a reauthentication =
tells
> +                * the client to keep encrypting, too.
> +                */
> +               if (sess->enc_required && !work->session_setup_binding)
> +                       rsp->SessionFlags =3D SMB2_SESSION_FLAG_ENCRYPT_D=
ATA_LE;
>                 /*
>                  * Draining the previous session drops srv_mutex. Finish =
using the
>                  * connection's authentication state and free mechToken f=
irst, and
> --
> 2.43.0
>
