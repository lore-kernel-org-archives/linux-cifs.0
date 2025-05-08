Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EF226D4EE
	for <linux-cifs@vger.kernel.org>; Thu,  8 May 2025 15:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746717889; cv=none; b=fOMYf0H8dBYxhK/XU95aJ2k3VIxPe0UiNoy1jUX+mJft0Jx+/g8tbdTP2wNSvt+mjDyp7LCfebwqAXnB7BXpSjmej6mBvCF2W8XpcIj9gYWo3U3QyoEQv0woMm5WH+dz9aiuGinW6zIPRIQe+lHr17mKwDA7cGPbDPQCaP9ev4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746717889; c=relaxed/simple;
	bh=163m5tNF6eGkddGv+1VrVyaNymXKl4bnqQpiVKPcNFg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=L6uJzbbAT1Fm+izNXl5OSOBnuzeMunIjYP0v3lyNoLMkpEbyTXlu4OSxT/6eDkL3a2m80hInRAGXv6Sjtbc669pMhpqQNjW+HT/4tcw0xzyVqHET/bw8wwbMS9AtQ9c15NnvuHWboj9mrbPaK5rZDXD+BrEvmxvqDA6ZkxYg//0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VA+JS69/; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VA+JS69/"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e5e22e6ed2so1750625a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 08 May 2025 08:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746717886; x=1747322686; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OWo2tTuVLb3xyulnw9ET1EeYifED6n9Je3QmfzOGh2w=;
        b=VA+JS69/lSg8FQ7sV3dkaWrHu1IW7o6Gtsd8HqfRjDVdbDCBeiyVYegW12QxxUu9Wi
         z0zXwQgbqas02RinO3mg0Hg+zpStVaNnknY0jbzuLG9GwwLQkc+XMc397cQxCnCWq+En
         IShJij+uLDiP5o3aydgATPqFY0zDA6cAXw6r03TY2ASLnuBZPBGLVP+VDJspLPTdXdd1
         LCxSXSDyGA5XjzB0FdL48Y8DkxEIjIFuyocS8bPve6ieTRz5SSl1ZdsFZZ+N0CNfvMms
         +BIxOgsn1WmN54tHgO9cz00HH2/8kRJcqBkuKOtbHfzzQcQorSjM2zBJSX5gO3cQs6Kf
         3ugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746717886; x=1747322686;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OWo2tTuVLb3xyulnw9ET1EeYifED6n9Je3QmfzOGh2w=;
        b=SwayMLt0Yt0md7X+DWg9/hma5cvgIoBIHIivpTGwgHLTlGzI8Hof6gpXKY/fc8+xAo
         1RLZyQm0JBbjU+TeByQhxsLsDdR76/IgeoTt06wyUOiV2xacVu7r2PERzhVf/VT0LnO8
         aQJ0ccm3yr4VTQffavQ3pFLmV2mBU/feOKbiFBFKjtGcctMRTZjq4rG3IexPDDkZO+OC
         QQA0YmyTgiYLhFsGlSbvdZ89zERB/3grcJ/izNayj3VllpWRHDIvqEy4zfz1Wu+EaWg1
         xHJ0DI2YC1vHVocx7yRjZn76eBcczC68SO1SwNNbOyknWCgEDm2LmKl2Ny0bzDkuG1PE
         ryGg==
X-Forwarded-Encrypted: i=1; AJvYcCW3a3Z1zjDYbwSVsaf6lk+jdsPSLDH95XLX/+Y+etMpz6BD+ajhEYSShPf5FzKABFpSPXptm0XIcmn8@vger.kernel.org
X-Gm-Message-State: AOJu0Yys3zzetBHV0K22Z0M9Otc4rCDCB8J56ij01mXUr4N0LtIO/Nmx
	4JxIjL1EiA4pqg0T6aGP3K3mKw7bBks0DOM1b+KRu04btF6a2xmGDzF8qJUEiMNoYMUtcHVC5RF
	QV/0D2KJvM04FHkgI0GiKQqrAVsI=
X-Gm-Gg: ASbGncuoxEsvIeHmucmUNxYp07/RMu9MRrdpOJdBI04Ey42bbrWroylWFoLKsKPivkw
	uBMXBwIjO5wWSCbZbVQR3ZFSaHbE66VEqEPceh1VG7C3d2PlUd3dEAIqT48p+9t8TWGFeUzdxjo
	vF7DVVky4zsqj1Mh0pqeL432qk
