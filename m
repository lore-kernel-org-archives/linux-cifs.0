Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B895B288515
	for <linux-cifs@vger.kernel.org>; Tue, 17 Feb 2026 23:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771369584; cv=pass; b=u75DOc03rlGzRqncXMJt+y2byt8yxgxM6hw1Bg59DEr44jSMjLhvUcbgQyEMph4TIRYgXt4lZ7xq9Y20+jp9mwaGF9yjf2UDdKKOPQZwui/c+gDD+HkN7Sbtk343Q/+vaP2pRQUXMTdFLH464WOS5cA0bekCpW4v53+MLQoRN+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771369584; c=relaxed/simple;
	bh=uTZb17dt9cw8zb/biR3+4XI1aOrTrhhiBMlwlamQO6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XIIWglY/eQY9v7Md3U3sPNcHuyc6Jo0g3D27S1bkkUVjUXHnUqhTp0Xkcq88TigJ8zTOaONHWcy23QlcQiDwbRZsnXRM//W3SPbHXwlfn2uCp/cOrzBBNob/sKT6zzhbdqh67E78+sNjq4O99KB3dw//BUzaa4d6N4nWt1+lq2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=clyV6haT; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="clyV6haT"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-89464760408so30995486d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 17 Feb 2026 15:06:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771369583; cv=none;
        d=google.com; s=arc-20240605;
        b=afKxIRX0hkpLw/jDhAWlYtiiWDQLLzsRkYQGA3oWk/wsG4FNRAKdO6KRdrzIHB8V/r
         AM0GZ6+DKdbUP9jtGj627QkgDRvnPleqGt0/sOhnY+cPBrBSLGWVT23PRSGjykqTpdUu
         QAcbEUmd+NjSgwLBzTFA+8Uh3seUHbIH+llfNIuY5tqyIwpVWC5ag+T0ErEY242AJrM2
         ksHOWBZjzcaBKMxLHlK4a1ll7aUH7f6C6bBkncfTA1+1O9JCcs/Ru7TWEjoKp5idfSoH
         T5D+ugWV8FV5748J+35Le/WKica+oRAvlgzmn3wJeugJPXg4gwYf0exTA1k9wjLkk1ON
         M+uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TjL+u1sCdOP3YhPAEfgmMIqLhjjQgHUqk+pTdwOF/9U=;
        fh=PpyYAz9Cfh9BLERj5zy9O1zgN07tXWw6mT4azTeXLhg=;
        b=FxvEvRON836OTCcyl2JmEqIqyeoE1W1dto+kn77FM0v5DZa/YjCPhgvq3oO2X3hheM
         x5DJjLRwt8rLx0Q12ZxeMaMjI2LCDi1Hmcf5Nm91BPOxk1DtZ2sBs51ii/b7fQT92SM1
         JzGE8tfJe0d30dtVac8yVF8pKmLTzb8RYX9yInW5zRicFHj2XJLWy6Fl2EiYWZPJsvSt
         7uD4FLMtZL8bKMAsmW9I3VwDOQQKM8n5L1hp4VUZTo5WGNO5QerLARX0FKeowxEKZ9PV
         fcglVaTuj7Jkoj+4qwN/vO7tmaJn4k1GnaByE0BbRHaR+9HXbMC9cPyzTvrE+qUrcE3H
         uG0w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771369583; x=1771974383; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TjL+u1sCdOP3YhPAEfgmMIqLhjjQgHUqk+pTdwOF/9U=;
        b=clyV6haTtNv2LSXxUYA8spIdzPk/3xhXMR+JscDGbUyhC7bDmZa6iThF0qf4tA7ZNB
         yKFfkIKT00/xoJs8IDBT5tPlmr8hLPlB2gan/zBC0lr08wEw/CEFqaVTXbAHcTHfq70d
         tibARQ7ON0/poPUQADY51xldnclLxJIkxM5IbnB/QGW4xbFfTJtzBycjH+v7YUbVu9s8
         rrYbaC5ycfDFNVaCSY8ejJlyzxcIfEU4WAtUX+OUdYFiHvToNQZAmvORVheoqxXSBLd1
         AjzUHo0CZbNjsgoDnd3JfZvCmvf7y50M+F3bDMhqacPUuojXDcB7BaObnqdsWnSB6v5D
         0UnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771369583; x=1771974383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TjL+u1sCdOP3YhPAEfgmMIqLhjjQgHUqk+pTdwOF/9U=;
        b=lXbJIuE6aQOiMNZg7rltajcQDQe1Qdn7YtXMNW5VVYoY9FeyPEa4rJ2ft/aaCEWrOe
         3Cl6O4kxlE9MJZHDIFMeSye+5I46Q6uF2MwyOoXYOPufgHpQb3ur2G6ImCYI2bwZ0xTb
         n39ueVl/hQYR3Szf7mIylc3NcLH6o7jqgKnnUnMtmjNltr2d6SWGjnHInltaBYHnSEoB
         XRxjc4OpkzmIr/SUaL9swKLInvgtWVV2zTi6jQcrPtFnNOfKhMf1F9vZd+hAalV7pWKi
         RsDr1r9tYS/9vjHy4hxEwaXRLulbIvT71yB5yEB1BKn9TYkCooINax6lVzi6Yf0bZjy+
         eTDQ==
