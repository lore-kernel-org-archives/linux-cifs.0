Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2875B1D5160
	for <linux-cifs@vger.kernel.org>; Wed, 12 Mar 2025 16:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741796605; cv=none; b=MlTvxy16qsXMFJBNyI3bjwVnskYPPP0G7d2LnAmJqlrQP5CLRaH+/NgKUido9tEBfKxhITn7kTZfVCflF295Kx3SmVobTOOkcOhktWTSZuRYL75zGRkxtfUjnhXEgtwhINOAZ44rANqed5Pdchq5RimOBdcvWFQjVt49s19tXfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741796605; c=relaxed/simple;
	bh=ZJdmmloqUmXESNntu0dPSMF/s6AVO1iYbsvbHXL++0I=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=SW0LmOGqWXo/DPitDA1XoZ6sDG1MZzCBnbNgZh2SKFqxn4qTazhTffC7Nx6xGCpDGOhmp4VlLksq00eyNabzZEVRWkCKgF/AolixVQ71x2h7nIxCZbB1fcgCijYzHoB5oylFhNVO1wv8ee3IXe/kywQ9lrnYdu8HkUPPF1qlhLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=XasS+x1c; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="XasS+x1c"
Message-ID: <9ef1d7140c93877011e7ca5fdcd13ec4@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1741796602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iIximd9JyvbuS++2Uxw2IolvTCJM7tpFbI8oOmAvbw4=;
	b=XasS+x1cCR90aor7am79FYv5Y88fIbyZ7sSgi8JhoOeShUKa5LP+1fj17jUdc+CycFeRqK
	nU7Y8O3l8rl5lAEstaM936N3B2sEPzvpDLh2xaSx5pO7IN0EFhe4RxgXJvVofpbqHF5sMg
	KPwO6uaFBkdIrHtkNWznl9r5CXO9l27Iu/mmci4Cl3rfJxgcxvjYBwr2s9eVsDSMLUyPxa
	ep49wNg7r7jisaaWfElHPODXrQeo4SiwI8Z7x/GWQzMALT5cTl+boiUzh756JXiOKoYjSA
	7bheb3U9+AjZCXkOKRH3hXH5ddudsqZEvuMFN6xdx7jEYJPuMYur5XGRpBQfJA==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>, Meetakshi Setiya
 <meetakshisetiyaoss@gmail.com>
Cc: Adam Williamson <awilliam@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix regression with guest option
In-Reply-To: <CAH2r5mu5=nnBwibmARGoLepbQfU6qkXnez8whaWaSM7G7MEVXw@mail.gmail.com>
References: <20250312135131.628756-1-pc@manguebit.com>
 <CAH2r5mtjtigJf7JKUiL3D5Lp8f4qTe4GUxQPXwz1o=SQMqiqdA@mail.gmail.com>
 <70d0157ac13725595d64978b11c4d3a91f417803.camel@redhat.com>
 <4cbaab94c2ba97a8d91b9f43ea8a3662@manguebit.com>
 <CAH2r5mu5=nnBwibmARGoLepbQfU6qkXnez8whaWaSM7G7MEVXw@mail.gmail.com>
Date: Wed, 12 Mar 2025 13:23:19 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> Meetakshi sent a patch idea to try (to also fix this in cifs-utils) -
> will take a look

Where is the patch?

Something like below would work

diff --git a/mount.cifs.c b/mount.cifs.c
index 7605130..16730c6 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -200,6 +200,7 @@ struct parsed_mount_info {
        unsigned int got_domain:1;
        unsigned int is_krb5:1;
        unsigned int is_noauth:1;
+       unsigned int is_guest:1;
        uid_t sudo_uid;
 };
 
@@ -1161,6 +1162,7 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
                        parsed_info->got_user = 1;
                        parsed_info->got_password = 1;
                        parsed_info->got_password2 = 1;
+                       parsed_info->is_guest = 1;
                        goto nocopy;
                case OPT_RO:
                        *filesys_flags |= MS_RDONLY;
@@ -2334,7 +2336,9 @@ mount_retry:
                fprintf(stderr, "%s kernel mount options: %s",
                        thisprogram, options);
 
-       if (parsed_info->got_password && !(parsed_info->is_krb5 || parsed_info->is_noauth)) {
+       if (parsed_info->got_password &&
+           !(parsed_info->is_krb5 || parsed_info->is_noauth ||
+             parsed_info->is_guest)) {
                /*
                 * Commas have to be doubled, or else they will
                 * look like the parameter separator
@@ -2345,7 +2349,9 @@ mount_retry:
                        fprintf(stderr, ",pass=********");
        }
 
-       if (parsed_info->got_password2 && !(parsed_info->is_krb5 || parsed_info->is_noauth)) {
+       if (parsed_info->got_password2 &&
+           !(parsed_info->is_krb5 || parsed_info->is_noauth ||
+             parsed_info->is_guest)) {
                strlcat(options, ",password2=", options_size);
                strlcat(options, parsed_info->password2, options_size);
                if (parsed_info->verboseflag)