X-Google-Smtp-Source: AGHT+IHrd9/s4vgfgglv+xNDjixdm3a9IOh+wkiL8QK2pG+BBmRKvN/zL17474JdNnzuImCwjg4zyYa8S8YXmLud6H0=
X-Received: by 2002:a05:6402:27d3:b0:5e6:616f:42e4 with SMTP id
 4fb4d7f45d1cf-5fc35808499mr4151941a12.27.1746717885440; Thu, 08 May 2025
 08:24:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250506223156.121141-1-henrique.carvalho@suse.com> <aBr6zohhW9Akuu3a@redcloak.home.arpa>
In-Reply-To: <aBr6zohhW9Akuu3a@redcloak.home.arpa>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 8 May 2025 20:54:34 +0530
X-Gm-Features: ATxdqUFZPdC7ht5RaYTXQ3huwKcfTLcmP_DEu7zd1xoXMkcisdUjR74gF2FQdTQ
Message-ID: <CANT5p=pHLh-8fDbJ2OCdNa_eHR5T=BVJAOSYy4zs_Lk6FzR9=A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: avoid dentry leak by not overwriting cfid->dentry
To: Henrique Carvalho <henrique.carvalho@suse.com>, ematsumiya@suse.de, sfrench@samba.org, 
	smfrench@gmail.com, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 7, 2025 at 11:56=E2=80=AFAM Paul Aurich <paul@darkrain42.org> w=
rote:
>
> On 2025-05-06 19:31:56 -0300, Henrique Carvalho wrote:
> >A race, likely between lease break and open, can cause cfid->dentry to
> >be valid when open_cached_dir() tries to set it again. This overwrites
> >the old dentry without dput(), leaking it.
> >
> >Skip assignment if cfid->dentry is already set.
> >
> >Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> >---
> > fs/smb/client/cached_dir.c | 23 +++++++++++++++--------
> > 1 file changed, 15 insertions(+), 8 deletions(-)
> >
> >diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> >index 43228ec2424d..8c1f00a3fc29 100644
> >--- a/fs/smb/client/cached_dir.c
> >+++ b/fs/smb/client/cached_dir.c
> >@@ -219,16 +219,23 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >               goto out;
> >       }
> >
> >-      if (!npath[0]) {
> >-              dentry =3D dget(cifs_sb->root);
> >-      } else {
> >-              dentry =3D path_to_dentry(cifs_sb, npath);
> >-              if (IS_ERR(dentry)) {
> >-                      rc =3D -ENOENT;
> >-                      goto out;
> >+      /*
> >+       * BB: cfid->dentry should be NULL here; if not, we're likely rac=
ing with
> >+       * a lease break. This is a temporary workaround to avoid overwri=
ting
> >+       * a valid dentry. Needs proper fix.
> >+       */
>
> Ah ha. I think this is trying to address the same race as Shyam's 'cifs: =
do
> not return an invalidated cfid' [1].


Hi Paul,
Yes. One of my patch did this check to avoid leaking dentry.
However, without serializing threads in this codepath, it is not
possible to rule out all such races.

>
> What about modifying open_cached_dir to hold cfid_list_lock across the ca=
ll to
> find_or_create_cached_dir through where it tests for validity, and then
> dropping the locking in find_or_create_cached_dir itself (see attached in=
 case
> my text description isn't clear)?

We can do that. But holding a spinlock till the response comes back
from the server is not a good idea.
We could see high CPU utilization if response from the server takes longer.
My other patch introduced a mutex just for this purpose.

>
> That's the only way I can see that a pre-existing cfid could escape to th=
e
> rest of open_cached_dir. I think.
>
> ~Paul
>
> [1] https://lore.kernel.org/linux-cifs/20250502051517.10449-2-sprasad@mic=
rosoft.com/T/#u
>
> >+      if (!cfid->dentry) {
> >+              if (!npath[0]) {
> >+                      dentry =3D dget(cifs_sb->root);
> >+              } else {
> >+                      dentry =3D path_to_dentry(cifs_sb, npath);
> >+                      if (IS_ERR(dentry)) {
> >+                              rc =3D -ENOENT;
> >+                              goto out;
> >+                      }
> >               }
> >+              cfid->dentry =3D dentry;
> >       }
> >-      cfid->dentry =3D dentry;
> >       cfid->tcon =3D tcon;
> >
> >       /*
> >--
> >2.47.0

--=20
Regards,
Shyam
