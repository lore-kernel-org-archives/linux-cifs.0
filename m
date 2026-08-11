Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F161B43B6C4
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 10:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786443459; cv=none; b=kPvGyYJDKAlCrjzCF55raTtMnuDxt1A49kdDT3wjnlZ7mf3BCA0/Lb/CGiEJ5KHHV3bmfMg6QTFrZeMWIeWdjCsb02gkDlmx4nsNyuPnjWip+aHE0E7SIYrXJmIy4bLyirhXkaMCYSydhSAnYDx3aisUGlcKFk9ZtBXL00Z7MKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786443459; c=relaxed/simple;
	bh=88T+C2sdS34T7X4oVt41r9hRmOWaFN9gIMu0YxT/qpI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NXXLQ/C5+fZVu3+Sx96ZJrTCByMb/cGhA5+a82PKweuNC+t6n57K0CHXda42IdEvpneI+GTnRPTvGZIMAxpLCDts2B/BAOJww4OVGnq8lwBnRPTHBZ9x1+OMnhuZEZDu4AvUJIdLa5PA5wKN+AKseVya+e/xUIVSx4x/q3BTpq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LfUHDo3D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LfUHDo3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562711F00A3D
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 10:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786443446;
	bh=blJ8vZ+YXBrsHmk/XqNX3JgLmgmfj7EPXyJTNnx6Zv0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LfUHDo3D2I++NzjcDV4N1bqfzl9hWwShV4fzC9yVS9uQUn/PahdSWWvOkMf+WaCHn
	 mjqLJLKfoGwuHM+3iSDobY/sTT+7PYT1vLDBov0aqzv2tePZsIqD1uKlY4tUdseDOG
	 l7Bc1aSrGm9dw42YlPTLkEdriP/ZkQlIabSMJg4d+MYadlQBoPvyLUGw0Wc7EIqkVK
	 1QumF8hLhSkaHfi/ToIwRmQs/aQT7E53NHrVELmXEJ7IVMNVlW/MDfPlA5JFfNKaPT
	 xB0tAVTYt4ejPjiKlmRsZH0Zjv22tmmHfPxZ9/SrZpcQIz+R5tUx04EDa3URoEcZfq
	 30WrxpEAUXSjQ==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c20ce3c118aso147430566b.0
        for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 03:17:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrnYmFGMmbO52fRXDxdfhVANQ6UMXV593hbn6nDmp1QzcZ5hAVBdLsa6GTqAjZdg851Xcdt/DkpQ8iz@vger.kernel.org
X-Gm-Message-State: AOJu0YxsSLiAjJ8e/nT19o3+12Mgypds04uG1HZFihBIe1u9jV0m3xUP
	6N2qU5cZW6SXznkGbgbLgUE49NCvltHcLAnmd04IuWjog5AUadTr8vdYfHtrtDxTcb/aExWfVJA
	MQhvwiCicMD2wqeU+d9UIJqeG8NTNLEQ=
X-Received: by 2002:a17:907:60d5:b0:c20:c23e:2afb with SMTP id
 a640c23a62f3a-c20e5ea9151mr126575066b.12.1786443445023; Tue, 11 Aug 2026
 03:17:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260810125857.1009618-1-thuth@redhat.com> <20260810125857.1009618-2-thuth@redhat.com>
In-Reply-To: <20260810125857.1009618-2-thuth@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 11 Aug 2026 19:17:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-W2D_oMsdEXTB18Evovh7V_1d=TaSpxBtaOyjNb_byxw@mail.gmail.com>
X-Gm-Features: AUfX_mwCU7Y0D8x8ebSPlhBYEH3wOexMcBqJSdoy7sf9C7OZlSxwKrsnR1_ZT3w
Message-ID: <CAKYAXd-W2D_oMsdEXTB18Evovh7V_1d=TaSpxBtaOyjNb_byxw@mail.gmail.com>
Subject: Re: [PATCH 1/4] smb: server: Clear sensitive stack and heap data in auth.c
To: Thomas Huth <thuth@redhat.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -464,7 +466,7 @@ int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
>         *out_len = resp->spnego_blob_len;
>         retval = 0;
>  out:
> -       kvfree(resp);
> +       kvfree_sensitive(resp, sizeof(*resp));
The flexible payload[] array contains the session key and AP-REP data,
which would remain in memory after the free. Please clear the complete
allocation:

          kvfree_sensitive(resp, sizeof(*resp) + resp->session_key_len
+ resp->spnego_blob_len);

Thanks!
