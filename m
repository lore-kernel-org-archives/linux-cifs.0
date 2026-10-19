Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792453646;
	b=CNrD4VhKBumuOE0C7Zyje97X7HPXwAWgDlB2Km5YHWU60hLZddH+I6pscM2tt3XOmP2H
	 8ZZ+r27UTclicPB8UizIJxprIjQdKMiZmhfTvM37MNdqQSMl6N10Q7cd7J9eGfksvw0MF
	 V2VtjPFwhZpRarjw+cKcts6rifGaR5Dn+T22Lrx3vCooTFLQZq/oh8wDxex09vnuV2wWL
	 EtDxcn7N8pIcMQPquj7KKDzw4e4ACctXc/IGcjKmv9onTpnDXLqsTccEje6J/cXAEKUHS
	 IDGZoJbwW+Hyej4U4Krk8fpLsAtzO0Q/824j9kVtYxnkmBT4ES55mfNeGpDIfV/T5Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792453646;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ayk/TP6+FwpClVfOv7ABNagIX/45Pt9+vmGRM76bB+k=;
	b=ekGrHOaP02Ns/OeJ49KQPMuWFAmUWjFa+Mus2M03YOUtjh/8t1t6NsCs94E2RKLErBcr
	 SSVcEeJdyq+TTBsgjV+61tDE1pPFBlyfxY/NKZu5UT7iZdN4p5G0tBsf6+A+BMzp76QuP
	 21yhA8SXrrYzf+1SiN4Xp4hCkgTJpvsBV23yTkNDEAtO8wSTLSMvg5Stj6pi98trcxIKg
	 /k+qU5AKGnVLZ76fGWmC8W093/XCC1aAMeFD0WQZOM2Y0RWMit4Ks9lxw8drZWL3tjU8J
	 I/7M0hrZ94LZI8DamW6ZtR7Luj+KH6oVIoiLjddxgKlbBKTno+wu6eOAK1vP5De4+tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lTNYa8Ti;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D0C606A31A
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 23:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lTNYa8Ti
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D91F1F000C6
	for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 23:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792453645;
	bh=ayk/TP6+FwpClVfOv7ABNagIX/45Pt9+vmGRM76bB+k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lTNYa8TiqWqS7cc71qp6XI2toE+xwh6XRtmeGc/XOFByhJel0Ngi3EanqKHN1bjSR
	 bBQP6qjbm06DU4CHWw4sBhXGvypa+zYhOTCdkiFLVK7pIvRjS4EKeuIT0MEQOplxiP
	 78Z/nEGvXZ9dbjNXuexaiQyUcIxXCW/wsvSU9slB+DVylYnzROOBs/6vhIXwWtUDvK
	 apCEqd55xnifpPUu3WxtFKxulZfrCtQyT9rx54o0uAURGCiHU9yHyTPbr0j8sNlPKw
	 RwqE04AAc+1omlLeEstTXbtv3sSmPgvaXI9nUd9L87rbdwfQq08QzptxhFDD0SfzCl
	 xQMta6EoXNnAQ==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c40447e25e6so303652366b.1
        for <linux-cifs@vger.kernel.org>; Mon, 19 Oct 2026 16:47:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz33dsVTv9qHMB1pFlExoHmRWCyYBCw1POOZx92SoIX2AatOjugE3NWLecniy+NCEKBQifVOLzjaSOz@vger.kernel.org
X-Gm-Message-State: AFq9FYLGj758bXpoZnjb75cjVEDx/21MM1SftrgxSQCMyRcKrUR2Swg5
	6vjcvdpV10easIIEodUqp5QT8F8kyoFdh1o57Voq5PMm11eIvBxdAOEnGQHIfkWMzSHzqUEpqHx
	A/P4GOdugawjEc9YRse7A3psYWAyP1iQ=
X-Received: by 2002:a17:907:d006:b0:c31:8c7c:391b with SMTP id
 a640c23a62f3a-c419df3e670mr622856266b.13.1792453643953; Mon, 19 Oct 2026
 16:47:23 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAKYAXd-Z_H2O3W=_KrUifR44yisJJhR=-bQQp1mML7vHgfcdDw@mail.gmail.com>
 <20261019191116.31291-1-mike.michalo@gmail.com>
In-Reply-To: <20261019191116.31291-1-mike.michalo@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 20 Oct 2026 08:47:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_JBrVjn9QK3cGN77biwivVKjdTyFvok5stALZ+rgXKbw@mail.gmail.com>
X-Gm-Features: AclHuK_j-ePbUAjPU9uHRRuq9fCSZmxHntO8HQwepZSmLVvhwnN11OB-xY_hF5M
Message-ID: <CAKYAXd_JBrVjn9QK3cGN77biwivVKjdTyFvok5stALZ+rgXKbw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: accept share config responses from ksmbd-tools
 before 3.5.3
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: farhad.alemi@berkeley.edu, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 4:11=E2=80=AFAM Michail Andreas Michalopoulos
<mike.michalo@gmail.com> wrote:
>
> ksmbd-tools releases before 3.5.2 do not have the payload_sz field in
> struct ksmbd_share_config_response; the field occupies the last word of
> their reserved[] area, so the kernel always sees payload_sz =3D=3D 0 from
> them.  ipc_validate_msg() and share_config_request() used to treat
> payload_sz =3D=3D 0 as "legacy userspace" and skip the payload size check=
s.
>
> That case was removed by
> commit f25e93768fcc ("ksmbd: prevent out-of-bounds reads in share config =
responses").
> With payload_sz =3D=3D 0:
>
>  - the IPC$ (pipe) response fails the final message size comparison:
>    these tools always send a one-byte payload, so msg_sz is
>    sizeof(*resp) + 1, but the expected size is now computed as
>    sizeof(*resp) + 0;
>  - every other share fails "payload_sz <=3D veto_list_sz".
>
> In addition, ksmbd-tools before 3.5.3 copy a global "veto files" setting
> into the IPC$ response, so with such a configuration IPC$ also fails the
> now unconditional "veto_list_sz > payload_sz" check, even though pipe
> shares never use a veto list.
>
> ksmbd_ipc_share_config_request() then returns NULL and every tree
> connect fails with STATUS_BAD_NETWORK_NAME, so ksmbd cannot serve any
> share when used with these ksmbd-tools releases, for example the 3.5.1
> package shipped by Ubuntu 24.04.  Login still works, which makes the
> failure look like a configuration problem:
>
>   CIFS: VFS: BAD_NETWORK_NAME: \\127.0.0.1\IPC$
>   CIFS: VFS: \\127.0.0.1 failed to connect to IPC (rc=3D-2)
>
> When payload_sz is zero, derive it from the size of the message actually
> received and store it back in the response, so that the checks in
> ipc_validate_msg() and the path and veto list parsing in
> share_config_request() all use the same bound.  The response is the
> kernel's own copy made by handle_response(), and msg_sz has already been
> checked to be at least sizeof(*resp), so this cannot underflow.  All
> checks added by that commit then apply unchanged, bounded by the bytes
> that really arrived, and newer ksmbd-tools that fill in payload_sz are
> unaffected.  Also skip the veto list size check for pipe shares:
> share_config_request() reads neither the path nor the veto list for
> them.
>
> Tested in QEMU with ksmbd-tools 3.5.1 and 3.5.7 and the in-kernel SMB
> client over loopback, with and without a global "veto files" setting.
>
> Fixes: f25e93768fcc ("ksmbd: prevent out-of-bounds reads in share config =
responses")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Applied it to #ksmbd-for-next.
Thanks!
