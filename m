Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875543EF0A8
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 06:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781592306; cv=pass; b=n2lB2u/RIsqi+qXWH6udb5nvAgOtqH8Rtsk+AdPOUeNcvTMR/CvRB1JdVf4otDIpnikh/4NeJSDBt5V1uRodXZWiAXazEYmsH5MiyToxCyBhvu5/vzMaBMecLAkFhd1y5P3SUncUpnZ25+fJEItVQ30nB8Xvt8eGB7sZyKr62bY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781592306; c=relaxed/simple;
	bh=h8BWZhukDPKWYEcWVB4imfJcJSdpT09dzQYQKk5hE6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G2tZQufvDyhzVqcaNZs2ZmwcSC6y4HpRDO1qoZZJRDOdX1FAIwTg2q4GrNPlVXXZGCdQwHNiA1NQ7WdGRdU/hLsqgdKD5+nLlF0Tp17hgGl3WZuE791ORo1OTQ6ynZ4ii+QIYDF2vXNbyr2cegdzF5awLl9mziTtNOL2jC9Uoqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hZhCv9G2; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hZhCv9G2"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5177945a279so48321491cf.0
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jun 2026 23:45:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781592304; cv=none;
        d=google.com; s=arc-20240605;
        b=QlKpiCL07Lt7m/AHIYnPc7MHEjONigQtBoWRt96qNVuzEQfPt/5R6ugyaZWv3LlEdF
         QFO/sc1NsCOIN5boP8R7octtyqcu9dG3c0rkmOnjqUHhz6O2oQUZ0yIc2cAU6/ZWHujd
         UYX2ySExgTzwB3UpwQEpmA8lejnD21KXHtwaXE7fg7B7H80I2Zr51tjvCKmsLH1T7NKt
         e5gIvyezLvJ7fqKYTEM0Ls2UTyDMivyeuEfupTLgrS7GiDsAl5nvtCj3E05jtZWUrLUO
         SlX35kAssdwrk5010GLowJ87ZUocn/cAbtuRkfPU4JbADcnXoCo2xfIdf9yA5zH0F8vc
         CJiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bf+zwmySwkeXLeSl+xhuNlTRaDvdl7B5NZsumuyGKxI=;
        fh=xgc6uHn0ac/ZBmixSW5GSJHnt7fND5PKFdxnUqHQJkc=;
        b=ecx6oMMpjJoIBS08V6zYAr4On9OgGygjaPdHQSQjk+ksaqaZ9pLyXWUgzMTFt3k0RI
         6gXpr5FsZRWCvgXM97sKpYAocrzYSnmG5wGgDepNm+tOAgxDFN+Bcqx6tKDIjorJRhls
         kcP0mU7fjuw11yqYvDC9NOPpwyDOO3hJJGvdzuXZtPPXuTdWP/mChid62vaJ59amKuB+
         dttJohk60Vz8O8GGhFCB5n0jhlNkLoZnaVip4utderrEtn5FG/3oNgMebLuNRkchLU1j
         UzQI8iXXpLXdzFov/igZ+wivNauAQ+Ru1Q4XqIVlb3V37+DyBfQhv/h59iXBCuDXYLBR
         lYNQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781592304; x=1782197104; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bf+zwmySwkeXLeSl+xhuNlTRaDvdl7B5NZsumuyGKxI=;
        b=hZhCv9G2aOm3KoFGphH2FvnVWd1TM5V/xZwGB+Yu9McgR/S9MyE7RtQlquNH7K5XO9
         npLNwKlqRa15SWcHacjBqVJ51FnIbRWd/jaxxYmCDfDMOnw00fGaNVYwjW0a3R29gvON
         VhaonBYGwz1JF/ZatJ2Td1Wi1bzsmGIbQLOO2UrSLMY0BdmmrHoAFJ2mW4HB6TNMwqiU
         TSE2zBPjYbWUqUKOl/zm8g4LGHQhGQbltnSNy61FdJUTAPdBuxYNrDe90xzzLlKXWx3h
         z7KsGSq+m3N1LwEeni3ZN7S2zqqC/MadoG5mr2w8xSHbQyts+1uPYJ1Syp1v8JZx/BAz
         mN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781592304; x=1782197104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bf+zwmySwkeXLeSl+xhuNlTRaDvdl7B5NZsumuyGKxI=;
        b=VEDx1nRLZ20TNDT/kc6YpS3DOqkp+tIL2GY5ocDLJSmstXPwMhhVL5R/aOqozRJuHk
         9+ZHb/aVea2EkcpWk8TXTiUAtkPr8kaD6PxcFHHQVL815hP5IQDIKvsIOR5GBKPagasY
         c3UaL7bVanNbZVELBLSPTRnP1PbVpIezXSKelV3g3mJaGLmRswVja7smENLbHdM+34Q9
         YEKliI1SHaMxd8h69SsWTSfXDmpDR4UMYG8FgpgR+NM1k7Do27hwY7z4KUIE8p+biqsL
         mVHMacGjQmNSwVDSN4p2xgLXwcVgUOz1Gg7ZjVvz5JPz/otI02Fjp/H7IZ0cry2IXe9G
         Na8Q==
