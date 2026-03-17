Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32A339281D
	for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 21:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773782838; cv=pass; b=rb3r8LHEu3RvATcbxL56PgrzP3HiycB+A3cDbUWzD5u0bzeg3rnlPecw2NRq/Ge4n2QQt/XZJMVxJKagmq4JU8Ll8a5zOYIBzeAduyZ1ghFTApcAp0jUKXitix9uAwBeHN5/G2EKPF8gun2TA4HpENKkNW8tkCdjcCB9DaXeX6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773782838; c=relaxed/simple;
	bh=wGd+thudyV9Nv0l5oAVAN331H+viWPRkQfv3V3ltlVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c5S2NHhYzfPzT27VPfEDQP99edjLp+h7vRMcH4ILASYIOVyyaW5O5XRL5EmzzpOQ6QlLpcrnrVxppIgi+LLufoMUZ+OOWgtvfv/ZLgypj+jS7eCk6vOg2TjgcbkEuASEy9nVHVgB2zBjEohfNGJ8+5xSnCAt2YX5MzTxf3XzEX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tlswbjuq; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tlswbjuq"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-89c52ef3c2fso23024296d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 14:27:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773782832; cv=none;
        d=google.com; s=arc-20240605;
        b=TJYSMc7eqbjRw2CVVmc1i4LjSEpiqTKsubkCTq8+empt4oyqS3UBSkKWLl74oyaHw3
         HG47ByMpdYpGMghwi2ej3A0Vn/jpCrm/9pZJboRTQWRV0x9dabik+ua51D5g4n3tTc5b
         /XMSIQuiENLmRw21848kvbentCq3EkCM1Mtutu0fqKZ+2vpGX5yfcTq7Fti3OVM3HHP9
         4639+etfa7t7awaYC3cBwlUCbzTVTFyLu1XmXNCs0GxVBcHVxV82xWuiIXuF1KMCcXxE
         IPI0h35LxZsuAm2oqp4g8DXLSaTcbNYOo+7U91lbAtkKZOm+nM5i6Y6JH6hOnLwq3Ogy
         o2Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WJn2bqD1oL1nPEOJJHpHZSbhMDi7B8umwU+fF6DGIU4=;
        fh=7EAONKmbCty2WHaCcuBVJ3OtsYNvvqm21D/ins9fJGg=;
        b=C/dpu73iajm4wxRF1qXBXW3mY+6IqcNz0VgtNfS+e5oY9khUSp1B+br+zlbEq1+z40
         WdAJVG5CEJbM6V1/nywEkaR5BL9VfcHglEsHDtwwoirHHkiis8notnswOrRCrIYJGKof
         He/zhn+1fR2q+dLgvFG4rgHpz8vVPm1ZkEtancLs6xGRlRIewRliaYmKqoI6rluOyfjd
         rrMar/5FfFg5oEWgeLdxNcnUig4AVTm7ig7sBtvg1jouojTrG7JmA3cpJIDTm3BXoAmq
         AuPNYSWceb59l/b/geIIAtMY9ynGvZIVcRinzc40LPR95kGgVgFqHqNq2f72R8jy90Hf
         Nf4A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773782832; x=1774387632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJn2bqD1oL1nPEOJJHpHZSbhMDi7B8umwU+fF6DGIU4=;
        b=TlswbjuqlWcgMinNXf6X34agjZPdaPTsvDlhYTuE57y7F6BhRxhOdipFC09j9JfOQ7
         eLCvVFNSP27/g8QYHDKu14HCOk5B6KzeVrfJ+00hpTIJAZGK0nQzUbQaZxt0eoYDa8vM
         7inJMSvB1xWOh1jCeHCcwO/1qg2mXEJonUnX+TvLE8HjccgHLuazsH/GeCAUVzK15aYO
         km+jGZolDoe9t3uUKirvMuCHXjBrNM7rogBy1kka6xdKbCzgVnSKnnAxgEKh049rS7Qq
         lYExJUYaWy1D22wo/FD0+YuxY6B+4889qhXTLkw3cGKqJ+nqguOQwdQVmx+KUuaF8QXu
         s64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773782832; x=1774387632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJn2bqD1oL1nPEOJJHpHZSbhMDi7B8umwU+fF6DGIU4=;
        b=tWcwmZpg4AGbJ1pNLvGgF/TYfogwUA5No41yH2QShTnixMOMxZTqA+PpbeZkkMO86s
         dLFB6OBXcfIRYwxMWW58QlQtUTGgSLEbFYRSPmS/z5XBBSEgcYWnC2EGHSYXy7xhdH6s
         zW4HgnnU0IVHAqKL/R8KdwqUjNacaD0ZWgnspQ2kYFZR5WQuqSOD2fztcN2ySNGKp87g
         QqSmA3YogGhj3lWRVyU9N7zyc4S9BVfZZGREBR0y+SO4AZofYHxZZ/oQoR4zdyl+2UVg
         DCaXyptg5KjIgKS3PQIli/yuVOaA9HobIZBKbXL2kqZCDqah6FW6GYJvvDFk8TC+k/zp
         5XdQ==
