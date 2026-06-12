Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B07131B80E
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 09:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781256206; cv=pass; b=tqXgqLzHXiEYuGHT1M3+iscsB2pfaeZVPBnuCcKilhedPCArQXrdTIM5gSQbJkaY7JiP1SHSpGlCVdSruQ8+qrGmbJbuWKenfZ29YkvUk3XjdRTWqQ3Te/jYhjanjvEuKRuoJS5M/XgzBrqpMR0eTf479oii4kRwjoHWmw6w5EY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781256206; c=relaxed/simple;
	bh=LurVipVlsDEqkzCMv4tfDxpB0T92l33Cfno6fVx9fPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mtn5aAJTL03GwpmUPhx+8CkJeU3Szmmo3WBMqOq1O7/q1XekyGnlpWjn/YoJP8GtCeCsQzonZKTK/5uBacZS4VsBEB2wjp03DeI6aeDrpCC3Ha22sODGFwK4Abyk3HHgmzO1a1IrnGf2icRy3XtWl6idHBCuapakOYG9TsRLKSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IDtgcxoy; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IDtgcxoy"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8d18de80b29so10638996d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 02:23:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781256202; cv=none;
        d=google.com; s=arc-20240605;
        b=X6Batn3c6RFVnDe6XchGTBmDbU1xZNp2PnrFkFyQRuNHKryCLjG530WJJ55oujYta3
         BE+0hkKX1urLf1LEGq/5RoizuNwvZAHFOKcwCpm9q1V5YLF3SeMgVwdNwfihsAaZ0lDd
         UQTrwJ5TBUAxXDcl5KOwO5uBvWFWuuzRprnAghEcF+mH/IQXl8j5e4e/46eyJqDy6p3Z
         jCySiekcLAv1qFXAH2qSeOj2aVn7/h8LiTAciYXrvFI/vIy2AuuP66IUVuaOpVi8aeMj
         aiHkYNf4oS74vPnR1lCMF+Z7gxV8Hpb6QyAVSio6jYqsl4WqpRqGZrJWW9n+0Dj7KUYd
         r55w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nuI5bR1iu7ixrP8tODt5ims/R4kRWQmPNBCPO/mnqsc=;
        fh=+ptEt3uHDCBp565C9vEjpLZ+G+mUjY4Hgo+r5zncWw8=;
        b=d7gytKX215QfDEMpouqgEJTnWCAj5QJLkabz26V8wR5dPae8YK51Xx3dFJSHDZwJ8M
         KrdzSwOpi9flxqsbNzYGBDsN4hKAbymsw3pjM+ioo1n23kQaMrAVqxdZ0UnakHOojGn0
         90E262PQpvzJUlAiugFQagLqwUxfkr+CBTRdmJ9kXmlqiYQSjE/a8nK9z5fNaYQJpscW
         BRw9hi4KZbv4PCiPmMcip0nDL3dDEvs3l+BmGzvkcFRhqK4lZaCLk+LdBrthCrwy0DCh
         mMTrsdgsqdMPqyu2BkXX54ONWmnWNvH/hyLR0ni0CNCc08fQShwZUKK/d4eG8oEYsI5k
         nbVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781256202; x=1781861002; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nuI5bR1iu7ixrP8tODt5ims/R4kRWQmPNBCPO/mnqsc=;
        b=IDtgcxoy0LB4WbUkaUofColTc/DhzR7Kx8Xeq5vYJYSnrkxFr614jZ4QEsnwper/Ns
         414ADr9CYhI1f52roPqNvCI12QnJmBm0vfbmowoEBkFb2DMJUe/yl9JzsA3HsfG1Uw+M
         83L+Wac4Bw8DF7UTbiGvYqPMeZc+Oiiu4Qfr16AX2n6kQqfQWwLuiwBcdBMZhs7BSysJ
         DizYIy7XMfKtegAYySDjsF4SrZH0H48aRwx6Np5UdKk2e9GVQKWZM388MwMEfhmMoNGc
         J27J4yIe+VAb6Aum/DqX9sdpZs+5AiKIDyNPMQdWCjd6ZLsiMCeC45V8EGDE8WgRer7+
         ZmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781256202; x=1781861002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nuI5bR1iu7ixrP8tODt5ims/R4kRWQmPNBCPO/mnqsc=;
        b=bbgbFo9dh7F/4m2BKK0TdkvPCkZUoteEDqRr3n+whEHLm/kQGJ5qI7BIKOxU6QIfn0
         IZYPi1tZriUhWRCPAo5lZoF6+PKmKfsUg4hvU/9S9CFniSdBMEFgY3aReRJBDhaJ6PwY
         fYcxPNFm/VkM7+5QQ81HkvRpb+6qp4JB81CfVBAz40fhryOsaXpijzkj5oW0E8ORFFM6
         R/SSTuUgJJqfwF7dR2Lcw08QW3Zf2iat3GFgf/pOe/TMjhJ5WMhJjYYFUttO4yDezVGW
         NIu6eSSrxio9J4lyCsSAQURFYxhDZAa5efo0ODdCWJfv1diMRyfRZC9Tl4KmuTjcq5M4
         301A==
