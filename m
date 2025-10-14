Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D142BCF5D
	for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 19:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760469167; cv=none; b=gTSR6HR/mhcWf8ELwmZ7uj9lf4dDDT8S7+cq1KL74Wdd/TVQLf2v1GmFb1Yvu2viLFEmyvCGSNh7muqR4hmL5z7dmJYMpv7iQC3ExZt+MEZlwQySw9qfWPtMGdwA6Cj5VAftrjK+TPRpp2mxghbITygkk1gW8d6nPnHnUENx/Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760469167; c=relaxed/simple;
	bh=O/CBH87Cuu2JnpiuuGV3gnN7vJ+9ZahquW7HlbJbW1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=geYfoulnX+yNgIhfCHASLit61t1o1+IdMaqXaubKp8TQYSS4zm1znu94/9agWTIQjI61gUfvgLe0kBKT5DA3Z+qyi9tuQIqjcQZHImkOUMTguG3UPHYMCoILpAbJFQ19K0oW/iT9ULWk/TrLHypiFn2pfrSdP9bWVw9GJ4HgX0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aXaDh3xQ; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aXaDh3xQ"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-87499a3cd37so52381026d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 12:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760469165; x=1761073965; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hj4KdecgoGHGYTc5Fn92jUDm+U1qN1I8QFfxys6tF+E=;
        b=aXaDh3xQwpTCC0qb/d/zlpNBRf4Syh2esrrv86aNt8dXTesjpHIQ/YeCMikT7+ajs4
         xc2uEBwBWUmCeYIAEw+wrnTrBfCrf2C9uloesj7i5/QEC8cSJkmXXvpl4c1VD33Wfq+w
         z40Tm7F/yyteHYnUGsZx23LWqKVMf150xLtcLwqFSBa88pS+XnONVS3cCl7BfC37lg2A
         lQvHGdvd9RwiJbUWgur3XMgk0Tc3iz9In0ATxQ50u9Nar3wIVgrWKkSag1aHirAUsBus
         qvTmNl5T8XXt8PA0RCwQ57RZx1JRSyyCd7sCn/n0CmMsRQIsR4oMPvaMTy4hwSPEnVMO
         HoZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760469165; x=1761073965;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hj4KdecgoGHGYTc5Fn92jUDm+U1qN1I8QFfxys6tF+E=;
        b=wX+OYW6Nze3bo6LBoMWxIu/DCSEE/+XGxWk4Lj1P6NvQvWP+rW6Ee9HpIGVdNbXRoN
         SmL+67P4UfShmIHUXbITL2SVCKh6qCTOI/hgKEUKxzHo2U9Nowx04nxF3JZVk3KaeBPo
         tM9/mzmPTxZDSm00n46xLYROTTYRZEg6usPDYUnZV0MiCemmCLftzGWR7/U9rmNItKcN
         1VsOpUnbTbxqECsmPHUAbk6KOGSGaiicqnvw49+gmS9hWRe4okrcwyTfgTW8UyyjTnLU
         6TudzNhxXu/a/941czb7qjDiDd28pMXzz5gfGYgkJHk11V/kbKx1WO5eIbQkWPzlPw86
         mJDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpt3DAoUAamKYGer0RPYa4C3ae4UPixNxVNxEiSy+VWU22yVJWVLDPbvoWLBADPR/+mFa29PZ8e+Vu@vger.kernel.org
X-Gm-Message-State: AOJu0YzpfeZ7AczbG64phAPIKuwiive/vn04tqsb/X6lbCKC4eZMB2pj
	MBc6mblDt0TAE60ngLc4grO3rZJEB6XHqZ9HzgRK/SJ2Ndpc6aragEixJYFXJWYiqT73M11gCPk
	yw+U3rNMwOw6KLcZ3EZEdQtTjwgrzZOk=
