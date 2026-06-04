Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BF547F2EF
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jun 2026 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780584136; cv=pass; b=fKu52AOTxZ6KrMWC/4+7942lZMJvy5Jmwqih7nPo/e1vlrsUhqiC8LwYM9X0SyhLuz8B59E+2z0af9xyPBmLKG+S0LYrrso7RlkRS4XTshsmVaWbQDZXRYRWV6MI3AyZCu5uPRHnb54UmEpv1pszeHBVYLAsqToxAfQZ5+GlG20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780584136; c=relaxed/simple;
	bh=he6e+WVwAzYLCUe9UIdRMzTaizhoArYuWdYgpJCfRRc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T5WbdPKlmNQJ6ykiB0h6IpU94Uc0YmSH9vll379RjBmyCRUAJ7UEAbW+F3RUjngHgRkvOBFJZD/XgaF6Yt1V2bDBDPhcJ7d/XlCZQgZiwR67PJksRTwflvgGrQpEClcRlvKp0GCH1blETy2kIg69sPUC175LYnly/vArXxPQAyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WzuvZ8Uj; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WzuvZ8Uj"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5175eab3a93so5895201cf.2
        for <linux-cifs@vger.kernel.org>; Thu, 04 Jun 2026 07:42:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780584134; cv=none;
        d=google.com; s=arc-20240605;
        b=C1/dUo7s0gjATyHAVSQqz4XPwebd7glirfBYPlsbwhKYdcjewiE7fS+8f3aXbbVfnm
         tt+I3Yi5N2hhy2aY3TialcRChNh2Y5cjD1kdqI2ToDWqluMRNvAS6POnVwdsMbogpHNG
         /WXE017vJBoyg/wRt6WthC0fnu87mqOcaOgCZzRFBgfTCQhygsq9Nde6Vr8Q2om+VF7t
         1zRW/wLT7h4o1KtuiX3nQ2vAVt1m7uydEszCok/SS80cMpNv7z0TwDhhQ0TzQIp1+zdZ
         RT3HBOwB5RvGLrsSGCM+LV059xhOj1ZsBFPTVfrwwtJlCxZ7KzUWrZJNFj/zwJoEnhJ+
         DiyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A1EpBYxXVmB8MXDdBiRBy0CPyHYr2ypwkVTdrEESssI=;
        fh=aorcWbxMKsNrBwSXUbgZT95kUtSiYzIucN49pcti88I=;
        b=S/PKJDlUKFL1PaaZTXWXhdDequjyIIv1E59uk1xvKKUpaV4WSsIW6pDoWFF2IWJuaE
         z3gFigGN8V0Hb5VbsU2tqTfaF5mj9f0/cfKbiIJwoM3k/oqIkY+zcMtkgnfM5477t033
         5j6Lv94b+ZaDyffQi+r5yoZC5X+itsElO1AlQlz8abJp8IEPNWuj2t5q1kf1hgHs0hYu
         FH74K7eyTuYJsVNigEYcTU8MmYCNazzpLiuZl5rt6pccDdUZRJD5AlljiEBMQ4mAJRB0
         NEYFTTbZ84S+BMzpNt4hj65ENf6/c9YG1Jr2L0f6auQYdLiojflPb5Lt8dfgdNkrA4ln
         OFyQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780584134; x=1781188934; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1EpBYxXVmB8MXDdBiRBy0CPyHYr2ypwkVTdrEESssI=;
        b=WzuvZ8Uj6Ftsc7gtqqpPjV7fXW1L4l1hUD98g+oPQE0YdK4O3aE/ASOeArJJ0bSanE
         zcVDtocWKooNZ0ZMvd9llIr/YX1xjeh+o5Irtd0v0BUoEaZxFIULVAHvIRUR+20hZNfG
         zGoOLzsmKPbp4rCJfF3eMSIx9AK0fCqVbdDQzWQEiFjlwe8hj6JK+fAL7SSnquZ/RPGy
         n8yMxfV7SsFrXVgKHRSjYKHMvtGXir8vyAs7DQOBab8J5CO086ACCd91Y5gg/qqE0rXY
         gRDKtMN+vLGuUGZUqfiOxjSG0HplE17Ioh7gtxFS0N55Yebt2py6IiXoJUuTAV/7XGOL
         4kLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780584134; x=1781188934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A1EpBYxXVmB8MXDdBiRBy0CPyHYr2ypwkVTdrEESssI=;
        b=UFcxqY4mqiQFIUNhr4v7b8020Sww9LKnSwFot8WTf0QrtDw09AF7AKqgZ8TwMDG0s/
         4CB9JfHvYzFLCxjvnaPFwdXkMG1v0jNJWYn3S/LxrS+Q3NndAo4ct3E94+t/tYytAAnv
         EBiABNJ5w3yXZXAKlMiTqtK0sruLni4AzhmSl19duqXsZ4SAJu5IOZx0EaSQE+qkNszZ
         euYub4f2vRyDYGEMEN9FpRA3nm9eK4WRlAASvZfqOQBKeNQOZHfT3PWE+HieYGsNnIgX
         IdPbNTBXAZIDTvtPUz8aBJKEt59OtDfB/rp7T3XEQh7KsO0rsRRxRB9KvEt/SCSKwpK0
         Hw5g==
