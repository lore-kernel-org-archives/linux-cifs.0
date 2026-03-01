Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFF1158DA3
	for <linux-cifs@vger.kernel.org>; Sun,  1 Mar 2026 17:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772386914; cv=pass; b=btePlqQOKjg5o8D8HK88wXl9vT9cFuv8fw4gGZKRFSjR/nART1MPuTbtc4jm5ciqXLSTi6A0tAmWLyhtBCiX6u2OBSlvKPr4wNLJxXIk+Ub26LnjfYJX9nKxj6S7JVh4cj3mQFp4beTVL1f+3TMjJ0TA+7mbj8DZtUdCEax4qq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772386914; c=relaxed/simple;
	bh=yO4ui74El3JfEF+mf9wBkuYyLKYfAtY1Xv3wPVXWOTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p58lFK2ObMQ7HcR5iNS34cvMJyC/EAi1eASD6ARCrHTMP0Ib837GWgESJc3MQPtyNuaW7gb5PZAnfdb5g1qIoMt/WLvRtietQ0r/1Sk0A1VJgvUkLlqMUYPHUt08Y8p7QqeY06JDcvZBuYYnKcoUDp/50pMeiRz/qdpTnUyYC3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f6pyTcOY; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f6pyTcOY"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-899f27df3d1so6127816d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 01 Mar 2026 09:41:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772386912; cv=none;
        d=google.com; s=arc-20240605;
        b=brABU9zJqMJ7u8LvdylO0FJzU96K2iAeN54+CktAQeCTGajz1dau/kvlvh1SOS3q4o
         x/OQalbSfszFuP8nb77lPrlX7BULc5030AHLvd4IZg1rPKs38FuqSPZa0sqkVjfrmIpF
         /Aw9NZYuV7spPffx+HGAbw0sTqTRHTakdy5LlXogSg5W2kt9AVAzKl/UPWY1Z07OjJDb
         7zFA+FVfhStdhT2dhuGCT2j4T/Nbd4p857jTP9kzA18q8mhiLbWd+E2KdOxngQquAPBp
         HdpTuWfTuuT0d/m5eeuepFvjTGUtso0RFJ2MkMotZnSlEc94/3BmdF6leLkn6iysc/ZS
         MPBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r08NG6IHHSJG7XkYCJYRfi5Dhj5CV7L6DwIhqk3VcX8=;
        fh=6Wq9p3YRTjLdI4HUtUwbIXv35kTPl+klZC2Wac3bRJE=;
        b=M6Wcr5Uz3pwJAHoiIgVQFc81c47HiagykHadsFoBBLcY8jD4a0ZH/5iXa3+grD+Uj3
         w4ldrsNwDpv1U0ELMnxiA+rUeMcU3A41CMtrehZMBaWKDa9JjkbmeXAB/kzyCkmic42Y
         1imdpDBgrjTUaak4qDNQ6o00gY9ov8GZDPyjRSiEe6ffJlBtHn/N0IacqmopeK4rfQBS
         nwoEzsBZ+xNtGwvTPs2ltwTTEZj++EgQP0M1MncbNx2hJoPOcr3EdO7BAFd2fQ3Xs9Nm
         gF4kh/FEzaMt1gnIAtWp5zSgOjwIG9+RW/H8UsdmtSdDiiW7sIuAAwmJ4kgSJpMIFd4q
         vs9g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772386912; x=1772991712; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r08NG6IHHSJG7XkYCJYRfi5Dhj5CV7L6DwIhqk3VcX8=;
        b=f6pyTcOY5dMXOt9cBkzqr2wLTJiP2Ql8/vF/D35/EPYcO5fHf9XzxLwF8YpON8XEag
         m5KD2fgDxiEove2avadNf9QzxykIcIKA2DZTaI+u9JNOSqhZQnu7AZr4hhtmgQb7fmdK
         bqwxK7MLEEVAyMn2uiEFG9EZAbctoncgmmNXqgor1SUVMi2AiZn67QcR6mjZBmWK0R3/
         l+SZ8uQ3Jz6/5pBnnvkQG2g6SntrtiBARO5OUJrBNnUSHoS3Q9I44kShsRbU2U7pnpk9
         e7Z1Ol8l/EeVdr6Yrn9I5V+/D0aYmukAg0tw6HcO8jRKLp4nCYkcEZ3+EKuBEKMGrXug
         VxYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772386912; x=1772991712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r08NG6IHHSJG7XkYCJYRfi5Dhj5CV7L6DwIhqk3VcX8=;
        b=OiyXKqp/ftvS8HW8r+OhFfKHTmHddQ4MXPcgvdwt1ThilkuTW3Gyg3s09OgblRPS7v
         uAi+Z/yKMui34EjCtQF6OSVvaLVeIy2yV+Iw7S+KflUn77EoYRIdexj1ffUNwyRe+Okq
         SEzAF0gZGx5P84mg/oSXpBGeitUGtRHwKctep9lhRWnvvt/4KsplK1UyUHvMP3g6Rn5r
         DVuLV+sGYJz+ZE5t9S1qquIRZztTIuf8Zw4gobV+M/F2IrRkJUEzx91pXSVLR/ZjtKGI
         GglFJ3EROXSvU30JDAeEVZ1KNPXeTR0iJ9K9Rvkj8lAw66vEzHgIRkErd5zg29VefTv0
         jjRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWALh/LlxpzA/EdrY5YRVlhkHlhmASvJ0UYK0RMW3KkZB+LNv63dRa+xrRQU4lYiFkSLA/m2PnSeO7f@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc/EdITngumAWo6VNTWOw1RQQBebcHwdBY9zND8LAwF9j1uc/8
	pIZAMW/dg4DshN/XNOrAX/1zP0RBsoNY1wdnJ5QOmNvGVAuOyLNDi308f0bIGEkyWRNOCg1oTY2
	xeLMB0X7XXEF+KoQoRT5Iv3Vt9XOUpsU=
