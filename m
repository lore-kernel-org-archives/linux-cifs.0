Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D85286D4D
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 14:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776434771; cv=pass; b=psRbi06lX51lEDQKfbvMXdjIkd2y5PVfAcrw4M2XiXMsHHOpmA/6RccQfy8E2w7uYIJmMjexx6VzBrEKC6V/Hx+gAboow5WvNyhra0rLym6UgocvIemfNyEq1ACkNY/tf507syOooitVdyeT5eg7W4zNIayj6eYfapp7UCmy+3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776434771; c=relaxed/simple;
	bh=b63nMkN0Nxrh2Z1I3AHtuEMRSduxRTfXioJLSIjSsVI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HpYLZlM6pvenZRygXkgfuulEopK2GQ7/2wNBlLFb6ToVSldw614COrMG+iztFsV41nOVtwZAel6Mkou90d26hV4Bq/Xbme2EkXcPfAzpO31uDAx7efrlfmpRpScUFzfboIbVmCna9VrhgRChY8AT+rVCHV7j2IGBG/kMwuvDHUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I9YNXxtn; arc=pass smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9YNXxtn"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7dbe437b072so401611a34.2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 07:06:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776434769; cv=none;
        d=google.com; s=arc-20240605;
        b=gli0Hp1zolA/UsB8a8gDR5vjgpaGD9JiFAooA568c2fiAvdAHdR14F9D6Y8ueya9AR
         BBsZOI22OjVzKxvXs2IEo9h/ho4bEIkhQ7xFqjuxJ0eTz2VVGKZB5tY+8Lz0EgZIPd9K
         ksbOuBzJuYfo4kL0I4npiYY2BgHEOzkuLgeXV+X5IiF+NAzM5pD4y7VH95Bzt1BQDSAd
         5IKXG55127KtvpGMe15302AMZPquMn8wptCQPkdGMi1f4kG9q/FNd55tPu2biWBPtbx6
         9oGzMfYwCPBUC6DDK35lOoWaiBO4xwr5fGQm/4PHrDXOytikdcXtFP5zdjIxfNXQUfyc
         aw8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0IoZ3XKLASKqQdfITCB0rGNRo5K/rmoj4rwT4vdw62g=;
        fh=WzBfaBSv+mwOgFrnnFMrqQthsRY4Zy4ppjhxUWSWJEw=;
        b=Ml42LSg7pK/F8Im2gbn0eon67gDbPdH20XO6NsWA/IU95lg7l+U3yFQHurI3AaEUvM
         YRLGUm75MhPrI3NEXqxbrDmBtQwyL46oESImaBOaqaYfdObQ6GemBWrOUcgL0d57CNk2
         Xf6MxVNYBgcGF/TNGkNl9QC0/3ASY3DVxmfv/66nzyLWbrRO5grqJA/q2MrHxRIZ5VGk
         qeo4pBK5HEk6qe85V0xnIuAQqxknU3EmwhddaSxfHEIvJzmfr7Xlpygugt+NTQL9oR86
         ZXMKWFOFYpqy4D8MtvoSbciaeDt6vJqtZnm4gmdda5mt/OKZ5DSoEp6qfCQ0pN++1OhZ
         7rHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776434769; x=1777039569; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0IoZ3XKLASKqQdfITCB0rGNRo5K/rmoj4rwT4vdw62g=;
        b=I9YNXxtn9MwNim7Gui1tWDWqIFltnH+x7lJj7QehfywJ1bO9/Lz4K+S8oeE1hpwINi
         7MbFD22alNavJQBDiwDoR/ISdjUspRgKOI+cDEZCYCl6iMxFabo1Qi+LteCR4tjKIM0W
         tneKHsq2Z0orOJYs5eacgKsXPRWpIo2NLKcMk3iK2Ltv8KGVbIL8kud5v21EaeZisUx9
         yW2Nl3E40exOItuzlDHwGOy/8AOdLYot3BMcDbKbkjYsKdg1kR3QCfhER313YrZSYHyl
         QnpCKsVV7R5UogfV3Xx88qgwJtu59UMErzIFGCYOo9lDp2qrIOaH96wrzL2WezWPXHx+
         dXeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776434769; x=1777039569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0IoZ3XKLASKqQdfITCB0rGNRo5K/rmoj4rwT4vdw62g=;
        b=rkqHBnpqCFXKjvDUaNyA5jze03uC2BtOXbQekze654ckPCgCPHIBi6G8WKyAjIxxxj
         HRCyowDc0ukBw2p5V5H28mtViqgUwqQ57oatmZ3TYyhjK548OTJY66RMzS6JobjWUFjf
         IOv6htYHs3h9v4DK/XJHikr3hbGICSJCYVEWCFj6NU6cTCfK1RS+YA7c3x7zO/sIEGCX
         NAMg1QBjAKbkPmnd9DrdZQ+EHFRIz9bEEQPAEDGyX00P7+hw6dULXkaLcUcfOKE9ZzW8
         eRI4jXDpKDQHXshSjvsb2oSRj0P34hobQmT80LLS7IcfmenGP1ITrTKJlo7eShS0Nj6H
         EQCg==
