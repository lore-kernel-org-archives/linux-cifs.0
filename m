Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92A92D12F3
	for <linux-cifs@vger.kernel.org>; Sat, 12 Sep 2026 01:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789175052; cv=none; b=NPgc0gbimZnPh0Qs3FMXxwJhKfb+1yjq3L01ISeQ0EE4XEqKVWDMDDF4AoyY7U8+iH+uH02MLMPy+91T0zMYvVRdtU5L+r5TumYsSPs70lKI8amdFIF+fV2iAPQmg78tiIlZicyrFvO0D3pp0UncqaGa126CEiuyg+eyT+SnGRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789175052; c=relaxed/simple;
	bh=vr07uqXgctEEZp90BcXpMmzEhnOInn+XstA72l+qsNc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oyb4F21MU4Q4k85YNGsZ/x0+xltJe81SRRnuCYPcAUoeR/c+z7Ulfz/kpf+OytjKt3a2Pr1krPgiEa6K7bhII5rVU0vo+jy9bAin4VW0fh9JWRv1f6xpl8II8yQDiGpMmQJ8KDOzm6HTepw0rSeVzGT459gtctm2NQtpgVjs9mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dE6toIvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dE6toIvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D711F0089A
	for <linux-cifs@vger.kernel.org>; Sat, 12 Sep 2026 01:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789175050;
	bh=rKirC/zfbMh4nONwqtdSsb87sR4Y6BWN44jahYCmhvk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dE6toIvI5cEjTsb4F+6GCbpP1AeOHyS3GRyqYpYlXfJdhzkKml6R5Mpd+9NMJzc6t
	 kDZe3Y8QqlubPYxlwGSbe96fMkHxgGD1tl0cZpknsw6Y2DgNaBBECUWaY325ul17H3
	 M9AXWn/qhIsDtWr+JGFVreBO9Uer4FjN+9AuiRTSTeTksr1KXLUerMekXb7+2xmbsj
	 PzfBFeTjDbidL+k2jpxkh+GGCy/DUtSG4mRJlOow4hSJN/yPsZN98eC1dAwv/G8+kL
	 IH++R16WQTDp7vS7XqySkfoYnzMj1NTOuW577YAdwDNMpdxJEN/7l1ZiNsTqoaQDX2
	 BfobfBx5tNeOg==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f8694aeso39066166b.0
        for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 18:04:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByQ+d+AGr1/FfTqehfLQMNItuQklFG6Nk/yVwzHLItns7tf5PCUYn6lGDIkgJPBh2eufC1jvB8+MA/f@vger.kernel.org
X-Gm-Message-State: AFuF++nw4t/ZcHnZtEKhIH42i6TMGFiqONTu3EggL8PbIYQ730PnvhV/
	oJzRAHxd1EXY+XXTNyNqxi3TSyfBnIGCVSYs4z0u4lEdOmo9zB2C9CAUztJafLCO19KZlMGLeQl
	Ztq9gsKZlC2pKL0QMQASt5+z+v68uQhY=
X-Received: by 2002:a17:907:3cc1:b0:c25:f7db:4bea with SMTP id
 a640c23a62f3a-c2962c35e44mr349285966b.16.1789175049172; Fri, 11 Sep 2026
 18:04:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260911163516.6403-1-15815827059@163.com>
In-Reply-To: <20260911163516.6403-1-15815827059@163.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 12 Sep 2026 10:03:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_5E9=EBuT_dHv6gvExmQfrmjVodM-WxHtLFcaL-1-knw@mail.gmail.com>
X-Gm-Features: AcwNN1Wg8-CzhIT54vNLKpllkooDbShxMBxlbb63TNsw-OGnPrX6Qh0DJo0LiMU
Message-ID: <CAKYAXd_5E9=EBuT_dHv6gvExmQfrmjVodM-WxHtLFcaL-1-knw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] smbd: fix FSCTL_QUERY_NETWORK_INTERFACE_INFO handling
To: huhai <15815827059@163.com>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, huhai <huhai@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 1:36=E2=80=AFAM huhai <15815827059@163.com> wrote:
>
> From: huhai <huhai@kylinos.cn>
>
> This series fixes several issues in fsctl_query_iface_info_ioctl():
> incorrect link speeds, an unlocked IPv6 address-list walk, an invalid
> final Next offset, and incorrect IPv4/IPv6 interface reporting.
>
> Patch 1 was previously submitted as a standalone patch; this series
> supersedes that submission.
>
> ---
> v1: https://lore.kernel.org/all/20260910090818.24479-1-15815827059@163.co=
m/
>
> Henry Hu (4):
>   ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()
>   ksmbd: fix unlocked IPv6 addr_list walk in
>     fsctl_query_iface_info_ioctl()
>   ksmbd: fix invalid Next offset in interface info replies
>   ksmbd: report IPv4 and IPv6 addresses independently in iface query
Applied it to #ksmbd-for-next.
Thanks!