X-Forwarded-Encrypted: i=1; AFNElJ+2qr30QO+A+dTqi5U3Lku7sF+pQ8Sqo+ghJnf34OMQfvr8QF8eu3I8vL82tW0tK87Z5ai21dXBFoyM@vger.kernel.org
X-Gm-Message-State: AOJu0YweNDoWjFnAVnAGkjub+ic/eIZlaHevAJEXK/yMHfuZPdR03eaT
	sUt5LzFopONikgjZ/6ZKFMbmRkx++NakuxdVRe1C0gCnCzpi+1g3pOOayGoTlFvCWJCs/ZfjJ/l
	es2ajT0O4ShnpRqpo1RmX68f0xheb77M=
X-Gm-Gg: Acq92OFZPr4VqteYt6qX6UQkNrdnJoyf+XlAuqZ0qq8bHmEMiNubnfRkwdZ3h0rdzMP
	gpe4v8MkwqRLsZkTOQWHEUSGkHbY7isRIiMoygtmq/KMMIUs2kNv5LnSQZ0bTPy0NpiJH+zzmdB
	Gb2Dt9BCqlkmNzCCmdl2wZ4uff6Cu23ccVINXFSrME97ieFd9MJJZvgMpTVw+5g90EF2Bq6GAt5
	egC9HkKomp7OhhlvticOpOjDl3rbAGtKt1P3QxMWHPhtiW2oa6slJupRPjFDGiNVsKqlokyOwP5
	xeStQA==
X-Received: by 2002:a05:6214:2262:b0:8b7:4b46:1248 with SMTP id
 6a1803df08f44-8da1f8c6e43mr37349506d6.24.1781592304445; Mon, 15 Jun 2026
 23:45:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260616055357.3798387-1-rajasimandalos@gmail.com> <20260616055357.3798387-3-rajasimandalos@gmail.com>
In-Reply-To: <20260616055357.3798387-3-rajasimandalos@gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Mon, 15 Jun 2026 23:44:52 -0700
X-Gm-Features: AVVi8Cf-zHiVZV1KYiIlt9qwI1ztrXT82Iuxka7K70sXzBYh1_ZeGHxbLt2YqA4
Message-ID: <CAFTVevXiCtq7C8w6YsD4Q25jBvSw6b__NNJLexWCv=cgFDNCvA@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] smb: client: block non-reconfigurable option
 changes on remount
To: rajasimandalos@gmail.com
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>

