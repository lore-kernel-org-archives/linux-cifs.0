Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794321620;
	b=DTWVMcqasvuNnNV43jF9h9DkobaFOpfdPIwQzJyfPsoMQ2ScDSOA/rgRN+a32wqLWfjR
	 KUWQgkjDH8bQTCNQngg+iMcU1ueo23EJNKjEkw3Qqp6l3yowU7RsTH9oCAmGo7hpkVQBH
	 Xb8T8NXHl/wIBY7kvTYDygdM+rNisyfXSsYm4jY67YXLlCXRn2jqte6sOyaDmXtRyotDT
	 gHgarcApXvx8LLpF8GH5MTZMh/xIFZ8MHvNZjISH57iYu5zpTHU8Bh+wJaAmNDzzikbHe
	 kvJnmcrxu0EH0C0kHDB8xh+HGkqviDywr5OGqtvxBLUiCVmkJu0rtCNafhZrFYEh4Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794321620;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=9FkP82NSjfPVkGjOtRXyI/+qz+a0r2i1CKeWvx3C2dI=;
	b=PFgiTFgTTCGXsFLVlwwEJwpBYcmH63Gr9iHhOjyFpCgEZoawmFHTn+KO9kwZGyMkVUTI
	 S/T3X0q8DykYS72OImstbJgI+mZopmDmBAVR8g+MTNJduY+AQaX5M0cRSOUnV5OZmSAu3
	 dFNn/RcBErbmGLG3Bcz0YlmhRhWlucE5GziZI82ZttdI1/KgueUt8Opp8XK1Uxmnuis3y
	 TX9IKJmxWJf2uW5w+nB4ujfzVsp6G44YboGN3vPiq91ugFhsEfyv+ifLm5UpUkxb0s9fF
	 ZIjxm80fyNyzE2ovf804GFTTmy0xan7HvDfss2i9Zd6X66qbNaus1Fl1yv+dRkngYMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NVp3+fJi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3980606A333
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 14:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NVp3+fJi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5322A1F008A4
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794321620;
	bh=9FkP82NSjfPVkGjOtRXyI/+qz+a0r2i1CKeWvx3C2dI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NVp3+fJiEximT8Zz8H9I9iDtFgXJtSm0JEe6oETmFM6825eYdosvMOkxIiXBSyuF4
	 cIWC7WzCxX4/v5wcnhJo5IpCvTD+TZQ10hnCFBjd2bmL7t6KxQHWvtlts8U90a4j0f
	 rkaPWcBplJHF+FC3agcB8RNEwLq+IF+bOvj/SDhCaWDCa22XnfTsyQ6TZU+yd3lVmx
	 IZd5J/DBnlk4q4/KY1Sj4LhTFU7/Lyrakj7SRh1MTbnAe+1uyzDSPwofUKZCDNzrzK
	 TdeZO/lpDtNSHtWD/Xtd8gTUfd8Pt4x9mUtxlGoWupbWpaW6xC4z3vBaglrJ1fhbfo
	 ILx3ZulylFCeA==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b65d69f5c2so2762986a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 06:40:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErH+GVC1UZiXIgpx/qA0fF2Hwf5sUNov7T8TbrlIKnlLmfjnKRIcymhPPIJnaB0H94BA+BQCv3oh8sJE@vger.kernel.org
X-Gm-Message-State: APuU4Z82JjhmHb1+w8tBLqJ3nXclXthZT/Urzhh/eoZ/mJEiYJAfw1mL
	BDuAL2SvpAHaNIyl7aYfqIcQbQvI20IhsU7cyB/PVYqHeXucsGUalV2jwVLD3yzKBgk/bT0f/Se
	0pv9zQmAEWnFrWFZrxHzeDCDFTT8URnM=
X-Received: by 2002:a05:6402:22d0:b0:6b1:b97b:745 with SMTP id
 4fb4d7f45d1cf-6b756af0889mr1703428a12.29.1794321618978; Tue, 10 Nov 2026
 06:40:18 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAKYAXd-Jo-ObBDs-AdGfaM+QmDsot3gj1g0oJiyDKczoUDg2TA@mail.gmail.com>
 <20261109194144.22814-1-mike.michalo@gmail.com> <20261109194144.22814-2-mike.michalo@gmail.com>
In-Reply-To: <20261109194144.22814-2-mike.michalo@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 10 Nov 2026 23:40:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-nhvaQPNF_=nTTwxa=umN24WfpWgvN8X_UE_P1Vk=dEA@mail.gmail.com>
X-Gm-Features: AclHuK-v7gL0EmbkbxKvWxJdfqe3QqJFytqQDKQtYVZUM0-qKu6IoLKDEwC3iso
Message-ID: <CAKYAXd-nhvaQPNF_=nTTwxa=umN24WfpWgvN8X_UE_P1Vk=dEA@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] ksmbd: verify the signature of session binding requests
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: stfrench@microsoft.com, icb@fastmail.org, senozhatsky@chromium.org, 
	tom@talpey.com, chenxiaosong@chenxiaosong.com, ematsumiya@suse.de, 
	lsahlber@redhat.com, hyc.lee@gmail.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +static bool smb2_check_binding_sign_req(struct ksmbd_work *work,
> +                                       struct smb2_hdr *hdr,
> +                                       struct ksmbd_session *sess)
> +{
> +       struct ksmbd_session *prev_sess = work->sess;
> +       char signature[SMB2_SIGNATURE_SIZE];
> +       int ret;
> +
> +       memcpy(signature, hdr->Signature, SMB2_SIGNATURE_SIZE);
> +       work->sess = sess;
> +       ret = smb3_check_sign_req(work);
> +       work->sess = prev_sess;
> +       memcpy(hdr->Signature, signature, SMB2_SIGNATURE_SIZE);
Could we restore hdr->Signature inside smb2_check_sign_req() and
smb3_check_sign_req(), using the existing signature_req buffer? This
would eliminate the extra signature backup and restore code in the
session-setup helper in patch 1/6 and __process_request() in patch
3/6.
