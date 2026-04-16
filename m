Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8328F33C183
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 04:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776315406; cv=pass; b=dUwJbU/HCVIEN2ibWdsFGGiFQmZTZPPnHUoN3XEOr2HhMbI7ETK/iwW+5cGyoC+VD/pQ8d2LS5oYqGNAy5xdH85POgjLnQezsJi3x5FP2kRKoafKhmaKA7TFEC23eDAUEiAZnOHhGRQCFPRvI4250bBOrumk+m9+PTYE9VrYY9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776315406; c=relaxed/simple;
	bh=Tdo0wkU/+7H7lOFsHJdcy03PvNSQKaMKnAQISrpO0kM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gy6uCE+tcQNv8BP0Zmo+sokgWjZ4W3lFOs7dxTj9CSVH8jjpgQyFDpiuwy8fosbxm7rZ0FJzAXp8ywQ0QUTdR+udzPiqqVW8EWDA9igJXZillaQEJa1+LQiLcrIBVP4lpTpcsYCfbA+8dMh3S0DLVDJhbxTdrXHDGFZfssVfT38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h+jOfjck; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h+jOfjck"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6725295a113so2220459a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 21:56:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776315403; cv=none;
        d=google.com; s=arc-20240605;
        b=Mr0D4IgZTbFSeZH2zZuJd+yiitGLWZgiqRfCdZAZR3qTk+KwP8OMJh81ldW2ejUqjf
         eHbvdPRrk0po8y/B+42Yd7tVyl8W4kz42NV9832FmEBD11XDZlVVCpqjCcctgYlmDv+M
         ZW1yw7Ke1LcCCaKQUMph9kCLzPIq08mAOmFTBdGeeFqJtI2jZLmJSZiWYM0FPOxzcDPn
         iIutTsZZl9nGSHUOsAKutLj8GNhWbzmexqpe06VxY1ag1aUK1qkVaXo9fxgJwtW3FQXk
         +UKjQr71Y4CYwHel0hbCl2tXHZm+33i7pfRntssLC6LJKRKD6P5apIEiyYm7WMDCgL4S
         YUkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V4wXnE/acyxugJcIAU1vSEb4rGdOI7xIqig6cNf2g2I=;
        fh=HSAIwjWR6sx7No3gg0dPfGs8VwPoQfE+gYVmIkCFamc=;
        b=Qfhu0saoTzQdHJ7qQcGEh6DlRiECh/YMMp0HfAt3WAW2WgTwPLOdXuHmNBWUMJMOlg
         M6zRbj2mW4Fvyy7jO/2Xzw5o7+HhvqvSViZdvinpX4wRIYq/fi44vh7WlNiGSrJSG2FH
         z7c7uBgYR1nJMBGZ1yHK0Unw5q9+NpIiV6zFqvyhUQR8XBQ/H1v0VsxSzYHq7pjssmFT
         B3k8/lT4AiGhE+3anl6Zypta6DjMuL/o3Y3RPhk3XvUggXp0EtbSB9UpNVP6dAVbYKIv
         trxSZuqK8D6emzquOoypgKUwql3SkHqrH85o0rOUmcwgENmA34JmeUI4I2Ma4bL9Ryx5
         0AaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776315403; x=1776920203; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4wXnE/acyxugJcIAU1vSEb4rGdOI7xIqig6cNf2g2I=;
        b=h+jOfjck0cZneRphifffDP7UMCI+G/QhRdtJz2xOCro/4pYegXry2NLbfnmn2qMMEr
         81MKV7RKYxFc06mYdvrAVSbMkBCKOfn66r4T57c/r5XasQ0faoif650JKM8g2hlFG0jj
         5hWAAeQnZJIEPOmHBHlC4UfKEdji3OEfTO8Y2I6FtD92S8uLhkNul3IH/iF3G8GZf/sa
         wvrILsmLjYlU3n0WJUWettGz1UJtvxmkRfXqHxQCAOdE0T2b2UWbcmS3tUCjzNQ7tGmL
         85VFsZbiDG7/Of9SNhvdK7mZHWhMppYPEIZ8bMCVFgHWs/Ulm5RpdghGxse5DZNhytJ4
         5gjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776315403; x=1776920203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V4wXnE/acyxugJcIAU1vSEb4rGdOI7xIqig6cNf2g2I=;
        b=aGqHHCoT0QOcLZo9hk0Qt6ArLmcGH1aTcS7bOqmXwCq0JmI2vMbjBvtI+ScqaaSvKg
         Is+qW964K1uduaIAvNEEO1EvngVg2oaRlbZ2QcEZDnVW464T0SonHuzJMQ2P1VrstFWw
         HeOFtL1Xo/YlXcZAEP4EsAal5GGS0GmDoXBWP0FxXHmZeqdKnXh7t2mxkPHawEnZrnuN
         K4USnK6ObXPYFS1E8sUwq5X/eV06MZ+GfG2l2CRPF2iYO1fhDpyqBMM/Up3iuVhMfFhd
         GTm7/8UGP9ZYUnGh9ZspXBAiIg2KWofWOhBD+QzODfgHBfXXsI+BaQjoCq20Irz0uZpR
         LlIA==
