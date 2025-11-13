Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9616325A33F
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 01:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762997039; cv=none; b=kDLu0q1/RsLZRJoJOKGJ015uVYPw7ohIUIlbFXnjMyYp/bz7ww56PQ+tIaBWPjdy5TFSV2tOKsJKMv7bTHSYtnBDNaewuLJDOjl9bXaCAYNEfGDTdgLje21nD4A98INfHHIov6SKkK1ArBGrrAFnvVKSR152iolBRK2S2oFyjqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762997039; c=relaxed/simple;
	bh=VYVCX7GPtJjuE+GgDCKLrXkBDv0CP9xP5mPuO/bZz5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T/ADMvyPYDKLXUrf79AxbA7Uug0XX2GooDO/Gj/l0iSEA19fJf6KE4G0WB6MvTdWy7SMS2Qnc1ahOsDS9645KrdDubVNrW32ojeSPlJTG5z2kWGhetxkYb0AuoHUsLZ6JJKK1VFc/IWgBACvXW8zX/NwchSjynQZtJxJ9WuWv2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qimOLV6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qimOLV6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE9BC2BC87
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 01:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762997039;
	bh=VYVCX7GPtJjuE+GgDCKLrXkBDv0CP9xP5mPuO/bZz5c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qimOLV6IgiQ/vtwsTcmqONYlgtdYjqXS+SBjenNwf4WsFjd/LA5jQiOQe+a1m5m8s
	 7J5hwobGj/s3DiKPgmGqZdk6T1/sDQroSsK2XHFkAd+BAly5srHfNX7PfpI9epR54b
	 KSLCx3rGSitDA+nb73J0vFkaTVlI/B8FuR/5wOXYNoOPT3SASYNPQ9Qy052xTbOvX7
	 IX4T3I7ur8Tk0pz8TbgMa0fvxS4rW73pK1Y2YpUnmatHa0WuFC55tNB0m2E903B5AU
	 ByJ4f1EkqctHZ+b11L1GLuSkvG/riHnLtQyjtapfZo3TEbKRcOrwHuw7SRusYFa7KL
	 elzB1xSvb+BPg==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64175dfc338so485892a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 17:23:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVGm1v0nvqHApjrlgj044TZenaeklAVbmt+pWMygR66WsVVGzFGFA8BJxbBCgZ4KqF8Pbs+e8pzRlGH@vger.kernel.org
X-Gm-Message-State: AOJu0YxTBAP9dkNrbRnYwcLHF1ONSJeMkW7hiEFGZtaV1RxVbXPuwWUU
	jVHtE0+T0Opypg6kPD25tBs+lKDPwF5OG6IfLSnScGVyHMh7iosvKFSIFuDk88CTj6Y5tsQ1Ix3
	5da/43kvq2QvHZvDrSh2rCaHx4TbzxxU=
X-Google-Smtp-Source: AGHT+IGEsa6QU6NH+dn86hp3h/tM2rUVVmZtnqxarHN5u+paEPhFru5BCQNU14p+2Wc/fDSbHzO5VPaAWwvsacyUEuU=
X-Received: by 2002:a05:6402:26cb:b0:640:c640:98c5 with SMTP id
 4fb4d7f45d1cf-6431a584ee0mr4668463a12.34.1762997037892; Wed, 12 Nov 2025
 17:23:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev> <20251102073059.3681026-13-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251102073059.3681026-13-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 13 Nov 2025 10:23:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_n3D=CC9DfVTak3oQa3xqkQ2jyHm9sUKDLd=exJAuXJQ@mail.gmail.com>
X-Gm-Features: AWmQ_bkqXjNzTD1YuzK5pU54qQgT-nuarTPHum9OF8Gyr-6AHVoR3Ynhe-xkUUE
Message-ID: <CAKYAXd_n3D=CC9DfVTak3oQa3xqkQ2jyHm9sUKDLd=exJAuXJQ@mail.gmail.com>
Subject: Re: [PATCH v5 12/14] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/fscc.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 2, 2025 at 4:32=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.dev=
> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Rename "struct filesystem_attribute_info" to "FILE_SYSTEM_ATTRIBUTE_INFO"=
,
> then move them to common header file.
>
> Calculate the minimum size of FileFsAttributeInformation using offsetof()=
.
>
> On the server, replace original "sizeof(struct filesystem_attribute_info)=
"
> with "MIN_FS_ATTR_INFO_SIZE".
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/cifspdu.h    | 10 ----------
>  fs/smb/common/fscc.h       | 14 ++++++++++++++
>  fs/smb/server/smb2pdu.c    |  6 +++---
>  fs/smb/server/smb_common.h |  7 -------
>  4 files changed, 17 insertions(+), 20 deletions(-)
>
> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> index a9a853b9011f..2c454e450dfa 100644
> --- a/fs/smb/client/cifspdu.h
> +++ b/fs/smb/client/cifspdu.h
> @@ -2063,16 +2063,6 @@ typedef struct {
>  #define FILE_PORTABLE_DEVICE                   0x00004000
>  #define FILE_DEVICE_ALLOW_APPCONTAINER_TRAVERSAL 0x00020000
>
> -/* minimum includes first three fields, and empty FS Name */
> -#define MIN_FS_ATTR_INFO_SIZE 12
> -
> -typedef struct {
> -       __le32 Attributes;
> -       __le32 MaxPathNameComponentLength;
> -       __le32 FileSystemNameLen;
> -       char FileSystemName[52]; /* do not have to save this - get subset=
? */
> -} __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;
> -
>  /***********************************************************************=
*******/
>  /* QueryFileInfo/QueryPathinfo (also for SetPath/SetFile) data buffer fo=
rmats */
>  /***********************************************************************=
*******/
> diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
> index a0580a772a41..9d3ac9903357 100644
> --- a/fs/smb/common/fscc.h
> +++ b/fs/smb/common/fscc.h
> @@ -94,6 +94,20 @@ struct smb2_file_network_open_info {
>         __le32 Reserved;
>  } __packed; /* level 34 Query also similar returned in close rsp and ope=
n rsp */
>
> +/* See FS-FSCC 2.5.1 */
> +typedef struct {
> +       __le32 Attributes;
> +       __le32 MaxPathNameComponentLength;
> +       __le32 FileSystemNameLen;
> +       __le16 FileSystemName[52]; /* do not have to save this - get subs=
et? */
Is there any reason why we can not use flex-array ?
Thanks.