X-Forwarded-Encrypted: i=1; AFNElJ+UuzlHPzp/8DcQxXbe1ECpWFkC3lAw20N03NQkd+Kj4HJkLSLhkATgZMsp5U7yc6tOXudb3ywPYjzN@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9ctbdAobtATEDWH+LZvggC9d03Y12HA43vJ4pBhrAlBihpm93
	ppDBkOASivs8Zf/oVcB4Ky8efv7g02Myx604amBbBa+sI5SGqiDz34HcFZKxaUQ7ZHVQpH00Tb4
	r9gmr+21Kq/9dPcpG8yJ/zud9QSpujQQ=
X-Gm-Gg: Acq92OF780lNRmQRmuuRXnAIKF5bHGwIO1HgOiOF+I7nJQcjz1GAdCDQKQ4hKXRxPF+
	zp/6PNlFhWNYyaM57mMXaweXlBFArG02VhHm1i4jsRvkPvP50amD3Eedw78wH/YxMLVlhqvFLrs
	knDBP4PU51MzuoQZMTeQzkC1eX+C+cqI7Oe8XXCQNtxL+haMlK7m7cwgXSgMIqYAf9Cd4fyNyUN
	dio6hK3kGaWi9UwkRdCJfkhvEBQQa+vhgU92aYIRmtrG0F8o6RtUFmSJHM+/ygAU2ZKdhbmKSU3
	znPOJQ==
X-Received: by 2002:a05:6214:c6f:b0:8cc:f159:7b70 with SMTP id
 6a1803df08f44-8d317c44356mr31903816d6.32.1781256202485; Fri, 12 Jun 2026
 02:23:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1779371115.git.rajasimandal@microsoft.com> <1fd3c3b8f04d7794e559f5caa4ea02ba6e4aa721.1779372325.git.rajasimandal@microsoft.com>
In-Reply-To: <1fd3c3b8f04d7794e559f5caa4ea02ba6e4aa721.1779372325.git.rajasimandal@microsoft.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Fri, 12 Jun 2026 02:23:09 -0700
X-Gm-Features: AVVi8CcnPVPcTMhjSzpYUBKgvB03qgd8tBxKbARSJhvFvWNIVMqQQRSPtu-CR7M
Message-ID: <CAFTVevXVTdApfhtU64sR5x2C5E2hft+S9SkfGwjonTiCUNUZYg@mail.gmail.com>
Subject: Re: [PATCH v3 6/9] smb: client: move struct tcon_list to cifsglob.h
To: rajasimandalos@gmail.com
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>

On Thu, May 21, 2026 at 7:06=E2=80=AFAM <rajasimandalos@gmail.com> wrote:
>
> From: Rajasi Mandal <rajasimandal@microsoft.com>
>
> struct tcon_list is a small list-node wrapper that pairs a list_head
> with a cifs_tcon pointer, used to safely iterate tcons under a
> superblock outside tlink_tree_lock.
>
> It is currently file-static in misc.c, used only by
> cifs_close_all_deferred_files_sb().  Move it next to the similar
> struct file_list in cifsglob.h so that other _sb() iteration helpers
> can reuse it instead of redefining the same shape locally.
>
> No functional change.
>
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h | 5 +++++
>  fs/smb/client/misc.c     | 5 -----
>  2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 82e0adc1dabd..2a8b955638e7 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1807,6 +1807,11 @@ struct file_list {
>         struct cifsFileInfo *cfile;
>  };
>
> +struct tcon_list {
> +       struct list_head entry;
> +       struct cifs_tcon *tcon;
> +};
> +
>  struct cifs_mount_ctx {
>         struct cifs_sb_info *cifs_sb;
>         struct smb3_fs_context *fs_ctx;
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index 0c54b9b79a2c..7ef135dc8268 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -28,11 +28,6 @@
>  #include "fs_context.h"
>  #include "cached_dir.h"
>
> -struct tcon_list {
> -       struct list_head entry;
> -       struct cifs_tcon *tcon;
> -};
> -
>  /* The xid serves as a useful identifier for each incoming vfs request,
>     in a similar way to the mid which is useful to track each sent smb,
>     and CurrentXid can also provide a running counter (although it
> --
> 2.43.0
>