X-Forwarded-Encrypted: i=1; AFNElJ8KXVTZ0kvVAa+tiV3B/fH0Jy0AxICKgBQqyy0v7WxCJQTNAB7SemaWWF6VsxTsKalsY4VGx9l+RnMj@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8mPVRCpwb/tZOYnb28CSWoVxqufjE3w8XrJKyggOwfRW9F9hV
	dN/ozRRsQwtVxtyhlyZ5A6gJy77CiZSruKu4o4mu+8Mxonu5KU0ZY2URjh2021O618AJ5vxIU9K
	8GsRFTSh1zsDm4C0k4GltgwDx+HIXnyc=
X-Gm-Gg: AeBDiet+cQjT9H/IuOJdHkd3mQ0YCd/y69yvtMzLgi1QFq+kB8SmelzPka/pOlD2yxD
	sOHVSw/+tL8ny045kFqMofYM7qoHTASyFzAbOZ4mBw3Dtx96KlhHaHI2wequOO0sAoHmaVJalRd
	LnHkpeQ+t/w7vkpOa2rz2aa/wvcZPzOycIKISe9QGcDht9fCLfHo9G6XX8oxbBYWkwDuPZthRgm
	luENnTqkrXwg0KjR2H/NoMbbjWPI03phpOrD4DYL5nQr8IHyvcUZL5TAUtCao5wne26YqVdgnnU
	v93E+tL8docCOO6S
X-Received: by 2002:a05:6402:3885:b0:671:a228:a403 with SMTP id
 4fb4d7f45d1cf-671a228a846mr6716558a12.17.1776315402579; Wed, 15 Apr 2026
 21:56:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416022811.2692096-1-charsyam@gmail.com>
In-Reply-To: <20260416022811.2692096-1-charsyam@gmail.com>
From: RAJASI MANDAL <rajasimandalos@gmail.com>
Date: Wed, 15 Apr 2026 21:56:31 -0700
X-Gm-Features: AQROBzA3-nKaWio2xT-lfLsB6EBPDfbK-2TtLLZRRHZL1VMPWtw3tmYPMWJSTNM
Message-ID: <CAEY6_V1+dzW3OD5zqXhsWyXwrDTrg5tAMGZ1AJ7_GAuRE+aevA@mail.gmail.com>
Subject: Re: [PATCH] smb/client: fix chan_max race and rollback in smb3_reconfigure
To: DaeMyung Kang <charsyam@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	rajasimandal@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi DaeMyung,

I reviewed your patch. The two core fixes (moving
smb3_sync_ses_chan_max after the SCALE_CHANNELS check, and rolling
back chan_max on failure) are correct. However the error handling
paths corrupt the mount context leading to false future remount
failures.

Issue 1: return rc after STEAL_STRING nullifies UNC/source/username

Earlier in smb3_reconfigure(), STEAL_STRING moves UNC, source, and
username from cifs_sb->ctx into ctx, setting cifs_sb->ctx->UNC =3D NULL.
The new if (rc < 0) return rc at the end of the multichannel block
exits before smb3_fs_context_dup() can copy them back.