On Mon, Jun 15, 2026 at 10:54=E2=80=AFPM <rajasimandalos@gmail.com> wrote:
>
> From: Rajasi Mandal <rajasimandal@microsoft.com>
>
> Several mount options (seal, sign, vers, ip, rdma, nosharesock,
> persistent/resilient handles, etc.) require tearing down the
> connection to take effect, but smb3_verify_reconfigure_ctx() does
> not reject them.  A remount that changes any of these silently
> ignores the new value, confusing users.
>
> Now that smb3_init_fs_context() duplicates the live context (with
> runtime state synced in) on reconfigure, simple !=3D checks in
> smb3_verify_reconfigure_ctx() are sound -- a difference between
> new_ctx and old_ctx represents a real, intentional change by the
> user rather than a spurious mismatch against init defaults.
>
> Add comprehensive checks for connection-tied options with clear
> error messages so the user sees why the remount failed.
>
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 141 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 141 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 576a78b6d0cb..d5a7d4dd402b 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1070,6 +1070,147 @@ static int smb3_verify_reconfigure_ctx(struct fs_=
context *fc,
>                 cifs_errorf(fc, "can not change nbsessinit during remount=
\n");
>                 return -EINVAL;
>         }
> +       if (new_ctx->compress !=3D old_ctx->compress) {
> +               cifs_errorf(fc, "can not change compress during remount\n=
");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->noblocksnd !=3D old_ctx->noblocksnd) {
> +               cifs_errorf(fc, "can not change noblocksend during remoun=
t\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->noautotune !=3D old_ctx->noautotune) {
> +               cifs_errorf(fc, "can not change noautotune during remount=
\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->no_sparse !=3D old_ctx->no_sparse) {
> +               cifs_errorf(fc, "can not change nosparse during remount\n=
");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->nodelete !=3D old_ctx->nodelete) {
> +               cifs_errorf(fc, "can not change nodelete during remount\n=
");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->cruid_specified &&
> +           !uid_eq(new_ctx->cred_uid, old_ctx->cred_uid)) {
> +               cifs_errorf(fc, "can not change cruid during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->port !=3D old_ctx->port) {
> +               cifs_errorf(fc, "can not change port during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->min_offload !=3D old_ctx->min_offload) {
> +               cifs_errorf(fc, "can not change min_enc_offload during re=
mount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->echo_interval !=3D old_ctx->echo_interval) {
> +               cifs_errorf(fc, "can not change echo_interval during remo=
unt\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->snapshot_time !=3D old_ctx->snapshot_time) {
> +               cifs_errorf(fc, "can not change snapshot during remount\n=
");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->max_credits !=3D old_ctx->max_credits) {
> +               cifs_errorf(fc, "can not change max_credits during remoun=
t\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->handle_timeout !=3D old_ctx->handle_timeout) {
> +               cifs_errorf(fc, "can not change handletimeout during remo=
unt\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->got_ip &&
> +           !cifs_match_ipaddr((struct sockaddr *)&new_ctx->dstaddr,
> +                              (struct sockaddr *)&old_ctx->dstaddr)) {
> +               cifs_errorf(fc, "can not change ip during remount\n");
> +               return -EINVAL;
> +       }
> +       if (!cifs_match_ipaddr((struct sockaddr *)&new_ctx->srcaddr,
> +                              (struct sockaddr *)&old_ctx->srcaddr)) {
> +               cifs_errorf(fc, "can not change srcaddr during remount\n"=
);
> +               return -EINVAL;
> +       }
> +       if (memcmp(new_ctx->source_rfc1001_name, old_ctx->source_rfc1001_=
name,
> +                  RFC1001_NAME_LEN)) {
> +               cifs_errorf(fc, "can not change netbiosname during remoun=
t\n");
> +               return -EINVAL;
> +       }
> +       if (memcmp(new_ctx->target_rfc1001_name, old_ctx->target_rfc1001_=
name,
> +                  RFC1001_NAME_LEN)) {
> +               cifs_errorf(fc, "can not change servern during remount\n"=
);
> +               return -EINVAL;
> +       }
> +       if (new_ctx->got_version &&
> +           (new_ctx->ops !=3D old_ctx->ops || new_ctx->vals !=3D old_ctx=
->vals)) {
> +               cifs_errorf(fc, "can not change vers during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->witness !=3D old_ctx->witness) {
> +               cifs_errorf(fc, "can not change witness during remount\n"=
);
> +               return -EINVAL;
> +       }
> +       if (new_ctx->rootfs !=3D old_ctx->rootfs) {
> +               cifs_errorf(fc, "can not change rootfs during remount\n")=
;
> +               return -EINVAL;
> +       }
> +       if (new_ctx->linux_ext !=3D old_ctx->linux_ext ||
> +           new_ctx->no_linux_ext !=3D old_ctx->no_linux_ext) {
> +               cifs_errorf(fc, "can not change unix during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->nocase !=3D old_ctx->nocase) {
> +               cifs_errorf(fc, "can not change nocase during remount\n")=
;
> +               return -EINVAL;
> +       }
> +       if (new_ctx->intr !=3D old_ctx->intr) {
> +               cifs_errorf(fc, "can not change intr during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->no_psx_acl !=3D old_ctx->no_psx_acl) {
> +               cifs_errorf(fc, "can not change acl during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->local_lease !=3D old_ctx->local_lease) {
> +               cifs_errorf(fc, "can not change locallease during remount=
\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->sign !=3D old_ctx->sign) {
> +               cifs_errorf(fc, "can not change sign during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->ignore_signature !=3D old_ctx->ignore_signature) {
> +               cifs_errorf(fc, "can not change ignore_signature during r=
emount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->seal !=3D old_ctx->seal) {
> +               cifs_errorf(fc, "can not change seal during remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->nosharesock !=3D old_ctx->nosharesock) {
> +               cifs_errorf(fc, "can not change nosharesock during remoun=
t\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->persistent !=3D old_ctx->persistent ||
> +           new_ctx->nopersistent !=3D old_ctx->nopersistent) {
> +               cifs_errorf(fc, "can not change persistenthandles during =
remount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->resilient !=3D old_ctx->resilient) {
> +               cifs_errorf(fc, "can not change resilienthandles during r=
emount\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->sockopt_tcp_nodelay !=3D old_ctx->sockopt_tcp_nodela=
y) {
> +               cifs_errorf(fc, "can not change tcpnodelay during remount=
\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->domainauto !=3D old_ctx->domainauto) {
> +               cifs_errorf(fc, "can not change domainauto during remount=
\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->rdma !=3D old_ctx->rdma) {
> +               cifs_errorf(fc, "can not change rdma during remount\n");
> +               return -EINVAL;
> +       }
>
>         return 0;
>  }
> --
> 2.43.0
>