X-Gm-Gg: ATEYQzyO5P/2FPD6dPQbNMB8M7qFYtzRDT8XI8BNoeTJxTQ80c3Z8YcSLdqBYXSyv3q
	gwGr6WlqGs1Y8Gv8MldzV9az7dWZrwPmfPAKLh6WMfi9I6mM7y5Il0x3Ded1Dlm6qhnbWN+dcIN
	npMxZpuwvzmQaDD1JK7ihaUa0bkpI6BU0+ITllHuVNbznxe0bawM8ERaP3eJZMZfyGTPwFajuAp
	5Vf3H+K4ioNiJ8Gh0CHfwV26nEtiTMYY9wV5f4xX4dyJddyJeijJ7ujJaqpI97Qn1hA6zh3hF4j
	hRWp7Q0QK4Qieu9r0WFyDjRkEIVbHZx+E47iQ+zlzHLtQ3+LVfuO3RJcI6m9zMiVMeCUh7lw4SY
	lWBqAurnmD2RpYNjXyYviMxVbn60U+hXQjKEsagQG1W6RTCI9MiAaWBN9w/A=
X-Received: by 2002:a05:6214:2a48:b0:899:bc44:7566 with SMTP id
 6a1803df08f44-899d1ebaf9emr147568366d6.35.1772386912305; Sun, 01 Mar 2026
 09:41:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260225041100.707468-1-zhang.guodong@linux.dev> <20260225041100.707468-5-zhang.guodong@linux.dev>
In-Reply-To: <20260225041100.707468-5-zhang.guodong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Sun, 1 Mar 2026 11:41:39 -0600
X-Gm-Features: AaiRm526Z4o_U9XUzLBirQ29uu5IhREKREJ2qNdhMbsYEa1dTM9t1y6fBy1XlIY
Message-ID: <CAH2r5mvT=+kCSgsH5FjTVf8U6e+CF0K29ea_d=g4wXiuBAGijg@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] smb: update some doc references
To: zhang.guodong@linux.dev
Cc: linkinjeon@kernel.org, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added to cifs-2.6.git for-next

On Tue, Feb 24, 2026 at 10:12=E2=80=AFPM <zhang.guodong@linux.dev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> To make it easier to locate the documentation during development.
>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2pdu.h | 7 +++++--
>  fs/smb/server/smb2pdu.h | 5 ++++-
>  2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 78bb99f29d38..30d70097fe2f 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -224,7 +224,7 @@ struct smb2_file_reparse_point_info {
>         __le32 Tag;
>  } __packed;
>
> -/* See MS-FSCC 2.4.21 */
> +/* See MS-FSCC 2.4.26 */
>  struct smb2_file_id_information {
>         __le64  VolumeSerialNumber;
>         __u64  PersistentFileId; /* opaque endianness */
> @@ -251,7 +251,10 @@ struct smb2_file_id_extd_directory_info {
>
>  extern char smb2_padding[7];
>
> -/* equivalent of the contents of SMB3.1.1 POSIX open context response */
> +/*
> + * See POSIX-SMB2 2.2.14.2.16
> + * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb=
3_posix_extensions.md
> + */
>  struct create_posix_rsp {
>         u32 nlink;
>         u32 reparse_tag;
> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
> index 9b3c4c9acb11..e7cf573e59f0 100644
> --- a/fs/smb/server/smb2pdu.h
> +++ b/fs/smb/server/smb2pdu.h
> @@ -83,7 +83,10 @@ struct create_durable_rsp {
>         } Data;
>  } __packed;
>
> -/* equivalent of the contents of SMB3.1.1 POSIX open context response */
> +/*
> + * See POSIX-SMB2 2.2.14.2.16
> + * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb=
3_posix_extensions.md
> + */
>  struct create_posix_rsp {
>         struct create_context_hdr ccontext;
>         __u8    Name[16];
> --
> 2.53.0
>


--=20
Thanks,

Steve