X-Gm-Message-State: AOJu0YwbtSUWUXT8XUOudchFQqfBFf6aIqMyopKKxu/5aCvKZ/9mqDU+
	xlIhbgh9UERtTVVngEh4ybJMggWn5Q4k5SBH5ZbDETVjFU3G+qK0inv3VLxBJbOheWj8LZ3DJW9
	SjNbefyVTsY694etZVo7Fl8Q+CXOrTgrG2oLd
X-Gm-Gg: AZuq6aKAQ7dvZVX2nZu/nBQkNIN4C0D+/1gIwefC/Vj3tLGX9jw95ULy7yMwIa0jzPG
	5wpBn97IcAbEhjVeIuzlmggsQLhsA6SiuRj69/SXnDtt38ZMpkuAHEvUkKMMoGE4ptmFdr/1vKI
	8nhkn7WTeYC2u1d6fNKREG0AayvRome9qcIjWtcATlxXgU+tmsWezAz+P1Ovre1vKHrShJTEPAF
	PLxuqlvqR6/ZzuqRMRnBPMc6tbU1WimqgHZ4v3qe3+6JjnFBaCv2/9b399Lc7QHnkqirZvBwP9r
	Cqz+w9t2ZRhAEmoYNRiejsfyIBOWdCn8ilTv8ou1pcRQyj2jj+u04habA6NY6krKL3DW/quW+3S
	H8OzrjJI3JCChLL1s6d+ntFvoogU2GIvH1ngl/Rf6BGktMTIqkkiHCOxcPwMKxAe/tXh/UhTUgN
	MSe3AWJ1/qcHueDzyAiy1dXA==
X-Received: by 2002:a05:6214:20a9:b0:897:277:d04b with SMTP id
 6a1803df08f44-89736249dd0mr209928596d6.57.1771369582641; Tue, 17 Feb 2026
 15:06:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aYx6-kjK8mJ6cKSB@4c764e5e3841>
In-Reply-To: <aYx6-kjK8mJ6cKSB@4c764e5e3841>
From: Steve French <smfrench@gmail.com>
Date: Tue, 17 Feb 2026 17:06:11 -0600
X-Gm-Features: AaiRm536Sontdm51bKCfu-AnbdPK3oFGpq6c_POtbshmcD1ox0ZDOFIbZv3-P_g
Message-ID: <CAH2r5mtQr6X0nZvr8GiH6-VxQo9K-nRuejU+S=gjF5R9EGX1xw@mail.gmail.com>
Subject: Re: [BUG] cifs-utils: mount.cifs.c/parse_options: const variable is
 being modified
To: Rudi Heitbaum <rudi@heitbaum.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I don't see this warning on my Ubuntu test system which seems to be
current for glibc

               Ubuntu GLIBC 2.42-0ubuntu3.1) 2.42

Are you using a newer GLIBC?  Do you want to submit a patch to fix
this (does an explicit cast fix it?)?

By the way, I didn't see your original email since gmail routed it to
spam for some reason

On Wed, Feb 11, 2026 at 6:50=E2=80=AFAM Rudi Heitbaum <rudi@heitbaum.com> w=
rote:
>
> In the mount.cifs.c/parse_options function - data is passed in as const
> char*.
>
> strchr returns a warning that the const has been discarded since the
> latest glibc / ISO C22.
>
> code in question is:
>
> https://git.samba.org/?p=3Dcifs-utils.git;a=3Dblob;f=3Dmount.cifs.c;h=3D1=
92391360bcaa29de964b65f77f0bf93dea64be5;hb=3DHEAD#l888
>
> 889: next_keyword =3D strchr(data, ','); - returns a const
> 890: *next_keyword++ =3D 0; - modifies a const
>
> 897: if ((equals =3D strchr(data, '=3D')) !=3D NULL) { - returns a const
> 898: *equals =3D '\0'; - modifies a const
>
> The warnings are:
>
> ../mount.cifs.c: In function 'parse_options':
> ../mount.cifs.c:889:30: warning: assignment discards 'const' qualifier fr=
om pointer target type [-Wdiscarded-qualifiers]
>   889 |                 next_keyword =3D strchr(data, ',');       /* BB h=
andle sep=3D */
>       |                              ^
> ../mount.cifs.c:897:29: warning: assignment discards 'const' qualifier fr=
om pointer target type [-Wdiscarded-qualifiers]
>   897 |                 if ((equals =3D strchr(data, '=3D')) !=3D NULL) {
>       |                             ^
>
> Regards
> Rudi
>


--=20
Thanks,

Steve
