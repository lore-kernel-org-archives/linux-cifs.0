Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2313C1531F4
	for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 12:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724242507; cv=none; b=iDe52dMdAt83rpBVhWs9VXFhADnqqBF19JXyWW6vcme9QSDpOefFQ7jwVJ3pY7COggGbkeeg9TOyPSts0FAsXN4b7KIxnbhP6gIc0zhXLumtGMhEpTjbExiD/odEfE6jrJ/PnENtLDI2xeTc4MUQ9nU2qaGN2DkGdLZ7paO7zVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724242507; c=relaxed/simple;
	bh=jK5BjIqpQqsO/cvRq29rjymLsF0TNSsugjheUGqnUgk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jeOE59OOunVKSrbESfqVndZggYMpytYouWfKx1HUqKe2QD44kTZlefsAiK9IlRTpMvKf8FbKOfipJbcD0wAs3knUZsYGofQIUDVppRU1jaAaVfCSeqKfQCyZbsCBFwMR1qXaw8806Y/ZS+7BLqmYJ+UTCeg4p3D3XZWJzb/PgOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DLoOnw5f; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DLoOnw5f"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7093efbade6so4224585a34.2
        for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 05:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724242505; x=1724847305; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u4kc5viHI18gT+Gengg5j5Fct/QoHhm0St/45SexA5c=;
        b=DLoOnw5fr+8y+14Dt89RQ5pN2+c74c3bUYrAaRz7qep+QsdWgEPinhdYvE0urKmVmH
         EuCQJIhIurlkJCvvE6v8eZi7Ur2zsCj8epe/PkwrpKt8csUsdmTaE9NLQoDYYMtAUxsO
         /8gvmr5jct1znlexa7ZCju2Fq5zIKkAIhLmMPbx9L14aHWFrZcXKZADrrnn54Op9pg5p
         vexAkxwabuQYinX7oeahT1izrxTfnPB8Uj1bFfPPvJCoEWZYLAo51eChC5TO+B8LqpTk
         P3fkTAbtBAMhGXK0KTG/lZdd/uIJ8mmc/t4WN0HHFs5sbBLhfqLT9C8FbjCP+ebWHHU1
         q0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724242505; x=1724847305;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u4kc5viHI18gT+Gengg5j5Fct/QoHhm0St/45SexA5c=;
        b=LXOhZOhdlKyf6/bVPFajy3YePCYEpOBVRIeCdcI7UWFeKQ9B7qo59kSy4N8jvRso4+
         xkqXNCZNJk4aedVL914KKP8PgzpiC63bM0SNIlJPCSU6/2Sf1wMt2IKxWoOujO0JtEcw
         VoZGTo60ZG4llyScb8VXBG+sjRLTLyzo/XU5c+Fs65VZgRVDhjsVccDpg89ahP2qMdwh
         9mK+wxKjbidWRA1dDv9Sc3qDOCEZBbQrKBXdGOWMNbgVLbwB5HFylPVlwwzauTql/ANI
         LhasY/JZVd7BrWB69NzBr050QrHq3y3/L5iZZgrAUQ5UqEAbVy9aeotl5xbxAGoKRK/0
         YxEA==
X-Gm-Message-State: AOJu0YzeUok9zJ/LDV1sgWGrwQAQhROitUk5pi303ZRQquB/Qt5XRTsF
	5hcMCiEVgw8uLxR+zGKWEmD8+vBPI/xKBhPnijOlpDdzz/O1wskpOtCv8tGwuoCk5mu7kzfHdJP
	0Yl4GCtNlBEZR2EzMAAqNwsA+KsqVPS2Ny+U=
X-Google-Smtp-Source: AGHT+IGoR0dTwbYpBN94+nLQDP+V/e8acYhgRccg/v+CVUPBuoYF/qenFxS0bHZ6dzmIig8Hek/78YQUP86qFFALzfw=
X-Received: by 2002:a05:6830:4184:b0:709:419f:2ae7 with SMTP id
 46e09a7af769-70df8a951f7mr2495829a34.29.1724242505060; Wed, 21 Aug 2024
 05:15:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com>
 <54a46d0e05c754fbc5643af2b576e876@manguebit.com>
In-Reply-To: <54a46d0e05c754fbc5643af2b576e876@manguebit.com>
From: Marc <1marc1@gmail.com>
Date: Wed, 21 Aug 2024 22:14:54 +1000
Message-ID: <CAMHwNVvAT-qeRvJ0jV2+5byHQnwzW9-YFj13ovXFC+M8hAfmyQ@mail.gmail.com>
Subject: Re: Issue with kernel 6.8.0-40-generic?
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Happy to help and assist where I can, but I have no idea how I would
try this updated code. I think it involves compiling a kernel and
applying the patch to it. This is not something I have ever done or
have an idea on how to go about it.


Op wo 21 aug 2024 om 09:45 schreef Paulo Alcantara <pc@manguebit.com>:
>
> Marc <1marc1@gmail.com> writes:
>
> > This has been working great for many years. Yesterday, this stopped
> > working. When I tried mounting the share, I would get the following
> > error: "mount error(95): Operation not supported". In dmesg I see:
> > "VFS: parse_reparse_point: unhandled reparse tag: 0x9000601a" and
> > "VFS: cifs_read_super: get root inode failed".
>
> Can you try the following changes?  Thanks.
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 689d8a506d45..48c27581ec51 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -378,6 +378,8 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
>                         u32 plen, struct cifs_sb_info *cifs_sb,
>                         bool unicode, struct cifs_open_info_data *data)
>  {
> +       struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
> +
>         data->reparse.buf = buf;
>
>         /* See MS-FSCC 2.1.2 */
> @@ -394,12 +396,13 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
>         case IO_REPARSE_TAG_LX_FIFO:
>         case IO_REPARSE_TAG_LX_CHR:
>         case IO_REPARSE_TAG_LX_BLK:
> -               return 0;
> +               break;
>         default:
> -               cifs_dbg(VFS, "%s: unhandled reparse tag: 0x%08x\n",
> -                        __func__, le32_to_cpu(buf->ReparseTag));
> -               return -EOPNOTSUPP;
> +               cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
> +                             le32_to_cpu(buf->ReparseTag));
> +               break;
>         }
> +       return 0;
>  }
>
>  int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
