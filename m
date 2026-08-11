Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9096A432E7C
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 10:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786443643; cv=none; b=g/mE9N5OgZAKxKuKGTcGSWaTIaAyslbRnxMGFV0AEPjxOhmMmlLL+F1tJoPn4HxCGLJQ8qBgl1WQGQwKz7YHAMqkCh5gsiBbk9LWzBdtcQTL0apogaZeL533n+dYO1RtfZ00i6dpoE9SmWE/sFJChrvyocbUG6GWzeTx6t5anT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786443643; c=relaxed/simple;
	bh=tflgnBrymLo6vczClfrwP78LF//ajQKDMxyDzxhVogs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K8A2ZfVicNXN51IUpzRIu8/bAHOzQrXVvkL5iQVWJfbIU6tlD3b/5pB55BtKgWlTWwSexsgt/209AmqPrlIIeTKI4bfPZbgv7SbFRATqHgRgl0VaV9KZzbLpcIHqPVU6/hO7IMgK57Rv3kVofDAMw1tvHmsLhNCb/EE+csKDNFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLQ8xWpo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLQ8xWpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20001F00A3E
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 10:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786443629;
	bh=/UBbjqPwegx7fuztVhmWInMc6U8hbFRhgWX64IKPRJE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WLQ8xWpoebEU6aLLhkugJDVX1h4veeraCX9d0vfXRQoM8RQ2lmZwn6YlRtpveHOcD
	 k15qfflyAk048M+8huOZAHXvDYWiKHZXrpQ6LAXsdodHnHRve1potxa1dGqNWjeWm1
	 KHl3CpR7nW5dhUtLdAlpOqNhaRE1UlIaYl9pltYKr5ut0YsmX6zCJMT3TIYQDu7+wz
	 dOxbkFChE/T6eNLNT+bRhaa4578QpI5lnJctoOhY/PmRPsts+B0rFtHw0o5n/wEnc1
	 FzpAE+XQc6N1tPhzIWxGd9Prh+U4Q8OiqUF3wUeHOBOr83bSRISyHSigPJIimbgR92
	 77gfKZtN/pqEQ==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a156627e22so1201433a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 03:20:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoNFKXTEhAZyJqIEsV2yKqUmansQBJTbIsR2TjRuutHuj6bsLNGuNZFZZ3DpTuN434UBwInppIZCymn@vger.kernel.org
X-Gm-Message-State: AOJu0YxOp30cYWkQri0reHnLY3YiZIecXY9SsFu5yIjDOCsyvnlZVzcm
	KDeZush+Z8oizjCFKoaMTdLSTIosB5ULzjBlQ77U8eJPQmeZFJusRJROtXq3i00ZKHt33lQX09e
	nyzhOI8ZKOLYyY07Cyx6KPZ6TOdt0qUA=
X-Received: by 2002:a17:907:94c3:b0:c15:a7b9:2ae1 with SMTP id
 a640c23a62f3a-c20e630fc72mr110160266b.6.1786443628585; Tue, 11 Aug 2026
 03:20:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260810125857.1009618-1-thuth@redhat.com> <20260810125857.1009618-4-thuth@redhat.com>
In-Reply-To: <20260810125857.1009618-4-thuth@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 11 Aug 2026 19:20:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-JSmGR-GjFD=Oyw-mYhBH2Di=ApKjj+J5DV1cAO_nJaA@mail.gmail.com>
X-Gm-Features: AUfX_mzHddJCJ7ZnitSE1W_oM4nGwtJPfcpVYBP-qwkV9NTIEeYIo6RzRwJ0ugI
Message-ID: <CAKYAXd-JSmGR-GjFD=Oyw-mYhBH2Di=ApKjj+J5DV1cAO_nJaA@mail.gmail.com>
Subject: Re: [PATCH 3/4] smb: server: Free session data with kfree_sensitive()
 to avoid leaking of data
To: Thomas Huth <thuth@redhat.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10, 2026 at 9:59=E2=80=AFPM Thomas Huth <thuth@redhat.com> wrot=
e:
>
> From: Thomas Huth <thuth@redhat.com>
>
> struct ksmbd_session contains some arrays with sensitive information, lik=
e
> sess_key, smb3encryptionkey, smb3decryptionkey and smb3signingkey. Thus
> let's make sure that this information cannot leak via the heap and use
> kfree_sensitive() to free it.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  fs/smb/server/mgmt/user_session.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_=
session.c
> index f99c86284ba3d..9cb990a22fd56 100644
> --- a/fs/smb/server/mgmt/user_session.c
> +++ b/fs/smb/server/mgmt/user_session.c
> @@ -389,10 +389,10 @@ void ksmbd_session_destroy(struct ksmbd_session *se=
ss)
>         ksmbd_launch_ksmbd_durable_scavenger();
>         ksmbd_session_rpc_clear_list(sess);
>         free_channel_list(sess);
> -       kfree(sess->Preauth_HashValue);
> +       kfree_sensitive(sess->Preauth_HashValue);
>         ksmbd_release_id(&session_ida, sess->id);
>         ida_destroy(&sess->tree_conn_ida);
> -       kfree(sess);
> +       kfree_sensitive(sess);
struct preauth_session embeds the sensitive
Preauth_HashValue[PREAUTH_HASHVALUE_SIZE] field, but it is still
released with kfree() in ksmbd_preauth_session_destroy(). Please
include it in this patch or another patch...

Thanks!