X-Forwarded-Encrypted: i=1; AJvYcCU06TByVueVl2uLY+FtNAWjKObfFXKgg0x3upyer2U7vycebRbba8VMzUJp4A8sjKB445gah+Ovtwz1@vger.kernel.org
X-Gm-Message-State: AOJu0YwZULio7P8mEqo4ZTs9t3Y2kP2iKuwvDt/tiv8wprLiUe2xvd+j
	lUwgygrEDkI6g/oRRL0N+SFL1XoYhOXU1nSuNbVVIQG3u7vulTrAxa9tUoaXbrNRt/HeDhJJylc
	7P9ws6KtWbkxPnYaXZPD5qO3gKRwheVY=
X-Gm-Gg: ATEYQzwvfqt9MmV+52k803lmlWoiq2oNZ9dyQfFgJftwhIkGj5S7mFLBBwSJoiwuX37
	dEz2TXc/Z47+tGH8V007D7D/j6d8uUL2D2zDEYlN4mpx8fw2bwPRJMj+b821cAPXAvJp7/sJKXF
	A2v++uvjwkyHcNnBQSiuutRAHkziLgspdh4Cc+tGScS6DiYcIv/UhwQs8HB/28DIePnk6zrpktt
	CpRQJ9fHl3+zXN1/vk6Z6k/d85cbDO113VqoG/TYaDdGmnKYGa3tKE5VjajRjfZJIf+jCIYRIOp
	+s0BeSDlVkJwoBchgbFYw5hyaoyvhFCnWpWPke5JNHEFuiWLXab/Zq7t2yTYxeVbEWWE8nq0Pw3
	e9514TUWhlV4R+0RPlICQiFXHqG2Tl4bDem+49PvZC4QilUx5IVMsiKKQxKhvNQ==
X-Received: by 2002:a05:6214:590e:b0:899:f9f5:97a9 with SMTP id
 6a1803df08f44-89c6b58deb7mr18079006d6.37.1773782832437; Tue, 17 Mar 2026
 14:27:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260317065253.1743552-1-werner@verivus.com> <435dda9f-93f5-41db-9d21-70371d31857b@chenxiaosong.com>
In-Reply-To: <435dda9f-93f5-41db-9d21-70371d31857b@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 17 Mar 2026 16:27:00 -0500
X-Gm-Features: AaiRm505a8UyoMHPlnBXec4AZ4qil-1PSoZze-n4iJ1WCJq2H-I9vKg9CjSnNpE
Message-ID: <CAH2r5mvRpUJpXSgeQdQ_ssjz=skeFAFPKQ3u1YZ9Z1jtsjf87A@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: fix use-after-free and NULL deref in smb_grant_oplock()
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Werner Kasselman <werner@verivus.ai>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	"linkinjeon@kernel.org" <linkinjeon@kernel.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I see some AI review comments from Sashiko:
https://sashiko.dev/#/patchset/20260317065253.1743552-1-werner%40verivus.co=
m

On Tue, Mar 17, 2026 at 3:17=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Looks good to me so far. Others can continue the review.
>
> Thanks,
> ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> On 3/17/26 14:52, Werner Kasselman wrote:
> > smb_grant_oplock() has two issues in the oplock publication sequence:
> >
> > 1) opinfo is linked into ci->m_op_list (via opinfo_add) before
> >     add_lease_global_list() is called.  If add_lease_global_list()
> >     fails (kmalloc returns NULL), the error path frees the opinfo
> >     via __free_opinfo() while it is still linked in ci->m_op_list.
> >     Concurrent m_op_list readers (opinfo_get_list, or direct iteration
> >     in smb_break_all_levII_oplock) dereference the freed node.
> >
> > 2) opinfo->o_fp is assigned after add_lease_global_list() publishes
> >     the opinfo on the global lease list.  A concurrent
> >     find_same_lease_key() can walk the lease list and dereference
> >     opinfo->o_fp->f_ci while o_fp is still NULL.
> >
> > Fix by restructuring the publication sequence to eliminate post-publish
> > failure:
> >
> > - Set opinfo->o_fp before any list publication (fixes NULL deref).
> > - Preallocate lease_table via alloc_lease_table() before opinfo_add()
> >    so add_lease_global_list() becomes infallible after publication.
> > - Keep the original m_op_list publication order (opinfo_add before
> >    lease list) so concurrent opens via same_client_has_lease() and
> >    opinfo_get_list() still see the in-flight grant.
> > - Use opinfo_put() instead of __free_opinfo() on err_out so that
> >    the RCU-deferred free path is used.
> >
> > This also requires splitting add_lease_global_list() to take a
> > preallocated lease_table and changing its return type from int to void,
> > since it can no longer fail.
> >
> > Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> > Fixes: 1dfd062caa16 ("ksmbd: fix use-after-free by using call_rcu() for=
 oplock_info")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Werner Kasselman <werner@verivus.com>



--=20
Thanks,

Steve