X-Gm-Gg: ASbGncut07pkC1JSIQLdo7SdLbXuXztyfwzEMT3glUflUETmB9+M43StrVPCU0/3YV5
	550is002WgSPMYYqgAtBlKWA+BT4ubOkt1lqiVSXGxflrtjDjZHvpBaGeFCCPcZv4X+76GNNoJ6
	+XxuOfbcyL+9oqHZj35CTKRtsboyDrpyD9ra4Cl3BvLrVHBZso6Dvg3lp0+F1ZGwzxIjCm8GH9z
	f9HGv2vf6bK1/YOE1A/1FV139/OqaPxNAQTAixfZW9E5Ul1IlA9qF7Py7XaVqmJ7gEs86L1GB0H
	Naio8phyRbMLlYvFPAIb/pBGZakGjPNbpwnhLIMTELWqT9tnzUU1S5z5GSXJYMUbtjhMR6ZWmfp
	crRn3pxUYSSE2uD59SXKmHE5AdvkpAu1a14uFk/E=
X-Google-Smtp-Source: AGHT+IGVnLqJpoAZcGkUlBY7oBpr7+xLff+kKqWhWi8JYLrzCEMQGNtSYRJnnKTVONKAwpF6Xdp30jZhS5ZxqaNWFFo=
X-Received: by 2002:a05:6214:f6d:b0:70f:5a6d:a253 with SMTP id
 6a1803df08f44-87b2ef44013mr355883666d6.49.1760469164911; Tue, 14 Oct 2025
 12:12:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014-smb-client-fix-wformat-32b-parse_dfs_referrals-v1-1-47fa7db66b71@kernel.org>
In-Reply-To: <20251014-smb-client-fix-wformat-32b-parse_dfs_referrals-v1-1-47fa7db66b71@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 14 Oct 2025 14:12:32 -0500
X-Gm-Features: AS18NWA3bxi7uC4cjWWZ93Qyu_Sqb3TU4Fwo7i25Q_1DJKLVcEl20vSn3Vb4mSs
Message-ID: <CAH2r5mtcJJ+_x2dQ3UkVFWd4+YapHXJFWFcxs5ErU+u8kncWsA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Fix format specifiers for size_t in parse_dfs_referrals()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Eugene Korenevsky <ekorenevsky@aliyun.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Ccm Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, patches@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000369f240641232bf3"

--000000000000369f240641232bf3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Nathan,
Good catch.  Have updated the patch with your change (rather than
having two patches) and added a Suggested-by.  If you want a
Reviewed-by or Acked-by let me know.

Updated patch attached.


On Tue, Oct 14, 2025 at 1:33=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> When building for 32-bit platforms, for which 'size_t' is
> 'unsigned int', there are a couple instances of -Wformat:
>
>   fs/smb/client/misc.c:922:25: error: format specifies type 'unsigned lon=
g' but the argument has type 'unsigned int' [-Werror,-Wformat]
>     921 |                          "%s: header is malformed (size is %u, =
must be %lu)\n",
>         |                                                                =
        ~~~
>         |                                                                =
        %u
>     922 |                          __func__, rsp_size, sizeof(*rsp));
>         |                                              ^~~~~~~~~~~~
>   fs/smb/client/misc.c:940:5: error: format specifies type 'unsigned long=
' but the argument has type 'unsigned int' [-Werror,-Wformat]
>     938 |                          "%s: malformed buffer (size is %u, mus=
t be at least %lu)\n",
>         |                                                                =
              ~~~
>         |                                                                =
              %u
