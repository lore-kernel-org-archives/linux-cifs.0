Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0576A338935
	for <linux-cifs@vger.kernel.org>; Mon,  1 Dec 2025 18:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764613018; cv=none; b=j6qH8Geek0tsZ1+dpt4vB+JuVdrq2BobEJxNgJlFQO+GcxFXZpd3S7/ENNucB5IoHkJO2WnnNLKfUFavVvz5XDGj229K2bS3rQKZae6I+/GVFF5yywYcfYSRTisZmUR+tt3/6kKbP9874OomkMhmwEbX8wGnzKlAo8QcN2qXwfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764613018; c=relaxed/simple;
	bh=ppk1uMVa5C3mwrdd8AKTnxZaLsInyOE9IJv+OBp9CEg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZgziBcCgbCuducd/fnPc6HKvOdDLdqxhAtYoqy98E3xIuuAfkAuo2rCOHtb+8nhEFnM1ItBA7PNIzXxyridoAsRH1DnABvNXpExkLbkPXyB3bggP/4z3ZsUbrUDukVdEYX9jgLkHmxlA6U/Bo8oGZnQHu1qHWaiMgfM8bnE1Beo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZhCyHkxL; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZhCyHkxL"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8823d5127daso45778386d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 01 Dec 2025 10:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764613016; x=1765217816; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h+ahSNRHAPTpSStGMQ+T6U8mmc9yGXaa07sdg/NiO2Y=;
        b=ZhCyHkxLjz4+6l1NpWzro0ru4WzbE+gdc37L3YNnOjfYDj/7M9zpVJhCPVgOCC1Akw
         DvLkSQFXg9UG1C72dJ6D5HWngzSdSfUQFrD3o0P8+jSc45Di0Fumw80vNEal78gA+2++
         RQZrpMIvWel52JISpNP50qtuth98DxGdutAurzWc4kGpknCsgstOZNWILA1nNa6bGnVe
         4HX3bnPmdwYu/yjw2XBvNgKX2CUifeiYt1eHrFhNYkEN0atpYc0Kz1v8PIaz7oIZboiU
         V1VVv6MtWrSqBCsq/3cnlZncJz0NDbDUAfTWjxEf8juFL4CtkHw3m5THWP2HtNl564ic
         yEWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764613016; x=1765217816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h+ahSNRHAPTpSStGMQ+T6U8mmc9yGXaa07sdg/NiO2Y=;
        b=Hmy46b7XzcnA/L6H9nweU/qmT1jdgDNvBzWkzX5j5fiNh6bOD5GpKFKSMix1YaLwKx
         IiaSx+COqXkPSTEKHSOorfYCCL7usRwScq/zhC1UIFuID4SE6QhBMHHaC4qJDeiAFb4p
         JENcWOsw/Yzkpqhp5Swu0I0HKvhbewenPyXzZO7AcwnSbawLS8QI1vTx4jrXYMhYDgd3
         pg7dvAI5yEqvHHdU5Vys/7BEU4Nm3tcI+T3GBBCiCgKon0BFD6Wm0v2j5O7OYofo5c11
         uXI5nvFkrKsftruPoKRayrDo9Z57ClAQvXefVRagpKZ+WNyrSfFs+sWFYxqTXH+l22fQ
         CPDg==
X-Forwarded-Encrypted: i=1; AJvYcCVK3dFXqSzM3wt3ePdrx7yBhDp2X7Auer4bUp3hZhJ8jR4piPXlJoLjA+mufKDxd/VGjpIA/HMfiMFg@vger.kernel.org
X-Gm-Message-State: AOJu0YzflUoalTWqBfBenDX7+FEpRf3tAwXhrJt3Yvgg6cCY04zb8TGh
	SlbwiXmXdhM73sVuRzPgGs06tP7Zsv2sdouZLPz6F/XcSuqrPsYxvAmo2EWncgYMVLyhaTr6frK
	XRKTsoKlcx/y4xDfMEg+oAY8NOu3r0wg=
X-Gm-Gg: ASbGncvATPVgPjnLgkK8V0OJgStNwLzyn0b9RMwgkK71wGySqLK6bFyQz1qQxS7WsC8
	BAEgECJbTz57PhmS4ygXqAaAOIqyUubPPPksK8DbTueRICEk8G74XtC+TNaTOs5zc/8Yg+gdNDv
	ndqszgW6q85s0SGds+XoFGEpXf8jiSBbpICGXrqMtUQEHj34DEPRLrR+fck5mu7mz0WoQo1Rgrj
	Zuqh+zUP5zCsc7f2GWZPe5YEVpV628eUwzfabMexwUEie/0g+sxUQ1flKExG4SG0f4Yq3fADQ+Z
	yOz5i3mMf4VWnaIjeNHZ5tyu7UC5ALAToas+yiAqhm+T2Nn3ZedKhslyqp8HFk1hexpj49PSySC
	6Ki/46NWouUkirQjyTqjDOOQgPjrM+itWWgu4N027ED4F6wudqQZbg4mlhvcMTqgg4SvfZrhPeM
	jqwN+rKYPANbv6tnXXbd4=