X-Forwarded-Encrypted: i=1; AFNElJ/DExDfwoLQWSSePyTKyywj4rUpcHmwiFBRP2wVNN4fXiIIIZpdMd8gMhUdyexhdRyON7cXgoXANb6T@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7ydgE9iGJFiythGDywm62k8buFa2nSiiEsMPP1jnkzDKJbwCq
	cRF9Zn8Rz7ED82Kxdqe4O7m0R9gRMDoooqxBsmzSxdxcfkA6twY5yuXLAKID28rW7MjqH6tY1uD
	aapF1tm+2jBjMXcy5QvW7ErIywjpaOFI1/18Z
X-Gm-Gg: AeBDies2iWdTHeacLNxUCmfEYDLd7d+wdKb0WhN5qgiD7jKWukVnyhSBfcjj9pDRI7C
	qKQCZHOGYmV1AG8QtKUAu/xOYds7WHQYIFBR7xidV9PQTApWKWdRH2aoYcjrOJu2+5rxiHbgWRS
	+XvyiXRmHb6aI8HQU5C1ygcgNxldMB2vZzU0OZgzxHlkloJilmKeo6oMh/uYyjse+hzy371ix7F
	owbX65vN5+QrIs3gwJiykCYQnuuxVcX8dKwD5O8Xya1XZ5vU4DOnTYrt3K/mvwCX7wy6Sc1BgP7
	M8Lcrfat2qalFM7R
X-Received: by 2002:a05:6808:1385:b0:468:776:1e91 with SMTP id
 5614622812f47-4799c88caa5mr1450086b6e.19.1776434768703; Fri, 17 Apr 2026
 07:06:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260409095926.905020-1-rajasimandalos@gmail.com> <20260413073249.2897840-1-rajasimandalos@gmail.com>
In-Reply-To: <20260413073249.2897840-1-rajasimandalos@gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Fri, 17 Apr 2026 07:05:56 -0700
X-Gm-Features: AQROBzBXRiCNE5wmwQQl_41RzMGQd_Qr5vboHbv0115Z_m2e0G7CCc171S3ZN2o
Message-ID: <CAFTVevUjoGEzaiUkyC5baXNvXSZTmVrzwE-caRLnOfPZZObjKw@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] smb: client: block non-reconfigurable option
 changes on remount
To: Rajasi Mandal <rajasimandalos@gmail.com>
Cc: stfrench@microsoft.com, linux-cifs@vger.kernel.org, sfrench@samba.org, 
	Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Rajasi,

My comments inline