>     939 |                          __func__, rsp_size,
>     940 |                          sizeof(*rsp) + *num_of_nodes * sizeof(=
REFERRAL3));
>         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~
>
> Use the proper 'size_t' format specifier, '%zu', to clear up these
> warnings.
>
> Cc: stable@vger.kernel.org
> Fixes: c1047752ed9f ("cifs: parse_dfs_referrals: prevent oob on malformed=
 input")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Feel free to squash this into the original change to make backporting
> easier. I included the tags in case rebasing was not an option.
> ---
>  fs/smb/client/misc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
> index 987f0ca73123..e10123d8cd7d 100644
> --- a/fs/smb/client/misc.c
> +++ b/fs/smb/client/misc.c
> @@ -918,7 +918,7 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp,=
 u32 rsp_size,
>
>         if (rsp_size < sizeof(*rsp)) {
>                 cifs_dbg(VFS | ONCE,
> -                        "%s: header is malformed (size is %u, must be %l=
u)\n",
> +                        "%s: header is malformed (size is %u, must be %z=
u)\n",
>                          __func__, rsp_size, sizeof(*rsp));
>                 rc =3D -EINVAL;
>                 goto parse_DFS_referrals_exit;
> @@ -935,7 +935,7 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp,=
 u32 rsp_size,
>
>         if (sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3) > rsp_size) =
{
>                 cifs_dbg(VFS | ONCE,
> -                        "%s: malformed buffer (size is %u, must be at le=
ast %lu)\n",
> +                        "%s: malformed buffer (size is %u, must be at le=
ast %zu)\n",
>                          __func__, rsp_size,
>                          sizeof(*rsp) + *num_of_nodes * sizeof(REFERRAL3)=
);
>                 rc =3D -EINVAL;
>
> ---
> base-commit: 4e47319b091f90d5776efe96d6c198c139f34883
> change-id: 20251014-smb-client-fix-wformat-32b-parse_dfs_referrals-189b8c=
6fdf75
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
>


--=20
Thanks,

Steve

--000000000000369f240641232bf3
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-parse_dfs_referrals-prevent-oob-on-malformed-in.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-parse_dfs_referrals-prevent-oob-on-malformed-in.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mgqxvjv90>
X-Attachment-Id: f_mgqxvjv90