X-Google-Smtp-Source: AGHT+IFG03chWckzr6y67x90QnGTqSMzQEluv5uCYHggyp/mWqt04gwhoT62JeF58wPH5dyi6hZU8IjEaZtL+ktDuZ0=
X-Received: by 2002:a05:6214:5889:b0:880:6a57:1a48 with SMTP id
 6a1803df08f44-8847c4d5725mr517223716d6.12.1764613015780; Mon, 01 Dec 2025
 10:16:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1430101.1764595523@warthog.procyon.org.uk> <qvtkweac7g5ejiicsnb7cqxlxl35toi2ykdmguaszqkcnir355@zvaw3oxlxzex>
In-Reply-To: <qvtkweac7g5ejiicsnb7cqxlxl35toi2ykdmguaszqkcnir355@zvaw3oxlxzex>
From: Steve French <smfrench@gmail.com>
Date: Mon, 1 Dec 2025 12:16:44 -0600
X-Gm-Features: AWmQ_bnpAyukHfBdaWxuRuWreo2AZSOmO4GxUpTXZ0FYkkhIDzupPaCil5Cr954
Message-ID: <CAH2r5mu13Jva4nP-rdk3QeRe=Y5iE6RcM7txKdRDHJM8a6AoBQ@mail.gmail.com>
Subject: Re: Can we sort out the prototypes within the cifs headers?
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
	Steve French <sfrench@samba.org>, Shyam Prasad N <sprasad@microsoft.com>, 
	Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I don't have much objection about #1 and $2, 3 possibly if not huge,
but higher priority is 4.  Agree that 5 and 6 are lowest priority
unless part of patch that is fixing (or perf improvement etc.)
something

On Mon, Dec 1, 2025 at 11:32=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Hi David,
>
> On 12/01, David Howells wrote:
> >Hi Paulo, Enzo, et al.,
> >
> >You may have seen my patch:
> >
> >       https://lore.kernel.org/linux-cifs/20251124124251.3565566-4-dhowe=
lls@redhat.com/T/#u
> >
> >to sort out the cifs header file prototypes, which are a bit of a mess: =
some
> >seem to have been placed haphazardly in the headers, some have unnamed
> >arguments and also sometimes the names in the .h and the .c don't match.
> >
> >Now Steve specifically namechecked you two as this will affect the backp=
orting
> >of patches.  Whilst this only affects the prototypes in the headers and =
not
> >the implementations in C files, it does cause chunks of the headers to m=
ove
> >around.
> >
> >Can we agree on at least a subset of the cleanups to be made?  In order =
of
> >increasing conflictiveness, I have:
> >
> > (1) Remove 'extern'.  cifs has a mix of externed and non-externed, but =
the
> >     documented approach is to get rid of externs on prototypes.
> >
> > (2) (Re)name the arguments in the prototypes to be the same as in the
> >     implementations.
> >
> > (3) Adjust the layout of each prototype to match the implementation, ju=
st
> >     with a semicolon on the end.  My script partially does this, but mo=
ves
> >     the return type onto the same line as the function name.
> >
> > (4) Move SMB1-specific functions out to smb1proto.h.  Move SMB2/3-speci=
fic
> >     functions out to smb2proto.h.
> >
> > (5) Divide the lists of prototypes (particularly the massive one in
> >     cifsproto.h) up into blocks according to which .c file contains the
> >     implementation and preface each block with a comment that indicates=
 the
> >     name of the relevant .c file.
> >
> >     The comment could then be used as a key for the script to maintain =
the
> >     division in future.
> >
> > (6) Sort each block by position in the .c file to make it easier to mai=
ntain
> >     them.
> >
> >A hybrid approach is also possible, where we run the script to do the ba=
sic
> >sorting and then manually correct the output.
>
> +1 for the cleanups, thanks for doing that.
>
> On backports, I think points 1-3 could be done together, but in separate
> commits (per header file) to minimise conflicts.
>
> 4 looks good to have.
>
> 5-6 would be most problematic (moving code around).
>
> Not sure what else to say here, but more atomic commit are easier to
> backport than big/monolithic ones.
>
>
> Cheers,
>
> Enzo
>


--=20
Thanks,

Steve
