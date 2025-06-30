Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55AC2F4A;
	Mon, 30 Jun 2025 18:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751307373; cv=none; b=hFSbrC6dJB/hSRWN3uxpIPGug/lVxKbWebQy134Cu2tbqqc/DVm7wzbAy5dljDp6AysxAC1kniWdr8xWNC2/kmNhzvkMcRZLZ46O2apK1WFTaGbx7P7/X/QNvpHt350lYbJjgomED2DEibbhCmlJXB0AqroXf1Kfg0ZQYPhzkW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751307373; c=relaxed/simple;
	bh=5b4zwQbI3TfVEvNHB8JL8VNLntaKp1XIOCDCu5Vi6uo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ksvfam7/Gqmqz7mUHuLXcL5N/q/lDDKrU007RYL315O1I4/+Jusm9z1aJSRyTQxD2vw5SZLdNv/olWaAS0TekWfxciAS98d9N4Z4Yq0Ux6/lM8xrtC51F+QI+I1ptA7BU9wGdBvbExEudFtwqZzkGblCT8O08Pxj4/vLX4/D20s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=blIXrso/; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="blIXrso/"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4a8244e897fso8632081cf.1;
        Mon, 30 Jun 2025 11:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751307370; x=1751912170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=onS6VXjtFeDdt7uVgfHVvrBvKC3QofJ8cD4ZNlDeikw=;
        b=blIXrso/YduSDXc/r2jcu1VLPA/ESFa4Rb1jNzLUw+IjSE8uevgs/uqp7otYon5sbN
         FekMdiVDGG1gWg/ZrmkmPmrowaoXcE4WWlBemWbT/EP2thoqdTreqMxpXlrYRuUqsHfT
         7AqaxY1osJ2yKFrojjEi5fhnDacFeth1RnaAWOfnZp+EjT7PmRsDc3NmKbLb9xQeUzM7
         CaDstAkS0Ppp+p9Zebephufc8w6sWSSjif9wGdNrMA+cUbdIt4z6UkQWHVIlmEeAJFJG
         iljDncJxtk++rUgjwRK5oogUKbP2TMug8QXprohLocaWikliMzhobbjRhQXMNOE+jznd
         C6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751307370; x=1751912170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=onS6VXjtFeDdt7uVgfHVvrBvKC3QofJ8cD4ZNlDeikw=;
        b=VYIdKwcpArfhlKQWT9TdOc1hVhly1XFDlYxAmACiguEquK6NA9jYRuO47jCbGUT99o
         HcFxxlicPtdVyXcOAT9kUkSKSY60XNh4+zVwM2CJlTsQCuvA189yfpG7ZM4HspiEer9S
         z4gBqm27vvLXXqaWKXzlzlPrIgW7lYYZG/QKOijEkGK6zAhwCZE07gsNK/Eap9rlXziY
         ++pBVZc5t9BfDpRaDpCnuG6GtK4T34nUlpuQjifE4MYhnrnibdiU9C+OjqzbZvWaUFdE
         VyQDeC7KrM9QcfX5U6aWjtc5m0ONoiiRVOVDeRR+D76UG4QFXItzR7MtHQm0aB9+r4E8
         ZbSA==
X-Forwarded-Encrypted: i=1; AJvYcCVdraxRmsW9p5c6L9DEY/8zMxNtHAwhfaWYkUVB5aabml6lKe0BpwjrJRCHZ2dSqnsdRjO+a2Qz9Irs@vger.kernel.org, AJvYcCXrnHkL4JWryF45Rxw4JMOSPwuw79cug3yQ5OdXtqcGYHg7uF/S0zVsvU/6PhdjKDSIWqobh6bU@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0dvLS+sXJhIkfXcpvoX+QEeQsT3IB74vK2t54CcKI+Vc2jK21
	SYrVMBbrhAUfEG0VG2xg5B2Y/sCdo/TdEr7hTSF6TxgbJ7BGV/7piMMpx4zidoikMvi8DbFpzH9
	EWL7zR78OsIY6n3QLMtA5TGmXZxdPDbE=
X-Gm-Gg: ASbGnctO0tp/lI5MeXAn1TgZwikinlMP8mJOWelTJf6zsUT1SEQZVWg5PNQjf7eFVDC
	kwcCWmUdOGOGxnpdXP4vDCh/QHawA4ejWklzG6odX0qzWC1j2dNR2qNfR4Ufkr6qd8iSszvhlL3
	oTt7uP6ojN5U3IvEFX1wp5e1sprOipSsNQhYj9ksk7eqpUspGeE6Vs0uqvYPPekJzPt2YYfdNKB
	mKKEg==