RnJvbSA3ZjBmNTRkZmMzMTA2M2E4ZWE4YzBkMTAzNGNjOTBhZTY2MTQwM2ZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFdWdlbmUgS29yZW5ldnNreSA8ZWtvcmVuZXZza3lAYWxpeXVu
LmNvbT4KRGF0ZTogTW9uLCAxMyBPY3QgMjAyNSAyMTozOTozMCArMDMwMApTdWJqZWN0OiBbUEFU
Q0hdIGNpZnM6IHBhcnNlX2Rmc19yZWZlcnJhbHM6IHByZXZlbnQgb29iIG9uIG1hbGZvcm1lZCBp
bnB1dAoKTWFsaWNpb3VzIFNNQiBzZXJ2ZXIgY2FuIHNlbmQgaW52YWxpZCByZXBseSB0byBGU0NU
TF9ERlNfR0VUX1JFRkVSUkFMUwoKLSByZXBseSBzbWFsbGVyIHRoYW4gc2l6ZW9mKHN0cnVjdCBn
ZXRfZGZzX3JlZmVycmFsX3JzcCkKLSByZXBseSB3aXRoIG51bWJlciBvZiByZWZlcnJhbHMgc21h
bGxlciB0aGFuIE51bWJlck9mUmVmZXJyYWxzIGluIHRoZQpoZWFkZXIKClByb2Nlc3Npbmcgb2Yg
c3VjaCByZXBsaWVzIHdpbGwgY2F1c2Ugb29iLgoKUmV0dXJuIC1FSU5WQUwgZXJyb3Igb24gc3Vj
aCByZXBsaWVzIHRvIHByZXZlbnQgb29iLXMuCgpTaWduZWQtb2ZmLWJ5OiBFdWdlbmUgS29yZW5l
dnNreSA8ZWtvcmVuZXZza3lAYWxpeXVuLmNvbT4KQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcK
U3VnZ2VzdGVkLWJ5OiBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0aGFuQGtlcm5lbC5vcmc+CkFja2Vk
LWJ5OiBQYXVsbyBBbGNhbnRhcmEgKFJlZCBIYXQpIDxwY0BtYW5ndWViaXQub3JnPgpTaWduZWQt
b2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvc21i
L2NsaWVudC9taXNjLmMgfCAxNyArKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDE3
IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L21pc2MuYyBiL2ZzL3Nt
Yi9jbGllbnQvbWlzYy5jCmluZGV4IGRkYTZkZWNlODAyYS4uZTEwMTIzZDhjZDdkIDEwMDY0NAot
LS0gYS9mcy9zbWIvY2xpZW50L21pc2MuYworKysgYi9mcy9zbWIvY2xpZW50L21pc2MuYwpAQCAt
OTE2LDYgKzkxNiwxNCBAQCBwYXJzZV9kZnNfcmVmZXJyYWxzKHN0cnVjdCBnZXRfZGZzX3JlZmVy
cmFsX3JzcCAqcnNwLCB1MzIgcnNwX3NpemUsCiAJY2hhciAqZGF0YV9lbmQ7CiAJc3RydWN0IGRm
c19yZWZlcnJhbF9sZXZlbF8zICpyZWY7CiAKKwlpZiAocnNwX3NpemUgPCBzaXplb2YoKnJzcCkp
IHsKKwkJY2lmc19kYmcoVkZTIHwgT05DRSwKKwkJCSAiJXM6IGhlYWRlciBpcyBtYWxmb3JtZWQg
KHNpemUgaXMgJXUsIG11c3QgYmUgJXp1KVxuIiwKKwkJCSBfX2Z1bmNfXywgcnNwX3NpemUsIHNp
emVvZigqcnNwKSk7CisJCXJjID0gLUVJTlZBTDsKKwkJZ290byBwYXJzZV9ERlNfcmVmZXJyYWxz
X2V4aXQ7CisJfQorCiAJKm51bV9vZl9ub2RlcyA9IGxlMTZfdG9fY3B1KHJzcC0+TnVtYmVyT2ZS
ZWZlcnJhbHMpOwogCiAJaWYgKCpudW1fb2Zfbm9kZXMgPCAxKSB7CkBAIC05MjUsNiArOTMzLDE1
IEBAIHBhcnNlX2Rmc19yZWZlcnJhbHMoc3RydWN0IGdldF9kZnNfcmVmZXJyYWxfcnNwICpyc3As
IHUzMiByc3Bfc2l6ZSwKIAkJZ290byBwYXJzZV9ERlNfcmVmZXJyYWxzX2V4aXQ7CiAJfQogCisJ
aWYgKHNpemVvZigqcnNwKSArICpudW1fb2Zfbm9kZXMgKiBzaXplb2YoUkVGRVJSQUwzKSA+IHJz
cF9zaXplKSB7CisJCWNpZnNfZGJnKFZGUyB8IE9OQ0UsCisJCQkgIiVzOiBtYWxmb3JtZWQgYnVm
ZmVyIChzaXplIGlzICV1LCBtdXN0IGJlIGF0IGxlYXN0ICV6dSlcbiIsCisJCQkgX19mdW5jX18s
IHJzcF9zaXplLAorCQkJIHNpemVvZigqcnNwKSArICpudW1fb2Zfbm9kZXMgKiBzaXplb2YoUkVG
RVJSQUwzKSk7CisJCXJjID0gLUVJTlZBTDsKKwkJZ290byBwYXJzZV9ERlNfcmVmZXJyYWxzX2V4
aXQ7CisJfQorCiAJcmVmID0gKHN0cnVjdCBkZnNfcmVmZXJyYWxfbGV2ZWxfMyAqKSAmKHJzcC0+
cmVmZXJyYWxzKTsKIAlpZiAocmVmLT5WZXJzaW9uTnVtYmVyICE9IGNwdV90b19sZTE2KDMpKSB7
CiAJCWNpZnNfZGJnKFZGUywgIlJlZmVycmFscyBvZiBWJWQgdmVyc2lvbiBhcmUgbm90IHN1cHBv
cnRlZCwgc2hvdWxkIGJlIFYzXG4iLAotLSAKMi40OC4xCgo=
--000000000000369f240641232bf3--