On Mon, Apr 13, 2026 at 12:33=E2=80=AFAM Rajasi Mandal <rajasimandalos@gmai=
l.com> wrote:
>
> From: Rajasi Mandal <rajasimandal@microsoft.com>
>
> Options like seal, sign, vers, ip, rdma and others require tearing
> down the connection to take effect, so they cannot be changed on
> remount.  Previously they were silently accepted and ignored.
>
> Add checks in smb3_verify_reconfigure_ctx() to reject changes to
> these options on remount.  Options shown in /proc/mounts use a bare
> !=3D comparison since libmount feeds them back automatically.  Options
> not shown in /proc/mounts use an 'if (new && new !=3D old)' guard so
> their init default does not cause a false mismatch.
>
> Introduce smb3_preserve_non_reconfig_opts() to copy hidden option
> values from the old context into the new one before
> smb3_fs_context_dup() overwrites them with init defaults.  Without
> this, a bare remount silently corrupts the stored mount context by
> replacing live values with zero/init defaults for every option not
> shown in /proc/mounts.
>
> Introduce smb3_sync_ctx_from_negotiated() to sync the stored mount
> context with runtime state (persistenthandles, unix, nosharesock,
> resilienthandles, domainname, ops/vals) before the verify step, since
> cifs_show_options() reads these from tcon/server and they can diverge
> from ctx when the server auto-enables a feature or negotiates a
> different dialect than what was parsed (e.g. default -> SMB 3.1.1).
> Without this sync, the fed-back /proc/mounts values mismatch the
> stale ctx and the verify step incorrectly rejects a bare remount.
>
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 235 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 235 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 3f0faae99ed5..a0217b5641a2 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1021,10 +1021,241 @@ static int smb3_verify_reconfigure_ctx(struct fs=
_context *fc,
>                 cifs_errorf(fc, "can not change nbsessinit during remount=
\n");
>                 return -EINVAL;
>         }
> +       /* init default: compress =3D false */
> +       if (new_ctx->compress &&
> +           new_ctx->compress !=3D old_ctx->compress) {
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
> +       /* init default: port =3D 0 */
> +       if (new_ctx->port &&
> +           new_ctx->port !=3D old_ctx->port) {
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
> +       /* source_rfc1001_name: both init from same nodename, safe to com=
pare */
> +       if (memcmp(new_ctx->source_rfc1001_name, old_ctx->source_rfc1001_=
name,
> +                  RFC1001_NAME_LEN)) {
> +               cifs_errorf(fc, "can not change netbiosname during remoun=
t\n");
> +               return -EINVAL;
> +       }
> +       /* init default: target_rfc1001_name[0] =3D 0 */
> +       if (new_ctx->target_rfc1001_name[0] &&
> +           memcmp(new_ctx->target_rfc1001_name, old_ctx->target_rfc1001_=
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
> +       /* init default: rootfs =3D false */
> +       if (new_ctx->rootfs &&
> +           new_ctx->rootfs !=3D old_ctx->rootfs) {
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
> +       /* init default: intr =3D false */
> +       if (new_ctx->intr &&
> +           new_ctx->intr !=3D old_ctx->intr) {
> +               cifs_errorf(fc, "can not change intr during remount\n");
> +               return -EINVAL;
> +       }
> +       /* init default: no_psx_acl =3D 0 */
> +       if (new_ctx->no_psx_acl &&
> +           new_ctx->no_psx_acl !=3D old_ctx->no_psx_acl) {
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
> +       /*
> +        * persistent is shown in /proc/mounts (bare !=3D).
> +        * nopersistent is NOT shown, so guard with init default check.
> +        */
> +       if (new_ctx->persistent !=3D old_ctx->persistent ||
> +           (new_ctx->nopersistent &&
> +            new_ctx->nopersistent !=3D old_ctx->nopersistent)) {
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
> +       /* init default: domainauto =3D false */
> +       if (new_ctx->domainauto &&
> +           new_ctx->domainauto !=3D old_ctx->domainauto) {
> +               cifs_errorf(fc, "can not change domainauto during remount=
\n");
> +               return -EINVAL;
> +       }
> +       /* init default: rdma =3D false */
> +       if (new_ctx->rdma &&
> +           new_ctx->rdma !=3D old_ctx->rdma) {
> +               cifs_errorf(fc, "can not change rdma during remount\n");
> +               return -EINVAL;
> +       }
>
>         return 0;
>  }

The guard patterns are inconsistent. For example, the bare !=3D options
can be rejected if the auto-negotiated value differs from init
(examples below).

>
> +/*
> + * Sync cifs_sb->ctx with negotiated runtime values for fields that
> + * cifs_show_options() reads from tcon/server rather than from ctx.
> + * The mount.cifs helper reads /proc/mounts and feeds these values back
> + * on remount, so ctx must match the runtime state to avoid false
> + * rejection by smb3_verify_reconfigure_ctx().
> + */
> +static void smb3_sync_ctx_from_negotiated(struct cifs_sb_info *cifs_sb)
> +{
> +       struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> +       struct TCP_Server_Info *server =3D tcon->ses->server;
> +       struct smb3_fs_context *ctx =3D cifs_sb->ctx;
> +
> +       /* /proc/mounts shows persistenthandles from tcon->use_persistent=
 */
> +       if (tcon->use_persistent && !ctx->persistent) {
> +               ctx->persistent =3D true;
> +               ctx->nopersistent =3D false;
> +       }
> +       /* /proc/mounts shows resilienthandles from tcon->use_resilient *=
/
> +       ctx->resilient =3D tcon->use_resilient;
> +       /* /proc/mounts shows nounix/unix/posix from tcon */
> +       if (tcon->posix_extensions) {
> +               ctx->linux_ext =3D 1;
> +               ctx->no_linux_ext =3D 0;
> +       } else if (tcon->unix_ext) {
> +               ctx->linux_ext =3D 1;
> +               ctx->no_linux_ext =3D 0;
> +       } else {
> +               ctx->linux_ext =3D 0;
> +               ctx->no_linux_ext =3D 1;
> +       }
> +       /* /proc/mounts shows nosharesock from server->nosharesock */
> +       if (server->nosharesock)
> +               ctx->nosharesock =3D true;
> +       /*
> +        * /proc/mounts shows vers=3D from server->vals->version_string,
> +        * which reflects the negotiated dialect. When mounted without
> +        * an explicit vers=3D, ctx stores smbdefault ops/vals while the
> +        * server may have negotiated e.g. SMB 3.1.1. Sync so the
> +        * verify check does not reject the fed-back vers=3D on remount.
> +        */
> +       ctx->ops =3D server->ops;
> +       ctx->vals =3D server->vals;
> +}

There is a risk of racing with reconnects here. Negotiate can modify
ops and vals.

When no explicit vers=3D is passed on remount,
smb3_sync_ctx_from_negotiated syncs old_ctx->ops/vals to whatever the
server has negotiated. The new_ctx, however, still has defaults
(smb30_ops/vals) and duplicating fs_context overwrites cifs_sb->ctx
with these values.
To repro, mount with vers 3.1.1 and remount without providing a version. ()
If you add some logging, you will see that the version string before
remount: 3.1.1 and version string after remount: default (3.0).

Also, I was not able to do a bare remount (-o username,remount)
because I got this error:

CIFS: VFS: can not change unix during remount

I was not using linux extensions. When you sync ctx from negotiated,
no_linux_ext is 1, but in the new context, no_linux_ext is initialised
to 0. So, when you compare the two, there is a spurious rejection.
You might want to check similar failures for other mount options too.
I am getting similar warnings for nosharesock.

There are no guardrails to protect old ctx values that have not been
synced in perserve_non_reconfig_opts.

> +
> +/*
> + * Carry forward non-reconfigurable mount options that are NOT
> + * displayed by cifs_show_options() into the new remount context
> + * before smb3_fs_context_dup() overwrites cifs_sb->ctx.
> + *
> + * Options that cifs_show_options() outputs are automatically
> + * re-fed by libmount (which reads /proc/mounts) on remount,
> + * so they do not need to be preserved here.
> + *
> + * Without this, a bare remount would silently reset these hidden
> + * fields to their init defaults.
> + */
> +static void smb3_preserve_non_reconfig_opts(struct smb3_fs_context *new_=
ctx,
> +                                           struct smb3_fs_context *old_c=
tx)
> +{
> +       new_ctx->compress =3D old_ctx->compress;
> +       new_ctx->port =3D old_ctx->port;
> +       new_ctx->rootfs =3D old_ctx->rootfs;
> +       new_ctx->intr =3D old_ctx->intr;
> +       new_ctx->no_psx_acl =3D old_ctx->no_psx_acl;
> +       new_ctx->domainauto =3D old_ctx->domainauto;
> +       new_ctx->rdma =3D old_ctx->rdma;
> +       new_ctx->nopersistent =3D old_ctx->nopersistent;
> +       memcpy(new_ctx->target_rfc1001_name, old_ctx->target_rfc1001_name=
,
> +              RFC1001_NAME_LEN_WITH_NULL);
> +}
> +
>  #define STEAL_STRING(cifs_sb, ctx, field)                              \
>  do {                                                                   \
>         kfree(ctx->field);                                              \
> @@ -1093,6 +1324,8 @@ static int smb3_reconfigure(struct fs_context *fc)
>         if (ses->expired_pwd)
>                 need_recon =3D true;
>
> +       smb3_sync_ctx_from_negotiated(cifs_sb);
> +
>         rc =3D smb3_verify_reconfigure_ctx(fc, ctx, cifs_sb->ctx, need_re=
con);
>         if (rc)
>                 return rc;
> @@ -1205,6 +1438,8 @@ static int smb3_reconfigure(struct fs_context *fc)
>         ctx->rsize =3D rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx=
->rsize;
>         ctx->wsize =3D wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx=
->wsize;
>
> +       smb3_preserve_non_reconfig_opts(ctx, cifs_sb->ctx);
> +
>         smb3_cleanup_fs_context_contents(cifs_sb->ctx);
>         rc =3D smb3_fs_context_dup(cifs_sb->ctx, ctx);
>         smb3_update_mnt_flags(cifs_sb);
> --
> 2.43.0
>
>

Thanks
Meetakshi