How to repro:
mount -t cifs //server/share /mnt -o multichannel,max_channels=3D2,...
mount -o remount,multichannel,max_channels=3D4 /mnt  # fails (server error)
grep /mnt /proc/mounts   # shows "none" instead of //server/share
mount -o remount,multichannel,max_channels=3D2 /mnt  # fails: "bad UNC (non=
e)"


Issue 2: return -EINVAL on loser path has the same STEAL_STRING corruption

When CIFS_SES_FLAG_SCALE_CHANNELS is already set (concurrent remount),
the return -EINVAL exits after STEAL_STRING but before
smb3_fs_context_dup(), same permanent NULL UNC corruption.

How to repro: Tested with a module parameter that forces the
SCALE_CHANNELS flag check to take the loser path. After the failed
remount, /proc/mounts shows "none" and all future remounts fail.

Suggested fix:

--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -NNNN,7 +NNNN,7 @@ static int smb3_reconfigure(struct fs_context *fc)
     char *new_password =3D NULL, *new_password2 =3D NULL;
     bool need_recon =3D false;
- int rc;
+ int rc, mchan_rc =3D 0;

     if (ses->expired_pwd)
@@ -NNNN,8 +NNNN,9 @@ static int smb3_reconfigure(struct fs_context *fc)
         if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
             spin_unlock(&ses->ses_lock);
             mutex_unlock(&ses->session_mutex);
- return -EINVAL;
+ mchan_rc =3D -EINVAL;
+ goto out;
         }
         ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
@@ -NNNN,13 +NNNN,14 @@ static int smb3_reconfigure(struct fs_context *fc)
         ses->flags &=3D ~CIFS_SES_FLAG_SCALE_CHANNELS;
         spin_unlock(&ses->ses_lock);

- if (rc < 0)
- return rc;
+ if (rc < 0)
+ mchan_rc =3D rc;
     } else {
         mutex_unlock(&ses->session_mutex);
     }

+out:
     STEAL_STRING(cifs_sb, ctx, domainname);
     STEAL_STRING(cifs_sb, ctx, nodename);
     STEAL_STRING(cifs_sb, ctx, iocharset);
@@ -NNNN,9 +NNNN,22 @@ static int smb3_reconfigure(struct fs_context *fc)
     ctx->rsize =3D rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsi=
ze;
     ctx->wsize =3D wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsi=
ze;

+ /*
+ * On multichannel failure, restore the old multichannel settings in ctx
+ * so smb3_fs_context_dup does not desync cifs_sb->ctx from ses->chan_max.
+ */
+ if (mchan_rc) {
+ ctx->multichannel =3D cifs_sb->ctx->multichannel;
+ ctx->max_channels =3D cifs_sb->ctx->max_channels;
+ }
+
     smb3_cleanup_fs_context_contents(cifs_sb->ctx);
     rc =3D smb3_fs_context_dup(cifs_sb->ctx, ctx);
     smb3_update_mnt_flags(cifs_sb);
+
+ if (mchan_rc)
+ return mchan_rc;
+
 #ifdef CONFIG_CIFS_DFS_UPCALL
     if (!rc)
         rc =3D dfs_cache_remount_fs(cifs_sb);