X-Forwarded-Encrypted: i=1; AFNElJ9dxkZrs2VpsD0F8t5G5jxDztagFN0tW911BYJGi0XLlsl4sSfnqqoHvQhFjl3xQZhLKI5nOATHGxQB@vger.kernel.org
X-Gm-Message-State: AOJu0YyVq5lUCCrFfEHR9FrWsvyNG1m73jCvqyE6OH4iA5ijMD73BmaV
	ZKhiIntTmazN5FTQccCubJHOJT9O1I7b4N8U6hXaP5M/EyfahmADKWL2ocks7eJWM/TEXfv0qhN
	oMytEPQcsOSio1ZIRgQn9YI9Dn6CYmGo=
X-Gm-Gg: Acq92OEaTn/kd1eZsf88fZSdjQZRY/V4GyTWhsljow5xI/NpqxRN8JTIA9En9sOOagO
	wN9VzU9PcyOg2Sf2jo9yNTdYZuUDURX6jR37CmujLFbRuW7/BxJpHmM0ewYA44p7tdUlTeGLHno
	69BoIGW8IKGsOo32a50gh9mYCht7Puwm49tW8ZsuHwskMN+xpqrGYRPARZAxve96e8bClF+eirh
	hAZb1l2mGn/mb2RThxTQrkIrFufmuGTHnjG/ljrt8gP8Te3WHI/2qu9tfKboUq1WbnOIY3svPcz
	mCt8HPHKwrOTY4yLwyY=
X-Received: by 2002:ac8:7d0d:0:b0:510:138e:b83c with SMTP id
 d75a77b69052e-51778694e0emr113859411cf.33.1780584134444; Thu, 04 Jun 2026
 07:42:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1779371115.git.rajasimandal@microsoft.com> <2421f42fd19e97a595262946def5131aa1ed1ed7.1779371115.git.rajasimandal@microsoft.com>
In-Reply-To: <2421f42fd19e97a595262946def5131aa1ed1ed7.1779371115.git.rajasimandal@microsoft.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Thu, 4 Jun 2026 20:12:01 +0530
X-Gm-Features: AVVi8Cee_Cem_CmdgYimEME626Rbct8M27UrCmxa6uIso2Gn2ynnE0FG7FDOlB4
Message-ID: <CAFTVevUnVqB+q3XtiRoKiFWgHYOwYuyhpVHu=Q8uAxNMKZhqHg@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] smb: client: block non-reconfigurable option
 changes on remount
To: rajasimandalos@gmail.com
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>

On Thu, May 21, 2026 at 7:24=E2=80=AFPM <rajasimandalos@gmail.com> wrote:
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
> ---
>  fs/smb/client/fs_context.c | 137 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 137 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index b93d6ef13463..0677aad237e8 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1069,6 +1069,143 @@ static int smb3_verify_reconfigure_ctx(struct fs_=
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
> +       if (((struct sockaddr *)&new_ctx->srcaddr)->sa_family !=3D AF_UNS=
PEC &&
> +           memcmp(&new_ctx->srcaddr, &old_ctx->srcaddr, sizeof(new_ctx->=
srcaddr))) {
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
