Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5FCC433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Sep 2021 13:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09FB360F6B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Sep 2021 13:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240114AbhIQNUU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Sep 2021 09:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240252AbhIQNUT (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 17 Sep 2021 09:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2457460FC0
        for <linux-cifs@vger.kernel.org>; Fri, 17 Sep 2021 13:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631884737;
        bh=DEyNInnZoREfNhoc0VY/P14tyOP6xC4Ao6R0nji9nY8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=NKbS9yjjwprkobKL9xynwbHh3TWTDHqLrYVI2XZqSKdmhdR/UUvxLa5MdkDl34NOA
         Y+65CJ6OPertLMOS04+vYQOosi/pUIKKXb+3giWoy3R62JsiGyqvWLybehmUKK/Kma
         uDghMJtd0nc1jkCltvvpF2k2x5HCgH0Qb4H0ve6v9F9hSV0eEZnIHDccQ0pMD7OQfe
         k5ZV03VpkC5U1Mtf3CkmSGmCEB1ft0Mbvq+3ibmbRMvKudhfI7J0eqHg2TGZtvw+Ia
         NPyhlJXBSLutUA7PlkSckCK7mgD8VOg9LAUbnLwdoARJaY2sN2P9CyCUgS4WccWujn
         66uhB6fWTfZmQ==
Received: by mail-ot1-f41.google.com with SMTP id y63-20020a9d22c5000000b005453f95356cso5889692ota.11
        for <linux-cifs@vger.kernel.org>; Fri, 17 Sep 2021 06:18:57 -0700 (PDT)
X-Gm-Message-State: AOAM532F3r6dDiiZpiDdUjqbveR2OTX6rhZ60iZ1CV+ZMBPVu9bD87/n
        sZVrsWTFCA1/ceEB+t0P/ymTfTjbieayUupsE7U=
X-Google-Smtp-Source: ABdhPJz4XlKzq02MBTtftpPh+tgWv0eIS3pMFh87G2rh9F6gC/tuejAhWWKlUJfqivN7X3JFpm6uLW+Sw9a6TeNMGY0=
X-Received: by 2002:a9d:36d:: with SMTP id 100mr9395593otv.237.1631884736470;
 Fri, 17 Sep 2021 06:18:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Fri, 17 Sep 2021 06:18:56
 -0700 (PDT)
In-Reply-To: <20210917104913.5823-1-hyc.lee@gmail.com>
References: <20210917104913.5823-1-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 17 Sep 2021 22:18:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9DRqvysX=VwGruB+QaqzHTEdcF1Ya=3Wwp2=nopyTK=w@mail.gmail.com>
Message-ID: <CAKYAXd9DRqvysX=VwGruB+QaqzHTEdcF1Ya=3Wwp2=nopyTK=w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: prevent out of share access
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>, lsahlber@redhat.com,
        kernel-team@lge.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-17 19:49 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Because of "..", files outside the share directory
> could be accessed. To prevent this, normalize
> the given path and remove all "." and ".."
> components.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/misc.c    | 79 ++++++++++++++++++++++++++++++++++++++++------
>  fs/ksmbd/misc.h    |  3 +-
>  fs/ksmbd/smb2pdu.c | 14 +++++---
>  3 files changed, 80 insertions(+), 16 deletions(-)
>
> diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
> index 0b307ca28a19..d599cb686415 100644
> --- a/fs/ksmbd/misc.c
> +++ b/fs/ksmbd/misc.c
> @@ -191,19 +191,80 @@ int get_nlink(struct kstat *st)
>  	return nlink;
>  }
>
> -void ksmbd_conv_path_to_unix(char *path)
> +char *ksmbd_conv_path_to_unix(char *path)
>  {
> +	size_t path_len, remain_path_len, out_path_len;
> +	char *out_path, *out_next;
> +	int i, pre_dotdot_cnt = 0, slash_cnt = 0;
> +	bool is_last;
> +
>  	strreplace(path, '\\', '/');
> -}
> +	path_len = strlen(path);
> +	remain_path_len = path_len;
> +	if (path_len == 0)
> +		return ERR_PTR(-EINVAL);
>
> -void ksmbd_strip_last_slash(char *path)
> -{
> -	int len = strlen(path);
> +	out_path = kzalloc(path_len + 2, GFP_KERNEL);
> +	if (!out_path)
> +		return ERR_PTR(-ENOMEM);
> +	out_path_len = 0;
> +	out_next = out_path;
> +
> +	do {
> +		char *name = path + path_len - remain_path_len;
> +		char *next = strchrnul(name, '/');
> +		size_t name_len = next - name;
> +
> +		is_last = !next[0];
> +		if (name_len == 2 && name[0] == '.' && name[1] == '.') {
> +			pre_dotdot_cnt++;
> +			/* handle the case that path ends with "/.." */
> +			if (is_last)
> +				goto follow_dotdot;
> +		} else {
> +			if (pre_dotdot_cnt) {
> +follow_dotdot:
> +				slash_cnt = 0;
> +				for (i = out_path_len - 1; i >= 0; i--) {
> +					if (out_path[i] == '/') {
> +						slash_cnt++;
> +						if (slash_cnt ==
> +						    pre_dotdot_cnt + 1)
> +							break;
> +					}
checkpatch.pl warn:

WARNING: Too many leading tabs - consider code refactoring
#70: FILE: fs/ksmbd/misc.c:231:
+						if (slash_cnt ==

total: 0 errors, 1 warnings, 125 lines checked

updated like this.

                                        if (out_path[i] == '/' &&
                                            ++slash_cnt == pre_dotdot_cnt + 1)
                                                break;
Thanks.

> +				}
> +
> +				if (i < 0 &&
> +				    slash_cnt != pre_dotdot_cnt) {
> +					kfree(out_path);
> +					return ERR_PTR(-EINVAL);
> +				}
> +
> +				out_next = &out_path[i+1];
> +				*out_next = '\0';
> +				out_path_len = i + 1;
>
> -	while (len && path[len - 1] == '/') {
> -		path[len - 1] = '\0';
> -		len--;
> -	}
> +			}
> +
> +			if (name_len != 0 &&
> +			    !(name_len == 1 && name[0] == '.') &&
> +			    !(name_len == 2 && name[0] == '.' && name[1] == '.')) {
> +				next[0] = '\0';
> +				sprintf(out_next, "%s/", name);
> +				out_next += name_len + 1;
> +				out_path_len += name_len + 1;
> +				next[0] = '/';
> +			}
> +			pre_dotdot_cnt = 0;
> +		}
> +
> +		remain_path_len -= name_len + 1;
> +	} while (!is_last);
> +
> +	if (out_path_len > 0)
> +		out_path[out_path_len-1] = '\0';
> +	path[path_len] = '\0';
> +	return out_path;
>  }
>
>  void ksmbd_conv_path_to_windows(char *path)
> diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
> index af8717d4d85b..b7b10139ada2 100644
> --- a/fs/ksmbd/misc.h
> +++ b/fs/ksmbd/misc.h
> @@ -16,8 +16,7 @@ int ksmbd_validate_filename(char *filename);
>  int parse_stream_name(char *filename, char **stream_name, int *s_type);
>  char *convert_to_nt_pathname(char *filename, char *sharepath);
>  int get_nlink(struct kstat *st);
> -void ksmbd_conv_path_to_unix(char *path);
> -void ksmbd_strip_last_slash(char *path);
> +char *ksmbd_conv_path_to_unix(char *path);
>  void ksmbd_conv_path_to_windows(char *path);
>  char *ksmbd_extract_sharename(char *treename);
>  char *convert_to_unix_name(struct ksmbd_share_config *share, char *name);
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index c86164dc70bb..46e0275a77a8 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -634,7 +634,7 @@ static char *
>  smb2_get_name(struct ksmbd_share_config *share, const char *src,
>  	      const int maxlen, struct nls_table *local_nls)
>  {
> -	char *name, *unixname;
> +	char *name, *norm_name, *unixname;
>
>  	name = smb_strndup_from_utf16(src, maxlen, 1, local_nls);
>  	if (IS_ERR(name)) {
> @@ -643,11 +643,15 @@ smb2_get_name(struct ksmbd_share_config *share, const
> char *src,
>  	}
>
>  	/* change it to absolute unix name */
> -	ksmbd_conv_path_to_unix(name);
> -	ksmbd_strip_last_slash(name);
> -
> -	unixname = convert_to_unix_name(share, name);
> +	norm_name = ksmbd_conv_path_to_unix(name);
> +	if (IS_ERR(norm_name)) {
> +		kfree(name);
> +		return norm_name;
> +	}
>  	kfree(name);
> +
> +	unixname = convert_to_unix_name(share, norm_name);
> +	kfree(norm_name);
>  	if (!unixname) {
>  		pr_err("can not convert absolute name\n");
>  		return ERR_PTR(-ENOMEM);
> --
> 2.17.1
>
>