On Wed, Apr 15, 2026 at 7:28=E2=80=AFPM DaeMyung Kang <charsyam@gmail.com> =
wrote:
>
> smb3_reconfigure() has two bugs when handling multichannel remount:
>
> 1) smb3_sync_ses_chan_max() is called before acquiring
>    CIFS_SES_FLAG_SCALE_CHANNELS. If a concurrent operation (e.g.
>    smb2_reconnect) holds the flag, the current thread takes the
>    loser path and returns -EINVAL, but ses->chan_max has already
>    been updated to the new value. This leaves chan_max inconsistent
>    with the actual channel state.
>
> 2) When smb3_update_ses_channels() fails, chan_max is not rolled
>    back to its previous value and the error is not propagated to
>    the caller. The mount command returns success even though the
>    channel configuration was not applied, and repeated failures
>    cause chan_max to drift further from reality.
>
> Fix both by moving smb3_sync_ses_chan_max() after the
> CIFS_SES_FLAG_SCALE_CHANNELS acquisition so the loser path cannot
> corrupt chan_max, and by restoring chan_max from old_chan_max on
> update failure while still holding the scaling flag to prevent a
> concurrent reconfigure from observing the intermediate state.
> Propagate the error to the caller so userspace is informed.
>
> Note: smb3_reconfigure() is not fully transactional =E2=80=94 credentials
> are committed before the multichannel block, so any early return
> (including the existing CIFS_SES_FLAG_SCALE_CHANNELS loser path)
> can leave ses->password updated while cifs_sb->ctx is not yet
> synced. Making the entire function atomic is a larger refactor
> and is left for a separate patch.
>
> Tested with a QEMU VM (ksmbd + cifs) using module-parameter-based
> fault injection:
>  - Forced smb3_update_ses_channels() failure via module param and
>    verified chan_max is preserved at the old value after remount
>    failure (fault-injection test for rollback).
>  - Pre-set CIFS_SES_FLAG_SCALE_CHANNELS before entering the
>    scaling path and verified the loser path returns -EINVAL
>    without corrupting chan_max (loser-path invariant test).
>  - Repeated 19 forced-failure remounts with varying max_channels
>    (range 2-8) and confirmed no chan_max drift (stress test).
> All three scenarios pass with the patch and fail without it.
>
> Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount opt=
ions on remount")
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
> ---
>  fs/smb/client/fs_context.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index b9544eb0381b..99e62c2dbf50 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1085,6 +1085,7 @@ static int smb3_reconfigure(struct fs_context *fc)
>         struct dentry *root =3D fc->root;
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(root->d_sb);
>         struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
> +       unsigned int old_chan_max;
>         unsigned int rsize =3D ctx->rsize, wsize =3D ctx->wsize;
>         char *new_password =3D NULL, *new_password2 =3D NULL;
>         bool need_recon =3D false;
> @@ -1170,9 +1171,6 @@ static int smb3_reconfigure(struct fs_context *fc)
>         if ((ctx->multichannel !=3D cifs_sb->ctx->multichannel) ||
>             (ctx->max_channels !=3D cifs_sb->ctx->max_channels)) {
>
> -               /* Synchronize ses->chan_max with the new mount context *=
/
> -               smb3_sync_ses_chan_max(ses, ctx->max_channels);
> -               /* Now update the session's channels to match the new con=
figuration */
>                 /* Prevent concurrent scaling operations */
>                 spin_lock(&ses->ses_lock);
>                 if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> @@ -1183,16 +1181,31 @@ static int smb3_reconfigure(struct fs_context *fc=
)
>                 ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
>                 spin_unlock(&ses->ses_lock);
>
> +               old_chan_max =3D ses->chan_max;
> +               /* Synchronize ses->chan_max with the new mount context *=
/
> +               smb3_sync_ses_chan_max(ses, ctx->max_channels);
> +
>                 mutex_unlock(&ses->session_mutex);
>
>                 rc =3D smb3_update_ses_channels(ses, ses->server,
>                                                false /* from_reconnect */=
,
>                                                false /* disable_mchan */)=
;
>
> +               /*
> +                * On failure, restore chan_max while still holding
> +                * CIFS_SES_FLAG_SCALE_CHANNELS so a concurrent reconfigu=
re
> +                * cannot observe or race with the rollback.
> +                */
> +               if (rc < 0)
> +                       smb3_sync_ses_chan_max(ses, old_chan_max);
> +
>                 /* Clear scaling flag after operation */
>                 spin_lock(&ses->ses_lock);
>                 ses->flags &=3D ~CIFS_SES_FLAG_SCALE_CHANNELS;
>                 spin_unlock(&ses->ses_lock);
> +
> +               if (rc < 0)
> +                       return rc;
>         } else {
>                 mutex_unlock(&ses->session_mutex);
>         }
> --
> 2.43.0
>
>