X-Google-Smtp-Source: AGHT+IF/g5OcPBpXJn0tRofPUL6K88XIxmCFBcHsdCC1nvD12ujpqKLQthAS63T4t+rxN44V9o6qfiDWZHP2C1W0LqE=
X-Received: by 2002:a05:6214:2581:b0:6fa:bbb7:602c with SMTP id
 6a1803df08f44-700134a7130mr191906136d6.29.1751307370466; Mon, 30 Jun 2025
 11:16:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250630174049.887492-1-sprasad@microsoft.com>
In-Reply-To: <20250630174049.887492-1-sprasad@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 30 Jun 2025 13:15:58 -0500
X-Gm-Features: Ac12FXwzFmbpisUUIKnYUmEkGiRFBLaYzV7iMJCNHmyuvdjU7DdYmMGGBay7vfM
Message-ID: <CAH2r5ms8UkxqGt=5YfnEbnXz35bTgEkXZQdJy3HNWa4NkoL4YQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: all initializations for tcon should happen in tcon_info_alloc
To: nspmangalore@gmail.com
Cc: pc@manguebit.org, linux-cifs@vger.kernel.org, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending testing and more revi=
ew

On Mon, Jun 30, 2025 at 12:40=E2=80=AFPM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> Today, a few work structs inside tcon are initialized inside
> cifs_get_tcon and not in tcon_info_alloc. As a result, if a tcon
> is obtained from tcon_info_alloc, but not called as a part of
> cifs_get_tcon, we may trip over.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsproto.h | 1 +
>  fs/smb/client/connect.c   | 8 +-------
>  fs/smb/client/misc.c      | 6 ++++++
>  3 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 66093fa78aed..045227ed4efc 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -136,6 +136,7 @@ extern int SendReceiveBlockingLock(const unsigned int=
 xid,
>                         struct smb_hdr *out_buf,
>                         int *bytes_returned);
>
> +void smb2_query_server_interfaces(struct work_struct *work);
>  void
>  cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
>                                       bool all_channels);
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index c48869c29e15..16c4f7fa1f34 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -97,7 +97,7 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_S=
erver_Info *server)
>         return rc;
>  }
>
> -static void smb2_query_server_interfaces(struct work_struct *work)
> +void smb2_query_server_interfaces(struct work_struct *work)
>  {
>         int rc;
>         int xid;
> @@ -2866,20 +2866,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_f=
s_context *ctx)
>         tcon->max_cached_dirs =3D ctx->max_cached_dirs;
>         tcon->nodelete =3D ctx->nodelete;
>         tcon->local_lease =3D ctx->local_lease;
> -       INIT_LIST_HEAD(&tcon->pending_opens);
>         tcon->status =3D TID_GOOD;
>
> -       INIT_DELAYED_WORK(&tcon->query_interfaces,
> -                         smb2_query_server_interfaces);
>         if (ses->server->dialect >=3D SMB30_PROT_ID &&
>             (ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) =
{
>                 /* schedule query interfaces poll */
>                 queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
>                                    (SMB_INTERFACE_POLL_INTERVAL * HZ));
>         }
> -#ifdef CONFIG_CIFS_DFS_UPCALL
> -       INIT_DELAYED_WORK(&tcon->dfs_cache_work, dfs_cache_refresh);
> -#endif
>         spin_lock(&cifs_tcp_ses_lock);
>         list_add(&tcon->tcon_list, &ses->tcon_list);
>         spin_unlock(&cifs_tcp_ses_lock);
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index e77017f47084..da23cc12a52c 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -151,6 +151,12 @@ tcon_info_alloc(bool dir_leases_enabled, enum smb3_t=
con_ref_trace trace)
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>         INIT_LIST_HEAD(&ret_buf->dfs_ses_list);
>  #endif
> +       INIT_LIST_HEAD(&ret_buf->pending_opens);
> +       INIT_DELAYED_WORK(&ret_buf->query_interfaces,
> +                         smb2_query_server_interfaces);
> +#ifdef CONFIG_CIFS_DFS_UPCALL
> +       INIT_DELAYED_WORK(&ret_buf->dfs_cache_work, dfs_cache_refresh);
> +#endif
>
>         return ret_buf;
>  }
> --
> 2.43.0
>


--=20
Thanks,

Steve
