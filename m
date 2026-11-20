Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795170130;
	b=f/qhrzyiNl8ual3C3SEUpkoPta+15XILcJcJSygJcz4gCaOOonOcfkXaX5N9JPwZazr1
	 V+1Xc2hygAenqGqg0Ugu7gVD2cinm//Gv0KV83DIMKHJvQazVahoqyC0bLyHEgx98OzgE
	 Tid6MEbTFqc3hRpMaNp7O0Iioq6pRttiwsBjcWNtVoCis4QniW/bPNtpVURmyEBPhteSv
	 WQMf1hoG/5coT1aSqrFt7z7Q6DcBG7HBbWfLQrVvbdODvcF7cUcimkAxrZ0pfFB0LOJS4
	 6HYjA95veQGgcJ3M/g7DsaSQxbD6UR63S8F8xTBsZW01uI1Q6rGcu1va0KjMJlmKlwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795170130;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=AomckiH2kg8UdKE0Ufuew6eJMusVeiFlY5GAfq9V6K8=;
	b=znl/FEOkjwzO2SVMbsHCWrvCN//0k10ZQpRpT6K6LOC1IDpuehu4OYfOGZDmGe5fdMGq
	 tDjpxUMuZztl4c5ygEswbfZ33BJv32aKHbhxtiw343jQEKRuQSzdW4wbzkALFQRC+sl8T
	 O7pisvKEBtpKflr6WkXq8GcVCKlqn2sLCABJMUtOuuXOrp9U4DMihX1E5m1akmxxv5rdd
	 bj+9AW1A8PiVq6btJlqVOaVHH7UB564+pWFnHv6t94ZKg9nPB5YKhFQ/HJbsFgA32HDCx
	 QUqR9m7/Dh7/WPSggjl4cNrtsz+quK5B7sXcUD5Ug0OJO4Vvub4vYHsmKyzw5lMYDsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R++Xn4lh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31730606A32C
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 10:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R++Xn4lh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56791F000E1
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 10:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170129;
	bh=AomckiH2kg8UdKE0Ufuew6eJMusVeiFlY5GAfq9V6K8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=R++Xn4lh6V23qQ3X8MVDYDHH80q/n/a1Wg/rHWidOPhA6AXPU5TWny73DsL4RwGXw
	 TOMCQkM35QR8Oc3lCVS3oxq4mnNTicP2FzLDkhyqk2E6kwDiJYu9tOXbf6TF86+U/h
	 9x1KHe+9IPOYwyIUfHFnJip30nLg5gCYyrdJ++i1U9zXq2aOtnYyNf73dSVcePgW0e
	 rcW2B7qZsuBUU6a6lCs5zdi/Aqj95MObbyOEdatMdIrPxY8pED5hVMBrpVaY85GEZh
	 dFbrmHdKBcOllYmAqRnnKpo/1eno5p1dObc74uP7r459IyCm5itlijKbEWOySHfq5B
	 0DOmRuYTZ15ZQ==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b87a240de3so879857a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 02:22:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGQaa2RO24h4shUKaolPiwgAkjhLQK5jc1KV8gw5ohq4XttuudMTmD/jZjLJBg7yR/X6gCNcvLvlDK+@vger.kernel.org
X-Gm-Message-State: APuU4Z9Qxzmv1wrrSdDHnfhjIPC6rRA6pxlaP7Fyn9a9hctnWAPRhjbI
	adqJh0kWy5VJyhjfh7I1gwUIEg/LAw1zELunqSDxw+1ZtCcw5OUCn9Eyle58x8iGATd57WgLdQf
	lDTU0hZS7gZrrMkzr6p1qe4hbkbXpGZI=
X-Received: by 2002:a17:907:da02:b0:c2d:c247:5400 with SMTP id
 a640c23a62f3a-c513a8493eemr258746566b.27.1795170128427; Fri, 20 Nov 2026
 02:22:08 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119191036.197225-1-icb@fastmail.org>
In-Reply-To: <20261119191036.197225-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 20 Nov 2026 19:21:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd99_zEgzyf6Qnad0Uq+ok=RP_a20hY381=pwF6=gTesdQ@mail.gmail.com>
X-Gm-Features: Aa3M54qujItBxVtNWavNvp1BXIUyRdVfvs80xYGd3K-AKL6FQFn7_KDmnkIOJvw
Message-ID: <CAKYAXd99_zEgzyf6Qnad0Uq+ok=RP_a20hY381=pwF6=gTesdQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: compare the whole SID when adding POSIX ACL
 entries to a DACL
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 4:10=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> When a query returns a stored DACL, set_posix_acl_entries_dacl() adds
> an ACE for each POSIX ACL entry that the stored DACL does not already
> have. It checks that by comparing only the last sub-authority of the
> SIDs. A POSIX entry is then left out when a stored ACE for another
> principal ends in the same number. For example, a stored ACE for unix
> group 1300 hides the POSIX entry for the user with uid 1300, so the
> query does not show that this user has access.
>
> Compare the whole SID. A POSIX entry for uid 0 is shown as S-1-22-1-0,
> but sid_to_id() maps the domain SID with RID 0 to uid 0, so a stored
> ACE with that SID also counts for it.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
